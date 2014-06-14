Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaFNQQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 12:16:27 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] sound: Add a quirk to enforce period_bytes
Date: Sat, 14 Jun 2014 13:16:09 -0300
Message-Id: <1402762571-6316-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Auvitek 0828 chip, used on HVR950Q actually need two
quirks and not just one.

The first one, already implemented, enforces that it won't have
channel swaps at the transfers.

However, for TV applications, like xawtv and tvtime, another quirk
is needed, in order to enforce that, at least 2 URB transfer
intervals will be needed to fill a buffer. Without it, buffer
underruns happen when trying to syncronize the audio input from
au0828 and the audio playback at the default audio output device.

As the second quirk may be needed by some other media devices
not based on au0828 chipset, keep it as a separate quirk.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 sound/usb/card.h         |  1 +
 sound/usb/pcm.c          | 34 ++++++++++++++++++++++++++++++++++
 sound/usb/quirks-table.h | 18 +++++++++---------
 sound/usb/quirks.c       | 14 ++++++++++----
 sound/usb/stream.c       |  1 +
 sound/usb/usbaudio.h     |  3 ++-
 6 files changed, 57 insertions(+), 14 deletions(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 97acb906acc2..f6f2c7ca6ed4 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -122,6 +122,7 @@ struct snd_usb_substream {
 	unsigned int buffer_periods;	/* current periods per buffer */
 	unsigned int altset_idx;     /* USB data format: index of alternate setting */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
+	unsigned int media_sync_quirk:1;/* Enforce a min period_bytes big enough to handle 2 URB transfer periods */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
 	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
 
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index c62a1659106d..e4a215b63d9f 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1102,6 +1102,8 @@ static int setup_hw_info(struct snd_pcm_runtime *runtime, struct snd_usb_substre
 	unsigned int pt, ptmin;
 	int param_period_time_if_needed;
 	int err;
+	size_t period_bytes_min = UINT_MAX;
+	size_t period_bytes_max = 0;
 
 	runtime->hw.formats = subs->formats;
 
@@ -1129,7 +1131,39 @@ static int setup_hw_info(struct snd_pcm_runtime *runtime, struct snd_usb_substre
 		}
 		pt = 125 * (1 << fp->datainterval);
 		ptmin = min(ptmin, pt);
+
+		if (subs->media_sync_quirk) {
+			size_t period, min_period, max_period;
+
+			/*
+			 * multimedia streams have both Audio and Video
+			 * URBs and limited contraints with regards to
+			 * the period size. Also, their stream will be
+			 * most likely synked with the playback card with
+			 * different constraints.
+			 * Due to that, we need to be sure that, at least
+			 * 2 URB transfers will be needed to fill a period,
+			 * in order to avoid buffer underruns on applications
+			 * like tvtime and xawtv.
+			 * A non-multiple of period_bytes_min can also be
+			 * a problem, so the best is to also enfoce it.
+			 */
+			period = 2 * MAX_URBS * fp->maxpacksize;
+			min_period = period * 90 / 100;
+			max_period = period * 110 / 100;
+
+			if (period_bytes_min > min_period)
+				period_bytes_min = min_period;
+			if (period_bytes_max < max_period)
+				period_bytes_max = max_period;
+		}
 	}
+
+	if (period_bytes_min != UINT_MAX && period_bytes_max != 0) {
+		runtime->hw.period_bytes_min = period_bytes_min;
+		runtime->hw.period_bytes_max = period_bytes_max;
+	}
+
 	err = snd_usb_autoresume(subs->stream->chip);
 	if (err < 0)
 		return err;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index f652b10ce905..236adf61d27a 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2757,7 +2757,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 {
@@ -2771,7 +2771,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 {
@@ -2785,7 +2785,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 {
@@ -2799,7 +2799,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 {
@@ -2813,7 +2813,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 {
@@ -2827,7 +2827,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 {
@@ -2841,7 +2841,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-850",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 {
@@ -2855,7 +2855,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 {
@@ -2869,7 +2869,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.vendor_name = "Hauppauge",
 		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+		.type = QUIRK_AUDIO_AUVITEK_0828,
 	}
 },
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 7c57f2268dd7..fea68eef5bdb 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -74,15 +74,21 @@ static int ignore_interface_quirk(struct snd_usb_audio *chip,
 
 
 /*
- * Allow alignment on audio sub-slot (channel samples) rather than
- * on audio slots (audio frames)
+ * There are actually two quirks needed by Auvitek 0828 audio:
+ *
+ * 1) Allow alignment on audio sub-slot (channel samples) rather than
+ *    on audio slots (audio frames), enabled via chip->txfr_quirk
+ *
+ * 2) Enforce that the minimum period_bytes will be able to store,
+ *    at least, 2 URB transfer intervals.
  */
-static int create_align_transfer_quirk(struct snd_usb_audio *chip,
+static int create_auvitek_0828_quirk(struct snd_usb_audio *chip,
 				       struct usb_interface *iface,
 				       struct usb_driver *driver,
 				       const struct snd_usb_audio_quirk *quirk)
 {
 	chip->txfr_quirk = 1;
+	chip->media_sync_quirk = 1;
 	return 1;	/* Continue with creating streams and mixer */
 }
 
@@ -529,7 +535,7 @@ int snd_usb_create_quirk(struct snd_usb_audio *chip,
 		[QUIRK_AUDIO_STANDARD_INTERFACE] = create_standard_audio_quirk,
 		[QUIRK_AUDIO_FIXED_ENDPOINT] = create_fixed_stream_quirk,
 		[QUIRK_AUDIO_EDIROL_UAXX] = create_uaxx_quirk,
-		[QUIRK_AUDIO_ALIGN_TRANSFER] = create_align_transfer_quirk,
+		[QUIRK_AUDIO_AUVITEK_0828] = create_auvitek_0828_quirk,
 		[QUIRK_AUDIO_STANDARD_MIXER] = create_standard_mixer_quirk,
 	};
 
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 310a3822d2b7..2ea6516e5e34 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -92,6 +92,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->direction = stream;
 	subs->dev = as->chip->dev;
 	subs->txfr_quirk = as->chip->txfr_quirk;
+	subs->media_sync_quirk = as->chip->media_sync_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
 	subs->pkt_offset_adj = 0;
 
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 91d0380431b4..a38e94554022 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -43,6 +43,7 @@ struct snd_usb_audio {
 	unsigned int in_pm:1;
 	unsigned int autosuspended:1;	
 	unsigned int txfr_quirk:1; /* Subframe boundaries on transfers */
+	unsigned int media_sync_quirk:1;/* Enforce a min period_bytes big enough to handle 2 URB transfer periods */
 	
 	int num_interfaces;
 	int num_suspended_intf;
@@ -97,7 +98,7 @@ enum quirk_type {
 	QUIRK_AUDIO_STANDARD_INTERFACE,
 	QUIRK_AUDIO_FIXED_ENDPOINT,
 	QUIRK_AUDIO_EDIROL_UAXX,
-	QUIRK_AUDIO_ALIGN_TRANSFER,
+	QUIRK_AUDIO_AUVITEK_0828,
 	QUIRK_AUDIO_STANDARD_MIXER,
 
 	QUIRK_TYPE_COUNT
-- 
1.9.3

