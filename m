Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:23081 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaAMTNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 14:13:55 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZC00GL0TF65N90@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jan 2014 14:13:54 -0500 (EST)
Date: Mon, 13 Jan 2014 17:13:47 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] em28xx: fix usb alternate setting for analog and
 digital video endpoints > 0
Message-id: <20140113171347.0657e822@samsung.com>
In-reply-to: <52D430A7.9060801@googlemail.com>
References: <1389447750-2642-1-git-send-email-fschaefer.oss@googlemail.com>
 <20140112153502.5cedd0ed@samsung.com> <52D430A7.9060801@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 13 Jan 2014 19:29:59 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> On 12.01.2014 18:35, Mauro Carvalho Chehab wrote:
> > Em Sat, 11 Jan 2014 14:42:29 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> The current code assumes that the analog + digital video endpoints are always at
> >> interface number 0 when changing the alternate setting.
> >> This seems to work fine for most existing devices.
> >> However, at least the SpeedLink VAD Laplace webcam has the video endpoint on
> >> interface number 3 (which fortunately doesn't cause any trouble because ist uses
> >> bulk transfers only).
> >> We already consider the actual the interface number for audio endpoints, so
> >> rename the the audio_ifnum variable and use it for all device types.
> >> Also get get rid of a pointless (ifnum < 0) in em28xx-audio.
> >>
> >> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >> ---
> >>   drivers/media/usb/em28xx/em28xx-audio.c |   10 +++++-----
> >>   drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
> >>   drivers/media/usb/em28xx/em28xx-dvb.c   |    2 +-
> >>   drivers/media/usb/em28xx/em28xx-video.c |    2 +-
> >>   drivers/media/usb/em28xx/em28xx.h       |    3 +--
> >>   5 Dateien geändert, 9 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)
> >>
> >> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> >> index 30ee389..b2ae954 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> >> @@ -243,15 +243,15 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
> >>   	}
> >>   
> >>   	runtime->hw = snd_em28xx_hw_capture;
> >> -	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
> >> -		if (dev->audio_ifnum)
> >> +	if ((dev->alt == 0 || dev->ifnum) && dev->adev.users == 0) {
> > Lets keep it named as "audio_ifnum". Ok, this is equal to the video_ifnum
> > for several devices, but on em2861 (and other em2xx1 devices), the audio
> > interface is different.
> Uhm, that doesn't make sense.
> Why do you want to call it audio_ifnum although it is used for 
> audio/video/dvb ???

em28xx-audio only cares about the interface used by audio, and if it is
different than the one used by video, in order to switch the alternate at
the right interface.

So, you'll likely need to add a video_ifnum and an audio_ifnum, in
order to track both (eventually, we may need a dvb_ifnum in the future,
if they decide to provide a separate interface for it too).

> > Also, as we're trying to get rid of hardcoded values, it also makes sense
> > to store the alternate used for the audio endpoint.
> We already to that: dev->alt.

See below: dev->alt = 1 or dev->alt = 7.

> I think there is some general misunderstanding here.
> There is always only a single interface number and current alternate 
> setting per driver instance.
> If all endpoints are on the same interface, there's only a sibgle driver 
> instance.
> If the audio endpoints are on a separate interface, there will be two 
> driver instances (each of them using their own device struct etc.).
> 
> > Btw, I'm thinking on rework on this entire code, adding a logic that would
> > handle properly the interface used by both audio and video (when this is
> > the case) to not just select alt = 7, but to dynamically allocate the proper
> > value for it, by taking into account the number of allocated audio URBs.
> alt=7 is actually bug that needs to be fixed.

Huh? alt = 7 is a "works everytime" kind of alternate, as it has the biggest
window size. You can say that this is not optimized, making em28xx to spend
more bandwidth than needed, but this is not a bug.

> It messes up the alt settings made by the video part.

Yes, because it doesn't recalculate the bandwidth.

> This just didn't show up so far, because the video stream is almost 
> always started after the audio stream.

You can't assume that. 

Actually, it is/was common for people to start the video streaming
using some non-alsa compatible application, and then use a separate
process for audio.

See, for example (at ALSA audio with other applications):
	http://www.linuxtv.org/wiki/index.php/Saa7134-alsa

I actually use this way when I want to do some tests with alsa,
stopping/restarting its stream without touching on the video one.

> Do you know any devices with audio endpoints 0x83 on the same interface 
> as video/dvb ?

Yes. HVR-950 (and HVR-900).

> If yes, can you check their alt settings ? I'm pretty sure the audio 
> endpoint uses the same wMaxPacketSize and bInterval values at all alt 
> settings.

Yes.

> Otherwise things would become very complicated...

The problem is basically the same: when a audio or video stream starts,
it will need to call some routine to determinate the alternate. Such
routine should track if both streams are active, or if just one is
active, and provide the lowest alternate that works for both (or,
in doubt, the alternate with the highest packet size, e. g. alt = 7
when audio and video are at the same interface, or alt = 1 otherwise).

> >
> > For now, could you please rebase this patch, keeping the interface named
> > as "audio_ifnum"?
> >
> > Thanks!
> > Mauro
> >
> >> +		if (dev->ifnum)
> >>   			dev->alt = 1;
> >>   		else
> >>   			dev->alt = 7;
> >>   
> >>   		dprintk("changing alternate number on interface %d to %d\n",
> >> -			dev->audio_ifnum, dev->alt);
> >> -		usb_set_interface(dev->udev, dev->audio_ifnum, dev->alt);
> >> +			dev->ifnum, dev->alt);
> >> +		usb_set_interface(dev->udev, dev->ifnum, dev->alt);
> >>   
> >>   		/* Sets volume, mute, etc */
> >>   		dev->mute = 0;
> >> @@ -625,7 +625,7 @@ static int em28xx_audio_init(struct em28xx *dev)
> >>   	const int sb_size = EM28XX_NUM_AUDIO_PACKETS *
> >>   			    EM28XX_AUDIO_MAX_PACKET_SIZE;
> >>   
> >> -	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
> >> +	if (!dev->has_alsa_audio) {
> >>   		/* This device does not support the extension (in this case
> >>   		   the device is expecting the snd-usb-audio module or
> >>   		   doesn't have analog audio support at all) */
> >> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> >> index 39cf49c..b2cfd5d 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> >> @@ -3224,7 +3224,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >>   	dev->has_alsa_audio = has_audio;
> >>   	dev->audio_mode.has_audio = has_audio;
> >>   	dev->has_video = has_video;
> >> -	dev->audio_ifnum = ifnum;
> >> +	dev->ifnum = ifnum;
> >>   
> >>   	/* Checks if audio is provided by some interface */
> >>   	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
> >> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> >> index 5c6be66..9d0fcc8 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> >> @@ -203,7 +203,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
> >>   		dvb_alt = dev->dvb_alt_isoc;
> >>   	}
> >>   
> >> -	usb_set_interface(dev->udev, 0, dvb_alt);
> >> +	usb_set_interface(dev->udev, dev->ifnum, dvb_alt);
> > In this case, it should be dev->video_ifnum, as otherwise this patch
> > will break support for devices with em2861.
> No. Audio and video are on the same interface.
> If they are on separate interfaces, there will be be two driver 
> instances running, each of them handling their own interface settings 
> (interface number and used alt setting).

