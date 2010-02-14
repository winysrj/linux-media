Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52706 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab0BNXeG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 18:34:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: videobuf and streaming I/O questions
Date: Mon, 15 Feb 2010 00:34:23 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <201002141422.48362.hverkuil@xs4all.nl> <4B77FD89.3080209@infradead.org> <201002141526.09339.hverkuil@xs4all.nl>
In-Reply-To: <201002141526.09339.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002150034.24891.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 14 February 2010 15:26:09 Hans Verkuil wrote:
> On Sunday 14 February 2010 14:41:29 Mauro Carvalho Chehab wrote:
> > Hans Verkuil wrote:
> > > Hi all,
> > > 
> > > I've been investigating some problems with my qv4l2 utility and I
> > > encountered some inconsistencies in the streaming I/O documentation
> > > and the videobuf implementation.
> > > 
> > > I would like to know which is correct.

[snip]

> > > 2) The VIDIOC_REQBUFS documentation states that it should be possible
> > > to use a count of 0, in which case it should do an implicit STREAMOFF.
> > > This is currently not implemented. I have included a patch for this
> > > below and if there are no issues with it, then I'll make a pull
> > > request for this.
> > 
> > This can eventually break some application. I think it is safer to fix
> > the specs.
> 
> I don't really see how this would break an application and I think that
> some drivers that do not use videobuf already support this. The reason why
> I think this is a good idea to support it is that this makes it very easy
> to check which streaming mode is supported without actually allocating
> anything.
> 
> I was actually using this in qv4l2 with uvc until I tried it with the mxb
> driver and discovered that videobuf didn't support it. I am definitely in
> favor of fixing the code instead of the spec in this case.

Using a count of 0 to free buffers definitely needs to be supported, so 
videobuf must be fixed. However, I don't think VIDIOC_REQBUFS should issue an 
implicit VIDIOC_STREAMOFF. It should instead return -EBUSY if streaming is in 
progress, or if buffers are still mapped in the userspace memory space.

Performing implicit actions make drivers more complex and error prone. I don't 
see any harm in requiring userspace to call VIDIOC_STREAMOFF before freeing 
buffers.

-- 
Regards,

Laurent Pinchart
