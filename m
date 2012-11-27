Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410Ab2K0KQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 05:16:42 -0500
Date: Tue, 27 Nov 2012 11:16:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH 01/15] [media] marvell-ccic: use internal variable replace
 global frame stats variable
In-Reply-To: <1353677577-23962-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1211271110530.22273@axis700.grange>
References: <1353677577-23962-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert

On Fri, 23 Nov 2012, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch replaces the global frame stats variables by using
> internal variables in mcam_camera structure.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>

Thanks for doing this work! Looks good just one remark below.

> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c |   30 ++++++++++-------------
>  drivers/media/platform/marvell-ccic/mcam-core.h |    9 +++++++
>  2 files changed, 22 insertions(+), 17 deletions(-)

[snip]

> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index bd6acba..e226de4 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -73,6 +73,14 @@ static inline int mcam_buffer_mode_supported(enum mcam_buffer_mode mode)
>  	}
>  }
>  
> +/*
> + * Basic frame states
> + */
> +struct mmp_frame_state {

I think this should be "struct mcam_frame_state" - don't think we need to 
introduce a whole new namespace in this header just because of this 
struct.

> +	unsigned int frames;
> +	unsigned int singles;
> +	unsigned int delivered;
> +};
>  
>  /*
>   * A description of one of our devices.
> @@ -108,6 +116,7 @@ struct mcam_camera {
>  	unsigned long flags;		/* Buffer status, mainly (dev_lock) */
>  	int users;			/* How many open FDs */
>  
> +	struct mmp_frame_state frame_state;	/* Frame state counter */
>  	/*
>  	 * Subsystem structures.
>  	 */
> -- 
> 1.7.9.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
