Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbbFHTyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:33 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: [PATCH 25/26] [media] dvb: dmx.h: don't use anonymous enums
Date: Mon,  8 Jun 2015 16:54:09 -0300
Message-Id: <457fb3301bb84d4c87d395e8d3783684e3acffc8.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several anonymous enums here, used via a typedef.

Well, we don't like typedefs on Kernel, so let's de-anonimize
those enums. Then, latter, we may be able to get rid of the
typedefs, at least from Kernelspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index b4fb650d9d4f..ece3661a3cac 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -32,7 +32,7 @@
 
 #define DMX_FILTER_SIZE 16
 
-typedef enum
+typedef enum dmx_output
 {
 	DMX_OUT_DECODER, /* Streaming directly to decoder. */
 	DMX_OUT_TAP,     /* Output going to a memory buffer */
@@ -44,7 +44,7 @@ typedef enum
 } dmx_output_t;
 
 
-typedef enum
+typedef enum dmx_input
 {
 	DMX_IN_FRONTEND, /* Input from a front-end device.  */
 	DMX_IN_DVR       /* Input from the logical DVR device.  */
@@ -122,7 +122,7 @@ typedef struct dmx_caps {
 	int num_decoders;
 } dmx_caps_t;
 
-typedef enum {
+typedef enum dmx_source {
 	DMX_SOURCE_FRONT0 = 0,
 	DMX_SOURCE_FRONT1,
 	DMX_SOURCE_FRONT2,
-- 
2.4.2

