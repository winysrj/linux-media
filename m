Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbcCaSm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 14:42:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Ricard Wanderlof <ricard.wanderlof@axis.com>,
	Julian Scheel <julian@jusst.de>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Takamichi Horikawa <takamichiho@gmail.com>,
	=?UTF-8?q?Dominic=20Sacr=C3=A9?= <dominic.sacre@gmx.de>,
	Geliang Tang <geliangtang@163.com>,
	=?UTF-8?q?Johan=20Rast=C3=A9n?= <johan@oljud.se>,
	alsa-devel@alsa-project.org
Subject: [PATCH 1/2] [media] Revert "[media] sound/usb: Use Media Controller API to share media resources"
Date: Thu, 31 Mar 2016 15:41:52 -0300
Message-Id: <c89178f57a19300b2056f58167e183e966a4836d.1459449687.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unfortunately, this patch caused several regressions at au0828 and
snd-usb-audio, like this one:
	https://bugzilla.kernel.org/show_bug.cgi?id=115561

It also showed several troubles at the MC core that handles pretty
poorly the memory protections and data lifetime management.

So, better to revert it and fix the core before reapplying this
change.

This reverts commit aebb2b89bff0 ("[media] sound/usb: Use Media
Controller API to share media resources")'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 sound/usb/Kconfig        |   4 -
 sound/usb/Makefile       |   2 -
 sound/usb/card.c         |  14 ---
 sound/usb/card.h         |   3 -
 sound/usb/media.c        | 318 -----------------------------------------------
 sound/usb/media.h        |  72 -----------
 sound/usb/mixer.h        |   3 -
 sound/usb/pcm.c          |  28 +----
 sound/usb/quirks-table.h |   1 -
 sound/usb/stream.c       |   2 -
 sound/usb/usbaudio.h     |   6 -
 11 files changed, 5 insertions(+), 448 deletions(-)
 delete mode 100644 sound/usb/media.c
 delete mode 100644 sound/usb/media.h

diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index d14bf411515b..a452ad7cec40 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -15,7 +15,6 @@ config SND_USB_AUDIO
 	select SND_RAWMIDI
 	select SND_PCM
 	select BITREVERSE
-	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER && (MEDIA_SUPPORT=y || MEDIA_SUPPORT=SND_USB_AUDIO)
 	help
 	  Say Y here to include support for USB audio and USB MIDI
 	  devices.
@@ -23,9 +22,6 @@ config SND_USB_AUDIO
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-usb-audio.
 
-config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
-	bool
-
 config SND_USB_UA101
 	tristate "Edirol UA-101/UA-1000 driver"
 	select SND_PCM
diff --git a/sound/usb/Makefile b/sound/usb/Makefile
index 8dca3c407f5a..2d2d122b069f 100644
--- a/sound/usb/Makefile
+++ b/sound/usb/Makefile
@@ -15,8 +15,6 @@ snd-usb-audio-objs := 	card.o \
 			quirks.o \
 			stream.o
 
-snd-usb-audio-$(CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER) += media.o
-
 snd-usbmidi-lib-objs := midi.o
 
 # Toplevel Module Dependency
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 63244bbba8c7..3fc63583a537 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -66,7 +66,6 @@
 #include "format.h"
 #include "power.h"
 #include "stream.h"
-#include "media.h"
 
 MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
 MODULE_DESCRIPTION("USB Audio");
@@ -612,11 +611,6 @@ static int usb_audio_probe(struct usb_interface *intf,
 	if (err < 0)
 		goto __error;
 
-	if (quirk->media_device) {
-		/* don't want to fail when media_snd_device_create() fails */
-		media_snd_device_create(chip, intf);
-	}
-
 	usb_chip[chip->index] = chip;
 	chip->num_interfaces++;
 	usb_set_intfdata(intf, chip);
@@ -673,14 +667,6 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		list_for_each(p, &chip->midi_list) {
 			snd_usbmidi_disconnect(p);
 		}
-		/*
-		 * Nice to check quirk && quirk->media_device
-		 * need some special handlings. Doesn't look like
-		 * we have access to quirk here
-		 * Acceses mixer_list
-		*/
-		media_snd_device_delete(chip);
-
 		/* release mixer resources */
 		list_for_each_entry(mixer, &chip->mixer_list, list) {
 			snd_usb_mixer_disconnect(mixer);
diff --git a/sound/usb/card.h b/sound/usb/card.h
index 34a0898e2238..71778ca4b26a 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -105,8 +105,6 @@ struct snd_usb_endpoint {
 	struct list_head list;
 };
 
-struct media_ctl;
-
 struct snd_usb_substream {
 	struct snd_usb_stream *stream;
 	struct usb_device *dev;
@@ -158,7 +156,6 @@ struct snd_usb_substream {
 	} dsd_dop;
 
 	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
-	struct media_ctl *media_ctl;
 };
 
 struct snd_usb_stream {
diff --git a/sound/usb/media.c b/sound/usb/media.c
deleted file mode 100644
index 93a50d01490c..000000000000
--- a/sound/usb/media.c
+++ /dev/null
@@ -1,318 +0,0 @@
-/*
- * media.c - Media Controller specific ALSA driver code
- *
- * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
- * Copyright (c) 2016 Samsung Electronics Co., Ltd.
- *
- * This file is released under the GPLv2.
- */
-
-/*
- * This file adds Media Controller support to ALSA driver
- * to use the Media Controller API to share tuner with DVB
- * and V4L2 drivers that control media device. Media device
- * is created based on existing quirks framework. Using this
- * approach, the media controller API usage can be added for
- * a specific device.
-*/
-
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/slab.h>
-#include <linux/usb.h>
-
-#include <sound/pcm.h>
-#include <sound/core.h>
-
-#include "usbaudio.h"
-#include "card.h"
-#include "mixer.h"
-#include "media.h"
-
-static int media_snd_enable_source(struct media_ctl *mctl)
-{
-	if (mctl && mctl->media_dev->enable_source)
-		return mctl->media_dev->enable_source(&mctl->media_entity,
-						      &mctl->media_pipe);
-	return 0;
-}
-
-static void media_snd_disable_source(struct media_ctl *mctl)
-{
-	if (mctl && mctl->media_dev->disable_source)
-		mctl->media_dev->disable_source(&mctl->media_entity);
-}
-
-int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
-			int stream)
-{
-	struct media_device *mdev;
-	struct media_ctl *mctl;
-	struct device *pcm_dev = &pcm->streams[stream].dev;
-	u32 intf_type;
-	int ret = 0;
-	u16 mixer_pad;
-	struct media_entity *entity;
-
-	mdev = subs->stream->chip->media_dev;
-	if (!mdev)
-		return -ENODEV;
-
-	if (subs->media_ctl)
-		return 0;
-
-	/* allocate media_ctl */
-	mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
-	if (!mctl)
-		return -ENOMEM;
-
-	mctl->media_dev = mdev;
-	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		intf_type = MEDIA_INTF_T_ALSA_PCM_PLAYBACK;
-		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_PLAYBACK;
-		mctl->media_pad.flags = MEDIA_PAD_FL_SOURCE;
-		mixer_pad = 1;
-	} else {
-		intf_type = MEDIA_INTF_T_ALSA_PCM_CAPTURE;
-		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_CAPTURE;
-		mctl->media_pad.flags = MEDIA_PAD_FL_SINK;
-		mixer_pad = 2;
-	}
-	mctl->media_entity.name = pcm->name;
-	media_entity_pads_init(&mctl->media_entity, 1, &mctl->media_pad);
-	ret =  media_device_register_entity(mctl->media_dev,
-					    &mctl->media_entity);
-	if (ret)
-		goto free_mctl;
-
-	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
-						  MAJOR(pcm_dev->devt),
-						  MINOR(pcm_dev->devt));
-	if (!mctl->intf_devnode) {
-		ret = -ENOMEM;
-		goto unregister_entity;
-	}
-	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
-						 &mctl->intf_devnode->intf,
-						 MEDIA_LNK_FL_ENABLED);
-	if (!mctl->intf_link) {
-		ret = -ENOMEM;
-		goto devnode_remove;
-	}
-
-	/* create link between mixer and audio */
-	media_device_for_each_entity(entity, mdev) {
-		switch (entity->function) {
-		case MEDIA_ENT_F_AUDIO_MIXER:
-			ret = media_create_pad_link(entity, mixer_pad,
-						    &mctl->media_entity, 0,
-						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				goto remove_intf_link;
-			break;
-		}
-	}
-
-	subs->media_ctl = mctl;
-	return 0;
-
-remove_intf_link:
-	media_remove_intf_link(mctl->intf_link);
-devnode_remove:
-	media_devnode_remove(mctl->intf_devnode);
-unregister_entity:
-	media_device_unregister_entity(&mctl->media_entity);
-free_mctl:
-	kfree(mctl);
-	return ret;
-}
-
-void media_snd_stream_delete(struct snd_usb_substream *subs)
-{
-	struct media_ctl *mctl = subs->media_ctl;
-
-	if (mctl && mctl->media_dev) {
-		struct media_device *mdev;
-
-		mdev = subs->stream->chip->media_dev;
-		if (mdev && media_devnode_is_registered(&mdev->devnode)) {
-			media_devnode_remove(mctl->intf_devnode);
-			media_device_unregister_entity(&mctl->media_entity);
-			media_entity_cleanup(&mctl->media_entity);
-		}
-		kfree(mctl);
-		subs->media_ctl = NULL;
-	}
-}
-
-int media_snd_start_pipeline(struct snd_usb_substream *subs)
-{
-	struct media_ctl *mctl = subs->media_ctl;
-
-	if (mctl)
-		return media_snd_enable_source(mctl);
-	return 0;
-}
-
-void media_snd_stop_pipeline(struct snd_usb_substream *subs)
-{
-	struct media_ctl *mctl = subs->media_ctl;
-
-	if (mctl)
-		media_snd_disable_source(mctl);
-}
-
-int media_snd_mixer_init(struct snd_usb_audio *chip)
-{
-	struct device *ctl_dev = &chip->card->ctl_dev;
-	struct media_intf_devnode *ctl_intf;
-	struct usb_mixer_interface *mixer;
-	struct media_device *mdev = chip->media_dev;
-	struct media_mixer_ctl *mctl;
-	u32 intf_type = MEDIA_INTF_T_ALSA_CONTROL;
-	int ret;
-
-	if (!mdev)
-		return -ENODEV;
-
-	ctl_intf = chip->ctl_intf_media_devnode;
-	if (!ctl_intf) {
-		ctl_intf = media_devnode_create(mdev, intf_type, 0,
-						MAJOR(ctl_dev->devt),
-						MINOR(ctl_dev->devt));
-		if (!ctl_intf)
-			return -ENOMEM;
-		chip->ctl_intf_media_devnode = ctl_intf;
-	}
-
-	list_for_each_entry(mixer, &chip->mixer_list, list) {
-
-		if (mixer->media_mixer_ctl)
-			continue;
-
-		/* allocate media_mixer_ctl */
-		mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
-		if (!mctl)
-			return -ENOMEM;
-
-		mctl->media_dev = mdev;
-		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_MIXER;
-		mctl->media_entity.name = chip->card->mixername;
-		mctl->media_pad[0].flags = MEDIA_PAD_FL_SINK;
-		mctl->media_pad[1].flags = MEDIA_PAD_FL_SOURCE;
-		mctl->media_pad[2].flags = MEDIA_PAD_FL_SOURCE;
-		media_entity_pads_init(&mctl->media_entity, MEDIA_MIXER_PAD_MAX,
-				  mctl->media_pad);
-		ret =  media_device_register_entity(mctl->media_dev,
-						    &mctl->media_entity);
-		if (ret) {
-			kfree(mctl);
-			return ret;
-		}
-
-		mctl->intf_link = media_create_intf_link(&mctl->media_entity,
-							 &ctl_intf->intf,
-							 MEDIA_LNK_FL_ENABLED);
-		if (!mctl->intf_link) {
-			media_device_unregister_entity(&mctl->media_entity);
-			media_entity_cleanup(&mctl->media_entity);
-			kfree(mctl);
-			return -ENOMEM;
-		}
-		mctl->intf_devnode = ctl_intf;
-		mixer->media_mixer_ctl = mctl;
-	}
-	return 0;
-}
-
-static void media_snd_mixer_delete(struct snd_usb_audio *chip)
-{
-	struct usb_mixer_interface *mixer;
-	struct media_device *mdev = chip->media_dev;
-
-	if (!mdev)
-		return;
-
-	list_for_each_entry(mixer, &chip->mixer_list, list) {
-		struct media_mixer_ctl *mctl;
-
-		mctl = mixer->media_mixer_ctl;
-		if (!mixer->media_mixer_ctl)
-			continue;
-
-		if (media_devnode_is_registered(&mdev->devnode)) {
-			media_device_unregister_entity(&mctl->media_entity);
-			media_entity_cleanup(&mctl->media_entity);
-		}
-		kfree(mctl);
-		mixer->media_mixer_ctl = NULL;
-	}
-	if (media_devnode_is_registered(&mdev->devnode))
-		media_devnode_remove(chip->ctl_intf_media_devnode);
-	chip->ctl_intf_media_devnode = NULL;
-}
-
-int media_snd_device_create(struct snd_usb_audio *chip,
-			struct usb_interface *iface)
-{
-	struct media_device *mdev;
-	struct usb_device *usbdev = interface_to_usbdev(iface);
-	int ret;
-
-	mdev = media_device_get_devres(&usbdev->dev);
-	if (!mdev)
-		return -ENOMEM;
-	if (!mdev->dev) {
-		/* register media device */
-		mdev->dev = &usbdev->dev;
-		if (usbdev->product)
-			strlcpy(mdev->model, usbdev->product,
-				sizeof(mdev->model));
-		if (usbdev->serial)
-			strlcpy(mdev->serial, usbdev->serial,
-				sizeof(mdev->serial));
-		strcpy(mdev->bus_info, usbdev->devpath);
-		mdev->hw_revision = le16_to_cpu(usbdev->descriptor.bcdDevice);
-		media_device_init(mdev);
-	}
-	if (!media_devnode_is_registered(&mdev->devnode)) {
-		ret = media_device_register(mdev);
-		if (ret) {
-			dev_err(&usbdev->dev,
-				"Couldn't register media device. Error: %d\n",
-				ret);
-			return ret;
-		}
-	}
-
-	/* save media device - avoid lookups */
-	chip->media_dev = mdev;
-
-	/* Create media entities for mixer and control dev */
-	ret = media_snd_mixer_init(chip);
-	if (ret) {
-		dev_err(&usbdev->dev,
-			"Couldn't create media mixer entities. Error: %d\n",
-			ret);
-
-		/* clear saved media_dev */
-		chip->media_dev = NULL;
-
-		return ret;
-	}
-	return 0;
-}
-
-void media_snd_device_delete(struct snd_usb_audio *chip)
-{
-	struct media_device *mdev = chip->media_dev;
-
-	media_snd_mixer_delete(chip);
-
-	if (mdev) {
-		if (media_devnode_is_registered(&mdev->devnode))
-			media_device_unregister(mdev);
-		chip->media_dev = NULL;
-	}
-}
diff --git a/sound/usb/media.h b/sound/usb/media.h
deleted file mode 100644
index 1dcdcdc5f7aa..000000000000
--- a/sound/usb/media.h
+++ /dev/null
@@ -1,72 +0,0 @@
-/*
- * media.h - Media Controller specific ALSA driver code
- *
- * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
- * Copyright (c) 2016 Samsung Electronics Co., Ltd.
- *
- * This file is released under the GPLv2.
- */
-
-/*
- * This file adds Media Controller support to ALSA driver
- * to use the Media Controller API to share tuner with DVB
- * and V4L2 drivers that control media device. Media device
- * is created based on existing quirks framework. Using this
- * approach, the media controller API usage can be added for
- * a specific device.
-*/
-#ifndef __MEDIA_H
-
-#ifdef CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER
-
-#include <media/media-device.h>
-#include <media/media-entity.h>
-#include <sound/asound.h>
-
-struct media_ctl {
-	struct media_device *media_dev;
-	struct media_entity media_entity;
-	struct media_intf_devnode *intf_devnode;
-	struct media_link *intf_link;
-	struct media_pad media_pad;
-	struct media_pipeline media_pipe;
-};
-
-/*
- * One source pad each for SNDRV_PCM_STREAM_CAPTURE and
- * SNDRV_PCM_STREAM_PLAYBACK. One for sink pad to link
- * to AUDIO Source
-*/
-#define MEDIA_MIXER_PAD_MAX    (SNDRV_PCM_STREAM_LAST + 2)
-
-struct media_mixer_ctl {
-	struct media_device *media_dev;
-	struct media_entity media_entity;
-	struct media_intf_devnode *intf_devnode;
-	struct media_link *intf_link;
-	struct media_pad media_pad[MEDIA_MIXER_PAD_MAX];
-	struct media_pipeline media_pipe;
-};
-
-int media_snd_device_create(struct snd_usb_audio *chip,
-			    struct usb_interface *iface);
-void media_snd_device_delete(struct snd_usb_audio *chip);
-int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
-			  int stream);
-void media_snd_stream_delete(struct snd_usb_substream *subs);
-int media_snd_start_pipeline(struct snd_usb_substream *subs);
-void media_snd_stop_pipeline(struct snd_usb_substream *subs);
-#else
-static inline int media_snd_device_create(struct snd_usb_audio *chip,
-					  struct usb_interface *iface)
-						{ return 0; }
-static inline void media_snd_device_delete(struct snd_usb_audio *chip) { }
-static inline int media_snd_stream_init(struct snd_usb_substream *subs,
-					struct snd_pcm *pcm, int stream)
-						{ return 0; }
-static inline void media_snd_stream_delete(struct snd_usb_substream *subs) { }
-static inline int media_snd_start_pipeline(struct snd_usb_substream *subs)
-					{ return 0; }
-static inline void media_snd_stop_pipeline(struct snd_usb_substream *subs) { }
-#endif
-#endif /* __MEDIA_H */
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index f3789446ab9c..3417ef347e40 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -3,8 +3,6 @@
 
 #include <sound/info.h>
 
