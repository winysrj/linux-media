Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:36763 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdFHPRv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 11:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <1496916298-5909-4-git-send-email-binoy.jayan@linaro.org>
References: <1496916298-5909-1-git-send-email-binoy.jayan@linaro.org> <1496916298-5909-4-git-send-email-binoy.jayan@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 8 Jun 2017 17:17:50 +0200
Message-ID: <CAK8P3a1Shy20oxG-jCe=FzeXGWCwZb7z6sA2fCC0-yQ8_AM75w@mail.gmail.com>
Subject: Re: [PATCH 3/3] media: ngene: Replace semaphore i2c_switch_mutex with mutex
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
> The semaphore 'i2c_switch_mutex' is used as a simple mutex, so
> it should be written as one. Semaphores are going away in the future.
>
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>

This one is obviously correct,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
