Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37271 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0DFL0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 07:26:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: exposing controls in sysfs
Date: Tue, 6 Apr 2010 13:27:04 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mike Isely <isely@isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl> <201004060837.24770.hverkuil@xs4all.nl> <1270551978.3025.38.camel@palomino.walls.org>
In-Reply-To: <1270551978.3025.38.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004061327.05929.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Tuesday 06 April 2010 13:06:18 Andy Walls wrote:
> On Tue, 2010-04-06 at 08:37 +0200, Hans Verkuil wrote:

[snip]

> > Again, I still don't know whether we should do this. It is dangerously
> > seductive because it would be so trivial to implement.
> 
> It's like watching ships run aground on a shallow sandbar that all the
> locals know about.  The waters off of 'Point /sys' are full of usability
> shipwrecks.  I don't know if it's some siren's song, the lack of a light
> house, or just strange currents that deceive even seasoned
> navigators....
> 
> Let the user run 'v4l2-ctl -d /dev/videoN -L' to learn about the control
> metatdata.  It's not as easy as typing 'cat', but the user base using
> sysfs in an interactive shell or shell script should also know how to
> use v4l2-ctl.  In embedded systems, the final system deployment should
> not need the control metadata available from sysfs in a command shell
> anyway.

I fully agree with this. If we push the idea one step further, why do we need 
to expose controls in sysfs at all ?

-- 
Regards,

Laurent Pinchart