-struct media_mixer_ctl;
-
 struct usb_mixer_interface {
 	struct snd_usb_audio *chip;
 	struct usb_host_interface *hostif;
@@ -24,7 +22,6 @@ struct usb_mixer_interface {
 	struct urb *rc_urb;
 	struct usb_ctrlrequest *rc_setup_packet;
 	u8 rc_buffer[6];
-	struct media_mixer_ctl *media_mixer_ctl;
 };
 
 #define MAX_CHANNELS	16	/* max logical channels */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 0e4e0640c504..44d178ee9177 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -35,7 +35,6 @@
 #include "pcm.h"
 #include "clock.h"
 #include "power.h"
-#include "media.h"
 
 #define SUBSTREAM_FLAG_DATA_EP_STARTED	0
 #define SUBSTREAM_FLAG_SYNC_EP_STARTED	1
@@ -718,14 +717,10 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	struct audioformat *fmt;
 	int ret;
 
-	ret = media_snd_start_pipeline(subs);
-	if (ret)
-		return ret;
-
 	ret = snd_pcm_lib_alloc_vmalloc_buffer(substream,
 					       params_buffer_bytes(hw_params));
 	if (ret < 0)
-		goto err_ret;
+		return ret;
 
 	subs->pcm_format = params_format(hw_params);
 	subs->period_bytes = params_period_bytes(hw_params);
@@ -739,27 +734,22 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		dev_dbg(&subs->dev->dev,
 			"cannot set format: format = %#x, rate = %d, channels = %d\n",
 			   subs->pcm_format, subs->cur_rate, subs->channels);
-		ret = -EINVAL;
-		goto err_ret;
+		return -EINVAL;
 	}
 
 	ret = snd_usb_lock_shutdown(subs->stream->chip);
 	if (ret < 0)
