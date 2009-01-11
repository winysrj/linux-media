Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56939 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbZAKNpS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 08:45:18 -0500
Subject: Early insights from conversion of cx18 to new v4l2_device framework
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
In-Reply-To: <1231650228.10110.67.camel@palomino.walls.org>
References: <1231650228.10110.67.camel@palomino.walls.org>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 08:46:29 -0500
Message-Id: <1231681589.3112.37.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


 
> > > I'm very interested in how easy it is for you to convert cx18 to 
> > > v4l2_subdev. Please let me know anything that is unclear or that can be 
> > > improved in the documentation or code!

Hans,

Converting cx18 to use a v4l2_device object was easy enough.  There's
not a lot to do, because on it's own it doesn't do to much.  At this
early stage, without the v4l2_subdev work done, it's simply one more
piece of kernel rigamarole with which to deal, along with struct
pci_dev, struct device, struct video_dev.

As I begin the conversion process to v4l2_subdev, I realize it's not the
straightforward hack for which I was hoping.  A clear first step in the
porting process needs to be to answer design questions:

1. What are the v4l2_subdev's for this family of capture devices?  (This
is actually harder to answer than I thought.)

2. Do I need to write any bridge specific v42l_subdev's?

3. What functions do all the needed v4l2_subdev's perform?

4. What functions will I need from all the functions a chip/v4l2_subdev
provides?

5. How will I manage the subdevs to get at just the particular subdev
functions I need for any given task?

6. Do I try to deal with the DTV subdevices on my hybrid cards now, or
wait until later?

These are all up front design questions that I would have done on a
professional project with a full up front design.  What I found with
trying to iteratively hack was that decisions come up at many junctures
with porting this framework to cx18.  I suspect the framework will be
great for maintenance activities once in place, but initial porting of
existing drivers probably requires an above average level of discipline.

I will elaborate on how I encountered the design questions above, later
today (I've got to head to out soon).  I'll also propose what I think is
some guidance to answer question 1 at least. (For highly integrated
devices with loose internal couplings in places, like CX23418, it's not
as simple as a "chip" or "something connected to I2C, GPIO or other bus
lines".)

Regards,
Andy

