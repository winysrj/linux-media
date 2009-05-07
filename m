Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50195 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZEGXbr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 19:31:47 -0400
Subject: Scoping the effort to add a media controller )Re: [ivtv-users]
 Delay loading v4l-cx25840.fw)
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200905021749.29207.hverkuil@xs4all.nl>
References: <1241054296.3374.44.camel@palomino.walls.org>
	 <1241144496.22968.15.camel@palomino.walls.org>
	 <200905021749.29207.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Thu, 07 May 2009 19:33:11 -0400
Message-Id: <1241739191.4035.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-05-02 at 17:49 +0200, Hans Verkuil wrote:
> On Friday 01 May 2009 04:21:36 Andy Walls wrote:
> > On Wed, 2009-04-29 at 21:18 -0400, Andy Walls wrote:
> > > On Wed, 2009-04-29 at 13:33 +0200, Hans Verkuil wrote:

> >
> > Hans, it sounds like your media_controller device node idea is really
> > what we need to get implemented here for user space to do queires on
> > hardware.  This problem obviously affects more than the ivtv driver so
> > I'd recommend against an ivtv band-aid.
> >
> > We'd also want to coordinate with the hald folks and other user space
> > app/plumbing developers, as this likely affects a few v4l2 drivers.  It
> > sounds like an LPC agenda item to me...
> >
> > Regards,
> > Andy
> 
> I agree. A media controller device is exactly what we need. It's ideal for 
> applications and daemons like hald.
> 
> Now all I need is the time to work on it and I don't see that happening 
> anytime soon. :-(
> 
> Any volunteers? I have a general idea of how it should be implemented, but 
> it needs a fair amount of research as well.

I recall a design document or brief: can you provide a pointer to them?

What is the research that you think needs to be done?  

Regards,
Andy


> Regards,
> 
> 	Hans


