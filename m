Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:39919 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756010AbbCCPVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 10:21:31 -0500
Message-ID: <54F5D16A.7090807@xs4all.nl>
Date: Tue, 03 Mar 2015 16:21:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	adi-buildroot-devel@lists.sourceforge.net
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/15] media: blackfin: bfin_capture: improve buf_prepare()
 callback
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com> <1424544001-19045-5-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-5-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/2015 07:39 PM, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch improves the buf_prepare() callback.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 332f8c9..8f62a84 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -305,16 +305,12 @@ static int bcap_queue_setup(struct vb2_queue *vq,
>  static int bcap_buffer_prepare(struct vb2_buffer *vb)
>  {
>  	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
> -	struct bcap_buffer *buf = to_bcap_vb(vb);
> -	unsigned long size;
>  
> -	size = bcap_dev->fmt.sizeimage;
> -	if (vb2_plane_size(vb, 0) < size) {
> -		v4l2_err(&bcap_dev->v4l2_dev, "buffer too small (%lu < %lu)\n",
> -				vb2_plane_size(vb, 0), size);

I would keep this error. Since you need to update patches 4 & 5 anyway to
improve the commit message, it's probably good to reinstate this.

Regards,

	Hans

> +	vb2_set_plane_payload(vb, 0, bcap_dev->fmt.sizeimage);
> +	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
>  		return -EINVAL;
> -	}
> -	vb2_set_plane_payload(&buf->vb, 0, size);
> +
> +	vb->v4l2_buf.field = bcap_dev->fmt.field;
>  
>  	return 0;
>  }
> 

