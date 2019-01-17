Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D96DC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBE9820868
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJFgGmll"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbfAQUUm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:20:42 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44379 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbfAQUUm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:20:42 -0500
Received: by mail-ot1-f68.google.com with SMTP id f18so12304784otl.11;
        Thu, 17 Jan 2019 12:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x/hXwTsO0lVqZLYTBZaCdFP+uwsSEazPwXTSeHiU9/w=;
        b=UJFgGmll28r8i4VjjgIA1sdpT3wPyW9lPzqBY1yzSbkMu9M0DHVXNlMjH2uiIVQYuZ
         +TvqpMUYzbQoXMli/3fmRXEoFzXaGKcE5APX0JcQX5g8OH+Qn9PKoscQKyOwRjL5QhXn
         y26t8bbM9PtkFdh05X2RK1BINPY0Ke0SktuQT0Frg4sj6Jd/hOIru9WM4gaHQK7s6Q9n
         2r4u6IlfWnTjSWJcARF8K4q5mG1ZzoFiUU6VVrl5dT1u7V0vM2lc1gUt27rwhAixWHXo
         ULyueni3M9EzcCgW0KlX6ie3CJxAo+e47I49V9keT23G9Ak8/J2v9AN9XKZCyZ88funw
         45tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x/hXwTsO0lVqZLYTBZaCdFP+uwsSEazPwXTSeHiU9/w=;
        b=mL0m8iThBhKK/B7peU0+pvWwj+xGp6RITCO+SDQJqn/oNqmEQJdN63XjLa0R69/dGL
         A/XC44wlNb6Sdv7fr1/1agT/1CBmNELUxEKQQjPPo3QI3fNfYJhoebgXmfMg6eh7by2v
         +fstXywrke6YyQd6WyIFTW6EjlvDdxR6UreLDw1iRNUHrCPPfkG6YmXeLR7cNWrh2nMt
         oNHBjouAVzTmQufwpxp96Zwy3U78ABJiLthFTesrPRN6wsnXayJoP4+A1oHdOp3jLstz
         +GVZMZungII9jY/RGwwYy6EQYBRQP4CtrsKepjBGlyQwgleuXOhD49mlL3adglZ/Usc0
         94Aw==
X-Gm-Message-State: AJcUukcQrpVYd/IX8ctnQIIUhq11IH3v6QpJEaWF0M5d5ptfaadRUzSc
        V7TQXF+/6GEZF6QVh7udP55qKpeqHzPEyNGLvT4GnA==
X-Google-Smtp-Source: ALg8bN6jzsMxdpE4SQ/YoeqMAdAgXnHhMb/AlUI+nwsbzIauvC61zsb2Q8/8UeS79dTVYbW16k6KiERZlObF6i+OC3Y=
X-Received: by 2002:a9d:721e:: with SMTP id u30mr9938017otj.203.1547756440888;
 Thu, 17 Jan 2019 12:20:40 -0800 (PST)
MIME-Version: 1.0
References: <20190117201347.27347-1-slongerbeam@gmail.com> <20190117201347.27347-2-slongerbeam@gmail.com>
In-Reply-To: <20190117201347.27347-2-slongerbeam@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 17 Jan 2019 18:20:30 -0200
Message-ID: <CAOMZO5BtS_iLcUH0zO1u_L+jVCena-WzRJgR3NUif7UoxQAYVw@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: imx: csi: Disable CSI immediately after last EOF
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

On Thu, Jan 17, 2019 at 6:15 PM Steve Longerbeam <slongerbeam@gmail.com> wr=
ote:
>
> Disable the CSI immediately after receiving the last EOF before stream
> off (and thus before disabling the IDMA channel).
>
> This fixes a complete system hard lockup on the SabreAuto when streaming
> from the ADV7180, by repeatedly sending a stream off immediately followed
> by stream on:
>
> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3D3; done
>
> Eventually this either causes the system lockup or EOF timeouts at all
> subsequent stream on, until a system reset.
>
> The lockup occurs when disabling the IDMA channel at stream off. Disablin=
g
> the CSI before disabling the IDMA channel appears to be a reliable fix fo=
r
> the hard lockup.
>
> Reported-by: Ga=C3=ABl PORTAY <gael.portay@collabora.com>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>

Thanks. Since this fixes a lockup, maybe it is worth adding a Fixes
tag and Cc stable?

> ---
>  drivers/staging/media/imx/imx-media-csi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/=
media/imx/imx-media-csi.c
> index e18f58f56dfb..9218372cb997 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -681,6 +681,8 @@ static void csi_idmac_stop(struct csi_priv *priv)
>         if (ret =3D=3D 0)
>                 v4l2_warn(&priv->sd, "wait last EOF timeout\n");
>
> +       ipu_csi_disable(priv->csi);
> +
>         devm_free_irq(priv->dev, priv->eof_irq, priv);
>         devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
>
> @@ -793,11 +795,10 @@ static void csi_stop(struct csi_priv *priv)
>                 /* stop the frame interval monitor */
>                 if (priv->fim)
>                         imx_media_fim_set_stream(priv->fim, NULL, false);
> +       } else {
> +               ipu_csi_disable(priv->csi);
>         }
> -
> -       ipu_csi_disable(priv->csi);
>  }
> -

Unneeded line removal.
