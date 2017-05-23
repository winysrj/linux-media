Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:35169 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759945AbdEWXrv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 19:47:51 -0400
Received: by mail-vk0-f67.google.com with SMTP id x71so8362179vkd.2
        for <linux-media@vger.kernel.org>; Tue, 23 May 2017 16:47:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170427212748.GD2568@joana>
References: <20170426144620.3560-1-andresx7@gmail.com> <92c9bc96-cf60-f246-a82e-47653472521e@vodafone.de>
 <20170427212748.GD2568@joana>
From: Dave Airlie <airlied@gmail.com>
Date: Wed, 24 May 2017 09:47:49 +1000
Message-ID: <CAPM=9twvHHDaVsEOJCazWJeNptMb+pFUroq5jc52Tu4Cvg-T0g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: avoid scheduling on fence status
 query v2
To: Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        Andres Rodriguez <andresx7@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28 April 2017 at 07:27, Gustavo Padovan <gustavo@padovan.org> wrote:
> 2017-04-26 Christian K=C3=B6nig <deathsimple@vodafone.de>:
>
>> Am 26.04.2017 um 16:46 schrieb Andres Rodriguez:
>> > When a timeout of zero is specified, the caller is only interested in
>> > the fence status.
>> >
>> > In the current implementation, dma_fence_default_wait will always call
>> > schedule_timeout() at least once for an unsignaled fence. This adds a
>> > significant overhead to a fence status query.
>> >
>> > Avoid this overhead by returning early if a zero timeout is specified.
>> >
>> > v2: move early return after enable_signaling
>> >
>> > Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
>>
>> Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com>
>
> pushed to drm-misc-next. Thanks all.

I don't see this patch in -rc2, where did it end up going?

Dave.
