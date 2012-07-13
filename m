Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63723 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab2GMCaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 22:30:15 -0400
Received: by obbuo13 with SMTP id uo13so4182179obb.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 19:30:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFC82F9.2090004@mlbassoc.com>
References: <4FFC3109.3080204@mlbassoc.com>
	<CABMb9GtV_CZ=ZFoqXD_u3dmZQoD5CmsptYkgwwecO7Ch9v3AAw@mail.gmail.com>
	<4FFC82F9.2090004@mlbassoc.com>
Date: Thu, 12 Jul 2012 21:30:14 -0500
Message-ID: <CAC-OdnBfxJar83+WFm1N-C0=+MivOvfAiWaEP-O3iCkYKxktbA@mail.gmail.com>
Subject: Re: OMAP4 support
From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Chris Lalancette <clalancette@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Discussion <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Tue, Jul 10, 2012 at 2:31 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2012-07-10 11:05, Chris Lalancette wrote:
>>
>> On Tue, Jul 10, 2012 at 9:41 AM, Gary Thomas <gary@mlbassoc.com> wrote:
>>>
>>> I'm looking for video support on OMAP4 platforms.  I've found the
>>> PandaBoard camera project
>>> (http://www.omappedia.org/wiki/PandaBoard_Camera_Support)
>>> and this is starting to work.  That said, I'm having some
>>> issues with setting up the pipeline, etc.
>>>
>>> Can this list help out?
>>
>>
>> I'm not sure exactly what kind of cameras you want to get working, but
>> if you are looking to get CSI2 cameras going through the ISS, Sergio
>> Aguirre has been working on support.  He also works on the media-ctl
>> tool, which is used for configuring the media framework pipeline.  The
>> latest versions that I am aware of are here:
>>
>> git://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera.git
>
>
> Yes, this is the tree I've been working with (pointed to by the page I
> mentioned).
>
> My kernel can see the camera OV5650 and set up the pipeline.  I am able to
> grab
> the raw SGRBG10 data but I'd like to get the ISS to convert this to a more
> usable
> UYVY format.  Here's what I tried:
>   media-ctl -r
>   media-ctl -l '"OMAP4 ISS CSI2a":1 -> "OMAP4 ISS ISP IPIPEIF":0 [1]'
>   media-ctl -l '"OMAP4 ISS ISP IPIPEIF":1 -> "OMAP4 ISS ISP IPIPEIF
> output":0 [1]'
>   media-ctl -f '"ov5650 3-0036":0 [SGRBG10 2592x1944]'
>   media-ctl -f '"OMAP4 ISS CSI2a":0 [SGRBG10 2592x1944]'
>   media-ctl -f '"OMAP4 ISS ISP IPIPEIF":0 [SGRBG10 2592x1944]','"OMAP4 ISS
> ISP IPIPEIF":1 [UYVY 2592x1944]'
>
> Sadly, I can't get the IPIPEIF element to take SGRGB10 in and put UYVY out
> (my reading
> of the manual implies that this _should_ be possible).  I always see this
> pipeline setup:
> - entity 5: OMAP4 ISS ISP IPIPEIF (3 pads, 4 links)
>             type V4L2 subdev subtype Unknown
>             device node name /dev/v4l-subdev2
>         pad0: Input [SGRBG10 2592x1944]
>                 <- 'OMAP4 ISS CSI2a':pad1 [ACTIVE]
>                 <- 'OMAP4 ISS CSI2b':pad1 []
>         pad1: Output [SGRBG10 2592x1944]
>                 -> 'OMAP4 ISS ISP IPIPEIF output':pad0 [ACTIVE]
>         pad2: Output [SGRBG10 2592x1944]
>                 -> 'OMAP4 ISS ISP resizer':pad0 []
>
> Am I missing something?  How can I make this conversion in the ISS?

The core problem is that, i haven't published any support for
RAW10->YUV conversion,
which is part of the IPIPE module (not the IPIPEIF, like you mention). I had
some patches, but sadly it is unfinished work. :/

Now, there's a main non-technical problem... I no longer work at TI
since end of June
this year, and I don't have the right HW setup available anymore.
Those sensors were
company's asset, and I couldn't keep any.

Now, we can make this work with cooperation of someone who has the right setup,
and me sharing my patches and some advice on my experience.

What do you think?

>
> Note: if this is not the appropriate place to ask these questions, please
> redirect me (hopefully to a useful list :-)

As I'm the main person who has been actively developing this, I'm your
guy to ask questions :).

By the way, this development has been my initiative the whole time,
and not an official
TI objective, so, to be honest, asking TI for official support won't
help much right now.

Regards,
Sergio

>
>
> Thanks
>
> --
> ------------------------------------------------------------
> Gary Thomas                 |  Consulting for the
> MLB Associates              |    Embedded world
> ------------------------------------------------------------
>
>
