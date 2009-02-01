Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55369 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753188AbZBATHe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 14:07:34 -0500
Date: Sun, 1 Feb 2009 20:07:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] soc_camera: Add FLDPOL flags
In-Reply-To: <utz7hm9r1.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902012003030.17985@axis700.grange>
References: <utz7hm9r1.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jan 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  include/media/soc_camera.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 7440d92..2c7ecdf 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -231,6 +231,8 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
>  #define SOCAM_PCLK_SAMPLE_FALLING	(1 << 13)
>  #define SOCAM_DATA_ACTIVE_HIGH		(1 << 14)
>  #define SOCAM_DATA_ACTIVE_LOW		(1 << 15)
> +#define SOCAM_FLDPOL_ACTIVE_HIGH	(1 << 16)
> +#define SOCAM_FLDPOL_ACTIVE_LOW		(1 << 17)
>  
>  #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
>  			      SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \

"FLDPOL" is the name of a field in the register, and it means "field ID 
polarity," i.e., the polarity of the field ID signal. Hence the name 
you're proposing reads: "field ID polarity active {low,high}," which seems 
redundant to me. What about SOCAM_FIELD_ID_ACTIVE_{HIGH,LOW}? Following 
the scheme "SOCAM_<signal name>_ACTIVE_*."

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
