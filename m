Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:50083 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037AbbKLHcY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 02:32:24 -0500
Subject: Re: v4l vs. dpdk
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMhL3VT=b_u=MQcymxDdxRB+bCn8ozaWW7vMh2HFPuKdmvQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56444083.8000907@xs4all.nl>
Date: Thu, 12 Nov 2015 08:32:19 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhL3VT=b_u=MQcymxDdxRB+bCn8ozaWW7vMh2HFPuKdmvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2015 07:54 AM, Ran Shalit wrote:
> Hello,
> 
> I hope you can assist me on the following debate.
> 
> I need to develop a driver/application which capture and output video
> frames from PCIe device , and is using Intel cpu (i7), and Intel's
> media sdk server framework for the video compression.
> 
> I am not sure what will be a better choice between the following 2 options:
> 1. application which use dpdk for capture and output to the PCIe device
> 2. v4l driver for the PCIe device
> 
> Intel advocate the usage of dpdk (framework for packet processing).
> dpdk is supposed to be able to read/write from PCIe device too.
> I tried to see the prons/cons of dpdk compared to v4l.

Of course they advocate it: it will lock you in to their CPU and their SDK.
V4L2 is platform independent: your PCIe device will work just as well on
other platforms and with any v4l2-aware application.

> 
> prons of dpdk, as I understand them:
> 1. userspace application (easier debugging compared to kernel
> debugging of v4l device driver)

But you probably have to do all the work and you can't use any of the
frameworks v4l2 gives you to simplify driver development.

> 2. supposed better performance

2 is nonsense. Video capture/output is just a matter of setting up the
DMA and feeding it buffers. The CPU is barely involved.

> 
> cons of dpdk compared to v4l:
> 1. I could not find examples for PCIe device usage , or samples for
> showing how application (such as media sdk) use dpdk video frames.

That might be a hint that it is perhaps not the best choice.

On the other hand, asking this on the linux-media mailinglist will
give you a biased answer :-)

Regards,

	Hans
