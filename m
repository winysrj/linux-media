Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9281 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3JRLzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 07:55:22 -0400
Message-id: <526121A3.3060000@samsung.com>
Date: Fri, 18 Oct 2013 13:55:15 +0200
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
 <525F9D4D.4000702@ti.com> <525FD760.20506@samsung.com>
 <525FDE54.2070909@ti.com>
In-reply-to: <525FDE54.2070909@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2013 02:55 PM, Tomi Valkeinen wrote:
> On 17/10/13 15:26, Andrzej Hajda wrote:
>
>> I am not sure what exactly the encoder performs, if this is only image
>> transport from dispc to panel CDF pipeline in both cases should look like:
>> dispc ----> panel
>> The only difference is that panels will be connected via different Linux bus
>> adapters, but it will be irrelevant to CDF itself. In this case I would say
>> this is DSI-master rather than encoder, or at least that the only
>> function of the
>> encoder is DSI.
> Yes, as I said, it's up to the driver writer how he wants to use CDF. If
> he doesn't see the point of representing the SoC's DSI encoder as a
> separate CDF entity, nobody forces him to do that.
Having it as an entity would cause the 'problem' of two APIs as you
described below :)
One API via control bus, another one via CDF.
>
> On OMAP, we have single DISPC with multiple parallel outputs, and a
> bunch of encoder IPs (MIPI DPI, DSI, DBI, etc). Each encoder IP can be
> connected to some of the DISPC's output. In this case, even if the DSI
> encoder does nothing special, I see it much better to represent the DSI
> encoder as a CDF entity so that the links between DISPC, DSI, and the
> DSI peripherals are all there.
>
>> If display_timings on input and output differs, I suppose it should be
>> modeled
>> as display_entity, as this is an additional functionality(not covered by
>> DSI standard AFAIK).
> Well, DSI standard is about the DSI output. Not about the encoder's
> input, or the internal operation of the encoder.
>
>>>> Of course there are some settings which are not panel dependent and those
>>>> should reside in DSI node.
>>> Exactly. And when the two panels require different non-panel-dependent
>>> settings, how do you represent them in the DT data?
>> non-panel-dependent setting cannot depend on panel, by definition :)
> With "non-panel-dependent" setting I meant something that is a property
> of the DSI master device, but still needs to be configured differently
> for each panel.
>
> Say, pin configuration. When using panel A, the first pin of the DSI
> block could be clock+. With panel B, the first pin could be clock-. This
> configuration is about DSI master, but it is different for each panel.
>
> If we have separate endpoint in the DSI master for each panel, this data
> can be there. If we don't have the endpoint, as is the case with
> separate control bus, where is that data?
I am open to propositions. For me it seems somehow similar to clock mapping
in DT (clock-names are mapped to provider clocks), so I think it could
be put in panel node and it will be parsed by DSI-master.
>
>>>> Could you describe such scenario?
>>> If we have two independent APIs, ctrl and video, that affect the same
>>> underlying hardware, the DSI bus, we could have a scenario like this:
>>>
>>> thread 1:
>>>
>>> ctrl->op_foo();
>>> ctrl->op_bar();
>>>
>>> thread 2:
>>>
>>> video->op_baz();
>>>
>>> Even if all those ops do locking properly internally, the fact that
>>> op_baz() can be called in between op_foo() and op_bar() may cause problems.
>>>
>>> To avoid that issue with two APIs we'd need something like:
>>>
>>> thread 1:
>>>
>>> ctrl->lock();
>>> ctrl->op_foo();
>>> ctrl->op_bar();
>>> ctrl->unlock();
>>>
>>> thread 2:
>>>
>>> video->lock();
>>> video->op_baz();
>>> video->unlock();
>> I should mention I was asking for real hw/drivers configuration.
>> I do not know what do you mean with video->op_baz() ?
>> DSI-master is not modeled in CDF, and only CDF provides video
>> operations.
> It was just an example of the additional complexity with regarding
> locking when using two APIs.
>
> The point is that if the panel driver has two pointers (i.e. API), one
> for the control bus, one for the video bus, and ops on both buses affect
> the same hardware, the locking is not easy.
>
> If, on the other hand, the panel driver only has one API to use, it's
> simple to require the caller to handle any locking.
I guess you are describing scenario with DSI-master having its own entity.
In such case its video ops are accessible at least to all pipeline
neightbourgs and
to pipeline controler, so I do not see how the client side locking would
work anyway.
Additionally multiple panels connected to one DSI also makes it harder.
Thus I do not see that 'client lock' apporach would work anyway, even
using video-source approach.

Andrzej


