Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34905 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728035AbeKTWXT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 17:23:19 -0500
Subject: Re: [RFC PATCH v8 4/4] sound/usb: Use Media Controller API to share
 media resources
To: shuah@kernel.org, mchehab@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <cover.1541118238.git.shuah@kernel.org>
 <ba3bb65b4250fa470c7319d50ebdf1047793efad.1541109584.git.shuah@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0b919080-669a-a266-c85c-66dc724a536b@xs4all.nl>
Date: Tue, 20 Nov 2018 12:54:27 +0100
MIME-Version: 1.0
In-Reply-To: <ba3bb65b4250fa470c7319d50ebdf1047793efad.1541109584.git.shuah@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/02/2018 01:31 AM, shuah@kernel.org wrote:
> From: Shuah Khan <shuah@kernel.org>
> 
> Change ALSA driver to use Media Controller API to share media resources
> with DVB, and V4L2 drivers on a AU0828 media device.
> 
> Media Controller specific initialization is done after sound card is
> registered. ALSA creates Media interface and entity function graph
> nodes for Control, Mixer, PCM Playback, and PCM Capture devices.
> 
> snd_usb_hw_params() will call Media Controller enable source handler
> interface to request the media resource. If resource request is granted,
> it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
> returned.
> 
> Media specific cleanup is done in usb_audio_disconnect().
> 
> Signed-off-by: Shuah Khan <shuah@kernel.org>
> ---
>  sound/usb/Kconfig        |   4 +
>  sound/usb/Makefile       |   2 +
>  sound/usb/card.c         |  14 ++
>  sound/usb/card.h         |   3 +
>  sound/usb/media.c        | 320 +++++++++++++++++++++++++++++++++++++++
>  sound/usb/media.h        |  73 +++++++++
>  sound/usb/mixer.h        |   3 +
>  sound/usb/pcm.c          |  29 +++-
>  sound/usb/quirks-table.h |   1 +
>  sound/usb/stream.c       |   2 +
>  sound/usb/usbaudio.h     |   6 +
>  11 files changed, 453 insertions(+), 4 deletions(-)
>  create mode 100644 sound/usb/media.c
>  create mode 100644 sound/usb/media.h
> 
> diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
> index f61b5662bb89..6319b544ba3a 100644
> --- a/sound/usb/Kconfig
> +++ b/sound/usb/Kconfig
> @@ -15,6 +15,7 @@ config SND_USB_AUDIO
>  	select SND_RAWMIDI
>  	select SND_PCM
>  	select BITREVERSE
> +	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER && (MEDIA_SUPPORT=y || MEDIA_SUPPORT=SND_USB_AUDIO)
>  	help
>  	  Say Y here to include support for USB audio and USB MIDI
>  	  devices.
> @@ -22,6 +23,9 @@ config SND_USB_AUDIO
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called snd-usb-audio.
>  
> +config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
> +	bool
> +
>  config SND_USB_UA101
>  	tristate "Edirol UA-101/UA-1000 driver"
>  	select SND_PCM
> diff --git a/sound/usb/Makefile b/sound/usb/Makefile
> index d330f74c90e6..e1ce257ab705 100644
> --- a/sound/usb/Makefile
> +++ b/sound/usb/Makefile
> @@ -18,6 +18,8 @@ snd-usb-audio-objs := 	card.o \
>  			quirks.o \
>  			stream.o
>  
> +snd-usb-audio-$(CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER) += media.o
> +
>  snd-usbmidi-lib-objs := midi.o
>  
>  # Toplevel Module Dependency
> diff --git a/sound/usb/card.c b/sound/usb/card.c
> index 2bfe4e80a6b9..d9ae331280a2 100644
> --- a/sound/usb/card.c
> +++ b/sound/usb/card.c
> @@ -68,6 +68,7 @@
>  #include "format.h"
>  #include "power.h"
>  #include "stream.h"
> +#include "media.h"
>  
>  MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
>  MODULE_DESCRIPTION("USB Audio");
> @@ -673,6 +674,11 @@ static int usb_audio_probe(struct usb_interface *intf,
>  	if (err < 0)
>  		goto __error;
>  
> +	if (quirk && quirk->media_device) {
> +		/* don't want to fail when media_snd_device_create() fails */
> +		media_snd_device_create(chip, intf);

I'd change the prefix to snd_media_device_create. After all, you are creating
a media_device for a sound device.

> +	}
> +
>  	usb_chip[chip->index] = chip;
>  	chip->num_interfaces++;
>  	usb_set_intfdata(intf, chip);
> @@ -729,6 +735,14 @@ static void usb_audio_disconnect(struct usb_interface *intf)
>  		list_for_each(p, &chip->midi_list) {
>  			snd_usbmidi_disconnect(p);
>  		}
> +		/*
> +		 * Nice to check quirk && quirk->media_device and
> +		 * then call media_snd_device_delete(). Don't have
> +		 * access to quirk here. media_snd_device_delete()
> +		 * acceses mixer_list

acceses -> accesses

> +		 */
> +		media_snd_device_delete(chip);
> +
>  		/* release mixer resources */
>  		list_for_each_entry(mixer, &chip->mixer_list, list) {
>  			snd_usb_mixer_disconnect(mixer);
> diff --git a/sound/usb/card.h b/sound/usb/card.h
> index ac785d15ced4..5dd3538ed6b5 100644
> --- a/sound/usb/card.h
> +++ b/sound/usb/card.h
> @@ -108,6 +108,8 @@ struct snd_usb_endpoint {
>  	struct list_head list;
>  };
>  
> +struct media_ctl;
> +
>  struct snd_usb_substream {
>  	struct snd_usb_stream *stream;
>  	struct usb_device *dev;
> @@ -160,6 +162,7 @@ struct snd_usb_substream {
>  	} dsd_dop;
>  
>  	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
> +	struct media_ctl *media_ctl;
>  };
>  
>  struct snd_usb_stream {
> diff --git a/sound/usb/media.c b/sound/usb/media.c
> new file mode 100644
> index 000000000000..140a98eed294
> --- /dev/null
> +++ b/sound/usb/media.c
> @@ -0,0 +1,320 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * media.c - Media Controller specific ALSA driver code
> + *
> + * Copyright (c) 2018 Shuah Khan <shuah@kernel.org>
> + *
> + */
> +
> +/*
> + * This file adds Media Controller support to ALSA driver

to -> to the

> + * to use the Media Controller API to share tuner with DVB

tuner -> the tuner

> + * and V4L2 drivers that control media device. Media device

that -> that the
Media -> The media

> + * is created based on existing quirks framework. Using this

on -> on the

> + * approach, the media controller API usage can be added for
> + * a specific device.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/usb.h>
> +
> +#include <sound/pcm.h>
> +#include <sound/core.h>
> +
> +#include "usbaudio.h"
> +#include "card.h"
> +#include "mixer.h"
> +#include "media.h"
> +
> +int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,

snd_media_stream_init makes more sense to me. Just my opinion though.

> +			int stream)
> +{
> +	struct media_device *mdev;
> +	struct media_ctl *mctl;
> +	struct device *pcm_dev = &pcm->streams[stream].dev;
> +	u32 intf_type;
> +	int ret = 0;
> +	u16 mixer_pad;
> +	struct media_entity *entity;
> +
> +	mdev = subs->stream->chip->media_dev;
> +	if (!mdev)
> +		return 0;
> +
> +	if (subs->media_ctl)
> +		return 0;
> +
> +	/* allocate media_ctl */
> +	mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
> +	if (!mctl)
> +		return -ENOMEM;
> +
> +	mctl->media_dev = mdev;
> +	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
> +		intf_type = MEDIA_INTF_T_ALSA_PCM_PLAYBACK;
> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_PLAYBACK;
> +		mctl->media_pad.flags = MEDIA_PAD_FL_SOURCE;
> +		mixer_pad = 1;
> +	} else {
> +		intf_type = MEDIA_INTF_T_ALSA_PCM_CAPTURE;
> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_CAPTURE;
> +		mctl->media_pad.flags = MEDIA_PAD_FL_SINK;
> +		mixer_pad = 2;
> +	}
> +	mctl->media_entity.name = pcm->name;
> +	media_entity_pads_init(&mctl->media_entity, 1, &mctl->media_pad);
> +	ret =  media_device_register_entity(mctl->media_dev,
> +					    &mctl->media_entity);
> +	if (ret)
> +		goto free_mctl;
> +
> +	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
> +						  MAJOR(pcm_dev->devt),
> +						  MINOR(pcm_dev->devt));
> +	if (!mctl->intf_devnode) {
> +		ret = -ENOMEM;
> +		goto unregister_entity;
> +	}
> +	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
> +						 &mctl->intf_devnode->intf,
> +						 MEDIA_LNK_FL_ENABLED);
> +	if (!mctl->intf_link) {
> +		ret = -ENOMEM;
> +		goto devnode_remove;
> +	}
> +
> +	/* create link between mixer and audio */
> +	media_device_for_each_entity(entity, mdev) {
> +		switch (entity->function) {
> +		case MEDIA_ENT_F_AUDIO_MIXER:
> +			ret = media_create_pad_link(entity, mixer_pad,
> +						    &mctl->media_entity, 0,
> +						    MEDIA_LNK_FL_ENABLED);
> +			if (ret)
> +				goto remove_intf_link;
> +			break;
> +		}
> +	}
> +
> +	subs->media_ctl = mctl;
> +	return 0;
> +
> +remove_intf_link:
> +	media_remove_intf_link(mctl->intf_link);
> +devnode_remove:
> +	media_devnode_remove(mctl->intf_devnode);
> +unregister_entity:
> +	media_device_unregister_entity(&mctl->media_entity);
> +free_mctl:
> +	kfree(mctl);
> +	return ret;
> +}
> +
> +void media_snd_stream_delete(struct snd_usb_substream *subs)
> +{
> +	struct media_ctl *mctl = subs->media_ctl;
> +
> +	if (mctl) {
> +		struct media_device *mdev;
> +
> +		mdev = mctl->media_dev;
> +		if (mdev && media_devnode_is_registered(mdev->devnode)) {
> +			media_devnode_remove(mctl->intf_devnode);
> +			media_device_unregister_entity(&mctl->media_entity);
> +			media_entity_cleanup(&mctl->media_entity);
> +		}
> +		kfree(mctl);
> +		subs->media_ctl = NULL;
> +	}
> +}
> +
> +int media_snd_start_pipeline(struct snd_usb_substream *subs)
> +{
> +	struct media_ctl *mctl = subs->media_ctl;
> +	int ret = 0;
> +
> +	if (!mctl)
> +		return 0;
> +
> +	mutex_lock(&mctl->media_dev->graph_mutex);
> +	if (mctl->media_dev->enable_source)
> +		ret = mctl->media_dev->enable_source(&mctl->media_entity,
> +						     &mctl->media_pipe);
> +	mutex_unlock(&mctl->media_dev->graph_mutex);
> +	return ret;
> +}
> +
> +void media_snd_stop_pipeline(struct snd_usb_substream *subs)
> +{
> +	struct media_ctl *mctl = subs->media_ctl;
> +
> +	if (!mctl)
> +		return;
> +
> +	mutex_lock(&mctl->media_dev->graph_mutex);
> +	if (mctl->media_dev->disable_source)
> +		mctl->media_dev->disable_source(&mctl->media_entity);
> +	mutex_unlock(&mctl->media_dev->graph_mutex);
> +}
> +
> +static int media_snd_mixer_init(struct snd_usb_audio *chip)
> +{
> +	struct device *ctl_dev = &chip->card->ctl_dev;
> +	struct media_intf_devnode *ctl_intf;
> +	struct usb_mixer_interface *mixer;
> +	struct media_device *mdev = chip->media_dev;
> +	struct media_mixer_ctl *mctl;
> +	u32 intf_type = MEDIA_INTF_T_ALSA_CONTROL;
> +	int ret;
> +
> +	if (!mdev)
> +		return -ENODEV;
> +
> +	ctl_intf = chip->ctl_intf_media_devnode;
> +	if (!ctl_intf) {
> +		ctl_intf = media_devnode_create(mdev, intf_type, 0,
> +						MAJOR(ctl_dev->devt),
> +						MINOR(ctl_dev->devt));
> +		if (!ctl_intf)
> +			return -ENOMEM;
> +		chip->ctl_intf_media_devnode = ctl_intf;
> +	}
> +
> +	list_for_each_entry(mixer, &chip->mixer_list, list) {
> +
> +		if (mixer->media_mixer_ctl)
> +			continue;
> +
> +		/* allocate media_mixer_ctl */
> +		mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
> +		if (!mctl)
> +			return -ENOMEM;
> +
> +		mctl->media_dev = mdev;
> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_MIXER;
> +		mctl->media_entity.name = chip->card->mixername;
> +		mctl->media_pad[0].flags = MEDIA_PAD_FL_SINK;
> +		mctl->media_pad[1].flags = MEDIA_PAD_FL_SOURCE;
> +		mctl->media_pad[2].flags = MEDIA_PAD_FL_SOURCE;
> +		media_entity_pads_init(&mctl->media_entity, MEDIA_MIXER_PAD_MAX,
> +				  mctl->media_pad);
> +		ret =  media_device_register_entity(mctl->media_dev,
> +						    &mctl->media_entity);
> +		if (ret) {
> +			kfree(mctl);
> +			return ret;
> +		}
> +
> +		mctl->intf_link = media_create_intf_link(&mctl->media_entity,
> +							 &ctl_intf->intf,
> +							 MEDIA_LNK_FL_ENABLED);
> +		if (!mctl->intf_link) {
> +			media_device_unregister_entity(&mctl->media_entity);
> +			media_entity_cleanup(&mctl->media_entity);
> +			kfree(mctl);
> +			return -ENOMEM;
> +		}
> +		mctl->intf_devnode = ctl_intf;
> +		mixer->media_mixer_ctl = mctl;
> +	}
> +	return 0;
> +}
> +
> +static void media_snd_mixer_delete(struct snd_usb_audio *chip)
> +{
> +	struct usb_mixer_interface *mixer;
> +	struct media_device *mdev = chip->media_dev;
> +
> +	if (!mdev)
> +		return;
> +
> +	list_for_each_entry(mixer, &chip->mixer_list, list) {
> +		struct media_mixer_ctl *mctl;
> +
> +		mctl = mixer->media_mixer_ctl;
> +		if (!mixer->media_mixer_ctl)
> +			continue;
> +
> +		if (media_devnode_is_registered(mdev->devnode)) {
> +			media_device_unregister_entity(&mctl->media_entity);
> +			media_entity_cleanup(&mctl->media_entity);
> +		}
> +		kfree(mctl);
> +		mixer->media_mixer_ctl = NULL;
> +	}
> +	if (media_devnode_is_registered(mdev->devnode))
> +		media_devnode_remove(chip->ctl_intf_media_devnode);
> +	chip->ctl_intf_media_devnode = NULL;
> +}
> +
> +int media_snd_device_create(struct snd_usb_audio *chip,
> +			struct usb_interface *iface)
> +{
> +	struct media_device *mdev;
> +	struct usb_device *usbdev = interface_to_usbdev(iface);
> +	int ret;
> +
> +	/* usb-audio driver is probed for each usb interface, and
> +	 * there are multiple interfaces per device. Avoid calling
> +	 * media_device_usb_allocate() each time usb_audio_probe()
> +	 * is called. Do it only once.
> +	 */
> +	if (chip->media_dev)
> +		goto snd_mixer_init;
> +
> +	mdev = media_device_usb_allocate(usbdev, KBUILD_MODNAME);
> +	if (!mdev)
> +		return -ENOMEM;
> +
> +	if (!media_devnode_is_registered(mdev->devnode)) {
> +		/* register media_device */
> +		ret = media_device_register(mdev);

You should first configure the media device before registering it.

General note: since there are two drivers modifying the same media device
the topology will change as these drivers configure the media device.

This means that there is a short window where the media device is registered
but the topology is only partially up.

Work is in progress to signal topology changes to userspace, but that is not
in (or even posted) yet. I do not believe that is an issue in this particular
case.

> +		if (ret) {
> +			media_device_delete(mdev, KBUILD_MODNAME);
> +			dev_err(&usbdev->dev,
> +				"Couldn't register media device. Error: %d\n",
> +				ret);
> +			return ret;
> +		}
> +	}
> +
> +	/* save media device - avoid lookups */
> +	chip->media_dev = mdev;
> +
> +snd_mixer_init:
> +	/* Create media entities for mixer and control dev */
> +	ret = media_snd_mixer_init(chip);
> +	if (ret) {
> +		dev_err(&usbdev->dev,
> +			"Couldn't create media mixer entities. Error: %d\n",
> +			ret);
> +
> +		/* clear saved media_dev */
> +		chip->media_dev = NULL;
> +
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +void media_snd_device_delete(struct snd_usb_audio *chip)
> +{
> +	struct media_device *mdev = chip->media_dev;
> +	struct snd_usb_stream *stream;
> +
> +	/* release resources */
> +	list_for_each_entry(stream, &chip->pcm_list, list) {
> +		media_snd_stream_delete(&stream->substream[0]);
> +		media_snd_stream_delete(&stream->substream[1]);
> +	}
> +
> +	media_snd_mixer_delete(chip);
> +
> +	if (mdev) {
> +		media_device_delete(mdev, KBUILD_MODNAME);
> +		chip->media_dev = NULL;
> +	}
> +}
> diff --git a/sound/usb/media.h b/sound/usb/media.h
> new file mode 100644
> index 000000000000..fbefa9cad215
> --- /dev/null
> +++ b/sound/usb/media.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * media.h - Media Controller specific ALSA driver code
> + *
> + * Copyright (c) 2018 Shuah Khan <shuah@kernel.org>
> + *
> + */
> +
> +/*
> + * This file adds Media Controller support to ALSA driver
> + * to use the Media Controller API to share tuner with DVB
> + * and V4L2 drivers that control media device. Media device
> + * is created based on existing quirks framework. Using this
> + * approach, the media controller API usage can be added for
> + * a specific device.
> + */
> +#ifndef __MEDIA_H
> +
> +#ifdef CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER
> +
> +#include <linux/media.h>
> +#include <media/media-device.h>
> +#include <media/media-entity.h>
> +#include <media/media-dev-allocator.h>
> +#include <sound/asound.h>
> +
> +struct media_ctl {
> +	struct media_device *media_dev;
> +	struct media_entity media_entity;
> +	struct media_intf_devnode *intf_devnode;
> +	struct media_link *intf_link;
> +	struct media_pad media_pad;
> +	struct media_pipeline media_pipe;
> +};
> +
> +/*
> + * One source pad each for SNDRV_PCM_STREAM_CAPTURE and
> + * SNDRV_PCM_STREAM_PLAYBACK. One for sink pad to link
> + * to AUDIO Source
> + */
> +#define MEDIA_MIXER_PAD_MAX    (SNDRV_PCM_STREAM_LAST + 2)
> +
> +struct media_mixer_ctl {
> +	struct media_device *media_dev;
> +	struct media_entity media_entity;
> +	struct media_intf_devnode *intf_devnode;
> +	struct media_link *intf_link;
> +	struct media_pad media_pad[MEDIA_MIXER_PAD_MAX];
> +	struct media_pipeline media_pipe;
> +};
> +
> +int media_snd_device_create(struct snd_usb_audio *chip,
> +			    struct usb_interface *iface);
> +void media_snd_device_delete(struct snd_usb_audio *chip);
> +int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
> +			  int stream);
> +void media_snd_stream_delete(struct snd_usb_substream *subs);
> +int media_snd_start_pipeline(struct snd_usb_substream *subs);
> +void media_snd_stop_pipeline(struct snd_usb_substream *subs);
> +#else
> +static inline int media_snd_device_create(struct snd_usb_audio *chip,
> +					  struct usb_interface *iface)
> +						{ return 0; }
> +static inline void media_snd_device_delete(struct snd_usb_audio *chip) { }
> +static inline int media_snd_stream_init(struct snd_usb_substream *subs,
> +					struct snd_pcm *pcm, int stream)
> +						{ return 0; }
> +static inline void media_snd_stream_delete(struct snd_usb_substream *subs) { }
> +static inline int media_snd_start_pipeline(struct snd_usb_substream *subs)
> +					{ return 0; }
> +static inline void media_snd_stop_pipeline(struct snd_usb_substream *subs) { }
> +#endif
> +#endif /* __MEDIA_H */
> diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
> index 3d12af8bf191..394cd9107507 100644
> --- a/sound/usb/mixer.h
> +++ b/sound/usb/mixer.h
> @@ -4,6 +4,8 @@
>  
>  #include <sound/info.h>
>  
> +struct media_mixer_ctl;
> +
>  struct usb_mixer_interface {
>  	struct snd_usb_audio *chip;
>  	struct usb_host_interface *hostif;
> @@ -23,6 +25,7 @@ struct usb_mixer_interface {
>  	struct urb *rc_urb;
>  	struct usb_ctrlrequest *rc_setup_packet;
>  	u8 rc_buffer[6];
> +	struct media_mixer_ctl *media_mixer_ctl;
>  
>  	bool disconnected;
>  };
> diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
> index 382847154227..a1971a87c613 100644
> --- a/sound/usb/pcm.c
> +++ b/sound/usb/pcm.c
> @@ -35,6 +35,7 @@
>  #include "pcm.h"
>  #include "clock.h"
>  #include "power.h"
> +#include "media.h"
>  
>  #define SUBSTREAM_FLAG_DATA_EP_STARTED	0
>  #define SUBSTREAM_FLAG_SYNC_EP_STARTED	1
> @@ -776,6 +777,10 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
>  	struct audioformat *fmt;
>  	int ret;
>  
> +	ret = media_snd_start_pipeline(subs);
> +	if (ret)
> +		return ret;
> +
>  	if (snd_usb_use_vmalloc)
>  		ret = snd_pcm_lib_alloc_vmalloc_buffer(substream,
>  						       params_buffer_bytes(hw_params));
> @@ -783,7 +788,7 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
>  		ret = snd_pcm_lib_malloc_pages(substream,
>  					       params_buffer_bytes(hw_params));
>  	if (ret < 0)
> -		return ret;
> +		goto stop_pipeline;
>  
>  	subs->pcm_format = params_format(hw_params);
>  	subs->period_bytes = params_period_bytes(hw_params);
> @@ -797,12 +802,13 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
>  		dev_dbg(&subs->dev->dev,
>  			"cannot set format: format = %#x, rate = %d, channels = %d\n",
>  			   subs->pcm_format, subs->cur_rate, subs->channels);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto stop_pipeline;
>  	}
>  
>  	ret = snd_usb_lock_shutdown(subs->stream->chip);
>  	if (ret < 0)
> -		return ret;
> +		goto stop_pipeline;
>  
>  	ret = snd_usb_pcm_change_state(subs, UAC3_PD_STATE_D0);
>  	if (ret < 0)
> @@ -818,6 +824,12 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
>  
>   unlock:
>  	snd_usb_unlock_shutdown(subs->stream->chip);
> +	if (ret < 0)
> +		goto stop_pipeline;
> +	return ret;
> +
> + stop_pipeline:
> +	media_snd_stop_pipeline(subs);
>  	return ret;
>  }
>  
> @@ -830,6 +842,7 @@ static int snd_usb_hw_free(struct snd_pcm_substream *substream)
>  {
>  	struct snd_usb_substream *subs = substream->runtime->private_data;
>  
> +	media_snd_stop_pipeline(subs);
>  	subs->cur_audiofmt = NULL;
>  	subs->cur_rate = 0;
>  	subs->period_bytes = 0;
> @@ -1302,6 +1315,7 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream)
>  	struct snd_usb_stream *as = snd_pcm_substream_chip(substream);
>  	struct snd_pcm_runtime *runtime = substream->runtime;
>  	struct snd_usb_substream *subs = &as->substream[direction];
> +	int ret;
>  
>  	subs->interface = -1;
>  	subs->altset_idx = 0;
> @@ -1315,7 +1329,13 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream)
>  	subs->dsd_dop.channel = 0;
>  	subs->dsd_dop.marker = 1;
>  
> -	return setup_hw_info(runtime, subs);
> +	ret = setup_hw_info(runtime, subs);
> +	if (ret == 0) {
> +		ret = media_snd_stream_init(subs, as->pcm, direction);
> +		if (ret)
> +			snd_usb_autosuspend(subs->stream->chip);
> +	}
> +	return ret;
>  }
>  
>  static int snd_usb_pcm_close(struct snd_pcm_substream *substream)
> @@ -1326,6 +1346,7 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream)
>  	int ret;
>  
>  	stop_endpoints(subs, true);
> +	media_snd_stop_pipeline(subs);
>  
>  	if (!as->chip->keep_iface &&
>  	    subs->interface >= 0 &&
> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
> index 08aa78007020..02789d1b2fec 100644
> --- a/sound/usb/quirks-table.h
> +++ b/sound/usb/quirks-table.h
> @@ -2887,6 +2887,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
>  		.product_name = pname, \
>  		.ifnum = QUIRK_ANY_INTERFACE, \
>  		.type = QUIRK_AUDIO_ALIGN_TRANSFER, \
> +		.media_device = 1, \
>  	} \
>  }
>  
> diff --git a/sound/usb/stream.c b/sound/usb/stream.c
> index 67cf849aa16b..5439dd2e6980 100644
> --- a/sound/usb/stream.c
> +++ b/sound/usb/stream.c
> @@ -38,6 +38,7 @@
>  #include "clock.h"
>  #include "stream.h"
>  #include "power.h"
> +#include "media.h"
>  
>  /*
>   * free a substream
> @@ -55,6 +56,7 @@ static void free_substream(struct snd_usb_substream *subs)
>  	}
>  	kfree(subs->rate_list.list);
>  	kfree(subs->str_pd);
> +	media_snd_stream_delete(subs);
>  }
>  
>  
> diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
> index b9faeca645fd..72bdae5ca54a 100644
> --- a/sound/usb/usbaudio.h
> +++ b/sound/usb/usbaudio.h
> @@ -30,6 +30,9 @@
>   *
>   */
>  
> +struct media_device;
> +struct media_intf_devnode;
> +
>  struct snd_usb_audio {
>  	int index;
>  	struct usb_device *dev;
> @@ -66,6 +69,8 @@ struct snd_usb_audio {
>  					 */
>  
>  	struct usb_host_interface *ctrl_intf;	/* the audio control interface */
> +	struct media_device *media_dev;
> +	struct media_intf_devnode *ctl_intf_media_devnode;
>  };
>  
>  #define usb_audio_err(chip, fmt, args...) \
> @@ -117,6 +122,7 @@ struct snd_usb_audio_quirk {
>  	const char *profile_name;	/* override the card->longname */
>  	int16_t ifnum;
>  	uint16_t type;
> +	bool media_device;

I'm not sure this is the right name for the quirk.

The quirk isn't that this audio device needs a media_device, the
quirk is that it *shares* a media device with another subsystem.

So 'shares_media_device' is a better name IMHO.

>  	const void *data;
>  };
>  
> 

Regards,

	Hans
