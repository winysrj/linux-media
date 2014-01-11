Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:40687 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAKUxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 15:53:20 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ9008YU8OVC060@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 11 Jan 2014 15:53:19 -0500 (EST)
Date: Sat, 11 Jan 2014 18:53:13 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/4] em28xx: use bInterval on em28xx-audio
Message-id: <20140111185313.1355156b@samsung.com>
In-reply-to: <52D1491A.1070104@googlemail.com>
References: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
 <1389379539-31550-2-git-send-email-m.chehab@samsung.com>
 <52D1491A.1070104@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 11 Jan 2014 14:37:30 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 10.01.2014 19:45, schrieb Mauro Carvalho Chehab:
> > Just filling urb->interval with 1 is wrong, and causes a different
> > behaviour with xHCI.
> >
> > With EHCI, the URB size is typically 192 bytes. However, as
> > xHCI specifies intervals in microframes, the URB size becomes
> > too short (24 bytes).
> >
> > With this patch, the interval will be properly initialized, and
> > the device will behave the same if connected into a xHCI or an
> > EHCI device port.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-audio.c | 39 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 38 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> > index 30ee389a07f0..8e6f04873422 100644
> > --- a/drivers/media/usb/em28xx/em28xx-audio.c
> > +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> > @@ -620,10 +620,13 @@ static int em28xx_audio_init(struct em28xx *dev)
> >  	struct em28xx_audio *adev = &dev->adev;
> >  	struct snd_pcm      *pcm;
> >  	struct snd_card     *card;
> > +	struct usb_interface *intf;
> > +	struct usb_endpoint_descriptor *e, *ep = NULL;
> >  	static int          devnr;
> >  	int                 err, i;
> >  	const int sb_size = EM28XX_NUM_AUDIO_PACKETS *
> >  			    EM28XX_AUDIO_MAX_PACKET_SIZE;
> > +	u8 alt;
> >  
> >  	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
> >  		/* This device does not support the extension (in this case
> > @@ -679,6 +682,34 @@ static int em28xx_audio_init(struct em28xx *dev)
> >  		em28xx_cvol_new(card, dev, "Surround", AC97_SURROUND_MASTER);
> >  	}
> >  
> > +	if (dev->audio_ifnum)
> > +		alt = 1;
> > +	else
> > +		alt = 7;
> > +
> > +	intf = usb_ifnum_to_if(dev->udev, dev->audio_ifnum);
> > +
> > +	if (intf->num_altsetting <= alt) {
> > +		em28xx_errdev("alt %d doesn't exist on interface %d\n",
> > +			      dev->audio_ifnum, alt);
> > +		return -ENODEV;
> > +	}
> Hmm... yeah, this the alt setting code looks suspicious.
> 
> Take a look at snd_em28xx_capture_open():
> 
>     if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
>         if (dev->audio_ifnum)
>             dev->alt = 1;
>         else
>             dev->alt = 7;
>     ...
>     }
> 
> I've been thinking about this for a while and I think this code is based
> on the following assumptions:
> 1.) Video endpoints are always at interface 0
> 2.) Hence, if the audio endpoints are on a separate interface, the
> interface number is > 0
> 3.) Video interfaces always have alt settings 0-7 and 7 is the one with
> the highest bandwith.
> 1.) is definitely wrong, the VAD Laplace webcam for example has video on
> interface #3.
> This needs to be fixed in the core, too.
> Because of that, the (dev->audio_ifnum > 0) check also needs to be fixed
> and dev->is_audio_only should be checked instead.
> 3.) matches what I've seen so far, but seems to be safer to do the same
> what we are doing in em28xx_usb_probe() for the dvb video endpoints.
> 
> Whether alt=1 and alt=max are a good choice is a separate question.

alt = 1 for audio is because the audio-only interface on em2861 has only 5
alternates, and alt = 1 has the biggest wMaxPacketSize.

This code can of course be optimized.

alt = <max> for mixed video/audio interface was chosen to avoid the
need of recalculate the video + audio bandwidth.

It would be possible to rework on this code to create a single function
that would adjust the bandwidth considering both video and audio
constraints, but it takes time, and testing. So, when the audio driver
was written, the developer just hardcoded alt = 7, and didn't bother
with that.

Nobody had time to review it so far.

> How many altternate settings does the audio only interface of you em2860
> have and how do they look ?


    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               4
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00b4  1x 180 bytes
        bInterval               4
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0084  1x 132 bytes
        bInterval               4
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0044  1x 68 bytes
        bInterval               4
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0024  1x 36 bytes
        bInterval               4

> 
> In case of vendor audio endpoints on the same interface as the video
> endpoints, wMaxPacketSize and bInterval seem to be the same for all alt
> settings.
> (The only device I know so far is the HVR-930c:   wMaxPacketSize =1x 196
> bytes, bInterval = 4).

Yes, but the interface to be selected, in this case, should estimate both
audio and video, if both are active, in order to select the right
alternate.

In any case, this patch doesn't change anything related to it, and it is
a first step to add a proper code here to detect and select the proper
setup.

> > +
> > +	for (i = 0; i < intf->altsetting[alt].desc.bNumEndpoints; i++) {
> > +		e = &intf->altsetting[alt].endpoint[i].desc;
> > +		if (!usb_endpoint_dir_in(e))
> > +			continue;
> > +		if (e->bEndpointAddress == EM28XX_EP_AUDIO) {
> > +			ep = e;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (!ep) {
> > +		em28xx_errdev("Couldn't find an audio endpoint");
> > +		return -ENODEV;
> > +	}
> > +
> >  	/* Alloc URB and transfer buffers */
> >  	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> >  		struct urb *urb;
> > @@ -707,11 +738,17 @@ static int em28xx_audio_init(struct em28xx *dev)
> >  		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
> >  		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
> >  		urb->transfer_buffer = dev->adev.transfer_buffer[i];
> > -		urb->interval = 1;
> > +		urb->interval = 1 << (ep->bInterval - 1);
> >  		urb->complete = em28xx_audio_isocirq;
> >  		urb->number_of_packets = EM28XX_NUM_AUDIO_PACKETS;
> >  		urb->transfer_buffer_length = sb_size;
> >  
> > +		if (!i)
> > +			dprintk("Will use ep 0x%02x on intf %d alt %d interval = %d (rcv isoc pipe: 0x%08x)\n",
> > +				EM28XX_EP_AUDIO, dev->audio_ifnum, alt,
> > +				urb->interval,
> > +				urb->pipe);
> > +
> >  		for (j = k = 0; j < EM28XX_NUM_AUDIO_PACKETS;
> >  			     j++, k += EM28XX_AUDIO_MAX_PACKET_SIZE) {
> >  			urb->iso_frame_desc[j].offset = k;
> 


-- 

Cheers,
Mauro
