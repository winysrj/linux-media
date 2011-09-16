Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47560 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1IPCoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 22:44:01 -0400
Received: by iaqq3 with SMTP id q3so1776307iaq.19
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 19:44:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E723281.6070208@iki.fi>
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com>
	<CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
	<4E723281.6070208@iki.fi>
Date: Fri, 16 Sep 2011 10:44:00 +0800
Message-ID: <CAFhB-RCNN74MdPCGB-J9Jqu0f_nxxspFoGsp+R97cQrWSUDFdw@mail.gmail.com>
Subject: Re: Asking advice for Camera/ISP driver framework design
From: Cliff Cai <cliffcai.sh@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 16, 2011 at 1:14 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Cliff Cai wrote:
>> Dear guys,
>
> Hi Cliff,
>
>> I'm currently working on a camera/ISP Linux driver project.Of course,I
>> want it to be a V4L2 driver,but I got a problem about how to design
>> the driver framework.
>> let me introduce the background of this ISP(Image signal processor) a
>> little bit.
>> 1.The ISP has two output paths,first one called main path which is
>> used to transfer image data for taking picture and recording,the other
>> one called preview path which is used to transfer image data for
>> previewing.
>> 2.the two paths have the same image data input from sensor,but their
>> outputs are different,the output of main path is high quality and
>> larger image,while the output of preview path is smaller image.
>
> Is the ISP able to process images which already are in memory, or is
> this only from the sensor?

yes,it has another DMA to achieve  this.

Cliff

>> 3.the two output paths have independent DMA engines used to move image
>> data to system memory.
>>
>> The problem is currently, the V4L2 framework seems only support one
>> buffer queue,and in my case,obviously,two buffer queues are required.
>> Any idea/advice for implementing such kind of V4L2 driver? or any
>> other better solutions?
>
> Regards,
>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
>
