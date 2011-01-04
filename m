Return-path: <mchehab@gaivota>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40191 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1ADThc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 14:37:32 -0500
From: "Yan, Yupeng" <yyan@quicinc.com>
To: Markus Rechberger <mrechberger@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Haibo Zhong <hzhong@codeaurora.org>,
	Shuzhen Wang <shuzhenw@codeaurora.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"yyan@codeaurora.org" <yyan@codeaurora.org>
Date: Tue, 4 Jan 2011 11:37:31 -0800
Subject: RE: RFC: V4L2 driver for Qualcomm MSM camera.
Message-ID: <1EEF208DFEB6C846A382BB12BB9CD5EC723263EFBB@NASANEXMB14.na.qualcomm.com>
References: <000601cba2d8$eaedcdc0$c0c96940$@org>
	<000001cbabb8$49892d10$dc9b8730$@org>	<4D22BAA8.9050607@codeaurora.org>
	<201101040946.21645.laurent.pinchart@ideasonboard.com>
	<f9cf31c9689f55d57cc2315395db31ad.squirrel@webmail.xs4all.nl>
	<4D232EC6.10204@redhat.com>
 <AANLkTinxG7_3cwwHBfjfsC9pQXn1fN6kXd0sAAxMD4GQ@mail.gmail.com>
In-Reply-To: <AANLkTinxG7_3cwwHBfjfsC9pQXn1fN6kXd0sAAxMD4GQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

We will exploring the usage of libv4l2...however we still have the difficulties to open-source hardware: our ISP and sensors, will need help on how to address such issues.

-----Original Message-----
From: Markus Rechberger [mailto:mrechberger@gmail.com] 
Sent: Tuesday, January 04, 2011 10:08 AM
To: Mauro Carvalho Chehab
Cc: Hans Verkuil; Laurent Pinchart; Haibo Zhong; Shuzhen Wang; linux-media@vger.kernel.org; Yan, Yupeng; Zhong, Jeff
Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.

