Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60736 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3JQHsx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 03:48:53 -0400
Message-id: <525F9660.3010408@samsung.com>
Date: Thu, 17 Oct 2013 09:48:48 +0200
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
 <52580EFF.2020401@ti.com>
In-reply-to: <52580EFF.2020401@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

Sorry for delayed response.


On 10/11/2013 04:45 PM, Tomi Valkeinen wrote:
> On 11/10/13 17:16, Andrzej Hajda wrote:
>
>> Picture size, content and format is the same on input and on output of DSI.
>> The same bits which enters DSI appears on the output. Internally bits
>> order can
>> be different but practically you are configuring DSI master and slave
>> with the same format.
>>
>> If you create DSI entity you will have to always set the same format and
>> size on DSI input, DSI output and encoder input.
>> If you skip creating DSI entity you loose nothing, and you do not need
>> to take care of it.
> Well, this is really a different question from the bus problem. But
> nothing says the DSI master cannot change the format or even size. For
> sure it can change the video timings. The DSI master could even take two
> parallel inputs, and combine them into one DSI output. You don't can't
> what all the possible pieces of hardware do =)
> If you have a bigger IP block that internally contains the DISPC and the
> DSI, then, yes, you can combine them into one display entity. I don't
> think that's correct, though. And if the DISPC and DSI are independent
> blocks, then especially I think there must be an entity for the DSI
> block, which will enable the powers, clocks, etc, when needed.
The main function of DSI is to transport pixels from one IP to another IP
and this function IMO should not be modeled by display entity.
"Power, clocks, etc" will be performed via control bus according to
panel demands.
If 'DSI chip' has additional functions for video processing they can
be modeled by CDF entity if it makes sense.
>>> Well, one point of the endpoints is also to allow "switching" of video
>>> devices.
>>>
>>> For example, I could have a board with a SoC's DSI output, connected to
>>> two DSI panels. There would be some kind of mux between, so that I can
>>> select which of the panels is actually connected to the SoC.
>>>
>>> Here the first panel could use 2 datalanes, the second one 4. Thus, the
>>> DSI master would have two endpoints, the other one using 2 and the other
>>> 4 datalanes.
>>>
>>> If we decide that kind of support is not needed, well, is there even
>>> need for the V4L2 endpoints in the DT data at all?
>> Hmm, both panels connected to one endpoint of dispc ?
>> The problem I see is which driver should handle panel switching,
>> but this is question about hardware design as well. If this is realized
>> by dispc I have told already the solution. If this is realized by other
>> device I do not see a problem to create corresponding CDF entity,
>> or maybe it can be handled by "Pipeline Controller" ???
> Well the switching could be automatic, when the panel power is enabled,
> the DSI mux is switched for that panel. It's not relevant.
>
> We still have two different endpoint configurations for the same
> DSI-master port. If that configuration is in the DSI-master's port node,
> not inside an endpoint data, then that can't be supported.
I am not sure if I understand it correctly. But it seems quite simple:
when panel starts/resumes it request DSI (via control bus) to fulfill
its configuration settings.
Of course there are some settings which are not panel dependent and those
should reside in DSI node.
>>>>> I agree that having DSI/DBI control and video separated would be
>>>>> elegant. But I'd like to hear what is the technical benefit of that? At
>>>>> least to me it's clearly more complex to separate them than to keep them
>>>>> together (to the extent that I don't yet see how it is even possible),
>>>>> so there must be a good reason for the separation. I don't understand
>>>>> that reason. What is it?
>>>> Roughly speaking it is a question where is the more convenient place to
>>>> put bunch
>>>> of opses, technically both solutions can be somehow implemented.
>>> Well, it's also about dividing a single physical bus into two separate
>>> interfaces to it. It sounds to me that it would be much more complex
>>> with locking. With a single API, we can just say "the caller handles
>>> locking". With two separate interfaces, there must be locking at the
>>> lower level.
>> We say then: callee handles locking :)
> Sure, but my point was that the caller handling the locking is much
> simpler than the callee handling locking. And the latter causes
> atomicity issues, as the other API could be invoked in between two calls
> for the first API.
>
>     
Could you describe such scenario?
> But note that I'm not saying we should not implement bus model just
> because it's more complex. We should go for bus model if it's better. I
> just want to bring up these complexities, which I feel are quite more
> difficult than with the simpler model.
>
>>>> Pros of mipi bus:
>>>> - no fake entity in CDF, with fake opses, I have to use similar entities
>>>> in MIPI-CSI
>>>> camera pipelines and it complicates life without any benefit(at least
>>>> from user side),
>>> You mean the DSI-master? I don't see how it's "fake", it's a video
>>> processing unit that has to be configured. Even if we forget the control
>>> side, and just think about plain video stream with DSI video mode,
>>> there's are things to configure with it.
>>>
>>> What kind of issues you have in the CSI side, then?
>> Not real issues, just needless calls to configure CSI entity pads,
>> with the same format and picture sizes as in camera.
> Well, the output of a component A is surely the same as the input of
> component B, if B receives the data from A. So that does sound useless.
> I don't do that kind of calls in my model.
>
>>>> - CDF models only video buses, control bus is a domain of Linux buses,
>>> Yes, but in this case the buses are the same. It makes me a bit nervous
>>> to have two separate ways (video and control) to use the same bus, in a
>>> case like video where timing is critical.
>>>
>>> So yes, we can consider video and control buses as "virtual" buses, and
>>> the actual transport is the DSI bus. Maybe it can be done. It just makes
>>> me a bit nervous =).
>>>
>>>> - less platform_bus abusing,
>>> Well, platform.txt says
>>>
>>> "This pseudo-bus
>>> is used to connect devices on busses with minimal infrastructure,
>>> like those used to integrate peripherals on many system-on-chip
>>> processors, or some "legacy" PC interconnects; as opposed to large
>>> formally specified ones like PCI or USB."
>>>
>>> I don't think DSI and DBI as platform bus is that far from the
>>> description. They are "simple", no probing point-to-point (in practice)
>>> buses. There's not much "bus" to speak of, just a point-to-point link.
>> Next section:
>>
>> Platform devices
>> ~~~~~~~~~~~~~~~~
>> Platform devices are devices that typically appear as autonomous
>> entities in the system. This includes legacy port-based devices and
>> host bridges to peripheral buses, and most controllers integrated
>> into system-on-chip platforms.  What they usually have in common
>> is direct addressing from a CPU bus.  Rarely, a platform_device will
>> be connected through a segment of some other kind of bus; but its
>> registers will still be directly addressable.
> Yep, "typically" and "rarely" =). I agree, it's not clear. I think there
> are things with DBI/DSI that clearly point to a platform device, but
> also the other way.
Just to be sure, we are talking here about DSI-slaves, ie. for example
about panels,
where direct accessing from CPU bus usually is not possible.

Andrzej
>>>> - better device tree topology (at least for common cases),
>>> Even if we use platform devices for DSI peripherals, we can have them
>>> described under the DSI master node.
>> Sorry, I meant rather Linux device tree topology, not DT.
> We can have the DSI peripheral platform devices as children of the
> DSI-master device.
>
>  Tomi
>
>

