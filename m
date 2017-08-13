Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33815 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbdHMMnt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 08:43:49 -0400
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
Subject: [PATCH 1/6] [media] usb: make snd_pcm_hardware const
Date: Sun, 13 Aug 2017 18:13:08 +0530
Message-Id: <1502628193-3343-2-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
References: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used during a copy operation.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c | 2 +-
 drivers/media/usb/em28xx/em28xx-audio.c   | 2 +-
 drivers/media/usb/go7007/snd-go7007.c     | 2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c    | 2 +-
 drivers/media/usb/usbtv/usbtv-audio.c     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index a050d12..06f10d7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -403,7 +403,7 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 	return 0;
 }
 
-static struct snd_pcm_hardware snd_cx231xx_hw_capture = {
+static const struct snd_pcm_hardware snd_cx231xx_hw_capture = {
 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER 	|
 	    SNDRV_PCM_INFO_MMAP 		|
 	    SNDRV_PCM_INFO_INTERLEAVED 		|
diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index ffad7f1..261620a 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -216,7 +216,7 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 	return 0;
 }
 
-static struct snd_pcm_hardware snd_em28xx_hw_capture = {
+static const struct snd_pcm_hardware snd_em28xx_hw_capture = {
 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		SNDRV_PCM_INFO_MMAP           |
 		SNDRV_PCM_INFO_INTERLEAVED    |
diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
index 070871f..c618764 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -52,7 +52,7 @@ struct go7007_snd {
 	int capturing;
 };
 
-static struct snd_pcm_hardware go7007_snd_capture_hw = {
+static const struct snd_pcm_hardware go7007_snd_capture_hw = {
 	.info			= (SNDRV_PCM_INFO_MMAP |
 					SNDRV_PCM_INFO_INTERLEAVED |
 					SNDRV_PCM_INFO_BLOCK_TRANSFER |
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index 4223225..3717a68 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -143,7 +143,7 @@ static int dsp_buffer_alloc(struct snd_pcm_substream *substream, int size)
  */
 #define DEFAULT_FIFO_SIZE	4096
 
-static struct snd_pcm_hardware snd_tm6000_digital_hw = {
+static const struct snd_pcm_hardware snd_tm6000_digital_hw = {
 	.info = SNDRV_PCM_INFO_BATCH |
 		SNDRV_PCM_INFO_MMAP |
 		SNDRV_PCM_INFO_INTERLEAVED |
diff --git a/drivers/media/usb/usbtv/usbtv-audio.c b/drivers/media/usb/usbtv/usbtv-audio.c
index 9db31db..2c2ca77 100644
--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -43,7 +43,7 @@
 
 #include "usbtv.h"
 
-static struct snd_pcm_hardware snd_usbtv_digital_hw = {
+static const struct snd_pcm_hardware snd_usbtv_digital_hw = {
 	.info = SNDRV_PCM_INFO_BATCH |
 		SNDRV_PCM_INFO_MMAP |
 		SNDRV_PCM_INFO_INTERLEAVED |
-- 
1.9.1
