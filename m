Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:64244 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZCNR41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 13:56:27 -0400
Received: by ewy25 with SMTP id 25so2952491ewy.37
        for <linux-media@vger.kernel.org>; Sat, 14 Mar 2009 10:56:24 -0700 (PDT)
Message-ID: <49BBEFC3.5070901@gmail.com>
Date: Sat, 14 Mar 2009 18:56:19 +0100
From: Benjamin Zores <benjamin.zores@gmail.com>
Reply-To: benjamin.zores@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] add new frequency table for Strasbourg, France
Content-Type: multipart/mixed;
 boundary="------------070903080903070004000005"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070903080903070004000005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Attached patch updates the current dvb-t/fr-Strasbourg file with
relevant transponders frequency values.

Please commit,

Ben

--------------070903080903070004000005
Content-Type: text/x-diff;
 name="dvb-t_fr-Strasbourg.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="dvb-t_fr-Strasbourg.diff"

# HG changeset patch
# User Benjamin Zores <ben@geexbox.org>
# Date 1237053058 -3600
# Node ID 492ed381071e5aeffbbde990a069f3beb46e5dc7
# Parent  fe5a6f79468e5317e394f78ccf98dbe63a83e004
new frequency table for Strasbourg, France

diff -r fe5a6f79468e -r 492ed381071e util/scan/dvb-t/fr-Strasbourg
--- a/util/scan/dvb-t/fr-Strasbourg	Fri Mar 13 14:35:20 2009 +0100
+++ b/util/scan/dvb-t/fr-Strasbourg	Sat Mar 14 18:50:58 2009 +0100
@@ -1,30 +1,17 @@
-# Strasbourg - France (DVB-T transmitter of Strasbourg ( Nondéfini ) )
-# Strasbourg - France (signal DVB-T transmis depuis l'émetteur de Nondéfini )
+# Strasbourg - France (DVB-T transmitter of Strasbourg (Nordheim))
+# contributed by Benjamin Zores <ben@geexbox.org>
 #
-# ATTENTION ! Ce fichier a ete construit automatiquement a partir
-# des frequences obtenues sur : http://www.tvnt.net/multiplex_frequences.htm
-# en Avril 2006. Si vous constatez des problemes et voulez apporter des
-# modifications au fichier, envoyez le fichier modifie a
-# l'adresse linux-dvb@linuxtv.org (depot des fichiers d'init dvb)
-# ou a l'auteur du fichier :
-# Nicolas Estre <n_estre@yahoo.fr>
+# Strasbourg - Nordheim: 22 47 48 51 61 69
+# See http://www.tvnt.net/V2/pages/342/medias/pro-bo-doc-tk-frequences_tnt.pdf
 #
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-#### Strasbourg - Nondéfini ####
-#R1
-#T FREQ1 8MHz AUTO NONE QAM64 8k AUTO NONE
-#R2
-#T FREQ2 8MHz AUTO NONE QAM64 8k AUTO NONE
-#R3
-#T FREQ3 8MHz AUTO NONE QAM64 8k AUTO NONE
-#R4
-#T FREQ4 8MHz AUTO NONE QAM64 8k AUTO NONE
-#R5
-#T FREQ5 8MHz AUTO NONE QAM64 8k AUTO NONE
-#R6
-#T FREQ6 8MHz AUTO NONE QAM64 8k AUTO NONE
-##############################################################
-# en Avril 2006, l'emetteur pour Strasbourg n'etait pas defini
-#  Vous devez donc modifier les frequences manuellement.
-# SVP Renvoyez le fichier mis a jour aux contacts ci-dessus.
-##############################################################
+T 482167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 570167000 8MHz 2/3 NONE QAM16 8k 1/32 NONE
+T 618167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 682167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 690167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 698167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 714167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 722167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 786167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 794167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

--------------070903080903070004000005--
