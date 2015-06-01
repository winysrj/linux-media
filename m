Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45023 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbbFAPv5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 11:51:57 -0400
Message-ID: <556C7F93.9060009@osg.samsung.com>
Date: Mon, 01 Jun 2015 09:51:47 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, hans.verkuil@cisco.com
CC: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	perex@perex.cz, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, vladcatoi@gmail.com, damien@zamaudio.com,
	chris.j.arges@canonical.com, takamichiho@gmail.com,
	misterpib@gmail.com, daniel@zonque.org, pmatilai@laiskiainen.org,
	jussi@sonarnerd.net, normalperson@yhbt.net, fisch602@gmail.com,
	joe@oampo.co.uk, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/2] sound/usb: Update ALSA driver to use media controller
 API
References: <cover.1431110739.git.shuahkh@osg.samsung.com> <dd21d1282a85d620be1aae497b66ccb355e458ba.1431110739.git.shuahkh@osg.samsung.com> <s5hbnh69h6e.wl-tiwai@suse.de>
In-Reply-To: <s5hbnh69h6e.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2015 09:24 AM, Takashi Iwai wrote:
> At Fri,  8 May 2015 13:31:31 -0600,
> Shuah Khan wrote:
>>
>> Change ALSA driver to use media controller API to share tuner
>> with DVB and V4L2 drivers that control AU0828 media device.
>> Media device is created based on a newly added field value
>> in the struct snd_usb_audio_quirk. Using this approach, the
>> media controller API usage can be added for a specific device.
>> In this patch, media controller API is enabled for AU0828 hw.
>> snd_usb_create_quirk() will check this new field, if set will
>> create a media device using media_device_get_dr() interface.
>> media_device_get_dr() will allocate a new media device device
>> resource or return an existing one if it exists. During probe,
>> media usb driver could have created the media device. It will
>> then register the media device if it isn't already registered.
>> Media device unregister is done from usb_audio_disconnect().
>>
>> New fields to add support for media entity and links are
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
> 
> I guess it gets broken when CONFIG_MEDIA_SUPPORT=m while
> CONFIG_SND*=y.  So, it should be compiled in only when the media
> support is built-in or both sound and media are module, i.e.
> 
> #ifdef CONFIG_MEDIA_CONTROLLER
> #if defined(CONFIG_MEDIA_SUPPORT) || \
>     (defined(CONFIG_MEDIA_SUPPORT_MODULE) && defined(MODULE))
> #define I_CAN_USE_MEDIA_CONTROLLER
> #endif
> #endif
> 
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  sound/usb/card.c         |  5 +++++
>>  sound/usb/card.h         | 12 ++++++++++
>>  sound/usb/pcm.c          | 23 ++++++++++++++++++-
>>  sound/usb/quirks-table.h |  1 +
>>  sound/usb/quirks.c       | 58 +++++++++++++++++++++++++++++++++++++++++++++++-
>>  sound/usb/quirks.h       |  6 +++++
>>  sound/usb/stream.c       | 40 +++++++++++++++++++++++++++++++++
>>  sound/usb/usbaudio.h     |  1 +
>>  8 files changed, 144 insertions(+), 2 deletions(-)
>>
>> diff --git a/sound/usb/card.c b/sound/usb/card.c
>> index 1fab977..587fc24 100644
>> --- a/sound/usb/card.c
>> +++ b/sound/usb/card.c
>> @@ -621,6 +621,11 @@ static void usb_audio_disconnect(struct usb_interface *intf)
>>  		}
>>  	}
>>  
>> +	/* Nice to check quirk && quirk->media_device
>> +	 * need some special handlings. Doesn't look like
>> +	 * we have access to quirk here */
>> +	media_device_delete(intf);
> 
> This should be called once, so better in if (!was_shutdown) block, I
> guess.

Moved it under if (!was_shutdown) block.

> 
> Apart from that, yes, a good way to call an optional destructor for
> quirks would be better.

Maybe something to look into as an enhancement for quirk handling.

