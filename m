Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4131 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3AEMJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 07:09:39 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id r05C9ZdL083223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 5 Jan 2013 13:09:37 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 58F3311E00F9
	for <linux-media@vger.kernel.org>; Sat,  5 Jan 2013 13:09:29 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [REVIEW PATCH] Fix 3.7 radio modulator regression
Date: Sat, 5 Jan 2013 13:09:29 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301051309.29506.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is a fix for a regression introduced in 3.7. If there are no comments,
then I'll post the final version early next week.

The fix was tested with radio-keene.

Regards,

	Hans

>From 86552330c91fff094a07c0018ca34a9f45362a64 Mon Sep 17 00:00:00 2001
Message-Id: <86552330c91fff094a07c0018ca34a9f45362a64.1357387528.git.hans.verkuil@cisco.com>
From: Hans Verkuil <hans.verkuil@cisco.com>
Date: Sat, 5 Jan 2013 12:52:12 +0100
Subject: [PATCH] radio: set vfl_dir correctly to fix modulator regression.

The vfl_dir field should be set to indicate whether a device can receive
data, output data or can do both. This is used to let the v4l core know
which ioctls should be accepted and which can be refused.

Unfortunately, when this field was added the radio modulator drivers were
not updated: radio modulators transmit and so vfl_dir should be set to
VFL_DIR_TX (or VFL_DIR_M2M in the special case of wl128x).

Because of this omission it is not possible to call g/s_modulator for these
drivers, which effectively renders them useless.

This patch sets the correct vfl_dir value for these drivers, correcting
this bug.

Thanks to Paul Grinberg for bringing this to my attention.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org      # for v3.7 and up
---
 drivers/media/radio/radio-keene.c       |    1 +
 drivers/media/radio/radio-si4713.c      |    1 +
 drivers/media/radio/radio-wl1273.c      |    1 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c |   10 ++++++++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index e10e525..296941a 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -374,6 +374,7 @@ static int usb_keene_probe(struct usb_interface *intf,
 	radio->vdev.ioctl_ops = &usb_keene_ioctl_ops;
 	radio->vdev.lock = &radio->lock;
 	radio->vdev.release = video_device_release_empty;
+	radio->vdev.vfl_dir = VFL_DIR_TX;
 
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index a082e40..1507c9d 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -250,6 +250,7 @@ static struct video_device radio_si4713_vdev_template = {
 	.name			= "radio-si4713",
 	.release		= video_device_release,
 	.ioctl_ops		= &radio_si4713_ioctl_ops,
+	.vfl_dir		= VFL_DIR_TX,
 };
 
 /* Platform driver interface */
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 6e55e93..8ba36c9 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1971,6 +1971,7 @@ static struct video_device wl1273_viddev_template = {
 	.ioctl_ops		= &wl1273_ioctl_ops,
 	.name			= WL1273_FM_DRIVER_NAME,
 	.release		= wl1273_vdev_release,
+	.vfl_dir		= VFL_DIR_TX,
 };
 
 static int wl1273_fm_radio_remove(struct platform_device *pdev)
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 048de45..0a8ee8f 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -518,6 +518,16 @@ static struct video_device fm_viddev_template = {
 	.ioctl_ops = &fm_drv_ioctl_ops,
 	.name = FM_DRV_NAME,
 	.release = video_device_release,
+	/*
+	 * To ensure both the tuner and modulator ioctls are accessible we
+	 * set the vfl_dir to M2M to indicate this.
+	 *
+	 * It is not really a mem2mem device of course, but it can both receive
+	 * and transmit using the same radio device. It's the only radio driver
+	 * that does this and it should really be split in two radio devices,
+	 * but that would affect applications using this driver.
+	 */
+	.vfl_dir = VFL_DIR_M2M,
 };
 
 int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
-- 
1.7.10.4

