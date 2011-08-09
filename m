Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26922 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1HIM6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 08:58:15 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LPN009J0W11FW@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Aug 2011 13:58:13 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPN00LQNW10D8@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Aug 2011 13:58:13 +0100 (BST)
Date: Tue, 09 Aug 2011 14:58:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC] The clock dependencies between sensor subdevs and the host
 interface drivers
In-reply-to: <201108091349.18460.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Marek Szyprowski/Poland R&D Center-Linux (MSS)/./????"
	<m.szyprowski@samsung.com>
Message-id: <4E412EE4.2030008@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <4E400280.7070100@samsung.com>
 <201108081744.37953.laurent.pinchart@ideasonboard.com>
 <4E40EB80.7080302@samsung.com>
 <201108091349.18460.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/09/2011 01:49 PM, Laurent Pinchart wrote:
...
>>>> The following is usually handled in the board files:
>>>>
>>>> 1) sensor/frontend power supply
>>>> 2) sensor's master clock (provided by the host device)
...
>>>> For 2) I'd like to propose adding a callback to struct v4l2_device, for
>>>> instance as in the below patch. The host driver would implement such an
>>>> operation and the sensor subdev driver would use it in its s_power op.
>>>
>>> What about using a struct clk object ? There has been lots of work in the
>>> ARM tree to make struct clk generic. I'm not sure if all patches have
>>> been pushed to mainline yet, but I think that's the direction we should
>>> follow.
>>
>> But is the 'struct clk' tried to be unified across all archs, not only ARM
>> ? I'm afraid it's not the case.
> 
> If the goals haven't changed since https://lkml.org/lkml/2011/5/20/85, the new 
> struct clk will be unified across all architectures.

OK, it sounds good then. Except the uncertainty of when actually the agreement
is achieved and the platforms are finally converted. Looks like there might
still be much time needed auntil the clk API based approach is applicable.
However I'm not denying we should be adopting it.

> 
>> By "using a struct clk object" do you also mean implementing some/all ops
>> of this object by the driver which exports it ?
> 
> That's correct.
> 
>> I suppose we can't rely only on the clock controller functionality exposed
>> through the clock API.
>>
>> Some devices may need to be brought to an active state before the clock can
>> be used outside. Some may have internal frequency dividers which need to be
>> handled in addition to the clock path in the clock controller.
>>
>> For instance, on Exynos4 the FIMC devices belong to a power domain that
>> needs to be enabled so the clock is not  blocked, and this is done through
>> the runtime PM calls.
>>
>> Normally the host device driver runtime resumes the device when /dev/video*
>> is opened. But we might want to use the clock before it happens, when only
>> a /dev/v4l-subdev* is opened, to play with the sensor device only. In this
>> situation the host device needs to be runtime resumed first.
>>
>> Thus the driver would need to (re)implement the clock ops to also handle
>> the details which are not covered by the clock controller driver.
> 
> The subdev driver would call clk_get(), which would end up being implemented 
> by the driver for whatever hardware block provides the clock. The driver would 
> then runtime_pm_resume() the hardware to start the clock.

Yup, makes sense.

> 
>> I also wonder how could we support the boards which choose to use some
>> extra external oscillator to provide clock to the sensors, rather than the
>> one derived from the host.
> 
> In that case the clock is always running. I'm not sure if we should create a 
> dummy clk object, or just pass a NULL clock and a fixed frequency to the 
> sensor driver.

Good point, a dummy (or not really) clock might be a good idea. Especially that
it might need to be created anyway.
I think, what we need, is a way to describe which clock goes where in terms of
DT bindings. Of course the clock names are not now being passed in DT.

--
Regards,
Sylwester Nawrocki
