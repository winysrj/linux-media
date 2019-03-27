Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974CBC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 11:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 675912070D
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 11:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="i04s8tvh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfC0Lzw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 07:55:52 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56101 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfC0Lzw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 07:55:52 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id B846225BF16;
        Wed, 27 Mar 2019 22:55:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1553687750; bh=4J8Cz7OwcswXIgEOYLCzCa7IN5HplLTtPIHjJ8sLS40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i04s8tvhEt7gTqLEpLU5Piqqp4LU1/jnGNktzKFZhAwwQ3A46sCnB5jGQPx6JIaGb
         U8x6r6Vqm7jw0VideAQu1TpIzItOAy2HwnkFS4yZrYbb9IheSGWSPu4xPKbEg7K6FS
         1gsNKk+22fph4NfbatYM0uTjh4vUkrPpps66NNXk=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id EF310940376; Wed, 27 Mar 2019 12:55:47 +0100 (CET)
Date:   Wed, 27 Mar 2019 12:55:47 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Rui Miguel Silva <rmfrfs@gmail.com>,
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
Subject: Re: [PATCH 1/1] staging: media: imx: imx7-mipi-csis: simplify
 getting .driver_data
Message-ID: <20190327115547.k57rynzsajbjo5sz@verge.net.au>
References: <20190319163622.30607-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319163622.30607-1-wsa+renesas@sang-engineering.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 19, 2019 at 05:36:22PM +0100, Wolfram Sang wrote:
> We should get 'driver_data' from 'struct device' directly. Going via
> platform_device is an unneeded step back and forth.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

> ---
> 
> Build tested only. buildbot is happy.
> 
>  drivers/staging/media/imx/imx7-mipi-csis.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
> index 2ddcc42ab8ff..44569c63e4de 100644
> --- a/drivers/staging/media/imx/imx7-mipi-csis.c
> +++ b/drivers/staging/media/imx/imx7-mipi-csis.c
> @@ -1039,8 +1039,7 @@ static int mipi_csis_probe(struct platform_device *pdev)
>  
>  static int mipi_csis_pm_suspend(struct device *dev, bool runtime)
>  {
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct v4l2_subdev *mipi_sd = platform_get_drvdata(pdev);
> +	struct v4l2_subdev *mipi_sd = dev_get_drvdata(dev);
>  	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
>  	int ret = 0;
>  
> @@ -1064,8 +1063,7 @@ static int mipi_csis_pm_suspend(struct device *dev, bool runtime)
>  
>  static int mipi_csis_pm_resume(struct device *dev, bool runtime)
>  {
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct v4l2_subdev *mipi_sd = platform_get_drvdata(pdev);
> +	struct v4l2_subdev *mipi_sd = dev_get_drvdata(dev);
>  	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
>  	int ret = 0;
>  
> -- 
> 2.11.0
> 
