Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57539 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab2GaKoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 06:44:18 -0400
Date: Tue, 31 Jul 2012 12:44:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Gershgorin <alexg@meprolight.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] media: mx3_camera: buf_init() add buffer state check
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2E31A0CA18@MEP-EXCH.meprolight.com>
Message-ID: <Pine.LNX.4.64.1207311239030.27888@axis700.grange>
References: <1343675227-9061-1-git-send-email-alexg@meprolight.com>,<Pine.LNX.4.64.1207310838110.27888@axis700.grange>
 <4875438356E7CA4A8F2145FCD3E61C0B2E31A0CA18@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Jul 2012, Alex Gershgorin wrote:

> Hi Guennadi,
> 
> > On Mon, 30 Jul 2012, Alex Gershgorin wrote:
> 
> > This patch check the state of the buffer when calling buf_init() method.
> > The thread http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/48587
> > also includes report witch can show the problem. This patch solved the problem.
> > Both MMAP and USERPTR methods was successfully tested.
> >
> > Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> > ---
> >  drivers/media/video/mx3_camera.c |   12 +++++++-----
> >  1 files changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> > index f13643d..950a8fe 100644
> > --- a/drivers/media/video/mx3_camera.c
> > +++ b/drivers/media/video/mx3_camera.c
> > @@ -405,13 +405,15 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
> 
> >> Sorry, don't understand. As we see in the thread, mentioned above, the
> >> Oops happened in mx3_videobuf_release(). If my analysis was correct in
> >> that thread, that Oops happened, when .buf_cleanup() was called without
> >> .buf_init() being called. This your patch modifies mx3_videobuf_init().
> >> which isn't even called in the problem case. How does this help?
> 
> Sorry for not quite a clear explanation, I will explain in more details.
> if you divide the report into two parts:
> 1) USERPTR method Oops happened as a result discontiguous memory allocation
> 2) USERPTR method use framebuffer memory allocation video starting, but after a few seconds the video freezes.
>     if we consider the first part of the report, your analysis is absolutely 
>    correct and unfortunately this patch does not solve the problems mentioned in the thread.
>    This patch solves a problem that is described in the second part of the report.

Ok, I understand now what this patch fixes, but I still don't understand 
what the problem is and how this patch fixes it. AFAICS, there should be 
nothing wrong with calling mx3_videobuf_init() each time a buffer gets 
queued. I suspect, it's just one of those 4 lines of code, that you put 
under "if (buf->state != CSI_BUF_PREPARED)", that breaks it. Could you 
please try to find out which exactly line it is? Just try to use your "if 
(...)" with each of them separately. My guess goes for

	buf->state = CSI_BUF_NEEDS_INIT;

but it would help if you could verify it.

Thanks
Guennadi

> 
> >       struct mx3_camera_dev *mx3_cam = ici->priv;
> >       struct mx3_camera_buffer *buf = to_mx3_vb(vb);
> >
> > -     /* This is for locking debugging only */
> > -     INIT_LIST_HEAD(&buf->queue);
> > -     sg_init_table(&buf->sg, 1);
> > +     if (buf->state != CSI_BUF_PREPARED) {
> > +             /* This is for locking debugging only */
> > +             INIT_LIST_HEAD(&buf->queue);
> > +             sg_init_table(&buf->sg, 1);
> >
> > -     buf->state = CSI_BUF_NEEDS_INIT;
> > +             buf->state = CSI_BUF_NEEDS_INIT;
> >
> > -     mx3_cam->buf_total += vb2_plane_size(vb, 0);
> > +             mx3_cam->buf_total += vb2_plane_size(vb, 0);
> > +     }
> >
> >       return 0;
> >  }
> > --
> > 1.7.0.4
> >
> 
> Regards,
> Alex
>  

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
