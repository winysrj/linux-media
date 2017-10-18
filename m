Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:50637 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759341AbdJRIfP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 04:35:15 -0400
Received: by mail-wm0-f51.google.com with SMTP id u138so8432726wmu.5
        for <linux-media@vger.kernel.org>; Wed, 18 Oct 2017 01:35:15 -0700 (PDT)
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
 <1507650010.2784.11.camel@ndufresne.ca>
 <20171015204014.2awhhygw6hi3lxas@valkosipuli.retiisi.org.uk>
 <1508108964.4502.6.camel@ndufresne.ca>
 <20171017101420.5a5cvyhkadmcqgfy@valkosipuli.retiisi.org.uk>
 <1508249953.19297.4.camel@ndufresne.ca>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <8f1eda59-fc51-b77e-ae43-9603b5759b14@linaro.org>
Date: Wed, 18 Oct 2017 11:34:58 +0300
MIME-Version: 1.0
In-Reply-To: <1508249953.19297.4.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/17/2017 05:19 PM, Nicolas Dufresne wrote:
> Le mardi 17 octobre 2017 à 13:14 +0300, Sakari Ailus a écrit :
>> On Sun, Oct 15, 2017 at 07:09:24PM -0400, Nicolas Dufresne wrote:
>>> Le dimanche 15 octobre 2017 à 23:40 +0300, Sakari Ailus a écrit :
>>>> Hi Nicolas,
>>>>
>>>> On Tue, Oct 10, 2017 at 11:40:10AM -0400, Nicolas Dufresne wrote:
>>>>> Le mardi 29 août 2017 à 14:26 +0300, Stanimir Varbanov a écrit :
>>>>>> Currently videobuf2-dma-sg checks for dma direction for
>>>>>> every single page and videobuf2-dc lacks any dma direction
>>>>>> checks and calls set_page_dirty_lock unconditionally.
>>>>>>
>>>>>> Thus unify and align the invocations of set_page_dirty_lock
>>>>>> for videobuf2-dc, videobuf2-sg  memory allocators with
>>>>>> videobuf2-vmalloc, i.e. the pattern used in vmalloc has been
>>>>>> copied to dc and dma-sg.
>>>>>
>>>>> Just before we go too far in "doing like vmalloc", I would like to
>>>>> share this small video that display coherency issues when rendering
>>>>> vmalloc backed DMABuf over various KMS/DRM driver. I can reproduce
>>>>> this
>>>>> easily with Intel and MSM display drivers using UVC or Vivid as
>>>>> source.
>>>>>
>>>>> The following is an HDMI capture of the following GStreamer
>>>>> pipeline
>>>>> running on Dragonboard 410c.
>>>>>
>>>>>     gst-launch-1.0 -v v4l2src device=/dev/video2 ! video/x-
>>>>> raw,format=NV16,width=1280,height=720 ! kmssink
>>>>>     https://people.collabora.com/~nicolas/vmalloc-issue.mov
>>>>>
>>>>> Feedback on this issue would be more then welcome. It's not clear
>>>>> to me
>>>>> who's bug is this (v4l2, drm or iommu). The software is unlikely to
>>>>> be
>>>>> blamed as this same pipeline works fine with non-vmalloc based
>>>>> sources.
>>>>
>>>> Could you elaborate this a little bit more? Which Intel CPU do you
>>>> have
>>>> there?
>>>
>>> I have tested with Skylake and Ivy Bridge and on Dragonboard 410c
>>> (Qualcomm APQ8016 SoC) (same visual artefact)
>>
>> I presume kmssink draws on the display. Which GPU did you use?
> 
> In order, GPU will be Iris Pro 580, Intel® Ivybridge Mobile and an
> Adreno (3x ?). Why does it matter ? I'm pretty sure the GPU is not used
> on the DB410c for this use case.

Nicolas, for me this looks like a problem in v4l2. In the case of vivid
the stats overlay (where the coherency issues are observed, and most
probably the issue will be observed on the whole image but fortunately
it is a static image pattern) are filled by the CPU but I cannot see
where the cache is flushed. Also I'm wondering why .finish method is
missing for dma-vmalloc mem_ops.

To be sure that the problem is in vmalloc v4l2 allocator, could you
change the allocator to dma-contig, there is a module param for that
called 'allocators'.


-- 
regards,
Stan
