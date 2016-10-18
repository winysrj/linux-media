Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51479 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934306AbcJRUqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 13/58] meye: don't break long lines
Date: Tue, 18 Oct 2016 18:45:25 -0200
Message-Id: <efed5f2ab76e9688b5ddaa5cb2246237c0039834.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/pci/meye/meye.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index ba887e8e1b17..11d81389ab1e 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -60,8 +60,7 @@ MODULE_PARM_DESC(gbuffers, "number of capture buffers, default is 2 (32 max)");
 /* size of a grab buffer */
 static unsigned int gbufsize = MEYE_MAX_BUFSIZE;
 module_param(gbufsize, int, 0444);
-MODULE_PARM_DESC(gbufsize, "size of the capture buffers, default is 614400"
-		 " (will be rounded up to a page multiple)");
+MODULE_PARM_DESC(gbufsize, "size of the capture buffers, default is 614400 (will be rounded up to a page multiple)");
 
 /* /dev/videoX registration number */
 static int video_nr = -1;
@@ -1261,8 +1260,7 @@ static int vidioc_reqbufs(struct file *file, void *fh,
 	meye.grab_fbuffer = rvmalloc(gbuffers * gbufsize);
 
 	if (!meye.grab_fbuffer) {
-		printk(KERN_ERR "meye: v4l framebuffer allocation"
-				" failed\n");
+		printk(KERN_ERR "meye: v4l framebuffer allocation failed\n");
 		mutex_unlock(&meye.lock);
 		return -ENOMEM;
 	}
@@ -1659,8 +1657,7 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	ret = -EIO;
 	if ((ret = sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 1))) {
 		v4l2_err(v4l2_dev, "meye: unable to power on the camera\n");
-		v4l2_err(v4l2_dev, "meye: did you enable the camera in "
-				"sonypi using the module options ?\n");
+		v4l2_err(v4l2_dev, "meye: did you enable the camera in sonypi using the module options ?\n");
 		goto outsonypienable;
 	}
 
@@ -1834,8 +1831,7 @@ static int __init meye_init(void)
 	if (gbufsize > MEYE_MAX_BUFSIZE)
 		gbufsize = MEYE_MAX_BUFSIZE;
 	gbufsize = PAGE_ALIGN(gbufsize);
-	printk(KERN_INFO "meye: using %d buffers with %dk (%dk total) "
-			 "for capture\n",
+	printk(KERN_INFO "meye: using %d buffers with %dk (%dk total) for capture\n",
 			 gbuffers,
 			 gbufsize / 1024, gbuffers * gbufsize / 1024);
 	return pci_register_driver(&meye_driver);
-- 
2.7.4


