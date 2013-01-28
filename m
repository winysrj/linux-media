Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4617 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3A1OTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 09:19:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 8/7] saa7134: v4l2-compliance: remove bogus g_parm
Date: Mon, 28 Jan 2013 15:19:34 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org> <201301281511.50411.linux@rainbow-software.org>
In-Reply-To: <201301281511.50411.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281519.34469.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 28 2013 15:11:50 Ondrej Zary wrote:
> Make saa7134 driver more V4L2 compliant: remove empty g_parm function
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/pci/saa7134/saa7134-video.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c 
> b/drivers/media/pci/saa7134/saa7134-video.c
> index b63cdad..3e88041 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -2232,12 +2232,6 @@ static int saa7134_streamoff(struct file *file, void 
> *priv,
>  	return 0;
>  }
>  
> -static int saa7134_g_parm(struct file *file, void *fh,
> -				struct v4l2_streamparm *parm)
> -{
> -	return 0;
> -}
> -
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  static int vidioc_g_register (struct file *file, void *priv,
>  			      struct v4l2_dbg_register *reg)
> @@ -2390,7 +2384,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
>  	.vidioc_g_fbuf			= saa7134_g_fbuf,
>  	.vidioc_s_fbuf			= saa7134_s_fbuf,
>  	.vidioc_overlay			= saa7134_overlay,
> -	.vidioc_g_parm			= saa7134_g_parm,
>  	.vidioc_g_frequency		= saa7134_g_frequency,
>  	.vidioc_s_frequency		= saa7134_s_frequency,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> 
