Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaG0T1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 15:27:39 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 6/6] cx231xx: return an error if it can't read PCB config
Date: Sun, 27 Jul 2014 16:27:32 -0300
Message-Id: <1406489252-30636-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
References: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using some random value, return an error if the
PCB config is not available or doesn't match a know profile

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c   |  6 +++++-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c | 10 +++++++---
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h |  2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 338417fee8b6..8039b769f258 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1144,7 +1144,11 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	dev->cx231xx_gpio_i2c_write = cx231xx_gpio_i2c_write;
 
 	/* Query cx231xx to find what pcb config it is related to */
-	initialize_cx231xx(dev);
+	retval = initialize_cx231xx(dev);
+	if (retval < 0) {
+		cx231xx_errdev("Failed to read PCB config\n");
+		return retval;
+	}
 
 	/*To workaround error number=-71 on EP0 for VideoGrabber,
 		 need set alt here.*/
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
index 2a34ceee4802..3052c4c20229 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
@@ -654,8 +654,9 @@ static struct pcb_config cx231xx_Scenario[] = {
 
 /*****************************************************************/
 
-u32 initialize_cx231xx(struct cx231xx *dev)
+int initialize_cx231xx(struct cx231xx *dev)
 {
+	int retval;
 	u32 config_info = 0;
 	struct pcb_config *p_pcb_info;
 	u8 usb_speed = 1;	/* from register,1--HS, 0--FS  */
@@ -670,7 +671,10 @@ u32 initialize_cx231xx(struct cx231xx *dev)
 
 	/* read board config register to find out which
 	pcb config it is related to */
-	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT, data, 4);
+	retval = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT,
+				       data, 4);
+	if (retval < 0)
+		return retval;
 
 	config_info = le32_to_cpu(*((__le32 *)data));
 	usb_speed = (u8) (config_info & 0x1);
@@ -767,7 +771,7 @@ u32 initialize_cx231xx(struct cx231xx *dev)
 			cx231xx_info("bad senario!!!!!\n");
 			cx231xx_info("config_info=%x\n",
 				     (config_info & SELFPOWER_MASK));
-			return 1;
+			return -ENODEV;
 		}
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
index b3c6190e0c69..4511dc5d199c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
@@ -221,6 +221,6 @@ enum INDEX_PCB_CONFIG{
 /***************************************************************************/
 struct cx231xx;
 
-u32 initialize_cx231xx(struct cx231xx *p_dev);
+int initialize_cx231xx(struct cx231xx *p_dev);
 
 #endif
-- 
1.9.3

