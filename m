Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34836 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbbHDVNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 17:13:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] vmc: Virtual Media Controller core, capture and sensor
Date: Wed, 05 Aug 2015 00:13:53 +0300
Message-ID: <2060960.lmDAdnFsBr@avalon>
In-Reply-To: <55B23F1C.1060507@xs4all.nl>
References: <7c3e9d96feb04697ccf4ea24d51c4db1a33a4729.1437230226.git.helen.fornazier@gmail.com> <55B23F1C.1060507@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 24 July 2015 15:35:24 Hans Verkuil wrote:
> Hi Helen,
> 
> Thank you for creating this driver! Much appreciated!
> 
> I do have some comments, see my notes below...
> 
> On 07/18/2015 04:42 PM, Helen Fornazier wrote:
> > First version of the Virtual Media Controller.
> > Add a simple version of the core of the driver, the capture and
> > sensor nodes in the topology, generating a grey image in a hardcoded
> > format.
> > 
> > Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
> > ---
> > 
> > The Virtual Media Controller is meant to provide a test tool which
> > simulates a configurable video pipeline exposing the configuration of its
> > individual nodes (such as sensors, debayers, scalers, inputs, outputs)
> > throught the subdevice API.
> > 
> > This first version generates a grey image with a fixed format within a
> > thread in the sensor, but it will be integrated with the Test Pattern
> > Generator from the Vivid driver in the future.
> > 
> > For more information: http://kernelnewbies.org/LaurentPinchart
> > 
> > The patch is based on 'media/master' branch and available at
> > 
> >         https://github.com/helen-fornazier/opw-staging
> >         vmc/review/video-pipe
> >  
> >  drivers/media/Kconfig           |   1 +
> >  drivers/media/Makefile          |   2 +-
> >  drivers/media/vmc/Kconfig       |   6 +
> >  drivers/media/vmc/Makefile      |   4 +
> >  drivers/media/vmc/vmc-capture.c | 528 +++++++++++++++++++++++++++++++++++
> >  drivers/media/vmc/vmc-capture.h |  50 ++++
> >  drivers/media/vmc/vmc-core.c    | 595 +++++++++++++++++++++++++++++++++++
> >  drivers/media/vmc/vmc-core.h    |  55 ++++
> >  drivers/media/vmc/vmc-sensor.c  | 275 +++++++++++++++++++
> >  drivers/media/vmc/vmc-sensor.h  |  40 +++
> >  10 files changed, 1555 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/media/vmc/Kconfig
> 
> As was mentioned before, this virtual driver should go into the platform
> directory.
> 
> I would also prefer that is was renamed to vimc to be consistent with the
> vim2m and vivid drivers (all with 'vi' prefixes).
> 
> >  create mode 100644 drivers/media/vmc/Makefile
> >  create mode 100644 drivers/media/vmc/vmc-capture.c
> >  create mode 100644 drivers/media/vmc/vmc-capture.h
> >  create mode 100644 drivers/media/vmc/vmc-core.c
> >  create mode 100644 drivers/media/vmc/vmc-core.h
> >  create mode 100644 drivers/media/vmc/vmc-sensor.c
> >  create mode 100644 drivers/media/vmc/vmc-sensor.h

[snip]

> > diff --git a/drivers/media/vmc/vmc-capture.c
> > b/drivers/media/vmc/vmc-capture.c new file mode 100644
> > index 0000000..9367973
> > --- /dev/null
> > +++ b/drivers/media/vmc/vmc-capture.c

[snip]

> > +static void vmc_cap_buf_queue(struct vb2_buffer *vb2)
> > +{
> > +	struct vmc_cap_device *vcap = vb2_get_drv_priv(vb2->vb2_queue);
> > +	struct vmc_cap_buffer *buf = container_of(vb2,
> > +						  struct vmc_cap_buffer, vb2);
> > +
> > +	/* If the buffer doesn't have enough size, mark it as error */
> > +	if (vb2->v4l2_planes[0].length < vcap->format.sizeimage) {
> > +		vb2_buffer_done(vb2, VB2_BUF_STATE_ERROR);
> > +		return;
> > +	}
> 
> No need for this check, this will never happen.
> 
> > +
> > +	spin_lock(&vcap->qlock);
> > +
> > +	list_add_tail(&buf->list, &vcap->buf_list);
> > +
> > +	spin_unlock(&vcap->qlock);
> > +}
> > +
> > +static int vmc_cap_queue_setup(struct vb2_queue *vq,
> > +			       const struct v4l2_format *fmt,
> > +			       unsigned int *nbuffers, unsigned int *nplanes,
> > +			       unsigned int sizes[], void *alloc_ctxs[])
> > +{
> > +	struct vmc_cap_device *vcap = vb2_get_drv_priv(vq);
> > +
> > +	/*We don't support multiplanes for now */
> > +	*nplanes = 1;
> > +
> > +	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : vcap->format.sizeimage;
> 
> If fmt != NULL then you need to check if fmt->fmt.pix.sizeimage >=
> vcap->format.sizeimage and return -EINVAL if that is not the case.

Isn't CREATE_BUFS allowed to create buffers smaller (or larger) than required 
for the currently configured format ?

> > +
> > +	return 0;
> > +}

[snip]

> I didn't review the MC-specific parts in-depth. I assume that Laurent did
> that already,

I did that to some extend, but getting upstream review is also an important 
part of the learning experience ;-) I mentor Helen on the VMC project, but it 
belongs to her, not to me.

> and in addition there will be upcoming changes in the MC API based on the
> workshop results next week.
> 
> In general I have the feeling that the amount of code needed to handle and
> setup entities, links, etc. is too large. That's not your problem, that's
> something we as V4L2 core developers need to address. I've seen this in
> other drivers as well. I suspect we need more helper functions in the core
> code.
> 
> I may be wrong, though. And in any case, any in-depth analysis of this will
> also have to wait until the workshop results are in.
> 
> Anyway, thank you for working on this. I didn't see much wrong here, and the
> few issues I noticed should be easy to fix.

-- 
Regards,

Laurent Pinchart

