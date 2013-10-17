Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24862 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3JQM0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 08:26:13 -0400
Message-id: <525FD760.20506@samsung.com>
Date: Thu, 17 Oct 2013 14:26:08 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Jesse Barnes <jesse.barnes@intel.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Zhang <markz@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Sunil Joshi <joshi@samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Marcus Lorentzon <marcus.lorentzon@huawei.com>
Subject: Re: [PATCH/RFC v3 00/19] Common Display Framework
References: <1376068510-30363-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <52498146.4050600@ti.com> <524C1058.2050500@samsung.com>
 <524C1E78.6030508@ti.com> <52556370.1050102@samsung.com>
 <52579CB2.8050601@ti.com> <5257DEB5.6000708@samsung.com>
 <5257EF6A.4020005@ti.com> <5258084A.9000509@samsung.com>
 <52580EFF.2020401@ti.com> <525F9660.3010408@samsung.com>
 <525F9D4D.4000702@ti.com>
In-reply-to: <525F9D4D.4000702@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2013 10:18 AM, Tomi Valkeinen wrote:
> On 17/10/13 10:48, Andrzej Hajda wrote:
>
>> The main function of DSI is to transport pixels from one IP to another IP
>> and this function IMO should not be modeled by display entity.
>> "Power, clocks, etc" will be performed via control bus according to
>> panel demands.
>> If 'DSI chip' has additional functions for video processing they can
>> be modeled by CDF entity if it makes sense.
> Now I don't follow. What do you mean with "display entity" and with "CDF
> entity"? Are they the same?
Yes, they are the same, sorry for confusion.
>
> Let me try to clarify my point:
>
> On OMAP SoC we have a DSI encoder, which takes input from the display
> controller in parallel RGB format, and outputs DSI.
>
> Then there are external encoders that take MIPI DPI as input, and output
> DSI.
>
> The only difference with the above two components is that the first one
> is embedded into the SoC. I see no reason to represent them in different
> ways (i.e. as you suggested, not representing the SoC's DSI at all).
>
> Also, if you use DSI burst mode, you will have to have different video
> timings in the DSI encoder's input and output. And depending on the
> buffering of the DSI encoder, you could have different timings in any case.
I am not sure what exactly the encoder performs, if this is only image
transport from dispc to panel CDF pipeline in both cases should look like:
dispc ----> panel
The only difference is that panels will be connected via different Linux bus
adapters, but it will be irrelevant to CDF itself. In this case I would say
this is DSI-master rather than encoder, or at least that the only
function of the
encoder is DSI.

If display_timings on input and output differs, I suppose it should be
modeled
as display_entity, as this is an additional functionality(not covered by
DSI standard AFAIK).
CDF in such case:
dispc ---> encoder ---> panel
In this case I would call it encoder with DSI master.

>
> Furthermore, both components could have extra processing. I know the
> external encoders sometimes do have features like scaling.
The same as above, ISP with embedded DSI.
>
>>> We still have two different endpoint configurations for the same
>>> DSI-master port. If that configuration is in the DSI-master's port node,
>>> not inside an endpoint data, then that can't be supported.
>> I am not sure if I understand it correctly. But it seems quite simple:
>> when panel starts/resumes it request DSI (via control bus) to fulfill
>> its configuration settings.
>> Of course there are some settings which are not panel dependent and those
>> should reside in DSI node.
> Exactly. And when the two panels require different non-panel-dependent
> settings, how do you represent them in the DT data?

non-panel-dependent setting cannot depend on panel, by definition :)
>
>>>> We say then: callee handles locking :)
>>> Sure, but my point was that the caller handling the locking is much
>>> simpler than the callee handling locking. And the latter causes
>>> atomicity issues, as the other API could be invoked in between two calls
>>> for the first API.
>>>
>>>     
>> Could you describe such scenario?
> If we have two independent APIs, ctrl and video, that affect the same
> underlying hardware, the DSI bus, we could have a scenario like this:
>
> thread 1:
>
> ctrl->op_foo();
> ctrl->op_bar();
>
> thread 2:
>
> video->op_baz();
>
> Even if all those ops do locking properly internally, the fact that
> op_baz() can be called in between op_foo() and op_bar() may cause problems.
>
> To avoid that issue with two APIs we'd need something like:
>
> thread 1:
>
> ctrl->lock();
> ctrl->op_foo();
> ctrl->op_bar();
> ctrl->unlock();
>
> thread 2:
>
> video->lock();
> video->op_baz();
> video->unlock();
I should mention I was asking for real hw/drivers configuration.
I do not know what do you mean with video->op_baz() ?
DSI-master is not modeled in CDF, and only CDF provides video
operations.

I guess one scenario, when two panels are connected to single DSI-master.
In such case both can call DSI ops, but I do not know how do you want to
prevent it in case of your CDF-T implementation.

>
>>>> Platform devices
>>>> ~~~~~~~~~~~~~~~~
>>>> Platform devices are devices that typically appear as autonomous
>>>> entities in the system. This includes legacy port-based devices and
>>>> host bridges to peripheral buses, and most controllers integrated
>>>> into system-on-chip platforms.  What they usually have in common
>>>> is direct addressing from a CPU bus.  Rarely, a platform_device will
>>>> be connected through a segment of some other kind of bus; but its
>>>> registers will still be directly addressable.
>>> Yep, "typically" and "rarely" =). I agree, it's not clear. I think there
>>> are things with DBI/DSI that clearly point to a platform device, but
>>> also the other way.
>> Just to be sure, we are talking here about DSI-slaves, ie. for example
>> about panels,
>> where direct accessing from CPU bus usually is not possible.
> Yes. My point is that with DBI/DSI there's not much bus there (if a
> normal bus would be PCI/USB/i2c etc), it's just a point to point link
> without probing or a clearly specified setup sequence.

This is why I considered replacing DSI bus with DSI-master as parent
device and panel as slave platorm_device, like in MFD devices.

>
> If DSI/DBI was used only for control, a linux bus would probably make
> sense. But DSI/DBI is mainly a video transport channel, with the
> control-part being "secondary".
>
> And when considering that the video and control data are sent over the
> same channel (i.e. there's no separate, independent ctrl channel), and
> the strict timing restrictions with video, my gut feeling is just that
> all the extra complexity brought with separating the control to a
> separate bus is not worth it.
There is additional complexity due to bus implementation requirements
(I would rather call it boiler-plate code), but in core it is still a
matter of ops.
With Linux bus those ops are available only to DSI-slave, which is
also a good thing I guess.

Andrzej

>
>  Tomi
>
>

