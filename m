Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1BZN0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 08:26:38 -0500
Received: by fxm17 with SMTP id 17so2549735fxm.19
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 05:26:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102241404.19275.hverkuil@xs4all.nl>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	<AANLkTin0GZxLqtPjNx9AEOPQKRkJ6hf2mXMOqp+LvNw0@mail.gmail.com>
	<AANLkTinvDR9SAiBOVOxMXGANpSq8w22ObjPEbdaRcj3R@mail.gmail.com>
	<201102241404.19275.hverkuil@xs4all.nl>
Date: Sat, 26 Feb 2011 15:26:36 +0200
Message-ID: <AANLkTimgNkOrWLxpQEjQWdQy4CE5j4C-S0j6Ew=u82nP@mail.gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Sachin Gupta <sachin.gupta@linaro.org>,
	"Clark, Rob" <rob@ti.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org, gstreamer-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Thu, Feb 24, 2011 at 3:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thursday, February 24, 2011 13:29:56 Linus Walleij wrote:
>> 2011/2/23 Sachin Gupta <sachin.gupta@linaro.org>:
>>
>> > The imaging coprocessor in today's platforms have a general purpose DSP
>> > attached to it I have seen some work being done to use this DSP for
>> > graphics/audio processing in case the camera use case is not being tried or
>> > also if the camera usecases does not consume the full bandwidth of this
>> > dsp.I am not sure how v4l2 would fit in such an architecture,
>>
>> Earlier in this thread I discussed TI:s DSPbridge.
>>
>> In drivers/staging/tidspbridge
>> http://omappedia.org/wiki/DSPBridge_Project
>> you find the TI hackers happy at work with providing a DSP accelerator
>> subsystem.
>>
>> Isn't it possible for a V4L2 component to use this interface (or something
>> more evolved, generic) as backend for assorted DSP offloading?

Yes it is, and it has been part of my to-do list for some time now.

>> So using one kernel framework does not exclude using another one
>> at the same time. Whereas something like DSPbridge will load firmware
>> into DSP accelerators and provide control/datapath for that, this can
>> in turn be used by some camera or codec which in turn presents a
>> V4L2 or ALSA interface.
>
> Yes, something along those lines can be done.
>
> While normally V4L2 talks to hardware it is perfectly fine to talk to a DSP
> instead.
>
> The hardest part will be to identify the missing V4L2 API pieces and design
> and add them. I don't think the actual driver code will be particularly hard.
> It should be nothing more than a thin front-end for the DSP. Of course, that's
> just theory at the moment :-)

The pieces are known already. I started a project called gst-dsp,
which I plan to split into the gst part, and the part that
communicates with the DSP, this part can move to kernel side with a
v4l2 interface.

It's easier to identify the code in the patches for FFmpeg:
http://article.gmane.org/gmane.comp.video.ffmpeg.devel/116798

> The problem is that someone has to do the actual work for the initial driver.
> And I expect that it will be a substantial amount of work. Future drivers should
> be *much* easier, though.
>
> A good argument for doing this work is that this API can hide which parts of
> the video subsystem are hardware and which are software. The application really
> doesn't care how it is organized. What is done in hardware on one SoC might be
> done on a DSP instead on another SoC. But the end result is pretty much the same.

Exactly.

-- 
Felipe Contreras
