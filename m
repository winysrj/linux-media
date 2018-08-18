Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45224 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbeHRP6H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 11:58:07 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 10/14] staging: media: tegra-vde: Keep VDE in reset when unused
Date: Sat, 18 Aug 2018 15:50:27 +0300
Message-ID: <2043408.4kzI8ETTWM@dimapc>
In-Reply-To: <20180813145027.16346-11-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com> <20180813145027.16346-11-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, 13 August 2018 17:50:23 MSK Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> There is no point in keeping the VDE module out of reset when it is not
> in use. Reset it on runtime suspend.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/staging/media/tegra-vde/tegra-vde.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c
> b/drivers/staging/media/tegra-vde/tegra-vde.c index
> 3bc0bfcfe34e..4b3c6ab3c77e 100644
> --- a/drivers/staging/media/tegra-vde/tegra-vde.c
> +++ b/drivers/staging/media/tegra-vde/tegra-vde.c
> @@ -1226,6 +1226,7 @@ static int tegra_vde_runtime_suspend(struct device
> *dev) }
> 
>  	reset_control_assert(vde->rst_bsev);
> +	reset_control_assert(vde->rst);
> 
>  	usleep_range(2000, 4000);

There is also no point to reset VDE while it is powered off, then why do we 
that?
