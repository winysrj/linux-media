Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728286AbeINAW4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 20:22:56 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8DJABcY091754
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 15:12:05 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2mfvgek2b2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 15:12:05 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Thu, 13 Sep 2018 15:12:04 -0400
Subject: Re: [PATCH 0/4] media: platform: Add Aspeed Video Engine driver
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, sboyd@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, mchehab@kernel.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
References: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
 <364c2565-fdb0-dd31-5852-6358066810a5@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2018 14:11:49 -0500
MIME-Version: 1.0
In-Reply-To: <364c2565-fdb0-dd31-5852-6358066810a5@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <64db5bad-d774-f5a5-3003-b361941355a2@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/03/2018 06:57 AM, Hans Verkuil wrote:
> Hi Eddie,
>
> Thank you for your work on this. Interesting to see support for this SoC :-)
>
> On 08/29/2018 11:09 PM, Eddie James wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting as a service processor, the Video Engine can
>> capture the host processor graphics output.
>>
>> This series adds a V4L2 driver for the VE, providing a read() interface
>> only. The driver triggers the hardware to capture the host graphics output
>> and compress it to JPEG format.
>>
>> Testing on an AST2500 determined that the videobuf/streaming/mmap interface
>> was significantly slower than the simple read() interface, so I have not
>> included the streaming part.
> Do you know why? It should be equal or faster, not slower.

Yes, it seems to be an issue with the timing of the video engine 
interrupts compared with how a normal v4l2 application queues buffers. 
With the simple read() application, the driver can swap between DMA 
buffers freely and get a frame ahead. With the streaming buffers, I 
found the driver ran through the queue quite quickly, but then, once 
userspace queues again, we had to wait for the next frame, as I couldn't 
get a frame ahead since no buffers were available during that time 
period. This could possibly be solved with more buffers but this gets to 
require a lot of memory, since each buffer is allocated for the full 
frame size even though we only fill a fraction of it with JPEG data...

>
> I reviewed about half of the driver, but then I stopped since there were too
> many things missing.
>
> First of all, you need to test your driver with v4l2-compliance (available here:
> https://git.linuxtv.org/v4l-utils.git/). Always compile from the git repo since
> the versions from distros tend to be too old.
>
> Just run 'v4l2-compliance -d /dev/videoX' and fix all issues. Then run
> 'v4l2-compliance -s -d /dev/videoX' to test streaming.
>
> This utility checks if the driver follows the V4L2 API correctly, implements
> all ioctls that it should and fills in all the fields that it should.
>
> Please add the output of 'v4l2-compliance -s' to future versions of this patch
> series: I don't accept V4L2 drivers without a clean report of this utility.

Sure thing. Thanks for the guidance.

>
> If you have any questions, then mail me or (usually quicker) ask on the #v4l
> freenode irc channel (I'm in the CET timezone).
>
> One thing that needs more explanation: from what I could tell from the driver
> the VIDIOC_G_FMT ioctl returns the detected format instead of the current
> format. This is wrong. Instead you should implement the VIDIOC_*_DV_TIMINGS
> ioctls and the V4L2_EVENT_SOURCE_CHANGE event.
>
> The normal sequence is that userspace queries the current timings with
> VIDIOC_QUERY_DV_TIMINGS, if it finds valid timings, then it sets these
> timings with _S_DV_TIMINGS. Now it can call G/S_FMT. If the timings
> change, then the driver should detect that and send a V4L2_EVENT_SOURCE_CHANGE
> event.

OK I see. I ended up simplifying this part anyway since it's not 
possible to change the video size from the driver. I don't think there 
is a need for VIDIOC_QUERY_DV_TIMINGS now, but feel free to review.

Thanks again,
Eddie

>
> When the application receives this event it can take action, such as
> increasing the size of the buffer for the jpeg data that it reads into.
>
> The reason for this sequence of events is that you can't just change the
> format/resolution mid-stream without giving userspace the chance to
> reconfigure.
>
> Regards,
>
> 	Hans
>
>> It's also possible to use an automatic mode for the VE such that
>> re-triggering the HW every frame isn't necessary. However this wasn't
>> reliable on the AST2400, and probably used more CPU anyway due to excessive
>> interrupts. It was approximately 15% faster.
>>
>> The series also adds the necessary parent clock definitions to the Aspeed
>> clock driver, with both a mux and clock divider.
>>
>> Eddie James (4):
>>    clock: aspeed: Add VIDEO reset index definition
>>    clock: aspeed: Setup video engine clocking
>>    dt-bindings: media: Add Aspeed Video Engine binding documentation
>>    media: platform: Add Aspeed Video Engine driver
>>
>>   .../devicetree/bindings/media/aspeed-video.txt     |   23 +
>>   drivers/clk/clk-aspeed.c                           |   41 +-
>>   drivers/media/platform/Kconfig                     |    8 +
>>   drivers/media/platform/Makefile                    |    1 +
>>   drivers/media/platform/aspeed-video.c              | 1307 ++++++++++++++++++++
>>   include/dt-bindings/clock/aspeed-clock.h           |    1 +
>>   6 files changed, 1379 insertions(+), 2 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>
