Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:50377 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246Ab0DHA6W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 20:58:22 -0400
Date: Wed, 7 Apr 2010 19:58:21 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: hermann pitton <hermann-pitton@arcor.de>
cc: Lars Hanisch <dvb@cinnamon-sage.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
In-Reply-To: <alpine.DEB.1.10.1004071939510.5518@ivanova.isely.net>
Message-ID: <alpine.DEB.1.10.1004071957070.5518@ivanova.isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl>  <alpine.DEB.1.10.1004060848540.27169@cnc.isely.net>  <4BBCD3F9.1070207@cinnamon-sage.de> <1270678528.6429.35.camel@pc07.localdom.local> <alpine.DEB.1.10.1004071939510.5518@ivanova.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 7 Apr 2010, Mike Isely wrote:

> 
> Backwards compatibility is very important and thus any kind of new 
> interface deserves a lot of forethought to ensure that choices are made 
> in the present that people will regret in the future.  Making an 

"in the present that people will NOT (!!) regret in the future."

Holy cow, what a typo...  :-)

  -Mike

> interface self-describing is one way that helps with compatibility: if 
> the app can discover on its own how to use the interface then it can 
> adapt to interface changes in the future.  I think a lot of people get 
> their brains so wrapped around the "ioctl-way" of doing things and then 
> they try to map that concept into a sysfs-like (or debugfs-like) 
> abstraction that they don't see how to naturally take advantage of what 
> is possible there.
> 
>   -Mike
> 
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
