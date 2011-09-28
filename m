Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4553 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1I1HfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 03:35:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/9 v7] V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF ioctl()s
Date: Wed, 28 Sep 2011 09:34:58 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <201109271251.01367.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271747160.7004@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109271747160.7004@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109280934.58154.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 17:49:52 Guennadi Liakhovetski wrote:
> On Tue, 27 Sep 2011, Hans Verkuil wrote:
> 
> > On Thursday, September 08, 2011 09:46:26 Guennadi Liakhovetski wrote:
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> 
> [snip]
> 
> > > +    <para>When the ioctl is called with a pointer to this structure the driver
> > > +will attempt to allocate up to the requested number of buffers and store the
> > > +actual number allocated and the starting index in the
> > > +<structfield>count</structfield> and the <structfield>index</structfield> fields
> > > +respectively. On return <structfield>count</structfield> can be smaller than
> > > +the number requested. The driver may also adjust buffer sizes as it sees fit,
> > 
> > Add: 'provided the size is greater than or equal to sizeimage'.
> 
> How about:
> 
> The driver may also increase buffer sizes if required, however, it will 
> not update <structfield>sizeimage</structfield> field values. The
> user has to use <constant>VIDIOC_QUERYBUF</constant> to retrieve that
> information.</para>

Looks good.

Regards,

	Hans
