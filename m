Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52253 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1I0TvD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 15:51:03 -0400
Date: Tue, 27 Sep 2011 22:50:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 3/9 v7] V4L: document the new VIDIOC_CREATE_BUFS and
 VIDIOC_PREPARE_BUF ioctl()s
Message-ID: <20110927195057.GD5599@valkosipuli.localdomain>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1109080942172.31156@axis700.grange>
 <Pine.LNX.4.64.1109080945290.31156@axis700.grange>
 <201109271251.01367.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1109271747160.7004@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109271747160.7004@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tue, Sep 27, 2011 at 05:49:52PM +0200, Guennadi Liakhovetski wrote:
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

This may be a stupid question but would there be adverse effects from
updating it?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
