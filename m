Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:34956 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517AbZIWA7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 20:59:31 -0400
Subject: Re: Audio drop on saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: David Liontooth <lionteeth@cogweb.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <4AB730F2.4090203@cogweb.net>
References: <4AAEFEC9.3080405@cogweb.net>
	 <20090915000841.56c24dd6@pedra.chehab.org> <4AAF11EC.3040800@cogweb.net>
	 <1252988501.3250.62.camel@pc07.localdom.local>
	 <4AAF232F.9060204@cogweb.net>
	 <1252993000.3250.97.camel@pc07.localdom.local>
	 <4AAF2F1B.2050206@cogweb.net> <4AB5E6AC.1090505@cogweb.net>
	 <20090920060218.51971a45@pedra.chehab.org>
	 <1253496615.3257.25.camel@pc07.localdom.local>
	 <4AB730F2.4090203@cogweb.net>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 02:42:45 +0200
Message-Id: <1253666565.3364.60.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Am Montag, den 21.09.2009, 00:53 -0700 schrieb David Liontooth: 
> hermann pitton wrote:
> > Hi,
> >
> > Am Sonntag, den 20.09.2009, 06:02 -0300 schrieb Mauro Carvalho Chehab:
> >   
> >> Em Sun, 20 Sep 2009 01:24:12 -0700
> >> David Liontooth <lionteeth@cogweb.net> escreveu:
> >>
> >>     
> >>> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 0x000000
> >>> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 0xbbbbbb
> >>>       
> >> This means mute. With this, audio will stop.
> >>
> >>     
> >>> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 0x000000
> >>> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 0xbbbb10
> >>>       
> >> This means unmute.
> >>
> >> It seems that the auto-mute code is doing some bad things for you. What happens
> >> if you disable automute? This is a control that you can access via v4l2ctl or
> >> on your userspace application.
> >>
> >> Are you using the last version of the driver? I'm not seeing some debug log messages
> >> that should be there...
> >>
> >>
> >>
> >> Cheers,
> >> Mauro
> >>     
> >
> > despite of still 1001 messages unread, Mauro is right here.
> >
> > You are also for sure not on a saa7134, likely you would not ever had a
> > reason to come up here on such. But the much better is to have you now.
> >   
> lspci says
> 
> 00:07.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 
> Video Broadcast Decoder (rev 10)
> 
> The cards apparently have the saa7133HL-v101 chip. Are you suggesting 
> the saa7134 would be better?

no, you can't use a saa7134 on System-M without additional audio
decoder. You should know better, since you helped a lot to get Closed
Captions working on saa7133/35/31e.

> > Means, you are at least on a saa7133, not able to decode stereo TV sound
> > on PAL and SECAM systems, vice versa counts for the saa7134 on SYSTEM-M.
> >   
> I'm recording NTSC -- are you saying the saa7133 should be able to 
> decode stereo on NTSC?

Yes, of course, but a saa7134 can't. Only the saa7135 and saa7131e chips
can do global stereo audio on that driver.

> If "vice versa" for the saa7134, does that mean this chip is not able to 
> decode stereo on NTSC?

Yes.

> Sorry, I don't know what SYSTEM-M is in this context.

You will find "NTSC" tuners also in South America.
For video they use some PAL, but for audio System-M.

A different example you can find in South Korea.
For video they use NTSC, but for audio dual FM (A2).

> If you could help me find a chip that avoids this audio drop problem, 
> that would be great.
> > The automute is for convenience of the users, say not to have loud noise
> > on channel switching. 
> I see. That's irrelevant for my purposes; the channels are switched 
> before the recording starts.
> > It is also controlled by different registers for
> > analog sound and PCI dma sound.
> >   
> I'm using PCI dma sound.
> > If debugging those issues, one more thing to mention is that external
> > video in without audio will kick in mute on those cards too at the first
> > round.
> >
> > It should be possible to disable all such funny stuff on production
> > systems, pleasant for the average user's conditions, and then see if
> > anything should still remain.
> >
> > On bad mobos, needing PCI quirks and other such stuff, we are likely not
> > any further than what you have seen on bttv previously, but in 99.9
> > percent of the known cases it seems to work.
> >
> > Else Mauro again is right, even audio_debug = 1 should deliver the
> > related mute ioctl prints.
> >   
> I see -- it may be a couple of weeks before I can run tests on a more 
> recent kernel, but I'll do that if turning off audiomute doesn't solve 
> the problem.
> 
> Cheers,
> Dave

Is it really still over the air?

We don't have any such anymore, only cable TV from satellites back
modulated as RF input into their network in best case. Is very stable.

We are not alone and depend also of work done by others.

Generally speaking, your stuff should be sufficient already, but without
having NTSC here, hm maybe some AFN stuff is still active, you are
somewhat on your own again.

To back up your kernel's modules media folder, install recent stuff for
some testing, and if not pleased, delete the recent media folder, copy
the old media folder back into place and run "depmod -a" once should be
not that hard.

Lots of small bugs in between ;)

Cheers,
Hermann







