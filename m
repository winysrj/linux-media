Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:34982 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab0DGCN2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 22:13:28 -0400
Subject: Re: RFC: exposing controls in sysfs
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mike Isely <isely@isely.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
In-Reply-To: <201004070039.20167.hverkuil@xs4all.nl>
References: <201004052347.10845.hverkuil@xs4all.nl>
	 <201004061327.05929.laurent.pinchart@ideasonboard.com>
	 <alpine.DEB.1.10.1004061008500.27169@cnc.isely.net>
	 <201004070039.20167.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Wed, 07 Apr 2010 04:10:37 +0200
Message-Id: <1270606237.3199.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 07.04.2010, 00:39 +0200 schrieb Hans Verkuil:
> On Tuesday 06 April 2010 17:16:17 Mike Isely wrote:
> > On Tue, 6 Apr 2010, Laurent Pinchart wrote:
> > 
> > > Hi Andy,
> > > 
> > > On Tuesday 06 April 2010 13:06:18 Andy Walls wrote:
> > > > On Tue, 2010-04-06 at 08:37 +0200, Hans Verkuil wrote:
> > > 
> > > [snip]
[snip]
> > code.  I don't know if that same strategy could be done in the V4L core.  
> > If it could, then this would probably alleviate a lot of concerns about 
> > testing / maintenance going forward.
> 
> In other words, yes, it could do this. And with relatively little work and
> completely transparent to all drivers.
> 
> But I have a big question mark whether we really want to go that way. The
> good thing about it is that the ioctls remain the primary API, as they should
> be. Anything like this will definitely be a phase 3 (or 4, or...), but it
> is at least nice to realize how easy it would be. That's a good sign of the
> quality of the code.
> 
> Regards,
> 
> 	Hans

that all looks really good now and quite promising, also IR/remote.

Maybe too good?

About what might be upcoming problems nobody is talking about currently.

Never seen before ...

I would wonder a lot, if we really should have made it close to such
with a lot of buffering all around ;)

Well, I guess the time on that beach might be short.

Manu gave some pointers previously that HD+ is a serious issue for us,
also it seems, that some lower level of firmware starts to hide GPIO's
and i2c addresses on recent boards.

We likely should stay hackish and able for quick responses and not
over-engineer convenience we do not really have.

Just my two cents.

Cheers,
Hermann




