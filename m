Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:37681 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbbIVRYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:24:50 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 21/21] sound/usb: Update ALSA driver to use Managed Media Controller API
Date: Tue, 22 Sep 2015 11:19:40 -0600
Message-Id: <c5ae91ab0d1ce733bb9d672a9daac0cae4775331.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ALSA driver to use Managed ~media Managed Controller
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
device devres. It will then register the media device if it
isn't already registered. Media device unregister is done from
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
 sound/usb/Makefile       |  15 +++-
 sound/usb/card.c         |   5 ++
 sound/usb/card.h         |   1 +
 sound/usb/media.c        | 178 +++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/media.h        |  51 ++++++++++++++
 sound/usb/pcm.c          |  29 ++++++--
 sound/usb/quirks-table.h |   1 +
 sound/usb/quirks.c       |   9 ++-
 sound/usb/stream.c       |   2 +
 sound/usb/usbaudio.h     |   1 +
 10 files changed, 284 insertions(+), 8 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

diff --git a/sound/usb/Makefile b/sound/usb/Makefile
index 2d2d122..665fdd9 100644
--- a/sound/usb/Makefile
+++ b/sound/usb/Makefile
@@ -2,6 +2,18 @@
 # Makefile for ALSA
 #
 
+# Media Controller
+ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
+  ifeq ($(CONFIG_MEDIA_SUPPORT),y)
+        KBUILD_CFLAGS += -DUSE_MEDIA_CONTROLLER
+  endif
+  ifeq ($(CONFIG_MEDIA_SUPPORT_MODULE),y)
+    ifeq ($(MODULE),y)
+          KBUILD_CFLAGS += -DUSE_MEDIA_CONTROLLER
+    endif
+  endif
+endif
+
 snd-usb-audio-objs := 	card.o \
 			clock.o \
 			endpoint.o \
@@ -13,7 +25,8 @@ snd-usb-audio-objs := 	card.o \
 			pcm.o \
 			proc.o \
 			quirks.o \
-			stream.o
+			stream.o \
+			media.o
 
 snd-usbmidi-lib-objs := midi.o
 
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 1fab977..469d2bf 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -66,6 +66,7 @@
 #include "format.h"
 #include "power.h"
 #include "stream.h"
+#include "media.h"
 
 MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
 MODULE_DESCRIPTION("USB Audio");
@@ -619,6 +620,10 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		list_for_each_entry(mixer, &chip->mixer_list, list) {
 			snd_usb_mixer_disconnect(mixer);
 		}
+		/* Nice to check quirk && quirk->media_device
+		 * need some special handlings. Doesn't look like
+		 * we have access to quirk here */
+		media_device_delete(intf);
 	}
 
 	chip->num_interfaces--;
diff --git a/sound/usb/card.h b/sound/usb/card.h
index ef580b4..235a85f 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -155,6 +155,7 @@ struct snd_usb_substream {
 	} dsd_dop;
 
 	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
