<%--
  Created by IntelliJ IDEA.
  User: jorge.carrillo
  Date: 2/24/2020
  Time: 11:31 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Affichage d'une commande</title>
    <link type="text/css" rel="stylesheet" href="<c:url value="/inc/style.css"/>" />
</head>
<body>
<c:import url="/inc/menu.jsp" />
<div id="corps">
    <p class="info">${ requestScope.form.resultat }</p>
    <p>Client</p>
    <p>Nom : <c:out value="${ requestScope.commande.client.nom }"/></p>
    <p>Prénom : <c:out value="${ requestScope.commande.client.prenom }"/></p>
    <p>Adresse : <c:out value="${ requestScope.commande.client.adresse }"/></p>
    <p>Numéro de téléphone : <c:out value="${ requestScope.commande.client.telephone }"/></p>
    <p>Email : <c:out value="${ requestScope.commande.client.email }"/></p>
    <p>Image : <c:out value="${ requestScope.commande.client.image }"/></p>
    <p>Commande</p>
    <p>Date  : <c:out value="${ requestScope.commande.date }"/></p>
    <p>Montant  : <c:out value="${ requestScope.commande.montant }"/></p>
    <p>Mode de paiement  : <c:out value="${ requestScope.commande.modePaiement }"/></p>
    <p>Statut du paiement  : <c:out value="${ requestScope.commande.statutPaiement }"/></p>
    <p>Mode de livraison  : <c:out value="${ requestScope.commande.modeLivraison }"/></p>
    <p>Statut de la livraison  : <c:out value="${ requestScope.commande.statutLivraison }"/></p>
</div>
</body>
</html>
