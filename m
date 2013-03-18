Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33326 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3CRXTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 19:19:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 4/6] v4l2: add const to argument of write-only s_register ioctl.
Date: Tue, 19 Mar 2013 00:20 +0100
Message-ID: <3012858.ncv28K4OCe@avalon>
In-Reply-To: <1363615925-19507-5-git-send-email-hverkuil@xs4all.nl>
References: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl> <1363615925-19507-5-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Monday 18 March 2013 15:12:03 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This ioctl is defined as IOW, so pass the argument as const.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

[snip]

> diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c
> b/drivers/media/pci/ivtv/ivtv-ioctl.c index 080f179..15e08aa 100644
> --- a/drivers/media/pci/ivtv/ivtv-ioctl.c
> +++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
> @@ -711,49 +711,50 @@ static int ivtv_g_chip_ident(struct file *file, void
> *fh, struct v4l2_dbg_chip_i }
> 
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> -static int ivtv_itvc(struct ivtv *itv, unsigned int cmd, void *arg)
> +static volatile u8 __iomem *ivtv_itvc_start(struct ivtv *itv,
> +		const struct v4l2_dbg_register *regs)

I haven't changed my mind since v1, I still don't think you need a volatile 
here :-)

>  {
> -	struct v4l2_dbg_register *regs = arg;
> -	volatile u8 __iomem *reg_start;
> -
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
>  	if (regs->reg >= IVTV_REG_OFFSET && regs->reg < IVTV_REG_OFFSET +
> IVTV_REG_SIZE) -		reg_start = itv->reg_mem - IVTV_REG_OFFSET;
> -	else if (itv->has_cx23415 && regs->reg >= IVTV_DECODER_OFFSET &&
> +		return itv->reg_mem - IVTV_REG_OFFSET;
> +	if (itv->has_cx23415 && regs->reg >= IVTV_DECODER_OFFSET &&
>  			regs->reg < IVTV_DECODER_OFFSET + IVTV_DECODER_SIZE)
> -		reg_start = itv->dec_mem - IVTV_DECODER_OFFSET;
> -	else if (regs->reg < IVTV_ENCODER_SIZE)
> -		reg_start = itv->enc_mem;
> -	else
> -		return -EINVAL;
> -
> -	regs->size = 4;
> -	if (cmd == VIDIOC_DBG_G_REGISTER)
> -		regs->val = readl(regs->reg + reg_start);
> -	else
> -		writel(regs->val, regs->reg + reg_start);
> -	return 0;
> +		return itv->dec_mem - IVTV_DECODER_OFFSET;
> +	if (regs->reg < IVTV_ENCODER_SIZE)
> +		return itv->enc_mem;
> +	return NULL;
>  }
> 
>  static int ivtv_g_register(struct file *file, void *fh, struct
> v4l2_dbg_register *reg) {
>  	struct ivtv *itv = fh2id(fh)->itv;
> 
> -	if (v4l2_chip_match_host(&reg->match))
> -		return ivtv_itvc(itv, VIDIOC_DBG_G_REGISTER, reg);
> +	if (v4l2_chip_match_host(&reg->match)) {
> +		volatile u8 __iomem *reg_start = ivtv_itvc_start(itv, reg);
> +
> +		if (reg_start == NULL)
> +			return -EINVAL;
> +		reg->size = 4;
> +		reg->val = readl(reg->reg + reg_start);
> +		return 0;
> +	}
>  	/* TODO: subdev errors should not be ignored, this should become a
>  	   subdev helper function. */
>  	ivtv_call_all(itv, core, g_register, reg);
>  	return 0;
>  }
> 
> -static int ivtv_s_register(struct file *file, void *fh, struct
> v4l2_dbg_register *reg) +static int ivtv_s_register(struct file *file, void
> *fh, const struct v4l2_dbg_register *reg) {
>  	struct ivtv *itv = fh2id(fh)->itv;
> 
> -	if (v4l2_chip_match_host(&reg->match))
> -		return ivtv_itvc(itv, VIDIOC_DBG_S_REGISTER, reg);
> +	if (v4l2_chip_match_host(&reg->match)) {
> +		volatile u8 __iomem *reg_start = ivtv_itvc_start(itv, reg);
> +
> +		if (reg_start == NULL)
> +			return -EINVAL;
> +		writel(reg->val, reg->reg + reg_start);
> +		return 0;
> +	}
>  	/* TODO: subdev errors should not be ignored, this should become a
>  	   subdev helper function. */
>  	ivtv_call_all(itv, core, s_register, reg);

-- 
Regards,

Laurent Pinchart

