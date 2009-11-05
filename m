Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56311 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756507AbZKEQ3N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2009 11:29:13 -0500
Date: Thu, 5 Nov 2009 17:29:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH 4/9] v4l: Add a 10-bit monochrome and missing 8- and
 10-bit Bayer fourcc codes
In-Reply-To: <200911051545.27931.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0911051728220.5620@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301405590.4378@axis700.grange> <200911051545.27931.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Nov 2009, Hans Verkuil wrote:

> On Friday 30 October 2009 15:01:14 Guennadi Liakhovetski wrote:
> > The 16-bit monochrome fourcc code has been previously abused for a 10-bit
> > format, add a new 10-bit code instead. Also add missing 8- and 10-bit Bayer
> > fourcc codes for completeness.
> 
> I'm fairly certain that you also have to document these new formats in the
> DocBook documentation. Run 'make spec' to verify this.

You mean hg-documentation, don't you? These are _kernel_ git-patches so 
far. When I prepare a pull request I'll (try not to forget to) add the 
docs too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
