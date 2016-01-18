Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:52263 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbcARX33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 18:29:29 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-api@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v3 26/31] sound/usb: Update ALSA driver to use Managed Media Controller API
Date: Mon, 18 Jan 2016 16:29:24 -0700
Message-Id: <21fcacc0b76c8f6d155b234dff70a3c97722ef64.1453158167.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1453158165.git.shuahkh@osg.samsung.com>
References: <cover.1453158165.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ALSA driver to use Managed Media Managed Controller
API to share tuner with DVB and V4L2 drivers that control
AU0828 media device.  Media device is created based on a
newly added field value in the struct snd_usb_audio_quirk.
Using this approach, the media controller API usage can be
added for a specific device. In this patch, Media Controller
API is enabled for AU0828 hw. snd_usb_create_quirk() will
check this new field, if set will create a media device using
media_device_get_devres() interface.

media_device_get_devres() will allocate a new media device
devres or return an existing one, if it finds one.

During probe, media usb driver could have created the media
device devres. It will then initialze (if necessary) and
register the media device if it isn't already initialized
and registered. Media device unregister is done from
usb_audio_disconnect().

During probe, media usb driver could have created the
media device devres. It will then register the media
device if it isn't already registered. Media device
unregister is done from usb_audio_disconnect().

New structure media_ctl is added to group the new
fields to support media entity and links. This new
structure is added to struct snd_usb_substream.

A new entity_notify hook and a new ALSA capture media
entity are registered from snd_usb_pcm_open() after
setting up hardware information for the PCM device.

When a new entity is registered, Media Controller API
interface media_device_register_entity() invokes all
registered entity_notify hooks for the media device.
ALSA entity_notify hook parses all the entity list to
find a link from decoder it ALSA entity. This indicates
that the bridge driver created a link from decoder to
ALSA capture entity.

ALSA will attempt to enable the tuner to link the tuner
to the decoder calling enable_source handler if one is
provided by the bridge driver prior to starting Media
pipeline from snd_usb_hw_params(). If enable_source returns
with tuner busy condition, then snd_usb_hw_params() will fail
with -EBUSY. Media pipeline is stopped from snd_usb_hw_free().

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
Changes since v2: Addressed Takasi Iwai's comments on v2
- Make SND_USB_AUDIO_USE_MEDIA_CONTROLLER auto-selectable
  and have it be selected by SND_USB_AUDIO when MEDIA_CONTROLLER
  is enabled.
- Remove unnecessary casts.
Changes since v1: Addressed Takasi Iwai's comments on v1
- Move config defines to Kconfig and add logic
  to Makefile to conditionally compile media.c
- Removed extra includes from media.c
- Added snd_usb_autosuspend() in error leg
- Removed debug related code that was missed in v1

 sound/usb/Kconfig        |   4 +
 sound/usb/Makefile       |   2 +
 sound/usb/card.c         |   7 ++
 sound/usb/card.h         |   1 +
 sound/usb/media.c        | 190 +++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/media.h        |  55 ++++++++++++++
 sound/usb/pcm.c          |  28 +++++--
 sound/usb/quirks-table.h |   1 +
 sound/usb/quirks.c       |   5 ++
 sound/usb/stream.c       |   2 +
 sound/usb/usbaudio.h     |   1 +
 11 files changed, 291 insertions(+), 5 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index a452ad7..1a71d93 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -15,6 +15,7 @@ config SND_USB_AUDIO
 	select SND_RAWMIDI
 	select SND_PCM
 	select BITREVERSE
+	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER	if MEDIA_CONTROLLER
 	help
 	  Say Y here to include support for USB audio and USB MIDI
 	  devices.
@@ -22,6 +23,9 @@ config SND_USB_AUDIO
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-usb-audio.
 
+config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
+	bool
+
 config SND_USB_UA101
 	tristate "Edirol UA-101/UA-1000 driver"
 	select SND_PCM
diff --git a/sound/usb/Makefile b/sound/usb/Makefile
index 2d2d122..8dca3c4 100644
--- a/sound/usb/Makefile
+++ b/sound/usb/Makefile
@@ -15,6 +15,8 @@ snd-usb-audio-objs := 	card.o \
 			quirks.o \
 			stream.o
 
