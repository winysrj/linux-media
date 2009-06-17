Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:39025 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246AbZFQILM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 04:11:12 -0400
Received: by gxk10 with SMTP id 10so262469gxk.13
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 01:11:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906141719510.4412@axis700.grange>
References: <62904.62.70.2.252.1244810776.squirrel@webmail.xs4all.nl>
	 <Pine.LNX.4.64.0906121454410.4843@axis700.grange>
	 <200906121800.51177.hverkuil@xs4all.nl>
	 <Pine.LNX.4.64.0906141719510.4412@axis700.grange>
Date: Wed, 17 Jun 2009 17:11:13 +0900
Message-ID: <aec7e5c30906170111y1f16919bie46b1e66f84a6a54@mail.gmail.com>
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 15, 2009 at 12:33 AM, Guennadi
Liakhovetski<g.liakhovetski@gmx.de> wrote:
> On Fri, 12 Jun 2009, Hans Verkuil wrote:
>
>> On Friday 12 June 2009 14:59:03 Guennadi Liakhovetski wrote:
>> > On Fri, 12 Jun 2009, Hans Verkuil wrote:
>> >
>> > > > 1. it is very unusual that the board designer has to mandate what signal
>> > > > polarity has to be used - only when there's additional logic between the
>> > > > capture device and the host. So, we shouldn't overload all boards with
>> > > > this information. Board-code authors will be grateful to us!
>> > >
>> > > I talked to my colleague who actually designs boards like that about what
>> > > he would prefer. His opinion is that he wants to set this himself, rather
>> > > than leave it as the result of a software negotiation. It simplifies
>> > > verification and debugging the hardware, and in addition there may be
>> > > cases where subtle timing differences between e.g. sampling on a falling
>> > > edge vs rising edge can actually become an important factor, particularly
>> > > on high frequencies.

Let me guess, your coworker is a hardware designer? Letting hardware
people do hardware design is usually a good idea, but I'm yet to see
good software written by hardware people. =)

>> > I'd say this is different. You're talking about cases where you _want_ to
>> > be able to configure it explicitly, I am saying you do not have to _force_
>> > all to do this. Now, this selection only makes sense if both are
>> > configurable, right? In this case, e.g., pxa270 driver does support
>> > platform-specified preference. So, if both the host and the client can
>> > configure either polarity in the software you _can_ still specify the
>> > preferred one in platform data and it will be used.
>> >
>> > I think, the ability to specify inverters and the preferred polarity
>> > should cover all possible cases.
>>
>> In my opinion you should always want to set this explicitly. This is not
>> something you want to leave to chance. Say you autoconfigure this. Now
>> someone either changes the autoconf algorithm, or a previously undocumented
>> register was discovered for the i2c device and it can suddenly configure the
>> polarity of some signal that was previously thought to be fixed, or something
>> else happens causing a different polarity to be negotiated.
>
> TBH, the argumentation like "someone changes the autoconf algorithm" or
> "previously undocumented register is discovered" doesn't convince me. In
> any case, I am adding authors, maintainers and major contributors to
> various soc-camera host drivers to CC and asking them to express their
> opinion on this matter. I will not add anything else here to avoid any
> "unfair competition":-) they will have to go a couple emails back in this
> thread to better understand what is being discussed here.

I think automatic negotiation is a good thing if it is implemented correctly.

Actually, i think modelling software after hardware is a good thing
and from that perspective the soc_camera was (and still is) a very
good fit for our on-chip SoC. Apart from host/sensor separation, the
main benefits in my mind are autonegotiation and separate
configuration for camera sensor, capture interface and board.

I don't mind doing the same outside soc_camera, and I agree with Hans
that in some cases it's nice to hard code and skip the "magic"
negotiation. I'm however pretty sure the soc_camera allows hard coding
though, so in that case you get the best of two worlds.

Cheers,

/ magnus
