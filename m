Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:41974 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0G0UJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 16:09:47 -0400
Received: from TheShoveller.local
 (ool-18bfe781.dyn.optonline.net [24.191.231.129]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0L6800JHFG094FR0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 27 Jul 2010 16:09:45 -0400 (EDT)
Date: Tue, 27 Jul 2010 16:09:45 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Unknown CX23885 device
In-reply-to: <4C4F31A7.8060609@iversen-net.dk>
To: Christian Iversen <chrivers@iversen-net.dk>
Cc: linux-media@vger.kernel.org
Message-id: <4C4F3D09.2060405@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4C4F31A7.8060609@iversen-net.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7/27/10 3:21 PM, Christian Iversen wrote:
> (please CC, I'm not subscribed yet)
>
> Hey Linux-DVB people
>
> I'm trying to make an as-of-yet unsupported CX23885 device work in Linux.

http://kernellabs.com/hg/~stoth/cx23885-mpx/

Try this and if necessary module option card=29.

Any good?

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com


