Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51562 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935133AbcJRUqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 43/58] stkwebcam: don't break long lines
Date: Tue, 18 Oct 2016 18:45:55 -0200
Message-Id: <0ca3003938f37a66e4a0f3ed2480da3013827b1a.1476822925.git.mchehab@s-opensource.com>
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
 drivers/media/usb/stkwebcam/stk-sensor.c | 4 ++--
 drivers/media/usb/stkwebcam/stk-webcam.c | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-sensor.c b/drivers/media/usb/stkwebcam/stk-sensor.c
index e546b014d7ad..13ad8fdf05bb 100644
--- a/drivers/media/usb/stkwebcam/stk-sensor.c
+++ b/drivers/media/usb/stkwebcam/stk-sensor.c
@@ -391,8 +391,8 @@ int stk_sensor_init(struct stk_camera *dev)
 	}
 	stk_sensor_write_regvals(dev, ov_initvals);
 	msleep(10);
-	STK_INFO("OmniVision sensor detected, id %02X%02X"
-		" at address %x\n", idh, idl, SENSOR_ADDRESS);
+	STK_INFO("OmniVision sensor detected, id %02X%02X at address %x\n",
+		 idh, idl, SENSOR_ADDRESS);
 	return 0;
 }
 
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index db200c9d796d..267a22f24f82 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -366,8 +366,7 @@ static void stk_isoc_handler(struct urb *urb)
 			if (fb->v4lbuf.bytesused != 0
 				&& fb->v4lbuf.bytesused != dev->frame_size) {
 				(void) (printk_ratelimit() &&
-				STK_ERROR("frame %d, "
-					"bytesused=%d, skipping\n",
+				STK_ERROR("frame %d, bytesused=%d, skipping\n",
 					i, fb->v4lbuf.bytesused));
 				fb->v4lbuf.bytesused = 0;
 				fill = fb->buffer;
-- 
2.7.4


