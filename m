Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60874 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaCVNAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Mar 2014 09:00:35 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so2700888eek.37
        for <linux-media@vger.kernel.org>; Sat, 22 Mar 2014 06:00:34 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/5] em28xx: remove some unused fields from struct em28xx
Date: Sat, 22 Mar 2014 14:01:01 +0100
Message-Id: <1395493263-2158-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 2051fc9..e95f4eb 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -618,7 +618,6 @@ struct em28xx {
 	unsigned hscale;	/* horizontal scale factor (see datasheet) */
 	unsigned vscale;	/* vertical scale factor (see datasheet) */
 	int interlaced;		/* 1=interlace fileds, 0=just top fileds */
-	unsigned int video_bytesread;	/* Number of bytes read */
 
 	unsigned long hash;	/* eeprom hash - for boards with generic ID */
 	unsigned long i2c_hash;	/* i2c devicelist hash -
@@ -638,8 +637,6 @@ struct em28xx {
 	/* locks */
 	struct mutex lock;
 	struct mutex ctrl_urb_lock;	/* protects urb_buf */
-	/* spinlock_t queue_lock; */
-	struct list_head inqueue, outqueue;
 	struct video_device *vbi_dev;
 	struct video_device *radio_dev;
 
@@ -663,7 +660,6 @@ struct em28xx {
 	spinlock_t slock;
 
 	unsigned int field_count;
-	unsigned int vbi_field_count;
 
 	/* usb transfer */
 	struct usb_device *udev;	/* the usb device */
-- 
1.8.4.5

