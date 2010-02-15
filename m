Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:48498 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0BOOlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 09:41:31 -0500
Received: from MacBook-Pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KXW0032V0T6N8D0@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 15 Feb 2010 09:41:31 -0500 (EST)
Date: Mon, 15 Feb 2010 09:41:30 -0500
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx23885
In-reply-to: <hlbhck$uh9$1@ger.gmane.org>
To: Michael <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Message-id: <4B795D1A.9040502@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <hlbe6t$kc4$1@ger.gmane.org>
 <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/15/10 8:15 AM, Michael wrote:
> Hi Andy
>
>>> Does anybody know whether this card is currently supported
>>
>> Likely no.  I have not checked the source to be sure.
>>
> Is this because the driver does not have the right capabilities or is it
> "just" a PCI-id missing in the driver?

A mixture of both, analog support in the 885 driver is limited. Generally, yes - 
start by adding the PCI id.

>
> The latter would be quite easy to add, I guess.
>>
>>> and if yes, is it
>>> by cx88 or by cx23885?
>>>
>>> http://www.commell.com.tw/Product/Surveillance/MPX-885.htm
>>>
>>> It is based on the Connexant 23885 chip but uses an Mini-PCIe interface.
>>
>> cx88 handles PCI bridge chips: CX2388[0123]
>>
>> cx23885 handles PCIe bridge chips: CX2388[578]
>>
>> > From the picture of the card from the datasheet it has a CX23885 chip.
>>
>
> That means, if a driver might support it, then the cx23885 driver not the
> cx88, correct?

Correct.


-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490

