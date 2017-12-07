Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34828 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdLGKKV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 05:10:21 -0500
Received: by mail-wr0-f195.google.com with SMTP id g53so6855881wra.2
        for <linux-media@vger.kernel.org>; Thu, 07 Dec 2017 02:10:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171205145107.17785-1-benjamin.gaignard@st.com>
References: <20171205145107.17785-1-benjamin.gaignard@st.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Thu, 7 Dec 2017 11:09:39 +0100
Message-ID: <CAOFm3uHXhH-zuyi+L5zVzPW_vgZPHVoZZ+8WWo+eyD3dXOpxMg@mail.gmail.com>
Subject: Re: [PATCH] media: platform: stm32: Adopt SPDX identifier
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Yannick FERTRE <yannick.fertre@st.com>, hugues.fruchet@st.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 5, 2017 at 3:51 PM, Benjamin Gaignard
<benjamin.gaignard@linaro.org> wrote:
> Add SPDX identifiers to files under stm32 directory
>
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  drivers/media/platform/stm32/stm32-cec.c  | 5 +----
>  drivers/media/platform/stm32/stm32-dcmi.c | 2 +-
>  2 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/platform/stm32/stm32-cec.c b/drivers/media/platform/stm32/stm32-cec.c
> index 0e5aa17bdd40..7c496bc1cf38 100644
> --- a/drivers/media/platform/stm32/stm32-cec.c
> +++ b/drivers/media/platform/stm32/stm32-cec.c
> @@ -1,11 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * STM32 CEC driver
>   * Copyright (C) STMicroelectronics SA 2017
>   *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>
>  #include <linux/clk.h>
> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
> index ac4c450a6c7d..519952bec6d5 100644
> --- a/drivers/media/platform/stm32/stm32-dcmi.c
> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Driver for STM32 Digital Camera Memory Interface
>   *
> @@ -5,7 +6,6 @@
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
>   *          for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   *
>   * This driver is based on atmel_isi.c
>   *
> --
> 2.15.0
>

Thank you for using the simpler SPDX license ids!

Acked-by: Philippe Ombredanne <pombredanne@nexb.com>

-- 
Cordially
Philippe Ombredanne
