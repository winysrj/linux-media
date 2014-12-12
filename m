Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42119 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934054AbaLLJmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 04:42:33 -0500
Message-ID: <548AB881.2030206@xs4all.nl>
Date: Fri, 12 Dec 2014 10:42:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [REVIEW] au0828-vbi.c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

This is my review for au0828-vbi.c with your patch applied.

> /*
>    au0828-vbi.c - VBI driver for au0828
> 
>    Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
> 
>    This work was sponsored by GetWellNetwork Inc.
> 
>    This program is free software; you can redistribute it and/or modify
>    it under the terms of the GNU General Public License as published by
>    the Free Software Foundation; either version 2 of the License, or
>    (at your option) any later version.
> 
>    This program is distributed in the hope that it will be useful,
>    but WITHOUT ANY WARRANTY; without even the implied warranty of
>    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>    GNU General Public License for more details.
> 
>    You should have received a copy of the GNU General Public License
>    along with this program; if not, write to the Free Software
>    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
>    02110-1301, USA.
>  */
> 
> #include "au0828.h"
> 
> #include <linux/kernel.h>
> #include <linux/module.h>
> #include <linux/init.h>
> #include <linux/slab.h>
> 
> static unsigned int vbibufs = 5;
> module_param(vbibufs, int, 0644);
> MODULE_PARM_DESC(vbibufs, "number of vbi buffers, range 2-32");

Drop this vbibufs argument. It's bogus.

> 
> /* ------------------------------------------------------------------ */
> 
> static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
> 			   unsigned int *nbuffers, unsigned int *nplanes,
> 			   unsigned int sizes[], void *alloc_ctxs[])
> {
> 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
> 	unsigned long size;
> 
> 	if (fmt)
> 		size = fmt->fmt.pix.sizeimage;

It's a VBI format, so the size is

	fmt->fmt.vbi.samples_per_line *
                   (fmt->fmt.vbi.count[0] + fmt->fmt.vbi.count[1]);


> 	else
> 		size = dev->vbi_width * dev->vbi_height * 2;
> 
> 	if (0 == *nbuffers)
> 		*nbuffers = 32;
> 	if (*nbuffers < 2)
> 		*nbuffers = 2;
> 	if (*nbuffers > 32)
> 		*nbuffers = 32;

Remove these checks, they are not needed.

But if a fmt is passed in, then you *do* need to check if the new format size
is enough to store the vbi data. If not, return -EINVAL.

Test with v4l2-compliance -V0 -s.

> 
> 	*nplanes = 1;
> 	sizes[0] = size;
> 
> 	return 0;
> }
> 
> static int vbi_buffer_prepare(struct vb2_buffer *vb)
> {
> 	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
> 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
> 	unsigned long size;
> 
> 	size = dev->vbi_width * dev->vbi_height * 2;
> 
> 	if (vb2_plane_size(vb, 0) < size) {
> 		pr_err("%s data will not fit into plane (%lu < %lu)\n",
> 			__func__, vb2_plane_size(vb, 0), size);
> 		return -EINVAL;
> 	}
> 	vb2_set_plane_payload(&buf->vb, 0, size);
> 
> 	return 0;
> }
> 
> static void
> vbi_buffer_queue(struct vb2_buffer *vb)
> {
> 	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
> 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
> 	struct au0828_dmaqueue *vbiq = &dev->vbiq;
> 	unsigned long flags = 0;
> 
> 	buf->mem = vb2_plane_vaddr(vb, 0);
> 	buf->length = vb2_plane_size(vb, 0);
> 
> 	spin_lock_irqsave(&dev->slock, flags);
> 	list_add_tail(&buf->list, &vbiq->active);
> 	spin_unlock_irqrestore(&dev->slock, flags);
> }
> 
> struct vb2_ops au0828_vbi_qops = {
> 	.queue_setup     = vbi_queue_setup,
> 	.buf_prepare     = vbi_buffer_prepare,
> 	.buf_queue       = vbi_buffer_queue,
> 	.start_streaming = au0828_start_analog_streaming,
> 	.stop_streaming  = au0828_stop_vbi_streaming,
> 	.wait_prepare    = vb2_ops_wait_prepare,
> 	.wait_finish     = vb2_ops_wait_finish,
> };

Regards,

	Hans
