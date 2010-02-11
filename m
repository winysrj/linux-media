Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:64554 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab0BKQMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 11:12:44 -0500
Received: from MacBook-Pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KXO00HV8OZ656W0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 11 Feb 2010 10:42:43 -0500 (EST)
Date: Thu, 11 Feb 2010 10:42:41 -0500
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: New Hauppauge HVR-2200 Revision?
In-reply-to: <4B7412CC.6010003@barber-family.id.au>
To: Francis Barber <fedora@barber-family.id.au>
Cc: linux-media@vger.kernel.org
Message-id: <4B742571.4010104@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B5B0E12.3090706@barber-family.id.au>
 <83bcf6341001230700h7db6600i89b9092051049612@mail.gmail.com>
 <4B5B837A.6020001@barber-family.id.au>
 <83bcf6341001231529o54f3afb9p29fa955bc93a660e@mail.gmail.com>
 <4B5B8E5B.4020600@barber-family.id.au>
 <83bcf6341001231618r59f03dc9t1eb746c39e67b5fc@mail.gmail.com>
 <4B5BF61A.4000605@barber-family.id.au> <4B73F6AC.5040803@barber-family.id.au>
 <4B7412CC.6010003@barber-family.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I was also wondering if it might help to use the latest firmware? I
>> got the drivers from here
>> http://www.hauppauge.com/site/support/support_hvr2250.html. Looking at
>> your extract script, it is trivial to get the saa7164 firmware but
>> I've no idea how you calculated the offsets tda10048 firmware. Would
>> you have any pointers on this?

I've been testing new saa7164 firmware recently and I'm ok with it, I plan to 
push those changes into saa7164-stable in the next few days.

TDA10048 firmware rev'ing - I haven't yet looked at, although it's on my todo list.

>>
>> Anyway, apart from the problems noted above it is fine. I'm not sure
>> what the criteria is for merging support for this card into the main
>> repository, but I would view it as worthy of merging even with these
>> problems outstanding.
>>
>> Many thanks,
>> Frank.
>>
> Interestingly, so far it only seems to affect the second adapter. The
> first one is still working.

Curious.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490

