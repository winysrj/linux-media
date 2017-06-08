Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33845 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdFHPTQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 11:19:16 -0400
MIME-Version: 1.0
In-Reply-To: <1496916298-5909-3-git-send-email-binoy.jayan@linaro.org>
References: <1496916298-5909-1-git-send-email-binoy.jayan@linaro.org> <1496916298-5909-3-git-send-email-binoy.jayan@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 8 Jun 2017 17:19:15 +0200
Message-ID: <CAK8P3a1x1VuNkvjkHM-e7b8pZ=A2W0iadUnSXTX=Z5cOTsV6+g@mail.gmail.com>
Subject: Re: [PATCH 2/3] media: ngene: Replace semaphore stream_mutex with mutex
To: Binoy Jayan <binoy.jayan@linaro.org>
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

On Thu, Jun 8, 2017 at 12:04 PM, Binoy Jayan <binoy.jayan@linaro.org> wrote:
> The semaphore 'stream_mutex' is used as a simple mutex, so
> it should be written as one. Semaphores are going away in the future.
>
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> ---

Looks correct, though I wonder whether it would be nicer to move the
mutex_lock/unlock() to the caller to avoid repeating the unlock() five
times.

Either way,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
