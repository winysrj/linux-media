Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:43154 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0FHRhz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 13:37:55 -0400
Received: by ewy8 with SMTP id 8so1197289ewy.28
        for <linux-media@vger.kernel.org>; Tue, 08 Jun 2010 10:37:53 -0700 (PDT)
From: Balint Reczey <balint@balintreczey.hu>
To: linux-media@vger.kernel.org
Cc: Balint Reczey <balint@balintreczey.hu>
Subject: [PATCH] libv4l1: support up to 256 different frame sizes
Date: Tue,  8 Jun 2010 19:36:58 +0200
Message-Id: <1276018618-12162-1-git-send-email-balint@balintreczey.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Logitech, Inc. Webcam Pro 9000 supports 18 wich is more than the the originally
supported 16. 256 should be enough for a while.
---
 lib/libv4lconvert/libv4lconvert-priv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index 6e880f8..b3e4c4e 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -29,7 +29,7 @@
 #define ARRAY_SIZE(x) ((int)sizeof(x)/(int)sizeof((x)[0]))
 
 #define V4LCONVERT_ERROR_MSG_SIZE 256
-#define V4LCONVERT_MAX_FRAMESIZES 16
+#define V4LCONVERT_MAX_FRAMESIZES 256
 
 #define V4LCONVERT_ERR(...) \
 	snprintf(data->error_msg, V4LCONVERT_ERROR_MSG_SIZE, \
-- 
1.7.1

