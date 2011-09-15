Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43685 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1IOKUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 06:20:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Cliff Cai <cliffcai.sh@gmail.com>
Subject: Re: Asking advice for Camera/ISP driver framework design
Date: Thu, 15 Sep 2011 12:20:53 +0200
Cc: linux-media@vger.kernel.org
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com> <CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
In-Reply-To: <CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109151220.54131.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Cliff,

On Wednesday 14 September 2011 08:13:32 Cliff Cai wrote:
> Dear guys,
> 
> I'm currently working on a camera/ISP Linux driver project.Of course,I
> want it to be a V4L2 driver,but I got a problem about how to design
> the driver framework.
> let me introduce the background of this ISP(Image signal processor) a
> little bit.
> 1.The ISP has two output paths,first one called main path which is
> used to transfer image data for taking picture and recording,the other
> one called preview path which is used to transfer image data for
> previewing.
> 2.the two paths have the same image data input from sensor,but their
> outputs are different,the output of main path is high quality and
> larger image,while the output of preview path is smaller image.
> 3.the two output paths have independent DMA engines used to move image
> data to system memory.
> 
> The problem is currently, the V4L2 framework seems only support one
> buffer queue,and in my case,obviously,two buffer queues are required.
> Any idea/advice for implementing such kind of V4L2 driver? or any
> other better solutions?

Your driver should create two video nodes, one for each stream. They will each 
have their own buffers queue.

The driver should also implement the media controller API to let applications 
discover that the video nodes are related and how they interact with the ISP.

-- 
Regards,

Laurent Pinchart
