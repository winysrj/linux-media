Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49703 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2IYAfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 20:35:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>, remi@remlab.net
Subject: Re: [RFC] Timestamps and V4L2
Date: Tue, 25 Sep 2012 02:35:47 +0200
Message-ID: <32114057.tIVjSTYujk@avalon>
In-Reply-To: <505F57A4.3040409@gmail.com>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <20120922202814.GA4891@minime.bse> <505F57A4.3040409@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sunday 23 September 2012 20:40:36 Sylwester Nawrocki wrote:
> On 09/22/2012 10:28 PM, Daniel Glöckner wrote:
> > On Sat, Sep 22, 2012 at 07:12:52PM +0200, Sylwester Nawrocki wrote:
> >> If we ever need the clock selection API I would vote for an IOCTL.
> >> The controls API is a bad choice for something such fundamental as
> >> type of clock for buffer timestamping IMHO. Let's stop making the
> >> controls API a dumping ground for almost everything in V4L2! ;)
> >> 
> >> Perhaps VIDIOC_QUERYBUF and VIDIOC_DQBUF should be reporting
> >> timestamps type only for the time they are being called. Not per buffer,
> >> per device. And applications would be checking the flags any time they
> >> want to find out what is the buffer timestamp type. Or every time if it
> >> don't have full control over the device (S/G_PRIORITY).
> > 
> > I'm all for adding an IOCTL, but if we think about adding a
> > VIDIOC_S_TIMESTAMP_TYPE in the future, we might as well add a
> > VIDIOC_G_TIMESTAMP_TYPE right now. Old drivers will return ENOSYS,
> > so the application knows it will have to guess the type (or take own
> > timestamps).
> 
> Hmm, would it make sense to design a single ioctl that would allow
> getting and setting the clock type, e.g. VIDIOC_CLOCK/TIMESTAMP_TYPE ?
> 
> > I can't imagine anything useful coming from an app that has to process
> > timestamps that change their source every now and then and I seriously
> > doubt anyone will go to such an extent that they check the timestamp
> > type on every buffer. If they don't set their priority high enough to
> > prevent others from changing the timestamp type, they also run the
> > risk of someone else changing the image format. It should be enough to
> > forbid changing the timestamp type while I/O is in progress, as it is
> > done for VIDIOC_S_FMT.
> 
> I agree, but mem-to-mem devices can have multiple logically independent,
> "concurrent" streams active. If the clock type is per device it might
> not be that straightforward...

Does the clock type need to be selectable for mem-to-mem devices ? Do device-
specific timestamps make sense there ?

-- 
Regards,

Laurent Pinchart

