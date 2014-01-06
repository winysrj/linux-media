Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:43879 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaAFQZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 11:25:53 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYZ004ZEMZ3V780@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Jan 2014 11:25:51 -0500 (EST)
Date: Mon, 06 Jan 2014 14:25:47 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 21/22] [media] em28xx-audio: allocate URBs at device
 driver init
Message-id: <20140106142547.514fb625@samsung.com>
In-reply-to: <20140105192557.7feefa69@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
 <1388832951-11195-22-git-send-email-m.chehab@samsung.com>
 <52C9C870.3050006@googlemail.com> <20140105192557.7feefa69@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 19:25:57 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Sun, 05 Jan 2014 22:02:40 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> 
> > Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> > > From: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Is this line still correct ? ;)
> > 
> > > Instead of allocating/deallocating URBs and transfer buffers
> > > every time stream is started/stopped, just do it once.
> > >
> > > That reduces the memory allocation pressure and makes the
> > > code that start/stop streaming a way simpler.
> > >
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > Two Signed-off-by lines ? ;)
> > 
> > > ---
> > >  drivers/media/usb/em28xx/em28xx-audio.c | 128 ++++++++++++++++++--------------
> > >  1 file changed, 73 insertions(+), 55 deletions(-)
> > >
> > > diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> > > index e5120430ec80..30ee389a07f0 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-audio.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> > > @@ -3,7 +3,7 @@
> > >   *
> > >   *  Copyright (C) 2006 Markus Rechberger <mrechberger@gmail.com>
> > >   *
> > > - *  Copyright (C) 2007-2011 Mauro Carvalho Chehab <mchehab@redhat.com>
> > > + *  Copyright (C) 2007-2014 Mauro Carvalho Chehab
> > >   *	- Port to work with the in-kernel driver
> > >   *	- Cleanups, fixes, alsa-controls, etc.
> > >   *
> > > @@ -70,16 +70,6 @@ static int em28xx_deinit_isoc_audio(struct em28xx *dev)
> > >  			usb_kill_urb(urb);
> > >  		else
> > >  			usb_unlink_urb(urb);
> > > -
> > > -		usb_free_coherent(dev->udev,
> > > -				  urb->transfer_buffer_length,
> > > -				  dev->adev.transfer_buffer[i],
> > > -				  urb->transfer_dma);
> > > -
> > > -		dev->adev.transfer_buffer[i] = NULL;
> > > -
> > > -		usb_free_urb(urb);
> > > -		dev->adev.urb[i] = NULL;
> > >  	}
> > >  
> > >  	return 0;
> > > @@ -174,53 +164,14 @@ static void em28xx_audio_isocirq(struct urb *urb)
> > >  static int em28xx_init_audio_isoc(struct em28xx *dev)
> > >  {
> > >  	int       i, errCode;
> > > -	const int sb_size = EM28XX_NUM_AUDIO_PACKETS *
> > > -			    EM28XX_AUDIO_MAX_PACKET_SIZE;
> > >  
> > >  	dprintk("Starting isoc transfers\n");
> > >  
> > > +	/* Start streaming */
> > >  	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> > > -		struct urb *urb;
> > > -		int j, k;
> > > -		void *buf;
> > > -
> > > -		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
> > > -		if (!urb) {
> > > -			em28xx_errdev("usb_alloc_urb failed!\n");
> > > -			for (j = 0; j < i; j++) {
> > > -				usb_free_urb(dev->adev.urb[j]);
> > > -				kfree(dev->adev.transfer_buffer[j]);
> > > -			}
> > > -			return -ENOMEM;
> > > -		}
> > > -
> > > -		buf = usb_alloc_coherent(dev->udev, sb_size, GFP_ATOMIC,
> > > -					 &urb->transfer_dma);
> > > -		if (!buf)
> > > -			return -ENOMEM;
> > > -		dev->adev.transfer_buffer[i] = buf;
> > > -		memset(buf, 0x80, sb_size);
> > > -
> > > -		urb->dev = dev->udev;
> > > -		urb->context = dev;
> > > -		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
> > > -		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
> > > -		urb->transfer_buffer = dev->adev.transfer_buffer[i];
> > > -		urb->interval = 1;
> > > -		urb->complete = em28xx_audio_isocirq;
> > > -		urb->number_of_packets = EM28XX_NUM_AUDIO_PACKETS;
> > > -		urb->transfer_buffer_length = sb_size;
> > > -
> > > -		for (j = k = 0; j < EM28XX_NUM_AUDIO_PACKETS;
> > > -			     j++, k += EM28XX_AUDIO_MAX_PACKET_SIZE) {
> > > -			urb->iso_frame_desc[j].offset = k;
> > > -			urb->iso_frame_desc[j].length =
> > > -			    EM28XX_AUDIO_MAX_PACKET_SIZE;
> > > -		}
> > > -		dev->adev.urb[i] = urb;
> > > -	}
> > > +		memset(dev->adev.transfer_buffer[i], 0x80,
> > > +		       dev->adev.urb[i]->transfer_buffer_length);
> > >  
> > > -	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> > >  		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
> > >  		if (errCode) {
> > >  			em28xx_errdev("submit of audio urb failed\n");
> > > @@ -643,13 +594,36 @@ static struct snd_pcm_ops snd_em28xx_pcm_capture = {
> > >  	.page      = snd_pcm_get_vmalloc_page,
> > >  };
> > >  
> > > +static void em28xx_audio_free_urb(struct em28xx *dev)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> > > +		struct urb *urb = dev->adev.urb[i];
> > > +
> > > +		if (!dev->adev.urb[i])
> > > +			continue;
> > > +
> > > +		usb_free_coherent(dev->udev,
> > > +				  urb->transfer_buffer_length,
> > > +				  dev->adev.transfer_buffer[i],
> > > +				  urb->transfer_dma);
> > > +
> > > +		usb_free_urb(urb);
> > > +		dev->adev.urb[i] = NULL;
> > > +		dev->adev.transfer_buffer[i] = NULL;
> > > +	}
> > > +}
> > > +
> > >  static int em28xx_audio_init(struct em28xx *dev)
> > >  {
> > >  	struct em28xx_audio *adev = &dev->adev;
> > >  	struct snd_pcm      *pcm;
> > >  	struct snd_card     *card;
> > >  	static int          devnr;
> > > -	int                 err;
> > > +	int                 err, i;
> > > +	const int sb_size = EM28XX_NUM_AUDIO_PACKETS *
> > > +			    EM28XX_AUDIO_MAX_PACKET_SIZE;
> > >  
> > >  	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
> > >  		/* This device does not support the extension (in this case
> > > @@ -662,7 +636,8 @@ static int em28xx_audio_init(struct em28xx *dev)
> > >  
> > >  	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
> > >  			 "Rechberger\n");
> > > -	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab\n");
> > > +	printk(KERN_INFO
> > > +	       "em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho Chehab\n");
> > >  
> > >  	err = snd_card_create(index[devnr], "Em28xx Audio", THIS_MODULE, 0,
> > >  			      &card);
> > > @@ -704,6 +679,47 @@ static int em28xx_audio_init(struct em28xx *dev)
> > >  		em28xx_cvol_new(card, dev, "Surround", AC97_SURROUND_MASTER);
> > >  	}
> > >  
> > > +	/* Alloc URB and transfer buffers */
> > > +	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> > > +		struct urb *urb;
> > > +		int j, k;
> > > +		void *buf;
> > > +
> > > +		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
> > > +		if (!urb) {
> > > +			em28xx_errdev("usb_alloc_urb failed!\n");
> > > +			em28xx_audio_free_urb(dev);
> > > +			return -ENOMEM;
> > > +		}
> > > +		dev->adev.urb[i] = urb;
> > > +
> > > +		buf = usb_alloc_coherent(dev->udev, sb_size, GFP_ATOMIC,
> > > +					 &urb->transfer_dma);
> > > +		if (!buf) {
> > > +			em28xx_errdev("usb_alloc_coherent failed!\n");
> > > +			em28xx_audio_free_urb(dev);
> > > +			return -ENOMEM;
> > > +		}
> > > +		dev->adev.transfer_buffer[i] = buf;
> > > +
> > > +		urb->dev = dev->udev;
> > > +		urb->context = dev;
> > > +		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
> > > +		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
> > > +		urb->transfer_buffer = dev->adev.transfer_buffer[i];
> > > +		urb->interval = 1;
> > > +		urb->complete = em28xx_audio_isocirq;
> > > +		urb->number_of_packets = EM28XX_NUM_AUDIO_PACKETS;
> > > +		urb->transfer_buffer_length = sb_size;
> > > +
> > > +		for (j = k = 0; j < EM28XX_NUM_AUDIO_PACKETS;
> > > +			     j++, k += EM28XX_AUDIO_MAX_PACKET_SIZE) {
> > > +			urb->iso_frame_desc[j].offset = k;
> > > +			urb->iso_frame_desc[j].length =
> > > +			    EM28XX_AUDIO_MAX_PACKET_SIZE;
> > > +		}
> > > +	}
> > > +
> > >  	err = snd_card_register(card);
> > >  	if (err < 0) {
> > >  		snd_card_free(card);
> > > @@ -728,6 +744,8 @@ static int em28xx_audio_fini(struct em28xx *dev)
> > >  		return 0;
> > >  	}
> > >  
> > > +	em28xx_audio_free_urb(dev);
> > > +
> > >  	if (dev->adev.sndcard) {
> > >  		snd_card_free(dev->adev.sndcard);
> > >  		dev->adev.sndcard = NULL;
> > I don't get it.
> > How does this patch reduce the memory allocation pressure ?
> > You are still allocating the same amount of memory.
> 
> True, but it is not de-allocating/reallocating the same amount of
> memory every time, for every start/stop trigger. Depending on the
> userspace and the amount of available RAM, this could cause memory 
> fragmentation.

Btw, this fixes a real bug with em2860 (Kworld U305): the time spent
with URB deallocation/reallocation every time that the trigger hits
makes it to loose audio frames.

With this patch, the sound becomes smooth, and it stops with the
periodic ALSA overrun errors that happen after channel tuning.

Regards,
-- 

Cheers,
Mauro