On Tue, Jan 4, 2011 at 3:29 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 04-01-2011 08:40, Hans Verkuil escreveu:
>>> Hi Jeff,
>>>
>>> On Tuesday 04 January 2011 07:14:00 Haibo Zhong wrote:
>>>> On 1/3/2011 6:37 PM, Shuzhen Wang wrote:
>>>>> On Tuesday, December 28, 2010 12:24 PM Laurent Pinchart wrote:
>>>>>>
>>>>>> I will strongly NAK any implementation that requires a daemon.
>>>>>
>>>>> We understand the motivation behind making the daemon optional.
>>>>> However there are restrictions from legal perspective, which we
>>>>> don't know how to get around.
>>>>>
>>>>> A simplest video streaming data flow with MSM ISP is like this:
>>>>>
>>>>> Sensor ->  ISP Hardware pipeline ->  videobuf
>>>>>
>>>>> The procedure to set up ISP pipeline is proprietary and cannot
>>>>> be open sourced. Without proper pipeline configuration, streaming
>>>>> won't work. And That's why we require the daemon.
>>>>
>>>> Laurent/Hans/Mauro,
>>>>
>>>> We are working on and will provide more design information on Qualcomm
>>>> MSM ISP design and explain the legal concern of the daemon
>>>> implementation.
>>>>
>>>> The underlined idea is to comply to V4L2 architecture with MSM solution.
>>>
>>> That's a good first step, but I'm afraid it's not enough. If you want your
>>> driver to be included in the mainline Linux kernel (and its derivative
>>> distribution kernels such as the MeeGo kernel for instance) all the code
>>> needed to access and use the hardware must be open-source.
>>>
>>> This of course doesn't preclude you from providing a closed-source
>>> userspace
>>> implementation of proprietary hardware-assisted image processing
>>> algorithms
>>> for instance (as a library or as a daemon).
>>>
>>>> In the meantime, Laurent, can you share with your major concern about
>>>> the
>>>> Daemon?
>>>
>>> I have two concerns.
>>>
>>> - The daemon makes code required to use the hardware closed-source, making
>>> the
>>> driver closed-source (whether the kernel-side code is licensed under the
>>> GPL
>>> or not is irrelevant). I would have the exact same opinion if the required
>>> userspace proprietary code was provided as a library, so this concern is
>>> not
>>> specific to the implementation being in the form of a daemon.
>>>
>>> - The daemon makes the kernel-side driver architecture more complex for no
>>> reason. Assuming you can make all the driver open-source in the future and
>>> want to keep proprietary userspace image processing code closed-source,
>>> the
>>> driver architecture must not be designed solely to support that use case.
>>> The
>>> driver should be clean and lean, and the proprietary code must then come
>>> as a
>>> user of the driver, not the other way around.
>>>
>>> As a summary, having part of the driver closed-source is a no-go, and
>>> having
>>> part of the kernel driver API designed and used to support closed-source
>>> components only is a no-go as well.
>>
>> I don't entirely understand the whole discussion: in Helsinki this was
>> discussed extensively with Jeff Zhong and I thought we all agreed on how
>> to implement the driver: using a libv4l plugin which communicates to a
>> daemon for your proprietary ISP code.
>
> I also had the same understanding from Helsinki's meeting.
>
>> Also, the driver should work without any proprietary code (obviously with
>> sub-optimal picture quality, but you should get something out of the
>> hardware). The driver API should be well-documented when it comes to any
>> custom ioctls/controls. This makes it possible for sufficiently motivated
>> developers to write open source libv4l plugins. It was my understanding
>> that the proprietary code was about determining the optimal ISP settings,
>> not about getting the ISP hardware to work.
>
> Look: we don't mind if you have some daemon/library/userspace utils with some
> picture enhancement algorithm that you may have developed and have legal
> concerns to protect them. The best way for doing that is probably via libv4l,
> as other userspace apps will use it, but you can do whatever you want.
>
> However, the driver should be open source for being accepted upstream.
> In other words, all access to the hardware should be done via the open
> source driver, and using a public, well documented, kernel<=>userspace API.
> That means that any application should be able to use it, without requiring
> any daemon.
>
> So, it is OK if your driver have some well-documented ways to expose image
> statistics and some way to adjust the device parameters to enhance image
> quality, and have some proprietary, closed source daemon/library that will
> use those statistics to enhance the image. Of course, such driver, to be open,
> should allow someone to write a different code to do similar enhancements,
> as Hans pointed.
>
> That's said, I can't understand why you're afraid of doing that.

Multiple reasons
1. They want to control their drivers and not have to take care about
the kernel release cycles.
2. With a thin kernel layer (if needed) they can still modify the
hardware and just need
to update the userspace part of it. This will make their product
better supported accross different
kernelversions.
3. easier debugging of course
4. things are going userspace.. see PCI/e virtualization, drivers can
be in Userspace which
also increases the system stability (and portability - my comment it's
easier to port userspace
drivers to other operating systems than kernelspace drivers we already
did that).

(note I'm not addressing opensource or closed source here, just the
advantage of userspace drivers).

Some people who just entered the year 1990 a few days ago don't see
those advantages maybe :-)

Markus

> Hardware
> initialization is very specific to a given hardware, and I don't see how
> open the initialization sequence for your hardware would cause any legal
> damage, or benefit your competitors: It is just a sequence of reads/writes.
> All drivers do it. The IP that you likely want to protect is the way you
> design your hardware and the image algorithms that you have to produce a
> clearer image. This won't be exposed by an open-source hardware, for
> two reasons:
>        1) They are not needed to make the driver work;
>        2) It is not a kernel task to do image conversion, handle auto-focus,
> do face track, do white balancing, etc. The kernel driver should just expose
> whatever feature the hardware have and let some userspace program to use it.
>
> So, if the hardware has white balancing, the driver should provide a control
> for the application to turn it on or off.
>
> With libv4l, you can even add a software white balancing control, that could,
> for example, read some hardware-provided statistics and use some red/green/blue
> gains and/or other hardware-provided controls. As discussed in Helsinki's meeting,
> libv4l can even call some proprietary code to actually implement such logic.
>
> Mauro.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
