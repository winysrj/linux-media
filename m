Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56614 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934046Ab1IOPjD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 11:39:03 -0400
Received: by yxm8 with SMTP id 8so2256463yxm.19
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 08:39:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109151220.54131.laurent.pinchart@ideasonboard.com>
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com>
	<CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
	<201109151220.54131.laurent.pinchart@ideasonboard.com>
Date: Thu, 15 Sep 2011 23:38:32 +0800
Message-ID: <CAFhB-RB8Pm--H5__kjKN=v=7pF0xtt_VKJw0Dh3YfQ6GE+4KVg@mail.gmail.com>
Subject: Re: Asking advice for Camera/ISP driver framework design
From: Cliff Cai <cliffcai.sh@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 15, 2011 at 6:20 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Cliff,
>
> On Wednesday 14 September 2011 08:13:32 Cliff Cai wrote:
>> Dear guys,
>>
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
>> 3.the two output paths have independent DMA engines used to move image
>> data to system memory.
>>
>> The problem is currently, the V4L2 framework seems only support one
>> buffer queue,and in my case,obviously,two buffer queues are required.
>> Any idea/advice for implementing such kind of V4L2 driver? or any
>> other better solutions?
>
> Your driver should create two video nodes, one for each stream. They will each
> have their own buffers queue.
>
> The driver should also implement the media controller API to let applications
> discover that the video nodes are related and how they interact with the ISP.

Hi Laurent,

As "Documentation/media-framework" says, one of the goals of media
device model is "Discovering a device internal topology,and
configuring it at runtime".I'm just a bit confused about how
applications can discover the related video notes? Could you explain
it a little more?


Thanks a lot!
Cliff
