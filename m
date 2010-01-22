Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:65163 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0AVR0R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 12:26:17 -0500
Subject: Re: About MPEG decoder interface
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Qiu <fallwind@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <201001221742.33679.hverkuil@xs4all.nl>
References: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com>
	 <1264129253.3094.5.camel@palomino.walls.org>
	 <201001221742.33679.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 12:25:55 -0500
Message-Id: <1264181155.5377.101.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-01-22 at 17:42 +0100, Hans Verkuil wrote:
> On Friday 22 January 2010 04:00:53 Andy Walls wrote:
> > On Fri, 2010-01-22 at 10:42 +0800, Michael Qiu wrote:
> > > Hi all,
> > > 
> > >   How can I export my MPEG decoder control interface to user space?
> > >   Or in other words, which device file(/dev/xxx) should a proper
> > > driver for mpeg decoder provide?
> > 
> > The MPEG decoder on a PVR-350 PCI card provides a /dev/video interface
> > (normally /dev/video16).
> > 
> > The interface specification to userspace is the V4L2 API:
> > 
> > http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html
> 
> Not really. The v4l2 API specifies the MPEG encoder part, but not the decode
> part.

Oops you are correct.  I confused/combined "MPEG Decoder" with "Video
output".

Regards,
Andy

