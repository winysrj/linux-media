Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38850 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbeDEVfH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 17:35:07 -0400
Received: by mail-qt0-f195.google.com with SMTP id z23so27854196qti.5
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 14:35:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <24a526280e4eb319147908ccab786e2ebc8f8076.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com> <24a526280e4eb319147908ccab786e2ebc8f8076.1522949748.git.mchehab@s-opensource.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 5 Apr 2018 23:35:06 +0200
Message-ID: <CAK8P3a1a7r1FNhpRHJfyzRNHgNHOzcK1wkerYb+BR_RjWNkOUQ@mail.gmail.com>
Subject: Re: [PATCH 05/16] media: fsl-viu: allow building it with COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 5, 2018 at 7:54 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> There aren't many things that would be needed to allow it
> to build with compile test.

> +/* Allow building this driver with COMPILE_TEST */
> +#ifndef CONFIG_PPC_MPC512x
> +#define NO_IRQ   0

The NO_IRQ usage here really needs to die. The portable way to do this
is the simpler

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 200c47c69a75..707bda89b4f7 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1407,7 +1407,7 @@ static int viu_of_probe(struct platform_device *op)
        }

        viu_irq = irq_of_parse_and_map(op->dev.of_node, 0);
-       if (viu_irq == NO_IRQ) {
+       if (!viu_irq) {
                dev_err(&op->dev, "Error while mapping the irq\n");
                return -EINVAL;
        }

> +#define out_be32(v, a) writel(a, v)
> +#define in_be32(a) readl(a)

This does get it to compile, but looks confusing because it mixes up the
endianess. I'd suggest doing it like

#ifndef CONFIG_PPC
#define out_be32(v, a) iowrite32be(a, v)
#define in_be32(a) ioread32be(a)
#endif

      Arnd
