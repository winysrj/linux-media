Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3HGIeUt032524
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 12:18:40 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3HGIGiO013199
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 12:18:26 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZH000OY99PCID0@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Thu, 17 Apr 2008 12:17:50 -0400 (EDT)
Date: Thu, 17 Apr 2008 12:17:48 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <480775F6.3030001@netvision.net.il>
To: amir sher <amir_in@netvision.net.il>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Message-id: <4807782C.5030001@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <480771AB.1030005@netvision.net.il> <48077400.8000605@linuxtv.org>
	<480775F6.3030001@netvision.net.il>
Cc: 
Subject: Re: support for Leadtek WinFast PxTV1200
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

amir sher wrote:
> 
> 
> Steven Toth wrote:
>> amir sher wrote:
>>> I have a pci express card, the Leadtek WinFast PxTV1200 which has a 
>>> CX23885 chip set and Xceive 2028 silicon tuner. As I understand the 
>>> latest kernel (2.6.25) has support for all of those components on 
>>> other cards but not specific to this one. Is it possible to add this 
>>> support for this card as well? I guess it shouldn't be too hard.
>>
>> Feel free to submit patches.
>>
>> - Steve
>>
> 
> I don't know how to submit patches. what I can do is submit any info you 
> might need (by running commands on command line...) and do the testing.

Don't remove the mailing list from the reply, I've CC'd them back in.

Wow, you actually managed to buy a TV card that doesn't do digital tv:

http://www.amazon.com/Leadtek-WinFast-PxTV1200-Express-Tuner/dp/B000XRR04O

The current cx23885 linux tree does not support analog TV on that 
particular design.

You're out of luck!

Personally, I'd return it an buy something decent.

Regards,

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
