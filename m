Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:37210 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3AQAIf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 19:08:35 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so149185vbi.3
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2013 16:08:34 -0800 (PST)
From: Simon Que <sque@chromium.org>
To: linux-media@vger.kernel.org
Cc: msb@chromium.org, Simon Que <sque@chromium.org>
Subject: [PATCH] media: tuners: initialize hw and fw ids in xc4000.c
Date: Wed, 16 Jan 2013 15:40:35 -0800
Message-Id: <1358379635-14542-1-git-send-email-sque@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These variables are implicitly initialized by passing them to
xc_get_version().  However, initializing them to 0 explicitly will avoid
compile warnings.

Signed-off-by: Simon Que <sque@chromium.org>
---
 drivers/media/tuners/xc4000.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 4937712..d9dd53d 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -934,7 +934,8 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 	int			   rc = 0, is_retry = 0;
 	u16			   hwmodel;
 	v4l2_std_id		   std0;
-	u8			   hw_major, hw_minor, fw_major, fw_minor;
+	u8			   hw_major = 0, hw_minor = 0;
+	u8			   fw_major = 0, fw_minor = 0;
 
 	dprintk(1, "%s called\n", __func__);
 
-- 
1.7.8.6

