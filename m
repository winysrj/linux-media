Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4552 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZIZTbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 15:31:01 -0400
Message-ID: <6d6bcf63e448949eceda7ef357efedff.squirrel@webmail.xs4all.nl>
In-Reply-To: <5e9665e10909260606t36901e72ma49c586d19f7d701@mail.gmail.com>
References: <200909232239.20105.hverkuil@xs4all.nl>
    <Pine.LNX.4.64.0909242000240.4913@axis700.grange>
    <5e9665e10909260140v2030ab5bvb7c1bed5e358319b@mail.gmail.com>
    <Pine.LNX.4.64.0909261103310.4273@axis700.grange>
    <5e9665e10909260606t36901e72ma49c586d19f7d701@mail.gmail.com>
Date: Sat, 26 Sep 2009 21:31:03 +0200
Subject: Re: V4L-DVB Summit Day 1
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Sat, Sep 26, 2009 at 6:32 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
>> On Sat, 26 Sep 2009, Dongsoo, Nathaniel Kim wrote:
>>
>>> On Fri, Sep 25, 2009 at 3:07 AM, Guennadi Liakhovetski
>>> <g.liakhovetski@gmx.de> wrote:
>>> > Hi Hans
>>> >
>>> > Thanks for keeping us updated. One comment:
>>> >
>>> > On Wed, 23 Sep 2009, Hans Verkuil wrote:
>>> >
>>> >> In the afternoon we discussed the proposed timings API. There was no
>>> >> opposition to this API. The idea I had to also use this for sensor
>>> setup
>>> >> turned out to be based on a misconception on how the S_FMT relates
>>> to sensors.
>>> >> ENUM_FRAMESIZES basically gives you the possible resolutions that
>>> the scaler
>>> >> hidden inside the bridge can scale the native sensor resolution. It
>>> does not
>>> >> enumerate the various native sensor resolutions, since there is only
>>> one. So
>>> >> S_FMT really sets up the scaler.
>>> >
>>> > Just as Jinlu Yu noticed in his email, this doesn't reflect the real
>>> > situation, I am afraid. You can use binning and skipping on the
>>> sensor to
>>> > scale the image, and you can also use the bridge to do the scaling,
>>> as you
>>> > say. Worth than that, there's also a case, where there _several_ ways
>>> to
>>> > perform scaling on the sensor, among which one can freely choose, and
>>> the
>>> > host can scale too. And indeed it makes sense to scale on the source
>>> to
>>> > save the bandwidth and thus increase the framerate. So, what I'm
>>> currently
>>> > doing on sh-mobile, I try to scale on the client - in the best
>>> possible
>>> > way. And then use bridge scaling to provide the exact result.
>>> >
>>>
>>> Yes I do agree with you. And it is highly necessary to provide a clear
>>> method which obviously indicates which device to use in scaling job.
>>> When I use some application processors which provide camera
>>> peripherals with scaler inside and external ISP attached, there is no
>>> way to use both scaler features inside them. I just need to choose one
>>> of them.
>>
>> Well, I don't necessarily agree, in fact, I do use both scaling engines
>> in
>> my sh setup. The argument is as mentioned above - bus usage and
>> framerate
>> optimisation. So, what I am doing is: I try to scale on the sensor as
>> close as possible, and then scale further on the host (SoC). This works
>> well, only calculations are not very trivial. But you only have to
>> perform
>> them once during setup, so, it's not time-critical. Might be worth
>> implementing such calculations somewhere centrally to reduce error
>> chances
>> in specific drivers. Same with cropping.
>>
>
> I think that is a good approach. And considering the image quality, I
> should make bypass the scaler when user is requesting the exact
> resolution supported by the external camera ISP. Because some of
> camera interface embedded scalers are very poor in image quality and
> performance thus they may reduce in framerate as well. So, user can
> choose "with scaler" or "without scaler".

There are two ways of doing this: one is to have a smart driver that will
attempt to do the best thing (soc-camera, uvc, gspca), the other will be
to give the application writer full control of the SoC capabilities
through the media controller. Through a media controller you will be able
to setup the sensor scaler and a SoC scaler independently.

For a digital camera for example you probably want to be able to control
the hardware from the application in order to get the very best results,
rather than let the driver do it.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

