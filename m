Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4A7C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 09:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D3EC20863
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 09:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKhqcOJL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfCZJqo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:46:44 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39616 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfCZJqo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 05:46:44 -0400
Received: by mail-ot1-f65.google.com with SMTP id f10so10847158otb.6;
        Tue, 26 Mar 2019 02:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ExQZt6khEROpA+UJnSeDW8GgVSZjdIx0gAHlWkmYf08=;
        b=OKhqcOJL6irW2bP84OwfnGGWb21pFdJp/i77Fp+vFCI6wAxJf4PnL3375r/sl+i9t4
         IlcAlhRF2Q6rnf0DaX7n9Ya3Epvw/MvSUG1/y0MDVk3fGbr0en0iaTzmdk8NRZ3n9WVS
         MrHG59isWowzhbQXx+gvzVwK0XkspMGom5jmyM6L37MmyK6IEsAnRpohJ4mXgm+siIPJ
         WeugeOVzAtbgUoXlBpP3OBsKSkdLfkviTk0fXDBCF3OUju1gihchPtx6p9saBatqcuqF
         wV7HNpQ04tChfQBB9hAm7GRo7dINTREZ4eqR6FEy+k1Tbt5OqwWRKBwEVe7ZEznoZto6
         ooRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ExQZt6khEROpA+UJnSeDW8GgVSZjdIx0gAHlWkmYf08=;
        b=OQU8W05Cn0TAxvdCTMhRuR9tHbxj+fZhhc2SDr6GHqmgxK/x9/UR2u8YMSLPXWD9Rs
         IPrSm9eDSeWVyylW/z/Op13bZOkq6kkn83iJd4s4qOc3Gs8P1r2oYA4VPXjeK9HqxPji
         SuIBcAdkpGRiM3hYzUwj7iIEU0bfilP40Fz0v4cQ+ilMGTeCydiwt2kCu4+vyeGr5Tak
         tidtUrgN33Q2YxQJN8Gl0X0qdvQeSJZZWMMP54BOrOS+Wb+OJZ3hGOmvq6qgkx1waKta
         5HWX4cd9bw6TDx//tkuqEhSVpOlJuDr1xKg8OgXtaYN7FFtItGGomvw4BSVyj1X6VcAS
         BfEw==
X-Gm-Message-State: APjAAAU1tFFDQOeJMYVnFUvvPbqsiieh/qO8+obR96vspbZ/UQa1+VZI
        XurH0YCBERtGi0d1cfA4yovI1u1YtVyOiGBOdRPlT2QB
X-Google-Smtp-Source: APXvYqz1hv0r09HYO3MpV9+1n+7htW0wQLJTj3BaGXyfmryo6gpzv/MqEX1lXdJSjYDy0Q9p9JJP4RyANJZe7HFWhrE=
X-Received: by 2002:a9d:ef4:: with SMTP id 107mr21749842otj.152.1553593603332;
 Tue, 26 Mar 2019 02:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190323025106.15865-1-kjlu@umn.edu>
In-Reply-To: <20190323025106.15865-1-kjlu@umn.edu>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 26 Mar 2019 09:46:16 +0000
Message-ID: <CA+V-a8tQMOjoWeBr==KW_7waQHMqG7x4FCVqMkVr3Hjy9cZe5A@mail.gmail.com>
Subject: Re: [PATCH] media: vpss: fix a potential NULL pointer dereference
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kangjie,

Thanks for the patch.

On Sat, Mar 23, 2019 at 2:51 AM Kangjie Lu <kjlu@umn.edu> wrote:
>
> In case ioremap fails, the fix returns -ENOMEM to avoid NULL
> pointer dereference.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/platform/davinci/vpss.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
> index 19cf6853411e..89a86c19579b 100644
> --- a/drivers/media/platform/davinci/vpss.c
> +++ b/drivers/media/platform/davinci/vpss.c
> @@ -518,6 +518,11 @@ static int __init vpss_init(void)
>                 return -EBUSY;
>
>         oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
> +       if (unlikely(!oper_cfg.vpss_regs_base2)) {
> +               release_mem_region(VPSS_CLK_CTRL, 4);
> +               return -ENOMEM;
> +       }
> +
>         writel(VPSS_CLK_CTRL_VENCCLKEN |
>                      VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
>
> --
> 2.17.1
>
