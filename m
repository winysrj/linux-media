Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8530 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3JKOQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Oct 2013 10:16:46 -0400
Message-id: <5258084A.9000509@samsung.com>
Date: Fri, 11 Oct 2013 16:16:42 +0200
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
 <5257EF6A.4020005@ti.com>
In-reply-to: <5257EF6A.4020005@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/11/2013 02:30 PM, Tomi Valkeinen wrote:
> On 11/10/13 14:19, Andrzej Hajda wrote:
>> On 10/11/2013 08:37 AM, Tomi Valkeinen wrote:
>>> The minimum bta-timeout should be deducable from the DSI bus speed,
>>> shouldn't it? Thus there's no need to define it anywhere.
>> Hmm, specification says "This specified period shall be longer then
>> the maximum possible turnaround delay for the unit to which the
>> turnaround request was sent".
> Ah, you're right. We can't know how long the peripheral will take
> responding. I was thinking of something that only depends on the
> bus-speed and the timings for that.
>
>> If I undrestand correctly you think about CDF topology like below:
>>
>> DispContr(SoC) ---> DSI-master(SoC) ---> encoder(DSI or I2C)
>>
>> But I think with mipi-dsi-bus topology could look like:
>>
>> DispContr(SoC) ---> encoder(DSI or I2C)
>>
>> DSI-master will not have its own entity, in the graph it could be
>> represented
>> by the link(--->), as it really does not process the video, only
>> transports it.
> At least in OMAP, the SoC's DSI-master receives parallel RGB data from
> DISPC, and encodes it to DSI. Isn't that processing? It's basically a
> DPI-to-DSI encoder. And it's not a simple pass-through, the DSI video
> timings could be considerably different than the DPI timings.
Picture size, content and format is the same on input and on output of DSI.
The same bits which enters DSI appears on the output. Internally bits
order can
be different but practically you are configuring DSI master and slave
with the same format.

If you create DSI entity you will have to always set the same format and
size on DSI input, DSI output and encoder input.
If you skip creating DSI entity you loose nothing, and you do not need
to take care of it.

