Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662EDC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 18:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3422921738
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 18:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8M0N5lj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfBSSlx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 13:41:53 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37100 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbfBSSlx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 13:41:53 -0500
Received: by mail-pg1-f193.google.com with SMTP id q206so10537914pgq.4
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 10:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9s69XlhG+rRUIrkn6yxaGUkhCuvBhy94WZ4hm4ODnMw=;
        b=R8M0N5ljrUrduztIOfzNDe0GzE6DUxoJ3taB6rypmsfHTLmG5tK+IpRZPUq6b1+yvJ
         zylQBL8LnaYzsaX30zoAzz3oxogj+4ogVB8oe+fYkndJS4z1giI+9Y40qO6PJFVuoqX+
         xu+oNl2ZkV/r9pYzWOpfepVW2WBg1AINKEL5E6CEMom007Z30IB8kXb1+MFIwKN8xX2g
         Fm3k5qqm87KmGblenCfuZM9nM9Jdx3pihLyMKzWPb33O0qD9Q8mDdwSxR6PN41oOwxXI
         AxcpgM03kym/PUlDem2VSwgrwCHB8Rw07xsQc14atpaZj9A4ceVkY+etkRfm+ZvoeL4+
         Tg7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9s69XlhG+rRUIrkn6yxaGUkhCuvBhy94WZ4hm4ODnMw=;
        b=nSp2DRYfvxq1VYjQ9Ij1DTcTNASBgbJ2iNbVmpmOcl827Bs0xHGC30jUAQFI2sZ7De
         2AzL+UuzNewtNZVW/4O3UcfwnMvlv44WGkUVs9u7KWLeXZBCVBPa0NWbBJsii4U48nLl
         LpcA9d0ob95RikrFubRV1612Ebb6YPiJYWvQ4ukTMDTXkQSqR9E9oFXoPnYeHlSow/ip
         Xk/U59yt7BrTnjDJjC00GfTeEEcy2DWUVZL54Ml/CsjVjFNeqXxQJ+OGq3UT0Ut7T3qL
         v0sxA8TwIPmri5ipDAAVEplx08H9sZP+1NNVeDfK22eOEtXlkbQYO7STSkQcBNYIn/Za
         qf0w==
X-Gm-Message-State: AHQUAubxL/fp/RzOoIfRqFUnGt2jNK4jvzvJr4dCsk6qup0s1NNFl7dY
        uFJrQx7V2MN6aUVhhGhMorJKMsg41wQcLs7ZPdfMJg==
X-Google-Smtp-Source: AHgI3Ib5rMiouOq5fatIVAbVX7DtWdoUPhO1ZfJIiBUm1lwEw7GjTKuYJ+06U6AxqQBlrF9bDZeXuYZb8PYkjEV+8jU=
X-Received: by 2002:a63:fe58:: with SMTP id x24mr25325202pgj.255.1550601712051;
 Tue, 19 Feb 2019 10:41:52 -0800 (PST)
MIME-Version: 1.0
References: <20190219170209.4180739-1-arnd@arndb.de>
In-Reply-To: <20190219170209.4180739-1-arnd@arndb.de>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 19 Feb 2019 10:41:40 -0800
Message-ID: <CAKwvOdn0hF0s7-O2X98TSgO0C685ktZPTXRQ7CeR5vKHVZktPQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: saa7146: avoid high stack usage with clang
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 19, 2019 at 9:02 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Two saa7146/hexium files contain a construct that causes a warning
> when built with clang:
>
> drivers/media/pci/saa7146/hexium_orion.c:210:12: error: stack frame size of 2272 bytes in function 'hexium_probe'
>       [-Werror,-Wframe-larger-than=]
> static int hexium_probe(struct saa7146_dev *dev)
>            ^
> drivers/media/pci/saa7146/hexium_gemini.c:257:12: error: stack frame size of 2304 bytes in function 'hexium_attach'
>       [-Werror,-Wframe-larger-than=]
> static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
>            ^
>
> This one happens regardless of KASAN, and the problem is that a
> constructor to initalize a dynamically allocated structure leads
> to a copy of that structure on the stack, whereas gcc initializes
> it in place.
>
> Link: https://bugs.llvm.org/show_bug.cgi?id=40776

oof, great bug report by the way!  Thanks for the fix.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/pci/saa7146/hexium_gemini.c | 4 +---
>  drivers/media/pci/saa7146/hexium_orion.c  | 4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
> index 5817d9cde4d0..f7ce0e1770bf 100644
> --- a/drivers/media/pci/saa7146/hexium_gemini.c
> +++ b/drivers/media/pci/saa7146/hexium_gemini.c
> @@ -270,9 +270,7 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
>         /* enable i2c-port pins */
>         saa7146_write(dev, MC1, (MASK_08 | MASK_24 | MASK_10 | MASK_26));
>
> -       hexium->i2c_adapter = (struct i2c_adapter) {
> -               .name = "hexium gemini",
> -       };
> +       strscpy(hexium->i2c_adapter.name, "hexium gemini", sizeof(hexium->i2c_adapter.name));
>         saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
>         if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
>                 DEB_S("cannot register i2c-device. skipping.\n");
> diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
> index 0a05176c18ab..b9f4a09c744d 100644
> --- a/drivers/media/pci/saa7146/hexium_orion.c
> +++ b/drivers/media/pci/saa7146/hexium_orion.c
> @@ -231,9 +231,7 @@ static int hexium_probe(struct saa7146_dev *dev)
>         saa7146_write(dev, DD1_STREAM_B, 0x00000000);
>         saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
>
> -       hexium->i2c_adapter = (struct i2c_adapter) {
> -               .name = "hexium orion",
> -       };
> +       strscpy(hexium->i2c_adapter.name, "hexium orion", sizeof(hexium->i2c_adapter.name));

Note that "sparse" designated initialization zero initializes unnnamed members:
https://godbolt.org/z/LkSpJp
This transform you've done is safe because hexium was zero initialized
via kzalloc, and struct hexium contains a struct i2c_adapter (as
opposed to  a pointer to a struct i2c_adapter).  The same is true for
both translation units you've touched. LGTM

>         saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
>         if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
>                 DEB_S("cannot register i2c-device. skipping.\n");
> --
> 2.20.0
>


-- 
Thanks,
~Nick Desaulniers
