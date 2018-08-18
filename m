Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33950 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbeHRP55 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 11:57:57 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 07/14] staging: media: tegra-vde: Add some clarifying comments
Date: Sat, 18 Aug 2018 15:50:17 +0300
Message-ID: <5081449.StsSdamf0J@dimapc>
In-Reply-To: <20180813145027.16346-8-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com> <20180813145027.16346-8-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, 13 August 2018 17:50:20 MSK Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add some comments specifying what tables are being set up in VRAM.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/staging/media/tegra-vde/tegra-vde.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c
> b/drivers/staging/media/tegra-vde/tegra-vde.c index
> 0adc603fa437..41cf86dc5dbd 100644
> --- a/drivers/staging/media/tegra-vde/tegra-vde.c
> +++ b/drivers/staging/media/tegra-vde/tegra-vde.c
> @@ -271,6 +271,7 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde
> *vde, unsigned int i, k;
>  	size_t size;
> 
> +	/* clear H256RefPicList */
>  	size = num_ref_pics * 4 * 8;
>  	memset(vde->iram, 0, size);

H256? Is it a typo?

> 
> @@ -453,6 +454,7 @@ static int tegra_vde_setup_hw_context(struct tegra_vde
> *vde, VDE_WR(0x00000000, vde->bsev + 0x98);
>  	VDE_WR(0x00000060, vde->bsev + 0x9C);
> 
> +	/* clear H264MB2SliceGroupMap, assuming no FMO */
>  	memset(vde->iram + 1024, 0, macroblocks_nb / 2);
> 
>  	tegra_setup_frameidx(vde, dpb_frames, ctx->dpb_frames_nb,
> @@ -480,6 +482,8 @@ static int tegra_vde_setup_hw_context(struct tegra_vde
> *vde, if (err)
>  		return err;
> 
> +	/* upload H264MB2SliceGroupMap */
> +	/* XXX don't hardcode map size? */
>  	value = (0x20 << 26) | (0 << 25) | ((4096 >> 2) & 0x1fff);
>  	err = tegra_vde_push_to_bsev_icmdqueue(vde, value, false);
>  	if (err)
> @@ -492,6 +496,7 @@ static int tegra_vde_setup_hw_context(struct tegra_vde
> *vde, if (err)
>  		return err;
> 
> +	/* clear H264MBInfo XXX don't hardcode size */
>  	value = (0x21 << 26) | ((240 & 0x1fff) << 12) | (0x54c & 0xfff);
>  	err = tegra_vde_push_to_bsev_icmdqueue(vde, 0x840F054C, false);
>  	if (err)
> @@ -499,6 +504,16 @@ static int tegra_vde_setup_hw_context(struct tegra_vde
> *vde,
> 
>  	size = num_ref_pics * 4 * 8;
> 
> +	/* clear H264RefPicList */

#if 0

> +	value = (0x21 << 26) | (((size >> 2) & 0x1fff) << 12) | 0xE34;
> +
> +	err = tegra_vde_push_to_bsev_icmdqueue(vde, value, false);
> +	if (err)
> +		return err;

#endif

Is it supposed to do the same as "clear H256RefPicList -> memset(vde->iram, 0, 
size)" above?

> +
> +	/* upload H264RefPicList */
>  	value = (0x20 << 26) | (0x0 << 25) | ((size >> 2) & 0x1fff);
>  	err = tegra_vde_push_to_bsev_icmdqueue(vde, value, false);
>  	if (err)
> @@ -584,7 +599,11 @@ static int tegra_vde_setup_hw_context(struct tegra_vde
> *vde,
> 
>  	tegra_vde_mbe_set_0xa_reg(vde, 0, 0x000009FC);
>  	tegra_vde_mbe_set_0xa_reg(vde, 2, 0x61DEAD00);
> +#if 0
> +	tegra_vde_mbe_set_0xa_reg(vde, 4, dpb_frames[0].aux_addr); /* 0x62DEAD00
> */ +#else
>  	tegra_vde_mbe_set_0xa_reg(vde, 4, 0x62DEAD00);
> +#endif

This doesn't really clarify much, let's drop this chunk for now.

>  	tegra_vde_mbe_set_0xa_reg(vde, 6, 0x63DEAD00);
>  	tegra_vde_mbe_set_0xa_reg(vde, 8, dpb_frames[0].aux_addr);
