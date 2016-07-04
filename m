Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53806 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbcGDIfb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/14] cx88: use wm8775_s_ctrl instead of the s_ctrl op.
Date: Mon,  4 Jul 2016 10:35:05 +0200
Message-Id: <1467621310-8203-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This op is deprecated and should not be used anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-alsa.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index e158a1d..f3f13eb 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -799,13 +799,9 @@ static int snd_cx88_alc_put(struct snd_kcontrol *kcontrol,
 {
 	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
-	struct v4l2_control client_ctl;
-
-	memset(&client_ctl, 0, sizeof(client_ctl));
-	client_ctl.value = 0 != value->value.integer.value[0];
-	client_ctl.id = V4L2_CID_AUDIO_LOUDNESS;
-	call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
 
+	wm8775_s_ctrl(core, V4L2_CID_AUDIO_LOUDNESS,
+		      value->value.integer.value[0] != 0);
 	return 0;
 }
 
-- 
2.8.1

