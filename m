Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out1.iol.cz ([194.228.2.86]:38414 "EHLO smtp-out1.iol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbZKDJBu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2009 04:01:50 -0500
From: Ales Jurik <ajurik@quick.cz>
Reply-To: ajurik@quick.cz
To: HoP <jpetrous@gmail.com>
Subject: Re: [PATCH] isl6421.c - added optional features: tone control and temporary diseqc overcurrent
Date: Wed, 4 Nov 2009 09:35:51 +0100
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <846899810910241711s6fb5939fq3a693a92a2a76310@mail.gmail.com> <1257295025.10268.7.camel@pc07.localdom.local> <846899810911032320q7c60d965wcaf1076664f8a7e1@mail.gmail.com>
In-Reply-To: <846899810911032320q7c60d965wcaf1076664f8a7e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911040935.51668.ajurik@quick.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 of November 2009, HoP wrote:
> Hi Hermann,
> 
> >> >> Attached patch adds two optional (so, disabled by default
> >> >> and therefore could not break any compatibility) features:
> >> >>
> >> >> 1, tone_control=1
> >> >> When enabled, ISL6421 overrides frontend's tone control
> >> >> function (fe->ops.set_tone) by its own one.
> >> >
> >> > On your comments, the better is to describe why someone would need
> >> > to use such option. You should also add a quick hint about that at the
> >> > option description.
> >>
> >> Well, I'm not sure I can make some good hint why such option can
> >> be useful by someone. I can only say that isl6121 has possibility
> >> to drive 22k tone, so why not enable usage of it?
> >
> > well, we have much more experienced guys than me here on that, but it
> > should be device specific then.
> >
> >> Of course, we made such code because we were using exactly
> >> this way of 22k control in our device.
> >
> > So the demod can't do it or just free choice?
> 
> Well, more detailed Ales can speak about it, he is "hw guy" here :)
> Anyway, regardless reason of choice important is that isl6421
> can be used this way and, may be even more important, it is
> used (and works correctly) in our hardware.
> 
> I understand it can be a bit non-usual way of usage, but as
> I said, it works for us :)
When using isl6421 it is one possible way how to modulate LNB voltage with 
22kHz tone. The interesting is that if frontend is capable to support such 
function it doesn't need any additional hw.
> 
> >> >> 2, overcurrent_enable=1
> >> >> When enabled, overcurrent protection is disabled during
> >> >> sending diseqc command. Such option is usable when ISL6421
> >> >> catch overcurrent threshold and starts limiting output.
> >> >> Note: protection is disabled only during sending
> >> >> of diseqc command, until next set_tone() usage.
> >> >> What typically means only max up to few hundreds of ms.
> >> >> WARNING: overcurrent_enable=1 is dangerous
> >> >> and can damage your device. Use with care
> >> >> and only if you really know what you do.
> >> >
> >> > I'm not sure if it is a good idea to have this... Why/when someone
> >> > would need this?
> >>
> >> I know that it is a bit dangerous option, so I can understand you can
> >> don't like it :)
> >>
> >> But I would like to note again - such way of using is permitted
> >> by datasheet (otherwise it would not be even possible to enable it)
> >> and we learnt when used correctly (it is enabled only within diseqc
> >> sequence), it boost rotor moving or fixes using some "power-eating"
> >> diseqc switches.
> >>
> >> If you still feel it is better to not support bit strange mode, then
> >> I can live with "#if 0" commented out blocks or adding some
> >> kernel config option with something like ISL6421_ENABLE_OVERCURRENT
> >> or so.
> >
> > Question is, can you melt down some chip with it or not?
> >
> > If you can, stay away, since this was not in the scope earlier.
> 
> We have tested it with few devices (both rotor and diseqc switches)
> and have not ran in any damage yet.
> 
> TBH, I'm writing about possibility of damage only because
> of understanding that if I disable overcurrent safeguard I
> can imagine it can end up bad way. But not tested on our side.
> 
> Regards
> 
> /Honza
> 
This is used in way I hope it was supposed to by designers of the chip. The 
current to LNB is in real not "unlimited", it is limited by hw design (sense 
resistor in FET circuit). So not isl6421 nor connected FET should be damaged 
even when short circuit appears in antenna connection, but as in most of cases 
this feature is not needed we add it as optional parameter.

Of course hw designer should take care of power dissipation from the circuit.

Let me cite the isl6421 datasheet:

"However, there could be some cases in which a highly                                                               
capacitive load on the output may cause a difficult start-up,
when the dynamic protection is chosen. This can be solved
by initiating a power start-up in static mode (DCL = HIGH)
and then switching to the dynamic mode (DCL = LOW) after
a chosen amount of time. When in static mode, the OLF bit
goes HIGH when the current clamp limit is reached and
returns LOW when the overload condition is cleared. The
OLF bit will be LOW at the end of initial power-on soft-start."

This is exactly situation in which we find ourselves when testing our hw with 
cascade of diseqc switch and diseqc motor. The proposed patch and activating 
of temporarily disabling the dynamic current limitations solved this problem 
perfectly.

BR,

Ales
