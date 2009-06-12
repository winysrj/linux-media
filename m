Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4599 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZFLMqR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 08:46:17 -0400
Message-ID: <62904.62.70.2.252.1244810776.squirrel@webmail.xs4all.nl>
Date: Fri, 12 Jun 2009 14:46:16 +0200 (CEST)
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Muralidharan Karicheri" <m-karicheri2@ti.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	davinci-linux-open-source@linux.davincidsp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wed, 10 Jun 2009, Hans Verkuil wrote:
>
>> On Wednesday 10 June 2009 23:30:55 Guennadi Liakhovetski wrote:
>> > On Wed, 10 Jun 2009, Hans Verkuil wrote:
>> > > My view of this would be that the board specification specifies the
>> > > sensor (and possibly other chips) that are on the board. And to me
>> it
>> > > makes sense that that also supplies the bus settings. I agree that
>> it
>> > > is not complex code, but I think it is also unnecessary code. Why
>> > > negotiate if you can just set it?
>> >
>> > Why force all platforms to set it if the driver is perfectly capable
>> do
>> > this itself? As I said - this is not a platform-specific feature, it's
>> > chip-specific. What good would it make to have all platforms using
>> > mt9t031 to specify, that yes, the chip can use both falling and rising
>> > pclk edge, but only active high vsync and hsync?
>>
>> ???
>>
>> You will just tell the chip what to use. So you set 'use falling edge'
>> and
>> either set 'active high vsync/hsync' or just leave that out since you
>> know
>> the mt9t031 has that fixed. You don't specify in the platform data what
>> the
>> chip can support, that's not relevant. You know what the host expects
>> and
>> you pass that information on to the chip.
>>
>> A board designer knows what the host supports, knows what the sensor
>> supports, and knows if he added any inverters on the board, and based on
>> all that information he can just setup these parameters for the sensor
>> chip. Settings that are fixed on the sensor chip he can just ignore, he
>> only need to specify those settings that the sensor really needs.
>
> I'd like to have this resolved somehow (preferably my way of ourse:-)),
> here once again (plus some new) my main arguments:
>
> 1. it is very unusual that the board designer has to mandate what signal
> polarity has to be used - only when there's additional logic between the
> capture device and the host. So, we shouldn't overload all boards with
> this information. Board-code authors will be grateful to us!

I talked to my colleague who actually designs boards like that about what
he would prefer. His opinion is that he wants to set this himself, rather
than leave it as the result of a software negotiation. It simplifies
verification and debugging the hardware, and in addition there may be
cases where subtle timing differences between e.g. sampling on a falling
edge vs rising edge can actually become an important factor, particularly
on high frequencies.

> 2. what if you do have an inverter between the two? You'd have to tell the
> sensor to use active high, and the host to use active low, i.e., you need
> two sets of flags.

You obviously need to set this for both the host and for the sub-device.
The s_bus op in v4l2_subdev is meant to set the sub-device. Setting this
up for the host is a platform/board issue.

>
> 3. all soc-camera boards rely on this autonegotiation. Do we really want
> (and have) to add this useless information back to them? Back - because,
> yes, we've been there we've done that before, but then we switched to the
> current autonegotiation, which we are perfectly happy with so far (anyone
> dares to object?:-)).

Well, I do :-) This is not useless information and particularly at high
clock frequencies (e.g. 74.25 MHz or higher) you do want to have full
control over this. Remember that this API is not only meant for sensor
devices, but also for HDTV video receivers.

> 4. the autonegiation code is simple and small, so, I really don't see a
> reason to hardcode something, that we can perfectly autoconfigure.

The fact that that code exists doesn't mean that we also have to use it.
While I am not a hardware engineer myself, I do work closely together with
them. And having seen some of the tricky things that can go wrong with
timings I think there is a very good case against autoconfiguring these
things. For simple designs where the timings aren't critical I am sure
that autoconfiguring works fine, but when you get to HD quality video
streaming then it does become an issue. And this will become ever more
important in the future as the pixel clock frequencies keep increasing.

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

