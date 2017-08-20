Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:38471 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752873AbdHTNNX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 09:13:23 -0400
Received: by mail-qk0-f179.google.com with SMTP id x77so28192804qka.5
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 06:13:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804104155.37386-6-hverkuil@xs4all.nl>
References: <20170804104155.37386-1-hverkuil@xs4all.nl> <20170804104155.37386-6-hverkuil@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Sun, 20 Aug 2017 15:13:22 +0200
Message-ID: <CA+M3ks6NFzMPeebwy0VPb3US-8adXSeD9mmW_4dy=sXRMQtJeA@mail.gmail.com>
Subject: Re: [PATCH 5/5] stm32-cec: use CEC_CAP_DEFAULTS
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-08-04 12:41 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Use the new CEC_CAP_DEFAULTS define in this driver.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

> ---
>  drivers/media/platform/stm32/stm32-cec.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/media/platform/stm32/stm32-cec.c b/drivers/media/platform/stm32/stm32-cec.c
> index 89904096d0a9..ed332a1a39b1 100644
> --- a/drivers/media/platform/stm32/stm32-cec.c
> +++ b/drivers/media/platform/stm32/stm32-cec.c
> @@ -246,9 +246,7 @@ static const struct regmap_config stm32_cec_regmap_cfg = {
>
>  static int stm32_cec_probe(struct platform_device *pdev)
>  {
> -       u32 caps = CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
> -                  CEC_CAP_TRANSMIT | CEC_CAP_RC | CEC_CAP_PHYS_ADDR |
> -                  CEC_MODE_MONITOR_ALL;
> +       u32 caps = CEC_CAP_DEFAULTS | CEC_CAP_PHYS_ADDR | CEC_MODE_MONITOR_ALL;
>         struct resource *res;
>         struct stm32_cec *cec;
>         void __iomem *mmio;
> --
> 2.13.2
>
