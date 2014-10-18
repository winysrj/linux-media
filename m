Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:56833 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaJRSuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Oct 2014 14:50:08 -0400
Date: Sat, 18 Oct 2014 20:49:58 +0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	crope@iki.fi, olebowle@gmx.com, dheitmueller@kernellabs.com,
	hverkuil@xs4all.nl, ramakrmu@cisco.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	perex@perex.cz, prabhakar.csengg@gmail.com,
	tim.gardner@canonical.com, linux@eikelenboom.it,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
Message-id: <20141018204958.567b252f.m.chehab@samsung.com>
In-reply-to: <543FDD51.9040404@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
 <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
 <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com>
 <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com>
 <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com>
 <s5htx34ul3w.wl-tiwai@suse.de> <543FDD51.9040404@osg.samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 16 Oct 2014 08:59:29 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 10/16/2014 08:48 AM, Takashi Iwai wrote:
> > At Thu, 16 Oct 2014 08:39:14 -0600,
> > Shuah Khan wrote:
> >>
> >> On 10/16/2014 08:16 AM, Takashi Iwai wrote:
> >>> At Thu, 16 Oct 2014 08:10:52 -0600,
> >>> Shuah Khan wrote:
> >>>>
> >>>> On 10/16/2014 08:01 AM, Takashi Iwai wrote:
> >>>>> At Thu, 16 Oct 2014 07:10:37 -0600,
> >>>>> Shuah Khan wrote:
> >>>>>>
> >>>>>> On 10/16/2014 06:00 AM, Lars-Peter Clausen wrote:
> >>>>>>> On 10/14/2014 04:58 PM, Shuah Khan wrote:
> >>>>>>> [...]
> >>>>>>>>       switch (cmd) {
> >>>>>>>>       case SNDRV_PCM_TRIGGER_START:
> >>>>>>>> +        err = media_get_audio_tkn(&subs->dev->dev);
> >>>>>>>> +        if (err == -EBUSY) {
> >>>>>>>> +            dev_info(&subs->dev->dev, "%s device is busy\n",
> >>>>>>>> +                    __func__);
> >>>>>>>
> >>>>>>> In my opinion this should not dev_info() as this is out of band error
> >>>>>>> signaling and also as the potential to spam the log. The userspace
> >>>>>>> application is already properly notified by the return code.
> >>>>>>>
> >>>>>>
> >>>>>> Yes it has the potential to flood the dmesg especially with alsa,
> >>>>>> I will remove the dev_info().
> >>>>>
> >>>>> Yes.  And, I think doing this in the trigger isn't the best.
> >>>>> Why not in open & close?
> >>>>
> >>>> My first cut of this change was in open and close. I saw pulseaudio
> >>>> application go into this loop trying to open the device. To avoid
> >>>> such problems, I went with trigger stat and stop. That made all the
> >>>> pulseaudio continues attempts to open problems go away.
> >>>
> >>> But now starting the stream gives the error, and PA would loop it
> >>> again, no?
> >>>
> >>>
> >>>>> Also, is this token restriction needed only for PCM?  No mixer or
> >>>>> other controls?
> >>>>
> >>>> snd_pcm_ops are the only ones media drivers implement and use. So
> >>>> I don't think mixer is needed. If it is needed, it is not to hard
> >>>> to add for that case.
> >>>
> >>> Well, then I wonder what resource does actually conflict with
> >>> usb-audio and media drivers at all...?
> >>>
> >>
> >> audio for dvb/v4l apps gets disrupted when audio app starts. For
> >> example, dvb or v4l app tuned to a channel, and when an audio app
> >> starts. audio path needs protected to avoid conflicts between
> >> digital and analog applications as well.
> > 
> > OK, then concentrating on only PCM is fine.
> > 
> > But, I'm still not convinced about doing the token management in the
> > trigger.  The reason -EBUSY doesn't work is that it's the very same
> > error code when a PCM device is blocked by other processes.  And
> > -EAGAIN is interpreted by PCM core to -EBUSY for historical reasons.
> 
> ah. ok your recommendation is to go with open and close.
> Mauro has some reservations with holding at open when I discussed
> my observations with pulseaudio when I was holding token in open
> instead of trigger start. Maybe he can chime with his concerns.
> I think his concern was breaking applications if token is held in
> open().

Yes. My concern is that PA has weird behaviors, and it tries to open and
keep opened all audio devices. Is there a way for avoiding it to keep doing
it for V4L devices?

> 
> Based on what you are seeing trigger could be worse.
> 
> > 
> > How applications (e.g. PA) should behave if the token get fails?
> > Shouldn't it retry or totally give up?
> > 
> 
> It would be up to the application I would think. I see that arecord
> quits right away when it finds the device busy. pluseaudio on the other
> hand appears to retry. I downloaded pulseaudio sources to understand
> what it is doing, however I didn't get too far. The way it does audio
> handling is complex for me to follow without spending a lot of time.
> 
> thanks,
> -- Shuah
> 


-- 

Cheers,
Mauro
