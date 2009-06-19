Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f206.google.com ([209.85.220.206]:47442 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZFSHbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 03:31:37 -0400
Received: by fxm2 with SMTP id 2so90842fxm.37
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 00:31:38 -0700 (PDT)
Date: Fri, 19 Jun 2009 09:32:23 +0200
From: Jan Nikitenko <jan.nikitenko@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH v2] af9015: avoid magically sized temporary buffer in
	eeprom_dump
Message-ID: <20090619073223.GA26155@localhost.localdomain>
References: <c4bc83220906091531h20677733kd993ed50c0bc74ec@mail.gmail.com> <4A2EF922.5040102@iki.fi> <20090618111253.GC9575@nikitenko.systek.local> <20090618112227.GA9930@nikitenko.systek.local> <Pine.LNX.4.58.0906181358390.32713@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0906181358390.32713@shell2.speakeasy.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printing to magically sized temporary buffer with use
of KERN_CONT for continual printing of eeprom registers dump.

Since deb_info is defined as dprintk, which is conditionally defined
to printk without additional parameters, meaning that deb_info is equivalent
to direct printk (without adding KERN_ facility), we can use KERN_DEBUG and
KERN_CONT in there, eliminating the need for sprintf into temporary buffer
with not easily readable/magical size.

Though it's strange, that deb_info definition uses printk without KERN_
facility and callers don't use it either.

v2: removed comma after KERN_CONT

Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>

---

I do not see better solution for the magical sized buffer, since
print_hex_dump like functions need dump of registers in memory
(so the magical sized temporary buffer would be needed for a copy anyway).
If deb_info was defined with inside KERN_ facility, then this patch
would not be valid. In that case the magically sized temporary buffer might
be acceptable.

This patch depends on 'af9015: fix stack corruption bug' patch.


On 14:00 Thu 18 Jun     , Trent Piepho wrote:
> On Thu, 18 Jun 2009, Jan Nikitenko wrote:
> > +			deb_info(KERN_CONT, " --");
> 
> No comma after KERN_CONT
> 
> Just use printk() instead of deb_info() for the ones that use KERN_CONT.

It's not possible to use printk instead of deb_info just for the ones
that use KERN_CONT, because deb_info not always goes to printk, it depends on
compile time dprintk macro expansion and on runtime configuration of debugging
messages from dvb subsystem.

If printk is used instead of all deb_info calls, this logging would not
be anymore influenced by above mentioned settings for deb_info.
I am not sure if duplicating all conditions of deb_info for direct
printk in there would be any better.


 linux/drivers/media/dvb/dvb-usb/af9015.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -r 722c6faf3ab5 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Wed Jun 17 22:39:23 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Fri Jun 19 09:22:53 2009 +0200
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
+			deb_info(KERN_CONT " %02x", val);
 		else
-			strcpy(buf2, "-- ");
-		strcat(buf, buf2);
+			deb_info(KERN_CONT " --");
 		if (reg == 0xff)
 			break;
 	}
-	deb_info("%s\n", buf);
+	deb_info(KERN_CONT "\n");
 	return 0;
 }
 
