Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51689
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753415AbcLFSlt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 13:41:49 -0500
Subject: Re: [PATCH v6 3/3] sound/usb: Use Media Controller API to share media
 resources
To: Takashi Iwai <tiwai@suse.de>, mchehab@kernel.org
References: <cover.1480539942.git.shuahkh@osg.samsung.com>
 <ebeaa42019b102f76d87a2fc4aa7793e1f87072c.1480539942.git.shuahkh@osg.samsung.com>
 <s5h8trt5z64.wl-tiwai@suse.de>
Cc: geliangtang@163.com, hans.verkuil@cisco.com,
        chehabrafael@gmail.com, mahasler@gmail.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        clemens@ladisch.de, k@oikw.org, javier@osg.samsung.com,
        perex@perex.cz, vdronov@redhat.com,
        Oliver Neukum <ONeukum@suse.com>, daniel@zonque.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <4563c1af-df2f-bcb5-4ff5-05acf79e6690@osg.samsung.com>
Date: Tue, 6 Dec 2016 11:41:37 -0700
MIME-Version: 1.0
In-Reply-To: <s5h8trt5z64.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Takashi,

On 12/05/2016 11:50 PM, Takashi Iwai wrote:
> On Wed, 30 Nov 2016 23:01:16 +0100,
> Shuah Khan wrote:
>>
>> --- a/sound/usb/card.c
>> +++ b/sound/usb/card.c
> (snip)
>> @@ -616,6 +617,11 @@ static int usb_audio_probe(struct usb_interface *intf,
>>  	if (err < 0)
>>  		goto __error;
>>  
>> +	if (quirk && quirk->media_device) {
>> +		/* don't want to fail when media_snd_device_create() fails */
>> +		media_snd_device_create(chip, intf);
> 
> Note that the usb-audio driver is probed for each usb interface, and
> there are multiple interfaces per device.  That is, usb_audio_probe()
> may be called multiple times per device, and at the second or the
> later calls, it appends the stuff onto the previously created card
> object.
> 
> So, you'd have to make this call also conditional (e.g. check
> chip->num_interfaces == 0, indicating the very first one), or allow to
> be called multiple times.
> 
> In the former case, it'd be better to split media_snd_device_create()
> and media_snd_mixer_init().  The *_device_create() needs to be called
> only once, while *_mixer_init() still has to be called for each time
> because the new mixer element may be added for each interface.
> 

Thanks for the catch. I am able to fix this in media_snd_device_create()
I made a change to do media_dev allocate only once. media_snd_mixer_init()
will get called every time media_snd_device_create() is called. This way
new mixers can be handled. media_snd_mixer_init() has logic to deal with
mixers that are already initialized. We are good here with the following
change:

@@ -272,6 +258,14 @@ int media_snd_device_create(struct snd_usb_audio *chip,
        struct usb_device *usbdev = interface_to_usbdev(iface);
        int ret;
 
+       /* usb-audio driver is probed for each usb interface, and
+        * there are multiple interfaces per device. Avoid calling
+        * media_device_usb_allocate() each time usb_audio_probe()
+        * is called. Do it only once.
+        */
+       if (chip->media_dev)
+               goto snd_mixer_init;
+
        mdev = media_device_usb_allocate(usbdev, KBUILD_MODNAME);
        if (!mdev)
                return -ENOMEM;
@@ -291,6 +285,7 @@ int media_snd_device_create(struct snd_usb_audio *chip,
        /* save media device - avoid lookups */
        chip->media_dev = mdev;
 
+snd_mixer_init:
        /* Create media entities for mixer and control dev */
        ret = media_snd_mixer_init(chip);
        if (ret) {

> 
>> +	}
>> +
>>  	usb_chip[chip->index] = chip;
>>  	chip->num_interfaces++;
>>  	usb_set_intfdata(intf, chip);
>> @@ -672,6 +678,14 @@ static void usb_audio_disconnect(struct usb_interface *intf)
>>  		list_for_each(p, &chip->midi_list) {
>>  			snd_usbmidi_disconnect(p);
>>  		}
>> +		/*
>> +		 * Nice to check quirk && quirk->media_device and
>> +		 * then call media_snd_device_delete(). Don't have
>> +		 * access to quirk here. media_snd_device_delete()
>> +		 * acceses mixer_list
>> +		 */
>> +		media_snd_device_delete(chip);
> 
> ... meanwhile this is OK, as it's called only once.
> 
> (BTW, is it OK to call media_* stuff while the device is still in use?
>  The disconnect callback gets called for hot-unplug.)
> 

Yes. All of the media_* functions that get called during run-time check for
chip->media_dev or media_ctl and do nothing when these are null.

media_device itself will not be free'd until all reference are gone. When
usb_audio_disconnect() happens via unbind snd_usb_audio or physical remove,
media_dev sticks around until au0828 (media driver) goes away. There is
handling for any user apps. that have /dev/mediaX open.

Does this sound correct? Did I miss any of your concerns?

> 
>> --- /dev/null
>> +++ b/sound/usb/media.c
> (snip)
>> +void media_snd_stream_delete(struct snd_usb_substream *subs)
>> +{
>> +	struct media_ctl *mctl = subs->media_ctl;
>> +
>> +	if (mctl && mctl->media_dev) {
> 
> mctl->media_dev NULL check here is superfluous, as it's checked
> mctl->below.
> 

Done.

>> +		struct media_device *mdev;
>> +
>> +		mdev = mctl->media_dev;
>> +		if (mdev && media_devnode_is_registered(mdev->devnode)) {
>> +			media_devnode_remove(mctl->intf_devnode);
>> +			media_device_unregister_entity(&mctl->media_entity);
>> +			media_entity_cleanup(&mctl->media_entity);
>> +		}
>> +		kfree(mctl);
>> +		subs->media_ctl = NULL;
>> +	}
>> +}
>> +
>> +int media_snd_start_pipeline(struct snd_usb_substream *subs)
>> +{
>> +	struct media_ctl *mctl = subs->media_ctl;
>> +
>> +	if (mctl)
>> +		return media_snd_enable_source(mctl);
>> +	return 0;
>> +}
> 
> It's merely a wrapper, and media_snd_enable_source() itself checks
> NULL mctl.  So we can replace media_snd_enable_source() with
> media_snd_start_pipeline().

Done.

> 
>> +void media_snd_stop_pipeline(struct snd_usb_substream *subs)
>> +{
>> +	struct media_ctl *mctl = subs->media_ctl;
>> +
>> +	if (mctl)
>> +		media_snd_disable_source(mctl);
>> +}
> 
> Ditto.

Done.

> 
>> diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
>> index 44d178e..0e4e0640 100644
>> --- a/sound/usb/pcm.c
>> +++ b/sound/usb/pcm.c
> (snip)
>> @@ -717,10 +718,14 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
>>  	struct audioformat *fmt;
>>  	int ret;
>>  
>> +	ret = media_snd_start_pipeline(subs);
>> +	if (ret)
>> +		return ret;
> 
> It's an open question at which timing we should call
> media_snd_start_pipeline().  The hw_params is mostly OK, while the
> real timing where the stream might be started is the prepare
> callback.  I guess we can keep as is for now.

Okay.

> 
> Also, one more thing to be considered is whether
> media_snd_start_pipeline() can be called multiple times.  hw_params
> and prepare callbacks may be called multiple times.  I suppose it's
> OK, but just to be sure.

Yes. media_snd_start_pipeline() can be called multiple times. v4l2 apps.
also call start_pipeline multiple times. So we are good here.

> 
> 
>> @@ -1234,7 +1246,12 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
>>  	subs->dsd_dop.channel = 0;
>>  	subs->dsd_dop.marker = 1;
>>  
>> -	return setup_hw_info(runtime, subs);
>> +	ret = setup_hw_info(runtime, subs);
>> +	if (ret == 0)
>> +		ret = media_snd_stream_init(subs, as->pcm, direction);
>> +	if (ret)
>> +		snd_usb_autosuspend(subs->stream->chip);
>> +	return ret;
> 
> This leads to the PM refcount unbalance.  The call of
> snd_usb_autosuspend() must be in the former if block,
> 
> 	ret = setup_hw_info(runtime, subs);
> 	if (ret == 0) {
> 		ret = media_snd_stream_init(subs, as->pcm, direction);
> 		if (ret)
> 			snd_usb_autosuspend(subs->stream->chip);
> 	}
> 	return ret;

Done.

> 
> 
> thanks,
> 
> Takashi
> 

Mauro,

I will send patch v7 and include the others in the series that don't need
changes to keep them grouped.

thanks,
-- Shuah

