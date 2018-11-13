Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr770094.outbound.protection.outlook.com ([40.107.77.94]:20128
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbeKMPJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 10:09:52 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <narmstrong@baylibre.com>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] media: cxd2880-spi: fix probe when dvb_attach fails
Date: Tue, 13 Nov 2018 05:13:20 +0000
Message-ID: <02699364973B424C83A42A84B04FDA850B32C7AC@JPYOKXMS113.jp.sony.com>
References: <1541681088-7385-1-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1541681088-7385-1-git-send-email-narmstrong@baylibre.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

Thanks for finding that.

Acked-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>


> -----Original Message-----
> From: Neil Armstrong [mailto:narmstrong@baylibre.com]
> Sent: Thursday, November 8, 2018 9:45 PM
> To: Takiguchi, Yasunari (SSS)
> Cc: Neil Armstrong; mchehab@kernel.org; linux-media@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH] media: cxd2880-spi: fix probe when dvb_attach fails
> 
> When dvb_attach fails, probe returns 0, and remove crashes afterwards.
> This patch sets the return value to -ENODEV when attach fails.
> 
> Fixes: bd24fcddf6b8 ("media: cxd2880-spi: Add support for CXD2880 SPI
> interface")
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/media/spi/cxd2880-spi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/spi/cxd2880-spi.c
> b/drivers/media/spi/cxd2880-spi.c
> index 11ce510..c437309 100644
> --- a/drivers/media/spi/cxd2880-spi.c
> +++ b/drivers/media/spi/cxd2880-spi.c
> @@ -536,6 +536,7 @@ cxd2880_spi_probe(struct spi_device *spi)
> 
>  	if (!dvb_attach(cxd2880_attach, &dvb_spi->dvb_fe, &config)) {
>  		pr_err("cxd2880_attach failed\n");
> +		ret = -ENODEV;
>  		goto fail_attach;
>  	}
> 
> --
> 2.7.4
