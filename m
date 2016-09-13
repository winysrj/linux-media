Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35713 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753167AbcIMOqk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 10:46:40 -0400
Received: by mail-wm0-f44.google.com with SMTP id i130so36056526wmf.0
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2016 07:46:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160829182616.GG23577@joana>
References: <20160829070834.22296-11-chris@chris-wilson.co.uk>
 <20160829181613.30722-1-chris@chris-wilson.co.uk> <20160829182616.GG23577@joana>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 13 Sep 2016 20:16:18 +0530
Message-ID: <CAO_48GEPBdGGPCGpJMWMoHQNj8uQMe3JHZd2-Su8pGuQjdu=TA@mail.gmail.com>
Subject: Re: [PATCH] dma-buf/sync-file: Avoid enable fence signaling if poll(.timeout=0)
To: Gustavo Padovan <gustavo@padovan.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On 29 August 2016 at 23:56, Gustavo Padovan <gustavo@padovan.org> wrote:
> Hi Chris,
>
> 2016-08-29 Chris Wilson <chris@chris-wilson.co.uk>:
>
>> If we being polled with a timeout of zero, a nonblocking busy query,
>> we don't need to install any fence callbacks as we will not be waiting.
>> As we only install the callback once, the overhead comes from the atomic
>> bit test that also causes serialisation between threads.
>>
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: Gustavo Padovan <gustavo@padovan.org>
>> Cc: linux-media@vger.kernel.org
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linaro-mm-sig@lists.linaro.org
>> ---
>>  drivers/dma-buf/sync_file.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Indeed, we can shortcut this.
>
> Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
>
> Gustavo

Thanks; pushed to drm-misc.

Best,
Sumit.
