import ballerina/http;
import ballerina/io;

public function main() {
    // Define the GraphQL endpoint URL.
    string endpointUrl = "https://graphql-server-endpoint";

    // Define the GraphQL query to perform various operations.
    string hodQuery = string `
        mutation {
            createDepartmentObjective(input: { description: "New Objective" }) {
                id
                description
            }
            deleteDepartmentObjective(objectiveId: "123") {
                success
            }
            viewEmployeesTotalScores(departmentId: "456") {
                employeeId
                totalScore
            }
            assignEmployeeToSupervisor(employeeId: "789", supervisorId: "987") {
                success
            }
        }
    `;

    string supervisorQuery = string `
        mutation {
            approveEmployeeKPIs(employeeId: "123") {
                success
            }
            deleteEmployeeKPIs(kpiId: "456") {
                success
            }
            updateEmployeeKPIs(kpiId: "789", score: 4.5) {
                id
                description
                score
            }
            viewEmployeeScores(employeeId: "987") {
                employeeId
                totalScore
            }
            gradeEmployeeKPI(kpiId: "654", score: 4.2) {
                id
                description
                score
            }
        }
    `;

    string employeeQuery = string `
        mutation {
            createKPI(input: { description: "New KPI", score: 3.0, employeeId: "YOUR_EMPLOYEE_ID" }) {
                id
                description
                score
            }
            gradeSupervisor(supervisorId: "123", score: 4.8) {
                id
                name
            }
            viewOwnScores {
                employeeId
                totalScore
            }
        }
    `;

    // Define the headers for authentication and other necessary information.
    map<http:HeaderValue> headers = {
        "Authorization": "Bearer YOUR_ACCESS_TOKEN"
    };

    // Execute the GraphQL queries using the client.
    executeGraphQLQuery(endpointUrl, hodQuery, headers, "HoD");
    executeGraphQLQuery(endpointUrl, supervisorQuery, headers, "Supervisor");
    executeGraphQLQuery(endpointUrl, employeeQuery, headers, "Employee");
}

function executeGraphQLQuery(string endpointUrl, string query, map<http:HeaderValue> headers, string userRole) {
    http:Response|error response = check post(endpointUrl, query, headers);

    // Handle the HTTP response.
    if (response is http:Response) {
        // Check for HTTP status codes and process the response body.
        match response.status {
            http:OK => {
                io:println(userRole + " GraphQL response data: " + response.getStringPayload());
            }
            http:Unauthorized => {
                io:println(userRole + " Unauthorized. Please check your credentials.");
            }
            // Add more status code checks as needed.
            _ => {
                io:println(userRole + " Unexpected status code: " + response.status.toString());
            }
        }
    } else {
        io:println(userRole + " Failed to execute the GraphQL request.");
    }
}
