Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:10927 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3L1MeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:34:24 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYI004YIO9AGA00@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 07:34:22 -0500 (EST)
Date: Sat, 28 Dec 2013 10:34:13 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3 21/24] em28xx: USB: adjust for changed 3.8 USB API
Message-id: <20131228103413.5d903df0.m.chehab@samsung.com>
In-reply-to: <52BEC358.9000004@xs4all.nl>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
 <1388232976-20061-22-git-send-email-mchehab@redhat.com>
 <52BEC358.9000004@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 13:26:00 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 12/28/2013 01:16 PM, Mauro Carvalho Chehab wrote:
> > From: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > 
> > The recent changes in the USB API ("implement new semantics for
> > URB_ISO_ASAP") made the former meaning of the URB_ISO_ASAP flag the
> > default, and changed this flag to mean that URBs can be delayed.
> > This is not the behaviour wanted by any of the audio drivers because
> > it leads to discontinuous playback with very small period sizes.
> > Therefore, our URBs need to be submitted without this flag.
> 
> Does this affect other drivers as well? E.g. cx231xx-audio.c uses this
> as well.

Likely yes. 

I should have tagged this specific patch as RFC, more tests are needed
for this change.

In a matter of fact, at least on the test machine I'm using here, I didn't
notice any difference with or without this patch. 

However, on another test machine, audio was not behaving well with some
USB devices, and I'm hoping that this change will fix it.
 
Unfortunately, I'm currently without access to any other test hardware
until the end of the next week.

> Regards,
> 
> 	Hans
> 
> > 
> > This patch implements the same fix as found at snd-usb-audio driver
> > (commit c75c5ab575af7db707689cdbb5a5c458e9a034bb)
> > 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-audio.c | 2 +-
> >  drivers/media/usb/em28xx/em28xx-core.c  | 3 +--
> >  2 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> > index a6eef06ffdcd..54f4eb6d513c 100644
> > --- a/drivers/media/usb/em28xx/em28xx-audio.c
> > +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> > @@ -195,7 +195,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
> >  		urb->dev = dev->udev;
> >  		urb->context = dev;
> >  		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
> > -		urb->transfer_flags = URB_ISO_ASAP;
> > +		urb->transfer_flags = 0;
> >  		urb->transfer_buffer = dev->adev.transfer_buffer[i];
> >  		urb->interval = 1;
> >  		urb->complete = em28xx_audio_isocirq;
> > diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> > index d6928d83fb2a..8376b9e6397f 100644
> > --- a/drivers/media/usb/em28xx/em28xx-core.c
> > +++ b/drivers/media/usb/em28xx/em28xx-core.c
> > @@ -953,8 +953,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
> >  			usb_fill_int_urb(urb, dev->udev, pipe,
> >  					 usb_bufs->transfer_buffer[i], sb_size,
> >  					 em28xx_irq_callback, dev, 1);
> > -			urb->transfer_flags = URB_ISO_ASAP |
> > -					      URB_NO_TRANSFER_DMA_MAP;
> > +			urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
> >  			k = 0;
> >  			for (j = 0; j < usb_bufs->num_packets; j++) {
> >  				urb->iso_frame_desc[j].offset = k;
> > 
> 


-- 

Cheers,
Mauro