Hmm... you may be right on that. 

The endpoint descriptors allow to see both interfaces. I'm not
sure how the current binding is doing, as there were several
changes with regards to it.

I'll need to double check it with the current version, and do some
tests.

> >
> >>   	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
> >>   	if (rc < 0)
> >>   		return rc;
> >> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> >> index 9c44628..b65d13a 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-video.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> >> @@ -382,7 +382,7 @@ set_alt:
> >>   	}
> >>   	em28xx_videodbg("setting alternate %d with wMaxPacketSize=%u\n",
> >>   		       dev->alt, dev->max_pkt_size);
> >> -	errCode = usb_set_interface(dev->udev, 0, dev->alt);
> >> +	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
> > Same here.
> Same here, it's correct.
> 
> >
> >>   	if (errCode < 0) {
> >>   		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
> >>   			      dev->alt, errCode);
> >> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> >> index efdf386..8d38d00 100644
> >> --- a/drivers/media/usb/em28xx/em28xx.h
> >> +++ b/drivers/media/usb/em28xx/em28xx.h
> >> @@ -549,8 +549,6 @@ struct em28xx {
> >>   	unsigned int has_alsa_audio:1;
> >>   	unsigned int is_audio_only:1;
> >>   
> >> -	int audio_ifnum;
> >> -
> >>   	struct v4l2_device v4l2_dev;
> >>   	struct v4l2_ctrl_handler ctrl_handler;
> >>   	struct v4l2_clk *clk;
> >> @@ -664,6 +662,7 @@ struct em28xx {
> >>   
> >>   	/* usb transfer */
> >>   	struct usb_device *udev;	/* the usb device */
> >> +	u8 ifnum;		/* number of the assigned usb interface */
> >>   	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
> >>   	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
> >>   	u8 dvb_ep_isoc;		/* address of isoc endpoint for DVB */
> >
> 


-- 

Cheers,
Mauro
