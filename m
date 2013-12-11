Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44271 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3LKK1J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 05:27:09 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXN00L6U116P130@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Dec 2013 10:27:06 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, awalls@md.metrocast.net,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	g.liakhovetski@gmx.de, 'Hans Verkuil' <hans.verkuil@cisco.com>,
	"'Lad, Prabhakar'" <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
References: <1386596592-48678-1-git-send-email-hverkuil@xs4all.nl>
 <1386596592-48678-8-git-send-email-hverkuil@xs4all.nl>
 <52A6C807.6040102@xs4all.nl>
In-reply-to: <52A6C807.6040102@xs4all.nl>
Subject: RE: [RFCv4 PATCH 7/8] vb2: return ENODATA in start_streaming in case
 of too few buffers.
Date: Wed, 11 Dec 2013 11:27:05 +0100
Message-id: <00c101cef65b$8abd4640$a037d2c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, December 10, 2013 8:52 AM
> 
> As Guennadi mentioned in his review, ENODATA will be replaced by
> ENOBUFS, which is more appropriate.
> 
> Prabhakar, Kamil, Tomasz, are you OK with this patch provided
> s/ENODATA/ENOBUFS/ ?

The patch looks good. However, shouldn't the documentation be changed too?

Now it says: [1]
"(...) Accordingly the output hardware is disabled, no video signal is
produced until VIDIOC_STREAMON has been called. The ioctl will succeed
only when at least one output buffer is in the incoming queue. (...)"

If I understand correctly, now the ioctl will succeed with no buffers
queued. Apart from the above you have my ack.

Acked-by: Kamil Debski <k.debski@samsung.com>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

[1] - http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-streamon.html

> 
> On 12/09/2013 02:43 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > This works together with the retry_start_streaming mechanism to allow
> > userspace to start streaming even if not all required buffers have
> been queued.
> >
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Kamil Debski <k.debski@samsung.com>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/media/platform/davinci/vpbe_display.c   | 2 +-
> >  drivers/media/platform/davinci/vpif_capture.c   | 2 +-
> >  drivers/media/platform/davinci/vpif_display.c   | 2 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 2 +-
> >  drivers/media/platform/s5p-tv/mixer_video.c     | 2 +-
> >  drivers/media/platform/soc_camera/mx2_camera.c  | 2 +-
> > drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 ++
> >  7 files changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/media/platform/davinci/vpbe_display.c
> > b/drivers/media/platform/davinci/vpbe_display.c
> > index eac472b..53be7fc 100644
> > --- a/drivers/media/platform/davinci/vpbe_display.c
> > +++ b/drivers/media/platform/davinci/vpbe_display.c
> > @@ -347,7 +347,7 @@ static int vpbe_start_streaming(struct vb2_queue
> *vq, unsigned int count)
> >  	/* If buffer queue is empty, return error */
> >  	if (list_empty(&layer->dma_queue)) {
> >  		v4l2_err(&vpbe_dev->v4l2_dev, "buffer queue is empty\n");
> > -		return -EINVAL;
> > +		return -ENODATA;
> >  	}
> >  	/* Get the next frame from the buffer queue */
> >  	layer->next_frm = layer->cur_frm = list_entry(layer-
> >dma_queue.next,
> > diff --git a/drivers/media/platform/davinci/vpif_capture.c
> > b/drivers/media/platform/davinci/vpif_capture.c
> > index 52ac5e6..4b04a27 100644
> > --- a/drivers/media/platform/davinci/vpif_capture.c
> > +++ b/drivers/media/platform/davinci/vpif_capture.c
> > @@ -277,7 +277,7 @@ static int vpif_start_streaming(struct vb2_queue
> *vq, unsigned int count)
> >  	if (list_empty(&common->dma_queue)) {
> >  		spin_unlock_irqrestore(&common->irqlock, flags);
> >  		vpif_dbg(1, debug, "buffer queue is empty\n");
> > -		return -EIO;
> > +		return -ENODATA;
> >  	}
> >
> >  	/* Get the next frame from the buffer queue */ diff --git
> > a/drivers/media/platform/davinci/vpif_display.c
> > b/drivers/media/platform/davinci/vpif_display.c
> > index c31bcf1..c5070dc 100644
> > --- a/drivers/media/platform/davinci/vpif_display.c
> > +++ b/drivers/media/platform/davinci/vpif_display.c
> > @@ -239,7 +239,7 @@ static int vpif_start_streaming(struct vb2_queue
> *vq, unsigned int count)
> >  	if (list_empty(&common->dma_queue)) {
> >  		spin_unlock_irqrestore(&common->irqlock, flags);
> >  		vpif_err("buffer queue is empty\n");
> > -		return -EIO;
> > +		return -ENODATA;
> >  	}
> >
> >  	/* Get the next frame from the buffer queue */ diff --git
> > a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > index 4ff3b6c..3bdfe85 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > @@ -1863,7 +1863,7 @@ static int s5p_mfc_start_streaming(struct
> vb2_queue *q, unsigned int count)
> >  		if (ctx->src_bufs_cnt < ctx->pb_count) {
> >  			mfc_err("Need minimum %d OUTPUT buffers\n",
> >  					ctx->pb_count);
> > -			return -EINVAL;
> > +			return -ENODATA;
> >  		}
> >  	}
> >
> > diff --git a/drivers/media/platform/s5p-tv/mixer_video.c
> > b/drivers/media/platform/s5p-tv/mixer_video.c
> > index 81b97db..220ec31 100644
> > --- a/drivers/media/platform/s5p-tv/mixer_video.c
> > +++ b/drivers/media/platform/s5p-tv/mixer_video.c
> > @@ -948,7 +948,7 @@ static int start_streaming(struct vb2_queue *vq,
> > unsigned int count)
> >
> >  	if (count == 0) {
> >  		mxr_dbg(mdev, "no output buffers queued\n");
> > -		return -EINVAL;
> > +		return -ENODATA;
> >  	}
> >
> >  	/* block any changes in output configuration */ diff --git
> > a/drivers/media/platform/soc_camera/mx2_camera.c
> > b/drivers/media/platform/soc_camera/mx2_camera.c
> > index 45a0276..587e3d1 100644
> > --- a/drivers/media/platform/soc_camera/mx2_camera.c
> > +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> > @@ -659,7 +659,7 @@ static int mx2_start_streaming(struct vb2_queue
> *q, unsigned int count)
> >  	unsigned long flags;
> >
> >  	if (count < 2)
> > -		return -EINVAL;
> > +		return -ENODATA;
> >
> >  	spin_lock_irqsave(&pcdev->lock, flags);
> >
> > diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > index 24d98a6..a81b0ab 100644
> > --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > @@ -1201,6 +1201,8 @@ static int vpfe_start_streaming(struct
> vb2_queue *vq, unsigned int count)
> >  	unsigned long addr;
> >  	int ret;
> >
> > +	if (count == 0)
> > +		return -ENODATA;
> >  	ret = mutex_lock_interruptible(&video->lock);
> >  	if (ret)
> >  		goto streamoff;
> >

