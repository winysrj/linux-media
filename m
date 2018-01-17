Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36829 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753000AbeAQM6S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 07:58:18 -0500
MIME-Version: 1.0
In-Reply-To: <1516188292-144008-1-git-send-email-weiyongjun1@huawei.com>
References: <1516188292-144008-1-git-send-email-weiyongjun1@huawei.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 17 Jan 2018 13:58:17 +0100
Message-ID: <CAMuHMdVopOB3ohSzTzTsf9m04uTDm977Wh2EWa5z5MCDwzrgJQ@mail.gmail.com>
Subject: Re: [PATCH -next] media: rcar_drif: fix error return code in rcar_drif_alloc_dmachannels()
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 17, 2018 at 12:24 PM, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> Fix to return error code -ENODEV from the dma_request_slave_channel()
> error handling case instead of 0, as done elsewhere in this function.
> rc can be overwrite to 0 by dmaengine_slave_config() in the for loop.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
