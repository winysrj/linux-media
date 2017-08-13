Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38348 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbdHMMoD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 08:44:03 -0400
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
Subject: [PATCH 2/6] [media] pci: make snd_pcm_hardware const
Date: Sun, 13 Aug 2017 18:13:09 +0530
Message-Id: <1502628193-3343-3-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
References: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used during a copy operation.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c | 4 ++--
 drivers/media/pci/cx18/cx18-alsa-pcm.c     | 2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c   | 2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c   | 2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c     | 2 +-
 drivers/media/pci/saa7134/saa7134-alsa.c   | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
index 49013c6..b69b258 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
@@ -43,7 +43,7 @@
 			pr_info("cobalt-alsa-pcm %s: " fmt, __func__, ##arg); \
 	} while (0)
 
-static struct snd_pcm_hardware snd_cobalt_hdmi_capture = {
+static const struct snd_pcm_hardware snd_cobalt_hdmi_capture = {
 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		SNDRV_PCM_INFO_MMAP           |
 		SNDRV_PCM_INFO_INTERLEAVED    |
@@ -64,7 +64,7 @@
 	.periods_max = 4,
 };
 
-static struct snd_pcm_hardware snd_cobalt_playback = {
+static const struct snd_pcm_hardware snd_cobalt_playback = {
 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		SNDRV_PCM_INFO_MMAP           |
 		SNDRV_PCM_INFO_INTERLEAVED    |
diff --git a/drivers/media/pci/cx18/cx18-alsa-pcm.c b/drivers/media/pci/cx18/cx18-alsa-pcm.c
index f68ee57..aadd764 100644
--- a/drivers/media/pci/cx18/cx18-alsa-pcm.c
+++ b/drivers/media/pci/cx18/cx18-alsa-pcm.c
@@ -44,7 +44,7 @@
 				  __func__, ##arg); 			\
 	} while (0)
 
-static struct snd_pcm_hardware snd_cx18_hw_capture = {
+static const struct snd_pcm_hardware snd_cx18_hw_capture = {
 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		SNDRV_PCM_INFO_MMAP           |
 		SNDRV_PCM_INFO_INTERLEAVED    |
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index c148f9a..d8c3637 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -293,7 +293,7 @@ static int dsp_buffer_free(struct cx23885_audio_dev *chip)
  */
 #define DEFAULT_FIFO_SIZE	4096
 
-static struct snd_pcm_hardware snd_cx23885_digital_hw = {
+static const struct snd_pcm_hardware snd_cx23885_digital_hw = {
 	.info = SNDRV_PCM_INFO_MMAP |
 		SNDRV_PCM_INFO_INTERLEAVED |
 		SNDRV_PCM_INFO_BLOCK_TRANSFER |
diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 519b81c..2b34990 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -428,7 +428,7 @@ static int dsp_buffer_free(struct cx25821_audio_dev *chip)
  * Digital hardware definition
  */
 #define DEFAULT_FIFO_SIZE	384
-static struct snd_pcm_hardware snd_cx25821_digital_hw = {
+static const struct snd_pcm_hardware snd_cx25821_digital_hw = {
 	.info = SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_INTERLEAVED |
 		SNDRV_PCM_INFO_BLOCK_TRANSFER | SNDRV_PCM_INFO_MMAP_VALID,
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index 417d03d..5326d86 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -41,7 +41,7 @@
 			pr_info("ivtv-alsa-pcm %s: " fmt, __func__, ##arg); \
 	} while (0)
 
-static struct snd_pcm_hardware snd_ivtv_hw_capture = {
+static const struct snd_pcm_hardware snd_ivtv_hw_capture = {
 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		SNDRV_PCM_INFO_MMAP           |
 		SNDRV_PCM_INFO_INTERLEAVED    |
diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index bf358ec..c59b69f 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -627,7 +627,7 @@ static int snd_card_saa7134_capture_prepare(struct snd_pcm_substream * substream
  *    switching to 32kHz without any frequency translation
  */
 
-static struct snd_pcm_hardware snd_card_saa7134_capture =
+static const struct snd_pcm_hardware snd_card_saa7134_capture =
 {
 	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_INTERLEAVED |
 				 SNDRV_PCM_INFO_BLOCK_TRANSFER |
-- 
1.9.1
