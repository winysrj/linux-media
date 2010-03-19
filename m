Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34522 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0CSPSk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:40 -0400
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
In-Reply-To: <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>
	 <201003190904.53867.laurent.pinchart@ideasonboard.com>
	 <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Fri, 19 Mar 2010 11:17:44 -0400
Message-Id: <1269011864.3073.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-03-19 at 09:46 +0100, Hans Verkuil wrote:
> > On Friday 19 March 2010 08:59:08 Hans Verkuil wrote:
> >> Hi all,
> >>
> >> V4L1 support has been marked as scheduled for removal for a long time.
> >> The
> >> deadline for that in the feature-removal-schedule.txt file was July
> >> 2009.
> >>
> >> I think it is time that we remove the V4L1 compatibility support from
> >> V4L2
> >> drivers for 2.6.35.
> >

> This means that V4L2 drivers can only be used by V4L2-aware applications
> and can no longer be accessed by V4L1-only applications.

>From user reports I've seen lately, it looks like Debian (or some Debian
derivative) is not packaging v4l2-ctl, etc. but only the older v4lctl
and related utilities.  Can anyone verify this?

If that is so, I anticipate end user complaints coming in.  I wouldn't
cut the V4L1 inetrface out until we've got v4l2-ctl and friends in a
repository that is easily packaged as stand alone utils - separate from
the v4l-dvb driver tree.  And perhaps a link on the webpage for
packagers and end users to find the v4l2 utils would head off some
complaints.

Regards,
Andy

