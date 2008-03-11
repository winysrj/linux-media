Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BM2cii006450
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 18:02:38 -0400
Received: from mailout04.sul.t-online.com (mailout04.sul.t-online.de
	[194.25.134.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2BM25TP027988
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 18:02:05 -0400
Message-ID: <47D7015C.3090904@t-online.de>
Date: Tue, 11 Mar 2008 23:02:04 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <200801051252.18108.tux@schweikarts-vom-dach.de>	
	<200802272151.19488.tux@schweikarts-vom-dach.de>	
	<47CC8094.8000106@t-online.de>	
	<200803101942.40158.tux@schweikarts-vom-dach.de>	
	<47D5A68C.7070004@t-online.de>
	<1205196280.6940.12.camel@pc08.localdom.local>
In-Reply-To: <1205196280.6940.12.camel@pc08.localdom.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, tux@schweikarts-vom-dach.de
Subject: Re: DVB-S on quad TV tuner card from Medion PC MD8800
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

Hi,

hermann pitton schrieb:
> Hi,
> 
> Am Montag, den 10.03.2008, 22:22 +0100 schrieb Hartmut Hackmann:
>> HI
>>
>> Tux schrieb:
>>> Hello Hartmut,
>>>
>>> sorry that it has taken so long time to test it. I have tried it with option 
>>> use_frontend=1,1 and now it is posible to watch TV on the other
>>> port.
>>>
>>> best regards
>>>
>>> Tux
>>>
>>> Am Montag, 3. März 2008 23:49:56 schrieben Sie:
>>>> Hi
>>>>
>>>> Tux schrieb:
>>>>> Hello Hartmut,
>>>>>
>>>>> i have tried the new driver. You are completely right, one port is
>>>>> working perfectly. But the other one not. What Information do you need to
>>>>> fix it ?
>>>>>
>>>>>
>>>>> best regards
>>>> <snip>
>>>>
>>>> in my personal repository: http://linuxtv.org/hg/~hhackmann/v4l-dvb/
>>>> i tried to make the 2nd section work too. I don't know which gpo is
>>>> the right one to control the LNB supply, i need you to find out whether
>>>> switching the polarization works.
>>>> There are remaining restrictions:
>>>> - the 2nd DVB-S section only works if the first is configured for DVB-S
>>>> too. so "options saa7134-dvb use_frontend=0,1" won't work, but
>>>> use_frontend=1,0 and use_frontend=1,1 should.
>>>> - currently it is not possible to choose the higher LNB voltage (14v
>>>> instead of 13v) - it is not possible to power down the 2nd LNB supply
>>>> independently. These are due to the fact that it is not possible to access
>>>> the LNB supply chip via the i2c bus fron the second section of the card.
>>>>
>>>> Happy testing
>>>>   Hartmut
>>>>
>> It's fully working? Great!
>> I expected more trouble. I'd like to rework the code a bit before i ask
>> Mauro to pull. May I ask you to test again in some days?
>>
>>
>> Best regards
>>   Hartmut
>>
> 
> this is really very good progress now, given that previously on such OEM
> and special devices testing abilities have been restricted for almost
> all of us. Nevertheless, they are in substantial numbers in the markets.
>
Indeed. I was aware of this. And there are still some well known cards left ...

> What makes me still wonder a little, since I can't test almost nothing
> on the second 0008 subdevice, how to deal with the RF loopthrough, this
> I can test and is active in both directions for what I can say.
> 
IMHO, a RF loopthrough makes no sense for satellite. I had a glance at the
datasheet of the tda8262 - it has a configurable loopthrough.
But lets deal with this later:
While i worked on the "need analog first issue", i noticed that currently the
LNA support of the tda8275a is heavily broken - it even causes a kernel oops.
I should fix this first.

Best regards
   Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
