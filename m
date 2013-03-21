Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:36449 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3CURum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 13:50:42 -0400
Received: by mail-ea0-f182.google.com with SMTP id q15so1042290ead.13
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 10:50:41 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 7/8] bttv: do not unmute the device before the first open
Date: Thu, 21 Mar 2013 18:51:19 +0100
Message-Id: <1363888280-28724-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    4 +++-
 1 Datei geändert, 3 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 0df4a16..55eab61 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4212,11 +4212,13 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	btv->std = V4L2_STD_PAL;
 	init_irqreg(btv);
 	v4l2_ctrl_handler_setup(hdl);
-
 	if (hdl->error) {
 		result = hdl->error;
 		goto fail2;
 	}
+	/* mute device */
+	audio_mute(btv, 1);
+
 	/* register video4linux + input */
 	if (!bttv_tvcards[btv->c.type].no_video) {
 		v4l2_ctrl_add_handler(&btv->radio_ctrl_handler, hdl,
-- 
1.7.10.4

