Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4302 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQLvP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 06:51:15 -0500
Message-ID: <52B03A2F.8030800@xs4all.nl>
Date: Tue, 17 Dec 2013 12:49:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com, linux-omap@vger.kernel.org,
	tomi.valkeinen@ti.com
Subject: Re: [PATCH 0/8] v4l: ti-vpe: Add support for scaling and color conversion
References: <1386837364-1264-1-git-send-email-archit@ti.com> <52B00488.9060907@xs4all.nl> <52B0335D.5060606@ti.com>
In-Reply-To: <52B0335D.5060606@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/17/13 12:19, Archit Taneja wrote:
> Hi Hans,
> 
> On Tuesday 17 December 2013 01:30 PM, Hans Verkuil wrote:
>> On 12/12/2013 09:35 AM, Archit Taneja wrote:
>>> The VPE and VIP IPs in DRA7x contain common scaler and color
>>> conversion hardware blocks. We create libraries for these
>>> components such that the vpe driver and the vip driver(in future)
>>> can use these library funcs to configure the blocks.
>>> 
>>> There are some points for which I would like comments:
>>> 
>>> - For VPE, setting the format and colorspace for the source and
>>> destination queues is enough to determine how these blocks need
>>> to be configured and whether they need to be bypassed or not. So
>>> it didn't make sense to represent them as media controller
>>> entities. For VIP(driver not upstream yet), it's possible that
>>> there are multiple data paths which may or may not include these 
>>> blocks. However, the current use cases don't require such
>>> flexibility. There may be a need to re-consider a media
>>> controller like setup once we work on the VIP driver. Is it a
>>> good idea in terms of user-space compatibilty if we use media
>>> controller framework in the future.
>> 
>> As long as you don't need the mc, then there is no need to
>> implement it.
> 
> The thing is that we want to use these blocks for a future capture
> hardware called VIP. A VIP port can capture multiple streams from
> different sensors in time slices, and each of those streams might be
> sharing the same hardware, but probably in different configurations.
> I'm not completely aware of media controller details, and whether it
> can help us here.
> 
> I was just wondering if it would be a problem if we later realise
> that mc might be useful for some use cases. Would implementing it
> then break previous user space applications which don't call mc
> ioctls?

My understanding is that in the current vpe driver the mc won't be
needed, so there is no point adding it. When implementing the vip
capture driver the mc might be needed, but that should not require
the vpe to add the mc API as well. It's a decision that has to be
made per driver.

When you start work on the vip driver it is probably a good idea to
talk to Laurent and myself first to see whether the mc is needed or
not.

If you have a block diagram of the video hardware that you can share,
then that will be quite useful.

Regards,

	Hans
