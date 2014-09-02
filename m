Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59056 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBKBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 06:01:07 -0400
Message-ID: <1409652053.4449.23.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC v2] [media] v4l2: add V4L2 pixel format array and helper
 functions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	kernel@pengutronix.de,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Tue, 02 Sep 2014 12:00:53 +0200
In-Reply-To: <53FF69C9.1090202@xs4all.nl>
References: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de>
	 <2323863.aLBeKZnVsL@avalon>
	 <1409242175.2696.108.camel@paszta.hi.pengutronix.de>
	 <2088388.O2EqQOIWv7@avalon> <53FF5B95.4030705@xs4all.nl>
	 <20140828141851.54899cae.m.chehab@samsung.com> <53FF67A5.8000607@xs4all.nl>
	 <53FF69C9.1090202@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Donnerstag, den 28.08.2014, 19:41 +0200 schrieb Hans Verkuil:
> On 08/28/2014 07:32 PM, Hans Verkuil wrote:
> > On 08/28/2014 07:18 PM, Mauro Carvalho Chehab wrote:
> >> I really don't see any gain on applying such patch. If the concern is
> >> just about properly naming the pixel formats, it is a way easier to use
> >> some defines for the names, and use the defines.
> > 
> > It's not just the names, also the bit depth etc. Most drivers need that information
> > and having it in a central place simplifies driver design. Yes, it slightly
> > increases the amount of memory, but that is insignificant compared to the huge
> > amount of memory necessary for video buffers. And reducing driver complexity is
> > always good since that has always been the main problem with drivers, not memory
> > or code performance.
> 
> I just want to add that we should try out any core solution with an existing driver
> (e.g. saa7134) to see if whatever solution we come up with actually makes drivers
> less complex. The saa7134 is from what I've seen fairly representative of most in
> that is has additional fields besides the name, fourcc and depth that are driver
> specific. So how will that be handled...

my main motivation was unification of the format description strings
(well, not wanting to come up with possibly new ones for every driver),
but reducing driver complexity is a nice side effect.

I think saa7134 won't benefit a whole lot. It still needs to keep that
list for the custom saa7134_format fields, but at least the common ones
can be moved into a struct v4l2_pixfmt_info.

The global array mostly has the potential to remove a little boilerplate
from a lot of the simple cases that are happy with the per-format info
already provided by the array.

regards
Philipp

