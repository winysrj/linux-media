Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m46KLWjI031046
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 16:21:32 -0400
Received: from mailout10.t-online.de (mailout10.t-online.de [194.25.134.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m46KKsCZ026880
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 16:20:55 -0400
Message-ID: <4820BD94.90005@t-online.de>
Date: Tue, 06 May 2008 22:20:36 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Emilio Lazo Zaia <emiliolazozaia@gmail.com>
References: <88771.83842.qm@web83107.mail.mud.yahoo.com>	
	<1209512868.5699.32.camel@palomino.walls.org>	
	<1209863718.546.24.camel@localhost.localdomain>	
	<481E1AD3.2060304@t-online.de>
	<1210045099.21581.6.camel@localhost.localdomain>
In-Reply-To: <1210045099.21581.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: MCE TV Philips 7135 Cardbus don't work
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



Emilio Lazo Zaia schrieb:
> ﻿Hi Hartmut!
> 
> This is a Cardbus adapter, so maybe I need to break in to have a
> look :-)
> If this is possible without a possible physical damage, I can try!
> 
You need to be careful but you can bend most modules open with a
not too sharp knife. You need to start this from the far side of the
cardbus connector.
I did this several times.

> What you say is that "no eeprom present" is not an error and can be
> ignored if the correct configuration is found the hard way?
>
yes.

> In the case of a PCI adapter, what can be deduced about the presence of
> these metal box? I saw some board with and without it.
> 
This box is the so-called tuner. It is important to know its type.

But before you open the module, you might try a "modprobe saa7134 card=55"
and watch the kernel log. If the driver tells you it found a tda8175(a),
we already learned a lot.


> Thanks,
> Regards!
> 
> El dom, 04-05-2008 a las 22:21 +0200, Hartmut Hackmann escribió:
> 
>> There are many saa713x based cards without eeprom. It stores the vendor ID and
>> - in many cases - the board configuration. For you this means
>> - you need to find out the configuration the hard way
>>    * identify the chips on the card
>>    * find the input configuration by try and error
>> - You will always need to force the card type with a card=xxx option, there is
>>    no way to automatically identify the card.
>>
>> So please have a close look at the card and write down all chip types. Is there
>> a metal box with the antenna connector on the card? What is its type?
>>
>> Hartmut

Good luck
   Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
