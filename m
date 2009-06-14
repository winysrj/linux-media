Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3017 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZFNRRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 13:17:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
Date: Sun, 14 Jun 2009 19:17:25 +0200
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
References: <62904.62.70.2.252.1244810776.squirrel@webmail.xs4all.nl> <200906121800.51177.hverkuil@xs4all.nl> <Pine.LNX.4.64.0906141719510.4412@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906141719510.4412@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141917.25328.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 June 2009 17:33:19 Guennadi Liakhovetski wrote:
> On Fri, 12 Jun 2009, Hans Verkuil wrote:
> 
> > On Friday 12 June 2009 14:59:03 Guennadi Liakhovetski wrote:
> > > On Fri, 12 Jun 2009, Hans Verkuil wrote:
> > > 
> > > > > 1. it is very unusual that the board designer has to mandate what signal
> > > > > polarity has to be used - only when there's additional logic between the
> > > > > capture device and the host. So, we shouldn't overload all boards with
> > > > > this information. Board-code authors will be grateful to us!
> > > > 
> > > > I talked to my colleague who actually designs boards like that about what
> > > > he would prefer. His opinion is that he wants to set this himself, rather
> > > > than leave it as the result of a software negotiation. It simplifies
> > > > verification and debugging the hardware, and in addition there may be
> > > > cases where subtle timing differences between e.g. sampling on a falling
> > > > edge vs rising edge can actually become an important factor, particularly
> > > > on high frequencies.
> > > 
> > > I'd say this is different. You're talking about cases where you _want_ to 
> > > be able to configure it explicitly, I am saying you do not have to _force_ 
> > > all to do this. Now, this selection only makes sense if both are 
> > > configurable, right? In this case, e.g., pxa270 driver does support 
> > > platform-specified preference. So, if both the host and the client can 
> > > configure either polarity in the software you _can_ still specify the 
> > > preferred one in platform data and it will be used.
> > > 
> > > I think, the ability to specify inverters and the preferred polarity 
> > > should cover all possible cases.
> > 
> > In my opinion you should always want to set this explicitly. This is not
> > something you want to leave to chance. Say you autoconfigure this. Now
> > someone either changes the autoconf algorithm, or a previously undocumented
> > register was discovered for the i2c device and it can suddenly configure the
> > polarity of some signal that was previously thought to be fixed, or something
> > else happens causing a different polarity to be negotiated.
> 
> TBH, the argumentation like "someone changes the autoconf algorithm" or 
> "previously undocumented register is discovered" doesn't convince me.

The point I'm making here is that since the autoconf part is done in software
it *can* be changed. And while just looking at the code there is no reason why
choosing a positive vs. negative polarity makes any difference if both host
and i2c device support it, from a hardware standpoint it *can* make a
difference.

In practice you verify and certify your hardware using specific bus settings.
An autoconf algorithm just obfuscates those settings. And relying on it to
always return the same settings in the future seems also wishful thinking.

> In  
> any case, I am adding authors, maintainers and major contributors to 
> various soc-camera host drivers to CC and asking them to express their 
> opinion on this matter. I will not add anything else here to avoid any 
> "unfair competition":-) they will have to go a couple emails back in this 
> thread to better understand what is being discussed here.

It will definitely be interesting to see what others think.

Regards,

	Hans

> 
> > Suddenly the board
> > doesn't work because it was never verified or tested with that different
> > polarity. Or worse: it glitches only 0.001% of the time. That's going to be a
> > nasty bug to find.
> > 
> > You generally verify your board with specific bus settings, and that's what
> > should also be configured explicitly. Sure, it is nice not to have to think
> > about this. The problem is that I believe that you *have* to think about it.
> > 
> > The longer I think about this, the more convinced I am that relying on
> > autoconfiguration is a bad design.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
