Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab2HGCsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:02 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:01 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 15/24] au0828: remove control buffer from send_control_msg
Date: Mon,  6 Aug 2012 22:47:05 -0400
Message-Id: <1344307634-11673-16-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no cases where a control message is ever sent to the au0828 with
an actual buffer defined.  Remove the reference to dev->ctrlmsg, which
currently requires us to hold a mutex since it is shared with the read
function.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-core.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
index b2c4254..65914bc 100644
--- a/drivers/media/video/au0828/au0828-core.c
+++ b/drivers/media/video/au0828/au0828-core.c
@@ -46,7 +46,7 @@ MODULE_PARM_DESC(disable_usb_speed_check,
 #define _BULKPIPESIZE 0xffff
 
 static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
-	u16 index, unsigned char *cp, u16 size);
+			    u16 index);
 static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 	u16 index, unsigned char *cp, u16 size);
 
@@ -64,8 +64,7 @@ u32 au0828_readreg(struct au0828_dev *dev, u16 reg)
 u32 au0828_writereg(struct au0828_dev *dev, u16 reg, u32 val)
 {
 	dprintk(8, "%s(0x%04x, 0x%02x)\n", __func__, reg, val);
-	return send_control_msg(dev, CMD_REQUEST_OUT, val, reg,
-				dev->ctrlmsg, 0);
+	return send_control_msg(dev, CMD_REQUEST_OUT, val, reg);
 }
 
 static void cmd_msg_dump(struct au0828_dev *dev)
@@ -87,10 +86,10 @@ static void cmd_msg_dump(struct au0828_dev *dev)
 }
 
 static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
-	u16 index, unsigned char *cp, u16 size)
+	u16 index)
 {
 	int status = -ENODEV;
-	mutex_lock(&dev->mutex);
+
 	if (dev->usbdev) {
 
 		/* cp must be memory that has been allocated by kmalloc */
@@ -99,8 +98,7 @@ static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 				request,
 				USB_DIR_OUT | USB_TYPE_VENDOR |
 					USB_RECIP_DEVICE,
-				value, index,
-				cp, size, 1000);
+				value, index, NULL, 0, 1000);
 
 		status = min(status, 0);
 
@@ -110,7 +108,7 @@ static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 		}
 
 	}
-	mutex_unlock(&dev->mutex);
+
 	return status;
 }
 
-- 
1.7.1

