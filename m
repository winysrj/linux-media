Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:51795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1A2TQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 14:16:51 -0500
Date: Sat, 29 Jan 2011 20:16:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	linux-arm-kernel@lists.infradead.org, Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 1/2] v4l: soc-camera: start stream after queueing the
 buffers
In-Reply-To: <1296031789-1721-2-git-send-email-agust@denx.de>
Message-ID: <Pine.LNX.4.64.1101292015140.26696@axis700.grange>
References: <1296031789-1721-1-git-send-email-agust@denx.de>
 <1296031789-1721-2-git-send-email-agust@denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 26 Jan 2011, Anatolij Gustschin wrote:

> Some camera systems have strong requirement for capturing
> an exact number of frames after starting the stream and do
> not tolerate losing captured frames. By starting the stream
> after the videobuf has queued the buffers, we ensure that
> no frame will be lost.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  drivers/media/video/soc_camera.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index a66811b..7299de0 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -646,11 +646,11 @@ static int soc_camera_streamon(struct file *file, void *priv,
>  	if (icd->streamer != file)
>  		return -EBUSY;
>  
> -	v4l2_subdev_call(sd, video, s_stream, 1);
> -
>  	/* This calls buf_queue from host driver's videobuf_queue_ops */
>  	ret = videobuf_streamon(&icd->vb_vidq);
>  
> +	v4l2_subdev_call(sd, video, s_stream, 1);
> +

After a bit more testing I'll make this to

+	if (!ret)
+		v4l2_subdev_call(sd, video, s_stream, 1);
+

Ok? Or you can submit a v2 yourself, if you like - when you fix the 
comment in the other patch from this series.

>  	return ret;
>  }
>  
> -- 
> 1.7.1

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
