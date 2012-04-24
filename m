Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53839 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2DXUJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 16:09:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] omap3isp: ccdc: Add crop support on output formatter source pad
Date: Tue, 24 Apr 2012 22:10:12 +0200
Message-ID: <2269542.7YJpMymPLc@avalon>
In-Reply-To: <20120424151420.GC7913@valkosipuli.localdomain>
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com> <14838654.TrzCLImese@avalon> <20120424151420.GC7913@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 24 April 2012 18:14:20 Sakari Ailus wrote:
> On Tue, Apr 24, 2012 at 11:08:12AM +0200, Laurent Pinchart wrote:
> > On Tuesday 24 April 2012 01:23:06 Sakari Ailus wrote:
> > > Hi Laurent,
> > > 
> > > The patch looks good as such on the first glance, but I have another
> > > question: why are you not using the selections API instead? It's in
> > > Mauro's tree already.
> > 
> > You're totally right, we need to convert the selection API. The reason why
> > I've implemented crop support at the CCDC output was simply that I needed
> > it for a project and didn't have time to implement the selection API. As
> > the code works, I considered it would be good to have it upstream until
> > we switch to the selection API.
> 
> "Until we switch to the selection API"? The subdev selection API is in
> Mauro's tree already so I see no reason not to use it. Implementing new
> functionality in a driver using API we've just marked obsolete is... not
> pretty.

You're of course totally right. I've pushed back on enough attemps similar to 
this one to know that I will have to give up here and implement selection 
support :-)

> The compatibility code for the old crop ioctls exist, too, so you get
> exactly the same functionality as well.
> 
> > > Also, the old S_CROP IOCTL only has been defined for sink pads, not
> > > source.
> > 
> > We're already using crop on source pads on sensors ;-)
> 
> Is that supposed to work? At the very least least it does not follow the
> spec.

It doesn't follow the spec. But it works :-)

-- 
Regards,

Laurent Pinchart

