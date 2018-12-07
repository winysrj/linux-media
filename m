Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_MED,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1F0C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 19:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFAF920700
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 19:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j9S93aFG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFAF920700
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbeLGTKl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 14:10:41 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41785 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeLGTKl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 14:10:41 -0500
Received: by mail-pl1-f196.google.com with SMTP id u6so2231415plm.8
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 11:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Iq4uLfhQZNhGUD9DIB41Rj41t4fKLRbQaTtWqQH9Is=;
        b=j9S93aFGTq8f4/FM42LfrKezASMKmdsUPz6TQFwW3L0t1irLk10oSY+mClWNk516JP
         5HKCUyxzupHqXkr1VvYGxXNAOzvwQWUGDSPmwIX5ODF+nTTzxa7TbnpZjttc1paUD2gj
         EUAGWxJADoZX3nSJx1YuZ8H26BvIfR1MjmmlefKVAHPWTcj6S9tK2C+f9tralaVJmOBu
         ry8rUIMSbRGwT6xqOuStvV+Yo6ieOha+XYCuhbq8k0rrD4/2HdPxQrINbGpNfprVLV19
         dlVCIM16jEsqQhWktsNb+qKBRKjC++vOPvDM85R/zMTVU4KYOtK3w1PMD+UA73S5DsJW
         UI/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Iq4uLfhQZNhGUD9DIB41Rj41t4fKLRbQaTtWqQH9Is=;
        b=i00ZKcKcmh63lq4qOQbn03Cjn5tByFTjFrv+GwL+qG4Uzimf3EGmt9k7uNn76XVdYv
         yw+Nr2SbX2UlzJBHeO4RND70vzhGHsb+skwQfSC1x7KktzT9KdXB/QmcC+M0M9Qsvbs0
         3PKrhr+puKVJCuwe3cH9Uv+cBsIeUeibNHZIdg0ohvP1U5l2Y8Ob9yg/6CoRhp2W71CZ
         Dogcjv9lfzjnkG7tknVi/yDiy2g5dR05lNiuSm/AUHNv6ejsvoWANk5FRxEFcQFgb6mJ
         7QHtehp6GeOI+rzgwkLsMLVZfa92WWTtA7SvDw90EOlkksHniljGmAkJCx4lXqz918PM
         dz0g==
X-Gm-Message-State: AA+aEWbs/CcLJPKik5g9RJi/JpJBONWPY29vVu39w4JmlQLvf008eZoO
        E4af4ErL5p5vyDGMIyvzq9Gv99lsGz/iq7Ei30i+DKsJB/s=
X-Google-Smtp-Source: AFSGD/Xpx/RHCp+1nVXXsSgdK5Zz4DD92lPJXc5rabemqB4eqg8VaTcNzUcAKBUgoLepUfXR9afEbAtcjsgd3iz9nR8=
X-Received: by 2002:a17:902:4464:: with SMTP id k91mr3293966pld.13.1544209840082;
 Fri, 07 Dec 2018 11:10:40 -0800 (PST)
MIME-Version: 1.0
References: <aa54ca91f2310ecea413daa289ab882cf9f37245.1544188058.git.mchehab+samsung@kernel.org>
 <94488f55b92ab1567dfeaf1fffb12fecc8c0b1d0.1544188058.git.mchehab+samsung@kernel.org>
In-Reply-To: <94488f55b92ab1567dfeaf1fffb12fecc8c0b1d0.1544188058.git.mchehab+samsung@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 7 Dec 2018 11:10:28 -0800
Message-ID: <CAKwvOd=i388Y90-wBgop7VYiDQ0UAD6qT15RRmLpm2xBu3QmcA@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: drxk_hard: check if parameter is not NULL
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org, mchehab@infradead.org,
        peda@axentia.se, wsa@the-dreams.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 7, 2018 at 5:08 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> There is a smatch warning:
>         drivers/media/dvb-frontends/drxk_hard.c: drivers/media/dvb-frontends/drxk_hard.c:1478 scu_command() error: we previously assumed 'parameter' could be null (see line 1467)
>
> Telling that parameter might be NULL. Well, it can't, due to the
> way the driver works, but it doesn't hurt to add a check, in order
> to shut up smatch.

eh, yeah this function is kind of odd; the early return conditions are
a little tricky, but I agree that this check doesn't hurt to add.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/dvb-frontends/drxk_hard.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
> index 84ac3f73f8fe..8ea1e45be710 100644
> --- a/drivers/media/dvb-frontends/drxk_hard.c
> +++ b/drivers/media/dvb-frontends/drxk_hard.c
> @@ -1474,9 +1474,11 @@ static int scu_command(struct drxk_state *state,
>
>         /* assume that the command register is ready
>                 since it is checked afterwards */
> -       for (ii = parameter_len - 1; ii >= 0; ii -= 1) {
> -               buffer[cnt++] = (parameter[ii] & 0xFF);
> -               buffer[cnt++] = ((parameter[ii] >> 8) & 0xFF);
> +       if (parameter) {
> +               for (ii = parameter_len - 1; ii >= 0; ii -= 1) {
> +                       buffer[cnt++] = (parameter[ii] & 0xFF);
> +                       buffer[cnt++] = ((parameter[ii] >> 8) & 0xFF);
> +               }
>         }
>         buffer[cnt++] = (cmd & 0xFF);
>         buffer[cnt++] = ((cmd >> 8) & 0xFF);
> --
> 2.19.2
>


-- 
Thanks,
~Nick Desaulniers
