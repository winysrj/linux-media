Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:58758 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0DFPIZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 11:08:25 -0400
Date: Tue, 6 Apr 2010 10:08:24 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Markus Rechberger <mrechberger@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
In-Reply-To: <t2wd9def9db1004060444o3c251ed6g7967b9f594ebd421@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.1004061006160.27169@cnc.isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl>  <201004060837.24770.hverkuil@xs4all.nl>  <1270551978.3025.38.camel@palomino.walls.org>  <201004061327.05929.laurent.pinchart@ideasonboard.com>
 <t2wd9def9db1004060444o3c251ed6g7967b9f594ebd421@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Apr 2010, Markus Rechberger wrote:

   [...]

> 
> how about security permissions? while you can easily change the
> permission levels for nodes in /dev you can't do this so easily with
> sysfs entries.
> I don't really think this is needed at all some applications will
> start to use ioctl some other apps might
> go for sysfs.. this makes the API a little bit whacko

This is an excellent point.  I should have brought this up sooner.

The driver has control over the modes of the nodes in sysfs.  The driver 
does NOT have control over the owner / group of those nodes.  It is 
possible to change the owner / group from userspace, and I *think* it's 
possible to create a udev rule to do this, but honestly I have not 
investigated this possibility so I don't fully know.

This is one serious potential drawback to using sysfs as a driver API.

  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
