Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33235 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037598AbdDZJ7M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 05:59:12 -0400
Received: by mail-ua0-f172.google.com with SMTP id j59so102816540uad.0
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 02:59:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6a3b44f0-bc9f-462c-9b0f-96ae15712b8b@vodafone.de>
References: <20170426013632.4716-1-andresx7@gmail.com> <d555eb6a-e975-b025-6ed0-c458b1c71f34@gmail.com>
 <6a3b44f0-bc9f-462c-9b0f-96ae15712b8b@vodafone.de>
From: Dave Airlie <airlied@gmail.com>
Date: Wed, 26 Apr 2017 19:59:05 +1000
Message-ID: <CAPM=9tzmBifbmh8zdMAZwv+vxT5WNLQAHqzACe1Sx63F-LUWLQ@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: avoid scheduling on fence status query
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: Andres Rodriguez <andresx7@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 April 2017 at 17:20, Christian K=C3=B6nig <deathsimple@vodafone.de> w=
rote:
> NAK, I'm wondering how often I have to reject that change. We should
> probably add a comment here.
>
> Even with a zero timeout we still need to enable signaling, otherwise som=
e
> fence will never signal if userspace just polls on them.
>
> If a caller is only interested in the fence status without enabling the
> signaling it should call dma_fence_is_signaled() instead.

Can we not move the return 0 (with spin unlock) down after we enabling
signalling, but before
we enter the schedule_timeout(1)?

Dave.