+	void *media_ctl;
 };
 
 struct snd_usb_stream {
diff --git a/sound/usb/media.c b/sound/usb/media.c
new file mode 100644
index 0000000..97c3b2d
--- /dev/null
+++ b/sound/usb/media.c
@@ -0,0 +1,178 @@
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
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/usb.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/usb/audio.h>
+#include <linux/usb/audio-v2.h>
+#include <linux/module.h>
+
+#include <sound/control.h>
+#include <sound/core.h>
+#include <sound/info.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/initval.h>
+
+#include "usbaudio.h"
+#include "card.h"
+#include "midi.h"
+#include "mixer.h"
+#include "proc.h"
+#include "quirks.h"
+#include "endpoint.h"
+#include "helper.h"
+#include "debug.h"
+#include "pcm.h"
+#include "format.h"
+#include "power.h"
+#include "stream.h"
+#include "media.h"
+
+#ifdef USE_MEDIA_CONTROLLER
+int media_device_init(struct snd_usb_audio *chip, struct usb_interface *iface)
+{
+	struct media_device *mdev;
+	struct usb_device *usbdev = interface_to_usbdev(iface);
+	int ret;
+
+	mdev = media_device_get_devres(&usbdev->dev);
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
+							&mctl->media_pipe);
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
+
+	mdev = media_device_find_devres(&subs->dev->dev);
+	if (!mdev)
+		return -ENODEV;
+
+	if (subs->media_ctl)
+		return 0;
+
+	/* allocate media_ctl */
+	mctl = kzalloc(sizeof(struct media_ctl), GFP_KERNEL);
+	if (!mctl)
+		return -ENOMEM;
+
+	subs->media_ctl = (void *) mctl;
+	mctl->media_dev = mdev;
+	if (stream == SNDRV_PCM_STREAM_PLAYBACK)
+		mctl->media_entity.type = MEDIA_ENT_T_DEVNODE_ALSA_PLAYBACK;
+	else
+		mctl->media_entity.type = MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE;
+	mctl->media_entity.name = pcm->name;
+	mctl->media_entity.info.dev.major = MAJOR(pcm_dev->devt);
+	mctl->media_entity.info.dev.minor = MINOR(pcm_dev->devt);
+	mctl->media_pad.flags = MEDIA_PAD_FL_SINK;
+	media_entity_init(&mctl->media_entity, 1, &mctl->media_pad, 0);
+	return media_device_register_entity(mctl->media_dev,
+						&mctl->media_entity);
+}
+
+void media_stream_delete(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
+
+	if (mctl && mctl->media_dev) {
+		struct media_device *mdev;
+
+		mdev = media_device_find_devres(&subs->dev->dev);
+		if (mdev) {
+			media_entity_remove_links(&mctl->media_entity);
+			media_device_unregister_entity(&mctl->media_entity);
+			media_entity_cleanup(&mctl->media_entity);
+		}
+		mctl->media_dev = NULL;
+		kfree(mctl);
+		subs->media_ctl = NULL;
+	}
+}
+
+int media_start_pipeline(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
+
+	if (mctl)
+		return media_enable_source(mctl);
+	return 0;
+}
+
+void media_stop_pipeline(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
+
+	if (mctl)
+		media_disable_source(mctl);
+}
+#endif
diff --git a/sound/usb/media.h b/sound/usb/media.h
new file mode 100644
index 0000000..90587aa
--- /dev/null
+++ b/sound/usb/media.h
@@ -0,0 +1,51 @@
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
+#ifdef USE_MEDIA_CONTROLLER
+#include <media/media-device.h>
+#include <media/media-entity.h>
+
+struct media_ctl {
+	struct media_device *media_dev;
+	struct media_entity media_entity;
+	struct media_pad media_pad;
+	struct media_pipeline media_pipe;
+};
+
+int media_device_init(struct snd_usb_audio *chip, struct usb_interface *iface);
+void media_device_delete(struct usb_interface *iface);
+int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
+			int stream);
+void media_stream_delete(struct snd_usb_substream *subs);
+int media_start_pipeline(struct snd_usb_substream *subs);
+void media_stop_pipeline(struct snd_usb_substream *subs);
+#else
+static inline int media_device_init(struct snd_usb_audio *chip,
+					struct usb_interface *iface)
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
index b4ef410..0cba02e 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -35,6 +35,7 @@
 #include "pcm.h"
 #include "clock.h"
 #include "power.h"
+#include "media.h"
 
 #define SUBSTREAM_FLAG_DATA_EP_STARTED	0
 #define SUBSTREAM_FLAG_SYNC_EP_STARTED	1
@@ -687,10 +688,14 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
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
@@ -704,23 +709,29 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		dev_dbg(&subs->dev->dev,
 			"cannot set format: format = %#x, rate = %d, channels = %d\n",
 			   subs->pcm_format, subs->cur_rate, subs->channels);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_ret;
 	}
 
 	down_read(&subs->stream->chip->shutdown_rwsem);
-	if (subs->stream->chip->shutdown)
+	if (subs->stream->chip->shutdown) {
 		ret = -ENODEV;
-	else
+		goto err_ret;
+	} else
 		ret = set_format(subs, fmt);
 	up_read(&subs->stream->chip->shutdown_rwsem);
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
@@ -732,6 +743,7 @@ static int snd_usb_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_usb_substream *subs = substream->runtime->private_data;
 
+	media_stop_pipeline(subs);
 	subs->cur_audiofmt = NULL;
 	subs->cur_rate = 0;
 	subs->period_bytes = 0;
@@ -1195,6 +1207,7 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_stream *as = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_usb_substream *subs = &as->substream[direction];
+	int ret;
 
 	subs->interface = -1;
 	subs->altset_idx = 0;
@@ -1208,7 +1221,10 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
 	subs->dsd_dop.channel = 0;
 	subs->dsd_dop.marker = 1;
 
-	return setup_hw_info(runtime, subs);
+	ret = setup_hw_info(runtime, subs);
+	if (ret == 0)
+		ret = media_stream_init(subs, as->pcm, direction);
+	return ret;
 }
 
 static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
@@ -1217,6 +1233,7 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_substream *subs = &as->substream[direction];
 
 	stop_endpoints(subs, true);
+	media_stop_pipeline(subs);
 
 	if (!as->chip->shutdown && subs->interface >= 0) {
 		usb_set_interface(subs->dev, subs->interface, 0);
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
index 7c5a701..8190069 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -36,6 +36,7 @@
 #include "pcm.h"
 #include "clock.h"
 #include "stream.h"
+#include "media.h"
 
 /*
  * handle the quirks for the contained interfaces
@@ -541,13 +542,19 @@ int snd_usb_create_quirk(struct snd_usb_audio *chip,
 		[QUIRK_AUDIO_ALIGN_TRANSFER] = create_align_transfer_quirk,
 		[QUIRK_AUDIO_STANDARD_MIXER] = create_standard_mixer_quirk,
 	};
+	int ret;
 
+	if (quirk->media_device) {
+		/* don't want to fail when media_device_init() doesn't work */
+		media_device_init(chip, iface);
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
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 310a382..6d01c47 100644
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