+snd-usb-audio-$(CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER) += media.o
+
 snd-usbmidi-lib-objs := midi.o
 
 # Toplevel Module Dependency
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 18f5664..1a63851 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -66,6 +66,7 @@
 #include "format.h"
 #include "power.h"
 #include "stream.h"
+#include "media.h"
 
 MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
 MODULE_DESCRIPTION("USB Audio");
@@ -621,6 +622,12 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		list_for_each_entry(mixer, &chip->mixer_list, list) {
 			snd_usb_mixer_disconnect(mixer);
 		}
+		/*
+		 * Nice to check quirk && quirk->media_device
+		 * need some special handlings. Doesn't look like
+		 * we have access to quirk here
+		*/
+		media_device_delete(intf);
 	}
 
 	chip->num_interfaces--;
diff --git a/sound/usb/card.h b/sound/usb/card.h
index 71778ca..c15a03c 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -156,6 +156,7 @@ struct snd_usb_substream {
 	} dsd_dop;
 
 	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
+	void *media_ctl;
 };
 
 struct snd_usb_stream {
diff --git a/sound/usb/media.c b/sound/usb/media.c
new file mode 100644
index 0000000..c575b33
--- /dev/null
+++ b/sound/usb/media.c
@@ -0,0 +1,190 @@
+/*
+ * media.c - Media Controller specific ALSA driver code
+ *
+ * Copyright (c) 2015 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2015 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ */
+
+/*
+ * This file adds Media Controller support to ALSA driver
+ * to use the Media Controller API to share tuner with DVB
+ * and V4L2 drivers that control media device. Media device
+ * is created based on existing quirks framework. Using this
+ * approach, the media controller API usage can be added for
+ * a specific device.
+*/
+
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+
+#include <sound/pcm.h>
+
+#include "usbaudio.h"
+#include "card.h"
+#include "media.h"
+
+int media_device_create(struct snd_usb_audio *chip,
+			struct usb_interface *iface)
+{
+	struct media_device *mdev;
+	struct usb_device *usbdev = interface_to_usbdev(iface);
+	int ret;
+
+	mdev = media_device_get_devres(&usbdev->dev);
+	if (!mdev)
+		return -ENOMEM;
+	if (!mdev->dev) {
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
+		ret = media_device_init(mdev);
+		if (ret) {
+			dev_err(&usbdev->dev,
+				"Couldn't create a media device. Error: %d\n",
+				ret);
+			return ret;
+		}
+	}
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		ret = media_device_register(mdev);
+		if (ret) {
+			dev_err(&usbdev->dev,
+				"Couldn't register media device. Error: %d\n",
+				ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+void media_device_delete(struct usb_interface *iface)
+{
+	struct media_device *mdev;
+	struct usb_device *usbdev = interface_to_usbdev(iface);
+
+	mdev = media_device_find_devres(&usbdev->dev);
+	if (mdev && media_devnode_is_registered(&mdev->devnode))
+		media_device_unregister(mdev);
+}
+
+static int media_enable_source(struct media_ctl *mctl)
+{
+	if (mctl && mctl->media_dev->enable_source)
+		return mctl->media_dev->enable_source(&mctl->media_entity,
+						      &mctl->media_pipe);
+	return 0;
+}
+
+static void media_disable_source(struct media_ctl *mctl)
+{
+	if (mctl && mctl->media_dev->disable_source)
+		mctl->media_dev->disable_source(&mctl->media_entity);
+}
+
+int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
+			int stream)
+{
+	struct media_device *mdev;
+	struct media_ctl *mctl;
+	struct device *pcm_dev = &pcm->streams[stream].dev;
+	u32 intf_type;
+	int ret = 0;
+
+	mdev = media_device_find_devres(&subs->dev->dev);
+	if (!mdev)
+		return -ENODEV;
+
+	if (subs->media_ctl)
+		return 0;
+
+	/* allocate media_ctl */
+	mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
+	if (!mctl)
+		return -ENOMEM;
+
+	mctl->media_dev = mdev;
+	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		intf_type = MEDIA_INTF_T_ALSA_PCM_PLAYBACK;
+		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_PLAYBACK;
+	} else {
+		intf_type = MEDIA_INTF_T_ALSA_PCM_CAPTURE;
+		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_CAPTURE;
+	}
+	mctl->media_entity.name = pcm->name;
+	mctl->media_entity.info.dev.major = MAJOR(pcm_dev->devt);
+	mctl->media_entity.info.dev.minor = MINOR(pcm_dev->devt);
+	mctl->media_pad.flags = MEDIA_PAD_FL_SINK;
+	media_entity_pads_init(&mctl->media_entity, 1, &mctl->media_pad);
+	ret =  media_device_register_entity(mctl->media_dev,
+					    &mctl->media_entity);
+	if (ret) {
+		kfree(mctl);
+		return ret;
+	}
+	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
+						  MAJOR(pcm_dev->devt),
+						  MINOR(pcm_dev->devt));
+	if (!mctl->intf_devnode) {
+		media_device_unregister_entity(&mctl->media_entity);
+		kfree(mctl);
+		return -ENOMEM;
+	}
+	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
+						 &mctl->intf_devnode->intf,
+						 MEDIA_LNK_FL_ENABLED);
+	if (!mctl->intf_link) {
+		media_devnode_remove(mctl->intf_devnode);
+		media_device_unregister_entity(&mctl->media_entity);
+		kfree(mctl);
+		return -ENOMEM;
+	}
+	subs->media_ctl = mctl;
+	return 0;
+}
+
+void media_stream_delete(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = subs->media_ctl;
+
+	if (mctl && mctl->media_dev) {
+		struct media_device *mdev;
+
+		mdev = media_device_find_devres(&subs->dev->dev);
+		if (mdev) {
+			media_devnode_remove(mctl->intf_devnode);
+			media_device_unregister_entity(&mctl->media_entity);
+			media_entity_cleanup(&mctl->media_entity);
+		}
+		kfree(mctl);
+		subs->media_ctl = NULL;
+	}
+}
+
+int media_start_pipeline(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = subs->media_ctl;
+
+	if (mctl)
+		return media_enable_source(mctl);
+	return 0;
+}
+
+void media_stop_pipeline(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = subs->media_ctl;
+
+	if (mctl)
+		media_disable_source(mctl);
+}
diff --git a/sound/usb/media.h b/sound/usb/media.h
new file mode 100644
index 0000000..698c2a4
--- /dev/null
+++ b/sound/usb/media.h
@@ -0,0 +1,55 @@
+/*
+ * media.h - Media Controller specific ALSA driver code
+ *
+ * Copyright (c) 2015 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2015 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ */
+
+/*
+ * This file adds Media Controller support to ALSA driver
+ * to use the Media Controller API to share tuner with DVB
+ * and V4L2 drivers that control media device. Media device
+ * is created based on existing quirks framework. Using this
+ * approach, the media controller API usage can be added for
+ * a specific device.
+*/
+#ifndef __MEDIA_H
+
+#ifdef CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER
+
+#include <media/media-device.h>
+#include <media/media-entity.h>
+
+struct media_ctl {
+	struct media_device *media_dev;
+	struct media_entity media_entity;
+	struct media_intf_devnode *intf_devnode;
+	struct media_link *intf_link;
+	struct media_pad media_pad;
+	struct media_pipeline media_pipe;
+};
+
+int media_device_create(struct snd_usb_audio *chip,
+			struct usb_interface *iface);
+void media_device_delete(struct usb_interface *iface);
+int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
+			int stream);
+void media_stream_delete(struct snd_usb_substream *subs);
+int media_start_pipeline(struct snd_usb_substream *subs);
+void media_stop_pipeline(struct snd_usb_substream *subs);
+#else
+static inline int media_device_create(struct snd_usb_audio *chip,
+				      struct usb_interface *iface)
+						{ return 0; }
+static inline void media_device_delete(struct usb_interface *iface) { }
+static inline int media_stream_init(struct snd_usb_substream *subs,
+					struct snd_pcm *pcm, int stream)
+						{ return 0; }
+static inline void media_stream_delete(struct snd_usb_substream *subs) { }
+static inline int media_start_pipeline(struct snd_usb_substream *subs)
+					{ return 0; }
+static inline void media_stop_pipeline(struct snd_usb_substream *subs) { }
+#endif
+#endif /* __MEDIA_H */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 9245f52..c3b8486 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -35,6 +35,7 @@
 #include "pcm.h"
 #include "clock.h"
 #include "power.h"
