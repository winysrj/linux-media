Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:2454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1AFLb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 06:31:26 -0500
Date: Thu, 6 Jan 2011 09:28:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: moinejf@free.fr, stable@kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] gspca - sonixj: Add the bit definitions of the
 bridge reg 0x01 and 0x17
Message-ID: <20110106092831.70cb08f8@gaivota>
In-Reply-To: <cover.1294312927.git.mchehab@redhat.com>
References: <cover.1294312927.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

backports changeset 4fd350ee2bf129acb933ad5104bc4754b2c7c9ef

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 63f789d..f8d25570 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -91,6 +91,19 @@ enum sensors {
 /* device flags */
 #define PDN_INV	1		/* inverse pin S_PWR_DN / sn_xxx tables */
 
+/* sn9c1xx definitions */
+/* register 0x01 */
+#define S_PWR_DN	0x01	/* sensor power down */
+#define S_PDN_INV	0x02	/* inverse pin S_PWR_DN */
+#define V_TX_EN		0x04	/* video transfer enable */
+#define LED		0x08	/* output to pin LED */
+#define SCL_SEL_OD	0x20	/* open-drain mode */
+#define SYS_SEL_48M	0x40	/* system clock 0: 24MHz, 1: 48MHz */
+/* register 0x17 */
+#define MCK_SIZE_MASK	0x1f	/* sensor master clock */
+#define SEN_CLK_EN	0x20	/* enable sensor clock */
+#define DEF_EN		0x80	/* defect pixel by 0: soft, 1: hard */
+
 /* V4L2 controls supported by the driver */
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
-- 
1.7.3.4


