Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:50981 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757825Ab0LNTO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 14:14:56 -0500
Date: Tue, 14 Dec 2010 20:16:58 +0100
From: =?UTF-8?B?SmVhbi1GcmFuw6dvaXM=?= Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 5/6] gspca - sonixj: Add the bit definitions of the bridge
 reg 0x01 and 0x17
Message-ID: <20101214201658.795f96f5@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Jean-François Moine <moinejf@free.fr>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 5deff24..a75f7ec 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -100,6 +100,19 @@ enum sensors {
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
 static void setbrightness(struct gspca_dev *gspca_dev);
 static void setcontrast(struct gspca_dev *gspca_dev);
-- 
1.7.2.3

