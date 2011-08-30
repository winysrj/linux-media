Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51901 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1H3P30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 11:29:26 -0400
Received: by gya6 with SMTP id 6so5711733gya.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 08:29:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108301650190.19151@axis700.grange>
References: <alpine.DEB.2.02.1108171551040.17540@ipanema>
	<201108301546.42050.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.1108301555350.19151@axis700.grange>
	<201108301636.55251.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.1108301650190.19151@axis700.grange>
Date: Tue, 30 Aug 2011 17:28:47 +0200
Message-ID: <CABYn4syUi0ZjONWyZ_xkS1u4n_fF=xOEoXrvGN6xDYoRLBck6w@mail.gmail.com>
Subject: Re: [PATCH] media: Add support for arbitrary resolution for the
 ov5642 camera driver
From: Bastian Hecht <hechtb@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/30 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Tue, 30 Aug 2011, Hans Verkuil wrote:
>
>> On Tuesday, August 30, 2011 16:24:55 Guennadi Liakhovetski wrote:
>> > Hi Hans
>> >
>> > On Tue, 30 Aug 2011, Hans Verkuil wrote:
>
> [snip]
>
>> > > The problem with S_FMT changing the crop rectangle (and I assume we are not
>> > > talking about small pixel tweaks to make the hardware happy) is that the
>> > > crop operation actually removes part of the frame. That's not something you
>> > > would expect S_FMT to do, ever. Such an operation has to be explicitly
>> > > requested by the user.
>> > >
>> > > It's also why properly written applications (e.g. capture-example.c) has
>> > > code like this to reset the crop rectangle before starting streaming:
>> > >
>> > >         if (0 == xioctl(fd, VIDIOC_CROPCAP, &cropcap)) {
>> > >                 crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> > >                 crop.c = cropcap.defrect; /* reset to default */
>> > >
>> > >                 if (-1 == xioctl(fd, VIDIOC_S_CROP, &crop)) {
>> > >                         switch (errno) {
>> > >                         case EINVAL:
>> > >                                 /* Cropping not supported. */
>> > >                                 break;
>> > >                         default:
>> > >                                 /* Errors ignored. */
>> > >                                 break;
>> > >                         }
>> > >                 }
>> > >         }
>> > >
>> > > (Hmm, capture-example.c should also test for ENOTTY since we changed the
>> > > error code).
>> >
>> > I agree, that preserving input rectangle == output rectangle in reply to
>> > S_FMT is not nice, and should be avoided, wherever possible. Still, I
>> > prefer this to sticking with just one fixed output geometry, especially
>> > since (1) the spec doesn't prohibit this behaviour,
>>
>> Hmm, I think it should be prohibited. Few drivers actually implement crop,
>> and fewer applications use it. So I'm not surprised the spec doesn't go into
>> much detail.
>>
>> > (2) there are already
>> > precedents in the mainline.
>>
>> Which precedents? My guess is that any driver that does this was either not
>> (or poorly) reviewed, or everyone just missed it.
>
> My first two sensor drivers mt9m001 and mt9v022 do this, but, I suspect, I
> didn't invent it at that time, I think, I copied it from somewhere, cannot
> say for sure though anymore.
>
>> > Maybe, a bit of hardware background would help: the sensor is actually
>> > supposed to be able to both crop and scale, and we did try to implement
>> > scales other than 1:1, but the chip just refused to produce anything
>> > meaningful.
>>
>> I still don't see any reason why S_FMT would suddenly crop on such a sensor.
>> It's completely unexpected and the user does not get what he expects.
>
> Good, let's make it simple for all (except Bastian) then: Bastian, sorry
> for having misguided you, please, switch to .s_crop().

Sure, no problem. So s_fmt() shall be not available at all then,
right? Instead the cropping rectangle can be changed and the output
rectangle is adjusted accordingly.

best regards,

 Bastian

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
