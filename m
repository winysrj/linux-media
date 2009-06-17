Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:41136 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZFQKzc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 06:55:32 -0400
Subject: Re: Convert cpia driver to v4l2, drop parallel port version
 support?
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 06:56:07 -0400
Message-Id: <1245236167.3147.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-06-17 at 09:43 +0200, Hans Verkuil wrote:

> > I personally think that loosing support for the parallel port
> > version is ok given that the parallel port itslef is rapidly
> > disappearing, what do you think ?
> 
> I agree wholeheartedly. If we remove pp support, then we can also remove
> the bw-qcam and c-qcam drivers since they too use the parallel port.

Maybe I just like keeping old hardware up and running, but...

I think it may be better to remove camera drivers when a majority of the
actual camera hardware is likely to reach EOL, as existing parallel
ports will likely outlive the cameras.

My PC I got in Dec 2005 has a parellel port, as does the motherboard I
purchased 2008.

I have a 802.11g router (ASUS WL-500g) with a parallel port.  It works
nicely as a remote print server.  From my perspective, that parallel
port isn't going away anytime soon.


<irrelevant aside>
At least the custom firmware for the WL-500g
( http://oleg.wl500g.info/ ) has the ability to use webcams for snapping
pictures and emailing away a notification.  I'm pretty sure PP webcams
are not actually supported though.

The wireless router surveillance case is probably not relevant though,
as routers are usually using (very) old kernels.
</irrelevant aside>

-Andy

