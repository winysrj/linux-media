Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:39593 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbcFPRCG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 13:02:06 -0400
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
To: Jack Mitchell <ml@embed.me.uk>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	<linux-media@vger.kernel.org>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <64c29bbc-2273-2a9d-3059-ab8f62dc531b@embed.me.uk>
 <576202D0.6010608@mentor.com>
 <597d73df-0fa0-fa8d-e0e5-0ad8b2c49bcf@embed.me.uk>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <5762DB8A.8090906@mentor.com>
Date: Thu, 16 Jun 2016 10:02:02 -0700
MIME-Version: 1.0
In-Reply-To: <597d73df-0fa0-fa8d-e0e5-0ad8b2c49bcf@embed.me.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 02:49 AM, Jack Mitchell wrote:
>
> On 16/06/16 02:37, Steve Longerbeam wrote:
>> Hi Jack,
>>
>> On 06/15/2016 03:43 AM, Jack Mitchell wrote:
>>> <snip>
>>> Trying to use a user pointer rather than mmap also fails and causes a kernel splat.
>>>
>>
>> Hmm, I've tested userptr with the mem2mem driver, but maybe never
>> with video capture. I tried "v4l2-ctl -d/dev/video0 --stream-user=8" but
>> that returns "VIDIOC_QBUF: failed: Invalid argument", haven't tracked
>> down why (could be a bug in v4l2-ctl). Can you share the splat?
>>
>
> On re-checking the splat was the same v4l_cropcap that was mentioned before so I don't think it's related. The error I get back is:
>
> VIDIOC_QBUF error 22, Invalid argument
>
> I'm using the example program the the v4l2 docs [1].

I found the cause at least in my case. After enabling dynamic debug in
videobuf2-dma-contig.c, "v4l2-ctl -d/dev/video0 --stream-user=8" gives
me

[  468.826046] user data must be aligned to 64 bytes



But even getting past that alignment issue, I've only tested userptr (in mem2mem
driver) by giving the driver a user address of a mmap'ed kernel contiguous
buffer. A true discontiguous user buffer may not work, the IPU DMA does not
support scatter-gather.

Steve

