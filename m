Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563B4C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24769206B7
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bS5BhomL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfBTLZ3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:25:29 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38394 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfBTLZ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 06:25:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so25520244wrw.5
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2019 03:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=/imoJEJydwPtU4mrTuQc39JmQS04qsEjCMVfkU0a1Js=;
        b=bS5BhomLcjY70nIvISD1IbJon8WfXDKsVYd7tl101Z0+bcXaV9uUdhTninABYqD/l/
         6d6kJElRtxaaag/C0pAAN9n9mXK9gaLQtAz5idhcZknLfgJrwFPJDsETH6A9wiKDlsvm
         w/wcyHERq640PU6uVDo4ZNrzx7zEljz8VM6E3WmqGnTyT3AmnS49cKAON232+tnzc2w9
         GFuTBW1vyhvElOCaS+BLW6JpS6wY/a1KAZVuEgefIr9SuIZNzQh9y+KIaripDH1MiKB/
         gvhLD1/nRFZA+UxeyRnEG2uQOq+fwT2MmmOHgzzEFKVIWzwCY+0YZNUPRo/0Y+KjmuZy
         vOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=/imoJEJydwPtU4mrTuQc39JmQS04qsEjCMVfkU0a1Js=;
        b=RTaoZLnttzkdCv+QbgyDEbG8HScdzX97oRFAx3h+a5G6kvZweIXymcpEKWB6FQ9wIX
         AePW3d5G0+q9jP58XuEt6nrcIX0+cEHf4EUJami/Ut2NGYxj3JHxBbqwqVlVi1ZgO9xB
         1js4CbNZ1agGV88p6ZHAxquhhiOEZqQzrsGR6bncHCpg+pRxX7XFUBG4JzdRBZfYGZpH
         FqCuJpqdtzYtBM3h4LpQJSIblLUzE0mkZj+IjJ65nm6mgf3dJmgJ5tNQKkWmWa4RE1ST
         r9UCBiewNla9AHz2HbrSvwsXSKNAQQC9jzIdJ0s15TbNO4aVXgN8IWs7EP983SDkMgWD
         3zeQ==
X-Gm-Message-State: AHQUAub5ScByqE4AQvilPb/0a+T4E9MXjauOdP0em2AyK9xzAs8fpMDP
        DRi0TVCnXaK53BIjg94jyCk=
X-Google-Smtp-Source: AHgI3IY4DvsxSqh08SNPhmnQ2/8rd/mPeNMUV5tRdvXwHC+IuBKkyDmVQtwoxaTT4Yz8fpryEVQrTg==
X-Received: by 2002:a5d:604d:: with SMTP id j13mr16878938wrt.194.1550661926915;
        Wed, 20 Feb 2019 03:25:26 -0800 (PST)
Received: from arch-late ([87.196.73.87])
        by smtp.gmail.com with ESMTPSA id f196sm6285539wme.36.2019.02.20.03.25.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 03:25:26 -0800 (PST)
References: <3958dde6-b934-f2d9-f522-ce2b001496d9@xs4all.nl>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rmfrfs@gmail.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH] imx7: fix smatch error
In-reply-to: <3958dde6-b934-f2d9-f522-ce2b001496d9@xs4all.nl>
Date:   Wed, 20 Feb 2019 11:25:24 +0000
Message-ID: <m37eduu2fv.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,
Thanks for the patch.

On Wed 20 Feb 2019 at 08:59, Hans Verkuil wrote:
> Fixes this smatch error:
>
> drivers/staging/media/imx/imx7-mipi-csis.c:716 
> mipi_csis_set_fmt() error: we previously assumed 'fmt' could 
> beor null (see line 709)
>
> fmt is never NULL, so remove the 'fmt &&' condition.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>

---
Cheers,
	Rui

> ---
> diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c 
> b/drivers/staging/media/imx/imx7-mipi-csis.c
> index f4674de09e83..a5f7bbc41c61 100644
> --- a/drivers/staging/media/imx/imx7-mipi-csis.c
> +++ b/drivers/staging/media/imx/imx7-mipi-csis.c
> @@ -706,7 +706,7 @@ static int mipi_csis_set_fmt(struct 
> v4l2_subdev *mipi_sd,
>  	fmt = mipi_csis_get_format(state, cfg, sdformat->which, 
>  sdformat->pad);
>
>  	mutex_lock(&state->lock);
> -	if (fmt && sdformat->pad == CSIS_PAD_SOURCE) {
> +	if (sdformat->pad == CSIS_PAD_SOURCE) {
>  		sdformat->format = *fmt;
>  		goto unlock;
>  	}

