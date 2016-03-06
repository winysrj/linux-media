Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbcCFNjr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:39:47 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/6] [media] mceusb: use %*ph for small buffer dumps
Date: Sun,  6 Mar 2016 10:39:19 -0300
Message-Id: <f91b5ae3337e9d9114648ccd02d7763fd1c9d4b0.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes the printk cleaner. As a side efect, it also fixes those smatch
warnings:
	drivers/media/rc/mceusb.c:590 mceusb_dev_printdata() warn: argument 6 to %02x specifier has type 'char'
	drivers/media/rc/mceusb.c:590 mceusb_dev_printdata() warn: argument 7 to %02x specifier has type 'char'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/rc/mceusb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 2cdb740cde48..35155ae500c7 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -587,9 +587,8 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			if (len == 2)
 				dev_dbg(dev, "Get hw/sw rev?");
 			else
-				dev_dbg(dev, "hw/sw rev 0x%02x 0x%02x 0x%02x 0x%02x",
-					 data1, data2,
-					 buf[start + 4], buf[start + 5]);
+				dev_dbg(dev, "hw/sw rev %*ph",
+					4, &buf[start + 2]);
 			break;
 		case MCE_CMD_RESUME:
 			dev_dbg(dev, "Device resume requested");
-- 
2.5.0

