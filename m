Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:60069 "EHLO
        pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1437424AbdDZKNg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 06:13:36 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by pegasos-out.vodafone.de (Rohrpostix1  Daemon) with ESMTP id 44059261F73
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 12:13:33 +0200 (CEST)
Received: from pegasos-out.vodafone.de ([127.0.0.1])
        by localhost (rohrpostix1.prod.vfnet.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jxS6oLvC862n for <linux-media@vger.kernel.org>;
        Wed, 26 Apr 2017 12:13:31 +0200 (CEST)
Subject: Re: [PATCH] dma-buf: avoid scheduling on fence status query
To: Dave Airlie <airlied@gmail.com>
References: <20170426013632.4716-1-andresx7@gmail.com>
 <d555eb6a-e975-b025-6ed0-c458b1c71f34@gmail.com>
 <6a3b44f0-bc9f-462c-9b0f-96ae15712b8b@vodafone.de>
 <CAPM=9tzmBifbmh8zdMAZwv+vxT5WNLQAHqzACe1Sx63F-LUWLQ@mail.gmail.com>
Cc: Andres Rodriguez <andresx7@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <a280488c-8bf0-f0c8-fff4-9f89462ebe34@vodafone.de>
Date: Wed, 26 Apr 2017 12:13:29 +0200
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzmBifbmh8zdMAZwv+vxT5WNLQAHqzACe1Sx63F-LUWLQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 26.04.2017 um 11:59 schrieb Dave Airlie:
> On 26 April 2017 at 17:20, Christian König <deathsimple@vodafone.de> wrote:
>> NAK, I'm wondering how often I have to reject that change. We should
>> probably add a comment here.
>>
>> Even with a zero timeout we still need to enable signaling, otherwise some
>> fence will never signal if userspace just polls on them.
>>
>> If a caller is only interested in the fence status without enabling the
>> signaling it should call dma_fence_is_signaled() instead.
> Can we not move the return 0 (with spin unlock) down after we enabling
> signalling, but before
> we enter the schedule_timeout(1)?

Yes, that would be an option.

Christian.

>
> Dave.
