Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393Ab2J0UnF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:43:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 14/68] [media] ivtv: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:32 -0200
Message-Id: <1351370486-29040-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/ivtv/ivtv-alsa-main.c:208:5: warning: no previous prototype for 'ivtv_alsa_load' [-Wmissing-prototypes]
drivers/media/pci/ivtv/ivtv-alsa-pcm.c:325:5: warning: no previous prototype for 'snd_ivtv_pcm_create' [-Wmissing-prototypes]
drivers/media/pci/ivtv/ivtv-alsa-pcm.c:72:6: warning: no previous prototype for 'ivtv_alsa_announce_pcm_data' [-Wmissing-prototypes]
drivers/media/pci/ivtv/ivtv-firmware.c:279:5: warning: no previous prototype for 'ivtv_firmware_restart' [-Wmissing-prototypes]
drivers/media/pci/ivtv/ivtv-ioctl.c:1171:5: warning: no previous prototype for 'ivtv_s_std' [-Wmissing-prototypes]

Cc: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c | 2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c  | 6 ++++--
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h  | 4 ----
 drivers/media/pci/ivtv/ivtv-firmware.c  | 2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c     | 2 +-
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 8deab16..4a221c6 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -205,7 +205,7 @@ err_exit:
 	return ret;
 }
 
-int ivtv_alsa_load(struct ivtv *itv)
+static int __init ivtv_alsa_load(struct ivtv *itv)
 {
 	struct v4l2_device *v4l2_dev = &itv->v4l2_dev;
 	struct ivtv_stream *s;
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index f7022bd..e1863db 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -37,6 +37,7 @@
 #include "ivtv-streams.h"
 #include "ivtv-fileops.h"
 #include "ivtv-alsa.h"
+#include "ivtv-alsa-pcm.h"
 
 static unsigned int pcm_debug;
 module_param(pcm_debug, int, 0644);
@@ -69,8 +70,9 @@ static struct snd_pcm_hardware snd_ivtv_hw_capture = {
 	.periods_max = 98,		/* 12544, */
 };
 
-void ivtv_alsa_announce_pcm_data(struct snd_ivtv_card *itvsc, u8 *pcm_data,
-				 size_t num_bytes)
+static void ivtv_alsa_announce_pcm_data(struct snd_ivtv_card *itvsc,
+					u8 *pcm_data,
+					size_t num_bytes)
 {
 	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime *runtime;
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.h b/drivers/media/pci/ivtv/ivtv-alsa-pcm.h
index 5ab1831..23dfe0d 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.h
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.h
@@ -21,7 +21,3 @@
  */
 
 int __init snd_ivtv_pcm_create(struct snd_ivtv_card *itvsc);
-
-/* Used by ivtv driver to announce the PCM data to the module */
-void ivtv_alsa_announce_pcm_data(struct snd_ivtv_card *card, u8 *pcm_data,
-				 size_t num_bytes);
diff --git a/drivers/media/pci/ivtv/ivtv-firmware.c b/drivers/media/pci/ivtv/ivtv-firmware.c
index 6ec7705..68387d4 100644
--- a/drivers/media/pci/ivtv/ivtv-firmware.c
+++ b/drivers/media/pci/ivtv/ivtv-firmware.c
@@ -276,7 +276,7 @@ void ivtv_init_mpeg_decoder(struct ivtv *itv)
 }
 
 /* Try to restart the card & restore previous settings */
-int ivtv_firmware_restart(struct ivtv *itv)
+static int ivtv_firmware_restart(struct ivtv *itv)
 {
 	int rc = 0;
 	v4l2_std_id std;
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 949ae23..31a69eb 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1168,7 +1168,7 @@ void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id *std)
 	}
 }
 
-int ivtv_s_std(struct file *file, void *fh, v4l2_std_id *std)
+static int ivtv_s_std(struct file *file, void *fh, v4l2_std_id *std)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
 
-- 
1.7.11.7

