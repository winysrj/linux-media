Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:42744 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbZFRLLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 07:11:14 -0400
Received: by bwz9 with SMTP id 9so973842bwz.37
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 04:11:16 -0700 (PDT)
Date: Thu, 18 Jun 2009 13:11:57 +0200
From: Jan Nikitenko <jan.nikitenko@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: [PATCH v2] zl10353 and qt1010: fix stack corruption bug
Message-ID: <20090618111157.GB9575@nikitenko.systek.local>
References: <4A28CEAD.9000000@gmail.com> <20090616155937.3f5d869d@pedra.chehab.org> <4A38DA79.70707@gmail.com> <200906171426.29468.zzam@gentoo.org> <20090617101845.425f9249@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617101845.425f9249@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes stack corruption bug present in dump_regs function of zl10353 and qt1010 drivers:
the buffer buf was one byte smaller than required - there are 4 chars for address prefix, 16 * 3 chars for dump of 16 eeprom bytes per line and 1 byte for zero ending the string required, i.e. 53 bytes, but only 52 were provided.
The one byte missing in stack based buffer buf can cause stack corruption possibly leading to kernel oops, as discovered originally with af9015 driver (af9015: fix stack corruption bug).

This is second version of the patch for zl10353 and qt1010 that uses continual printk instead of stack based buffer with proper magic number size.

Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>

---

 linux/drivers/media/common/tuners/qt1010.c  |   12 +++++-------
 linux/drivers/media/dvb/frontends/zl10353.c |   12 +++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff -r 722c6faf3ab5 linux/drivers/media/common/tuners/qt1010.c
--- a/linux/drivers/media/common/tuners/qt1010.c	Wed Jun 17 22:39:23 2009 -0300
+++ b/linux/drivers/media/common/tuners/qt1010.c	Thu Jun 18 08:49:58 2009 +0200
@@ -65,24 +65,22 @@
 /* dump all registers */
 static void qt1010_dump_regs(struct qt1010_priv *priv)
 {
-	char buf[52], buf2[4];
 	u8 reg, val;
 
 	for (reg = 0; ; reg++) {
 		if (reg % 16 == 0) {
 			if (reg)
-				printk("%s\n", buf);
-			sprintf(buf, "%02x: ", reg);
+				printk(KERN_CONT "\n");
+			printk(KERN_DEBUG "%02x:", reg);
 		}
 		if (qt1010_readreg(priv, reg, &val) == 0)
-			sprintf(buf2, "%02x ", val);
+			printk(KERN_CONT " %02x", val);
 		else
-			strcpy(buf2, "-- ");
-		strcat(buf, buf2);
+			printk(KERN_CONT " --");
 		if (reg == 0x2f)
 			break;
 	}
-	printk("%s\n", buf);
+	printk(KERN_CONT "\n");
 }
 
 static int qt1010_set_params(struct dvb_frontend *fe,
diff -r 722c6faf3ab5 linux/drivers/media/dvb/frontends/zl10353.c
--- a/linux/drivers/media/dvb/frontends/zl10353.c	Wed Jun 17 22:39:23 2009 -0300
+++ b/linux/drivers/media/dvb/frontends/zl10353.c	Thu Jun 18 08:49:58 2009 +0200
@@ -102,7 +102,6 @@
 static void zl10353_dump_regs(struct dvb_frontend *fe)
 {
 	struct zl10353_state *state = fe->demodulator_priv;
-	char buf[52], buf2[4];
 	int ret;
 	u8 reg;
 
@@ -110,19 +109,18 @@
 	for (reg = 0; ; reg++) {
 		if (reg % 16 == 0) {
 			if (reg)
-				printk(KERN_DEBUG "%s\n", buf);
-			sprintf(buf, "%02x: ", reg);
+				printk(KERN_CONT "\n");
+			printk(KERN_DEBUG "%02x:", reg);
 		}
 		ret = zl10353_read_register(state, reg);
 		if (ret >= 0)
-			sprintf(buf2, "%02x ", (u8)ret);
+			printk(KERN_CONT " %02x", (u8)ret);
 		else
-			strcpy(buf2, "-- ");
-		strcat(buf, buf2);
+			printk(KERN_CONT " --");
 		if (reg == 0xff)
 			break;
 	}
-	printk(KERN_DEBUG "%s\n", buf);
+	printk(KERN_CONT "\n");
 }
 #endif
 
