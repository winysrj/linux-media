Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54861 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2F0Kts (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 06:49:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 23/34] vb2-core: refactor reqbufs/create_bufs.
Date: Wed, 27 Jun 2012 12:49:45 +0200
Message-ID: <7844932.d669S5i05h@avalon>
In-Reply-To: <201206271237.21149.hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl> <2768547.EFJTNiot7U@avalon> <201206271237.21149.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 27 June 2012 12:37:21 Hans Verkuil wrote:
> On Wed 27 June 2012 11:52:10 Laurent Pinchart wrote:
> > On Friday 22 June 2012 14:21:17 Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > Split off the memory and type validation. This is done both from reqbufs
> > > and create_bufs, and will also be done by vb2 helpers in a later patch.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

[snip]

> > > +
> > > +/**
> > > + * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the
> > > memory and
> > > + * type values.
> > > + * @q:		videobuf2 queue
> > > + * @create:	creation parameters, passed from userspace to
> > > vidioc_create_bufs
> > > + *		handler in driver
> > > + */
> > > +int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers
> > > *create)
> > > +{
> > > +	int ret = __verify_memory_type(q, create->memory,
> > > create->format.type);
> > > +
> > > +	create->index = q->num_buffers;
> > 
> > I think this changes the behaviour of create_bufs, it should thus belong
> > to the next patch.
> 
> No, I don't think this changes the behavior as far as I can tell.

Without your patch create->index isn't modified if the checks fail. On the 
other hand, I've just remembered that video_usercopy won't copy the structure 
back to userspace if ret < 0, so you should be right.

> > > +	return ret ? ret : __create_bufs(q, create);
> > > +}
> > > 
> > >  EXPORT_SYMBOL_GPL(vb2_create_bufs);
> > >  
> > >  /**
-- 
Regards,

Laurent Pinchart

