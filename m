Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57687 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbFYNLZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 09:11:25 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQI00J4G4N0JTB0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Jun 2015 14:11:24 +0100 (BST)
Message-id: <558BFDED.1090006@samsung.com>
Date: Thu, 25 Jun 2015 15:11:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>, kamil@wypas.org,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/2] [media] v4l2-mem2mem: set the queue owner field just
 as vb2_ioctl_reqbufs does
References: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Philipp,

On 25/06/15 12:01, Philipp Zabel wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index dc853e5..511caaa 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -357,9 +357,16 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  		     struct v4l2_requestbuffers *reqbufs)
>  {
>  	struct vb2_queue *vq;
> +	int ret;
>  
>  	vq = v4l2_m2m_get_vq(m2m_ctx, reqbufs->type);
> -	return vb2_reqbufs(vq, reqbufs);
> +	ret = vb2_reqbufs(vq, reqbufs);
> +	/* If count == 0, then the owner has released all buffers and he
> +	   is no longer owner of the queue. Otherwise we have a new owner. */
> +	if (ret == 0)
> +		vq->owner = reqbufs->count ? file->private_data : NULL;
> +
> +	return ret;
>  }

How about modifying v4l2_m2m_ioctl_reqbufs() instead ?

Moreover, does it really makes sense when a new m2m device context
is being created during each video device open()?

Regards,
Sylwester
