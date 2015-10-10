Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbbJJNgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:20 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 16/26] [media] dvb: Remove unused frontend sources at demux.h and sync doc
Date: Sat, 10 Oct 2015 10:35:59 -0300
Message-Id: <0693bdf75469487812da7c09949b09ad0396a737.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB core has a provision for other frontend sources, but no
drivers use it. The kdapi.xml contains provision for some other
frontend source types, but it is not in sync with the code.

So, remove the unused types and sync both files.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/kdapi.xml b/Documentation/DocBook/media/dvb/kdapi.xml
index 1acae6730151..ff133a326d50 100644
--- a/Documentation/DocBook/media/dvb/kdapi.xml
+++ b/Documentation/DocBook/media/dvb/kdapi.xml
@@ -148,14 +148,9 @@ should be kept identical) to the types in the demux device.
  /&#x22C6;--------------------------------------------------------------------------&#x22C6;/
 
  typedef enum {
-	 DMX_OTHER_FE = 0,
-	 DMX_SATELLITE_FE,
-	 DMX_CABLE_FE,
-	 DMX_TERRESTRIAL_FE,
-	 DMX_LVDS_FE,
-	 DMX_ASI_FE, /&#x22C6; DVB-ASI interface &#x22C6;/
-	 DMX_MEMORY_FE
- } dmx_frontend_source_t;
+	 DMX_MEMORY_FE,
+	 DMX_FRONTEND_0,
+ } dmx_frontend_source;
 
  typedef struct {
 	 /&#x22C6; The following char&#x22C6; fields point to NULL terminated strings &#x22C6;/
@@ -166,7 +161,7 @@ should be kept identical) to the types in the demux device.
 						be connected to a particular
 						demux &#x22C6;/
 	 void&#x22C6; priv;     /&#x22C6; Pointer to private data of the API client &#x22C6;/
-	 dmx_frontend_source_t source;
+	 dmx_frontend_source source;
  } dmx_frontend_t;
 
  /&#x22C6;--------------------------------------------------------------------------&#x22C6;/
diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 2d036b36f551..15b79bdee465 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -141,13 +141,6 @@ typedef int (*dmx_section_cb) (	const u8 * buffer1,
 enum dmx_frontend_source {
 	DMX_MEMORY_FE,
 	DMX_FRONTEND_0,
-	DMX_FRONTEND_1,
-	DMX_FRONTEND_2,
-	DMX_FRONTEND_3,
-	DMX_STREAM_0,    /* external stream input, e.g. LVDS */
-	DMX_STREAM_1,
-	DMX_STREAM_2,
-	DMX_STREAM_3
 };
 
 struct dmx_frontend {
-- 
2.4.3


