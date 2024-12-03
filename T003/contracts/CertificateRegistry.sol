pragma solidity ^0.8.0;

contract CertificateRegistry {
    struct Certificate {
        string studentName;
        string course;
        string issueDate;
        bool isValid; 
    }

    mapping(uint256 => Certificate) private certificates;

    address public institution;

    constructor() {
        institution = msg.sender;
    }

    modifier onlyInstitution() {
        require(msg.sender == institution, "Acesso restrito a instituicao.");
        _;
    }

    function registerCertificate(
        uint256 certId,
        string memory studentName,
        string memory course,
        string memory issueDate
    ) public onlyInstitution {
        require(certificates[certId].isValid == false, "Certificado ja registrado.");

        certificates[certId] = Certificate({
            studentName: studentName,
            course: course,
            issueDate: issueDate,
            isValid: true
        });
    }

    function getCertificate(uint256 certId)
        public
        view
        returns (
            string memory studentName,
            string memory course,
            string memory issueDate,
            bool isValid
        )
    {
        require(certificates[certId].isValid || !certificates[certId].isValid, "Certificado nao encontrado.");

        Certificate memory cert = certificates[certId];
        return (cert.studentName, cert.course, cert.issueDate, cert.isValid);
    }

    function revokeCertificate(uint256 certId) public onlyInstitution {
        require(certificates[certId].isValid, "Certificado nao valido ou nao encontrado.");

        certificates[certId].isValid = false;
    }
}
