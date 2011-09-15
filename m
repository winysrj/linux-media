Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:38621 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1IORNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 13:13:44 -0400
Message-ID: <4E723281.6070208@iki.fi>
Date: Thu, 15 Sep 2011 20:14:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Cliff Cai <cliffcai.sh@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Asking advice for Camera/ISP driver framework design
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com> <CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
In-Reply-To: <CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cliff Cai wrote:
> Dear guys,

Hi Cliff,

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

Is the ISP able to process images which already are in memory, or is
this only from the sensor?

> 3.the two output paths have independent DMA engines used to move image
> data to system memory.
> 
> The problem is currently, the V4L2 framework seems only support one
> buffer queue,and in my case,obviously,two buffer queues are required.
> Any idea/advice for implementing such kind of V4L2 driver? or any
> other better solutions?

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
