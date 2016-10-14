Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:56564 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753300AbcJNVUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 17:20:04 -0400
Date: Fri, 14 Oct 2016 16:18:39 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 29/57] [media] ti-vpe: don't break long lines
Message-ID: <20161014211839.GJ31296@ti.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
 <c3f436701af70b46f884a4dad4989176cec5e0c3.1476475771.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c3f436701af70b46f884a4dad4989176cec5e0c3.1476475771.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Benoit Parrot <bparrot@ti.com>

Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote on Fri [2016-Oct-14 17:20:17 -0300]:
> Due to the 80-cols checkpatch warnings, several strings
> were broken into multiple lines. This is not considered
> a good practice anymore, as it makes harder to grep for
> strings at the source code. So, join those continuation
> lines.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/ti-vpe/vpdma.c | 12 ++++--------
>  drivers/media/platform/ti-vpe/vpe.c   |  3 +--
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
> index 3e2e3a33e6ed..079a0c894d02 100644
> --- a/drivers/media/platform/ti-vpe/vpdma.c
> +++ b/drivers/media/platform/ti-vpe/vpdma.c
> @@ -466,8 +466,7 @@ static void dump_cfd(struct vpdma_cfd *cfd)
>  
>  	pr_debug("word2: payload_addr = 0x%08x\n", cfd->payload_addr);
>  
> -	pr_debug("word3: pkt_type = %d, direct = %d, class = %d, dest = %d, "
> -		"payload_len = %d\n", cfd_get_pkt_type(cfd),
> +	pr_debug("word3: pkt_type = %d, direct = %d, class = %d, dest = %d, payload_len = %d\n", cfd_get_pkt_type(cfd),
>  		cfd_get_direct(cfd), class, cfd_get_dest(cfd),
>  		cfd_get_payload_len(cfd));
>  }
> @@ -574,8 +573,7 @@ static void dump_dtd(struct vpdma_dtd *dtd)
>  	pr_debug("%s data transfer descriptor for channel %d\n",
>  		dir == DTD_DIR_OUT ? "outbound" : "inbound", chan);
>  
> -	pr_debug("word0: data_type = %d, notify = %d, field = %d, 1D = %d, "
> -		"even_ln_skp = %d, odd_ln_skp = %d, line_stride = %d\n",
> +	pr_debug("word0: data_type = %d, notify = %d, field = %d, 1D = %d, even_ln_skp = %d, odd_ln_skp = %d, line_stride = %d\n",
>  		dtd_get_data_type(dtd), dtd_get_notify(dtd), dtd_get_field(dtd),
>  		dtd_get_1d(dtd), dtd_get_even_line_skip(dtd),
>  		dtd_get_odd_line_skip(dtd), dtd_get_line_stride(dtd));
> @@ -586,8 +584,7 @@ static void dump_dtd(struct vpdma_dtd *dtd)
>  
>  	pr_debug("word2: start_addr = %pad\n", &dtd->start_addr);
>  
> -	pr_debug("word3: pkt_type = %d, mode = %d, dir = %d, chan = %d, "
> -		"pri = %d, next_chan = %d\n", dtd_get_pkt_type(dtd),
> +	pr_debug("word3: pkt_type = %d, mode = %d, dir = %d, chan = %d, pri = %d, next_chan = %d\n", dtd_get_pkt_type(dtd),
>  		dtd_get_mode(dtd), dir, chan, dtd_get_priority(dtd),
>  		dtd_get_next_chan(dtd));
>  
> @@ -595,8 +592,7 @@ static void dump_dtd(struct vpdma_dtd *dtd)
>  		pr_debug("word4: frame_width = %d, frame_height = %d\n",
>  			dtd_get_frame_width(dtd), dtd_get_frame_height(dtd));
>  	else
> -		pr_debug("word4: desc_write_addr = 0x%08x, write_desc = %d, "
> -			"drp_data = %d, use_desc_reg = %d\n",
> +		pr_debug("word4: desc_write_addr = 0x%08x, write_desc = %d, drp_data = %d, use_desc_reg = %d\n",
>  			dtd_get_desc_write_addr(dtd), dtd_get_write_desc(dtd),
>  			dtd_get_drop_data(dtd), dtd_get_use_desc(dtd));
>  
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 0189f7f7cb03..1cf4a4c1b899 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1263,8 +1263,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
>  	}
>  
>  	if (irqst0 | irqst1) {
> -		dev_warn(dev->v4l2_dev.dev, "Unexpected interrupt: "
> -			"INT0_STATUS0 = 0x%08x, INT0_STATUS1 = 0x%08x\n",
> +		dev_warn(dev->v4l2_dev.dev, "Unexpected interrupt: INT0_STATUS0 = 0x%08x, INT0_STATUS1 = 0x%08x\n",
>  			irqst0, irqst1);
>  	}
>  
> -- 
> 2.7.4
> 
> 
