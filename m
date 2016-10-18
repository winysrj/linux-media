Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51577 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935137AbcJRUqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH v2 41/58] pwc: don't break long lines
Date: Tue, 18 Oct 2016 18:45:53 -0200
Message-Id: <a15b62dccdbada04c01f966593f07357da8affc6.1476822925.git.mchehab@s-opensource.com>
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
 drivers/media/usb/pwc/pwc-if.c  | 4 ++--
 drivers/media/usb/pwc/pwc-v4l.c | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index ff657644b6b3..22420c14ac98 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -238,8 +238,8 @@ static void pwc_frame_complete(struct pwc_device *pdev)
 	} else {
 		/* Check for underflow first */
 		if (fbuf->filled < pdev->frame_total_size) {
-			PWC_DEBUG_FLOW("Frame buffer underflow (%d bytes);"
-				       " discarded.\n", fbuf->filled);
+			PWC_DEBUG_FLOW("Frame buffer underflow (%d bytes); discarded.\n",
+				       fbuf->filled);
 		} else {
 			fbuf->vb.field = V4L2_FIELD_NONE;
 			fbuf->vb.sequence = pdev->vframe_count;
diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index 3d987984602f..92f04db6bbae 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -406,8 +406,7 @@ static void pwc_vidioc_fill_fmt(struct v4l2_format *f,
 	f->fmt.pix.bytesperline = f->fmt.pix.width;
 	f->fmt.pix.sizeimage	= f->fmt.pix.height * f->fmt.pix.width * 3 / 2;
 	f->fmt.pix.colorspace	= V4L2_COLORSPACE_SRGB;
-	PWC_DEBUG_IOCTL("pwc_vidioc_fill_fmt() "
-			"width=%d, height=%d, bytesperline=%d, sizeimage=%d, pixelformat=%c%c%c%c\n",
+	PWC_DEBUG_IOCTL("pwc_vidioc_fill_fmt() width=%d, height=%d, bytesperline=%d, sizeimage=%d, pixelformat=%c%c%c%c\n",
 			f->fmt.pix.width,
 			f->fmt.pix.height,
 			f->fmt.pix.bytesperline,
@@ -473,8 +472,7 @@ static int pwc_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f)
 
 	pixelformat = f->fmt.pix.pixelformat;
 
-	PWC_DEBUG_IOCTL("Trying to set format to: width=%d height=%d fps=%d "
-			"format=%c%c%c%c\n",
+	PWC_DEBUG_IOCTL("Trying to set format to: width=%d height=%d fps=%d format=%c%c%c%c\n",
 			f->fmt.pix.width, f->fmt.pix.height, pdev->vframes,
 			(pixelformat)&255,
 			(pixelformat>>8)&255,
-- 
2.7.4


