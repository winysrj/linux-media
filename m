Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758353Ab1F1Qbo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 12:31:44 -0400
Date: Mon, 27 Jun 2011 23:17:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 01/13] [media] v4l2-ioctl: Add a default value for kernel
 version
Message-ID: <20110627231720.32e5f14f@pedra>
In-Reply-To: <cover.1309226359.git.mchehab@redhat.com>
References: <cover.1309226359.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Most drivers don't increase kernel versions as newer features are added or
bug fixes are solved. So, vidioc_querycap returned value for cap->version is
meaningless. Instead of keeping this situation forever, let's add a default
value matching the current Linux version.

Drivers that want to keep their own version control can still do it, as they
can override the default value for cap->version.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 213ba7d..61ac6bf 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/version.h>
 
 #include <linux/videodev2.h>
 
@@ -605,6 +606,7 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_querycap)
 			break;
 
+		cap->version = LINUX_VERSION_CODE;
 		ret = ops->vidioc_querycap(file, fh, cap);
 		if (!ret)
 			dbgarg(cmd, "driver=%s, card=%s, bus=%s, "
-- 
1.7.1


