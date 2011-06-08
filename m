Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab1FHCKj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 22:10:39 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p582AdG2005322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 22:10:39 -0400
Received: from [10.3.236.210] (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p582AcaI013094
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 22:10:39 -0400
Message-ID: <4DEEDA1E.3000404@redhat.com>
Date: Tue, 07 Jun 2011 23:10:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 16/15] [media] DocBook/dvbproperty.xml: Better name the ISDB-T
 layers
References: <20110607224542.597d46bc@pedra>
In-Reply-To: <20110607224542.597d46bc@pedra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In order to improve the DVB index, replace the title to a
better name.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index a9863a3..caec58c 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -449,13 +449,14 @@ typedef enum fe_delivery_system {
 		<para>Note: This value cannot be determined by an automatic channel search.</para>
 	</section>
 	<section id="isdb-hierq-layers">
-		<title>Hierarchical layers</title>
+		<title><constant>DTV-ISDBT-LAYER*</constant> parameters</title>
 		<para>ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
 			ISDB-T hierarchical layers can be decoded simultaneously. For that
 			reason a ISDB-T demodulator has 3 viterbi and 3 reed-solomon-decoders.</para>
 		<para>ISDB-T has 3 hierarchical layers which each can use a part of the
 			available segments. The total number of segments over all layers has
 			to 13 in ISDB-T.</para>
+		<para>There are 3 parameter sets, for Layers A, B and C.</para>
 		<section id="DTV-ISDBT-LAYER-ENABLED">
 			<title><constant>DTV_ISDBT_LAYER_ENABLED</constant></title>
 			<para>Hierarchical reception in ISDB-T is achieved by enabling or disabling
