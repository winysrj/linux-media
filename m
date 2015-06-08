Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbbFHTyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:33 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 17/26] [media] DocBook: add xrefs for enum fe_type
Date: Mon,  8 Jun 2015 16:54:01 -0300
Message-Id: <02391cd7fc77d9a8b77cd8ca67684b73ccaffcc5.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The only enum that was missing xrefs at frontend.h is fe_type.
Add xrefs for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index 8523caf91a2c..8fadf3a4ba44 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -20,22 +20,22 @@
   </thead>
   <tbody valign="top">
   <row>
-     <entry id="FE_QPSK"><constant>FE_QPSK</constant></entry>
+     <entry id="FE-QPSK"><constant>FE_QPSK</constant></entry>
      <entry>For DVB-S standard</entry>
      <entry><constant>SYS_DVBS</constant></entry>
   </row>
   <row>
-     <entry id="FE_QAM"><constant>FE_QAM</constant></entry>
+     <entry id="FE-QAM"><constant>FE_QAM</constant></entry>
      <entry>For DVB-C annex A standard</entry>
      <entry><constant>SYS_DVBC_ANNEX_A</constant></entry>
   </row>
   <row>
-     <entry id="FE_OFDM"><constant>FE_OFDM</constant></entry>
+     <entry id="FE-OFDM"><constant>FE_OFDM</constant></entry>
      <entry>For DVB-T standard</entry>
      <entry><constant>SYS_DVBT</constant></entry>
   </row>
   <row>
-     <entry id="FE_ATSC"><constant>FE_ATSC</constant></entry>
+     <entry id="FE-ATSC"><constant>FE_ATSC</constant></entry>
      <entry>For ATSC standard (terrestrial) or for DVB-C Annex B (cable) used in US.</entry>
      <entry><constant>SYS_ATSC</constant> (terrestrial) or <constant>SYS_DVBC_ANNEX_B</constant> (cable)</entry>
   </row>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 66499f238204..a36d802fae0c 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -28,12 +28,14 @@
 
 #include <linux/types.h>
 
-typedef enum fe_type {
+enum fe_type {
 	FE_QPSK,
 	FE_QAM,
 	FE_OFDM,
 	FE_ATSC
-} fe_type_t;
+};
+
+typedef enum fe_type fe_type_t;
 
 
 enum fe_caps {
-- 
2.4.2

