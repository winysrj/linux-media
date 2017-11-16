Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58542 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933981AbdKPJeY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 04:34:24 -0500
Date: Thu, 16 Nov 2017 11:34:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: sh_mobile_ceu: Return buffers on streamoff()
Message-ID: <20171116093421.ilgbtsvsqffutiql@valkosipuli.retiisi.org.uk>
References: <1510768752-7588-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510768752-7588-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for the patch. I think you could add this to v2 of your related set;
that way it'll be easy to get the dependencies right. I don't think this is
urgent either...

On Wed, Nov 15, 2017 at 06:59:12PM +0100, Jacopo Mondi wrote:
> videobuf2 core reports an error when not all buffers have been returned
> to the framework:
> 
> drivers/media/v4l2-core/videobuf2-core.c:1651
> WARN_ON(atomic_read(&q->owned_by_drv_count))
> 
> Fix this returning all buffers currently in capture queue.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> ---
> 
> I know I'm working to get rid of this driver, but while I was trying to have
> it working again on mainline, I found this had to be fixed.
> 
> Thanks
>   j
> 
> ---
>  drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> index 36762ec..9180a1d 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> @@ -451,13 +451,18 @@ static void sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct sh_mobile_ceu_dev *pcdev = ici->priv;
>  	struct list_head *buf_head, *tmp;
> +	struct vb2_v4l2_buffer *vbuf;
> 
>  	spin_lock_irq(&pcdev->lock);
> 
>  	pcdev->active = NULL;
> 
> -	list_for_each_safe(buf_head, tmp, &pcdev->capture)
> +	list_for_each_safe(buf_head, tmp, &pcdev->capture) {
> +		vbuf = &list_entry(buf_head, struct sh_mobile_ceu_buffer,
> +				   queue)->vb;
> +		vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);

This should be VB2_BUF_STATE_ERROR, as the hardware hasn't actually
processed them, right?

>  		list_del_init(buf_head);
> +	}
> 
>  	spin_unlock_irq(&pcdev->lock);
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
