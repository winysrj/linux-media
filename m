Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39059 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1INHlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 03:41:44 -0400
Received: by qyk7 with SMTP id 7so1368277qyk.19
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 00:41:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com>
	<CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
Date: Wed, 14 Sep 2011 15:41:43 +0800
Message-ID: <CAHG8p1BCsNdSu__aDV3OkQZxgz8Ohz01J9ufAHAjxDkwErOuuQ@mail.gmail.com>
Subject: Re: Asking advice for Camera/ISP driver framework design
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Cliff Cai <cliffcai.sh@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/9/14 Cliff Cai <cliffcai.sh@gmail.com>:
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
>
> Thanks a lot!
> Cliff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Your chip seems like davinci isp, only difference is dma. So you can
reference davinci drivers.
If dma interrupt doesn't happen at the same time,  I guess you must
wait because source image is the same.

Scott
