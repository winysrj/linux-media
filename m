Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36993 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab1IXVDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 17:03:53 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Sun, 25 Sep 2011 02:33:44 +0530
Subject: RE: [PATCH] omap_vout: Add poll() support
Message-ID: <19F8576C6E063C45BE387C64729E739404EC942773@dbde02.ent.ti.com>
References: <1314181669-10263-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1314181669-10263-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Wednesday, August 24, 2011 3:58 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org
> Subject: [PATCH] omap_vout: Add poll() support
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap/omap_vout.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index a1f3c0f..cfc1705 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -1184,6 +1184,15 @@ static void omap_vout_buffer_release(struct
> videobuf_queue *q,
>  /*
>   *  File operations
>   */
> +static unsigned int omap_vout_poll(struct file *file,
> +				   struct poll_table_struct *wait)
> +{
> +	struct omap_vout_device *vout = file->private_data;
> +	struct videobuf_queue *q = &vout->vbq;
> +
> +	return videobuf_poll_stream(file, q, wait);
> +}
> +
>  static void omap_vout_vm_open(struct vm_area_struct *vma)
>  {
>  	struct omap_vout_device *vout = vma->vm_private_data;
> @@ -2175,6 +2184,7 @@ static const struct v4l2_ioctl_ops vout_ioctl_ops =
> {
> 
>  static const struct v4l2_file_operations omap_vout_fops = {
>  	.owner 		= THIS_MODULE,
> +	.poll		= omap_vout_poll,
>  	.unlocked_ioctl	= video_ioctl2,
>  	.mmap 		= omap_vout_mmap,
>  	.open 		= omap_vout_open,

Acked-By: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav

> --
> 1.7.3.4

