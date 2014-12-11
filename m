Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46011 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757878AbaLKO4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Dec 2014 09:56:40 -0500
Date: Thu, 11 Dec 2014 16:56:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Nikhil Devshatwar <nikhil.nd@ti.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] videobuf-dma-contig: NULL check for
 vb2_plane_cookie
Message-ID: <20141211145606.GS15559@valkosipuli.retiisi.org.uk>
References: <1418303242-8513-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418303242-8513-1-git-send-email-nikhil.nd@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nikhil,

On Thu, Dec 11, 2014 at 06:37:22PM +0530, Nikhil Devshatwar wrote:
> vb2_plane_cookie can return NULL if the plane no is greater than
> total no of planes or when mem_ops are absent.
> 
> Add NULL check to avoid NULL pointer crash in the kernel.
> 
> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
> ---
>  include/media/videobuf2-dma-contig.h |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
> index 8197f87..5efc56e 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -21,7 +21,10 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>  {
>  	dma_addr_t *addr = vb2_plane_cookie(vb, plane_no);
>  
> -	return *addr;
> +	if (addr == NULL)
> +		return addr;
> +	else
> +		return *addr;
>  }
>  
>  void *vb2_dma_contig_init_ctx(struct device *dev);

Should this happen? Wouldn't it be a bug somewhere, quite possibly the driver?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
