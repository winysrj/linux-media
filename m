Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39485 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3AVTv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 14:51:28 -0500
Received: by mail-wg0-f51.google.com with SMTP id 8so2915040wgl.6
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 11:51:27 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] v4l2-core: do not enable the buffer ioctls for radio devices
Date: Tue, 22 Jan 2013 20:51:55 +0100
Message-Id: <1358884315-2810-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The buffer ioctls (VIDIOC_REQBUFS, VIDIOC_QUERYBUF, VIDIOC_QBUF, VIDIOC_DQBUF,
VIDIOC_EXPBUF, VIDIOC_CREATE_BUFS, VIDIOC_PREPARE_BUF) are not applicable for
radio devices. Hence, they should be set valid only for non-radio devices in
determine_valid_ioctls().

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/v4l2-core/v4l2-dev.c |   14 +++++++-------
 1 Datei geändert, 7 Zeilen hinzugefügt(+), 7 Zeilen entfernt(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 98dcad9..51b3a77 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -568,11 +568,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	if (ops->vidioc_s_priority ||
 			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
 		set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
-	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
-	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
-	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
-	SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
-	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
 	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
 	/* Note: the control handler can also be passed through the filehandle,
@@ -605,8 +600,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
-	SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
-	SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
 	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
 		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
 
@@ -672,6 +665,13 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	}
 	if (!is_radio) {
 		/* ioctls valid for video or vbi */
+		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
+		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
+		SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
+		SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
 		if (ops->vidioc_s_std)
 			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
 		if (ops->vidioc_g_std || vdev->current_norm)
-- 
1.7.10.4

