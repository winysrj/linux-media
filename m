Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1JNUDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 16:03:12 -0400
Message-ID: <4E98957A.1070009@infradead.org>
Date: Fri, 14 Oct 2011 17:03:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Mijhail Moreyra <mijhail.moreyra@gmail.com>,
	Abylai Ospan <aospan@netup.ru>
Subject: Re: [GIT PATCHES FOR 3.2] cx23885 alsa cleaned and prepaired
References: <201110101752.11536.liplianin@me.by>
In-Reply-To: <201110101752.11536.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-10-2011 11:52, Igor M. Liplianin escreveu:
> Hi Mauro and Steven,
> 
> It's been a long time since cx23885-alsa pull was requested.
> To speed things up I created a git branch where I put the patches.
> Some patches merged, like introduce then correct checkpatch compliance
> or convert spinlock to mutex and back to spinlock, insert printk then remove printk as well.
> Minor corrections from me was silently merged, for major I created additional patches.
> 
> Hope it helps.
> 
> The following changes since commit e30528854797f057aa6ffb6dc9f890e923c467fd:
> 
>   [media] it913x-fe changes to power up and down of tuner (2011-10-08 08:03:27 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/liplianin/media_tree.git cx23885-alsa-clean-2
> 
> Igor M. Liplianin (2):
>       cx23885: videobuf: Remove the videobuf_sg_dma_map/unmap functions
>       cx25840-audio: fix missing state declaration
> 
> Mijhail Moreyra (6):
>       cx23885: merge mijhail's header changes for alsa
>       cx23885: ALSA support
>       cx23885: core changes requireed for ALSA
>       cx23885: add definitions for HVR1500 to support audio
>       cx23885: correct the contrast, saturation and hue controls
>       cx23885: hooks the alsa changes into the video subsystem

> patches/0009-cx23885-hooks-the-alsa-changes-into-the-video-subsys.patch
> From ee1eadb6f02f9c1b6d14e049874ad883d752ea7e Mon Sep 17 00:00:00 2001
> From: Mijhail Moreyra <mijhail.moreyra@gmail.com>
> Date: Mon, 10 Oct 2011 17:09:53 +0300
> Subject: cx23885: hooks the alsa changes into the video subsystem
> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> Priority: normal
> 
> Signed-off-by: Mijhail Moreyra <mijhail.moreyra@gmail.com>
> Signed-off-by: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/video/cx23885/cx23885-video.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
> index 0c463f9..acd6e0c 100644
> --- a/drivers/media/video/cx23885/cx23885-video.c
> +++ b/drivers/media/video/cx23885/cx23885-video.c
> @@ -37,6 +37,8 @@
>  #include "cx23885-ioctl.h"
>  #include "tuner-xc2028.h"
>  
> +#include <media/cx25840.h>
> +
>  MODULE_DESCRIPTION("v4l2 driver module for cx23885 based TV cards");
>  MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
>  MODULE_LICENSE("GPL");
> @@ -884,8 +886,9 @@ static int cx23885_get_control(struct cx23885_dev *dev,
>  static int cx23885_set_control(struct cx23885_dev *dev,
>  	struct v4l2_control *ctl)
>  {
> -	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)"
> -		" (disabled - no action)\n", __func__);
> +	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)\n", __func__);
> +	call_all(dev, core, s_ctrl, ctl);
> +
>  	return 0;
>  }
>  
> @@ -1220,11 +1223,9 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>  	if (0 != t->index)
>  		return -EINVAL;
>  
> +	memset(t, 0, sizeof(*t));

No. The V4L2 core already cleans the parameters that are meant to be
returned to userspace.

In particular, this will break part of the tuner logic, as now the V4L2 core
fills t->type, and tuner-core relies on that.

If the rest of the patches are ok, I'll add a patch on the series removing this.

Regards,
Mauro
