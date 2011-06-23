Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37781 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360Ab1FWSOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 14:14:40 -0400
Received: by qyk9 with SMTP id 9so1210149qyk.19
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2011 11:14:39 -0700 (PDT)
References: <22615.4194.11299-2628-1588834168-1307429140@seznam.cz> <201DD109-A022-4E54-B595-D9C08E8C1D87@wilsonet.com>
In-Reply-To: <201DD109-A022-4E54-B595-D9C08E8C1D87@wilsonet.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <EEA29F5D-467E-49BD-ACF8-210B1A18C268@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: "linux-media@vger.kernel.org Mailing List"
	<linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Last key repeated after every keypress on remote control (saa7134 lirc devinput driver)
Date: Thu, 23 Jun 2011 14:14:32 -0400
To: Radim <radim100@seznam.cz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jun 7, 2011, at 12:04 PM, Jarod Wilson wrote:

> On Jun 7, 2011, at 2:45 AM, Radim wrote:
> 
>> 
>>> ------------ Pôvodná správa ------------
>>> Od: Jarod Wilson <jarod@redhat.com>
>>> Predmet: Re: Last key repeated after every keypress on remote control (saa7134
>>> lirc devinput driver)
>>> Dátum: 06.6.2011 20:39:50
>>> ----------------------------------------
>>> Devin Heitmueller wrote:
>>>> On Mon, Jun 6, 2011 at 2:13 PM, Radim<radim100@seznam.cz>  wrote:
>>>>> Hello to everybody,
>>>>> I was redirected here from lirc mailinglist (reason is at the end).
>>>>> 
>>>>> I'm asking for any help because I wasn't able to solve
>>>>> this problem by my self (and google of course).
>>>>> 
>>>>> When I'm testing lirc configuration using irw, last pressed key is repeated
>>>>> just befor the new one:
>>>>> 
>>>>> after pressing key 1:
>>>>> 0000000080010002 00 KEY_1 devinput
>>>>> 
>>>>> after pressing key 2:
>>>>> 0000000080010002 00 KEY_1 devinput
>>>>> 0000000080010003 00 KEY_2 devinput
>>>>> 
>>>>> after pressing key 3:
>>>>> 0000000080010003 00 KEY_2 devinput
>>>>> 0000000080010004 00 KEY_3 devinput
>>>>> 
>>>>> after pressing key 4:
>>>>> 0000000080010004 00 KEY_3 devinput
>>>>> 0000000080010005 00 KEY_4 devinput
>>>>> 
>>>>> after pressing key 5:
>>>>> 0000000080010005 00 KEY_4 devinput
>>>>> 0000000080010006 00 KEY_5 devinput
>>>>> 
>>>>> 
>>>>> My configuration:
>>>>> Archlinux (allways up-to-date)
>>>>> Asus MyCinema P7131 with remote control PC-39
>>>>> lircd 0.9.0, driver devinput, default config file lirc.conf.devinput
>>>>> kernel 2.6.38
>>>>> 
>>>>> # ir-keytable
>>>>> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
>>>>>       Driver saa7134, table rc-asus-pc39
>>>>>       Supported protocols: NEC RC-5 RC-6 JVC SONY LIRC
>>>>>       Enabled protocols: RC-5
>>>>>       Repeat delay = 500 ms, repeat period = 33 ms
>>>>> 
>>>>> Answare from lirc-mainlinglist (Jarod Wilson):
>>>>> Looks like a bug in saa7134-input.c, which doesn't originate in lirc land,
>>>>> its from the kernel itself. The more apropos location to tackle this issue
>>>>> is linux-media@vger.kernel.org.
>>>>> 
>>>>> I can provide any other listings, just ask for them.
>>>>> 
>>>>> Thank you for any help,
>>>>> Radim
>>>> 
>>>> I actually sent Jarod a board specifically to investigate this issue
>>>> (the same issue occurs on the saa7134 based HVR-1150).  I believe it's
>>>> on his TODO list.
>>> Yep, he chopped out the part of my reply where I said as much. :)
>>> Just waiting on the IR receiver cable to arrive, could well be here in today's mail...
>> 
>> Oh, I misunderstood Jarod answer - he pointed me to this list as a right place for posting this possible bug in saa7134 driver, so I sent it also here. I was thinking that this is not a job for member of lirc developers, so I was trying luck here..
> 
> I work on both lirc and media tree drivers. In this case, lircd is doing
> exactly the right thing with the data its being fed, the bug is in the
> kernel driver, which is from the media tree. Best to discuss the bug on
> the list for the layer at which it exists. :)
> 
> (No cable yet, still awaiting its arrival).

Forgot to reply in this thread. Patch was posted last week that fixes
the repeat problem on the HVR-1150 Devin sent me. Best as I can tell
from looking at the saa7134 code and the particulars for your hardware,
that fix should solve your repeat issue as well.

-- 
Jarod Wilson
jarod@wilsonet.com



