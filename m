Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934473AbcJRUqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Terry Heo <terryheo@google.com>, Peter Rosin <peda@axentia.se>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v2 34/58] cx231xx: don't break long lines
Date: Tue, 18 Oct 2016 18:45:46 -0200
Message-Id: <0ba434ef9b8ec5d4b19ae1744932441169647374.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 10 ++++------
 drivers/media/usb/cx231xx/cx231xx-dvb.c  |  4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 8b099fe1d592..550ec932f931 100644
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
@@ -600,8 +598,8 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 			return -1;
 	}
 
-	cx231xx_coredbg("setting alternate %d with wMaxPacketSize=%u,"
-			"Interface = %d\n", alt, max_pkt_size,
+	cx231xx_coredbg("setting alternate %d with wMaxPacketSize=%u,Interface = %d\n",
+			alt, max_pkt_size,
 			usb_interface_index);
 
 	if (usb_interface_index > 0) {
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 1417515d30eb..2868546999ca 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -377,8 +377,8 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 	cfg.i2c_addr = addr;
 
 	if (!dev->dvb->frontend) {
-		dev_err(dev->dev, "%s/2: dvb frontend not attached. "
-		       "Can't attach xc5000\n", dev->name);
+		dev_err(dev->dev, "%s/2: dvb frontend not attached. Can't attach xc5000\n",
+			dev->name);
 		return -EINVAL;
 	}
 
-- 
2.7.4


