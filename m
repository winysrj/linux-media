Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43105 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757510AbcAKKn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 05:43:57 -0500
Subject: Re: CMA usage in driver
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMhK7f4kLYaTw874g4w2vjd5nw_FBET1JsjX9Us30Eve5GQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56938769.308@xs4all.nl>
Date: Mon, 11 Jan 2016 11:43:53 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhK7f4kLYaTw874g4w2vjd5nw_FBET1JsjX9Us30Eve5GQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2016 10:23 PM, Ran Shalit wrote:
> Hello,
> 
> I made some reading on CMA usage with device driver, nut not quite sure yet.
> Do we need to call dma_declare_contiguous or does it get called from
> within videobuf2 ?
> 
> Is there any example how to use CMA memory in v4l2 driver ?

You don't need to do anything. If the architecture supports cma (ARM does, but I'm
not sure if it is supported for x86_64) and it is enabled in the kernel, then you
have it. All you have to do is to add cma=<memsize> to the kernel options to
reserve CMA memory and when vb2 allocates buffer memory it will automatically use the
CMA memory for it.

Regards,

	Hans

