Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:39206 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3CJLj5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 07:39:57 -0400
Received: by mail-ea0-f175.google.com with SMTP id o10so751245eaj.6
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 04:39:56 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 2/2] bttv: fix audio mute on device close for the radio device node
Date: Sun, 10 Mar 2013 12:40:35 +0100
Message-Id: <1362915635-5431-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    5 ++++-
 1 Datei geändert, 4 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 2c09bc5..74977f7 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3227,6 +3227,7 @@ static int radio_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 
 	btv->radio_user++;
+	audio_mute(btv, btv->mute);
 
 	v4l2_fh_add(&fh->fh);
 
@@ -3248,8 +3249,10 @@ static int radio_release(struct file *file)
 
 	bttv_call_all(btv, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
 
-	if (btv->radio_user == 0)
+	if (btv->radio_user == 0) {
 		btv->has_radio_tuner = 0;
+		audio_mute(btv, 1);
+	}
 	return 0;
 }
 
-- 
1.7.10.4

