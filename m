Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36170 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbeH3M51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 08:57:27 -0400
Date: Thu, 30 Aug 2018 11:56:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 03/14] staging: media: tegra-vde: Prepare for interlacing
 support
Message-ID: <20180830085605.dpfsd6korroisfrq@mwanda>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
 <20180813145027.16346-4-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180813145027.16346-4-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 13, 2018 at 04:50:16PM +0200, Thierry Reding wrote:
>  static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
> +					unsigned int num_ref_pics,
>  					struct video_frame *dpb_frames,
>  					unsigned int ref_frames_nb,
>  					unsigned int with_earlier_poc_nb)
> @@ -251,13 +260,17 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
>  	u32 value, aux_addr;
>  	int with_later_poc_nb;
>  	unsigned int i, k;
> +	size_t size;
> +
> +	size = num_ref_pics * 4 * 8;
> +	memset(vde->iram, 0, size);

I can't get behind the magical size calculation...  :(

regards,
dan carpenter
