Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFFDC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E28F2146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6esLqnJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfBTLX0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:23:26 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33340 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfBTLX0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 06:23:26 -0500
Received: by mail-wm1-f65.google.com with SMTP id h22so4468889wmb.0
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2019 03:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=/EgvqyBOK4aEdkk+1Ilz9OdPrUVMsAWAoUmbAuKMz4g=;
        b=W6esLqnJTK2ScrTgGqrEZ8eWV2AkmRkw/BNkJAcZOhlBks5i7/P1CiqKTEK+XHWmFS
         tWyku44mYA7m7mBng5mDfm51RnZhmlW5DQPiMMjt8mwpxb3mCfdxW6de0j4kB7RzCvP2
         +BOzLOZ5npVWhfCSnuWmR/l4zBAhhmcLzrkvBHtZ1biqB4+eAOoSoxi8fxoSuR7IXv9p
         P/B4fdE1aSQNMO4i91ClRige4UWqp+bWw4VKF7wBOzDlpYYpY1wufKYh/61YLUe8UsHY
         M5lWqO9GjUHo7NAgGo2H3P5FIE1R0k0sqj2G3xnFdcmuf6glBCMm9asOB20sF/XncTfj
         W8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=/EgvqyBOK4aEdkk+1Ilz9OdPrUVMsAWAoUmbAuKMz4g=;
        b=k5KET33j4yAP8P6u1HEF+tY8N9l5Pwwb6m02O4apkMQtLKnqFmmxOFvCdcq4ocF3d3
         LMNhs1HTkq+gpO2ATIoIPH855+hAx6bHUAnmgTSQAcZSaUmaB6DwintCDDWSCJ4jInFT
         Kwzni76MGtnRvTCVWUfXU6yuRGGUmaJtCWWKkGi7Ofrxr9B4VMzFEvFJ78akAvHvcg0u
         +GWy6z0SEozuIFuH2A9dNTiy0HVS39eiaNCwgXDZ+Y/fJvwOtbwakXRncXs8ZMuKUSrY
         H2I89d9kZ3A6UVZX4rRlgRoKdufs2L8qxwgL7UHzgjF649wsFPZbciTJXIKwLguAm46V
         GRHA==
X-Gm-Message-State: AHQUAuYxqbHoN7TsGkGZZsxlclHnwtbZb0l7lEyS29XyOM1YtdXrAt36
        ocZsvZzudynpbv0/APEbsm2jGcUwYrs=
X-Google-Smtp-Source: AHgI3Ibmcpw/J50ICjflcvlmzPXW+xcvh7KCU6qj8cHmArUN3ux69hPK0DpgWnQAr68rKZISS6U84Q==
X-Received: by 2002:a7b:c84b:: with SMTP id c11mr2198471wml.108.1550661804585;
        Wed, 20 Feb 2019 03:23:24 -0800 (PST)
Received: from arch-late ([87.196.73.87])
        by smtp.gmail.com with ESMTPSA id y185sm5792308wmg.34.2019.02.20.03.23.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 03:23:23 -0800 (PST)
References: <1c186d5fd734e63305352986b6c5e84d19375787.1550582690.git.mchehab+samsung@kernel.org> <91937229883824924f1a06ded49dfded4ca96d43.1550582690.git.mchehab+samsung@kernel.org>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rmfrfs@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] media: imx7-media-csi: get rid of unused var
In-reply-to: <91937229883824924f1a06ded49dfded4ca96d43.1550582690.git.mchehab+samsung@kernel.org>
Date:   Wed, 20 Feb 2019 11:23:20 +0000
Message-ID: <m38syau2jb.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Oi Mauro,
On Tue 19 Feb 2019 at 13:24, Mauro Carvalho Chehab wrote:
> 	drivers/staging/media/imx/imx7-media-csi.c: In function 
> 'imx7_csi_enum_mbus_code':
> 	drivers/staging/media/imx/imx7-media-csi.c:926:33: 
> warning: variable 'in_cc' set but not used 
> [-Wunused-but-set-variable]
> 	  const struct imx_media_pixfmt *in_cc;
> 	                                 ^~~~~
>
> Signed-off-by: Mauro Carvalho Chehab 
> <mchehab+samsung@kernel.org>

Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>

---
Cheers,
	Rui

> ---
>  drivers/staging/media/imx/imx7-media-csi.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx7-media-csi.c 
> b/drivers/staging/media/imx/imx7-media-csi.c
> index 0b1788d79ce9..3fba7c27c0ec 100644
> --- a/drivers/staging/media/imx/imx7-media-csi.c
> +++ b/drivers/staging/media/imx/imx7-media-csi.c
> @@ -923,7 +923,6 @@ static int imx7_csi_enum_mbus_code(struct 
> v4l2_subdev *sd,
>  				   struct 
>  v4l2_subdev_mbus_code_enum *code)
>  {
>  	struct imx7_csi *csi = v4l2_get_subdevdata(sd);
> -	const struct imx_media_pixfmt *in_cc;
>  	struct v4l2_mbus_framefmt *in_fmt;
>  	int ret = 0;
>  
> @@ -931,8 +930,6 @@ static int imx7_csi_enum_mbus_code(struct 
> v4l2_subdev *sd,
>  
>  	in_fmt = imx7_csi_get_format(csi, cfg, IMX7_CSI_PAD_SINK, 
>  code->which);
>  
> -	in_cc = imx_media_find_mbus_format(in_fmt->code, 
> CS_SEL_ANY, true);
> -
>  	switch (code->pad) {
>  	case IMX7_CSI_PAD_SINK:
>  		ret = imx_media_enum_mbus_format(&code->code, 
>  code->index,

