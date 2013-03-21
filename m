Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38787 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3CURun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 13:50:43 -0400
Received: by mail-ee0-f51.google.com with SMTP id d17so1850557eek.24
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 10:50:42 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 8/8] bttv: apply mute settings on open
Date: Thu, 21 Mar 2013 18:51:20 +0100
Message-Id: <1363888280-28724-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
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
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
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

