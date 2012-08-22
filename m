Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2845 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2HVLsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 07:48:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv8 13/26] v4l: vivi: support for dmabuf importing
Date: Wed, 22 Aug 2012 13:47:56 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	dmitriyz@google.com, s.nawrocki@samsung.com, k.debski@samsung.com
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-14-git-send-email-t.stanislaws@samsung.com> <201208221256.30179.hverkuil@xs4all.nl>
In-Reply-To: <201208221256.30179.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221347.56879.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed August 22 2012 12:56:30 Hans Verkuil wrote:
> On Tue August 14 2012 17:34:43 Tomasz Stanislawski wrote:
> > This patch enhances VIVI driver with a support for importing a buffer
> > from DMABUF file descriptors.
> 
> Thanks for adding DMABUF support to vivi.
> 
> What would be great is if DMABUF support is also added to mem2mem_testdev.
> It would make an excellent test case to take the vivi output, pass it
> through mem2mem_testdev, and finally output the image using the gpu, all
> using dmabuf.
> 
> It's also very useful for application developers to test dmabuf support
> without requiring special hardware (other than a dmabuf-enabled gpu
> driver).

Adding VIDIOC_EXPBUF support to vivi and mem2mem_testdev would be
welcome as well for the same reasons.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/video/Kconfig |    1 +
> >  drivers/media/video/vivi.c  |    2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index 966954d..8fa81be 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -653,6 +653,7 @@ config VIDEO_VIVI
> >  	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
> >  	select FONT_8x16
> >  	select VIDEOBUF2_VMALLOC
> > +	select DMA_SHARED_BUFFER
> >  	default n
> >  	---help---
> >  	  Enables a virtual video driver. This device shows a color bar
> > diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> > index a6351c4..37d8fd4 100644
> > --- a/drivers/media/video/vivi.c
> > +++ b/drivers/media/video/vivi.c
> > @@ -1308,7 +1308,7 @@ static int __init vivi_create_instance(int inst)
> >  	q = &dev->vb_vidq;
> >  	memset(q, 0, sizeof(dev->vb_vidq));
> >  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > -	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
> > +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> >  	q->drv_priv = dev;
> >  	q->buf_struct_size = sizeof(struct vivi_buffer);
> >  	q->ops = &vivi_video_qops;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
