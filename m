Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38319 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbeHNPqR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 11:46:17 -0400
MIME-Version: 1.0
References: <20180814091636.1960071-1-arnd@arndb.de> <565437f4-e01a-4558-ccc1-4f312e26cf35@linaro.org>
In-Reply-To: <565437f4-e01a-4558-ccc1-4f312e26cf35@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 14 Aug 2018 14:58:55 +0200
Message-ID: <CAK8P3a2swXMsOnOv_Oow6TCShna4LLfm=uuNmvKk+O2GTZMr+A@mail.gmail.com>
Subject: Re: [PATCH] [v2] media: camss: add missing includes
To: todor.tomov@linaro.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, hansverk@cisco.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 14, 2018 at 2:45 PM Todor Tomov <todor.tomov@linaro.org> wrote:
>
> Hi Arnd,
>
> On 14.08.2018 12:13, Arnd Bergmann wrote:
> > Multiple files in this driver fail to build because of missing
> > header inclusions:
> >
> > drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c: In function 'csiphy_hw_version_read':
> > drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c:31:18: error: implicit declaration of function 'readl_relaxed'; did you mean 'xchg_relaxed'? [-Werror=implicit-function-declaration]
> > drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c: In function 'csiphy_hw_version_read':
> > drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c:52:2: error: implicit declaration of function 'writel' [-Werror=implicit-function-declaration]
>
> Thank you for noticing this and preparing a patch.
> I build for arm64 and x86_64 with compile test enabled and I don't see these errors. Do you have a guess what is different that I don't have them?

I try lots of randconfig builds, and only one of them hit this, so
it's surely some
header that may or may not include io.h and slab.h depending on the
configuration,
or based on some other changes in linux-next.

Since the solution seemed obvious, I did not investigate further.

If you want to try reproducing the problem, see the arm64 config file
at https://pastebin.com/raw/bNTPvYfZ

     Arnd
