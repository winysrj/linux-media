Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm12-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.142]:23264 "HELO
	nm12-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751136Ab1KLPMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:12:48 -0500
Message-ID: <4EBE8B89.60108@yahoo.com>
Date: Sat, 12 Nov 2011 16:06:49 +0100
From: Norret Thierry <tnorret@yahoo.com>
MIME-Version: 1.0
To: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Any update on the Hauppauge WinTV-HVR-900H?
References: <4EBE73F4.4080002@technomancy.org> <4EBE8018.6010005@gmail.com> <4EBE84D7.5000800@yahoo.com> <CAGoCfiwV0qiWRv-8=S9+mJApUuepb+=i_i5ohcu0=CNvuz6rhw@mail.gmail.com>
In-Reply-To: <CAGoCfiwV0qiWRv-8=S9+mJApUuepb+=i_i5ohcu0=CNvuz6rhw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> You're talking about two different versions of the 900H.  You have to go
> by the USB IDs, and *not* the model number.  One of you has 2040:6600
> and the other has 2040:b138.  The 6600 version (which is a TM6000
> design) did work at one point.  The b138 (which is a cx231xx design) has
> never been supported.
> 
> Devin
> 
> 

Effectively I did not pay attention
We don't have the same card, mine is 2040:6600

>>>> Hi,
>>>>
>>>> I recently bought a Hauppauge WinTV-HVR-900H (usb id: 2040:b138), but I
>>>> see from this wiki page
>>>> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-900H that there is
>>>> no driver for it. However that's as of 2008.
>>>>
>>>> Has there been any progress on this since? Is that wiki page correct
>>>> that there is still no support for that card? Is there anyway to get
>>>> this USB device to work under linux?
>>>>
>>>> Thanks,
>>>>
>>>
>>> Hi Rory,
>>>
>>> If you search for the 900H, you'll find a thread titled "Hauppauge
>>> HVR900H don't work with kernel 3.*". The original submitter stated that
>>> it worked in 2.6.x, but when the computer was upgraded to a 3.x kernel,
>>> it stopped working.  This was two days ago (9 November 2011), so I'm not
>>> sure how much progress was made (if any).
>>>
>>> So, if your running a 2.6.x kernel, it *may* work, but it seems to be
>>> broken on the 3.x kernels (Ubuntu 11.10 or similar distros).
>>> Unfortunately I don't have that tuner, so I can't help out with it.
>>>
>>> I would say try it. You can check dmesg to see if the tuner is even
>>> being recognized (and drivers loaded). If so, then see if it works. If
>>> not, then you might need the latest build of the v4l. You can get
>>> information on installing the latest version from
>>>
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>>> .  Then make it (without your tuner plugged in) and try plugging it in
>>> again. Check dmesg again, and if it's recognized, try it.
>>>
>>> Sorry I couldn't find more information on this. Also if anyone else
>>> posts a reply, I would defer to their suggestions--as they have more
>>> experience with this than me.
>>>
>>> Have a good weekend.:)
>>> Patrick.
>>> --
>>>
>> I confirm, I've this card
>>
>> Support for this card is break since kernel 2.6.39
>> http://www.spinics.net/lists/linux-media/msg39917.html
>>
>> Building v4l from git don't solve the problem.
>> This card work fine with < 2.6.38 kernels.
>> --
>> 
