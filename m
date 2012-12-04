Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab2LDG4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 01:56:38 -0500
Date: Tue, 4 Dec 2012 07:56:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Libin Yang <lbyang@marvell.com>
cc: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH 06/15] [media] marvell-ccic: add new formats support for
 marvell-ccic driver
In-Reply-To: <A63A0DC671D719488CD1A6CD8BDC16CF230ABFA3AE@SC-VEXCH4.marvell.com>
Message-ID: <Pine.LNX.4.64.1212040753300.26918@axis700.grange>
References: <1353677621-24143-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271218120.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C8E9@SC-VEXCH1.marvell.com>
 <A63A0DC671D719488CD1A6CD8BDC16CF230ABFA3AE@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Libin

On Mon, 3 Dec 2012, Libin Yang wrote:

> Hi Guennadi,
> 
> When I'm refining the patch based on your comments, I met an issue. 
> Could you please help me?
> 
> [snip]
> 
> 
> >>> -
> >>>  /*
> >>>   * Configure the controller for operation; caller holds the
> >>>   * device mutex.
> >>> @@ -979,11 +1070,32 @@ static void mcam_vb_buf_queue(struct vb2_buffer
> >>> *vb)  {
> >>>  	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
> >>>  	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
> >>> +	struct v4l2_pix_format *fmt = &cam->pix_format;
> >>>  	unsigned long flags;
> >>>  	int start;
> >>> +	dma_addr_t dma_handle;
> >>> +	u32 base_size = fmt->width * fmt->height;
> >>
> >>Shouldn't you be just using bytesperline? Is stride != width * height supported?
> >>
> >We will update it.
> 
> [Libin] What I understand is width is the pixel number perline, so 
> bytesperline = width * BytePerPixel. This means bytesperline should 
> include Y data and UV data.
> 
> For example, for yuv420 legacy 8-bit, it transfers like below:
> U Y Y U Y Y U Y Y U Y Y ......
> V Y Y V Y Y V Y Y V Y Y ......
> 
> As each Y is one byte, so all Y data length is nuber_Y_per_line * 
> height. While the nuber_Y_per_line is the pixel_per_line, which is 
> fmt->width.
> 
> So for the planner, the first block is saving the Y data, whose length 
> is nuber_Y_per_line * height, which equals to fmt->width * height.
> 
> Do I understand correctly?
> 
> The base_size here means the size of Y data, so it should be fmt->width 
> * fmt->height.

Right, in this case you're right. Sorry for a misleading comment. Just a 
suggestion, if you prefer, you can keep the name, but maybe a name like 
pixel_count or pixel_num or pixel_per_frame would be clearer for that 
variable? But keeping the name is also ok with me.

> >>>
> >>>  	spin_lock_irqsave(&cam->dev_lock, flags);
> >>> +	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
