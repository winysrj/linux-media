Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49427 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab3LQLUH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 06:20:07 -0500
Message-ID: <52B0335D.5060606@ti.com>
Date: Tue, 17 Dec 2013 16:49:57 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <k.debski@samsung.com>,
	<laurent.pinchart@ideasonboard.com>, <linux-omap@vger.kernel.org>,
	<tomi.valkeinen@ti.com>
Subject: Re: [PATCH 0/8] v4l: ti-vpe: Add support for scaling and color conversion
References: <1386837364-1264-1-git-send-email-archit@ti.com> <52B00488.9060907@xs4all.nl>
In-Reply-To: <52B00488.9060907@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 17 December 2013 01:30 PM, Hans Verkuil wrote:
> On 12/12/2013 09:35 AM, Archit Taneja wrote:
>> The VPE and VIP IPs in DRA7x contain common scaler and color conversion hardware
>> blocks. We create libraries for these components such that the vpe driver and
>> the vip driver(in future) can use these library funcs to configure the blocks.
>>
>> There are some points for which I would like comments:
>>
>> - For VPE, setting the format and colorspace for the source and destination
>>    queues is enough to determine how these blocks need to be configured and
>>    whether they need to be bypassed or not. So it didn't make sense to represent
>>    them as media controller entities. For VIP(driver not upstream yet), it's
>>    possible that there are multiple data paths which may or may not include these
>>    blocks. However, the current use cases don't require such flexibility. There
>>    may be a need to re-consider a media controller like setup once we work on the
>>    VIP driver. Is it a good idea in terms of user-space compatibilty if we use
>>    media controller framework in the future.
>
> As long as you don't need the mc, then there is no need to implement it.

The thing is that we want to use these blocks for a future capture 
hardware called VIP. A VIP port can capture multiple streams from 
different sensors in time slices, and each of those streams might be 
sharing the same hardware, but probably in different configurations. I'm 
not completely aware of media controller details, and whether it can 
help us here.

I was just wondering if it would be a problem if we later realise that 
mc might be useful for some use cases. Would implementing it then break 
previous user space applications which don't call mc ioctls?


>
>> - These blocks will also require some custom control commands later on. For
>>    example, we may want to tell the scaler later on to perform bi-linear
>>    scaling, or perform peaking at a particular frequency.
>>
>> - The current series keeps the default scaler coefficients in a header file.
>>    These coefficients add a lot of lines of code in the kernel. Does it make more
>>    sense for the user application to pass the co-efficients to the kernel using
>>    an ioctl? Is there any driver which currenlty does this?
>
> I think it is good to keep it in the driver. Otherwise apps would be forced to
> set up the table. It's about 11 kilobyte in memory, which isn't that bad.

Okay.

>
>>
>> The series is based on the branch:
>>
>> git://linuxtv.org/media_tree.git master
>>
>> Archit Taneja (8):
>>    v4l: ti-vpe: create a scaler block library
>>    v4l: ti-vpe: support loading of scaler coefficients
>>    v4l: ti-vpe: make vpe driver load scaler coefficients
>>    v4l: ti-vpe: enable basic scaler support
>>    v4l: ti-vpe: create a color space converter block library
>>    v4l: ti-vpe: Add helper to perform color conversion
>>    v4l: ti-vpe: enable CSC support for VPE
>>    v4l: ti-vpe: Add a type specifier to describe vpdma data format type
>>
>>   drivers/media/platform/ti-vpe/Makefile   |    2 +-
>>   drivers/media/platform/ti-vpe/csc.c      |  196 +++++
>>   drivers/media/platform/ti-vpe/csc.h      |   68 ++
>>   drivers/media/platform/ti-vpe/sc.c       |  311 +++++++
>>   drivers/media/platform/ti-vpe/sc.h       |  208 +++++
>>   drivers/media/platform/ti-vpe/sc_coeff.h | 1342 ++++++++++++++++++++++++++++++
>>   drivers/media/platform/ti-vpe/vpdma.c    |   36 +-
>>   drivers/media/platform/ti-vpe/vpdma.h    |    7 +
>>   drivers/media/platform/ti-vpe/vpe.c      |  251 ++++--
>>   drivers/media/platform/ti-vpe/vpe_regs.h |  187 -----
>>   10 files changed, 2335 insertions(+), 273 deletions(-)
>>   create mode 100644 drivers/media/platform/ti-vpe/csc.c
>>   create mode 100644 drivers/media/platform/ti-vpe/csc.h
>>   create mode 100644 drivers/media/platform/ti-vpe/sc.c
>>   create mode 100644 drivers/media/platform/ti-vpe/sc.h
>>   create mode 100644 drivers/media/platform/ti-vpe/sc_coeff.h
>>
>
> For this patch series:
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks for the review.

Archit
