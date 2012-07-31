Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.meprolight.com ([194.90.149.17]:51263 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026Ab2GaTUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 15:20:04 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 31 Jul 2012 22:20:16 +0300
Subject: RE: [PATCH] media: mx3_camera: buf_init() add buffer state check
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2E31A0CA1B@MEP-EXCH.meprolight.com>
References: <1343675227-9061-1-git-send-email-alexg@meprolight.com>,<Pine.LNX.4.64.1207310838110.27888@axis700.grange>
	<4875438356E7CA4A8F2145FCD3E61C0B2E31A0CA18@MEP-EXCH.meprolight.com>,<Pine.LNX.4.64.1207311239030.27888@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207311239030.27888@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



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

> > Ok, I understand now what this patch fixes, but I still don't understand
> > what the problem is and how this patch fixes it. AFAICS, there should be
> > nothing wrong with calling mx3_videobuf_init() each time a buffer gets
> > queued. 

I only see the problem when the user implements USERPTR method :-)

> > I suspect, it's just one of those 4 lines of code, that you put
> > under "if (buf->state != CSI_BUF_PREPARED)", that breaks it. Could you

I think the best way to make sure this solves the problem is to test it, and that is what I did :-) 

> > please try to find out which exactly line it is? Just try to use your "if
> > (...)" with each of them separately. My guess goes for

        > > buf->state = CSI_BUF_NEEDS_INIT;

> > but it would help if you could verify it.

mx3_camera uses slave dma API of the dmaengine. 
In MMAP and USERPTR methods, the buffer which had been prepared already 
have a descriptor for transaction and does not need additional descriptor.
If user implement  MMAP method,  there is no problem  because mx3_videobuf_init() happens at REQBUFS time
and we have only one descriptor for transaction per video buffer.
 
As you mentioned, In case of USERPTR method mx3_videobuf_init() happens at QBUF time.
In my opinion there are two problems:
 
1) During QBUF there is no need to get a new descriptor for the transaction if it has been already obtained.
 
2) The second problem derives from the first as the number of descriptors for each channel is limited and very quickly
    we reach the maximum permitted number of descriptors. As a results of that, the video freezes.

This patch solves the two problems.

Regards,

Alex
  
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