> 
> 
>>  	chip->num_interfaces--;
>>  	if (chip->num_interfaces <= 0) {
>>  		usb_chip[chip->index] = NULL;
>> diff --git a/sound/usb/card.h b/sound/usb/card.h
>> index ef580b4..477bdcd 100644
>> --- a/sound/usb/card.h
>> +++ b/sound/usb/card.h
>> @@ -1,6 +1,11 @@
>>  #ifndef __USBAUDIO_CARD_H
>>  #define __USBAUDIO_CARD_H
>>  
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +#include <media/media-device.h>
>> +#include <media/media-entity.h>
>> +#endif
>> +
>>  #define MAX_NR_RATES	1024
>>  #define MAX_PACKS	6		/* per URB */
>>  #define MAX_PACKS_HS	(MAX_PACKS * 8)	/* in high speed mode */
>> @@ -155,6 +160,13 @@ struct snd_usb_substream {
>>  	} dsd_dop;
>>  
>>  	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +	struct media_device *media_dev;
>> +	struct media_entity media_entity;
>> +	struct media_pad media_pads;
>> +	struct media_pipeline media_pipe;
>> +	bool   tuner_linked;
>> +#endif
> 
> Maybe a slightly better idea is to allocate these in a new record and
> stores the pointer in stream->media_ctl or whatever new field.
> Then, a check like
> 	if (subs->tuner_linked)
> can be replaced with
> 	if (subs->media_ctl)
> 
> The whole media-specific stuff can be gathered in a single file,
> e.g. sound/usb/media.c, and there you can define the struct.
> 
> 
>>  };
>>  
>>  struct snd_usb_stream {
>> diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
>> index b4ef410..c2a40a9 100644
>> --- a/sound/usb/pcm.c
>> +++ b/sound/usb/pcm.c
>> @@ -1225,6 +1225,10 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
>>  
>>  	subs->pcm_substream = NULL;
>>  	snd_usb_autosuspend(subs->stream->chip);
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +	if (subs->tuner_linked)
>> +		media_entity_pipeline_stop(&subs->media_entity);
>> +#endif
> 
> Let's define each of such call properly and drop ifdef at each place.
> 
> 
>>  	return 0;
>>  }
>> @@ -1587,9 +1591,22 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
>>  
>>  	switch (cmd) {
>>  	case SNDRV_PCM_TRIGGER_START:
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +		if (subs->tuner_linked) {
>> +			err = media_entity_pipeline_start(&subs->media_entity,
>> +							  &subs->media_pipe);
>> +			if (err)
>> +				return err;
>> +		}
>> +#endif
>>  		err = start_endpoints(subs, false);
>> -		if (err < 0)
>> +		if (err < 0) {
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +			if (subs->tuner_linked)
>> +				media_entity_pipeline_stop(&subs->media_entity);
>> +#endif
>>  			return err;
>> +		}
>>  
>>  		subs->data_endpoint->retire_data_urb = retire_capture_urb;
>>  		subs->running = 1;
>> @@ -1597,6 +1614,10 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
>>  	case SNDRV_PCM_TRIGGER_STOP:
>>  		stop_endpoints(subs, false);
>>  		subs->running = 0;
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +		if (subs->tuner_linked)
>> +			media_entity_pipeline_stop(&subs->media_entity);
>> +#endif
>>  		return 0;
>>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>>  		subs->data_endpoint->retire_data_urb = NULL;
>> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
>> index 2f6d3e9..51c544f 100644
>> --- a/sound/usb/quirks-table.h
>> +++ b/sound/usb/quirks-table.h
>> @@ -2798,6 +2798,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
>>  		.product_name = pname, \
>>  		.ifnum = QUIRK_ANY_INTERFACE, \
>>  		.type = QUIRK_AUDIO_ALIGN_TRANSFER, \
>> +		.media_device = 1, \
>>  	} \
> 
> I guess this could be implemented with QUIRK_COMPOSITE, too, without
> adding a new field.  But it might result in too complex code.  Let's
> judge it later.
> 

I looked into this. Looks like there is one quirk type allowed
at this time. My initial thought was to make .type an array of
quirk types so a device could have multiple quirk types. I opted
to go with the simpler route to add a new field instead.

> 
>>  }
>>  
>> diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
>> index 7c5a701..468e10f 100644
>> --- a/sound/usb/quirks.c
>> +++ b/sound/usb/quirks.c
>> @@ -503,6 +503,56 @@ static int create_standard_mixer_quirk(struct snd_usb_audio *chip,
>>  	return snd_usb_create_mixer(chip, quirk->ifnum, 0);
>>  }
>>  
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +static int media_device_init(struct usb_interface *iface)
>> +{
>> +	struct media_device *mdev;
>> +	struct usb_device *usbdev = interface_to_usbdev(iface);
>> +	int ret;
>> +
>> +	mdev = media_device_get_dr(&usbdev->dev);
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
>> +	mdev = media_device_find_dr(&usbdev->dev);
>> +	if (mdev && media_devnode_is_registered(&mdev->devnode))
>> +		media_device_unregister(mdev);
>> +	dev_info(&usbdev->dev, "Deleted media device.\n");
>> +}
>> +#else
>> +static inline int media_device_init(struct usb_interface *iface)
>> +{
>> +	return 0;
>> +}
>> +#endif
> 
> Let's move all these media specific code into the single place.
> 

Moved all the media specific code into a new file. I will send
v2 that covers Hans's comments as well later on this week.

P.S: Entity part of the code needs updates once Property API
solidifies.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
