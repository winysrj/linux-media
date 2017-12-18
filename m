Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44359 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757971AbdLRITS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 03:19:18 -0500
Subject: Re: [PATCH v2] media: s5p-mfc: Add support for V4L2_MEMORY_DMABUF
 type
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Marian Mihailescu <mihailescu2m@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        JaeChul Lee <jcsing.lee@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <c894f9b6-5381-b7eb-ba77-35e71958bf45@samsung.com>
Date: Mon, 18 Dec 2017 09:19:11 +0100
MIME-version: 1.0
In-reply-to: <e71e9a74-736a-5185-a544-845fff4ff63c@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20171103081132eucas1p2212e32d26e7921340336d78d0d92cb1b@eucas1p2.samsung.com>
        <20171103081124.30119-1-m.szyprowski@samsung.com>
        <1509716721.3607.6.camel@ndufresne.ca>
        <decd38f5-d3c0-6a60-cdbb-20bb804be3a5@samsung.com>
        <1509996082.30233.51.camel@ndufresne.ca>
        <e360971a-cb3b-0546-e621-ab56f8ed8f36@samsung.com>
        <e71e9a74-736a-5185-a544-845fff4ff63c@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2017-12-15 16:57, Hans Verkuil wrote:
> On 14/12/17 15:11, Marek Szyprowski wrote:
>> I would like to get your opinion on this patch. Do you think it makes sense to:
>>
>> 1. add limited support for USERPTR and DMA-buf import? (limited means driver will accept setting buffer pointer/fd only once after reqbufs for each buffer index)
> I don't like this. It's unexpected almost-but-not-quite behavior that will make
> life very difficult for userspace.
>
>> 2. add a V4L2 device flag to let userspace to discover if device support queue buffer reconfiguration on-fly or not?
> This seems to me a better approach. It should be possible to implement most/all of this
> in vb2, but we need to find a way to signal this to the user.

Okay, I will prepare a patch with such flag soon.

> Is this an MFC limitation for the decoder, encoder or both? And is it a limitation
> of the capture or output side or both?

Both and both. DMA addresses of all buffers must be known while 
initializing decoder
and encoder.

 > ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
