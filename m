Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45737 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbcLFTGV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 14:06:21 -0500
Date: Tue, 06 Dec 2016 20:06:16 +0100
Message-ID: <s5hfum0513r.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, geliangtang@163.com, hans.verkuil@cisco.com,
        chehabrafael@gmail.com, mahasler@gmail.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        clemens@ladisch.de, k@oikw.org, javier@osg.samsung.com,
        perex@perex.cz, vdronov@redhat.com,
        Oliver Neukum <ONeukum@suse.com>, daniel@zonque.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v6 3/3] sound/usb: Use Media Controller API to share media resources
In-Reply-To: <4563c1af-df2f-bcb5-4ff5-05acf79e6690@osg.samsung.com>
References: <cover.1480539942.git.shuahkh@osg.samsung.com>
        <ebeaa42019b102f76d87a2fc4aa7793e1f87072c.1480539942.git.shuahkh@osg.samsung.com>
        <s5h8trt5z64.wl-tiwai@suse.de>
        <4563c1af-df2f-bcb5-4ff5-05acf79e6690@osg.samsung.com>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 06 Dec 2016 19:41:37 +0100,
Shuah Khan wrote:
> 
> Hi Takashi,
> 
> On 12/05/2016 11:50 PM, Takashi Iwai wrote:
> > On Wed, 30 Nov 2016 23:01:16 +0100,
> > Shuah Khan wrote:
> >>
> >> --- a/sound/usb/card.c
> >> +++ b/sound/usb/card.c
> > (snip)
> >> @@ -616,6 +617,11 @@ static int usb_audio_probe(struct usb_interface *intf,
> >>  	if (err < 0)
> >>  		goto __error;
> >>  
> >> +	if (quirk && quirk->media_device) {
> >> +		/* don't want to fail when media_snd_device_create() fails */
> >> +		media_snd_device_create(chip, intf);
> > 
> > Note that the usb-audio driver is probed for each usb interface, and
> > there are multiple interfaces per device.  That is, usb_audio_probe()
> > may be called multiple times per device, and at the second or the
> > later calls, it appends the stuff onto the previously created card
> > object.
> > 
> > So, you'd have to make this call also conditional (e.g. check
> > chip->num_interfaces == 0, indicating the very first one), or allow to
> > be called multiple times.
> > 
> > In the former case, it'd be better to split media_snd_device_create()
> > and media_snd_mixer_init().  The *_device_create() needs to be called
> > only once, while *_mixer_init() still has to be called for each time
> > because the new mixer element may be added for each interface.
> > 
> 
> Thanks for the catch. I am able to fix this in media_snd_device_create()
> I made a change to do media_dev allocate only once. media_snd_mixer_init()
> will get called every time media_snd_device_create() is called. This way
> new mixers can be handled. media_snd_mixer_init() has logic to deal with
> mixers that are already initialized. We are good here with the following
> change:
> 
> @@ -272,6 +258,14 @@ int media_snd_device_create(struct snd_usb_audio *chip,
>         struct usb_device *usbdev = interface_to_usbdev(iface);
>         int ret;
>  
> +       /* usb-audio driver is probed for each usb interface, and
> +        * there are multiple interfaces per device. Avoid calling
> +        * media_device_usb_allocate() each time usb_audio_probe()
> +        * is called. Do it only once.
> +        */
> +       if (chip->media_dev)
> +               goto snd_mixer_init;
> +
>         mdev = media_device_usb_allocate(usbdev, KBUILD_MODNAME);
>         if (!mdev)
>                 return -ENOMEM;
> @@ -291,6 +285,7 @@ int media_snd_device_create(struct snd_usb_audio *chip,
>         /* save media device - avoid lookups */
>         chip->media_dev = mdev;
>  
> +snd_mixer_init:
>         /* Create media entities for mixer and control dev */
>         ret = media_snd_mixer_init(chip);
>         if (ret) {

This looks good enough, yes.

> 
> > 
> >> +	}
> >> +
> >>  	usb_chip[chip->index] = chip;
> >>  	chip->num_interfaces++;
> >>  	usb_set_intfdata(intf, chip);
> >> @@ -672,6 +678,14 @@ static void usb_audio_disconnect(struct usb_interface *intf)
> >>  		list_for_each(p, &chip->midi_list) {
> >>  			snd_usbmidi_disconnect(p);
> >>  		}
> >> +		/*
> >> +		 * Nice to check quirk && quirk->media_device and
> >> +		 * then call media_snd_device_delete(). Don't have
> >> +		 * access to quirk here. media_snd_device_delete()
> >> +		 * acceses mixer_list
> >> +		 */
> >> +		media_snd_device_delete(chip);
> > 
> > ... meanwhile this is OK, as it's called only once.
> > 
> > (BTW, is it OK to call media_* stuff while the device is still in use?
> >  The disconnect callback gets called for hot-unplug.)
> > 
> 
> Yes. All of the media_* functions that get called during run-time check for
> chip->media_dev or media_ctl and do nothing when these are null.
> 
> media_device itself will not be free'd until all reference are gone. When
> usb_audio_disconnect() happens via unbind snd_usb_audio or physical remove,
> media_dev sticks around until au0828 (media driver) goes away. There is
> handling for any user apps. that have /dev/mediaX open.
> 
> Does this sound correct? Did I miss any of your concerns?

That sounds all good, so it's safe to call there.


thanks,

Takashi
