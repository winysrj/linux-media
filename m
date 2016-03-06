Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcCFNjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:39:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6/6] [media] touptek: cast char types on %x printk
Date: Sun,  6 Mar 2016 10:39:22 -0300
Message-Id: <6b7ff5dac58433fe4cd9c78156878c0cccbcb66c.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes those two smatch warnings:
	drivers/media/usb/gspca/touptek.c:206 val_reply() warn: argument 3 to %02x specifier has type 'char'
	drivers/media/usb/gspca/touptek.c:222 reg_w() warn: argument 4 to %02x specifier has type 'char'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/gspca/touptek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/touptek.c b/drivers/media/usb/gspca/touptek.c
index 8063b8e45ee5..b8af4370d27c 100644
--- a/drivers/media/usb/gspca/touptek.c
+++ b/drivers/media/usb/gspca/touptek.c
@@ -203,7 +203,7 @@ static int val_reply(struct gspca_dev *gspca_dev, const char *reply, int rc)
 		return -EIO;
 	}
 	if (reply[0] != 0x08) {
-		PERR("Bad reply 0x%02X", reply[0]);
+		PERR("Bad reply 0x%02x", (int)reply[0]);
 		return -EIO;
 	}
 	return 0;
@@ -219,7 +219,7 @@ static void reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
 		value, index);
 	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
 		0x0B, 0xC0, value, index, buff, 1, 500);
-	PDEBUG(D_USBO, "rc=%d, ret={0x%02X}", rc, buff[0]);
+	PDEBUG(D_USBO, "rc=%d, ret={0x%02x}", rc, (int)buff[0]);
 	if (rc < 0) {
 		PERR("Failed reg_w(0x0B, 0xC0, 0x%04X, 0x%04X) w/ rc %d\n",
 			value, index, rc);
-- 
2.5.0

