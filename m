Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52731
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750848AbdGGRbY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 13:31:24 -0400
Subject: Re: [PATCH 09/12] [media] vivid: mark vivid queues as ordered
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-10-gustavo@padovan.org>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <f8f17191-6217-ef1b-3b55-0dfdb485a7fc@osg.samsung.com>
Date: Fri, 7 Jul 2017 11:31:21 -0600
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-10-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2017 01:39 AM, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> To enable vivid to be used with explicit synchronization we need
> to mark its queues as ordered.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
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

How will the driver ensure ordered buffers? Are there more changes needed
in this driver?

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

thanks,
-- Shuah
