Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48968 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab3CTTYT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:19 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so1306198eek.36
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:18 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 08/10] bttv: apply mute settings on open
Date: Wed, 20 Mar 2013 20:24:48 +0100
Message-Id: <1363807490-3906-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, this has been done implicitly for video device nodes by calling
set_input() (which calls audio_input() and also modified the mute
setting).
Since input and mute setting are now untangled (as much as possible), we need to
apply the mute setting with an explicit call to audio_mute().
Also apply the mute setting when the radio device node gets opened.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    3 ++-
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 55eab61..2fb2168 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3065,7 +3065,7 @@ static int bttv_open(struct file *file)
 			    fh, &btv->lock);
 	set_tvnorm(btv,btv->tvnorm);
 	set_input(btv, btv->input, btv->tvnorm);
-
+	audio_mute(btv, btv->mute);
 
 	/* The V4L2 spec requires one global set of cropping parameters
 	   which only change on request. These are stored in btv->crop[1].
@@ -3230,6 +3230,7 @@ static int radio_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 
 	btv->radio_user++;
+	audio_mute(btv, btv->mute);
 
 	v4l2_fh_add(&fh->fh);
 
-- 
1.7.10.4

