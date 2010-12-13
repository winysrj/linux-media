Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:36244 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab0LMNCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:02:09 -0500
Date: Mon, 13 Dec 2010 14:04:09 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 5/6] gspca - sonixj: Add the bit definitions of the bridge
 reg 0x01 and 0x17
Message-ID: <20101213140409.7e3bc5ab@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Signed-off-by: Jean-François Moine <moinejf@free.fr>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 9b7e28a..4c10324 100644
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

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
