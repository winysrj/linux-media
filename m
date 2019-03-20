Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AE4C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C5A42184E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vzd125ZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfCTOk2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:40:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40478 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfCTOk2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:40:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id u10so17982372wmj.5;
        Wed, 20 Mar 2019 07:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=63lUCKzou0hKfO0w+V6Cio4BeboSTxW84Eh4nTzwxsM=;
        b=Vzd125ZFTuWtYphi13aF3UM8xmSExJHfC09VqlBSXM8QEGQGkjj8a/G4u0xUVWxq50
         KGActoHGWYrUoQpD/4Y6TbIDbZTD/OSlbXa4cifeXn070lCv6Y6avSJeYpuc3yYEkTOH
         OIyr45wPD/TkW5CTa/cIjmnT2+t7vuupwABMfV1LVN3j9Dfk3CWuHcPaIRh/OaNulhe6
         1jy6LcJ1R953IFmkyYWSdlsSK3a6TlSfh/v3mFWcnDdRk/wsna1BGs91I7SaZspRHIk1
         u/ByT3PZteHrWOeJ6/s8IDC725sao0KCFqbYqZWb90RaIgz+CZ6hOAJAPbG0RSKjDjGU
         pGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=63lUCKzou0hKfO0w+V6Cio4BeboSTxW84Eh4nTzwxsM=;
        b=NHW6Ir83/IDJVN5UUu6VbTDuyS6T+vvC3dt4TToC3YEF2qZVJlCjEScmrvs89hDP5C
         DzSldiQNfrcLysj94Sg0Ay43b6zyrtmSPezj/sdoJXQcjzzSrCIaCs+Nb/+zp7AXNUpK
         aF8qlr3GyTIex9+HsCrWXIHBZPgA0licQa0t5WzMEUzxEjqBJgA3asrANPSP9x3u7NAP
         7EH/BTLOt5E36d1X4biOlc67EszdGra5uYSW61uaxlPsRHIqbYXPZaUZg7b5BoAaroqo
         0h2IRFTYrfDw/6YOA6ajVho8Pg58xfjTWwsKtxZNpbkxTbIBgE11C3moanKy9DvIHvBd
         srfA==
X-Gm-Message-State: APjAAAVDHkJG/0WOQLY2MEV7z7JSXmXQDLT8PDO/YwXQ1AsGHwYLf2Nm
        +FTMO9CHwtPFkVY1MYIlcOg=
X-Google-Smtp-Source: APXvYqy2vehQ4w1sNvQHIK58PnXeQOX8/aXLrDPAzBtZ2No4z0wtJ9+TVE5c0KF86+piralA7Sxtyg==
X-Received: by 2002:a1c:ed10:: with SMTP id l16mr6511616wmh.118.1553092825868;
        Wed, 20 Mar 2019 07:40:25 -0700 (PDT)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id c10sm2738646wrr.1.2019.03.20.07.40.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Mar 2019 07:40:25 -0700 (PDT)
References: <20190319163622.30607-1-wsa+renesas@sang-engineering.com>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rmfrfs@gmail.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] staging: media: imx: imx7-mipi-csis: simplify getting .driver_data
In-reply-to: <20190319163622.30607-1-wsa+renesas@sang-engineering.com>
Date:   Wed, 20 Mar 2019 14:40:23 +0000
Message-ID: <m3y359vcbs.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Wolfram,
Thanks for the patch.
On Tue 19 Mar 2019 at 16:36, Wolfram Sang wrote:
> We should get 'driver_data' from 'struct device' directly. Going 
> via
> platform_device is an unneeded step back and forth.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>

---
Cheers,
	Rui

> ---
>
> Build tested only. buildbot is happy.
>
>  drivers/staging/media/imx/imx7-mipi-csis.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c 
> b/drivers/staging/media/imx/imx7-mipi-csis.c
> index 2ddcc42ab8ff..44569c63e4de 100644
> --- a/drivers/staging/media/imx/imx7-mipi-csis.c
> +++ b/drivers/staging/media/imx/imx7-mipi-csis.c
> @@ -1039,8 +1039,7 @@ static int mipi_csis_probe(struct 
> platform_device *pdev)
>  
>  static int mipi_csis_pm_suspend(struct device *dev, bool 
>  runtime)
>  {
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct v4l2_subdev *mipi_sd = platform_get_drvdata(pdev);
> +	struct v4l2_subdev *mipi_sd = dev_get_drvdata(dev);
>  	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
>  	int ret = 0;
>  
> @@ -1064,8 +1063,7 @@ static int mipi_csis_pm_suspend(struct 
> device *dev, bool runtime)
>  
>  static int mipi_csis_pm_resume(struct device *dev, bool 
>  runtime)
>  {
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct v4l2_subdev *mipi_sd = platform_get_drvdata(pdev);
> +	struct v4l2_subdev *mipi_sd = dev_get_drvdata(dev);
>  	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
>  	int ret = 0;

