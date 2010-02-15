Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:33095 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0BOUxS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 15:53:18 -0500
Received: from MacBook-Pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KXW00MGYI0NQQF0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 15 Feb 2010 15:53:17 -0500 (EST)
Date: Mon, 15 Feb 2010 15:53:11 -0500
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx23885
In-reply-to: <hlcbhu$4s3$1@ger.gmane.org>
To: Michael <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Message-id: <4B79B437.5000004@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <hlbe6t$kc4$1@ger.gmane.org>
 <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org>
 <4B795D1A.9040502@kernellabs.com> <hlbopr$v7s$1@ger.gmane.org>
 <4B79803B.4070302@kernellabs.com> <hlcbhu$4s3$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Well if tvtime runs then mplayer will most probably, too. The question is,
> what means "with some work" :-)

If you haven't worked on the cx23885 driver in the past, and you're not 
accustomed to developing tv/video drivers then you're going to struggle, massively.

Not that I'm trying to discourage, on the contrary, the more driver developers 
the better. In reality this isn't something you can fix with an evenings work.

However, if you would like to take a shot then look at the existing support for 
the HVR1800 board in the cx23885 tree. Specifically look at the raw video 
support in the cx23885-video.c file and you'll also want to investigate the 
cx25840 driver for configuring the A/V subsystem.

Feel free to submit patches.

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490

