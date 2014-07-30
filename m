Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42005 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaG3UwZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 16:52:25 -0400
Message-ID: <53D95B04.2030109@iki.fi>
Date: Wed, 30 Jul 2014 23:52:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bjoern <lkml@call-home.ch>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>
Subject: Re: ddbridge -- kernel 3.15.6
References: <53C920FB.1040501@grumpydevil.homelinux.org>	 <53CAAF9D.6000507@kaiser-linux.li> <1406697205.2591.13.camel@bjoern-W35xSTQ-370ST> <53D8EC86.6020701@iki.fi>
In-Reply-To: <53D8EC86.6020701@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/30/2014 04:00 PM, Antti Palosaari wrote:
>
>
> On 07/30/2014 08:13 AM, Bjoern wrote:
>>> Hello Rudy
>>>
>>> I use a similar card from Digital Devices with Ubuntu 14.04 and
>>> kernel 3.13.0-32-generic. Support for this card was not build into
>>> the kernel and I had to compile it myself. I had to use
>>> media_build_experimental from Mr. Endriss.
>>>
>>> http://linuxtv.org/hg/~endriss/media_build_experimental
>>>
>>> Your card should be supported with this version.
>>>
>>> Regards, Thomas
>>
>> Hi Rudy,
>>
>> What Thomas writes is absolutely correct...
>>
>> This is unfortunately the worst situation I've ever run across in
>> Linux... There was a kernel driver that worked and was supported by
>> Digital Devices. Then, from what I read, changes to how the V4L drivers
>> have to be written was changed - Digital Devices doesn't like that and
>> they force users to use "experimental" builds which are the "old
>> style".
>>
>> This is total rubbish imo - if this is how it was decided that the
>> drivers have to be nowadays then adjust them. Why am I paying such a lot
>> of money others right, these DD cards are really not cheap?
>>
>> Some attempts have been made by people active here to adapt the drivers
>> and make them work in newer kernels, but so far no one has succeeded.
>> Last attempt was in Jan 2014 iirc, since then - silence.
>>
>> I wish I could help out, I can code but Linux is well just a bit more
>> "difficult" I guess ;-)
>
> I have one of such device too, but I have been too busy all the time
> with other drivers...
>
> Basically these DTV drivers should be developed in a order, bridge
> driver first, then demod and tuner - for one single device. After it is
> committed in tree, you could start adding new devices and drivers. If
> you try implement too big bunch of things as a once, you will likely
> fail endless reviews and so.
>
> I don't know what is change in development process which causes these
> problems. What I remember there has been only few big changes in recent
> years, change from Mercurial to Git and reorganization of
> directories/files.

Device I have seems to be:
DD Cine S2 V6.5 - Twin Tuner Card DVB-S/S2 (PCI Express Card)
DD DuoFlex C/C2/T/T2 Expansion (V3) - Twin Tuner Expansion-modul DVB-C/T/T2

I will start looking DVB-S/S2 support at the very first as it is the 
bridge needed in any case. I have no experience from PCIe devices...

regards
Antti

-- 
http://palosaari.fi/
