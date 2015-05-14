Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60376 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308AbbENLzs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 07:55:48 -0400
From: Juergen Gier <juergen.gier@gmx.de>
To: mchehab@osg.samsung.com
Cc: Juergen Gier <juergen.gier@gmx.de>, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] saa7134: switch tuner FMD1216ME_MK3 to analog
Date: Thu, 14 May 2015 13:55:04 +0200
Message-Id: <1431604504-6515-1-git-send-email-juergen.gier@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Committer: Juergen Gier <juergen.gier@gmx.de>

Signed-off-by: Juergen Gier <juergen.gier@gmx.de>

The CTX946 TV card doesn't detect a signal after cold boot, seems
the tuner FMD1216ME_MK3 suffers the same problem as FMD1216MEX_MK3,
as described in saa7134-cards.c (disabled IF, enabled DVB-T). The
card does work under MS Windows, after soft reboot into Linux it
continues to work, only then tda9887 is loaded as well.
I copied the relevant code from the BEHOLD_H6 section to MD7134.

---

 drivers/media/pci/saa7134/saa7134-cards.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 3ca0780..43d2dda 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7797,10 +7797,11 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 	case SAA7134_BOARD_MD7134:
 	{
 		u8 subaddr;
-		u8 data[3];
+		u8 data[3], data1[] = { 0x09, 0x9f, 0x86, 0x11};
 		int ret, tuner_t;
-		struct i2c_msg msg[] = {{.addr=0x50, .flags=0, .buf=&subaddr, .len = 1},
-					{.addr=0x50, .flags=I2C_M_RD, .buf=data, .len = 3}};
+		struct i2c_msg msg[] = {{.addr = 0x50, .flags = 0, .buf = &subaddr, .len = 1},
+					{.addr = 0x50, .flags = I2C_M_RD, .buf = data, .len = 3}},
+				msg1 = {.addr = 0x61, .flags = 0, .buf = data1, .len = sizeof(data1)};
 
 		subaddr= 0x14;
 		tuner_t = 0;
@@ -7852,6 +7853,16 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		}
 
 		printk(KERN_INFO "%s Tuner type is %d\n", dev->name, dev->tuner_type);
+
+		/* The tuner TUNER_PHILIPS_FMD1216ME_MK3 after hardware    */
+		/* start has disabled IF and enabled DVB-T. When saa7134   */
+		/* scan I2C devices it will not detect IF tda9887 and can`t*/
+		/* watch TV without software reboot. To solve this problem */
+		/* switch the tuner to analog TV mode manually.            */
+		if (dev->tuner_type == TUNER_PHILIPS_FMD1216ME_MK3) {
+			if (i2c_transfer(&dev->i2c_adap, &msg1, 1) != 1)
+				printk(KERN_WARNING "%s: Unable to enable IF of the tuner.\n", dev->name);
+		}
 		break;
 	}
 	case SAA7134_BOARD_PHILIPS_EUROPA:
-- 
2.1.0

