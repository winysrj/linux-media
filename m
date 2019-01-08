Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B770C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6172E20827
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977230;
	bh=gAdcduL4w429neXlretvKrzx2dABdkMYjOD3WuuevdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m5ozqYNtN5r3PyX+8qgc7pHvAQEu46jSrM1h+Ptkr/WqxlmqOiP+s/9Gp1PpZqtph
	 ickb3MHs4TTtYRrY8Hf/xKIfpE3JWjXWdwJukCJ0MPAZXsSSBwbUyNNyKXWl+huDsa
	 AIsvBJnudGfdyJ2V1K/S+16/CTWhEmo+5T2YnzF8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbfAHTax (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729891AbfAHTav (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 14:30:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B73A42070B;
        Tue,  8 Jan 2019 19:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975850;
        bh=gAdcduL4w429neXlretvKrzx2dABdkMYjOD3WuuevdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQMj2TjiaKbTpwSODUqmjZvf8FW2bN+qbwjuvSfilmZv4FBf+RGN0WaeGVG8L5dbA
         WKLzH1kBGKJu5etSMf7IHVbjb7yUUfANL0MCpymw4pNNoEcIYvBheyqah6ZtlgCTOH
         LIVcdKmd+YAVjLFogdLDFxDkcDNNb2GIfyNnI99M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Axtens <dja@axtens.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 36/97] media: uvcvideo: Refactor teardown of uvc on USB disconnect
Date:   Tue,  8 Jan 2019 14:28:45 -0500
Message-Id: <20190108192949.122407-36-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

[ Upstream commit 10e1fdb95809ed21406f53b5b4f064673a1b9ceb ]

Currently, disconnecting a USB webcam while it is in use prints out a
number of warnings, such as:

WARNING: CPU: 2 PID: 3118 at /build/linux-ezBi1T/linux-4.8.0/fs/sysfs/group.c:237 sysfs_remove_group+0x8b/0x90
sysfs group ffffffffa7cd0780 not found for kobject 'event13'

This has been noticed before. [0]

This is because of the order in which things are torn down.

If there are no streams active during a USB disconnect:

 - uvc_disconnect() is invoked via device_del() through the bus
   notifier mechanism.

 - this calls uvc_unregister_video().

 - uvc_unregister_video() unregisters the video device for each
   stream,

 - because there are no streams open, it calls uvc_delete()

 - uvc_delete() calls uvc_status_cleanup(), which cleans up the status
   input device.

 - uvc_delete() calls media_device_unregister(), which cleans up the
   media device

 - uvc_delete(), uvc_unregister_video() and uvc_disconnect() all
   return, and we end up back in device_del().

 - device_del() then cleans up the sysfs folder for the camera with
   dpm_sysfs_remove(). Because uvc_status_cleanup() and
   media_device_unregister() have already been called, this all works
   nicely.

If, on the other hand, there *are* streams active during a USB disconnect:

 - uvc_disconnect() is invoked

 - this calls uvc_unregister_video()

 - uvc_unregister_video() unregisters the video device for each
   stream,

 - uvc_unregister_video() and uvc_disconnect() return, and we end up
   back in device_del().

 - device_del() then cleans up the sysfs folder for the camera with
   dpm_sysfs_remove(). Because the status input device and the media
   device are children of the USB device, this also deletes their
   sysfs folders.

 - Sometime later, the final stream is closed, invoking uvc_release().

 - uvc_release() calls uvc_delete()

 - uvc_delete() calls uvc_status_cleanup(), which cleans up the status
   input device. Because the sysfs directory has already been removed,
   this causes a WARNing.

 - uvc_delete() calls media_device_unregister(), which cleans up the
   media device. Because the sysfs directory has already been removed,
   this causes another WARNing.

To fix this, we need to make sure the devices are always unregistered
before the end of uvc_disconnect(). To this, move the unregistration
into the disconnect path:

 - split uvc_status_cleanup() into two parts, one on disconnect that
   unregisters and one on delete that frees.

 - move v4l2_device_unregister() and media_device_unregister() into
   the disconnect path.

[0]: https://lkml.org/lkml/2016/12/8/657

[Renamed uvc_input_cleanup() to uvc_input_unregister()]

Signed-off-by: Daniel Axtens <dja@axtens.net>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 13 +++++++++----
 drivers/media/usb/uvc/uvc_status.c | 12 ++++++++----
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d46dc432456c..361abbc00486 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1824,11 +1824,7 @@ static void uvc_delete(struct kref *kref)
 	usb_put_intf(dev->intf);
 	usb_put_dev(dev->udev);
 
-	if (dev->vdev.dev)
-		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(dev->mdev.devnode))
-		media_device_unregister(&dev->mdev);
 	media_device_cleanup(&dev->mdev);
 #endif
 
@@ -1885,6 +1881,15 @@ static void uvc_unregister_video(struct uvc_device *dev)
 
 		uvc_debugfs_cleanup_stream(stream);
 	}
+
+	uvc_status_unregister(dev);
+
+	if (dev->vdev.dev)
+		v4l2_device_unregister(&dev->vdev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (media_devnode_is_registered(dev->mdev.devnode))
+		media_device_unregister(&dev->mdev);
+#endif
 }
 
 int uvc_register_video_device(struct uvc_device *dev,
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 0722dc684378..883e4cab45e7 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -54,7 +54,7 @@ static int uvc_input_init(struct uvc_device *dev)
 	return ret;
 }
 
-static void uvc_input_cleanup(struct uvc_device *dev)
+static void uvc_input_unregister(struct uvc_device *dev)
 {
 	if (dev->input)
 		input_unregister_device(dev->input);
@@ -71,7 +71,7 @@ static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
 
 #else
 #define uvc_input_init(dev)
-#define uvc_input_cleanup(dev)
+#define uvc_input_unregister(dev)
 #define uvc_input_report_key(dev, code, value)
 #endif /* CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV */
 
@@ -292,12 +292,16 @@ int uvc_status_init(struct uvc_device *dev)
 	return 0;
 }
 
-void uvc_status_cleanup(struct uvc_device *dev)
+void uvc_status_unregister(struct uvc_device *dev)
 {
 	usb_kill_urb(dev->int_urb);
+	uvc_input_unregister(dev);
+}
+
+void uvc_status_cleanup(struct uvc_device *dev)
+{
 	usb_free_urb(dev->int_urb);
 	kfree(dev->status);
-	uvc_input_cleanup(dev);
 }
 
 int uvc_status_start(struct uvc_device *dev, gfp_t flags)
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index e5f5d84f1d1d..a738486fd9d6 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -750,6 +750,7 @@ int uvc_register_video_device(struct uvc_device *dev,
 
 /* Status */
 int uvc_status_init(struct uvc_device *dev);
+void uvc_status_unregister(struct uvc_device *dev);
 void uvc_status_cleanup(struct uvc_device *dev);
 int uvc_status_start(struct uvc_device *dev, gfp_t flags);
 void uvc_status_stop(struct uvc_device *dev);
-- 
2.19.1

