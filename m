Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34173 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbbE2B3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 21:29:02 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/8] DocBook: cross-reference enum fe_modulation where needed
Date: Thu, 28 May 2015 22:28:51 -0300
Message-Id: <4bed30d6786f8e0e8875745f166103205d3eec68.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At frontend legacy API description, there are three places
where fe_modulation_t is defined. Cross-reference it to point
to the right place at the documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index 1eedc4ce0e4a..7d5823858df0 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -115,7 +115,7 @@ OFDM frontends the <constant>frequency</constant> specifies the absolute frequen
  struct dvb_qam_parameters {
 	 uint32_t         symbol_rate; /&#x22C6; symbol rate in Symbols per second &#x22C6;/
 	 fe_code_rate_t   fec_inner;   /&#x22C6; forward error correction (see above) &#x22C6;/
-	 fe_modulation_t  modulation;  /&#x22C6; modulation type (see above) &#x22C6;/
+	 &fe-modulation-t;  modulation;  /&#x22C6; modulation type (see above) &#x22C6;/
  };
 </programlisting>
 </section>
@@ -125,7 +125,7 @@ OFDM frontends the <constant>frequency</constant> specifies the absolute frequen
 <para>ATSC frontends are supported by the <constant>dvb_vsb_parameters</constant> structure:</para>
 <programlisting>
 struct dvb_vsb_parameters {
-	fe_modulation_t modulation;	/&#x22C6; modulation type (see above) &#x22C6;/
+	&fe-modulation-t; modulation;	/&#x22C6; modulation type (see above) &#x22C6;/
 };
 </programlisting>
 </section>
@@ -138,7 +138,7 @@ struct dvb_vsb_parameters {
 	 fe_bandwidth_t      bandwidth;
 	 fe_code_rate_t      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
 	 fe_code_rate_t      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
-	 fe_modulation_t     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
+	 &fe-modulation-t;     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
 	 fe_transmit_mode_t  transmission_mode;
 	 fe_guard_interval_t guard_interval;
 	 fe_hierarchy_t      hierarchy_information;
-- 
2.4.1

