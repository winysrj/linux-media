Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:42558 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZIZIkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 04:40:42 -0400
Received: by qyk4 with SMTP id 4so2504887qyk.33
        for <linux-media@vger.kernel.org>; Sat, 26 Sep 2009 01:40:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909242000240.4913@axis700.grange>
References: <200909232239.20105.hverkuil@xs4all.nl> <Pine.LNX.4.64.0909242000240.4913@axis700.grange>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Sat, 26 Sep 2009 17:40:26 +0900
Message-ID: <5e9665e10909260140v2030ab5bvb7c1bed5e358319b@mail.gmail.com>
Subject: Re: V4L-DVB Summit Day 1
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 25, 2009 at 3:07 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Hans
>
> Thanks for keeping us updated. One comment:
>
> On Wed, 23 Sep 2009, Hans Verkuil wrote:
>
>> In the afternoon we discussed the proposed timings API. There was no
>> opposition to this API. The idea I had to also use this for sensor setup
>> turned out to be based on a misconception on how the S_FMT relates to sensors.
>> ENUM_FRAMESIZES basically gives you the possible resolutions that the scaler
>> hidden inside the bridge can scale the native sensor resolution. It does not
>> enumerate the various native sensor resolutions, since there is only one. So
>> S_FMT really sets up the scaler.
>
> Just as Jinlu Yu noticed in his email, this doesn't reflect the real
> situation, I am afraid. You can use binning and skipping on the sensor to
> scale the image, and you can also use the bridge to do the scaling, as you
> say. Worth than that, there's also a case, where there _several_ ways to
> perform scaling on the sensor, among which one can freely choose, and the
> host can scale too. And indeed it makes sense to scale on the source to
> save the bandwidth and thus increase the framerate. So, what I'm currently
> doing on sh-mobile, I try to scale on the client - in the best possible
> way. And then use bridge scaling to provide the exact result.
>

Yes I do agree with you. And it is highly necessary to provide a clear
method which obviously indicates which device to use in scaling job.
When I use some application processors which provide camera
peripherals with scaler inside and external ISP attached, there is no
way to use both scaler features inside them. I just need to choose one
of them.
Cheers,

Nate

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
