Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:43778 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbZKDAnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2009 19:43:23 -0500
Subject: Re: [PATCH] isl6421.c - added optional features: tone control and
	temporary diseqc overcurrent
From: hermann pitton <hermann-pitton@arcor.de>
To: HoP <jpetrous@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Ales Jurik <ajurik@quick.cz>
In-Reply-To: <846899810911031510p252dadfeu3fa058c7b8733270@mail.gmail.com>
References: <846899810910241711s6fb5939fq3a693a92a2a76310@mail.gmail.com>
	 <4AEC08F0.70205@redhat.com>
	 <846899810911031510p252dadfeu3fa058c7b8733270@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 01:37:05 +0100
Message-Id: <1257295025.10268.7.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Honza,

Am Mittwoch, den 04.11.2009, 00:10 +0100 schrieb HoP:
> Hi Mauro,
> 
> thank you for your valued hints. I'm commenting inside
> message:
> 
> > First of all, please check all your patches with checkpatch, to be sure
> > that they don't have any CodingStyle troubles. There are some on your
> > patch (the better is to read README.patches for more info useful
> > for developers).
> 
> Did checkpatch testing and has fixed all errors/warnings except
> of 3 warning regarding longer line (all 3 lines has exactly
> one char over 80, so I guess it should not bother much).
> Of course if this rule is a must, then I can fix that also).
> 
> >>
> >> Attached patch adds two optional (so, disabled by default
> >> and therefore could not break any compatibility) features:
> >>
> >> 1, tone_control=1
> >> When enabled, ISL6421 overrides frontend's tone control
> >> function (fe->ops.set_tone) by its own one.
> >>
> >
> > On your comments, the better is to describe why someone would need
> > to use such option. You should also add a quick hint about that at the
> > option description.
> 
> Well, I'm not sure I can make some good hint why such option can
> be useful by someone. I can only say that isl6121 has possibility
> to drive 22k tone, so why not enable usage of it?

well, we have much more experienced guys than me here on that, but it
should be device specific then.

> Of course, we made such code because we were using exactly
> this way of 22k control in our device.

So the demod can't do it or just free choice?

> >>
> >> 2, overcurrent_enable=1
> >> When enabled, overcurrent protection is disabled during
> >> sending diseqc command. Such option is usable when ISL6421
> >> catch overcurrent threshold and starts limiting output.
> >> Note: protection is disabled only during sending
> >> of diseqc command, until next set_tone() usage.
> >> What typically means only max up to few hundreds of ms.
> >> WARNING: overcurrent_enable=1 is dangerous
> >> and can damage your device. Use with care
> >> and only if you really know what you do.
> >>
> >
> > I'm not sure if it is a good idea to have this... Why/when someone would
> > need this?
> >
> 
> I know that it is a bit dangerous option, so I can understand you can
> don't like it :)
> 
> But I would like to note again - such way of using is permitted
> by datasheet (otherwise it would not be even possible to enable it)
> and we learnt when used correctly (it is enabled only within diseqc
> sequence), it boost rotor moving or fixes using some "power-eating"
> diseqc switches.
> 
> If you still feel it is better to not support bit strange mode, then
> I can live with "#if 0" commented out blocks or adding some
> kernel config option with something like ISL6421_ENABLE_OVERCURRENT
> or so.

Question is, can you melt down some chip with it or not?

If you can, stay away, since this was not in the scope earlier.

Cheers,
Hermann

> > If we go ahead and add this one, you should add a notice about it at the
> > parameter.
> > I would also print a big WARNING message at the dmesg if the module were
> > loaded
> > with this option turned on.
> 
> Added some WARNING printing to dmesg when option is enabled.
> 
> Regards
> 
> /Honza
> 
> ---
> 
> Signed-off-by: Jan Petrous <jpetrous@gmail.com>
> Signed-off-by: Ales Jurik <ajurik@quick.cz>

