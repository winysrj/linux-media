Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55233 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751205Ab3EMOX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 10:23:28 -0400
Date: Mon, 13 May 2013 10:25:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, mchehab@redhat.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] v4l: vb2: fix error return code in
 __vb2_init_fileio()
Message-ID: <20130513072535.GE6748@valkosipuli.retiisi.org.uk>
References: <CAPgLHd9ydkkQ_yOmhnU1awN08kBhiM-ZryGBqq8S0qisHkYvqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9ydkkQ_yOmhnU1awN08kBhiM-ZryGBqq8S0qisHkYvqA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

On Mon, May 13, 2013 at 01:48:45PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -EINVAL in the get kernel address error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7d833ee..7bd3ee6 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2193,8 +2193,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>  	 */
>  	for (i = 0; i < q->num_buffers; i++) {
>  		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
> -		if (fileio->bufs[i].vaddr == NULL)
> +		if (fileio->bufs[i].vaddr == NULL) {
> +			ret = -EINVAL;
>  			goto err_reqbufs;
> +		}
>  		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
>  	}
>  
> 

Nice patch!

Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
