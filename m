Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:57389 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbZFVSPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 14:15:25 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KLN00L7XK1FW170@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 22 Jun 2009 14:15:16 -0400 (EDT)
Date: Mon, 22 Jun 2009 14:15:12 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hauppauge HVR-1250 IR Support? (CX23885)
In-reply-to: <2840372.1245692029927.JavaMail.root@elwamui-ovcar.atl.sa.earthlink.net>
To: whelky-82852@mypacks.net
Cc: linux-media@vger.kernel.org
Message-id: <4A3FCA30.1050801@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <2840372.1245692029927.JavaMail.root@elwamui-ovcar.atl.sa.earthlink.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

whelky-82852@mypacks.net wrote:
> 
> -----Original Message-----
>> From: Steven Toth <stoth@kernellabs.com>
>> Sent: Jun 22, 2009 7:29 AM
>> To: whelky-82852@mypacks.net
>> Cc: linux-media@vger.kernel.org
>> Subject: Re: Hauppauge HVR-1250 IR Support? (CX23885)
>>
>> whelky-82852@mypacks.net wrote:
>>> I was wondering if anyone is working on IR support for this card? I looked through cx23885-cards.c and its not supported.
>>>
>>> 627         switch (dev->board) {
>>> 628         case CX23885_BOARD_HAUPPAUGE_HVR1250:
>>> 629         case CX23885_BOARD_HAUPPAUGE_HVR1500:
>>> 630         case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
>>> 631         case CX23885_BOARD_HAUPPAUGE_HVR1800:
>>> 632         case CX23885_BOARD_HAUPPAUGE_HVR1200:
>>> 633         case CX23885_BOARD_HAUPPAUGE_HVR1400:
>>> 634                 /* FIXME: Implement me */
>>> 635                 break;
>> Not currently.
>>
>> -- 
>> Steven Toth - Kernel Labs
>> http://www.kernellabs.com
> 
> Thanks for reply.
> 
> Are there some roadblocks that make this card different from others that are supported? Is is possible to take a working driver and tweak/hack it, or is it way more complex that that?

Time / motivation are the roadblock. It's a different IR design to all existing 
drivers so it needs a decent chunk of effort to bring it into life.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
