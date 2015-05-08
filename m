Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:37642 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbbEHTbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 15:31:38 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, vladcatoi@gmail.com,
	damien@zamaudio.com, chris.j.arges@canonical.com,
	takamichiho@gmail.com, misterpib@gmail.com, daniel@zonque.org,
	pmatilai@laiskiainen.org, jussi@sonarnerd.net,
	normalperson@yhbt.net, fisch602@gmail.com, joe@oampo.co.uk
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH 2/2] sound/usb: Update ALSA driver to use media controller API
Date: Fri,  8 May 2015 13:31:31 -0600
Message-Id: <dd21d1282a85d620be1aae497b66ccb355e458ba.1431110739.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1431110739.git.shuahkh@osg.samsung.com>
References: <cover.1431110739.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1431110739.git.shuahkh@osg.samsung.com>
References: <cover.1431110739.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ALSA driver to use media controller API to share tuner
with DVB and V4L2 drivers that control AU0828 media device.
Media device is created based on a newly added field value
in the struct snd_usb_audio_quirk. Using this approach, the
media controller API usage can be added for a specific device.
In this patch, media controller API is enabled for AU0828 hw.
snd_usb_create_quirk() will check this new field, if set will
create a media device using media_device_get_dr() interface.
media_device_get_dr() will allocate a new media device device
resource or return an existing one if it exists. During probe,
media usb driver could have created the media device. It will
then register the media device if it isn't already registered.
Media device unregister is done from usb_audio_disconnect().

New fields to add support for media entity and links are
added to struct snd_usb_substream. A new media entity for
ALSA and a link from tuner entity to the newly registered
ALSA entity are created from snd_usb_init_substream() and
removed from free_substream(). The state is kept to indicate
if tuner is linked. This is to account for case when tuner
entity doesn't exist. Media pipeline gets started to mark
the tuner busy from snd_usb_substream_capture_trigger in
response to SNDRV_PCM_TRIGGER_START and pipeline is stopped
in response to SNDRV_PCM_TRIGGER_STOP. snd_usb_pcm_close()
stops pipeline to cover the case when SNDRV_PCM_TRIGGER_STOP
isn't issued. Pipeline start and stop are done only when
tuner_linked is set.

Tested with and without CONFIG_MEDIA_CONTROLLER enabled.
Tested tuner entity doesn't exist case as au0828 v4l2
driver is the one that will create the tuner when it gets
updated to use media controller API.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/card.c         |  5 +++++
 sound/usb/card.h         | 12 ++++++++++
 sound/usb/pcm.c          | 23 ++++++++++++++++++-
 sound/usb/quirks-table.h |  1 +
 sound/usb/quirks.c       | 58 +++++++++++++++++++++++++++++++++++++++++++++++-
 sound/usb/quirks.h       |  6 +++++
 sound/usb/stream.c       | 40 +++++++++++++++++++++++++++++++++
 sound/usb/usbaudio.h     |  1 +
 8 files changed, 144 insertions(+), 2 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 1fab977..587fc24 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -621,6 +621,11 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		}
 	}
 
+	/* Nice to check quirk && quirk->media_device
+	 * need some special handlings. Doesn't look like
+	 * we have access to quirk here */
+	media_device_delete(intf);
+
 	chip->num_interfaces--;
 	if (chip->num_interfaces <= 0) {
 		usb_chip[chip->index] = NULL;
diff --git a/sound/usb/card.h b/sound/usb/card.h
index ef580b4..477bdcd 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -1,6 +1,11 @@
 #ifndef __USBAUDIO_CARD_H
 #define __USBAUDIO_CARD_H
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+#include <media/media-device.h>
+#include <media/media-entity.h>
+#endif
+
 #define MAX_NR_RATES	1024
 #define MAX_PACKS	6		/* per URB */
 #define MAX_PACKS_HS	(MAX_PACKS * 8)	/* in high speed mode */
@@ -155,6 +160,13 @@ struct snd_usb_substream {
 	} dsd_dop;
 
 	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *media_dev;
+	struct media_entity media_entity;
+	struct media_pad media_pads;
+	struct media_pipeline media_pipe;
+	bool   tuner_linked;
+#endif
 };
 
 struct snd_usb_stream {
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b4ef410..c2a40a9 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1225,6 +1225,10 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
 
 	subs->pcm_substream = NULL;
 	snd_usb_autosuspend(subs->stream->chip);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (subs->tuner_linked)
+		media_entity_pipeline_stop(&subs->media_entity);
+#endif
 
 	return 0;
 }
@@ -1587,9 +1591,22 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
+#ifdef CONFIG_MEDIA_CONTROLLER
+		if (subs->tuner_linked) {
+			err = media_entity_pipeline_start(&subs->media_entity,
+							  &subs->media_pipe);
+			if (err)
+				return err;
+		}
+#endif
 		err = start_endpoints(subs, false);
-		if (err < 0)
+		if (err < 0) {
+#ifdef CONFIG_MEDIA_CONTROLLER
+			if (subs->tuner_linked)
+				media_entity_pipeline_stop(&subs->media_entity);
+#endif
 			return err;
+		}
 
 		subs->data_endpoint->retire_data_urb = retire_capture_urb;
 		subs->running = 1;
@@ -1597,6 +1614,10 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
 	case SNDRV_PCM_TRIGGER_STOP:
 		stop_endpoints(subs, false);
 		subs->running = 0;
+#ifdef CONFIG_MEDIA_CONTROLLER
+		if (subs->tuner_linked)
+			media_entity_pipeline_stop(&subs->media_entity);
+#endif
 		return 0;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		subs->data_endpoint->retire_data_urb = NULL;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 2f6d3e9..51c544f 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2798,6 +2798,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.product_name = pname, \
 		.ifnum = QUIRK_ANY_INTERFACE, \
 		.type = QUIRK_AUDIO_ALIGN_TRANSFER, \
