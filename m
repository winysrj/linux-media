Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:50430 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab1AaJkJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 04:40:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PjqEv-0005TS-2s
	for linux-media@vger.kernel.org; Mon, 31 Jan 2011 10:40:05 +0100
Received: from 219-89-36-29.dialup.xtra.co.nz ([219.89.36.29])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 31 Jan 2011 10:40:05 +0100
Received: from m by 219-89-36-29.dialup.xtra.co.nz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 31 Jan 2011 10:40:05 +0100
To: linux-media@vger.kernel.org
From: Matt Vickers <m@vicke.rs>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Mon, 31 Jan 2011 22:33:54 +1300
Message-ID: <ii5vm9$r2g$1@dough.gmane.org>
References: <4B7D83B2.4030709@online.no> <201003032105.06263.liplianin@me.by> <4B978D75.5080501@online.no> <201010231220.51387.liplianin@me.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <201010231220.51387.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 23/10/2010 10:20 p.m., Igor M. Liplianin wrote:
> В сообщении от 10 марта 2010 14:15:49 автор Hendrik Skarpeid написал:
>> Igor M. Liplianin skrev:
>>> On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
>>>> Igor M. Liplianin wrote:
>>>>> Now to find GPIO's for LNB power control and ... watch TV :)
>>>>
>>>> Yep. No succesful tuning at the moment. There might also be an issue
>>>> with the reset signal and writing to GPIOCTR, as the module at the
>>>> moment loads succesfully only once.
>>>> As far as I can make out, the LNB power control is probably GPIO 16 and
>>>> 17, not sure which is which, and how they work.
>>>> GPIO15 is wired to tuner #reset
>>>
>>> New patch to test
>>
>> I think the LNB voltage may be a little to high on my card, 14.5V and
>> 20V. I would be a little more happy if they were 14 and 19, 13 and 18
>> would be perfect.
>> Anyways, as Igor pointet out, I don't have any signal from the LNB,
>> checked with another tuner card. It's a quad LNB, and the other outputs
>> are fine. Maybe it's' toasted from to high supply voltage! I little word
>> of warning then.
>> Anyways, here's my tweaked driver.
>
> Here is reworked patch for clear GPIO's handling.
> It allows to support I2C on GPIO's and per board LNB control through GPIO's.
> Also incuded support for Hendrik's card.
> I think it is clear how to change and test GPIO's for LNB and other stuff now.
> To Hendrik:
> 	Not shure, but there is maybe GPIO for raise/down LNB voltage a little (~1v).
> 	It is used for long coaxial lines to compensate voltage dropping.
>
> Signed-off-by: Igor M. Liplianin<liplianin@me.by>

Hi Igor,

I have a brandless DVB-S tv tuner card also, with a dm1105n chip. I was 
getting the "DM1105: could not attach frontend 195d:1105" message with 
the latest kernel also, but I applied this patch to the dm1105 module 
and now the card's being recognised  (though is still listed as an 
ethernet controller with lspci)

My dmesg output is:

dm1105 0000:01:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
DVB: registering new adapter (dm1105)
dm1105 0000:01:05.0: MAC 00:00:00:00:00:00
DVB: registering adapter 0 frontend 0 (SL SI21XX DVB-S)...
Registered IR keymap rc-dm1105-nec
input: DVB on-card IR receiver as 
/devices/pci0000:00/0000:00:1e.0/0000:01:05.0/rc/rc0/input6
rc0: DVB on-card IR receiver as 
/devices/pci0000:00/0000:00:1e.0/0000:01:05.0/rc/rc0

The card is one of these:
http://www.hongsun.biz/ProView.asp?ID=90

Scanning doesn't appear to give me any results.  Should this be working? 
  Anything I can do to test the card out for you?

Cheers,
Matt.

