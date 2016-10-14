Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757005AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Terry Heo <terryheo@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Rosin <peda@axentia.se>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 36/57] [media] cx231xx: don't break long lines
Date: Fri, 14 Oct 2016 17:20:24 -0300
Message-Id: <a47f416a27d002059a3584999b5a9542da812e16.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 9 +++------
 drivers/media/usb/cx231xx/cx231xx-dvb.c  | 3 +--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 8b099fe1d592..6bab66d3377e 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -241,8 +241,7 @@ static int __usb_control_msg(struct cx231xx *dev, unsigned int pipe,
 	int rc, i;
 
 	if (reg_debug) {
-		printk(KERN_DEBUG "%s: (pipe 0x%08x): "
-				"%s:  %02x %02x %02x %02x %02x %02x %02x %02x ",
+		printk(KERN_DEBUG "%s: (pipe 0x%08x): %s:  %02x %02x %02x %02x %02x %02x %02x %02x ",
 				dev->name,
 				pipe,
 				(requesttype & USB_DIR_IN) ? "IN" : "OUT",
@@ -441,8 +440,7 @@ int cx231xx_write_ctrl_reg(struct cx231xx *dev, u8 req, u16 reg, char *buf,
 	if (reg_debug) {
 		int byte;
 
-		cx231xx_isocdbg("(pipe 0x%08x): "
-			"OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>>",
+		cx231xx_isocdbg("(pipe 0x%08x): OUT: %02x %02x %02x %02x %02x %02x %02x %02x >>>",
 			pipe,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			req, 0, val, reg & 0xff,
@@ -600,8 +598,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 			return -1;
 	}
 
-	cx231xx_coredbg("setting alternate %d with wMaxPacketSize=%u,"
-			"Interface = %d\n", alt, max_pkt_size,
+	cx231xx_coredbg("setting alternate %d with wMaxPacketSize=%u,Interface = %d\n", alt, max_pkt_size,
 			usb_interface_index);
 
 	if (usb_interface_index > 0) {
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 1417515d30eb..653ff20b484d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -377,8 +377,7 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 	cfg.i2c_addr = addr;
 
 	if (!dev->dvb->frontend) {
-		dev_err(dev->dev, "%s/2: dvb frontend not attached. "
-		       "Can't attach xc5000\n", dev->name);
+		dev_err(dev->dev, "%s/2: dvb frontend not attached. Can't attach xc5000\n", dev->name);
 		return -EINVAL;
 	}
 
-- 
2.7.4


