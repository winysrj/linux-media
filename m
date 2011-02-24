Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1156 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1BXNEZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 08:04:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
Date: Thu, 24 Feb 2011 14:04:19 +0100
Cc: Sachin Gupta <sachin.gupta@linaro.org>, "Clark, Rob" <rob@ti.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"ST-Ericsson LT Mailing List" <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org, gstreamer-devel@lists.freedesktop.org
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com> <AANLkTin0GZxLqtPjNx9AEOPQKRkJ6hf2mXMOqp+LvNw0@mail.gmail.com> <AANLkTinvDR9SAiBOVOxMXGANpSq8w22ObjPEbdaRcj3R@mail.gmail.com>
In-Reply-To: <AANLkTinvDR9SAiBOVOxMXGANpSq8w22ObjPEbdaRcj3R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241404.19275.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, February 24, 2011 13:29:56 Linus Walleij wrote:
> 2011/2/23 Sachin Gupta <sachin.gupta@linaro.org>:
> 
> > The imaging coprocessor in today's platforms have a general purpose DSP
> > attached to it I have seen some work being done to use this DSP for
> > graphics/audio processing in case the camera use case is not being tried or
> > also if the camera usecases does not consume the full bandwidth of this
> > dsp.I am not sure how v4l2 would fit in such an architecture,
> 
> Earlier in this thread I discussed TI:s DSPbridge.
> 
> In drivers/staging/tidspbridge
> http://omappedia.org/wiki/DSPBridge_Project
> you find the TI hackers happy at work with providing a DSP accelerator
> subsystem.
> 
> Isn't it possible for a V4L2 component to use this interface (or something
> more evolved, generic) as backend for assorted DSP offloading?
> 
> So using one kernel framework does not exclude using another one
> at the same time. Whereas something like DSPbridge will load firmware
> into DSP accelerators and provide control/datapath for that, this can
> in turn be used by some camera or codec which in turn presents a
> V4L2 or ALSA interface.

Yes, something along those lines can be done.

While normally V4L2 talks to hardware it is perfectly fine to talk to a DSP
instead.

The hardest part will be to identify the missing V4L2 API pieces and design
and add them. I don't think the actual driver code will be particularly hard.
It should be nothing more than a thin front-end for the DSP. Of course, that's
just theory at the moment :-)

The problem is that someone has to do the actual work for the initial driver.
And I expect that it will be a substantial amount of work. Future drivers should
be *much* easier, though.

A good argument for doing this work is that this API can hide which parts of
the video subsystem are hardware and which are software. The application really
doesn't care how it is organized. What is done in hardware on one SoC might be
done on a DSP instead on another SoC. But the end result is pretty much the same.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
