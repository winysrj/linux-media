Return-path: <mchehab@gaivota>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1684 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1ADKk5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 05:40:57 -0500
Message-ID: <f9cf31c9689f55d57cc2315395db31ad.squirrel@webmail.xs4all.nl>
In-Reply-To: <201101040946.21645.laurent.pinchart@ideasonboard.com>
References: <000601cba2d8$eaedcdc0$c0c96940$@org>
    <000001cbabb8$49892d10$dc9b8730$@org> <4D22BAA8.9050607@codeaurora.org>
    <201101040946.21645.laurent.pinchart@ideasonboard.com>
Date: Tue, 4 Jan 2011 11:40:40 +0100
Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Haibo Zhong" <hzhong@codeaurora.org>,
	"Shuzhen Wang" <shuzhenw@codeaurora.org>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	linux-media@vger.kernel.org, "Yan, Yupeng" <yyan@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> Hi Jeff,
>
> On Tuesday 04 January 2011 07:14:00 Haibo Zhong wrote:
>> On 1/3/2011 6:37 PM, Shuzhen Wang wrote:
>> > On Tuesday, December 28, 2010 12:24 PM Laurent Pinchart wrote:
>> >>
>> >> I will strongly NAK any implementation that requires a daemon.
>> >
>> > We understand the motivation behind making the daemon optional.
>> > However there are restrictions from legal perspective, which we
>> > don't know how to get around.
>> >
>> > A simplest video streaming data flow with MSM ISP is like this:
>> >
>> > Sensor ->  ISP Hardware pipeline ->  videobuf
>> >
>> > The procedure to set up ISP pipeline is proprietary and cannot
>> > be open sourced. Without proper pipeline configuration, streaming
>> > won't work. And That's why we require the daemon.
>>
>> Laurent/Hans/Mauro,
>>
>> We are working on and will provide more design information on Qualcomm
>> MSM ISP design and explain the legal concern of the daemon
>> implementation.
>>
>> The underlined idea is to comply to V4L2 architecture with MSM solution.
>
> That's a good first step, but I'm afraid it's not enough. If you want your
> driver to be included in the mainline Linux kernel (and its derivative
> distribution kernels such as the MeeGo kernel for instance) all the code
> needed to access and use the hardware must be open-source.
>
> This of course doesn't preclude you from providing a closed-source
> userspace
> implementation of proprietary hardware-assisted image processing
> algorithms
> for instance (as a library or as a daemon).
>
>> In the meantime, Laurent, can you share with your major concern about
>> the
>> Daemon?
>
> I have two concerns.
>
> - The daemon makes code required to use the hardware closed-source, making
> the
> driver closed-source (whether the kernel-side code is licensed under the
> GPL
> or not is irrelevant). I would have the exact same opinion if the required
> userspace proprietary code was provided as a library, so this concern is
> not
> specific to the implementation being in the form of a daemon.
>
> - The daemon makes the kernel-side driver architecture more complex for no
> reason. Assuming you can make all the driver open-source in the future and
> want to keep proprietary userspace image processing code closed-source,
> the
> driver architecture must not be designed solely to support that use case.
> The
> driver should be clean and lean, and the proprietary code must then come
> as a
> user of the driver, not the other way around.
>
> As a summary, having part of the driver closed-source is a no-go, and
> having
> part of the kernel driver API designed and used to support closed-source
> components only is a no-go as well.

I don't entirely understand the whole discussion: in Helsinki this was
discussed extensively with Jeff Zhong and I thought we all agreed on how
to implement the driver: using a libv4l plugin which communicates to a
daemon for your proprietary ISP code.

Also, the driver should work without any proprietary code (obviously with
sub-optimal picture quality, but you should get something out of the
hardware). The driver API should be well-documented when it comes to any
custom ioctls/controls. This makes it possible for sufficiently motivated
developers to write open source libv4l plugins. It was my understanding
that the proprietary code was about determining the optimal ISP settings,
not about getting the ISP hardware to work.

Regards,

        Hans

>
> --
> Regards,
>
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

