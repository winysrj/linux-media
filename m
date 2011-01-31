Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52471 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1AaSCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 13:02:00 -0500
Received: by fxm20 with SMTP id 20so5876677fxm.19
        for <linux-media@vger.kernel.org>; Mon, 31 Jan 2011 10:01:59 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Matt Vickers <m@vicke.rs>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Mon, 31 Jan 2011 19:55:00 +0200
Cc: linux-media@vger.kernel.org
References: <4B7D83B2.4030709@online.no> <201010231220.51387.liplianin@me.by> <ii5vm9$r2g$1@dough.gmane.org>
In-Reply-To: <ii5vm9$r2g$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101311955.01003.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 31 января 2011 11:33:54 автор Matt Vickers написал:
> On 23/10/2010 10:20 p.m., Igor M. Liplianin wrote:
> > В сообщении от 10 марта 2010 14:15:49 автор Hendrik Skarpeid написал:
> >> Igor M. Liplianin skrev:
> >>> On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
> >>>> Igor M. Liplianin wrote:
> >>>>> Now to find GPIO's for LNB power control and ... watch TV :)
> >>>> 
> >>>> Yep. No succesful tuning at the moment. There might also be an issue
> >>>> with the reset signal and writing to GPIOCTR, as the module at the
> >>>> moment loads succesfully only once.
> >>>> As far as I can make out, the LNB power control is probably GPIO 16
> >>>> and 17, not sure which is which, and how they work.
> >>>> GPIO15 is wired to tuner #reset
> >>> 
> >>> New patch to test
> >> 
> >> I think the LNB voltage may be a little to high on my card, 14.5V and
> >> 20V. I would be a little more happy if they were 14 and 19, 13 and 18
> >> would be perfect.
> >> Anyways, as Igor pointet out, I don't have any signal from the LNB,
> >> checked with another tuner card. It's a quad LNB, and the other outputs
> >> are fine. Maybe it's' toasted from to high supply voltage! I little word
> >> of warning then.
> >> Anyways, here's my tweaked driver.
> > 
> > Here is reworked patch for clear GPIO's handling.
> > It allows to support I2C on GPIO's and per board LNB control through
> > GPIO's. Also incuded support for Hendrik's card.
> > I think it is clear how to change and test GPIO's for LNB and other stuff
> > now.
> > 
> > To Hendrik:
> > 	Not shure, but there is maybe GPIO for raise/down LNB voltage a little
> > 	(~1v). It is used for long coaxial lines to compensate voltage
> > 	dropping.
> > 
> > Signed-off-by: Igor M. Liplianin<liplianin@me.by>
> 
> Hi Igor,
> 
> I have a brandless DVB-S tv tuner card also, with a dm1105n chip. I was
> getting the "DM1105: could not attach frontend 195d:1105" message with
> the latest kernel also, but I applied this patch to the dm1105 module
> and now the card's being recognised  (though is still listed as an
> ethernet controller with lspci)
> 
> My dmesg output is:
> 
> dm1105 0000:01:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> DVB: registering new adapter (dm1105)
> dm1105 0000:01:05.0: MAC 00:00:00:00:00:00
> DVB: registering adapter 0 frontend 0 (SL SI21XX DVB-S)...
> Registered IR keymap rc-dm1105-nec
> input: DVB on-card IR receiver as
> /devices/pci0000:00/0000:00:1e.0/0000:01:05.0/rc/rc0/input6
> rc0: DVB on-card IR receiver as
> /devices/pci0000:00/0000:00:1e.0/0000:01:05.0/rc/rc0
> 
> The card is one of these:
> http://www.hongsun.biz/ProView.asp?ID=90
> 
> Scanning doesn't appear to give me any results.  Should this be working?
>   Anything I can do to test the card out for you?
> 
> Cheers,
> Matt.
Hi Matt,
Is there any label on tuner can?
Have you a close look picture of PCB ?

Cheers,
Igor.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
