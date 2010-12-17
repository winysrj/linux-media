Return-path: <mchehab@gaivota>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:37281 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0LQAqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 19:46:37 -0500
Received: by ewy10 with SMTP id 10so67163ewy.4
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 16:46:36 -0800 (PST)
Date: Fri, 17 Dec 2010 10:46:33 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and IR
Message-ID: <20101217104633.7c9d10d7@glory.local>
In-Reply-To: <4D0A4883.20804@arcor.de>
References: <4CAD5A78.3070803@redhat.com>
	<20101008150301.2e3ceaff@glory.local>
	<4CAF0602.6050002@redhat.com>
	<20101012142856.2b4ee637@glory.local>
	<4CB492D4.1000609@arcor.de>
	<20101129174412.08f2001c@glory.local>
	<4CF51C9E.6040600@arcor.de>
	<20101201144704.43b58f2c@glory.local>
	<4CF67AB9.6020006@arcor.de>
	<20101202134128.615bbfa0@glory.local>
	<4CF71CF6.7080603@redhat.com>
	<20101206010934.55d07569@glory.local>
	<4CFBF62D.7010301@arcor.de>
	<20101206190230.2259d7ab@glory.local>
	<4CFEA3D2.4050309@arcor.de>
	<20101208125539.739e2ed2@glory.local>
	<4CFFAD1E.7040004@arcor.de>
	<20101214122325.5cdea67e@glory.local>
	<4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
	<20101216183844.6258734e@glory.local>
	<4D0A4883.20804@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Stefan

> Am 16.12.2010 10:38, schrieb Dmitri Belimov:
> > Hi
> >
> >>> I think your mean is wrong. Our IR remotes send extended NEC it is
> >>> 4 bytes. We removed inverted 4 byte and now we have 3 bytes from
> >>> remotes. I think we must have full RCMAP with this 3 bytes from
> >>> remotes. And use this remotes with some different IR recievers
> >>> like some TV cards and LIRC-hardware and other. No need different
> >>> RCMAP for the same remotes to different IR recievers like now.
> >> Your change doesn't work with my terratec remote control !!
> > I found what happens. Try my new patch.
> >
> > What about NEC. Original NEC send
> > address (inverted address) key (inverted key)
> > this is realy old standart now all remotes use extended NEC
> > (adress high) (address low) key (inverted key)
> > The trident 5600/6000/6010 use old protocol but didn't test
> > inverted address byte.
> >
> > I think much better discover really address value and write it to
> > keytable. For your remotes I add low address byte. This value is
> > incorrent but usefull for tm6000. When you found correct value
> > update keytable.
> >
> That is not acceptable. Have you forgotten what Mauro have written?
> The Terratec rc map are use from other devices.

NO
The RC_MAP_NEC_TERRATEC_CINERGY_XS used only in tm6000 module.
My patch didn't kill support any other devices.

> The best are only the 
> received data without additional data. And I think the Trident chip
> send only compatibly data (send all extended data like standard
> data). The device decoded the protocols not the driver.

You can't use this remotes with normal working IR receivers because this receivers
returned FULL scancodes. Need add one more keytable.

1. With my variant we have one keytable of remote and some workaround in device drivers. 
    And can switch keytable and remotes on the fly (of course when keytable has really value and device driver has workaround)
    
2. With your variant we have some keytables for one remote for different IR recevers. 
    Can't use incompatible keytable with other IR recievers. It is black magic for understanding what remotes is working with this hardware.

I think my variant much better.

With my best regards, Dmitry.

> >>>> Then the function call usb_set_interface in tm6000_video, can
> >>>> write for example:
> >>>>
> >>>> stop_ir_pipe
> >>>> usb_set_interface
> >>>> start_ir_pipe
> >>> Ok, I'll try.
> > See dmesg. I was add function for start/stop interrupt urbs
> > All works well.
> >
> > With my best regards, Dmitry.
> 
