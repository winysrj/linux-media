Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03173C4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 10:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5C8B20856
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 10:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sQ/nCCwG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfCZKYO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:24:14 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33869 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfCZKYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 06:24:13 -0400
Received: by mail-ot1-f66.google.com with SMTP id k21so9561457otf.1;
        Tue, 26 Mar 2019 03:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQrEXgdEPLeasmPwHakTZ2jwTQBdItD5Ls859v7sW4U=;
        b=sQ/nCCwG/AOYkAeS2ss6bUed/nbHc4ADdgFNXW6fjGRNAczmNu5HKn9SYiGrg02ltS
         MMzhq8N1KbzbL8eK7kAUuXXZKV6UkUedGxWIdB0049L58ZZzIkiyVrEb2i+sGkdYQurZ
         PxTrsK6cIbEDuUv18r1Wwi7vltDNHTovMf/JDIhOf+EIEZi6hGmeOzeW7e6K0ipiFtaS
         ZamfQsUsfU1oqwd/6N7hgu9NeER64tOsLwFqAYfFkN5vpdqLapl0/QEmJEApdFDDVFDV
         jAiKZ3hrlJZ1prqj2UiUjMnVr6NzjMfYz7oYNqoJ5r8ygwy1JUp5DxcfYTf2PG4OcpfM
         DZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQrEXgdEPLeasmPwHakTZ2jwTQBdItD5Ls859v7sW4U=;
        b=hmAqAFAiSMMQ7wl94E4LwBHr/iZAfbvkBddvPAc7I5wjfCcKzyrTHHWJlo22g15aQM
         UYDSMvhidOCZuWnVVdmBrqjM2JEBlNw1eqY0KuoRE9gnVkCv7SKXqCJk9BvkeognggG0
         QwsDcToF1Kq3SJ9/v0Xdjp4/I08po52zTgyfc9svT1IQ5Ih6x7y6pLtdxvyyKoDhg/qE
         cGbGCuX7nxnhxeVcSmS4NhTkvtnBr6WA1y4ppu2rTuM1KPNC5mGs3HEj8oZJ42fLdblZ
         AM39eOOxgIbZJT8KU+2kMal+GJGw63jl1XXz+T2Y92nir6ijWUStpfuZZzEcCcBOi8JX
         pqBQ==
X-Gm-Message-State: APjAAAUpx1mYtjU0bQKQEhcc1dVf4R3zRZKEcDTJ2FtHLZr9dXK+y/AK
        M97rz6DcIDwXv1LyC4PLxe9hDEw7U0MMCxThj+Q=
X-Google-Smtp-Source: APXvYqwertsZLsDuITLbHRXjCBHttRFdyPHljtmGSNl0Ye3+WjgxOEz266P21JqwBJ07XrUqY8Lo1cAr1BcpiExVXJs=
X-Received: by 2002:a9d:ef4:: with SMTP id 107mr21858530otj.152.1553595852867;
 Tue, 26 Mar 2019 03:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190322143431.1235295-1-arnd@arndb.de>
In-Reply-To: <20190322143431.1235295-1-arnd@arndb.de>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 26 Mar 2019 10:23:46 +0000
Message-ID: <CA+V-a8sEAOTnS0+YxgvF3FSnSNvg3MdH145iRtDwiKTWQxkEMQ@mail.gmail.com>
Subject: Re: [PATCH] media: davinci-isif: avoid uninitialized variable use
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Wenwen Wang <wang6495@umn.edu>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Mar 22, 2019 at 2:34 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> clang warns about a possible variable use that gcc never
> complained about:
>
> drivers/media/platform/davinci/isif.c:982:32: error: variable 'frame_size' is uninitialized when used here
>       [-Werror,-Wuninitialized]
>                 dm365_vpss_set_pg_frame_size(frame_size);
>                                              ^~~~~~~~~~
> drivers/media/platform/davinci/isif.c:887:2: note: variable 'frame_size' is declared here
>         struct vpss_pg_frame_size frame_size;
>         ^
> 1 error generated.
>
> There is no initialization for this variable at all, and there
> has never been one in the mainline kernel, so we really should
> not put that stack data into an mmio register.
>
> On the other hand, I suspect that gcc checks the condition
> more closely and notices that the global
> isif_cfg.bayer.config_params.test_pat_gen flag is initialized
> to zero and never written to from any code path, so anything
> depending on it can be eliminated.
>
> To shut up the clang warning, just remove the dead code manually,
> it has probably never been used because any attempt to do so
> would have resulted in undefined behavior.
>
> Fixes: 63e3ab142fa3 ("V4L/DVB: V4L - vpfe capture - source for ISIF driver on DM365")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/davinci/isif.c | 9 ---------
>  1 file changed, 9 deletions(-)
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
> index 47cecd10eb9f..2dee9af6d413 100644
> --- a/drivers/media/platform/davinci/isif.c
> +++ b/drivers/media/platform/davinci/isif.c
> @@ -884,9 +884,7 @@ static int isif_set_hw_if_params(struct vpfe_hw_if_param *params)
>  static int isif_config_ycbcr(void)
>  {
>         struct isif_ycbcr_config *params = &isif_cfg.ycbcr;
> -       struct vpss_pg_frame_size frame_size;
>         u32 modeset = 0, ccdcfg = 0;
> -       struct vpss_sync_pol sync;
>
>         dev_dbg(isif_cfg.dev, "\nStarting isif_config_ycbcr...");
>
> @@ -974,13 +972,6 @@ static int isif_config_ycbcr(void)
>                 /* two fields are interleaved in memory */
>                 regw(0x00000249, SDOFST);
>
> -       /* Setup test pattern if enabled */
> -       if (isif_cfg.bayer.config_params.test_pat_gen) {
> -               sync.ccdpg_hdpol = params->hd_pol;
> -               sync.ccdpg_vdpol = params->vd_pol;
> -               dm365_vpss_set_sync_pol(sync);
> -               dm365_vpss_set_pg_frame_size(frame_size);
> -       }
>         return 0;
>  }
>
> --
> 2.20.0
>
