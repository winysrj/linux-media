Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59409 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3CJVxU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 17:53:20 -0400
Received: by mail-ea0-f169.google.com with SMTP id z7so878368eaf.14
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 14:53:19 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH v2 4/6] bttv: do not unmute the device before the first open
Date: Sun, 10 Mar 2013 22:53:52 +0100
Message-Id: <1362952434-2974-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    8 +++++---
 1 Datei geändert, 5 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 945ecd2..6432bfe 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3062,8 +3062,7 @@ static int bttv_open(struct file *file)
 			    sizeof(struct bttv_buffer),
 			    fh, &btv->lock);
 	set_tvnorm(btv,btv->tvnorm);
-	set_input(btv, btv->input, btv->tvnorm);
-
+	set_input(btv, btv->input, btv->tvnorm); /* also (un)mutes audio */
 
 	/* The V4L2 spec requires one global set of cropping parameters
 	   which only change on request. These are stored in btv->crop[1].
@@ -4209,11 +4208,14 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	btv->std = V4L2_STD_PAL;
 	init_irqreg(btv);
 	v4l2_ctrl_handler_setup(hdl);
-
 	if (hdl->error) {
 		result = hdl->error;
 		goto fail2;
 	}
+
+	/* mute device */
+	audio_mute(btv, 1);
+
 	/* register video4linux + input */
 	if (!bttv_tvcards[btv->c.type].no_video) {
 		v4l2_ctrl_add_handler(&btv->radio_ctrl_handler, hdl,
-- 
1.7.10.4

