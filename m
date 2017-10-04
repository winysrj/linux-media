Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56524 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbdJDUSd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 16:18:33 -0400
Message-ID: <1507148284.2981.62.camel@collabora.com>
Subject: Re: [PATCH v3 10/15] [media] vb2: add 'ordered' property to queues
From: Gustavo Padovan <gustavo.padovan@collabora.com>
To: Brian Starkey <brian.starkey@arm.com>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org, Jonathan.Chai@arm.com
Date: Wed, 04 Oct 2017 17:18:04 -0300
In-Reply-To: <20171002134350.GE22538@e107564-lin.cambridge.arm.com>
References: <20170907184226.27482-1-gustavo@padovan.org>
         <20170907184226.27482-11-gustavo@padovan.org>
         <20171002134350.GE22538@e107564-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-10-02 at 14:43 +0100, Brian Starkey wrote:
> Hi,
> 
> On Thu, Sep 07, 2017 at 03:42:21PM -0300, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > For explicit synchronization (and soon for HAL3/Request API) we
> > need
> > the v4l2-driver to guarantee the ordering in which the buffers were
> > queued
> > by userspace. This is already true for many drivers, but we never
> > needed
> > to say it.
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> > include/media/videobuf2-core.h | 4 ++++
> > 1 file changed, 4 insertions(+)
> > 
> > diff --git a/include/media/videobuf2-core.h
> > b/include/media/videobuf2-core.h
> > index 5ed8d3402474..20099dc22f26 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -508,6 +508,9 @@ struct vb2_buf_ops {
> >  * @last_buffer_dequeued: used in poll() and DQBUF to immediately
> > return if the
> >  *		last decoded buffer was already dequeued. Set for
> > capture queues
> >  *		when a buffer with the V4L2_BUF_FLAG_LAST is
> > dequeued.
> > + * @ordered: if the driver can guarantee that the queue will be
> > ordered or not.
> > + *		The default is not ordered unless the driver
> > sets this flag. It
> > + *		is mandatory for using explicit fences.
> 
> If it's mandatory for fences (why is that?), then I guess this patch
> should come before any of the fence implementation?

As of this implementation it is mandatory for out-fences, so that is
why I didn't put it before the in-fences support.

> 
> But it's not entirely clear to me what this flag means - ordered with
> respect to what? Ordered such that the order in which the buffers are
> queued in the driver are the same order that they will be dequeued by
> userspace?

Exactly.

> I think the order they are queued from userspace can still be
> different from both the order they are queued in the driver (because
> the in-fences can signal in any order), and dequeued again in
> userspace, so "ordered" seems a bit ambiguous.

Exactly. That is what the current implementation does.

> 
> I think it should be more clear.

Sure, sorry for not being clear, the next iteration will have a much
better explanation.

Gustavo
