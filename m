Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:36837 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdFMKbC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 06:31:02 -0400
Received: by mail-ua0-f171.google.com with SMTP id h39so72653808uaa.3
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 03:31:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1DU4NnaoshK4naU5Z-nqLRpPXhcnisDirF5FeXu5BLYA@mail.gmail.com>
References: <1497344330-13915-1-git-send-email-binoy.jayan@linaro.org> <CAK8P3a1DU4NnaoshK4naU5Z-nqLRpPXhcnisDirF5FeXu5BLYA@mail.gmail.com>
From: Binoy Jayan <binoy.jayan@linaro.org>
Date: Tue, 13 Jun 2017 16:01:01 +0530
Message-ID: <CAHv-k__q3_ztz7eSrTVnjJ2KLba_7NvM=esLLKH-n5xQteuO8g@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ngene: Replace semaphores with mutexes
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

On 13 June 2017 at 15:19, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Jun 13, 2017 at 10:58 AM, Binoy Jayan <binoy.jayan@linaro.org> wrote:
>> These are a set of patches [v2] which removes semaphores from ngene.
>> These are part of a bigger effort to eliminate unwanted semaphores
>> from the linux kernel.
>
> All three
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> I already gave an Ack for one or two of the patches in the first round, but
> you seem to have dropped that. When you resend a patch with an Ack,
> please include that above your Signed-off-by line. (No need to resend
> for an Ack otherwise, this normally gets picked up when the patch
> gets applied from the list.

Sorry I dropped it as there were changes in two of the patches.
But there were obvious ones anyway.

Thanks,
Binoy
