Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:51706 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933290AbbFCPNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 11:13:08 -0400
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
Subject: [PATCH v2 2/2] sound/usb: Update ALSA driver to use media controller API
Date: Wed,  3 Jun 2015 09:12:54 -0600
Message-Id: <7326d512ec83ac510431864d2fe2d79b0c72e0a6.1433298842.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1433298842.git.shuahkh@osg.samsung.com>
References: <cover.1433298842.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1433298842.git.shuahkh@osg.samsung.com>
References: <cover.1433298842.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ALSA driver to use media controller API to share tuner
with DVB and V4L2 drivers that control AU0828 media device.
Media device is created based on a newly added field value
in the struct snd_usb_audio_quirk. Using this approach, the
media controller API usage can be added for a specific device.
In this patch, media controller API is enabled for AU0828 hw.
snd_usb_create_quirk() will check this new field, if set will
create a media device using media_device_get_devres() interface.
media_device_get_devres() will allocate a new media device
devres or return an existing one, if it finds one.

During probe, media usb driver could have created the media
device devres. It will then register the media device if it
isn't already registered. Media device unregister is done
from usb_audio_disconnect().

New structure media_ctl is added to group the new fields
to support media entity and links. This new structure is
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
 sound/usb/Makefile       |   3 +-
 sound/usb/card.c         |   5 ++
 sound/usb/card.h         |   1 +
 sound/usb/media.c        | 181 +++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/media.h        |  40 +++++++++++
 sound/usb/pcm.c          |  10 ++-
 sound/usb/quirks-table.h |   1 +
 sound/usb/quirks.c       |   9 ++-
 sound/usb/stream.c       |   3 +
 sound/usb/usbaudio.h     |   1 +
 10 files changed, 251 insertions(+), 3 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

diff --git a/sound/usb/Makefile b/sound/usb/Makefile
index 2d2d122..7fe4fdd 100644
--- a/sound/usb/Makefile
+++ b/sound/usb/Makefile
@@ -13,7 +13,8 @@ snd-usb-audio-objs := 	card.o \
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
index 0000000..8e8a0b3
--- /dev/null
+++ b/sound/usb/media.c
@@ -0,0 +1,181 @@
+/*
+ * media.c - managed media token resource
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
+#ifdef CONFIG_MEDIA_CONTROLLER
+#if defined(CONFIG_MEDIA_SUPPORT) || \
+	(defined(CONFIG_MEDIA_SUPPORT_MODULE) && defined(MODULE))
+#define USE_MEDIA_CONTROLLER
+#endif
+#endif
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
+int media_device_init(struct usb_interface *iface)
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
+	dev_info(&usbdev->dev, "Created media device.\n");
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
+	dev_info(&usbdev->dev, "Deleted media device.\n");
+}
+
+void media_stream_init(struct snd_usb_substream *subs)
+{
+	struct media_device *mdev;
+	struct media_ctl *mctl;
+	struct media_entity *entity;
+	int ret;
+
+	mdev = media_device_find_devres(&subs->dev->dev);
+	if (!mdev)
+		return;
+
+	/* allocate media_ctl */
+	mctl = kzalloc(sizeof(struct media_ctl), GFP_KERNEL);
+	if (!mctl)
+		return;
+
+	mctl->media_dev = mdev;
+	mctl->media_entity.type = MEDIA_ENT_T_DEVNODE_ALSA;
+	media_entity_init(&mctl->media_entity, 1, &mctl->media_pads, 0);
+	media_device_register_entity(mctl->media_dev, &mctl->media_entity);
+	media_device_for_each_entity(entity, mctl->media_dev) {
+		switch (entity->type) {
+		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
+			ret = media_entity_create_link(entity, 0,
+						 &mctl->media_entity, 0,
+						 MEDIA_LNK_FL_ENABLED);
+			if (ret == 0)
+				mctl->tuner_linked = 1;
+		break;
+		}
+	}
+	subs->media_ctl = (void *) mctl;
+}
+
+void media_stream_delete(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
+
+	if (mctl && mctl->media_dev) {
+		mctl->media_dev = NULL;
+		mctl->tuner_linked = 0;
+		media_entity_remove_links(&mctl->media_entity);
+		media_device_unregister_entity(&mctl->media_entity);
+		media_entity_cleanup(&mctl->media_entity);
+	}
+}
+
+int media_start_pipeline(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
+	int ret = 0;
+
+	if (mctl && mctl->tuner_linked)
+		ret = media_entity_pipeline_start(&mctl->media_entity,
+							&mctl->media_pipe);
+	return ret;
+}
+
+void media_stop_pipeline(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
+
+	if (mctl && mctl->tuner_linked)
+		media_entity_pipeline_stop(&mctl->media_entity);
+}
+#else
+int media_device_init(struct usb_interface *iface) { return 0; }
+
+void media_device_delete(struct usb_interface *iface) { }
+
+void media_stream_init(struct snd_usb_substream *subs) { }
+
+void media_stream_delete(struct snd_usb_substream *subs) { }
+
+int media_start_pipeline(struct snd_usb_substream *subs) { return 0; }
+
+void media_stop_pipeline(struct snd_usb_substream *subs) { }
+#endif
diff --git a/sound/usb/media.h b/sound/usb/media.h
new file mode 100644
index 0000000..cddc05c
--- /dev/null
+++ b/sound/usb/media.h
@@ -0,0 +1,40 @@
+/*
+ * media.h - managed media token resource
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
+	struct media_pad media_pads;
+	struct media_pipeline media_pipe;
+	bool   tuner_linked;
+};
+#endif
+
+extern int media_device_init(struct usb_interface *iface);
+extern void media_device_delete(struct usb_interface *iface);
+extern void media_stream_init(struct snd_usb_substream *subs);
+extern void media_stream_delete(struct snd_usb_substream *subs);
+extern int media_start_pipeline(struct snd_usb_substream *subs);
+extern void media_stop_pipeline(struct snd_usb_substream *subs);
+
+#endif /* __MEDIA_H */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b4ef410..bb83da5 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -35,6 +35,7 @@
 #include "pcm.h"
 #include "clock.h"
 #include "power.h"
+#include "media.h"
 
 #define SUBSTREAM_FLAG_DATA_EP_STARTED	0
 #define SUBSTREAM_FLAG_SYNC_EP_STARTED	1
@@ -1225,6 +1226,7 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
 
 	subs->pcm_substream = NULL;
 	snd_usb_autosuspend(subs->stream->chip);
+	media_stop_pipeline(subs);
 
 	return 0;
 }
@@ -1587,9 +1589,14 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
+		err = media_start_pipeline(subs);
+		if (err)
+			return err;
 		err = start_endpoints(subs, false);
-		if (err < 0)
+		if (err < 0) {
+			media_stop_pipeline(subs);
 			return err;
+		}
 
 		subs->data_endpoint->retire_data_urb = retire_capture_urb;
 		subs->running = 1;
@@ -1597,6 +1604,7 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
 	case SNDRV_PCM_TRIGGER_STOP:
 		stop_endpoints(subs, false);
 		subs->running = 0;
+		media_stop_pipeline(subs);
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
index 46facfc..ea2a9f0 100644
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
+		media_device_init(iface);
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
index 310a382..ab15d9a 100644
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
 
 
@@ -104,6 +106,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
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

