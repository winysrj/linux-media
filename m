Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39727 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbbFSL6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 07:58:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, Kamil Debski <kamil@wypas.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [URGENT] [PATCH] vb2: Don't WARN when v4l2_buffer.bytesused is 0 for multiplanar buffers
Date: Fri, 19 Jun 2015 14:59:26 +0300
Message-ID: <4737269.QnNX680z18@avalon>
In-Reply-To: <55840367.3010700@xs4all.nl>
References: <1434714607-31447-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <55840367.3010700@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 19 June 2015 13:56:23 Hans Verkuil wrote:
> On 06/19/2015 01:50 PM, Laurent Pinchart wrote:
> > Commit f61bf13b6a07 ("[media] vb2: add allow_zero_bytesused flag to the
> > vb2_queue struct") added a WARN_ONCE to catch usage of a deprecated API
> > using a zero value for v4l2_buffer.bytesused.
> > 
> > However, the condition is checked incorrectly, as the v4L2_buffer
> > bytesused field is supposed to be ignored for multiplanar buffers. This
> > results in spurious warnings when using the multiplanar API.
> > 
> > Fix it by checking v4l2_buffer.bytesused for uniplanar buffers and
> > v4l2_plane.bytesused for multiplanar buffers.
> > 
> > Fixes: f61bf13b6a07 ("[media] vb2: add allow_zero_bytesused flag to the
> > vb2_queue struct") Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > --- 
> >  drivers/media/v4l2-core/videobuf2-core.c | 33 +++++++++++++++++----------
> >  1 file changed, 23 insertions(+), 10 deletions(-)
> > 
> > The bug was introduced in v4.1-rc1. It would be quite bad if it made it to
> > v4.1 as many users will start complaining.
> > 
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c index
> > d835814a24d4..93b315459098 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -1242,6 +1242,23 @@ void vb2_discard_done(struct vb2_queue *q)
> > 
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_discard_done);
> > 
> > +static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
> > +{
> > +	static bool __check_once __read_mostly;
> 
> Why the underscores? Why the __read_mostly?

Copied from WARN_ONCE :-)

> Just say: 'static bool check_once;'
> 
> Much more readable, and there really is no benefit whatsoever for adding
> a __read_mostly attribute here.

I'll remove them.

> > +
> > +	if (__check_once)
> > +		return;
> > +
> > +	__check_once = true;
> > +	__WARN();
> > +
> > +	pr_warn_once("use of bytesused == 0 is deprecated and will be removed 
in
> > the future,\n");
> This can be pr_warn now. pr_warn_once will implicitly only do another
> 'check_once' check with its own 'check_once' variable.

I had intended to do so but just forgot.

v2 on its way.

> > +	if (vb->vb2_queue->allow_zero_bytesused)
> > +		pr_warn_once("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.
\n");
> > +	else
> > +		pr_warn_once("use the actual size instead.\n");
> > +}

-- 
Regards,

Laurent Pinchart

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
