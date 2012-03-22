Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52609 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2CVPOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 11:14:07 -0400
Received: by eaaq12 with SMTP id q12so735386eaa.19
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2012 08:14:04 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] em28xx: clean-up several unused parametrs in struct em28xx_usb_isoc_ctl
Date: Thu, 22 Mar 2012 16:13:55 +0100
Message-Id: <1332429235-19282-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of several unused parameters in struct em28xx_usb_isoc_ctl.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/video/em28xx/em28xx-core.c |    1 -
 drivers/media/video/em28xx/em28xx.h      |   14 --------------
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index cbbe399..fd54c80 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -974,7 +974,6 @@ void em28xx_uninit_isoc(struct em28xx *dev, enum em28xx_mode mode)
 	else
 		isoc_bufs = &dev->isoc_ctl.analog_bufs;
 
-	dev->isoc_ctl.nfields = -1;
 	for (i = 0; i < isoc_bufs->num_bufs; i++) {
 		urb = isoc_bufs->urb[i];
 		if (urb) {
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 286b9f8..c2a5a99 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -226,24 +226,10 @@ struct em28xx_usb_isoc_ctl {
 		/* isoc transfer buffers for digital mode */
 	struct em28xx_usb_isoc_bufs	digital_bufs;
 
-		/* Last buffer command and region */
-	u8				cmd;
-	int				pos, size, pktsize;
-
-		/* Last field: ODD or EVEN? */
-	int				field;
-
-		/* Stores incomplete commands */
-	u32				tmp_buf;
-	int				tmp_buf_len;
-
 		/* Stores already requested buffers */
 	struct em28xx_buffer    	*vid_buf;
 	struct em28xx_buffer    	*vbi_buf;
 
-		/* Stores the number of received fields */
-	int				nfields;
-
 		/* isoc urb callback */
 	int (*isoc_copy) (struct em28xx *dev, struct urb *urb);
 
-- 
1.7.0.4

