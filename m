Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46968 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934488Ab0BYXpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 18:45:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: More videobuf and streaming I/O questions
Date: Fri, 26 Feb 2010 00:46:14 +0100
Cc: "'Hans Verkuil'" <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	"'Mauro Carvalho Chehab'" <mchehab@infradead.org>
References: <201002201500.21118.hverkuil@xs4all.nl> <201002220012.20797.laurent.pinchart@ideasonboard.com> <000901cab45b$a8c55a10$fa500e30$%osciak@samsung.com>
In-Reply-To: <000901cab45b$a8c55a10$fa500e30$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002260046.16878.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tuesday 23 February 2010 08:41:49 Pawel Osciak wrote:
> >On Mon, 22 Feb 2010 00:12:18 +0100
> >Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> >> On Saturday 20 February 2010 15:00:21 Hans Verkuil wrote:
> >> > 1) The spec mentions that the memory field should be set for
> >> > VIDIOC_DQBUF. But videobuf doesn't need it and it makes no sense to
> >> > me either unless it is for symmetry with VIDIOC_QBUF. Strictly
> >> > speaking QBUF doesn't need it either, but it is a good sanity check.
> >> > 
> >> > Can I remove the statement in the spec that memory should be set
> >> > for DQBUF? The alternative is to add a check against the memory
> >> > field in videobuf, but that's rather scary.
> >> 
> >> In that case I would remove it for QBUF as well, and state that the
> >> memory field must be ignored by drivers (but should they fill it when
> >> returning from QBUF/DQBUF ?)
> >
> >Agree. It seems that the memory field is not useful at all in the struct
> >v4l2_buffer if a same process does reqbuf, qbuf, dqbuf and querybuf.
> 
> In the current multi-plane buffer proposal, the memory field is required
> in querybuf, qbuf and dqbuf for the v4l2-ioctl.c code to be able to
> determine whether the planes array should be copied from/to user along
> with the buffer.
> Just wanted to add another view to the problem, as multiplanes are accepted
> yet of course.

Thanks for the reminder. I'm not against keeping the requirement for 
applications to set the memory field in the v4l2_buffer structure. QBUF and 
DQBUF should behave the same way though, they should both require the field to 
be set or not require it at all.

> As for the REQBUF, I've always thought it'd be nice to be able to ask the
> driver for the "recommended" number of buffers that should be used by
> issuing a REQBUF with count=0...

How would the driver come up with the number of recommended buffers ?

-- 
Regards,

Laurent Pinchart
