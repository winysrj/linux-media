Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED73C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 18:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752A92086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 18:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qfMeySxl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 752A92086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbeLLSRQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:17:16 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45260 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbeLLSRQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 13:17:16 -0500
Received: by mail-lj1-f193.google.com with SMTP id s5-v6so17092452ljd.12
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 10:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TMwJer3kWLgf4bFMoX/DL0uzMKupxqCBsJerCs0q2zE=;
        b=qfMeySxlrsiYs1Tc4GHuEoYOdv6eWng1MPb9Vtdbqx+qGaAs6fobrCdXSOcMvR4bZJ
         rmeFdjlKmTgMiz6yLHqQiOVYJh/mtx91/WT0bzIAWAukrm6ZR9C69bhSNUr872C/x5PG
         5WSykHBVoAi47NUhBuCAOcrt/Y/nHUOh3H6xOaCS/o6/M4lyjzuG3DmrMD53xgaCxXXU
         +QxZ+2JGkJYrNWNTvSiwfrIyjXZnvy2X/JBTv8BvB3Q4MGmH6y6LvsNXMyieYHeKHbs8
         bzZlCs0vNkjuFxKxFqK7pGZ8JeWSveuFEgfwLhwmgnb8uI7F8ucmNKBbs2lSFEhIXRJr
         FNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TMwJer3kWLgf4bFMoX/DL0uzMKupxqCBsJerCs0q2zE=;
        b=rQpPmFLfMOx+vYDImB4Qkdfozgl1fxdSMjNRrublQB4Zk8GjPfDYrqPpRz/XHTqp2O
         1e/qMAm6BTRBxz+hDYlfjThwTxZn7rhzQdaH8q1xZtJW9V8vBzvX67VEgLNSG09paGi3
         Lq18wrnfBe5lQE+hlTedHROhw2HkBduhXmwJvawpDbZsB3Cp3ysqxFF15fc/dEc5G5kT
         PQgFqUDq0XwWpMeUx5MS30Y63Dft42PMWr+moG/OqI9mrttWrdeSX8ehVQbF1k9t70YZ
         ie09Z4KB/7pL4jMhnivCZ4yqLWnnhgEW47kzewPWiiRagE4P6WRx9oLdujtP3yZ6Jrge
         6XvQ==
X-Gm-Message-State: AA+aEWaLgbm3fxydaZGiWcv7eK3fGV8BblJfgUpYlv1sRnM774VggQyE
        3+uqcGhxGTG5V7jYQGS99XTi5bq7w1tzHmPoBy4=
X-Google-Smtp-Source: AFSGD/UTlCRDy8kzEbF7rOYcH61m9wOHloPCmLIFAJuSlFnBaVLbjKLSeaXB3Oqz0Nsn1kTeRX4THnwRQMUzvdZqeTY=
X-Received: by 2002:a2e:851a:: with SMTP id j26-v6mr12815080lji.163.1544638634291;
 Wed, 12 Dec 2018 10:17:14 -0800 (PST)
MIME-Version: 1.0
References: <4800f277368eb6cc6099eb622988588e5a5de9ae.1544182979.git.mchehab+samsung@kernel.org>
 <823b68c7-dd0d-088a-d870-596c8b8e1bf5@xs4all.nl>
In-Reply-To: <823b68c7-dd0d-088a-d870-596c8b8e1bf5@xs4all.nl>
From:   Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date:   Wed, 12 Dec 2018 19:16:57 +0100
Message-ID: <CAPybu_1e8poSGYv2_8d1bMtkE+LgmPbnUJs1BWS6F=vnGMZ1cw@mail.gmail.com>
Subject: Re: [PATCH] media: imx214: don't de-reference a NULL pointer
To:     hverkuil-cisco@xs4all.nl
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro, Hi Hans

Thanks for taking a look at this.
On Wed, Dec 12, 2018 at 6:55 PM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
>
> On 12/7/18 12:43 PM, Mauro Carvalho Chehab wrote:
> > As warned by smatch:
> >       drivers/media/i2c/imx214.c:591 imx214_set_format() warn: variable dereferenced before check 'format' (see line 589)
> >
> > It turns that the code at imx214_set_format() has support for being
> > called with the format being NULL. I've no idea why, as it is only
> > called internally with the pointer set, and via subdev API (with
> > should also set it).
> >
> > Also, the entire logic there depends on having format != NULL, so
> > just remove the bogus broken support for a null format.

I believe it is a relic for when I did not use imx214_entity_init_cfg.
Sorry about that.

> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>
> Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>
Reviewed-by: Ricardo Ribalda Delgado <ricardo@ribalda.com>

Best Regards
> Regards,
>
>         Hans
>
> > ---
> >  drivers/media/i2c/imx214.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
> > index ec3d1b855f62..b046a26219a4 100644
> > --- a/drivers/media/i2c/imx214.c
> > +++ b/drivers/media/i2c/imx214.c
> > @@ -588,12 +588,10 @@ static int imx214_set_format(struct v4l2_subdev *sd,
> >
> >       __crop = __imx214_get_pad_crop(imx214, cfg, format->pad, format->which);
> >
> > -     if (format)
> > -             mode = v4l2_find_nearest_size(imx214_modes,
> > -                             ARRAY_SIZE(imx214_modes), width, height,
> > -                             format->format.width, format->format.height);
> > -     else
> > -             mode = &imx214_modes[0];
> > +     mode = v4l2_find_nearest_size(imx214_modes,
> > +                                   ARRAY_SIZE(imx214_modes), width, height,
> > +                                   format->format.width,
> > +                                   format->format.height);
> >
> >       __crop->width = mode->width;
> >       __crop->height = mode->height;
> >
>


-- 
Ricardo Ribalda