+#include "media.h"
 
 #define SUBSTREAM_FLAG_DATA_EP_STARTED	0
 #define SUBSTREAM_FLAG_SYNC_EP_STARTED	1
@@ -715,10 +716,14 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	struct audioformat *fmt;
 	int ret;
 
+	ret = media_start_pipeline(subs);
+	if (ret)
+		return ret;
+
 	ret = snd_pcm_lib_alloc_vmalloc_buffer(substream,
 					       params_buffer_bytes(hw_params));
 	if (ret < 0)
-		return ret;
+		goto err_ret;
 
 	subs->pcm_format = params_format(hw_params);
 	subs->period_bytes = params_period_bytes(hw_params);
@@ -732,22 +737,27 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		dev_dbg(&subs->dev->dev,
 			"cannot set format: format = %#x, rate = %d, channels = %d\n",
 			   subs->pcm_format, subs->cur_rate, subs->channels);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_ret;
 	}
 
 	ret = snd_usb_lock_shutdown(subs->stream->chip);
 	if (ret < 0)
-		return ret;
+		goto err_ret;
 	ret = set_format(subs, fmt);
 	snd_usb_unlock_shutdown(subs->stream->chip);
 	if (ret < 0)
-		return ret;
+		goto err_ret;
 
 	subs->interface = fmt->iface;
 	subs->altset_idx = fmt->altset_idx;
 	subs->need_setup_ep = true;
 
 	return 0;
