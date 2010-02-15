Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:49625 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0BOXAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 18:00:53 -0500
Received: from MacBook-Pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KXW00B4LNXG1JH0@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 15 Feb 2010 18:00:52 -0500 (EST)
Date: Mon, 15 Feb 2010 18:00:51 -0500
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx23885
In-reply-to: <hlcjfi$unq$1@ger.gmane.org>
To: Michael <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Message-id: <4B79D223.4010909@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <hlbe6t$kc4$1@ger.gmane.org>
 <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org>
 <4B795D1A.9040502@kernellabs.com> <hlbopr$v7s$1@ger.gmane.org>
 <4B79803B.4070302@kernellabs.com> <hlcbhu$4s3$1@ger.gmane.org>
 <4B79B437.5000004@kernellabs.com> <hlch5h$ogp$1@ger.gmane.org>
 <hlciur$tb0$1@ger.gmane.org> <hlcjfi$unq$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/15/10 5:56 PM, Michael wrote:
> Well, this did not work. The cx23885 driver was not included in kernel
> 2.6.21, so no diff. The diff of the 2.6.21 cx25840 is twice as big as the
> 2.6.31 diff. :-(
>
> If anybody can give me a hint, what to include in a patch and what was old
> stuff that has jsut changed in 2.6.31, I'd be grateful.
>
> Attached is the diff of cx23885, the commell version against kernel
> 2.6.31.4.
>
>>
>> I'm downloading kernel 2.6.21 now and make a diff with these drivers.
>>

Start by patching the current cx23885 driver with all of the switch statements 
related to the new board CX23885_BOARD_MPX885.

-cards.c -core.c etc.

I already see some issues in their MPX885 additions, driving wrong gpios and 
assuming the encoder is attached - but it's a good start.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490

