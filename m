Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876Ab1LPIrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 03:47:15 -0500
Date: Fri, 16 Dec 2011 09:47:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, saaguirre@ti.com,
	mchehab@infradead.org
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
In-Reply-To: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1112160909470.6572@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Fri, 16 Dec 2011, Javier Martin wrote:

> Some v4l-subdevs such as tvp5150 have multiple
> inputs. This patch allows the user of a soc-camera
> device to select between them.

Sure, we can support it. But I've got a couple of remarks:

First question: you probably also want to patch soc_camera_g_input() and 
soc_camera_enum_input(). But no, I do not know how. The video subdevice 
operations do not seem to provide a way to query subdevice routing 
capabilities, so, I've got no idea how we're supposed to support 
enum_input(). There is a g_input_status() method, but I'm not sure about 
its semantics. Would it return an error like -EINVAL on an unsupported 
index?

Secondly, I would prefer to keep the current behaviour per default. I.e., 
if the subdevice doesn't implement routing- / input-related operations, we 
should act as before - assume input 0 and return success.

Thanks
Guennadi

> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/soc_camera.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index b72580c..1cea1a9 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -235,10 +235,10 @@ static int soc_camera_g_input(struct file *file, void *priv, unsigned int *i)
>  
>  static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
>  {
> -	if (i > 0)
> -		return -EINVAL;
> +	struct soc_camera_device *icd = file->private_data;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  
> -	return 0;
> +	return v4l2_subdev_call(sd, video, s_routing, i, 0, 0);
>  }
>  
>  static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