+
+err_ret:
+	media_stop_pipeline(subs);
+	return ret;
 }
 
 /*
@@ -759,6 +769,7 @@ static int snd_usb_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_usb_substream *subs = substream->runtime->private_data;
 
+	media_stop_pipeline(subs);
 	subs->cur_audiofmt = NULL;
 	subs->cur_rate = 0;
 	subs->period_bytes = 0;
@@ -1219,6 +1230,7 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_stream *as = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_usb_substream *subs = &as->substream[direction];
+	int ret;
 
 	subs->interface = -1;
 	subs->altset_idx = 0;
@@ -1232,7 +1244,12 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
 	subs->dsd_dop.channel = 0;
 	subs->dsd_dop.marker = 1;
 
-	return setup_hw_info(runtime, subs);
+	ret = setup_hw_info(runtime, subs);
+	if (ret == 0)
+		ret = media_stream_init(subs, as->pcm, direction);
+	if (ret)
+		snd_usb_autosuspend(subs->stream->chip);
+	return ret;
 }
 
 static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
@@ -1241,6 +1258,7 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_substream *subs = &as->substream[direction];
 
 	stop_endpoints(subs, true);
+	media_stop_pipeline(subs);
 
 	if (subs->interface >= 0 &&
 	    !snd_usb_lock_shutdown(subs->stream->chip)) {
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 1a1e2e4..8f7b71b 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2875,6 +2875,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.product_name = pname, \
 		.ifnum = QUIRK_ANY_INTERFACE, \
 		.type = QUIRK_AUDIO_ALIGN_TRANSFER, \
+		.media_device = 1, \
 	} \
 }
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 5ca80e7..b0d9d13 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -36,6 +36,7 @@
 #include "pcm.h"
 #include "clock.h"
 #include "stream.h"
+#include "media.h"
 
 /*
  * handle the quirks for the contained interfaces
@@ -545,6 +546,10 @@ int snd_usb_create_quirk(struct snd_usb_audio *chip,
 		[QUIRK_AUDIO_STANDARD_MIXER] = create_standard_mixer_quirk,
 	};
 
+	if (quirk->media_device) {
+		/* don't want to fail when media_device_create() fails */
+		media_device_create(chip, iface);
+	}
 	if (quirk->type < QUIRK_TYPE_COUNT) {
 		return quirk_funcs[quirk->type](chip, iface, driver, quirk);
 	} else {
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 8ee14f2..789e515 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -36,6 +36,7 @@
 #include "format.h"
 #include "clock.h"
 #include "stream.h"
+#include "media.h"
 
 /*
  * free a substream
@@ -52,6 +53,7 @@ static void free_substream(struct snd_usb_substream *subs)
 		kfree(fp);
 	}
 	kfree(subs->rate_list.list);
+	media_stream_delete(subs);
 }
 
 
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 15a1271..e3fac29 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -109,6 +109,7 @@ struct snd_usb_audio_quirk {
 	const char *product_name;
 	int16_t ifnum;
 	uint16_t type;
+	bool media_device;
 	const void *data;
 };
 
-- 
2.5.0

