Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63527 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab3CTTYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:20 -0400
Received: by mail-ee0-f42.google.com with SMTP id b47so1307549eek.1
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:19 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 09/10] bttv: fix mute on last close of the video device node
Date: Wed, 20 Mar 2013 20:24:49 +0100
Message-Id: <1363807490-3906-10-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of applying the current mute setting on last device node close, always
mute the device.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    2 +-
 1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 2fb2168..469ea06 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3126,7 +3126,7 @@ static int bttv_release(struct file *file)
 	bttv_field_count(btv);
 
 	if (!btv->users)
-		audio_mute(btv, btv->mute);
+		audio_mute(btv, 1);
 
 	v4l2_fh_del(&fh->fh);
 	v4l2_fh_exit(&fh->fh);
-- 
1.7.10.4

