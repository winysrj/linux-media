Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:39279 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab0DFPQS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 11:16:18 -0400
Date: Tue, 6 Apr 2010 10:16:17 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
In-Reply-To: <201004061327.05929.laurent.pinchart@ideasonboard.com>
Message-ID: <alpine.DEB.1.10.1004061008500.27169@cnc.isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl> <201004060837.24770.hverkuil@xs4all.nl> <1270551978.3025.38.camel@palomino.walls.org> <201004061327.05929.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Apr 2010, Laurent Pinchart wrote:

> Hi Andy,
> 
> On Tuesday 06 April 2010 13:06:18 Andy Walls wrote:
> > On Tue, 2010-04-06 at 08:37 +0200, Hans Verkuil wrote:
> 
> [snip]
> 
> > > Again, I still don't know whether we should do this. It is dangerously
> > > seductive because it would be so trivial to implement.
> > 
> > It's like watching ships run aground on a shallow sandbar that all the
> > locals know about.  The waters off of 'Point /sys' are full of usability
> > shipwrecks.  I don't know if it's some siren's song, the lack of a light
> > house, or just strange currents that deceive even seasoned
> > navigators....
> > 
> > Let the user run 'v4l2-ctl -d /dev/videoN -L' to learn about the control
> > metatdata.  It's not as easy as typing 'cat', but the user base using
> > sysfs in an interactive shell or shell script should also know how to
> > use v4l2-ctl.  In embedded systems, the final system deployment should
> > not need the control metadata available from sysfs in a command shell
> > anyway.
> 
> I fully agree with this. If we push the idea one step further, why do we need 
> to expose controls in sysfs at all ?

I have found it useful to have the sysfs interface within the pvrusb2 
driver.

If it is going to take a lot of work to specifically craft a sysfs 
interface that exports the V4L API, then it will probably be a pain to 
maintain going forward.  By "a lot of work" I mean that each V4L API 
function would have to be explicitly coded for in this interface, thus 
as the V4L API evolves over time then extra work must be expended each 
time to keep the sysfs interface in step.  If that is to be the case 
then it may not be worth it.

In the pvrusb2 driver this has not been the case because the code I 
wrote which implements the sysfs interface for the driver does this 
programmatically.  That is, there is nothing in the pvrusb2-sysfs.c 
module which is specific to a particular function.  Instead, when the 
module initializes it is able to enumerate the API on its own and 
generate the appropriate interface for each control it finds.  Thus as 
the pvrusb2 driver's implementation has evolved over time, the sysfs 
implementation has simply continues to do its job, automatically 
reflecting internal changes without any extra work in that module's 
code.  I don't know if that same strategy could be done in the V4L core.  
If it could, then this would probably alleviate a lot of concerns about 
testing / maintenance going forward.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
