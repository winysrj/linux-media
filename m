Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbcCFNjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:39:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/6] [media] touptek: don't DMA at the stack
Date: Sun,  6 Mar 2016 10:39:21 -0300
Message-Id: <03e3125996244a85493652e8675dbb1b66e8ead4.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/usb/gspca/touptek.c:220 reg_w() error: doing dma on the stack (buff)
	drivers/media/usb/gspca/touptek.c:458 configure() error: doing dma on the stack (buff)

This can fail, as the stack may not be in a memory that would
allod DMA. So, use the usb_buf instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/gspca/touptek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/touptek.c b/drivers/media/usb/gspca/touptek.c
index 7bac6bc96063..8063b8e45ee5 100644
--- a/drivers/media/usb/gspca/touptek.c
+++ b/drivers/media/usb/gspca/touptek.c
@@ -211,7 +211,7 @@ static int val_reply(struct gspca_dev *gspca_dev, const char *reply, int rc)
 
 static void reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
 {
-	char buff[1];
+	char *buff = gspca_dev->usb_buf;
 	int rc;
 
 	PDEBUG(D_USBO,
@@ -438,7 +438,7 @@ static void configure_encrypted(struct gspca_dev *gspca_dev)
 static int configure(struct gspca_dev *gspca_dev)
 {
 	int rc;
-	uint8_t buff[4];
+	char *buff = gspca_dev->usb_buf;
 
 	PDEBUG(D_STREAM, "configure()\n");
 
-- 
2.5.0

