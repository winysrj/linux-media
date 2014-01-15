Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:55502 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaAOXLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 18:11:42 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZG00ESUTRHFC40@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Jan 2014 18:11:41 -0500 (EST)
Date: Wed, 15 Jan 2014 21:11:37 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFT PATCH] em28xx-audio: don't overwrite the usb alt setting made
 by the video part
Message-id: <20140115211137.2dc33033@samsung.com>
In-reply-to: <52D6FF59.6010407@googlemail.com>
References: <1389821502-11346-1-git-send-email-fschaefer.oss@googlemail.com>
 <52D6FF59.6010407@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 15 Jan 2014 22:36:25 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 15.01.2014 22:31, schrieb Frank Schäfer:
> > em28xx-audio currently switches to usb alternate setting #7 in case of a mixed
> > interface. This may overwrite the setting made by the video part and break video
> > streaming.
> > As far as we know, there is no difference between the alt settings with regards
> > to the audio endpoint if the interface is a mixed interface, the audio part only
> > has to make sure that alt is > 0, which is fortunately only the case when video
> > streaming is off.
> >
> > Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-audio.c |   41 ++++++++++++-------------------
> >  1 Datei geändert, 16 Zeilen hinzugefügt(+), 25 Zeilen entfernt(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> > index 05e9bd1..2e7a3ad 100644
> > --- a/drivers/media/usb/em28xx/em28xx-audio.c
> > +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> > @@ -266,33 +266,30 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
> >  	dprintk("opening device and trying to acquire exclusive lock\n");
> >  
> >  	runtime->hw = snd_em28xx_hw_capture;
> > -	if ((dev->alt == 0 || dev->is_audio_only) && dev->adev.users == 0) {
> > -		int nonblock = !!(substream->f_flags & O_NONBLOCK);
> >  
> > +	if (dev->adev.users == 0) {
> > +		int nonblock = !!(substream->f_flags & O_NONBLOCK);
> >  		if (nonblock) {
> >  			if (!mutex_trylock(&dev->lock))
> >  				return -EAGAIN;
> >  		} else
> >  			mutex_lock(&dev->lock);
> > -		if (dev->is_audio_only)
> > -			/* vendor audio is on a separate interface */
> > +
> > +		/* Select initial alternate setting (if necessary) */
> > +		if (dev->alt == 0) {
> >  			dev->alt = 1;
> > -		else
> > -			/* vendor audio is on the same interface as video */
> > -			dev->alt = 7;
> >  			/*
> > -			 * FIXME: The intention seems to be to select the alt
> > -			 * setting with the largest wMaxPacketSize for the video
> > -			 * endpoint.
> > -			 * At least dev->alt should be used instead, but we
> > -			 * should probably not touch it at all if it is
> > -			 * already >0, because wMaxPacketSize of the audio
> > -			 * endpoints seems to be the same for all.
> > +			 * NOTE: in case of a mixed (audio+video) interface, we
> > +			 * don't want to touch the alt setting made by the video
> > +			 * part. There is no difference between the alt settings
> > +			 * with regards to the audio endpoint.
> > +			 * TODO: in case of a pure audio interface, this could
> > +			 * be improved. The alt settings are different here.
> >  			 */
> > -
> > -		dprintk("changing alternate number on interface %d to %d\n",
> > -			dev->ifnum, dev->alt);
> > -		usb_set_interface(dev->udev, dev->ifnum, dev->alt);
> > +			dprintk("changing alternate number on interface %d to %d\n",
> > +				dev->ifnum, dev->alt);
> > +			usb_set_interface(dev->udev, dev->ifnum, dev->alt);
> > +		}
> >  
> >  		/* Sets volume, mute, etc */
> >  		dev->mute = 0;
> > @@ -740,15 +737,9 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
> >  	struct usb_endpoint_descriptor *e, *ep = NULL;
> >  	int                 i, ep_size, interval, num_urb, npackets;
> >  	int		    urb_size, bytes_per_transfer;
> > -	u8 alt;
> > -
> > -	if (dev->ifnum)
> > -		alt = 1;
> > -	else
> > -		alt = 7;
> > +	u8 alt = 1;
> >  
> >  	intf = usb_ifnum_to_if(dev->udev, dev->ifnum);
> > -
> >  	if (intf->num_altsetting <= alt) {
> >  		em28xx_errdev("alt %d doesn't exist on interface %d\n",
> >  			      dev->ifnum, alt);
> 
> Please note that this is actually just a minor fix.
> What's really evil with the current alternate setting code is that the
> video part may switch the alt setting while audio streaming is in progress.
> I'm not sure how to fix this. Maybe we shouldn't start audio streaming
> before video streaming.

This patch will very likely break em28xx audio. The change to use alt=7
was added there because em28xx can only deliver a certain number of URBs
per a given period of time. In other words, if the video-only calculated
alternate is used, when audio starts, the em28xx DMA engine half-fills
some video URBs.

As I said, the right fix here is to have a bandwidth estimator that will
take both traffics into account (when both are activated), and select
the right alternate.

Such patch should be tested with more than one device type, as I think
that em284x are somewhat different than em286x and em288x with this
regards.

Regards,
Mauro