+		.media_device = 1, \
 	} \
 }
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 7c5a701..468e10f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -503,6 +503,56 @@ static int create_standard_mixer_quirk(struct snd_usb_audio *chip,
 	return snd_usb_create_mixer(chip, quirk->ifnum, 0);
 }
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+static int media_device_init(struct usb_interface *iface)
+{
+	struct media_device *mdev;
+	struct usb_device *usbdev = interface_to_usbdev(iface);
+	int ret;
+
+	mdev = media_device_get_dr(&usbdev->dev);
+	if (!mdev)
+		return -ENOMEM;
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		/* register media device */
+		mdev->dev = &usbdev->dev;
+		if (usbdev->product)
+			strlcpy(mdev->model, usbdev->product,
+				sizeof(mdev->model));
+		if (usbdev->serial)
+			strlcpy(mdev->serial, usbdev->serial,
+				sizeof(mdev->serial));
+		strcpy(mdev->bus_info, usbdev->devpath);
+		mdev->hw_revision = le16_to_cpu(usbdev->descriptor.bcdDevice);
+		ret = media_device_register(mdev);
+		if (ret) {
+			dev_err(&usbdev->dev,
+				"Couldn't create a media device. Error: %d\n",
+				ret);
+			return ret;
+		}
+	}
+	dev_info(&usbdev->dev, "Created media device.\n");
+	return 0;
+}
+
+void media_device_delete(struct usb_interface *iface)
+{
+	struct media_device *mdev;
+	struct usb_device *usbdev = interface_to_usbdev(iface);
+
+	mdev = media_device_find_dr(&usbdev->dev);
+	if (mdev && media_devnode_is_registered(&mdev->devnode))
+		media_device_unregister(mdev);
+	dev_info(&usbdev->dev, "Deleted media device.\n");
+}
+#else
+static inline int media_device_init(struct usb_interface *iface)
+{
+	return 0;
+}
+#endif
+
 /*
  * audio-interface quirks
  *
@@ -541,13 +591,19 @@ int snd_usb_create_quirk(struct snd_usb_audio *chip,
 		[QUIRK_AUDIO_ALIGN_TRANSFER] = create_align_transfer_quirk,
 		[QUIRK_AUDIO_STANDARD_MIXER] = create_standard_mixer_quirk,
 	};
+	int ret;
 
+	if (quirk->media_device) {
+		/* don't want to fail when media_device_init() doesn't work */
+		ret = media_device_init(iface);
+	}
 	if (quirk->type < QUIRK_TYPE_COUNT) {
-		return quirk_funcs[quirk->type](chip, iface, driver, quirk);
+		ret = quirk_funcs[quirk->type](chip, iface, driver, quirk);
 	} else {
 		usb_audio_err(chip, "invalid quirk type %d\n", quirk->type);
 		return -ENXIO;
 	}
+	return ret;
 }
 
 /*
diff --git a/sound/usb/quirks.h b/sound/usb/quirks.h
index 2cd71ed..7782f03 100644
--- a/sound/usb/quirks.h
+++ b/sound/usb/quirks.h
@@ -40,4 +40,10 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 					struct audioformat *fp,
 					unsigned int sample_bytes);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+void media_device_delete(struct usb_interface *iface);
+#else
+static inline void media_device_delete(struct usb_interface *iface) {}
+#endif
+
 #endif /* __USBAUDIO_QUIRKS_H */
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 310a382..d19f870 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -52,6 +52,17 @@ static void free_substream(struct snd_usb_substream *subs)
 		kfree(fp);
 	}
 	kfree(subs->rate_list.list);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (subs->media_dev) {
+		subs->media_dev = NULL;
+		subs->tuner_linked = 0;
+		media_entity_remove_links(&subs->media_entity);
+		media_device_unregister_entity(&subs->media_entity);
+		media_entity_cleanup(&subs->media_entity);
+		pr_info("free_substream(): tuner_linked = %d\n",
+			subs->tuner_linked);
+	}
+#endif
 }
 
 
@@ -75,6 +86,34 @@ static void snd_usb_audio_pcm_free(struct snd_pcm *pcm)
 	}
 }
 
+static void media_stream_init(struct snd_usb_substream *subs)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity *entity;
+	int ret;
+
+	subs->media_dev = media_device_find_dr(&subs->dev->dev);
+	if (!subs->media_dev)
+		return;
+	subs->media_entity.type = MEDIA_ENT_T_DEVNODE_ALSA;
+	media_entity_init(&subs->media_entity, 1, &subs->media_pads, 0);
+	media_device_register_entity(subs->media_dev, &subs->media_entity);
+	media_device_for_each_entity(entity, subs->media_dev) {
+		switch (entity->type) {
+		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
+			ret = media_entity_create_link(entity, 0,
+						 &subs->media_entity, 0,
+						 MEDIA_LNK_FL_ENABLED);
+			if (ret == 0)
+				subs->tuner_linked = 1;
+		break;
+		}
+	}
+	pr_info("media_stream_init(): tuner_linked = %d\n",
+		subs->tuner_linked);
+#endif
+}
+
 /*
  * initialize the substream instance.
  */
@@ -104,6 +143,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->ep_num = fp->endpoint;
 	if (fp->channels > subs->channels_max)
 		subs->channels_max = fp->channels;
+	media_stream_init(subs);
 }
 
 /* kctl callbacks for usb-audio channel maps */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 91d0380..c2dbf1d 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -108,6 +108,7 @@ struct snd_usb_audio_quirk {
 	const char *product_name;
 	int16_t ifnum;
 	uint16_t type;
+	bool media_device;
 	const void *data;
 };
 
-- 
2.1.4

