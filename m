Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54869 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab3JKLTX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Oct 2013 07:19:23 -0400
Message-id: <5257DEB5.6000708@samsung.com>
Date: Fri, 11 Oct 2013 13:19:17 +0200
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
 <52579CB2.8050601@ti.com>
In-reply-to: <52579CB2.8050601@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/11/2013 08:37 AM, Tomi Valkeinen wrote:
> On 09/10/13 17:08, Andrzej Hajda wrote:
>
>> As I have adopted existing internal driver for MIPI-DSI bus, I did not
>> take too much
>> care for DT. You are right, 'bta-timeout' is a configuration parameter
>> (however its
>> minimal value is determined by characteristic of the DSI-slave). On the
>> other
>> side currently there is no good place for such configuration parameters
>> AFAIK.
> The minimum bta-timeout should be deducable from the DSI bus speed,
> shouldn't it? Thus there's no need to define it anywhere.
Hmm, specification says "This specified period shall be longer then
the maximum possible turnaround delay for the unit to which the
turnaround request was sent".
>
>>> - enable_hs and enable_te, used to enable/disable HS mode and
>>> tearing-elimination
>> It seems there should be a way to synchronize TE signal with panel,
>> in case signal is provided only to dsi-master. Some callback I suppose?
>> Or transfer synchronization should be done by dsi-master.
> Hmm, can you explain a bit what you mean?
>
> Do you mean that the panel driver should get a callback when DSI TE
> trigger happens?
>
> On OMAP, when using DSI TE trigger, the dsi-master does it all. So the
> panel driver just calls update() on the dsi-master, and then the
> dsi-master will wait for TE, and then start the transfer. There's also a
> callback to the panel driver when the transfer has completed.
Yes I though about a callback, but approach with DSI-master taking care
of synchronization in fact better fits to exynos-dsi and I suspect to
omap also.
>
>>> - set_max_rx_packet_size, used to configure the max rx packet size.
>> Similar callbacks should be added to mipi-dsi-bus ops as well, to
>> make it complete/generic.
> Do you mean the same calls should exist both in the mipi-dbi-bus ops and
> on the video ops? If they are called with different values, which one
> "wins"?
No, I meant that if mipi-dbi-bus want to be complete it should have
similar ops.
I did not think about scenario with two overlaping APIs.
>
>>> http://article.gmane.org/gmane.comp.video.dri.devel/90651
>>> http://article.gmane.org/gmane.comp.video.dri.devel/91269
>>> http://article.gmane.org/gmane.comp.video.dri.devel/91272
>>>
>>> I still think that it's best to consider DSI and DBI as a video bus (not
>>> as a separate video bus and a control bus), and provide the packet
>>> transfer methods as part of the video ops.
>> I have read all posts regarding this issue and currently I tend
>> to solution where CDF is used to model only video streams,
>> with control bus implemented in different framework.
>> The only concerns I have if we should use Linux bus for that.
> Ok. I have many other concerns, as I've expressed in the mails =). I
> still don't see how it could work. So I'd very much like to see a more
> detailed explanation how the separate control & video bus approach would
> deal with different scenarios.
>
> Let's consider a DSI-to-HDMI encoder chip. Version A of the chip is
> controlled via DSI, version B is controlled via i2c. As the output of
> the chip goes to HDMI connector, the DSI bus speed needs to be set
> according to the resolution of the HDMI monitor.
>
> So, with version A, the encoder driver would have some kind of pointers
> to ctrl_ops and video_ops (or, pointers to dsi_bus instance and
> video_bus instance), right? The ctrl_ops would need to have ops like
> set_bus_speed, enable_hs, etc, to configure the DSI bus.
>
> When the encoder driver is started, it'd probably set some safe bus
> speed, configure the encoder a bit, read the EDID, enable HS,
> re-configure the bus speed to match the monitor's video mode, configure
> the encoder, and at last enable the video stream.
>
> Version B would have i2c_client and video_ops. When the driver starts,
> it'd  probably do the same things as above, except the control messages
> would go through i2c. That means that setting the bus speed, enabling
> HS, etc, would happen through video_ops, as the i2c side has no
> knowledge of the DSI side, right? Would there be identical ops on both
> DSI ctrl and video ops?
>
> That sounds very bad. What am I missing here? How would it work?
If I undrestand correctly you think about CDF topology like below:

DispContr(SoC) ---> DSI-master(SoC) ---> encoder(DSI or I2C)

But I think with mipi-dsi-bus topology could look like:

DispContr(SoC) ---> encoder(DSI or I2C)

DSI-master will not have its own entity, in the graph it could be
represented
by the link(--->), as it really does not process the video, only
transports it.

In case of version A I think everything is clear.
In case of version B it does not seems so nice at the first sight, but
still seems quite straightforward to me - special plink in encoder's
node pointing
to DSI-master, driver will find the device in runtime and use ops as needed
(additional ops/helpers required).
This is also the way to support devices which can be controlled by DSI
and I2C
in the same time. Anyway I suspect such scenario will be quite rare.

>
> And, if we want to separate the video and control, I see no reason to
> explicitly require the video side to be present. I.e. we could as well
> have a DSI peripheral that has only the control bus used. How would that
> reflect to, say, the DT presentation? Say, if we have a version A of the
> encoder, we could have DT data like this (just a rough example):
>
> soc-dsi {
> 	encoder {
> 		input: endpoint {
> 			remote-endpoint = <&soc-dsi-ep>;
Here I would replace &soc-dsi-ep by phandle to display controller/crtc/....

> 			/* configuration for the DSI lanes */
> 			dsi-lanes = <0 1 2 3 4 5>;
Wow, quite advanced DSI.
> 		};
> 	};
> };
>
> So the encoder would be places inside the SoC's DSI node, similar to how
> an i2c device would be placed inside SoC's i2c node. DSI configuration
> would be inside the video endpoint data.
>
> Version B would be almost the same:
>
> &i2c0 {
> 	encoder {
> 		input: endpoint {
> 			remote-endpoint = <&soc-dsi-ep>;
&soc-dsi-ep => &disp-ctrl-ep
> 			/* configuration for the DSI lanes */
> 			dsi-lanes = <0 1 2 3 4 5>;
> 		};
> 	};
> };
>
> Now, how would the video-bus-less device be defined?
> It'd be inside the
> soc-dsi node, that's clear. Where would the DSI lane configuration be?
> Not inside 'endpoint' node, as that's for video and wouldn't exist in
> this case. Would we have the same lane configuration in two places, once
> for video and once for control?
I think it is control setting, so it should be put outside endpoint node.
Probably it could be placed in encoder node.
>
> I agree that having DSI/DBI control and video separated would be
> elegant. But I'd like to hear what is the technical benefit of that? At
> least to me it's clearly more complex to separate them than to keep them
> together (to the extent that I don't yet see how it is even possible),
> so there must be a good reason for the separation. I don't understand
> that reason. What is it?
Roughly speaking it is a question where is the more convenient place to
put bunch
of opses, technically both solutions can be somehow implemented.

Pros of mipi bus:
- no fake entity in CDF, with fake opses, I have to use similar entities
in MIPI-CSI
camera pipelines and it complicates life without any benefit(at least
from user side),
- CDF models only video buses, control bus is a domain of Linux buses,
- less platform_bus abusing,
- better device tree topology (at least for common cases),
- quite simple in case of typical devices.

Regards
Andrzej
>
>  Tomi
>
>

