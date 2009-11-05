Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4975 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZKEQcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 11:32:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 4/9] v4l: Add a 10-bit monochrome and missing 8- and 10-bit Bayer fourcc codes
Date: Thu, 5 Nov 2009 17:32:06 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <200911051545.27931.hverkuil@xs4all.nl> <Pine.LNX.4.64.0911051728220.5620@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911051728220.5620@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051732.06321.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 November 2009 17:29:29 Guennadi Liakhovetski wrote:
> On Thu, 5 Nov 2009, Hans Verkuil wrote:
> 
> > On Friday 30 October 2009 15:01:14 Guennadi Liakhovetski wrote:
> > > The 16-bit monochrome fourcc code has been previously abused for a 10-bit
> > > format, add a new 10-bit code instead. Also add missing 8- and 10-bit Bayer
> > > fourcc codes for completeness.
> > 
> > I'm fairly certain that you also have to document these new formats in the
> > DocBook documentation. Run 'make spec' to verify this.
> 
> You mean hg-documentation, don't you? These are _kernel_ git-patches so 
> far. When I prepare a pull request I'll (try not to forget to) add the 
> docs too.

Yes, that's hg documentation.

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
