Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34971 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753942AbdHUONb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 10:13:31 -0400
Received: by mail-wr0-f171.google.com with SMTP id k46so25585637wre.2
        for <linux-media@vger.kernel.org>; Mon, 21 Aug 2017 07:13:30 -0700 (PDT)
Subject: Re: [PATCH 1/7 v3] media: vb2: add bidirectional flag in vb2_queue
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20170818141606.4835-2-stanimir.varbanov@linaro.org>
 <CGME20170821113451epcas5p14ba601f0848c8198c269f8da53129595@epcas5p1.samsung.com>
 <20170821113410.17542-1-stanimir.varbanov@linaro.org>
 <9757cfb2-66b3-7c8e-bb60-25b14706fbe9@samsung.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <0137b1b9-1eb1-cff6-0e0e-fed446ccca64@linaro.org>
Date: Mon, 21 Aug 2017 17:13:28 +0300
MIME-Version: 1.0
In-Reply-To: <9757cfb2-66b3-7c8e-bb60-25b14706fbe9@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On 08/21/2017 03:21 PM, Marek Szyprowski wrote:
> Hi Stanimir,
> 
> On 2017-08-21 13:34, Stanimir Varbanov wrote:
>> This change is intended to give to the v4l2 drivers a choice to
>> change the default behavior of the v4l2-core DMA mapping direction
>> from DMA_TO/FROM_DEVICE (depending on the buffer type CAPTURE or
>> OUTPUT) to DMA_BIDIRECTIONAL during queue_init time.
>>
>> Initially the issue with DMA mapping direction has been found in
>> Venus encoder driver where the hardware (firmware side) adds few
>> lines padding on bottom of the image buffer, and the consequence
>> is triggering of IOMMU protection faults.
>>
>> This will help supporting venus encoder (and probably other drivers
>> in the future) which wants to map output type of buffers as
>> read/write.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> 
> Thanks for the patch.
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thanks!

> 
> While touching this, I would love to unify set_page_dirty_lock()
> related code in videobuf2-dc, videobuf2-sg and videobuf2-vmalloc.
> 
> IMHO the pattern used in videobuf2-vmalloc should be copied to
> videobuf2-sg (currently checks for dma_dir for every single page)
> and videobuf2-dc (currently it lacks any checks and calls
> set_page_dirty_lock() unconditionally). If you have a little bit
> of spare time, please prepare a separate patch for the above
> mentioned fix.

Sure, I'll unify set_page_dirty_lock invocations in separate patch.

-- 
regards,
Stan
