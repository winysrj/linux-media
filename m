Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:40978 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933995AbdKQHLU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 02:11:20 -0500
Received: by mail-io0-f195.google.com with SMTP id g73so7799899ioj.8
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 23:11:20 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC v5 08/11] [media] vb2: add videobuf2 dma-buf fence helpers
Date: Fri, 17 Nov 2017 16:11:14 +0900
MIME-Version: 1.0
Message-ID: <71b364e6-967b-4ede-adcc-2c5d4e70af8e@chromium.org>
In-Reply-To: <a5b0e0e6-4912-4aec-ac6f-f7744a856d3d@chromium.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-9-gustavo@padovan.org>
 <a5b0e0e6-4912-4aec-ac6f-f7744a856d3d@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 17, 2017 4:02:56 PM JST, Alexandre Courbot wrote:
> On Thursday, November 16, 2017 2:10:54 AM JST, Gustavo Padovan wrote:
>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>> 
>> Add a videobuf2-fence.h header file that contains different helpers
>> for DMA buffer sharing explicit fence support in videobuf2.
>> 
>> v2:	- use fence context provided by the caller in vb2_fence_alloc()
>> 
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com> ...
>
> It is probably not a good idea to define that struct here since it will be
> deduplicated for every source file that includes it.
>
> Maybe change it to a simple declaration, and move the definition to
> videobuf2-core.c or a dedicated videobuf2-fence.c file?
>
>> +
>> +static inline struct dma_fence *vb2_fence_alloc(u64 context)
>> +{
>> +	struct dma_fence *vb2_fence = kzalloc(sizeof(*vb2_fence), GFP_KERNEL);
>> + ...
>
> Not sure we gain a lot by having this function static inline, but your call.
>

Looking at the following patch, since it seems that this function is only 
to be
called from vb2_setup_out_fence() anyway, you may as well make it static in
videobuf2-core.c or even inline it in vb2_setup_out_fence() - it would only
add a few extra lines to this function.
