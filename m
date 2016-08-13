Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53389 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbcHNJRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 05:17:11 -0400
Subject: Re: [PATCH v3 12/14] media: platform: pxa_camera: add debug register
 access
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
 <1470684652-16295-13-git-send-email-robert.jarzmik@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c0b25215-b11a-c4bc-fa08-dbd55470daa7@xs4all.nl>
Date: Sat, 13 Aug 2016 20:46:58 +0200
MIME-Version: 1.0
In-Reply-To: <1470684652-16295-13-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2016 09:30 PM, Robert Jarzmik wrote:
> Add pxa_camera registers access through advanced video debugging.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 57 ++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index 1e15734ae287..20340489e07e 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -1344,6 +1344,58 @@ static int pxa_camera_check_frame(u32 width, u32 height)
>  		(width & 0x01);
>  }
>  
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int pxac_vidioc_g_register(struct file *file, void *priv,
> +				  struct v4l2_dbg_register *reg)
> +{
> +	struct pxa_camera_dev *pcdev = video_drvdata(file);
> +
> +	if (reg->reg > CIBR2)
> +		return -ERANGE;
> +
> +	reg->val = __raw_readl(pcdev->base + reg->reg);
> +	reg->size = sizeof(__u32);
> +	return 0;
> +}
> +
> +static int pxac_vidioc_s_register(struct file *file, void *priv,
> +				  const struct v4l2_dbg_register *reg)
> +{
> +	struct pxa_camera_dev *pcdev = video_drvdata(file);
> +
> +	if (reg->reg > CIBR2)
> +		return -ERANGE;
> +	if (reg->size != sizeof(__u32))
> +		return -EINVAL;
> +	__raw_writel(reg->val, pcdev->base + reg->reg);
> +	return 0;
> +}
> +
> +static int pxac_vidioc_g_chip_info(struct file *file, void *fh,
> +				   struct v4l2_dbg_chip_info *chip)
> +{
> +	struct pxa_camera_dev *pcdev = video_drvdata(file);
> +
> +	switch (chip->match.type) {
> +	case V4L2_CHIP_MATCH_BRIDGE:
> +		if (chip->match.addr > 0)
> +			return -EINVAL;
> +
> +		strlcpy(chip->name, "pxa-camera", sizeof(chip->name));
> +		return 0;
> +	case V4L2_CHIP_MATCH_SUBDEV:
> +		if (chip->match.addr > 0)
> +			return -EINVAL;
> +
> +		strlcpy(chip->name, pcdev->sensor->name, sizeof(chip->name));
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}

You shouldn't need this g_chip_info function, it should be handled automatically
by the v4l2 core. Just drop it.

> +
> +#endif
> +
>  static int pxac_vidioc_enum_fmt_vid_cap(struct file *filp, void  *priv,
>  					struct v4l2_fmtdesc *f)
>  {
> @@ -1594,6 +1646,11 @@ static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
>  	.vidioc_expbuf			= vb2_ioctl_expbuf,
>  	.vidioc_streamon		= vb2_ioctl_streamon,
>  	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.vidioc_g_register		= pxac_vidioc_g_register,
> +	.vidioc_s_register		= pxac_vidioc_s_register,
> +	.vidioc_g_chip_info		= pxac_vidioc_g_chip_info,
> +#endif
>  };
>  
>  static struct v4l2_clk_ops pxa_camera_mclk_ops = {
> 

Regards,

	Hans
