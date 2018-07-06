Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48802 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753688AbeGFNnb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 09:43:31 -0400
Message-ID: <d84d6dc29cfb53eaf55e92bbf51dc36b72c7d6b9.camel@collabora.com>
Subject: Re: [PATCH v2 2/3] s5p-g2d: Remove unrequired wait in .job_abort
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>
Date: Fri, 06 Jul 2018 10:43:22 -0300
In-Reply-To: <7a4debab-717e-c99b-778f-fc9bdc99775e@kernel.org>
References: <20180618043852.13293-1-ezequiel@collabora.com>
         <20180618043852.13293-3-ezequiel@collabora.com>
         <0c63d9ee-88c4-c09d-ec36-cc0ee3ca3d8f@xs4all.nl>
         <7a4debab-717e-c99b-778f-fc9bdc99775e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-07-06 at 13:09 +0200, Sylwester Nawrocki wrote:
> Hi,
> 
> On 07/04/2018 10:04 AM, Hans Verkuil wrote:
> > On 18/06/18 06:38, Ezequiel Garcia wrote:
> > > As per the documentation, job_abort is not required
> > > to wait until the current job finishes. It is redundant
> > > to do so, as the core will perform the wait operation.
> 
> Could you elaborate how the core ensures DMA operation is not in
> progress
> after VIDIOC_STREAMOFF, VIDIOC_DQBUF with this patch applied?
> 

Well, .streamoff is handled by v4l2_m2m_streamoff, which
guarantees that no job is running by calling v4l2_m2m_cancel_job.

The call chain goes like this:

vidioc_streamoff
  v4l2_m2m_ioctl_streamoff
    v4l2_m2m_streamoff
      v4l2_m2m_cancel_job
        wait_event(m2m_ctx->finished, ...);

The wait_event() wakes up by v4l2_m2m_job_finish(),
which is called by g2d_isr after marking the buffers
as done.

The reason why I haven't elaborated this in the commit log
is because it's documented in .job_abort declaration.
 
> > > Remove the wait infrastructure completely.
> > 
> > Sylwester, can you review this?
> 
> Thanks for forwarding Hans!
> 
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Kamil Debski <kamil@wypas.org>
> > > Cc: Andrzej Hajda <a.hajda@samsung.com>
> > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > ---
> > >   drivers/media/platform/s5p-g2d/g2d.c | 11 -----------
> > >   drivers/media/platform/s5p-g2d/g2d.h |  1 -
> > >   2 files changed, 12 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/s5p-g2d/g2d.c
> > > b/drivers/media/platform/s5p-g2d/g2d.c
> > > index 66aa8cf1d048..e98708883413 100644
> > > --- a/drivers/media/platform/s5p-g2d/g2d.c
> > > +++ b/drivers/media/platform/s5p-g2d/g2d.c
> > > @@ -483,15 +483,6 @@ static int vidioc_s_crop(struct file *file,
> > > void *prv, const struct v4l2_crop *c
> > >   
> > >   static void job_abort(void *prv)
> > >   {
> > > -	struct g2d_ctx *ctx = prv;
> > > -	struct g2d_dev *dev = ctx->dev;
> > > -
> > > -	if (dev->curr == NULL) /* No job currently running */
> > > -		return;
> > > -
> > > -	wait_event_timeout(dev->irq_queue,
> > > -			   dev->curr == NULL,
> > > -			   msecs_to_jiffies(G2D_TIMEOUT));
> 
> I think after this patch there will be a potential race condition
> possible,
> we could have the hardware DMA and CPU writing to same buffer with
> sequence like:
> ...
> QBUF
> STREAMON
> STREAMOFF
> DQBUF 
> CPU accessing the buffer  <--  at this point G2D DMA could still be
> writing
> to an already dequeued buffer. Image processing can take few
> miliseconds, it should
> be fairly easy to trigger such a condition.
> 

I don't think this is the case, as I've explained above. This commit
merely removes a redundant wait, as job_abort simply waits the
interrupt handler to complete, and that is the purpose of
v4l2_m2m_job_finish.

It only makes sense to implement job_abort if you can actually stop
the current DMA. If you can only wait for it to complete, then it's not
needed.

> Not saying about DMA being still in progress after device file handle
> is closed,
> but that's something that deserves a separate patch. It seems there
> is a bug in 
> the driver as there is no call to v4l2_m2m_ctx_release()in the device
> fops release() 
> callback.
> 

Yes, that seems correct. Should be fixed in a separate patch.

> I think we could remove the s5p-g2d driver altogether as the
> functionality is covered
> by the exynos DRM IPP driver (drivers/gpu/drm/exynos).
> 

That I'll leave for you to decide :-)

The intention of this series is simply to make job_abort optional,
and remove those drivers that implement job_abort as a wait-for-
current-job.

Thanks for reviewing!
Eze
