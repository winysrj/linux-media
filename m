Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:51282 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab0IOUOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 16:14:48 -0400
Message-ID: <4C912935.7010109@iki.fi>
Date: Wed, 15 Sep 2010 23:14:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gregory Orange <gregory.orange@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Leadtek DTV2000DS remote
References: <AANLkTi=1cucc=LrMEp44xpWs=_f75C7iAgXfkC+r5dPP@mail.gmail.com> <AANLkTi=zhzZ9RJwRzUt_Ftg9sHDzBhuw7cUss-dXQoSs@mail.gmail.com>
In-Reply-To: <AANLkTi=zhzZ9RJwRzUt_Ftg9sHDzBhuw7cUss-dXQoSs@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Leadtek WinFast DTV2000DS remote is not supported at all. Leadtek 
WinFast DTV Dongle Gold remote is. If you can compile and install latest 
drivers from http://git.linuxtv.org/anttip/media_tree.git af9015 tree I 
can add support for that remote rather easily.

Antti



On 09/15/2010 10:45 AM, Gregory Orange wrote:
> Shall I assume that noone has had any experience with one of these
> devices? From some input from other sources, I'm now not sure if I
> lack a kernel module, or perhaps the firmware for this device isn't
> supported (or somesuch - a bit confused on that).
>
> In any case, pretty well everything is now working including EIT at
> last. The remote is all I lack. I have no idea who else to ask or what
> to try, so I may try borrowing a different remote. I'm all Googled out
> (:
>
> Regards,
> Greg.
>
> On 9 September 2010 22:11, Gregory Orange<gregory.orange@gmail.com>  wrote:
>> Hi all, first post.
>>
>> I have a newly purchased Leadtek DTV2000DS dual tuner card in my
>> machine, configured and running in Mythbuntu 10.04 (after installing
>> latest v4l-dvb from source). I am having a bit of trouble getting the
>> supplied remote control working. Is anyone here able to assist? I
>> asked on the LIRC sf.net list and after a bit of back and forth I was
>> directed to see if you guys can help me. In particular I wonder if the
>> author of dvb_usb_af9015 and af9013 is around - hmm, seems to be Antti
>> Palosaari, who seems to be a fairly recent poster. Don't get me wrong
>> though - anyone who can assist would be great (:
>>
>> I have confirmed that the hardware works - I installed the drivers in
>> a Windows boot, and the remote works.
>>
>> In terms of driver support I'm not sure exactly what I'm looking for,
>> but there is this line in dmesg:
>> [   22.263721] input: IR-receiver inside an USB DVB receiver as
>> /devices/pci0000:00/0000:00:0e.0/0000:02:0a.2/usb2/2-1/input/input5
>>
>> cat /proc/bus/input/devices yields
>> I: Bus=0003 Vendor=0413 Product=6a04 Version=0200
>> N: Name="IR-receiver inside an USB DVB receiver"
>> P: Phys=usb-0000:02:0a.2-1/ir0
>> S: Sysfs=/devices/pci0000:00/0000:00:0e.0/0000:02:0a.2/usb2/2-1/input/input5
>> U: Uniq=
>> H: Handlers=kbd event5
>> B: EV=3
>> B: KEY=108fc310 2802891 0 0 0 0 118000 200180 4803 e1680 0 100000 ffe
>>
>> So I've been using /dev/input/event5 in my tests. I have tried using
>> evtest, mode2, and irw to no avail. I get no indication of any signal
>> coming from the remote. Am I missing a kernel driver module? Any
>> further advice or specific experience with this device would be
>> gratefully welcomed.
>>
>> Cheers,
>> Greg.
>>
>> --
>> Gregory Orange
>>
>
>
>


-- 
http://palosaari.fi/
