Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60460 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaBDJCI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Feb 2014 04:02:08 -0500
Date: Tue, 04 Feb 2014 17:02:02 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Federico Simoncelli <fsimonce@redhat.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 499/499]
 drivers/media/usb/usbtv/usbtv-core.c:119:22: sparse: symbol
 'usbtv_id_table' was not declared. Should it be static?
Message-ID: <52f0ac8a.aIXONk2PY1rBXEn8%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_52f0ac8a.7ZNwzhrlGIS3BXOCezLjaawGm1ma5pjgVNBuRPTdZRMRT5iz"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_52f0ac8a.7ZNwzhrlGIS3BXOCezLjaawGm1ma5pjgVNBuRPTdZRMRT5iz
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   a3550ea665acd1922df8275379028c1634675629
commit: a3550ea665acd1922df8275379028c1634675629 [499/499] [media] usbtv: split core and video implementation
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/usbtv/usbtv-core.c:119:22: sparse: symbol 'usbtv_id_table' was not declared. Should it be static?
>> drivers/media/usb/usbtv/usbtv-core.c:129:19: sparse: symbol 'usbtv_usb_driver' was not declared. Should it be static?
--
>> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
>> drivers/media/usb/usbtv/usbtv-video.c:565:23: sparse: symbol 'usbtv_ioctl_ops' was not declared. Should it be static?
>> drivers/media/usb/usbtv/usbtv-video.c:587:29: sparse: symbol 'usbtv_fops' was not declared. Should it be static?
>> drivers/media/usb/usbtv/usbtv-video.c:648:16: sparse: symbol 'usbtv_vb2_ops' was not declared. Should it be static?

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--=_52f0ac8a.7ZNwzhrlGIS3BXOCezLjaawGm1ma5pjgVNBuRPTdZRMRT5iz
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-a3550ea665acd1922df8275379028c1634675629.diff"

From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH linuxtv-media] usbtv: usbtv_id_table[] can be static
TO: Federico Simoncelli <fsimonce@redhat.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: linux-media@vger.kernel.org 
CC: linux-kernel@vger.kernel.org 

CC: Federico Simoncelli <fsimonce@redhat.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 usbtv-core.c  |    4 ++--
 usbtv-video.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index e89e48b..2dd47e0 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -116,7 +116,7 @@ static void usbtv_disconnect(struct usb_interface *intf)
 	v4l2_device_put(&usbtv->v4l2_dev);
 }
 
-struct usb_device_id usbtv_id_table[] = {
+static struct usb_device_id usbtv_id_table[] = {
 	{ USB_DEVICE(0x1b71, 0x3002) },
 	{}
 };
@@ -126,7 +126,7 @@ MODULE_AUTHOR("Lubomir Rintel");
 MODULE_DESCRIPTION("Fushicai USBTV007 Video Grabber Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 
-struct usb_driver usbtv_usb_driver = {
+static struct usb_driver usbtv_usb_driver = {
 	.name = "usbtv",
 	.id_table = usbtv_id_table,
 	.probe = usbtv_probe,
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 496bc2e..029ea7c 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -562,7 +562,7 @@ static int usbtv_s_input(struct file *file, void *priv, unsigned int i)
 	return usbtv_select_input(usbtv, i);
 }
 
-struct v4l2_ioctl_ops usbtv_ioctl_ops = {
+static struct v4l2_ioctl_ops usbtv_ioctl_ops = {
 	.vidioc_querycap = usbtv_querycap,
 	.vidioc_enum_input = usbtv_enum_input,
 	.vidioc_enum_fmt_vid_cap = usbtv_enum_fmt_vid_cap,
@@ -584,7 +584,7 @@ struct v4l2_ioctl_ops usbtv_ioctl_ops = {
 	.vidioc_streamoff = vb2_ioctl_streamoff,
 };
 
-struct v4l2_file_operations usbtv_fops = {
+static struct v4l2_file_operations usbtv_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = video_ioctl2,
 	.mmap = vb2_fop_mmap,
@@ -645,7 +645,7 @@ static int usbtv_stop_streaming(struct vb2_queue *vq)
 	return 0;
 }
 
-struct vb2_ops usbtv_vb2_ops = {
+static struct vb2_ops usbtv_vb2_ops = {
 	.queue_setup = usbtv_queue_setup,
 	.buf_queue = usbtv_buf_queue,
 	.start_streaming = usbtv_start_streaming,

--=_52f0ac8a.7ZNwzhrlGIS3BXOCezLjaawGm1ma5pjgVNBuRPTdZRMRT5iz--
