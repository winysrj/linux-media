Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0IPBAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 21:00:08 -0400
Date: Wed, 15 Sep 2010 21:56:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/8] V4L/DVB: bttv: use unlocked ioctl
Message-ID: <20100915215638.22c3a6cb@pedra>
In-Reply-To: <cover.1284597566.git.mchehab@redhat.com>
References: <cover.1284597566.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 5f5cd4a..8d1b222 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3419,13 +3419,13 @@ bttv_mmap(struct file *file, struct vm_area_struct *vma)
 
 static const struct v4l2_file_operations bttv_fops =
 {
-	.owner	  = THIS_MODULE,
-	.open	  = bttv_open,
-	.release  = bttv_release,
-	.ioctl	  = video_ioctl2,
-	.read	  = bttv_read,
-	.mmap	  = bttv_mmap,
-	.poll     = bttv_poll,
+	.owner		  = THIS_MODULE,
+	.open		  = bttv_open,
+	.release	  = bttv_release,
+	.unlocked_ioctl	  = video_ioctl2,
+	.read		  = bttv_read,
+	.mmap		  = bttv_mmap,
+	.poll		  = bttv_poll,
 };
 
 static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
-- 
1.7.1


