Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab1FHBqB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:01 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581k17P028970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:01 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jnc9007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:00 -0400
Date: Tue, 7 Jun 2011 22:45:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/15] [media] DocBook/dvbproperty.xml: Use links for all
 parameters
Message-ID: <20110607224535.0a82e96e@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead of adding a program listing, just add there all parameters.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 67a2deb..01f3933 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -150,51 +150,51 @@ get/set up to 64 properties. The actual meaning of each property is described on
 </para>
 
 <para>The available frontend property types are:</para>
-<programlisting>
-#define DTV_UNDEFINED		0
-#define DTV_TUNE		1
-#define DTV_CLEAR		2
-#define DTV_FREQUENCY		3
-#define DTV_MODULATION		4
-#define DTV_BANDWIDTH_HZ	5
-#define DTV_INVERSION		6
-#define DTV_DISEQC_MASTER	7
-#define DTV_SYMBOL_RATE		8
-#define DTV_INNER_FEC		9
-#define DTV_VOLTAGE		10
-#define DTV_TONE		11
-#define DTV_PILOT		12
-#define DTV_ROLLOFF		13
-#define DTV_DISEQC_SLAVE_REPLY	14
-#define DTV_FE_CAPABILITY_COUNT	15
-#define DTV_FE_CAPABILITY	16
-#define DTV_DELIVERY_SYSTEM	17
-#define DTV_ISDBT_PARTIAL_RECEPTION	18
-#define DTV_ISDBT_SOUND_BROADCASTING	19
-#define DTV_ISDBT_SB_SUBCHANNEL_ID	20
-#define DTV_ISDBT_SB_SEGMENT_IDX	21
-#define DTV_ISDBT_SB_SEGMENT_COUNT	22
-#define DTV_ISDBT_LAYERA_FEC			23
-#define DTV_ISDBT_LAYERA_MODULATION		24
-#define DTV_ISDBT_LAYERA_SEGMENT_COUNT		25
-#define DTV_ISDBT_LAYERA_TIME_INTERLEAVING	26
-#define DTV_ISDBT_LAYERB_FEC			27
-#define DTV_ISDBT_LAYERB_MODULATION		28
-#define DTV_ISDBT_LAYERB_SEGMENT_COUNT		29
-#define DTV_ISDBT_LAYERB_TIME_INTERLEAVING	30
-#define DTV_ISDBT_LAYERC_FEC			31
-#define DTV_ISDBT_LAYERC_MODULATION		32
-#define DTV_ISDBT_LAYERC_SEGMENT_COUNT		33
-#define DTV_ISDBT_LAYERC_TIME_INTERLEAVING	34
-#define DTV_API_VERSION		35
-#define DTV_CODE_RATE_HP	36
-#define DTV_CODE_RATE_LP	37
-#define DTV_GUARD_INTERVAL	38
-#define DTV_TRANSMISSION_MODE	39
-#define DTV_HIERARCHY		40
-#define DTV_ISDBT_LAYER_ENABLED	41
-#define DTV_ISDBS_TS_ID		42
-</programlisting>
+
+<para><link linkend="DTV-UNDEFINED">DTV_UNDEFINED</link></para>
+<para><link linkend="DTV-TUNE">DTV_TUNE</link></para>
+<para><link linkend="DTV-CLEAR">DTV_CLEAR</link></para>
+<para><link linkend="DTV-FREQUENCY">DTV_FREQUENCY</link></para>
+<para><link linkend="DTV-MODULATION">DTV_MODULATION</link></para>
+<para><link linkend="DTV-BANDWIDTH-HZ">DTV_BANDWIDTH_HZ</link></para>
+<para><link linkend="DTV-INVERSION">DTV_INVERSION</link></para>
+<para><link linkend="DTV-DISEQC-MASTER">DTV_DISEQC_MASTER</link></para>
+<para><link linkend="DTV-SYMBOL-RATE">DTV_SYMBOL_RATE</link></para>
+<para><link linkend="DTV-INNER-FEC">DTV_INNER_FEC</link></para>
+<para><link linkend="DTV-VOLTAGE">DTV_VOLTAGE</link></para>
+<para><link linkend="DTV-TONE">DTV_TONE</link></para>
+<para><link linkend="DTV-PILOT">DTV_PILOT</link></para>
+<para><link linkend="DTV-ROLLOFF">DTV_ROLLOFF</link></para>
+<para><link linkend="DTV-DISEQC-SLAVE-REPLY">DTV_DISEQC_SLAVE_REPLY</link></para>
+<para><link linkend="DTV-FE-CAPABILITY-COUNT">DTV_FE_CAPABILITY_COUNT</link></para>
+<para><link linkend="DTV-FE-CAPABILITY">DTV_FE_CAPABILITY</link></para>
+<para><link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link></para>
+<para><link linkend="DTV-ISDBT-PARTIAL-RECEPTION">DTV_ISDBT_PARTIAL_RECEPTION</link></para>
+<para><link linkend="DTV-ISDBT-SOUND-BROADCASTING">DTV_ISDBT_SOUND_BROADCASTING</link></para>
+<para><link linkend="DTV-ISDBT-SB-SUBCHANNEL-ID">DTV_ISDBT_SB_SUBCHANNEL_ID</link></para>
+<para><link linkend="DTV-ISDBT-SB-SEGMENT-IDX">DTV_ISDBT_SB_SEGMENT_IDX</link></para>
+<para><link linkend="DTV-ISDBT-SB-SEGMENT-COUNT">DTV_ISDBT_SB_SEGMENT_COUNT</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-FEC">DTV_ISDBT_LAYERA_FEC</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-MODULATION">DTV_ISDBT_LAYERA_MODULATION</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT">DTV_ISDBT_LAYERA_SEGMENT_COUNT</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING">DTV_ISDBT_LAYERA_TIME_INTERLEAVING</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-FEC">DTV_ISDBT_LAYERB_FEC</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-MODULATION">DTV_ISDBT_LAYERB_MODULATION</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT">DTV_ISDBT_LAYERB_SEGMENT_COUNT</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING">DTV_ISDBT_LAYERB_TIME_INTERLEAVING</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-FEC">DTV_ISDBT_LAYERC_FEC</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-MODULATION">DTV_ISDBT_LAYERC_MODULATION</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-SEGMENT-COUNT">DTV_ISDBT_LAYERC_SEGMENT_COUNT</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING">DTV_ISDBT_LAYERC_TIME_INTERLEAVING</link></para>
+<para><link linkend="DTV-API-VERSION">DTV_API_VERSION</link></para>
+<para><link linkend="DTV-CODE-RATE-HP">DTV_CODE_RATE_HP</link></para>
+<para><link linkend="DTV-CODE-RATE-LP">DTV_CODE_RATE_LP</link></para>
+<para><link linkend="DTV-GUARD-INTERVAL">DTV_GUARD_INTERVAL</link></para>
+<para><link linkend="DTV-TRANSMISSION-MODE">DTV_TRANSMISSION_MODE</link></para>
+<para><link linkend="DTV-HIERARCHY">DTV_HIERARCHY</link></para>
+<para><link linkend="DTV-ISDBT-LAYER-ENABLED">DTV_ISDBT_LAYER_ENABLED</link></para>
+<para><link linkend="DTV-ISDBS-TS-ID">DTV_ISDBS_TS_ID</link></para>
+<para><link linkend="DTV-DVBT2-PLP-ID">DTV_DVBT2_PLP_ID</link></para>
 </section>
 
 <section id="fe_property_common">
-- 
1.7.1


