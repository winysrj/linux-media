Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33832 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbZFRLVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 07:21:46 -0400
Received: by bwz9 with SMTP id 9so979613bwz.37
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 04:21:47 -0700 (PDT)
Date: Thu, 18 Jun 2009 13:22:27 +0200
From: Jan Nikitenko <jan.nikitenko@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] af9015: avoid magically sized temporal buffer in
	eeprom_dump
Message-ID: <20090618112227.GA9930@nikitenko.systek.local>
References: <c4bc83220906091531h20677733kd993ed50c0bc74ec@mail.gmail.com> <4A2EF922.5040102@iki.fi> <20090618111253.GC9575@nikitenko.systek.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2EF922.5040102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printing to magically sized temporal buffer with use of KERN_CONT
for continual printing of eeprom registers dump.

Since deb_info is defined as dprintk, which is defined as printk without
additional parameters, meaning that deb_info is equivalent to direct printk
(without KERN_ facility), we can use KERN_DEBUG and KERN_CONT in there,
eliminating the need for sprintf into temporal buffer with not easily
readable/magical size.

Though it's strange, that deb_info definition uses printk without KERN_
facility and callers don't use it either.

Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>

---

(added missing Singned-off)

I do not see better solution for the magical sized buffer, since print_hex_dump
like functions need dump of registers in memory (so the magical sized temporal
buffer would be needed for a copy anyway).
If deb_info was defined with inside KERN_ facility, then this patch would not
be valid and so the magically sized temporal buffer might be acceptable to keep
there.

This patch depends on 'af9015: fix stack corruption bug' patch.

 linux/drivers/media/dvb/dvb-usb/af9015.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -r 722c6faf3ab5 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Wed Jun 17 22:39:23 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Thu Jun 18 08:49:58 2009 +0200
@@ -541,24 +541,22 @@
 /* dump eeprom */
 static int af9015_eeprom_dump(struct dvb_usb_device *d)
 {
-	char buf[4+3*16+1], buf2[4];
 	u8 reg, val;
 
 	for (reg = 0; ; reg++) {
 		if (reg % 16 == 0) {
 			if (reg)
-				deb_info("%s\n", buf);
-			sprintf(buf, "%02x: ", reg);
+				deb_info(KERN_CONT "\n");
+			deb_info(KERN_DEBUG "%02x:", reg);
 		}
 		if (af9015_read_reg_i2c(d, AF9015_I2C_EEPROM, reg, &val) == 0)
-			sprintf(buf2, "%02x ", val);
+			deb_info(KERN_CONT, " %02x", val);
 		else
-			strcpy(buf2, "-- ");
-		strcat(buf, buf2);
+			deb_info(KERN_CONT, " --");
 		if (reg == 0xff)
 			break;
 	}
-	deb_info("%s\n", buf);
+	deb_info(KERN_CONT "\n");
 	return 0;
 }
 
