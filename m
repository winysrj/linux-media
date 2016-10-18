Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51580 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935154AbcJRUqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 22/58] marvell-ccic: don't break long lines
Date: Tue, 18 Oct 2016 18:45:34 -0200
Message-Id: <4d5302fb158e1e2c2cafbf69c63bb70be7997f9a.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/platform/marvell-ccic/mcam-core.c | 26 +++++++------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index af59bf4dca2d..a8bda6679422 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -49,24 +49,17 @@
 static bool alloc_bufs_at_read;
 module_param(alloc_bufs_at_read, bool, 0444);
 MODULE_PARM_DESC(alloc_bufs_at_read,
-		"Non-zero value causes DMA buffers to be allocated when the "
-		"video capture device is read, rather than at module load "
-		"time.  This saves memory, but decreases the chances of "
-		"successfully getting those buffers.  This parameter is "
-		"only used in the vmalloc buffer mode");
+		"Non-zero value causes DMA buffers to be allocated when the video capture device is read, rather than at module load time.  This saves memory, but decreases the chances of successfully getting those buffers.  This parameter is only used in the vmalloc buffer mode");
 
 static int n_dma_bufs = 3;
 module_param(n_dma_bufs, uint, 0644);
 MODULE_PARM_DESC(n_dma_bufs,
-		"The number of DMA buffers to allocate.  Can be either two "
-		"(saves memory, makes timing tighter) or three.");
+		"The number of DMA buffers to allocate.  Can be either two (saves memory, makes timing tighter) or three.");
 
 static int dma_buf_size = VGA_WIDTH * VGA_HEIGHT * 2;  /* Worst case */
 module_param(dma_buf_size, uint, 0444);
 MODULE_PARM_DESC(dma_buf_size,
-		"The size of the allocated DMA buffers.  If actual operating "
-		"parameters require larger buffers, an attempt to reallocate "
-		"will be made.");
+		"The size of the allocated DMA buffers.  If actual operating parameters require larger buffers, an attempt to reallocate will be made.");
 #else /* MCAM_MODE_VMALLOC */
 static const bool alloc_bufs_at_read;
 static const int n_dma_bufs = 3;  /* Used by S/G_PARM */
@@ -75,15 +68,12 @@ static const int n_dma_bufs = 3;  /* Used by S/G_PARM */
 static bool flip;
 module_param(flip, bool, 0444);
 MODULE_PARM_DESC(flip,
-		"If set, the sensor will be instructed to flip the image "
-		"vertically.");
+		"If set, the sensor will be instructed to flip the image vertically.");
 
 static int buffer_mode = -1;
 module_param(buffer_mode, int, 0444);
 MODULE_PARM_DESC(buffer_mode,
-		"Set the buffer mode to be used; default is to go with what "
-		"the platform driver asks for.  Set to 0 for vmalloc, 1 for "
-		"DMA contiguous.");
+		"Set the buffer mode to be used; default is to go with what the platform driver asks for.  Set to 0 for vmalloc, 1 for DMA contiguous.");
 
 /*
  * Status flags.  Always manipulated with bit operations.
@@ -1759,8 +1749,7 @@ int mccic_register(struct mcam_camera *cam)
 		cam->buffer_mode = buffer_mode;
 	if (cam->buffer_mode == B_DMA_sg &&
 			cam->chip_id == MCAM_CAFE) {
-		printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O, "
-			"attempting vmalloc mode instead\n");
+		printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O, attempting vmalloc mode instead\n");
 		cam->buffer_mode = B_vmalloc;
 	}
 	if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
@@ -1828,8 +1817,7 @@ int mccic_register(struct mcam_camera *cam)
 	 */
 	if (cam->buffer_mode == B_vmalloc && !alloc_bufs_at_read) {
 		if (mcam_alloc_dma_bufs(cam, 1))
-			cam_warn(cam, "Unable to alloc DMA buffers at load"
-					" will try again later.");
+			cam_warn(cam, "Unable to alloc DMA buffers at load will try again later.");
 	}
 
 	mutex_unlock(&cam->s_mutex);
-- 
2.7.4


