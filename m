Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41486 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2KSSer (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:34:47 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 375/493] media: remove use of __devinitconst
Date: Mon, 19 Nov 2012 13:25:24 -0500
Message-Id: <1353349642-3677-375-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinitconst is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: linux-media@vger.kernel.org 
---
 drivers/media/mmc/siano/smssdio.c  | 2 +-
 drivers/media/platform/timblogiw.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/mmc/siano/smssdio.c b/drivers/media/mmc/siano/smssdio.c
index 0a61bc6..15d3493 100644
--- a/drivers/media/mmc/siano/smssdio.c
+++ b/drivers/media/mmc/siano/smssdio.c
@@ -50,7 +50,7 @@
 #define SMSSDIO_INT		0x04
 #define SMSSDIO_BLOCK_SIZE	128
 
-static const struct sdio_device_id smssdio_ids[] __devinitconst = {
+static const struct sdio_device_id smssdio_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, SDIO_DEVICE_ID_SIANO_STELLAR),
 	 .driver_data = SMS1XXX_BOARD_SIANO_STELLAR},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, SDIO_DEVICE_ID_SIANO_NOVA_A0),
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 574b2dd..384d2cc 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -745,7 +745,7 @@ static int timblogiw_mmap(struct file *file, struct vm_area_struct *vma)
 
 /* Platform device functions */
 
-static __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
+static struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
 	.vidioc_querycap		= timblogiw_querycap,
 	.vidioc_enum_fmt_vid_cap	= timblogiw_enum_fmt,
 	.vidioc_g_fmt_vid_cap		= timblogiw_g_fmt,
@@ -767,7 +767,7 @@ static __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
 	.vidioc_enum_framesizes		= timblogiw_enum_framesizes,
 };
 
-static __devinitconst struct v4l2_file_operations timblogiw_fops = {
+static struct v4l2_file_operations timblogiw_fops = {
 	.owner		= THIS_MODULE,
 	.open		= timblogiw_open,
 	.release	= timblogiw_close,
@@ -777,7 +777,7 @@ static __devinitconst struct v4l2_file_operations timblogiw_fops = {
 	.poll		= timblogiw_poll,
 };
 
-static __devinitconst struct video_device timblogiw_template = {
+static struct video_device timblogiw_template = {
 	.name		= TIMBLOGIWIN_NAME,
 	.fops		= &timblogiw_fops,
 	.ioctl_ops	= &timblogiw_ioctl_ops,
-- 
1.8.0

