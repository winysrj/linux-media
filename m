Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2203 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab0IMNEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 09:04:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc driver
Date: Mon, 13 Sep 2010 15:03:52 +0200
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <201009122226.11970.hverkuil@xs4all.nl> <201009130902.30242.hverkuil@xs4all.nl> <1284382595.2031.51.camel@morgan.silverblock.net>
In-Reply-To: <1284382595.2031.51.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131503.52803.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, September 13, 2010 14:56:35 Andy Walls wrote:
> On Mon, 2010-09-13 at 09:02 +0200, Hans Verkuil wrote:
> > On Sunday, September 12, 2010 23:12:42 Andy Walls wrote:
> > > On Sun, 2010-09-12 at 22:26 +0200, Hans Verkuil wrote:
> > > 
> > > > And other news on the V4L1 front:
> > > 
> > > > I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
> > > > support can be removed from that driver as well.
> > > 
> > > FYI, that will break this 2005 vintage piece of V4L1 software people may
> > > still be using for the QX5 microscope:
> > > 
> > > http://www.cryptoforge.net/qx5/qx5view/
> > > http://www.cryptoforge.net/qx5/qx5view/qx5view-0.5.tar.gz
> > 
> > Why? qx5view has support for v4l2 as well.
> 
> The frontend.c file in the tar archive used these ioctls:
> 
> VIDIOCSYNC
> VIDIOCSPICT
> VIDIOCMCAPTURE
> VIDIOCSWIN
> VIDIOCGCAP
> VIDIOCGWIN
> VIDIOCGMBUF
> 
> I could have sworn those were V4L1.  But in any case, I forgot we have a
> V4L1 compat layer in place.

True, but there is also a HAVE_V4L2 define that enables v4l2 support. Whether
it works is another matter :-)

In any case, if this is a really useful application, then we can add it to
git. Or enhance e.g. qv4l2 to be able to handle this gracefully.

Regards,

	Hans

> 
> Please disregard.
> 
> I apparently need to spend spend more time reading and testing to get my
> fact straight lately, and less time clicking the send button on
> emails. :P
> 
> Regards,
> Andy
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
