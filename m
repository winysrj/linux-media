Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:35723 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752709AbdHULha (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 07:37:30 -0400
Received: by mail-wr0-f177.google.com with SMTP id k46so21768240wre.2
        for <linux-media@vger.kernel.org>; Mon, 21 Aug 2017 04:37:30 -0700 (PDT)
Subject: Re: [PATCH 1/7 v2] media: vb2: add bidirectional flag in vb2_queue
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20170818141606.4835-2-stanimir.varbanov@linaro.org>
 <CGME20170821090953epcas3p1121178ff7dbd3125a423a807c79ee33b@epcas3p1.samsung.com>
 <20170821090909.32614-1-stanimir.varbanov@linaro.org>
 <de7f1b28-378d-8f4e-17d4-0526f77bd1c9@samsung.com>
 <d68ce072-81ae-bc40-b86c-19f8721505c3@xs4all.nl>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <7122444e-a3e5-2fde-f608-a6b2f87eac29@linaro.org>
Date: Mon, 21 Aug 2017 14:37:27 +0300
MIME-Version: 1.0
In-Reply-To: <d68ce072-81ae-bc40-b86c-19f8721505c3@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/21/2017 01:21 PM, Hans Verkuil wrote:
> On 08/21/2017 11:29 AM, Marek Szyprowski wrote:
>> Hi Stanimir,
>>
>> On 2017-08-21 11:09, Stanimir Varbanov wrote:
>>> This change is intended to give to the v4l2 drivers a choice to
>>> change the default behavior of the v4l2-core DMA mapping direction
>>> from DMA_TO/FROM_DEVICE (depending on the buffer type CAPTURE or
>>> OUTPUT) to DMA_BIDIRECTIONAL during queue_init time.
>>>
>>> Initially the issue with DMA mapping direction has been found in
>>> Venus encoder driver where the hardware (firmware side) adds few
>>> lines padding on bottom of the image buffer, and the consequence
>>> is triggering of IOMMU protection faults.
>>>
>>> This will help supporting venus encoder (and probably other drivers
>>> in the future) which wants to map output type of buffers as
>>> read/write.
>>>
>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>
>> This has been already discussed about a year ago, but it got lost in
>> meantime, probably due to lack of users. I hope that this time it
>> finally will get into vb2.
>>
>> For the reference, see https://patchwork.kernel.org/patch/9388163/
> 
> Interesting.
> 
> Stanimir, I like your implementation better than the macro in the old
> patch. But as it said there, videobuf2-dma-sg/contig/vmalloc.c have references
> to DMA_FROM_DEVICE that won't work with BIDIRECTIONAL, so those need
> to be adapted as well. I missed that when I reviewed your patch :-(
Thanks for catching this, I didn't thought too much about usrptr. Sent v3.

-- 
regards,
Stan
