Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56903 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755308Ab2ACVDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jan 2012 16:03:46 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 465F120B61
	for <linux-media@vger.kernel.org>; Tue,  3 Jan 2012 16:03:46 -0500 (EST)
Date: Tue, 3 Jan 2012 12:55:39 -0800
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [patch -longterm] V4L/DVB: v4l2-ioctl: integer overflow in
 video_usercopy()
Message-ID: <20120103205539.GC17131@kroah.com>
References: <20111215063445.GA2424@elgon.mountain>
 <4EE9BC25.7020303@infradead.org>
 <201112151033.35153.hverkuil@xs4all.nl>
 <4EE9C2E6.1060304@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE9C2E6.1060304@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 15, 2011 at 07:50:30AM -0200, Mauro Carvalho Chehab wrote:
> On 15-12-2011 07:33, Hans Verkuil wrote:
> > On Thursday, December 15, 2011 10:21:41 Mauro Carvalho Chehab wrote:
> >> On 15-12-2011 04:34, Dan Carpenter wrote:
> >>> On a 32bit system the multiplication here could overflow.  p->count is
> >>> used in some of the V4L drivers.
> >>
> >> ULONG_MAX / sizeof(v4l2_ext_control) is too much. This ioctl is used on things
> >> like setting MPEG paramenters, where several parameters need adjustments at
> >> the same time. I risk to say that 64 is probably a reasonably safe upper limit.
> > 
> > Let's make it 1024. That gives more than enough room for expansion without taking
> > too much memory.
> >
> > Especially for video encoders a lot of controls are needed, and sensor drivers
> > are also getting more complex, so 64 is a bit too low for my taste.
> > 
> > I agree that limiting this to some sensible value is a good idea.
> 
> I'm fine with 1024. Yet, this could easily be changed to whatever upper value needed,
> and still be backward compatible.

Ok, can someone please send me the "accepted" version of this patch for
inclusion in the 2.6.32-stable tree?

thanks,

greg k-h
