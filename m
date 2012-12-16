Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53884 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab2LPQtD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:49:03 -0500
Date: Sun, 16 Dec 2012 09:49:02 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 13/15] [media] marvell-ccic: add dma burst mode
 support in marvell-ccic driver
Message-ID: <20121216094902.15d74353@hpe.lwn.net>
In-Reply-To: <1355565484-15791-14-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-14-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:58:02 +0800
Albert Wang <twang13@marvell.com> wrote:

> This patch adds the dma burst size config support for marvell-ccic.
> Developer can set the dma burst size in specified board driver.

> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 57442e0..e1025f2 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -126,6 +126,7 @@ struct mcam_camera {
>  	short int use_smbus;	/* SMBUS or straight I2c? */
>  	enum mcam_buffer_mode buffer_mode;
>  
> +	int burst;

That's a register flag value, seems it should be unsigned (says the guy who
is admittedly sloppy about such things).

>  	int mclk_min;
>  	int mclk_src;
>  	int mclk_div;
> @@ -411,9 +412,9 @@ int mcam_soc_camera_host_register(struct mcam_camera *mcam);
>  #define   C1_DESC_3WORD   0x00000200	/* Three-word descriptors used */
>  #define	  C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
>  #define	  C1_ALPHA_SHFT	  20
> -#define	  C1_DMAB32	  0x00000000	/* 32-byte DMA burst */
> -#define	  C1_DMAB16	  0x02000000	/* 16-byte DMA burst */
> -#define	  C1_DMAB64	  0x04000000	/* 64-byte DMA burst */
> +#define	  C1_DMAB64	  0x00000000	/* 64-byte DMA burst */
> +#define	  C1_DMAB128	  0x02000000	/* 128-byte DMA burst */
> +#define	  C1_DMAB256	  0x04000000	/* 256-byte DMA burst */

Interesting, did I just get those wrong somehow?  Or might they have been
different in the Cafe days?  

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
