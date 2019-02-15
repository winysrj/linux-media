Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944E1C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 06:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633E421872
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 06:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WNvAk1AS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfBOGbZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 01:31:25 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45052 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfBOGbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 01:31:25 -0500
Received: by mail-ot1-f66.google.com with SMTP id g1so14783839otj.11
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2019 22:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kyFF1fTjgmmE/tUAn/20BqJuv3JTwvP5IX3nJ+F2ft4=;
        b=WNvAk1ASxvYbbNXMGsbLXqsVe2eKhnbISpkiRucE2aqepDJIxSJothWWMOS/9u+XaH
         75SaY656lSqJFS21MpkPegkAjVfywWDLX8a+Zoc1Bd+1W0thWbC/y1HUEC0lD05FvhZK
         G4vu1AiBU+bNUpu1nYhh4tHdCo97gwTnjAYmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kyFF1fTjgmmE/tUAn/20BqJuv3JTwvP5IX3nJ+F2ft4=;
        b=H4kEIEMF9n5s0Y1QC3qFZT/TXgMViQ3W/d3DGrxGV0lBC5nfOCoNWcnDIEHjLrpKfg
         tgxk7mMMiXA8mjIu7lDdV3K2HPili84fVT+rLrLuOR7iXT8+KYBtgn+3A+kHbN+xqRg4
         J6FdpS2FRD6H3/887ZJTZNJ5isHnHzXpvRISBzqwioFY0gVdPBibZM5hg6i8bMofieKy
         qIn6q7o8p8rJczMWU0cjKrcoi/mbVxmzdZzvL0DsO5AhPYLYgBBDkxffpePHQg7BbP0W
         ClFoulya3VBVALMDiwCZzDd0TuLjJAwDQhhqtui6cEOzqbIkB4C0dqjeuRqUbEh6EYA1
         7N0A==
X-Gm-Message-State: AHQUAuaWX/2hoJEz4PfOLDDCgjMkxlYNn3P93C/AtwUCCOxLVWWdr9QY
        DPSr/xO9V8TdnUxTKeIZ0ZnFRaRSLAU=
X-Google-Smtp-Source: AHgI3Ia3QAkJPH7OTUOS4TbfeX0BctUATPtG4iBMvKX6GOvo3Vaf1u6n28XjtopI5LYX7mAXiFpypA==
X-Received: by 2002:a9d:2387:: with SMTP id t7mr4742455otb.68.1550212283972;
        Thu, 14 Feb 2019 22:31:23 -0800 (PST)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id c26sm1130191otm.10.2019.02.14.22.31.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 22:31:22 -0800 (PST)
Received: by mail-ot1-f52.google.com with SMTP id n71so14794880ota.10
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2019 22:31:22 -0800 (PST)
X-Received: by 2002:a9d:6f8e:: with SMTP id h14mr4570616otq.241.1550212282249;
 Thu, 14 Feb 2019 22:31:22 -0800 (PST)
MIME-Version: 1.0
References: <1550141817-25453-1-git-send-email-bingbu.cao@intel.com>
In-Reply-To: <1550141817-25453-1-git-send-email-bingbu.cao@intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 15 Feb 2019 15:31:11 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DJpBP7s5UTiT4W=8_v8CA-n5+f2=yEbFmTUFcXNgyhCA@mail.gmail.com>
Message-ID: <CAAFQd5DJpBP7s5UTiT4W=8_v8CA-n5+f2=yEbFmTUFcXNgyhCA@mail.gmail.com>
Subject: Re: [PATCH] media:staging/intel-ipu3: update minimal GDC envelope
 size to 4
To:     Cao Bing Bu <bingbu.cao@intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        Bingbu Cao <bingbu.cao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Bingbu,

On Thu, Feb 14, 2019 at 7:50 PM <bingbu.cao@intel.com> wrote:
>
> From: Bingbu Cao <bingbu.cao@intel.com>
>
> The ipu3 GDC function need some envelope to do filtering and the
> minimal envelope size(GDC in - out) for ipu3 should be 4.
> Current value 4 was defined for older version GDC, this patch
> correct it.
>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> ---
>  drivers/staging/media/ipu3/ipu3-css.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
> index 44c55639389a..8864206fd7e3 100644
> --- a/drivers/staging/media/ipu3/ipu3-css.c
> +++ b/drivers/staging/media/ipu3/ipu3-css.c
> @@ -23,9 +23,8 @@
>  #define IPU3_CSS_MAX_H         3136
>  #define IPU3_CSS_MAX_W         4224
>
> -/* filter size from graph settings is fixed as 4 */
> -#define FILTER_SIZE             4
> -#define MIN_ENVELOPE            8
> +/* minimal envelope size(GDC in - out) should be 4 */
> +#define MIN_ENVELOPE            4
>
>  /*
>   * pre-allocated buffer size for CSS ABI, auxiliary frames
> @@ -1821,9 +1820,9 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
>         vf->width   = ipu3_css_adjust(vf->width, VF_ALIGN_W);
>         vf->height  = ipu3_css_adjust(vf->height, 1);
>
> -       s = (bds->width - gdc->width) / 2 - FILTER_SIZE;
> +       s = (bds->width - gdc->width) / 2;
>         env->width = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
> -       s = (bds->height - gdc->height) / 2 - FILTER_SIZE;
> +       s = (bds->height - gdc->height) / 2;
>         env->height = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
>
>         css->pipes[pipe].bindex =
> @@ -2245,9 +2244,8 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
>                                 css_pipe->aux_frames[a].height,
>                                 css_pipe->rect[g].width,
>                                 css_pipe->rect[g].height,
> -                               css_pipe->rect[e].width + FILTER_SIZE,
> -                               css_pipe->rect[e].height +
> -                               FILTER_SIZE);
> +                               css_pipe->rect[e].width,
> +                               css_pipe->rect[e].height);
>                 }
>         }
>
> --
> 1.9.1
>

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
