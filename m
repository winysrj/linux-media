Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46648 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbeHRPxI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 11:53:08 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 06/14] staging: media: tegra-vde: Print out invalid FD
Date: Sat, 18 Aug 2018 15:45:29 +0300
Message-ID: <10439434.lSlGX5k21Y@dimapc>
In-Reply-To: <20180813145027.16346-7-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com> <20180813145027.16346-7-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, 13 August 2018 17:50:19 MSK Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Include the invalid file descriptor when reporting an error message to
> help diagnosing why importing the buffer failed.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/staging/media/tegra-vde/tegra-vde.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c
> b/drivers/staging/media/tegra-vde/tegra-vde.c index
> 0ce30c7ccb75..0adc603fa437 100644
> --- a/drivers/staging/media/tegra-vde/tegra-vde.c
> +++ b/drivers/staging/media/tegra-vde/tegra-vde.c
> @@ -643,7 +643,7 @@ static int tegra_vde_attach_dmabuf(struct device *dev,
> 
>  	dmabuf = dma_buf_get(fd);
>  	if (IS_ERR(dmabuf)) {
> -		dev_err(dev, "Invalid dmabuf FD\n");
> +		dev_err(dev, "Invalid dmabuf FD: %d\n", fd);
>  		return PTR_ERR(dmabuf);
>  	}

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
