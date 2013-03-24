Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3507 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3CXKNS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 06:13:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [REVIEWv2 PATCH 4/6] v4l2: add const to argument of write-only s_register ioctl.
Date: Sun, 24 Mar 2013 11:12:37 +0100
Cc: linux-media@vger.kernel.org,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
References: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl> <1363615925-19507-5-git-send-email-hverkuil@xs4all.nl> <20130324070703.63a4e918@redhat.com>
In-Reply-To: <20130324070703.63a4e918@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303241112.37231.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 24 2013 11:07:03 Mauro Carvalho Chehab wrote:
> Em Mon, 18 Mar 2013 15:12:03 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This ioctl is defined as IOW, so pass the argument as const.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> ...
> 
> > diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
> > index 080f179..15e08aa 100644
> > --- a/drivers/media/pci/ivtv/ivtv-ioctl.c
> > +++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
> > @@ -711,49 +711,50 @@ static int ivtv_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_i
> >  }
> >  
> >  #ifdef CONFIG_VIDEO_ADV_DEBUG
> > -static int ivtv_itvc(struct ivtv *itv, unsigned int cmd, void *arg)
> > +static volatile u8 __iomem *ivtv_itvc_start(struct ivtv *itv,
> > +		const struct v4l2_dbg_register *regs)
> >  {
> > -	struct v4l2_dbg_register *regs = arg;
> > -	volatile u8 __iomem *reg_start;
> > -
> > -	if (!capable(CAP_SYS_ADMIN))
> > -		return -EPERM;
> >  	if (regs->reg >= IVTV_REG_OFFSET && regs->reg < IVTV_REG_OFFSET + IVTV_REG_SIZE)
> > -		reg_start = itv->reg_mem - IVTV_REG_OFFSET;
> > -	else if (itv->has_cx23415 && regs->reg >= IVTV_DECODER_OFFSET &&
> > +		return itv->reg_mem - IVTV_REG_OFFSET;
> > +	if (itv->has_cx23415 && regs->reg >= IVTV_DECODER_OFFSET &&
> >  			regs->reg < IVTV_DECODER_OFFSET + IVTV_DECODER_SIZE)
> > -		reg_start = itv->dec_mem - IVTV_DECODER_OFFSET;
> > -	else if (regs->reg < IVTV_ENCODER_SIZE)
> > -		reg_start = itv->enc_mem;
> > -	else
> > -		return -EINVAL;
> > -
> > -	regs->size = 4;
> > -	if (cmd == VIDIOC_DBG_G_REGISTER)
> > -		regs->val = readl(regs->reg + reg_start);
> > -	else
> > -		writel(regs->val, regs->reg + reg_start);
> > -	return 0;
> > +		return itv->dec_mem - IVTV_DECODER_OFFSET;
> > +	if (regs->reg < IVTV_ENCODER_SIZE)
> > +		return itv->enc_mem;
> > +	return NULL;
> >  }
> >  
> >  static int ivtv_g_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
> >  {
> >  	struct ivtv *itv = fh2id(fh)->itv;
> >  
> > -	if (v4l2_chip_match_host(&reg->match))
> > -		return ivtv_itvc(itv, VIDIOC_DBG_G_REGISTER, reg);
> > +	if (v4l2_chip_match_host(&reg->match)) {
> > +		volatile u8 __iomem *reg_start = ivtv_itvc_start(itv, reg);
> > +
> > +		if (reg_start == NULL)
> > +			return -EINVAL;
> > +		reg->size = 4;
> > +		reg->val = readl(reg->reg + reg_start);
> > +		return 0;
> > +	}
> >  	/* TODO: subdev errors should not be ignored, this should become a
> >  	   subdev helper function. */
> >  	ivtv_call_all(itv, core, g_register, reg);
> >  	return 0;
> >  }
> >  
> > -static int ivtv_s_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
> > +static int ivtv_s_register(struct file *file, void *fh, const struct v4l2_dbg_register *reg)
> >  {
> >  	struct ivtv *itv = fh2id(fh)->itv;
> >  
> > -	if (v4l2_chip_match_host(&reg->match))
> > -		return ivtv_itvc(itv, VIDIOC_DBG_S_REGISTER, reg);
> > +	if (v4l2_chip_match_host(&reg->match)) {
> > +		volatile u8 __iomem *reg_start = ivtv_itvc_start(itv, reg);
> > +
> > +		if (reg_start == NULL)
> > +			return -EINVAL;
> > +		writel(reg->val, reg->reg + reg_start);
> > +		return 0;
> > +	}
> >  	/* TODO: subdev errors should not be ignored, this should become a
> >  	   subdev helper function. */
> >  	ivtv_call_all(itv, core, s_register, reg);
> 
> I'm not convinced about the changes on ivtv. Why do you need volatile there?

It was using volatile before and as I told Laurent as well, I don't want to
mix changing volatile removal with adding const support.

> Also, as you're doing changes there that aren't that trivial, and are not
> just "add const argument", please split those non-trivial ivtv changes into
> a separate patch, and properly describe what you're doing and why.

OK, and I'll add a separate patch in that case to remove the volatile part.

> Also, having it on a separate patch helps to bisect it, if it ever brings
> any problem.

Regards,

	Hans
