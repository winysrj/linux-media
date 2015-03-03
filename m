Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35576 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbbCCOOC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 09:14:02 -0500
Date: Tue, 3 Mar 2015 11:13:56 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/15] media: blackfin: bfin_capture: improve
 queue_setup() callback
Message-ID: <20150303111356.1960ea78@recife.lan>
In-Reply-To: <1424544001-19045-6-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
	<1424544001-19045-6-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lad,


Em Sat, 21 Feb 2015 18:39:51 +0000
Lad Prabhakar <prabhakar.csengg@gmail.com> escreveu:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch improves the queue_setup() callback.

Please improve your comments. The above description doesn't tell
anything that it wasn't said before at the patch subject.

It "improves" how? Why?

Please fix the comments and resubmit this patch series.

Thanks,
Mauro

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 8f62a84..be0d0a2b 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -44,7 +44,6 @@
>  #include <media/blackfin/ppi.h>
>  
>  #define CAPTURE_DRV_NAME        "bfin_capture"
> -#define BCAP_MIN_NUM_BUF        2
>  
>  struct bcap_format {
>  	char *desc;
> @@ -292,11 +291,14 @@ static int bcap_queue_setup(struct vb2_queue *vq,
>  {
>  	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
>  
> -	if (*nbuffers < BCAP_MIN_NUM_BUF)
> -		*nbuffers = BCAP_MIN_NUM_BUF;
> +	if (fmt && fmt->fmt.pix.sizeimage < bcap_dev->fmt.sizeimage)
> +		return -EINVAL;
> +
> +	if (vq->num_buffers + *nbuffers < 2)
> +		*nbuffers = 2;
>  
>  	*nplanes = 1;
> -	sizes[0] = bcap_dev->fmt.sizeimage;
> +	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : bcap_dev->fmt.sizeimage;
>  	alloc_ctxs[0] = bcap_dev->alloc_ctx;
>  
>  	return 0;
