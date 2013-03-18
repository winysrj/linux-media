Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1271 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3CRONA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 10:13:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 5/6] v4l2-ioctl: simplify debug code.
Date: Mon, 18 Mar 2013 15:12:04 +0100
Message-Id: <1363615925-19507-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
References: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The core debug code can now be simplified since all the write-only ioctls are
now const and will not modify the data they pass to the drivers.

So instead of logging write-only ioctls before the driver is called this can
now be done afterwards, which is cleaner when it comes to error reporting as
well.

This also fixes a logic error in the debugging code where there was one 'else'
too many.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2abd13a..b3fe148 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2147,11 +2147,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
-	if (write_only && debug > V4L2_DEBUG_IOCTL) {
-		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
-		pr_cont(": ");
-		info->debug(arg, write_only);
-	}
 	if (info->flags & INFO_FL_STD) {
 		typedef int (*vidioc_op)(struct file *file, void *fh, void *p);
 		const void *p = vfd->ioctl_ops;
@@ -2170,16 +2165,10 @@ static long __video_do_ioctl(struct file *file,
 
 done:
 	if (debug) {
-		if (write_only && debug > V4L2_DEBUG_IOCTL) {
-			if (ret < 0)
-				printk(KERN_DEBUG "%s: error %ld\n",
-					video_device_node_name(vfd), ret);
-			return ret;
-		}
 		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
 		if (ret < 0)
-			pr_cont(": error %ld\n", ret);
-		else if (debug == V4L2_DEBUG_IOCTL)
+			pr_cont(": error %ld", ret);
+		if (debug == V4L2_DEBUG_IOCTL)
 			pr_cont("\n");
 		else if (_IOC_DIR(cmd) == _IOC_NONE)
 			info->debug(arg, write_only);
-- 
1.7.10.4

