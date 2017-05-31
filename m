Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13571 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdEaLBD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 07:01:03 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OQT0091ND9E4I60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 May 2017 12:00:50 +0100 (BST)
Subject: Re: [ANN] HDMI CEC Status Update
To: Andrzej Hajda <a.hajda@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <3669c1d6-5348-1a20-6c17-6467819350a0@samsung.com>
Date: Wed, 31 May 2017 13:00:47 +0200
MIME-version: 1.0
In-reply-to: <8bc3a64a-15cb-c2f1-584b-7e8c64df887c@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20170530065337epcas2p4a0a30d4766fe94cc506536a46c6173cd@epcas2p4.samsung.com>
 <8e277103-8bc5-34b2-411d-e396665df249@xs4all.nl>
 <8bc3a64a-15cb-c2f1-584b-7e8c64df887c@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej and Hans,

On 2017-05-31 10:12, Andrzej Hajda wrote:
> On 30.05.2017 08:53, Hans Verkuil wrote:
>> For those who are interested in HDMI CEC support I made a little status
>> document that I intend to keep up to date:
>>
>> https://hverkuil.home.xs4all.nl/cec-status.txt
>>
>> My goal is to get CEC supported for any mainlined HDMI driver where the hardware
>> supports CEC.
>>
>> If anyone is working on a CEC driver that I don't know already about, just drop
>> me an email so I can update the status.
> Sii8620 HDMI->MHL bridge is on my TODO list.
> Regarding Exynos5 it is apparently the same IP as in Exynos4.

I've just posted a patch enabling CEC module on Exynos5250 (Google Snow)
and Exynos5422 (Odroid XU3).

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
