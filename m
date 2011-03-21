Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:49917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab1CUQt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 12:49:27 -0400
Date: Mon, 21 Mar 2011 17:49:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: V4L2_CAP_VIDEO_OUTPUT and videobuf[1/2] & adv7175 mediabus
In-Reply-To: <AANLkTimN9Acw2hE3p8T6U6RxgXi1HRcypKB2Uqg8V7oa@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103211740150.24139@axis700.grange>
References: <AANLkTimN9Acw2hE3p8T6U6RxgXi1HRcypKB2Uqg8V7oa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Christian

On Thu, 24 Feb 2011, Christian Gmeiner wrote:

> Hi all,
> 
> I jumped into the cold water and I am trying to convert the
> dxr3/em8300 driver to the v4l2 api. I got some parts already working,
> but I think
> that the hardest parts are still missing. As you might think... yes I
> have some questions :)
> 
> 1) The dxr3 has a hardware fifo, which is used to play content. Can I
> reuse videbuf1 or videbuf2 to manage the fifo? Are these
> the frameworks designed to support output devices - write operation to
> the device?

Yes, videobuf* APIs are used for both input and output. I don't think you 
would be able to use videobuf1 for your set up, and you shouldn't anyway. 
As for videobuf2 - not sure... Are those hardware buffers purely internal 
to the hardware or can they also be directly accessed by the CPU as normal 
RAM? Even if it is possible in principle, using videobuf2, you would, 
probably, have to write your own memory-allocator. I'm sure others on this 
list can give a more qualified answer to this question;-)

> Here you can find the current fifo impl.
> https://github.com/austriancoder/v4l2-em8300/blob/master/modules/em8300_fifo.c
> 
> 2) The adv7175 chip support to different input data types:
> 
> Video Input Data Port Supports:
> CCIR-656 4:2:2 8-Bit Parallel Input Format
> 4:2:2 16-Bit Parallel Input Format
> 
> See http://dxr3.sourceforge.net/download/hardware/ADV7175A_6A.pdf for
> more details about the chip.
> 
> Now I thought that I should use the v4l2-mediabus api for that, but I
> am not sure what pixel codes (V4L2_MBUS_FMT...)
> should be used for CCIR-656 4:2:2 8-Bit and CCIR-656 4:2:2 16-Bit.

Yes, you should use mediabus formats, and no, these formats are not 
defined yet. Please, propose a patch with these two new formats.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
