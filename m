Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:55138 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109Ab0DHAwV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 20:52:21 -0400
Date: Wed, 7 Apr 2010 19:52:20 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
In-Reply-To: <201004070856.40867.hverkuil@xs4all.nl>
Message-ID: <alpine.DEB.1.10.1004071947520.5518@ivanova.isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl> <alpine.DEB.1.10.1004061008500.27169@cnc.isely.net> <201004070039.20167.hverkuil@xs4all.nl> <201004070856.40867.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 7 Apr 2010, Hans Verkuil wrote:

   [...]

> 
> Perhaps we should just not do this in sysfs at all but in debugfs? We have a
> lot more freedom there. No requirement of one-value-per-file, and if we need
> to we can change things in the future. It would actually be easier to issue
> ioctl commands to a driver from debugfs since we have a proper struct file
> there.
> 
> It could be implemented as a separate module that can be loaded if debugfs is
> enabled and suddenly you have all this extra debug functionality.
> 
> I admit, I would really enjoy writing something like this. I just don't want
> to do this in sysfs as that makes it too 'official' so to speak. In other words,
> mainline applications should not use sysfs, but home-grown scripts are free to
> use it as far as I am concerned.
> 
> How much of a problem would that be for you, Mike? On the one hand users have
> to mount debugfs, but on the other hand it will be consistent for all drivers
> that use the control framework. And you should be able to ditch a substantial
> amount of code :-)

Adding a debugfs interface that can be used by all V4L drivers is 
obviously a concept I would not have any problem with.

However that does not necessarily mean that I would agree with eventual 
removal of the pvrusb2 driver's existing sysfs interface.  That would 
depend on whether or not doing such a thing loses functionality and what 
the driver's user community would think about it.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
