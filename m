Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53967 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2LPQ4C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:56:02 -0500
Date: Sun, 16 Dec 2012 09:56:01 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 15/15] [media] marvell-ccic: add 3 frame buffers
 support in DMA_CONTIG mode
Message-ID: <20121216095601.4a086356@hpe.lwn.net>
In-Reply-To: <1355565484-15791-16-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-16-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:58:04 +0800
Albert Wang <twang13@marvell.com> wrote:

> This patch adds support of 3 frame buffers in DMA-contiguous mode.
> 
> In current DMA_CONTIG mode, only 2 frame buffers can be supported.
> Actually, Marvell CCIC can support at most 3 frame buffers.
> 
> Currently 2 frame buffers mode will be used by default.
> To use 3 frame buffers mode, can do:
>   define MAX_FRAME_BUFS 3
> in mcam-core.h

Now that the code supports three buffers properly, is there any reason not
to use that mode by default?

Did you test that it works properly if allocation of the third buffer fails?

Otherwise looks OK except for one thing:

> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 765d47c..9bf31c8 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -62,6 +62,13 @@ enum mcam_state {
>  #define MAX_DMA_BUFS 3
>  
>  /*
> + * CCIC can support at most 3 frame buffers in DMA_CONTIG buffer mode
> + * 2 - Use Two Buffers mode
> + * 3 - Use Three Buffers mode
> + */
> +#define MAX_FRAME_BUFS 2 /* Current marvell-ccic used Two Buffers mode */
> +
> +/*
>   * Different platforms work best with different buffer modes, so we
>   * let the platform pick.
>   */
> @@ -99,6 +106,10 @@ struct mcam_frame_state {
>  	unsigned int frames;
>  	unsigned int singles;
>  	unsigned int delivered;
> +	/*
> +	 * Only usebufs == 2 can enter single buffer mode
> +	 */
> +	unsigned int usebufs;
>  };

What is the purpose of the "usebufs" field?  The code maintains it in
various places, but I don't see anywhere that actually uses that value for
anything.

Thanks,

jon
