Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:57031 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab1BIIsX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 03:48:23 -0500
Subject: Re: WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
In-Reply-To: <4D501704.6060504@redhat.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
	 <4D4FDED0.7070008@redhat.com>
	 <20110207120234.GE10564@opensource.wolfsonmicro.com>
	 <4D4FEA03.7090109@redhat.com>
	 <20110207131045.GG10564@opensource.wolfsonmicro.com>
	 <4D4FF821.4010701@redhat.com>
	 <20110207135225.GJ10564@opensource.wolfsonmicro.com>
	 <1297088242.15320.62.camel@masi.mnp.nokia.com>
	 <4D501704.6060504@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 10:47:58 +0200
Message-ID: <1297241278.15320.90.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-02-07 at 14:00 -0200, ext Mauro Carvalho Chehab wrote:
> Em 07-02-2011 12:17, Matti J. Aaltonen escreveu:
> > On Mon, 2011-02-07 at 13:52 +0000, ext Mark Brown wrote:
> >> On Mon, Feb 07, 2011 at 11:48:17AM -0200, Mauro Carvalho Chehab wrote:
> >>> Em 07-02-2011 11:10, Mark Brown escreveu:
> >>
> >>>> There is an audio driver for this chip and it is using those functions.
> >>
> >>> Where are the other drivers that depend on it?
> >>
> >> Nothing's been merged yet to my knowledge, Matti can comment on any
> >> incoming boards which will use it (rx51?).
> > 
> > Yes, nothing's been merged yet. There are only dependencies between the
> > parts of this driver... I cannot comment on upcoming boards, I just hope
> > we could agree on a sensible structure for this thing.
> 
> We don't need any brand names or specific details, but it would be good to 
> have an overview, in general lines, about the architecture, in order to help 
> you to map how this would fit. In particular, the architecturre of 
> things that are tightly coupled and can't be splitted by some bus abstraction.

I understand what you are saying but obviously I cannot think like a
sub-system maintainer:-) What I see here is a piece of hardware with
lots of capabilities: FM RX and TX with analog and digital audio, I2C
and UART control... 

I would have thought that the goal is to make a driver that's as
"general" as possible and to make it possible to use the chip in all
kinds of architectures and scenarios.

But we have been using the driver in principle in its current form. But
if the interface to the users has to be split in a different way, I
don't see that as a major problem. But on the other hand I can't see the
ASoC / V4L2 division going away completely. The users won't probably
care if we have MFD or not.

Cheers,
Matti

> Mauro.


