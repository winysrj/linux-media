Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51482 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934325AbcJRUqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH v2 32/58] b2c2: don't break long lines
Date: Tue, 18 Oct 2016 18:45:44 -0200
Message-Id: <b30d41a26b3c2189aaa281d9c9a8ed6f61c2d23a.1476822925.git.mchehab@s-opensource.com>
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
 drivers/media/usb/b2c2/flexcop-usb.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index d4bdba60b0f7..086afe25df76 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -33,8 +33,7 @@
 
 static int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info,ts=2,"
-		"ctrl=4,i2c=8,v8mem=16 (or-able))." DEBSTATUS);
+MODULE_PARM_DESC(debug, "set debugging level (1=info,ts=2,ctrl=4,i2c=8,v8mem=16 (or-able))." DEBSTATUS);
 #undef DEBSTATUS
 
 #define deb_info(args...) dprintk(0x01, args)
@@ -403,8 +402,8 @@ static int flexcop_usb_transfer_init(struct flexcop_usb *fc_usb)
 		frame_size, i, j, ret;
 	int buffer_offset = 0;
 
-	deb_ts("creating %d iso-urbs with %d frames "
-			"each of %d bytes size = %d.\n", B2C2_USB_NUM_ISO_URB,
+	deb_ts("creating %d iso-urbs with %d frames each of %d bytes size = %d.\n",
+	       B2C2_USB_NUM_ISO_URB,
 			B2C2_USB_FRAMES_PER_ISO, frame_size, bufsize);
 
 	fc_usb->iso_buffer = usb_alloc_coherent(fc_usb->udev,
@@ -429,8 +428,8 @@ static int flexcop_usb_transfer_init(struct flexcop_usb *fc_usb)
 	for (i = 0; i < B2C2_USB_NUM_ISO_URB; i++) {
 		int frame_offset = 0;
 		struct urb *urb = fc_usb->iso_urb[i];
-		deb_ts("initializing and submitting urb no. %d "
-			"(buf_offset: %d).\n", i, buffer_offset);
+		deb_ts("initializing and submitting urb no. %d (buf_offset: %d).\n",
+		       i, buffer_offset);
 
 		urb->dev = fc_usb->udev;
 		urb->context = fc_usb;
-- 
2.7.4


