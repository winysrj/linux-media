Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33820 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3CJVxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 17:53:19 -0400
Received: by mail-ea0-f175.google.com with SMTP id o10so874259eaj.6
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 14:53:18 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH v2 3/6] bttv: fix mute on last close of the video device node
Date: Sun, 10 Mar 2013 22:53:51 +0100
Message-Id: <1362952434-2974-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    2 +-
 1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index a082ab4..945ecd2 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3124,7 +3124,7 @@ static int bttv_release(struct file *file)
 	bttv_field_count(btv);
 
 	if (!btv->users)
-		audio_mute(btv, btv->mute);
+		audio_mute(btv, 1);
 
 	v4l2_fh_del(&fh->fh);
 	v4l2_fh_exit(&fh->fh);
-- 
1.7.10.4

