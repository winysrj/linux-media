Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1616 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1DHIIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 04:08:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFCv1 PATCH 5/9] vb2_poll: don't start DMA, leave that to the first read().
Date: Fri, 8 Apr 2011 10:07:52 +0200
Cc: "'Hans Verkuil'" <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com> <aa6ba599252cedcbb977fa151a5af70860384bf1.1301916466.git.hans.verkuil@cisco.com> <000601cbf5ba$b499c690$1dcd53b0$%szyprowski@samsung.com>
In-Reply-To: <000601cbf5ba$b499c690$1dcd53b0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081007.52435.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, April 08, 2011 09:00:55 Marek Szyprowski wrote:
> Hello,
> 
> On Monday, April 04, 2011 1:52 PM Hans Verkuil wrote:
> 
> > The vb2_poll function would start read DMA if called without any streaming
> > in progress. This unfortunately does not work if the application just wants
> > to poll for exceptions. This information of what the application is polling
> > for is sadly unavailable in the driver.
> > 
> > Andy Walls suggested to just return POLLIN | POLLRDNORM and let the first
> > call to read start the DMA. This initial read() call will return EAGAIN
> > since no actual data is available yet, but it does start the DMA.
> 
> The current implementation of vb2_read() will just start streaming on first
> call without returning EAGAIN. Do you think this should be changed?

In the non-blocking case vb2_read will also return EAGAIN. Which is what
I meant. So nothing needs to be changed.

Regards,

        Hans

> 
> > 
> > Application are supposed to handle EAGAIN. MythTV does handle this
> > correctly.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/videobuf2-core.c |   16 +++-------------
> >  1 files changed, 3 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/video/videobuf2-core.c
> > b/drivers/media/video/videobuf2-core.c
> > index 6698c77..2dea57a 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -1372,20 +1372,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> > file *file, poll_table *wait)
> >  	 * Start file I/O emulator only if streaming API has not been used
> > yet.
> >  	 */
> >  	if (q->num_buffers == 0 && q->fileio == NULL) {
> > -		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
> > {
> > -			ret = __vb2_init_fileio(q, 1);
> > -			if (ret)
> > -				return POLLERR;
> > -		}
> > -		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
> > {
> > -			ret = __vb2_init_fileio(q, 0);
> > -			if (ret)
> > -				return POLLERR;
> > -			/*
> > -			 * Write to OUTPUT queue can be done immediately.
> > -			 */
> > +		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
> > +			return POLLIN | POLLRDNORM;
> > +		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
> >  			return POLLOUT | POLLWRNORM;
> > -		}
> >  	}
> > 
> >  	/*
> > --
> 
> Best regards
> 
