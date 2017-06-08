Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:32844 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdFHPKx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 11:10:53 -0400
MIME-Version: 1.0
In-Reply-To: <1496916298-5909-2-git-send-email-binoy.jayan@linaro.org>
References: <1496916298-5909-1-git-send-email-binoy.jayan@linaro.org> <1496916298-5909-2-git-send-email-binoy.jayan@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 8 Jun 2017 17:10:51 +0200
Message-ID: <CAK8P3a2huLuzaaHh-hw4S1pRa0BTPEywvp3Kw134j_dm8Lns6g@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: ngene: Replace semaphore cmd_mutex with mutex
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
> The semaphore 'cmd_mutex' is used as a simple mutex, so
> it should be written as one. Semaphores are going away in the future.
>
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> ---

> @@ -1283,7 +1283,7 @@ static int ngene_load_firm(struct ngene *dev)
>
>  static void ngene_stop(struct ngene *dev)
>  {
> -       down(&dev->cmd_mutex);
> +       mutex_lock(&dev->cmd_mutex);
>         i2c_del_adapter(&(dev->channel[0].i2c_adapter));
>         i2c_del_adapter(&(dev->channel[1].i2c_adapter));
>         ngwritel(0, NGENE_INT_ENABLE);

Are you sure about this one? There is only one mutex_lock() and
then the structure gets freed without a corresponding mutex_unlock().

I suspect this violates some rules of mutexes, either when compile
testing with "make C=1", or when running with lockdep enabled.

Can we actually have a concurrently held mutex at the time we
get here? If not, using mutex_destroy() in place of the down()
may be the right answer.

       Arnd
