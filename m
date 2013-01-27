Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:59853 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3A0Tpi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 14:45:38 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/7] saa7134: v4l2-compliance: don't report invalid audio modes for radio
Date: Sun, 27 Jan 2013 20:45:07 +0100
Message-Id: <1359315912-1767-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: filter audio modes that came from
tuner - keep only MONO/STEREO in radio mode

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index ce15f1f..db8da32 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2333,6 +2333,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 	t->type = V4L2_TUNER_RADIO;
 
 	saa_call_all(dev, tuner, g_tuner, t);
+	t->audmode &= V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO;
 	if (dev->input->amux == TV) {
 		t->signal = 0xf800 - ((saa_readb(0x581) & 0x1f) << 11);
 		t->rxsubchans = (saa_readb(0x529) & 0x08) ?
-- 
Ondrej Zary

