Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35118 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdHMMoc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 08:44:32 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, mkrufky@linuxtv.org, eric@anholt.net,
        stefan.wahren@i2se.com, gregkh@linuxfoundation.org,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, balbi@kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 4/6] usb: gadget: make snd_pcm_hardware const
Date: Sun, 13 Aug 2017 18:13:11 +0530
Message-Id: <1502628193-3343-5-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
References: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used during a copy operation.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/usb/gadget/function/u_audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index d4caa21..3971bba 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -79,7 +79,7 @@ struct snd_uac_chip {
 	unsigned int p_framesize;
 };
 
-static struct snd_pcm_hardware uac_pcm_hardware = {
+static const struct snd_pcm_hardware uac_pcm_hardware = {
 	.info = SNDRV_PCM_INFO_INTERLEAVED | SNDRV_PCM_INFO_BLOCK_TRANSFER
 		 | SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_MMAP_VALID
 		 | SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME,
-- 
1.9.1
