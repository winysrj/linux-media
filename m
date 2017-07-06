Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41590 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751854AbdGFIiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 04:38:08 -0400
Subject: Re: [PATCH 09/12] [media] vivid: mark vivid queues as ordered
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-10-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a4503642-4fb5-4b40-d9a4-6d9ce797aacd@xs4all.nl>
Date: Thu, 6 Jul 2017 10:37:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-10-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> To enable vivid to be used with explicit synchronization we need
> to mark its queues as ordered.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/vivid/vivid-core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index 8843170..c7bef90 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -1063,6 +1063,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
>  			V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> +		q->ordered = 1;
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_vid_cap_qops;
> @@ -1083,6 +1084,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
>  			V4L2_BUF_TYPE_VIDEO_OUTPUT;
>  		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
> +		q->ordered = 1;
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_vid_out_qops;
> @@ -1103,6 +1105,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->type = dev->has_raw_vbi_cap ? V4L2_BUF_TYPE_VBI_CAPTURE :
>  					      V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
>  		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> +		q->ordered = 1;
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_vbi_cap_qops;
> @@ -1123,6 +1126,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->type = dev->has_raw_vbi_out ? V4L2_BUF_TYPE_VBI_OUTPUT :
>  					      V4L2_BUF_TYPE_SLICED_VBI_OUTPUT;
>  		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
> +		q->ordered = 1;
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_vbi_out_qops;
> @@ -1142,6 +1146,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q = &dev->vb_sdr_cap_q;
>  		q->type = V4L2_BUF_TYPE_SDR_CAPTURE;
>  		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> +		q->ordered = 1;
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_sdr_cap_qops;
> 
