Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37323 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2CJPfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 10:35:06 -0500
Received: by yenl12 with SMTP id l12so1570797yen.19
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2012 07:35:04 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: crope@iki.fi, eddi@depieri.net, dheitmueller@kernellabs.com,
	gareth@garethwilliams.me.uk, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] media: em28xx: Remove unused urb arrays from device struct
Date: Sat, 10 Mar 2012 12:34:27 -0300
Message-Id: <1331393667-25611-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These arrays were embedded in the struct itself, but they weren't
used by anyone, since urbs are now dinamically allocated
at em28xx_usb_isoc_ctl struct.
Tested by compilation only.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 2ae6815..6a27e61 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -613,9 +613,6 @@ struct em28xx {
 	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
 	int dvb_alt;				/* alternate for DVB */
 	unsigned int dvb_max_pkt_size;		/* wMaxPacketSize for DVB */
-	struct urb *urb[EM28XX_NUM_BUFS];	/* urb for isoc transfers */
-	char *transfer_buffer[EM28XX_NUM_BUFS];	/* transfer buffers for isoc
-						   transfer */
 	char urb_buf[URB_MAX_CTRL_SIZE];	/* urb control msg buffer */
 
 	/* helper funcs that call usb_control_msg */
-- 
1.7.3.4

