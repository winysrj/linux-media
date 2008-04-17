Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3HGsFU8026820
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 12:54:15 -0400
Received: from mxout2.netvision.net.il (mxout2.netvision.net.il [194.90.9.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3HGs3Ob008324
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 12:54:04 -0400
Received: from [192.168.2.100] ([85.250.225.146]) by mxout2.netvision.net.il
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTPA id <0JZH00M7YAXYMD00@mxout2.netvision.net.il> for
	video4linux-list@redhat.com; Thu, 17 Apr 2008 19:53:58 +0300 (IDT)
Date: Thu, 17 Apr 2008 19:53:58 +0300
From: amir sher <amir_in@netvision.net.il>
In-reply-to: <4807782C.5030001@linuxtv.org>
To: Steven Toth <stoth@linuxtv.org>
Message-id: <480780A6.40600@netvision.net.il>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <480771AB.1030005@netvision.net.il> <48077400.8000605@linuxtv.org>
	<480775F6.3030001@netvision.net.il> <4807782C.5030001@linuxtv.org>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
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



Steven Toth wrote:
> amir sher wrote:
>>
>>
>> Steven Toth wrote:
>>> amir sher wrote:
>>>> I have a pci express card, the Leadtek WinFast PxTV1200 which has a 
>>>> CX23885 chip set and Xceive 2028 silicon tuner. As I understand the 
>>>> latest kernel (2.6.25) has support for all of those components on 
>>>> other cards but not specific to this one. Is it possible to add this 
>>>> support for this card as well? I guess it shouldn't be too hard.
>>>
>>> Feel free to submit patches.
>>>
>>> - Steve
>>>
>>
>> I don't know how to submit patches. what I can do is submit any info 
>> you might need (by running commands on command line...) and do the 
>> testing.
> 
> Don't remove the mailing list from the reply, I've CC'd them back in.
> 
> Wow, you actually managed to buy a TV card that doesn't do digital tv:
> 
> http://www.amazon.com/Leadtek-WinFast-PxTV1200-Express-Tuner/dp/B000XRR04O
> 
> The current cx23885 linux tree does not support analog TV on that 
> particular design.
> 
> You're out of luck!
> 
> Personally, I'd return it an buy something decent.
> 
> Regards,
> 
> - Steve
> 
sorry for that, thank you so much for your help I'll do what you 
recommended.
Amir

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
