Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35298 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbcITMxz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 08:53:55 -0400
Received: by mail-lf0-f50.google.com with SMTP id l131so12755983lfl.2
        for <linux-media@vger.kernel.org>; Tue, 20 Sep 2016 05:53:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160920111338.GE13275@joana>
References: <1474202961-10099-1-git-send-email-baoyou.xie@linaro.org> <20160920111338.GE13275@joana>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 20 Sep 2016 18:23:33 +0530
Message-ID: <CAO_48GFTkpvKLZghbOtNu=CUB61tZx0q6uC1JPVRMB1rPiSPqA@mail.gmail.com>
Subject: Re: [PATCH] dma-buf/sw_sync: mark sync_timeline_create() static
To: Gustavo Padovan <gustavo@padovan.org>,
        Baoyou Xie <baoyou.xie@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, xie.baoyou@zte.com.cn,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baoyou,

On 20 September 2016 at 16:43, Gustavo Padovan <gustavo@padovan.org> wrote:
> 2016-09-18 Baoyou Xie <baoyou.xie@linaro.org>:
>
>> We get 1 warning when building kernel with W=1:
>> drivers/dma-buf/sw_sync.c:87:23: warning: no previous prototype for 'sync_timeline_create' [-Wmissing-prototypes]
>>
>> In fact, this function is only used in the file in which it is
>> declared and don't need a declaration, but can be made static.
>> So this patch marks it 'static'.
>>
>> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
>> ---
>>  drivers/dma-buf/sw_sync.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Thanks for finding this.

Thanks for the patch; this doesn't apply to mainline yet, since the
de-staging of sw_sync code is queued for 4.9 via Greg-KH's tree.
CC'ing him.

Greg, would it be possible to please take this via your tree?
>
> Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>

> Gustavo
>

Best regards,
Sumi
