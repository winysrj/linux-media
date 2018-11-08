Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbeKHUzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 15:55:07 -0500
Date: Thu, 8 Nov 2018 03:20:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin King <colin.king@canonical.com>
Cc: Dmitry Osipenko <digetx@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: staging: tegra-vde: print long unsigned using %lu
 format specifier
Message-ID: <20181108112001.GA7793@kroah.com>
References: <20181108110224.1916-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108110224.1916-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 08, 2018 at 11:02:24AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The frame.flags & FLAG_B_FRAME is promoted to a long unsigned because
> of the use of the BIT() macro when defining FLAG_B_FRAME and causing a
> build warning. Fix this by using the %lu format specifer.
> 
> Cleans up warning:
> drivers/staging/media/tegra-vde/tegra-vde.c:267:5: warning: format
> specifies type 'int' but the argument has type 'unsigned long' [-Wformat]
> 
> Fixes: 42e764d05712 ("staging: tegravde: replace bit assignment with macro")
> Cc: Ioannis Valasakis <code@wizofe.uk>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/media/tegra-vde/tegra-vde.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
> index 6f06061a40d9..66cf14212c14 100644
> --- a/drivers/staging/media/tegra-vde/tegra-vde.c
> +++ b/drivers/staging/media/tegra-vde/tegra-vde.c
> @@ -262,7 +262,7 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
>  			value |= frame->frame_num;
>  
>  			dev_dbg(vde->miscdev.parent,
> -				"\tFrame %d: frame_num = %d B_frame = %d\n",
> +				"\tFrame %d: frame_num = %d B_frame = %lu\n",
>  				i + 1, frame->frame_num,
>  				(frame->flags & FLAG_B_FRAME));
>  		} else {
> -- 
> 2.19.1

Thanks for this, you beat me too it :)

greg k-h
