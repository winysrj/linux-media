Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34693 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbcEPXK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 19:10:26 -0400
MIME-Version: 1.0
In-Reply-To: <1462806459-8124-4-git-send-email-benjamin.gaignard@linaro.org>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
	<1462806459-8124-4-git-send-email-benjamin.gaignard@linaro.org>
Date: Tue, 17 May 2016 00:10:24 +0100
Message-ID: <CACvgo50i0Y=TJNCvX+c2m8u8ai2p30EbaU1u3xBmQYBZGWH5UA@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] SMAF: add fake secure module
From: Emil Velikov <emil.l.velikov@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: linux-media@vger.kernel.org,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	zoltan.kuscsik@linaro.org, Sumit Semwal <sumit.semwal@linaro.org>,
	cc.ma@mediatek.com, pascal.brand@linaro.org,
	joakim.bech@linaro.org, dan.caprita@windriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin,

On 9 May 2016 at 16:07, Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:
> This module is allow testing secure calls of SMAF.
>
"Add fake secure module" does sound like something not (m)any people
want to hear ;-)
Have you considered calling it 'dummy', 'test' or similar ?


> --- /dev/null
> +++ b/drivers/smaf/smaf-fakesecure.c
> @@ -0,0 +1,85 @@
> +/*
> + * smaf-fakesecure.c
> + *
> + * Copyright (C) Linaro SA 2015
> + * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/smaf-secure.h>
> +
> +#define MAGIC 0xDEADBEEF
> +
> +struct fake_private {
> +       int magic;
> +};
> +
> +static void *smaf_fakesecure_create(void)
> +{
> +       struct fake_private *priv;
> +
> +       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
Missing ENOMEM handling ?

> +       priv->magic = MAGIC;
> +
> +       return priv;
> +}
> +
> +static int smaf_fakesecure_destroy(void *ctx)
> +{
> +       struct fake_private *priv = (struct fake_private *)ctx;
You might want to flesh this cast into a (inline) helper and use it throughout ?


... and that is all. Hope these were useful, or at the very least not
utterly wrong, suggestions :-)


Regards,
Emil

P.S. From a quick look userspace has some subtle bugs/odd practises.
Let me know if you're interested in my input.
