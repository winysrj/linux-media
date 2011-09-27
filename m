Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1I0PuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 11:50:15 -0400
Date: Tue, 27 Sep 2011 17:49:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 3/9 v7] V4L: document the new VIDIOC_CREATE_BUFS and
 VIDIOC_PREPARE_BUF ioctl()s
In-Reply-To: <201109271251.01367.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1109271747160.7004@axis700.grange>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1109080942172.31156@axis700.grange>
 <Pine.LNX.4.64.1109080945290.31156@axis700.grange> <201109271251.01367.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Sep 2011, Hans Verkuil wrote:

> On Thursday, September 08, 2011 09:46:26 Guennadi Liakhovetski wrote:
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---

[snip]

> > +    <para>When the ioctl is called with a pointer to this structure the driver
> > +will attempt to allocate up to the requested number of buffers and store the
> > +actual number allocated and the starting index in the
> > +<structfield>count</structfield> and the <structfield>index</structfield> fields
> > +respectively. On return <structfield>count</structfield> can be smaller than
> > +the number requested. The driver may also adjust buffer sizes as it sees fit,
> 
> Add: 'provided the size is greater than or equal to sizeimage'.

How about:

The driver may also increase buffer sizes if required, however, it will 
not update <structfield>sizeimage</structfield> field values. The
user has to use <constant>VIDIOC_QUERYBUF</constant> to retrieve that
information.</para>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