-		goto err_ret;
+		return ret;
 	ret = set_format(subs, fmt);
 	snd_usb_unlock_shutdown(subs->stream->chip);
 	if (ret < 0)
-		goto err_ret;
+		return ret;
 
 	subs->interface = fmt->iface;
 	subs->altset_idx = fmt->altset_idx;
 	subs->need_setup_ep = true;
 
 	return 0;
-
-err_ret:
-	media_snd_stop_pipeline(subs);
-	return ret;
 }
 
 /*
@@ -771,7 +761,6 @@ static int snd_usb_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_usb_substream *subs = substream->runtime->private_data;
 
-	media_snd_stop_pipeline(subs);
 	subs->cur_audiofmt = NULL;
 	subs->cur_rate = 0;
 	subs->period_bytes = 0;
@@ -1232,7 +1221,6 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_stream *as = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_usb_substream *subs = &as->substream[direction];
-	int ret;
 
 	subs->interface = -1;
 	subs->altset_idx = 0;
@@ -1246,12 +1234,7 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
 	subs->dsd_dop.channel = 0;
 	subs->dsd_dop.marker = 1;
 
-	ret = setup_hw_info(runtime, subs);
-	if (ret == 0)
-		ret = media_snd_stream_init(subs, as->pcm, direction);
-	if (ret)
-		snd_usb_autosuspend(subs->stream->chip);
-	return ret;
+	return setup_hw_info(runtime, subs);
 }
 
 static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
@@ -1260,7 +1243,6 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_substream *subs = &as->substream[direction];
 
 	stop_endpoints(subs, true);
-	media_snd_stop_pipeline(subs);
 
 	if (subs->interface >= 0 &&
 	    !snd_usb_lock_shutdown(subs->stream->chip)) {
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 9d087b19c70c..c60a776e815d 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2886,7 +2886,6 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.product_name = pname, \
 		.ifnum = QUIRK_ANY_INTERFACE, \
 		.type = QUIRK_AUDIO_ALIGN_TRANSFER, \
-		.media_device = 1, \
 	} \
 }
 
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 51258a15f653..c4dc577ab1bd 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -36,7 +36,6 @@
 #include "format.h"
 #include "clock.h"
 #include "stream.h"
-#include "media.h"
 
 /*
  * free a substream
@@ -53,7 +52,6 @@ static void free_substream(struct snd_usb_substream *subs)
 		kfree(fp);
 	}
 	kfree(subs->rate_list.list);
-	media_snd_stream_delete(subs);
 }
 
 
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index a161c7c1b126..b665d85555cb 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -30,9 +30,6 @@
  *
  */
 
-struct media_device;
-struct media_intf_devnode;
-
 struct snd_usb_audio {
 	int index;
 	struct usb_device *dev;
@@ -63,8 +60,6 @@ struct snd_usb_audio {
 	bool autoclock;			/* from the 'autoclock' module param */
 
 	struct usb_host_interface *ctrl_intf;	/* the audio control interface */
-	struct media_device *media_dev;
-	struct media_intf_devnode *ctl_intf_media_devnode;
 };
 
 #define usb_audio_err(chip, fmt, args...) \
@@ -115,7 +110,6 @@ struct snd_usb_audio_quirk {
 	const char *product_name;
 	int16_t ifnum;
 	uint16_t type;
-	bool media_device;
 	const void *data;
 };
 
-- 
2.5.5

