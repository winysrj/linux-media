Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62492 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbcAAPoL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jan 2016 10:44:11 -0500
Date: Fri, 1 Jan 2016 16:43:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aviv Greenberg <avivgr@gmail.com>
Subject: Re: per-frame camera metadata (again)
In-Reply-To: <5520197.vJSVcNd1Sr@avalon>
Message-ID: <Pine.LNX.4.64.1601011639070.30606@axis700.grange>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange>
 <2560629.CtpjHgJUC1@avalon> <Pine.LNX.4.64.1512241123060.12474@axis700.grange>
 <5520197.vJSVcNd1Sr@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, 27 Dec 2015, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Thursday 24 December 2015 11:42:49 Guennadi Liakhovetski wrote:
> > Hi Laurent,
> > 
> > Let me put this at the top: So far it looks like we converge on two
> > possibilities:
> > 
> > (1) a separate video-device node with a separate queue. No user-space
> > visible changes are required apart from new FOURCC codes. In the kernel
> > we'd have to add some subdev API between the bridge and the sensor drivers
> > to let the sensor driver instruct the bridge driver to use some of the
> > data, arriving over the camera interface, as metadata.
> 
> The interface should be more generic and allow describing how multiple 
> channels (in terms of virtual channels and data types for CSI-2 for instance) 
> are multiplexed over a single physical link. I'm not sure how to represent 
> that at the media controller level, that's also one topic that needs to be 
> researched.

Sure, agree. How about an enumetation style method, something like 
.enum_mbus_streams()?

In principle agree with the rest too, just probably would rather 
concentrate on this one method, if we decide, that we also want to be able 
to access that data, using controls, we can add it later?

Thanks
Guennadi
