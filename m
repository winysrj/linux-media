Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61262 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0KFWuR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Nov 2010 18:50:17 -0400
Received: by yxk8 with SMTP id 8so2797404yxk.19
        for <linux-media@vger.kernel.org>; Sat, 06 Nov 2010 15:50:17 -0700 (PDT)
Message-ID: <4CD5DC63.5060406@gmail.com>
Date: Sat, 06 Nov 2010 18:53:23 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Proftuners S2-8000 support
References: <AANLkTi=LedNdgYkBa2Si3dpnnMDqPv=zr=AVx3GkM3GD@mail.gmail.com>	<4CD559C6.7040106@gmail.com> <20101106235338.33ba4e26@bk.ru>
In-Reply-To: <20101106235338.33ba4e26@bk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Goga777 a écrit :
>>> I have recently purchased Proftuners S2-8000 PCI-e card which consist of :
>>>
>>> * CX23885 pci-e interface
>>> * STB6100 Frontend
>>> * STV0900 Demodulator
>>>
>>> Vendor company supposed that card has Linux support via additional
>>> patch in their support page. I applied patch to v4l-dvb and
>>> s2-liplianin repositories. Patched source compiled and modules loaded
>>> successfully, but it didn't work properly. I got mass of error
>>> messages below, during launching VDR application.
>>>
>>> Insructions: http://www.proftuners.com/driver8000.html
>>> Patch: http://www.proftuners.com/sites/default/files/prof8000.patch
>>>
>>>   
>>>       
>> So... any news for support and 45Msps DVB-S2 capability?
>>     
>
> the card is working with patch 
> http://linuxdvb.org.ru/wbb/index.php?page=Thread&postID=17602#post17602
>
> but why are you interesting so high SR for dvb-s2 ? For me the dvb-s2 channels with sr = 45 000 don't
> exist 
>
> Goga
>   
Well there is at least one ;-), you can look here: 
http://www.lyngsat.com/intel903.html, *transponder which says 11495 H. 
And I can confirm it is not a 30000 Msps DVB-S2 as I cant tune to it and 
alot of other people have confirmed that the high rate is actually 45Msps.
And I think that this sort of high symbol rate is probably demanding for 
the hardware but also for the driver, so I'd like a confirmation by 
someone who has tested it instead of blindly believing the specs.
And as all HD channels are crammed into this transponder, I am desperate 
to find a capable card. Moreover it is encrypted, but I can do without 
CI and using a smartcard reader.
Anyways if someone can point me to some info in this direction, that 
would be great!
Bye
Manu
*
