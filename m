Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:45089 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0BORLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:11:40 -0500
Received: from MacBook-Pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KXW00BZE7QZS4T0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 15 Feb 2010 12:11:24 -0500 (EST)
Date: Mon, 15 Feb 2010 12:11:23 -0500
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx23885
In-reply-to: <hlbopr$v7s$1@ger.gmane.org>
To: Michael <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Message-id: <4B79803B.4070302@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <hlbe6t$kc4$1@ger.gmane.org>
 <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org>
 <4B795D1A.9040502@kernellabs.com> <hlbopr$v7s$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/15/10 10:21 AM, Michael wrote:
> Steven Toth wrote:
>
>>> Is this because the driver does not have the right capabilities or is it
>>> "just" a PCI-id missing in the driver?
>>
>> A mixture of both, analog support in the 885 driver is limited. Generally,
>> yes - start by adding the PCI id.
>>
>
> So, does this imply that you see a chance to get this card running? :-)
>
> If so, I will order one card and try. There is not much I want to do with
> the card. It should simply digitize an external camera signal. I want to
> display it with mplayer. It should, however, be reliable and not crash the
> system or drop the stream or whatever.
>
> So far, it seems that this is the only mini-pcie video digitizer card that
> exists. I would have taken a bttv based one instead, but as there is none...

The hardware has no mpeg encoder, so if by digitizer you mean raw high bitrate 
video frames then yes, and if mplayer is capable of supporting the v4l mmap 
interfaces then yes. (I've have zero experience of mplayer with raw video - not 
sure if this works).

It feels like a reach, the design looks like a 'same-old' cx23885/7/8 which you 
could potentially use in tvtime - with some work.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490

