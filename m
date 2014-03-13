Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:43931 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaCMS72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 14:59:28 -0400
Message-ID: <eeec5a8802f535ed458ff9384bca7971.squirrel@www.codeaurora.org>
In-Reply-To: <53217418.40405@xs4all.nl>
References: <04588cf620ba3635c9a59e6eb92d0000.squirrel@www.codeaurora.org>
    <53217418.40405@xs4all.nl>
Date: Thu, 13 Mar 2014 18:59:27 -0000
Subject: Re: Query: Mutiple CAPTURE ports on a single device
From: vkalia@codeaurora.org
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: vkalia@codeaurora.org, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Hans for the pointers! Unfortunately, my driver is implemented M2M
way.

Thanks
Vinay

> Hi Vinay!
>
> On 03/12/14 18:58, vkalia@codeaurora.org wrote:
>> Hi
>>
>> I have a v4l2 driver for a hardware which is capable of taking one input
>> and producing two outputs. Eg: Downscaler which takes one input @ 1080p
>> and two outputs - one @ 720p and other at VGA. My driver is currently
>> implemented as having two capabilities -
>>
>> 1. V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
>> 2. V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
>>
>> Do you know if I can have two CAPTURE capabilities. In that case how do
>> I
>> distinguish between QBUF/DQBUF of each capability?
>
> The answer depends on how your driver is organized: is it a
> memory-to-memory
> device (i.e. it has one video node that is used for both output and
> capture
> to/from the m2m hardware) or does it have two video nodes, one for output
> to
> the hardware, one for capture from the hardware?
>
> In the first case you won't be able to implement this using the M2M API.
>
> In the second case it is quite easy: you just create another video capture
> node. For every frame send to the hardware you'll get a frame back at each
> of the two capture nodes, one 720p, one VGA.
>
> This is actually quite common, there are many drivers that have multiple
> video nodes that give back the same video source but in different formats
> (e.g. raw video and compressed video).
>
> Each video node basically represents a DMA engine. So if you have multiple
> DMA engines, you'll need multiple video nodes.
>
> Regards,
>
> 	Hans
>


