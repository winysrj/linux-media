Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38925 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbeHRPxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 11:53:00 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 05/14] staging: media: tegra-vde: Properly mark invalid entries
Date: Sat, 18 Aug 2018 15:45:20 +0300
Message-ID: <1655447.DEioCXKPSa@dimapc>
In-Reply-To: <20180813145027.16346-6-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com> <20180813145027.16346-6-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, 13 August 2018 17:50:18 MSK Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Entries in the reference picture list are marked as invalid by setting
> the frame ID to 0x3f.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/staging/media/tegra-vde/tegra-vde.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c
> b/drivers/staging/media/tegra-vde/tegra-vde.c index
> 275884e745df..0ce30c7ccb75 100644
> --- a/drivers/staging/media/tegra-vde/tegra-vde.c
> +++ b/drivers/staging/media/tegra-vde/tegra-vde.c
> @@ -296,7 +296,7 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde
> *vde, (frame->flags & FLAG_B_FRAME));
>  		} else {
>  			aux_addr = 0x6ADEAD00;
> -			value = 0;
> +			value = 0x3f;
>  		}
> 
>  		tegra_vde_setup_iram_entry(vde, num_ref_pics, 0, i, value,

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
