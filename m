Return-path: <linux-media-owner@vger.kernel.org>
Received: from eumx.net ([91.82.101.43]:43277 "EHLO owm.eumx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbcFPJsd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 05:48:33 -0400
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <64c29bbc-2273-2a9d-3059-ab8f62dc531b@embed.me.uk>
 <576202D0.6010608@mentor.com>
From: Jack Mitchell <ml@embed.me.uk>
Message-ID: <597d73df-0fa0-fa8d-e0e5-0ad8b2c49bcf@embed.me.uk>
Date: Thu, 16 Jun 2016 10:49:19 +0100
MIME-Version: 1.0
In-Reply-To: <576202D0.6010608@mentor.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 16/06/16 02:37, Steve Longerbeam wrote:
> Hi Jack,
>
> On 06/15/2016 03:43 AM, Jack Mitchell wrote:
>> <snip>
>> Trying to use a user pointer rather than mmap also fails and causes a kernel splat.
>>
>
> Hmm, I've tested userptr with the mem2mem driver, but maybe never
> with video capture. I tried "v4l2-ctl -d/dev/video0 --stream-user=8" but
> that returns "VIDIOC_QBUF: failed: Invalid argument", haven't tracked
> down why (could be a bug in v4l2-ctl). Can you share the splat?
>

On re-checking the splat was the same v4l_cropcap that was mentioned 
before so I don't think it's related. The error I get back is:

VIDIOC_QBUF error 22, Invalid argument

I'm using the example program the the v4l2 docs [1].

Cheers,
Jack

[1] https://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html

>
>> Apart from that and a few v4l2-compliance tests failing which you already mentioned, it seems to work OK. I'll try and do some more testing and see if I can come back with some more feedback.
>
> Thanks!
>
>
> Steve
>
