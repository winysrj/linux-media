Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34133 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751859AbdFMI6s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 04:58:48 -0400
Received: by mail-ua0-f169.google.com with SMTP id m31so71332717uam.1
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 01:58:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK8P3a24uKE4wYTO123boOfs1pHzgjAjEc8imZT=J03Hsk=rcg@mail.gmail.com>
References: <1496916298-5909-1-git-send-email-binoy.jayan@linaro.org>
 <1496916298-5909-2-git-send-email-binoy.jayan@linaro.org> <CAK8P3a2huLuzaaHh-hw4S1pRa0BTPEywvp3Kw134j_dm8Lns6g@mail.gmail.com>
 <CAHv-k_-AKvXqXVhxGKLr0R_UW6Tdc_4gm9DxcLXVamNhOrF9UQ@mail.gmail.com> <CAK8P3a24uKE4wYTO123boOfs1pHzgjAjEc8imZT=J03Hsk=rcg@mail.gmail.com>
From: Binoy Jayan <binoy.jayan@linaro.org>
Date: Tue, 13 Jun 2017 14:28:47 +0530
Message-ID: <CAHv-k_-G59wScnVqH_RdF9d-CPdDZV1-b+iABYDet62i9ZZugA@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: ngene: Replace semaphore cmd_mutex with mutex
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rajendra <rnayak@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cao jin <caoj.fnst@cn.fujitsu.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 9 June 2017 at 16:06, Arnd Bergmann <arnd@arndb.de> wrote:

>> Thank you for pointing out that. I'll check the
>> concurrency part. By the way why do we need mutex_destoy?
>> To debug an aberrate condition?
>
> At first I suspected the down() here was added for the same
> purpose as a mutex_destroy: to ensure that we are in a sane
> state before we free the device structure, but the way they
> achieve that is completely different.
>
> However, if there is any way that a command may still be in
> progress by the time we get to ngene_stop(), we may also
> be lacking reference counting on the ngene structure here.
> So far I haven't found any of those, and think the mutex_destroy()
> is sufficient here as a debugging help.

I've made the necessary changes. Thank you for reviewing all the patches.

Regards,
Binoy
