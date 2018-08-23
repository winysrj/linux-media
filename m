Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua1-f68.google.com ([209.85.222.68]:34490 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbeHWXqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 19:46:24 -0400
MIME-Version: 1.0
References: <20180817095425.2630974-1-arnd@arndb.de>
In-Reply-To: <20180817095425.2630974-1-arnd@arndb.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 23 Aug 2018 22:14:54 +0200
Message-ID: <CAMuHMdVLRRjoA-6jfLfO9g+nkN7RyVahFiTe_T=rSEEmCPCBpA@mail.gmail.com>
Subject: Re: [PATCH] media: camss: mark PM functions as __maybe_unused
To: Arnd Bergmann <arnd@arndb.de>
Cc: Todor Tomov <todor.tomov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        hansverk@cisco.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 17, 2018 at 11:54 AM Arnd Bergmann <arnd@arndb.de> wrote:
> The empty suspend/resume functions cause a build warning
> when they are unused:
>
> drivers/media/platform/qcom/camss/camss.c:1001:12: error: 'camss_runtime_resume' defined but not used [-Werror=unused-function]
> drivers/media/platform/qcom/camss/camss.c:996:12: error: 'camss_runtime_suspend' defined but not used [-Werror=unused-function]
>
> Mark them as __maybe_unused so the compiler can silently drop them.
>
> Fixes: 02afa816dbbf ("media: camss: Add basic runtime PM support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
