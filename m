Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:42389 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbeENGpu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 02:45:50 -0400
Received: by mail-wr0-f193.google.com with SMTP id v5-v6so10985808wrf.9
        for <linux-media@vger.kernel.org>; Sun, 13 May 2018 23:45:49 -0700 (PDT)
Subject: Re: [PATCH] [media] gspca: Stop using GFP_DMA for buffers for USB
 bulk transfers
To: Adam Baker <linux@baker-net.org.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <20180505082208.32553-1-hdegoede@redhat.com>
 <2e774de2-eda8-775e-4164-8b48fbadcbd6@baker-net.org.uk>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <46016353-6e2a-5efb-8b26-89a037518f47@redhat.com>
Date: Mon, 14 May 2018 07:45:46 +0100
MIME-Version: 1.0
In-Reply-To: <2e774de2-eda8-775e-4164-8b48fbadcbd6@baker-net.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/13/2018 07:54 PM, Adam Baker wrote:
> On 05/05/18 09:22, Hans de Goede wrote:
>> The recent "x86 ZONE_DMA love" discussion at LSF/MM pointed out that some
>> gspca sub-drivvers are using GFP_DMA to allocate buffers which are used
>> for USB bulk transfers, there is absolutely no need for this, drop it.
>>
> 
> The documentation for kmalloc() says
>    GFP_DMA - Allocation suitable for DMA.
> 
> end at least in sq905.c the allocation is passed to the USB stack that
> then uses it for DMA.
> 
> Looking a bit closer the "suitable for DMA" label that GFP_DMA promises
> is not really a sensible thing for kmalloc() to determine as it is
> dependent on the DMA controller in question. The USB stack now ensures
> that everything works correctly as long as the memory is allocated with
> kmalloc() so acked by me for sq905.c but, is anyone taking care of
> fixing the kmalloc() documentation?

The whole GFP_DMA flag use in the kernel is a mess and fixing the
doucmentation is not easy and likely also not the solution, see:

https://lwn.net/Articles/753273/

Note this article is currently only available to LWN subscribers
(it will become freely available in a week).

I'll send you a private mail with a link which will allow you
to read it.

Regards,

Hans
