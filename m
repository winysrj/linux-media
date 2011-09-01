Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1IAHKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 03:10:53 -0400
Date: Thu, 1 Sep 2011 09:10:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 3/9 v6] V4L: document the new VIDIOC_CREATE_BUFS and
 VIDIOC_PREPARE_BUF ioctl()s
In-Reply-To: <20110831211157.GR12368@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1109010904300.21309@axis700.grange>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <1314813768-27752-4-git-send-email-g.liakhovetski@gmx.de>
 <20110831211157.GR12368@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Sep 2011, Sakari Ailus wrote:

> Hi Guennadi,
> 
> On Wed, Aug 31, 2011 at 08:02:42PM +0200, Guennadi Liakhovetski wrote:
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Cc: Pawel Osciak <pawel@osciak.com>
> > Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > ---
> >  Documentation/DocBook/media/v4l/io.xml             |   17 +++
> >  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
> >  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  147 ++++++++++++++++++++
> >  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 +++++++++++++
> >  4 files changed, 262 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> >  create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml

[snip]

> > +  <refsect1>
> > +    <title>Description</title>
> > +
> > +    <para>Applications can optionally call the
> > +<constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
> > +to the driver before actually enqueuing it, using the
> > +<constant>VIDIOC_QBUF</constant> ioctl, and to prepare it for future I/O.
> > +Such preparations may include cache invalidation or cleaning. Performing them
> 
> I think it could be added that the first time when the buffer is prepared,
> the preparation may include very time consuming tasks such as memory
> allocation and iommu mapping of that memory.

Sure, looking forward to your incremental patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
