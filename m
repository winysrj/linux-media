Return-path: <mchehab@gaivota>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:40575 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab0LPRMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 12:12:38 -0500
Message-ID: <4D0A4883.20804@arcor.de>
Date: Thu, 16 Dec 2010 18:12:35 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and IR
References: <4CAD5A78.3070803@redhat.com>	<20101008150301.2e3ceaff@glory.local>	<4CAF0602.6050002@redhat.com>	<20101012142856.2b4ee637@glory.local>	<4CB492D4.1000609@arcor.de>	<20101129174412.08f2001c@glory.local>	<4CF51C9E.6040600@arcor.de>	<20101201144704.43b58f2c@glory.local>	<4CF67AB9.6020006@arcor.de>	<20101202134128.615bbfa0@glory.local>	<4CF71CF6.7080603@redhat.com>	<20101206010934.55d07569@glory.local>	<4CFBF62D.7010301@arcor.de>	<20101206190230.2259d7ab@glory.local>	<4CFEA3D2.4050309@arcor.de>	<20101208125539.739e2ed2@glory.local>	<4CFFAD1E.7040004@arcor.de>	<20101214122325.5cdea67e@glory.local>	<4D079ADF.2000705@arcor.de>	<20101215164634.44846128@glory.local>	<4D08E43C.8080002@arcor.de> <20101216183844.6258734e@glory.local>
In-Reply-To: <20101216183844.6258734e@glory.local>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am 16.12.2010 10:38, schrieb Dmitri Belimov:
> Hi
>
>>> I think your mean is wrong. Our IR remotes send extended NEC it is
>>> 4 bytes. We removed inverted 4 byte and now we have 3 bytes from
>>> remotes. I think we must have full RCMAP with this 3 bytes from
>>> remotes. And use this remotes with some different IR recievers like
>>> some TV cards and LIRC-hardware and other. No need different RCMAP
>>> for the same remotes to different IR recievers like now.
>> Your change doesn't work with my terratec remote control !!
> I found what happens. Try my new patch.
>
> What about NEC. Original NEC send
> address (inverted address) key (inverted key)
> this is realy old standart now all remotes use extended NEC
> (adress high) (address low) key (inverted key)
> The trident 5600/6000/6010 use old protocol but didn't test inverted address byte.
>
> I think much better discover really address value and write it to keytable.
> For your remotes I add low address byte. This value is incorrent but usefull for tm6000.
> When you found correct value update keytable.
>
That is not acceptable. Have you forgotten what Mauro have written? The 
Terratec rc map are use from other devices. The best are only the 
received data without additional data. And I think the Trident chip send 
only compatibly data (send all extended data like standard data). The 
device decoded the protocols not the driver.
>>>> Then the function call usb_set_interface in tm6000_video, can write
>>>> for example:
>>>>
>>>> stop_ir_pipe
>>>> usb_set_interface
>>>> start_ir_pipe
>>> Ok, I'll try.
> See dmesg. I was add function for start/stop interrupt urbs
> All works well.
>
> With my best regards, Dmitry.

