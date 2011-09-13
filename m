Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64856 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1IMLQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 07:16:00 -0400
Date: Tue, 13 Sep 2011 13:15:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
In-Reply-To: <CAHG8p1AYXg9zHjoYk6H1pGwUnSzmBTvazWDJuco8nQbFkHOtuw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109131312370.17902@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
 <Pine.LNX.4.64.1109130943021.17902@axis700.grange>
 <CAHG8p1AYXg9zHjoYk6H1pGwUnSzmBTvazWDJuco8nQbFkHOtuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Sep 2011, Scott Jiang wrote:

> >> +
> >> +struct bcap_format {
> >> +     u8 *desc;
> >> +     u32 pixelformat;
> >> +     enum v4l2_mbus_pixelcode mbus_code;
> >> +     int bpp; /* bytes per pixel */
> >
> > Don't you think you might have to process 12 bpp formats at some point,
> > like YUV 4:2:0, or NV12? Maybe better calculate in bits from the beginning?
> >
> sounds good, changed in v2
> 
> >
> > Does it really have to be fixed 32 bits? Seems a plane simple int would do
> > just fine.
> >
> users can't be negative, so I used u32

no, then use unsigned int.

> >> +struct bcap_fh {
> >> +     struct v4l2_fh fh;
> >> +     struct bcap_device *bcap_dev;
> >> +     /* indicates whether this file handle is doing IO */
> >> +     u8 io_allowed;
> >
> > bool
> >
> does kernel prefer bool now?

yes

> >> +     if (!bcap_dev->started)
> >> +             complete(&bcap_dev->comp);
> >> +     else {
> >> +             if (!list_empty(&bcap_dev->dma_queue)) {
> >> +                     bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
> >> +                                             struct bcap_buffer, list);
> >> +                     list_del(&bcap_dev->next_frm->list);
> >> +                     addr = vb2_plane_cookie(&bcap_dev->next_frm->vb, 0);
> >
> > I think, the direct use of vb2_plane_cookie() is discouraged.
> > vb2_dma_contig_plane_dma_addr() should work for you.
> >
> I guess you mean vb2_dma_contig_plane_paddr

no, in the current kernel it's vb2_dma_contig_plane_dma_addr(). See

http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.2

> 
> >> +
> >> +     for (i = 0; i < BCAP_MAX_FMTS; i++) {
> >> +             if (mbus_fmt.code == bcap_formats[i].mbus_code) {
> >> +                     bcap_fmt = &bcap_formats[i];
> >> +                     v4l2_fill_pix_format(pixfmt, &mbus_fmt);
> >> +                     pixfmt->bytesperline = pixfmt->width * bcap_fmt->bpp;
> >> +                     pixfmt->sizeimage = pixfmt->bytesperline
> >> +                                             * pixfmt->height;
> >
> > It seems to me, you're forgetting to fill in ->pixelformat?
> >
> yes, add in v2
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
