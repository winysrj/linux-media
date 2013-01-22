Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40908 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3AVTqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 14:46:07 -0500
Received: by mail-wg0-f41.google.com with SMTP id ds1so2020018wgb.2
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 11:46:05 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, fschaefer.oss@googlemail.com
Subject: [PATCH] tuner-core: return tuner name with ioctl VIDIOC_G_TUNER
Date: Tue, 22 Jan 2013 20:46:21 +0100
Message-Id: <1358883981-2645-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tuner_g_tuner() is supposed to fill struct v4l2_tuner passed by ioctl
VIDIOC_G_TUNER, but misses setting the name field.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: stable@kernel.org
---
 drivers/media/v4l2-core/tuner-core.c |    1 +
 1 Datei geändert, 1 Zeile hinzugefügt(+)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index b5a819a..95a47cf 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -1187,6 +1187,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 
 	if (check_mode(t, vt->type) == -EINVAL)
 		return 0;
+	strcpy(vt->name, t->name);
 	if (vt->type == t->mode && analog_ops->get_afc)
 		vt->afc = analog_ops->get_afc(&t->fe);
 	if (analog_ops->has_signal)
-- 
1.7.10.4

