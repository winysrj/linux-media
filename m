Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59576 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbbFFBh1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 21:37:27 -0400
Message-ID: <55724ECD.9030103@osg.samsung.com>
Date: Fri, 05 Jun 2015 19:37:17 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	tiwai@suse.de, perex@perex.cz, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, vladcatoi@gmail.com, damien@zamaudio.com,
	chris.j.arges@canonical.com, takamichiho@gmail.com,
	misterpib@gmail.com, daniel@zonque.org, pmatilai@laiskiainen.org,
	jussi@sonarnerd.net, normalperson@yhbt.net, fisch602@gmail.com,
	joe@oampo.co.uk, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 2/2] sound/usb: Update ALSA driver to use media controller
 API
References: <cover.1433298842.git.shuahkh@osg.samsung.com> <7326d512ec83ac510431864d2fe2d79b0c72e0a6.1433298842.git.shuahkh@osg.samsung.com> <20150603161433.20f9a746@recife.lan>
In-Reply-To: <20150603161433.20f9a746@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 01:14 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 03 Jun 2015 09:12:54 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Change ALSA driver to use media controller API to share tuner
>> with DVB and V4L2 drivers that control AU0828 media device.
>> Media device is created based on a newly added field value
>> in the struct snd_usb_audio_quirk. Using this approach, the
>> media controller API usage can be added for a specific device.
>> In this patch, media controller API is enabled for AU0828 hw.
>> snd_usb_create_quirk() will check this new field, if set will
>> create a media device using media_device_get_devres() interface.
>> media_device_get_devres() will allocate a new media device
>> devres or return an existing one, if it finds one.
>>
>> During probe, media usb driver could have created the media
>> device devres. It will then register the media device if it
>> isn't already registered. Media device unregister is done
>> from usb_audio_disconnect().
>>
>> New structure media_ctl is added to group the new fields
>> to support media entity and links. This new structure is
>> added to struct snd_usb_substream. A new media entity for
>> ALSA and a link from tuner entity to the newly registered
>> ALSA entity are created from snd_usb_init_substream() and
>> removed from free_substream(). The state is kept to indicate
>> if tuner is linked. This is to account for case when tuner
>> entity doesn't exist. Media pipeline gets started to mark
>> the tuner busy from snd_usb_substream_capture_trigger in
>> response to SNDRV_PCM_TRIGGER_START and pipeline is stopped
>> in response to SNDRV_PCM_TRIGGER_STOP. snd_usb_pcm_close()
>> stops pipeline to cover the case when SNDRV_PCM_TRIGGER_STOP
>> isn't issued. Pipeline start and stop are done only when
>> tuner_linked is set.
>>
>> Tested with and without CONFIG_MEDIA_CONTROLLER enabled.
>> Tested tuner entity doesn't exist case as au0828 v4l2
>> driver is the one that will create the tuner when it gets
>> updated to use media controller API.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  sound/usb/Makefile       |   3 +-
>>  sound/usb/card.c         |   5 ++
>>  sound/usb/card.h         |   1 +
>>  sound/usb/media.c        | 181 +++++++++++++++++++++++++++++++++++++++++++++++
>>  sound/usb/media.h        |  40 +++++++++++
>>  sound/usb/pcm.c          |  10 ++-
>>  sound/usb/quirks-table.h |   1 +
>>  sound/usb/quirks.c       |   9 ++-
>>  sound/usb/stream.c       |   3 +
>>  sound/usb/usbaudio.h     |   1 +
>>  10 files changed, 251 insertions(+), 3 deletions(-)
>>  create mode 100644 sound/usb/media.c
>>  create mode 100644 sound/usb/media.h
>>
>> diff --git a/sound/usb/Makefile b/sound/usb/Makefile
>> index 2d2d122..7fe4fdd 100644
>> --- a/sound/usb/Makefile
>> +++ b/sound/usb/Makefile
>> @@ -13,7 +13,8 @@ snd-usb-audio-objs := 	card.o \
>>  			pcm.o \
>>  			proc.o \
>>  			quirks.o \
>> -			stream.o
>> +			stream.o \
>> +			media.o
>>  
>>  snd-usbmidi-lib-objs := midi.o
>>  
>> diff --git a/sound/usb/card.c b/sound/usb/card.c
>> index 1fab977..469d2bf 100644
>> --- a/sound/usb/card.c
>> +++ b/sound/usb/card.c
>> @@ -66,6 +66,7 @@
>>  #include "format.h"
>>  #include "power.h"
>>  #include "stream.h"
>> +#include "media.h"
>>  
>>  MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
>>  MODULE_DESCRIPTION("USB Audio");
>> @@ -619,6 +620,10 @@ static void usb_audio_disconnect(struct usb_interface *intf)
>>  		list_for_each_entry(mixer, &chip->mixer_list, list) {
>>  			snd_usb_mixer_disconnect(mixer);
>>  		}
>> +		/* Nice to check quirk && quirk->media_device
>> +		 * need some special handlings. Doesn't look like
>> +		 * we have access to quirk here */
>> +		media_device_delete(intf);
>>  	}
>>  
>>  	chip->num_interfaces--;
>> diff --git a/sound/usb/card.h b/sound/usb/card.h
>> index ef580b4..235a85f 100644
>> --- a/sound/usb/card.h
>> +++ b/sound/usb/card.h
>> @@ -155,6 +155,7 @@ struct snd_usb_substream {
>>  	} dsd_dop;
>>  
>>  	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
>> +	void *media_ctl;
>>  };
>>  
>>  struct snd_usb_stream {
>> diff --git a/sound/usb/media.c b/sound/usb/media.c
>> new file mode 100644
>> index 0000000..8e8a0b3
>> --- /dev/null
>> +++ b/sound/usb/media.c
>> @@ -0,0 +1,181 @@
>> +/*
>> + * media.c - managed media token resource
>> + *
>> + * Copyright (c) 2015 Shuah Khan <shuahkh@osg.samsung.com>
>> + * Copyright (c) 2015 Samsung Electronics Co., Ltd.
>> + *
>> + * This file is released under the GPLv2.
>> + */
>> +
>> +/*
>> + * This file adds Media Controller support to ALSA driver
>> + * to use the Media Controller API to share tuner with DVB
>> + * and V4L2 drivers that control media device. Media device
>> + * is created based on existing quirks framework. Using this
>> + * approach, the media controller API usage can be added for
>> + * a specific device.
>> +*/
>> +
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +#if defined(CONFIG_MEDIA_SUPPORT) || \
>> +	(defined(CONFIG_MEDIA_SUPPORT_MODULE) && defined(MODULE))
>> +#define USE_MEDIA_CONTROLLER
>> +#endif
>> +#endif
>> +
>> +#include <linux/init.h>
>> +#include <linux/list.h>
>> +#include <linux/slab.h>
>> +#include <linux/string.h>
>> +#include <linux/ctype.h>
>> +#include <linux/usb.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/mutex.h>
>> +#include <linux/usb/audio.h>
>> +#include <linux/usb/audio-v2.h>
>> +#include <linux/module.h>
>> +
>> +#include <sound/control.h>
>> +#include <sound/core.h>
>> +#include <sound/info.h>
>> +#include <sound/pcm.h>
>> +#include <sound/pcm_params.h>
>> +#include <sound/initval.h>
>> +
>> +#include "usbaudio.h"
>> +#include "card.h"
>> +#include "midi.h"
>> +#include "mixer.h"
>> +#include "proc.h"
>> +#include "quirks.h"
>> +#include "endpoint.h"
>> +#include "helper.h"
>> +#include "debug.h"
>> +#include "pcm.h"
>> +#include "format.h"
>> +#include "power.h"
>> +#include "stream.h"
>> +#include "media.h"
>> +
>> +#ifdef USE_MEDIA_CONTROLLER
> 
> Nah. Please move this test to Makefile and add the stubs to media.h header.

Yes that is a good way to go.

> 
>> +int media_device_init(struct usb_interface *iface)
>> +{
>> +	struct media_device *mdev;
>> +	struct usb_device *usbdev = interface_to_usbdev(iface);
>> +	int ret;
>> +
>> +	mdev = media_device_get_devres(&usbdev->dev);
>> +	if (!mdev)
>> +		return -ENOMEM;
>> +	if (!media_devnode_is_registered(&mdev->devnode)) {
>> +		/* register media device */
>> +		mdev->dev = &usbdev->dev;
>> +		if (usbdev->product)
>> +			strlcpy(mdev->model, usbdev->product,
>> +				sizeof(mdev->model));
>> +		if (usbdev->serial)
>> +			strlcpy(mdev->serial, usbdev->serial,
>> +				sizeof(mdev->serial));
>> +		strcpy(mdev->bus_info, usbdev->devpath);
>> +		mdev->hw_revision = le16_to_cpu(usbdev->descriptor.bcdDevice);
>> +		ret = media_device_register(mdev);
>> +		if (ret) {
>> +			dev_err(&usbdev->dev,
>> +				"Couldn't create a media device. Error: %d\n",
>> +				ret);
>> +			return ret;
>> +		}
>> +	}
>> +	dev_info(&usbdev->dev, "Created media device.\n");
>> +	return 0;
>> +}
>> +
>> +void media_device_delete(struct usb_interface *iface)
>> +{
>> +	struct media_device *mdev;
>> +	struct usb_device *usbdev = interface_to_usbdev(iface);
>> +
>> +	mdev = media_device_find_devres(&usbdev->dev);
>> +	if (mdev && media_devnode_is_registered(&mdev->devnode))
>> +		media_device_unregister(mdev);
>> +	dev_info(&usbdev->dev, "Deleted media device.\n");
>> +}
>> +
>> +void media_stream_init(struct snd_usb_substream *subs)
>> +{
>> +	struct media_device *mdev;
>> +	struct media_ctl *mctl;
>> +	struct media_entity *entity;
>> +	int ret;
>> +
>> +	mdev = media_device_find_devres(&subs->dev->dev);
>> +	if (!mdev)
>> +		return;
>> +
>> +	/* allocate media_ctl */
>> +	mctl = kzalloc(sizeof(struct media_ctl), GFP_KERNEL);
>> +	if (!mctl)
>> +		return;
>> +
>> +	mctl->media_dev = mdev;
>> +	mctl->media_entity.type = MEDIA_ENT_T_DEVNODE_ALSA;
>> +	media_entity_init(&mctl->media_entity, 1, &mctl->media_pads, 0);
>> +	media_device_register_entity(mctl->media_dev, &mctl->media_entity);
> 
> Looks ok, but we'll likely need to change from DEVNODE_ALSA to something
> else to reflect what alsa components (sub-devices?) will be actually
> being registered: mixer, pcm playback, pcm capture, etc;

Yes. This might need changes to reflect the full media graph.

> 
>> +	media_device_for_each_entity(entity, mctl->media_dev) {
>> +		switch (entity->type) {
>> +		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
>> +			ret = media_entity_create_link(entity, 0,
>> +						 &mctl->media_entity, 0,
>> +						 MEDIA_LNK_FL_ENABLED);
> 
> I don't think that this code belongs here.
> 
> The proper thing to do seems to add a hook that would be called every
> time that media_entity_create() is called.
> 
> Inside the hook code, if both alsa mixer and tuner are registered, it
> will create the above link.
> 
> Such hook would be registered by some function call. At the time 
> such function would be called, the hook code will also run.

One way we can do this in a generic way would be as follows. This
might help other media driver interactions in creating entities
as well.

Add a new ops to struct media_entity_operations to be called when
a new entity id registered so existing entities can take necessary
action in response to new entity registration. This hook could be
invoked for all existing entities as well as the new one, so the
new entity can create necessary links.

If snd-usb-audio is the the first one to create entity, when au0828
comes along and registers its entity, snd-usb-audio's
media_entity_operations hook can be called and in that hook it can
create links. If au0828 comes along first, then when snd-usb-audio
registers its entity and when its new hook is called, it can create
the necessary links.

How does this sound? I could make the changes and see if it works.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
