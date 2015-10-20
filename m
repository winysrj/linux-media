Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:52408 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbbJTXZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 19:25:21 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen v2 2/3] sound/usb: Create media mixer function and control interface entities
Date: Tue, 20 Oct 2015 17:25:15 -0600
Message-Id: <2f95ce0190c05e994e02bdc4393be21ec7609adf.1445380851.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1445380851.git.shuahkh@osg.samsung.com>
References: <cover.1445380851.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1445380851.git.shuahkh@osg.samsung.com>
References: <cover.1445380851.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for creating MEDIA_ENT_F_AUDIO_MIXER entity for
each mixer and a MEDIA_INTF_T_ALSA_CONTROL control interface
entity that links to mixer entities. MEDIA_INTF_T_ALSA_CONTROL
entity corresponds to the control device for the card.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/card.c     |  5 +++
 sound/usb/media.c    | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/media.h    | 20 ++++++++++++
 sound/usb/mixer.h    |  1 +
 sound/usb/usbaudio.h |  1 +
 5 files changed, 116 insertions(+)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 469d2bf..d004cb4 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -560,6 +560,9 @@ static int usb_audio_probe(struct usb_interface *intf,
 	if (err < 0)
 		goto __error;
 
+	/* Create media entities for mixer and control dev */
+	media_mixer_init(chip);
+
 	usb_chip[chip->index] = chip;
 	chip->num_interfaces++;
 	chip->probing = 0;
@@ -616,6 +619,8 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		list_for_each(p, &chip->midi_list) {
 			snd_usbmidi_disconnect(p);
 		}
+		/* delete mixer media resources */
+		media_mixer_delete(chip);
 		/* release mixer resources */
 		list_for_each_entry(mixer, &chip->mixer_list, list) {
 			snd_usb_mixer_disconnect(mixer);
diff --git a/sound/usb/media.c b/sound/usb/media.c
index 0cbfee6..a26ea8b 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -199,4 +199,93 @@ void media_stop_pipeline(struct snd_usb_substream *subs)
 	if (mctl)
 		media_disable_source(mctl);
 }
+
+int media_mixer_init(struct snd_usb_audio *chip)
+{
+	struct device *ctl_dev = &chip->card->ctl_dev;
+	struct media_intf_devnode *ctl_intf;
+	struct usb_mixer_interface *mixer;
+	struct media_device *mdev;
+	struct media_mixer_ctl *mctl;
+	u32 intf_type = MEDIA_INTF_T_ALSA_CONTROL;
+	int ret;
+
+	mdev = media_device_find_devres(&chip->dev->dev);
+	if (!mdev)
+		return -ENODEV;
+
+	ctl_intf = (struct media_intf_devnode *) chip->ctl_intf_media_devnode;
+	if (!ctl_intf) {
+		ctl_intf = (void *) media_devnode_create(mdev,
+							 intf_type, 0,
+							 MAJOR(ctl_dev->devt),
+							 MINOR(ctl_dev->devt));
+		if (!ctl_intf)
+			return -ENOMEM;
+	}
+
+	list_for_each_entry(mixer, &chip->mixer_list, list) {
+
+		if (mixer->media_mixer_ctl)
+			continue;
+
+		/* allocate media_ctl */
+		mctl = kzalloc(sizeof(struct media_ctl), GFP_KERNEL);
+		if (!mctl)
+			return -ENOMEM;
+
+		mixer->media_mixer_ctl = (void *) mctl;
+		mctl->media_dev = mdev;
+
+		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_MIXER;
+		mctl->media_entity.name = chip->card->mixername;
+		mctl->media_pad[0].flags = MEDIA_PAD_FL_SINK;
+		mctl->media_pad[1].flags = MEDIA_PAD_FL_SOURCE;
+		mctl->media_pad[2].flags = MEDIA_PAD_FL_SOURCE;
+		media_entity_init(&mctl->media_entity, MEDIA_MIXER_PAD_MAX,
+				  mctl->media_pad);
+		ret =  media_device_register_entity(mctl->media_dev,
+						    &mctl->media_entity);
+		if (ret)
+			return ret;
+
+		mctl->intf_link = media_create_intf_link(&mctl->media_entity,
+							 &ctl_intf->intf,
+							 MEDIA_LNK_FL_ENABLED);
+		if (!mctl->intf_link) {
+			media_device_unregister_entity(&mctl->media_entity);
+			return -ENOMEM;
+		}
+		mctl->intf_devnode = ctl_intf;
+	}
+	return 0;
+}
+
+void media_mixer_delete(struct snd_usb_audio *chip)
+{
+	struct usb_mixer_interface *mixer;
+	struct media_device *mdev;
+
+	mdev = media_device_find_devres(&chip->dev->dev);
+	if (!mdev)
+		return;
+
+	list_for_each_entry(mixer, &chip->mixer_list, list) {
+		struct media_mixer_ctl *mctl;
+
+		mctl = (struct media_mixer_ctl *) mixer->media_mixer_ctl;
+		if (!mixer->media_mixer_ctl)
+			continue;
+
+		media_entity_remove_links(&mctl->media_entity);
+		media_device_unregister_entity(&mctl->media_entity);
+		media_entity_cleanup(&mctl->media_entity);
+		mctl->media_dev = NULL;
+		mctl->intf_devnode = NULL;
+		kfree(mctl);
+		mixer->media_mixer_ctl = NULL;
+	}
+	media_devnode_remove(chip->ctl_intf_media_devnode);
+}
+
 #endif
diff --git a/sound/usb/media.h b/sound/usb/media.h
index cdcfb80..8268e52 100644
--- a/sound/usb/media.h
+++ b/sound/usb/media.h
@@ -20,6 +20,7 @@
 #ifdef USE_MEDIA_CONTROLLER
 #include <media/media-device.h>
 #include <media/media-entity.h>
+#include <sound/asound.h>
 
 struct media_ctl {
 	struct media_device *media_dev;
@@ -30,6 +31,21 @@ struct media_ctl {
 	struct media_pipeline media_pipe;
 };
 
+/* One source pad each for SNDRV_PCM_STREAM_CAPTURE and
+ * SNDRV_PCM_STREAM_PLAYBACK. One for sink pad to link
+ * to AUDIO Source
+*/
+#define MEDIA_MIXER_PAD_MAX	(SNDRV_PCM_STREAM_LAST + 2)
+
+struct media_mixer_ctl {
+	struct media_device *media_dev;
+	struct media_entity media_entity;
+	struct media_intf_devnode *intf_devnode;
+	struct media_link *intf_link;
+	struct media_pad media_pad[MEDIA_MIXER_PAD_MAX];
+	struct media_pipeline media_pipe;
+};
+
 int media_device_init(struct snd_usb_audio *chip, struct usb_interface *iface);
 void media_device_delete(struct usb_interface *iface);
 int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
@@ -37,6 +53,8 @@ int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 void media_stream_delete(struct snd_usb_substream *subs);
 int media_start_pipeline(struct snd_usb_substream *subs);
 void media_stop_pipeline(struct snd_usb_substream *subs);
+int media_mixer_init(struct snd_usb_audio *chip);
+void media_mixer_delete(struct snd_usb_audio *chip);
 #else
 static inline int media_device_init(struct snd_usb_audio *chip,
 					struct usb_interface *iface)
@@ -49,5 +67,7 @@ static inline void media_stream_delete(struct snd_usb_substream *subs) { }
 static inline int media_start_pipeline(struct snd_usb_substream *subs)
 					{ return 0; }
 static inline void media_stop_pipeline(struct snd_usb_substream *subs) { }
+static int media_mixer_init(struct snd_usb_audio *chip) { return 0; }
+static void media_mixer_delete(struct snd_usb_audio *chip) { }
 #endif
 #endif /* __MEDIA_H */
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index d3268f0..9d62a9e 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -22,6 +22,7 @@ struct usb_mixer_interface {
 	struct urb *rc_urb;
 	struct usb_ctrlrequest *rc_setup_packet;
 	u8 rc_buffer[6];
+	void *media_mixer_ctl;
 };
 
 #define MAX_CHANNELS	16	/* max logical channels */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index c2dbf1d..b2be7c3 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -59,6 +59,7 @@ struct snd_usb_audio {
 	bool autoclock;			/* from the 'autoclock' module param */
 
 	struct usb_host_interface *ctrl_intf;	/* the audio control interface */
+	void *ctl_intf_media_devnode;
 };
 
 #define usb_audio_err(chip, fmt, args...) \
-- 
2.1.4