>
>> In case of version A I think everything is clear.
>> In case of version B it does not seems so nice at the first sight, but
>> still seems quite straightforward to me - special plink in encoder's
>> node pointing
>> to DSI-master, driver will find the device in runtime and use ops as needed
>> (additional ops/helpers required).
>> This is also the way to support devices which can be controlled by DSI
>> and I2C
>> in the same time. Anyway I suspect such scenario will be quite rare.
> Okay, so if I gather it right, you say there would be something like
> 'dsi_adapter' (like i2c_adapter), which represents the dsi-master. And a
> driver could get pointer to this, regardless of whether it the linux
> device is a DSI device.
>
> At least one issue with this approach is the endpoint problem (see below).
>
>>> And, if we want to separate the video and control, I see no reason to
>>> explicitly require the video side to be present. I.e. we could as well
>>> have a DSI peripheral that has only the control bus used. How would that
>>> reflect to, say, the DT presentation? Say, if we have a version A of the
>>> encoder, we could have DT data like this (just a rough example):
>>>
>>> soc-dsi {
>>> 	encoder {
>>> 		input: endpoint {
>>> 			remote-endpoint = <&soc-dsi-ep>;
>> Here I would replace &soc-dsi-ep by phandle to display controller/crtc/....
>>
>>> 			/* configuration for the DSI lanes */
>>> 			dsi-lanes = <0 1 2 3 4 5>;
>> Wow, quite advanced DSI.
> Wha? That just means there is one clock lane and two datalanes, nothing
> more =). We can select the polarity of a lane, so we describe both the
> positive and negative lines there. So it says clk- is connected to pin
> 0, clk+ connected to pin 1, etc.
OK in V4L binding world it means DSI with six lanes :)
>
>>> 		};
>>> 	};
>>> };
>>>
>>> So the encoder would be places inside the SoC's DSI node, similar to how
>>> an i2c device would be placed inside SoC's i2c node. DSI configuration
>>> would be inside the video endpoint data.
>>>
>>> Version B would be almost the same:
>>>
>>> &i2c0 {
>>> 	encoder {
>>> 		input: endpoint {
>>> 			remote-endpoint = <&soc-dsi-ep>;
>> &soc-dsi-ep => &disp-ctrl-ep
>>> 			/* configuration for the DSI lanes */
>>> 			dsi-lanes = <0 1 2 3 4 5>;
>>> 		};
>>> 	};
>>> };
>>>
>>> Now, how would the video-bus-less device be defined?
>>> It'd be inside the
>>> soc-dsi node, that's clear. Where would the DSI lane configuration be?
>>> Not inside 'endpoint' node, as that's for video and wouldn't exist in
>>> this case. Would we have the same lane configuration in two places, once
>>> for video and once for control?
>> I think it is control setting, so it should be put outside endpoint node.
>> Probably it could be placed in encoder node.
> Well, one point of the endpoints is also to allow "switching" of video
> devices.
>
> For example, I could have a board with a SoC's DSI output, connected to
> two DSI panels. There would be some kind of mux between, so that I can
> select which of the panels is actually connected to the SoC.
>
> Here the first panel could use 2 datalanes, the second one 4. Thus, the
> DSI master would have two endpoints, the other one using 2 and the other
> 4 datalanes.
>
> If we decide that kind of support is not needed, well, is there even
> need for the V4L2 endpoints in the DT data at all?
Hmm, both panels connected to one endpoint of dispc ?
The problem I see is which driver should handle panel switching,
but this is question about hardware design as well. If this is realized
by dispc I have told already the solution. If this is realized by other
device I do not see a problem to create corresponding CDF entity,
or maybe it can be handled by "Pipeline Controller" ???
>
>>> I agree that having DSI/DBI control and video separated would be
>>> elegant. But I'd like to hear what is the technical benefit of that? At
>>> least to me it's clearly more complex to separate them than to keep them
>>> together (to the extent that I don't yet see how it is even possible),
>>> so there must be a good reason for the separation. I don't understand
>>> that reason. What is it?
>> Roughly speaking it is a question where is the more convenient place to
>> put bunch
>> of opses, technically both solutions can be somehow implemented.
> Well, it's also about dividing a single physical bus into two separate
> interfaces to it. It sounds to me that it would be much more complex
> with locking. With a single API, we can just say "the caller handles
> locking". With two separate interfaces, there must be locking at the
> lower level.
We say then: callee handles locking :)
>
>> Pros of mipi bus:
>> - no fake entity in CDF, with fake opses, I have to use similar entities
>> in MIPI-CSI
>> camera pipelines and it complicates life without any benefit(at least
>> from user side),
> You mean the DSI-master? I don't see how it's "fake", it's a video
> processing unit that has to be configured. Even if we forget the control
> side, and just think about plain video stream with DSI video mode,
> there's are things to configure with it.
>
> What kind of issues you have in the CSI side, then?
Not real issues, just needless calls to configure CSI entity pads,
with the same format and picture sizes as in camera.

>
>> - CDF models only video buses, control bus is a domain of Linux buses,
> Yes, but in this case the buses are the same. It makes me a bit nervous
> to have two separate ways (video and control) to use the same bus, in a
> case like video where timing is critical.
>
> So yes, we can consider video and control buses as "virtual" buses, and
> the actual transport is the DSI bus. Maybe it can be done. It just makes
> me a bit nervous =).
>
>> - less platform_bus abusing,
> Well, platform.txt says
>
> "This pseudo-bus
> is used to connect devices on busses with minimal infrastructure,
> like those used to integrate peripherals on many system-on-chip
> processors, or some "legacy" PC interconnects; as opposed to large
> formally specified ones like PCI or USB."
>
> I don't think DSI and DBI as platform bus is that far from the
> description. They are "simple", no probing point-to-point (in practice)
> buses. There's not much "bus" to speak of, just a point-to-point link.
Next section:

Platform devices
~~~~~~~~~~~~~~~~
Platform devices are devices that typically appear as autonomous
entities in the system. This includes legacy port-based devices and
host bridges to peripheral buses, and most controllers integrated
into system-on-chip platforms.  What they usually have in common
is direct addressing from a CPU bus.  Rarely, a platform_device will
be connected through a segment of some other kind of bus; but its
registers will still be directly addressable.


>> - better device tree topology (at least for common cases),
> Even if we use platform devices for DSI peripherals, we can have them
> described under the DSI master node.
Sorry, I meant rather Linux device tree topology, not DT.
>
>> - quite simple in case of typical devices.
> Still more complex than single API for both video and control =).
I agree.

Andrzej

>  Tomi
>
>

