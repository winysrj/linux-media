Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52952 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab1BBSnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Feb 2011 13:43:16 -0500
Received: by eye27 with SMTP id 27so231620eye.19
        for <linux-media@vger.kernel.org>; Wed, 02 Feb 2011 10:43:15 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Matt Vickers <m@vicke.rs>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Wed, 2 Feb 2011 20:41:58 +0200
Cc: linux-media@vger.kernel.org
References: <4B7D83B2.4030709@online.no> <4D47975F.3050206@vicke.rs> <201102022039.33684.liplianin@me.by>
In-Reply-To: <201102022039.33684.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102022041.58508.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 2 февраля 2011 20:39:33 автор Igor M. Liplianin написал:
> В сообщении от 1 февраля 2011 07:17:19 автор Matt Vickers написал:
> > On 1/02/2011 6:55 a.m., Igor M. Liplianin wrote:
> > > В сообщении от 31 января 2011 11:33:54 автор Matt Vickers написал:
> > >> On 23/10/2010 10:20 p.m., Igor M. Liplianin wrote:
> > >>> В сообщении от 10 марта 2010 14:15:49 автор Hendrik Skarpeid написал:
> > >>>> Igor M. Liplianin skrev:
> > >>>>> On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
> > >>>>>> Igor M. Liplianin wrote:
> > >>>>>>> Now to find GPIO's for LNB power control and ... watch TV :)
> > >>>>>> 
> > >>>>>> Yep. No succesful tuning at the moment. There might also be an
> > >>>>>> issue with the reset signal and writing to GPIOCTR, as the module
> > >>>>>> at the moment loads succesfully only once.
> > >>>>>> As far as I can make out, the LNB power control is probably GPIO
> > >>>>>> 16 and 17, not sure which is which, and how they work.
> > >>>>>> GPIO15 is wired to tuner #reset
> > >>>>> 
> > >>>>> New patch to test
> > >>>> 
> > >>>> I think the LNB voltage may be a little to high on my card, 14.5V
> > >>>> and 20V. I would be a little more happy if they were 14 and 19, 13
> > >>>> and 18 would be perfect.
> > >>>> Anyways, as Igor pointet out, I don't have any signal from the LNB,
> > >>>> checked with another tuner card. It's a quad LNB, and the other
> > >>>> outputs are fine. Maybe it's' toasted from to high supply voltage! I
> > >>>> little word of warning then.
> > >>>> Anyways, here's my tweaked driver.
> > >>> 
> > >>> Here is reworked patch for clear GPIO's handling.
> > >>> It allows to support I2C on GPIO's and per board LNB control through
> > >>> GPIO's. Also incuded support for Hendrik's card.
> > >>> I think it is clear how to change and test GPIO's for LNB and other
> > >>> stuff now.
> > >>> 
> > >>> To Hendrik:
> > >>> 	Not shure, but there is maybe GPIO for raise/down LNB voltage a
> > >>> 	little (~1v). It is used for long coaxial lines to compensate
> > >>> 	voltage dropping.
> > >>> 
> > >>> Signed-off-by: Igor M. Liplianin<liplianin@me.by>
> > >> 
> > >> Hi Igor,
> > >> 
> > >> I have a brandless DVB-S tv tuner card also, with a dm1105n chip. I
> > >> was getting the "DM1105: could not attach frontend 195d:1105" message
> > >> with the latest kernel also, but I applied this patch to the dm1105
> > >> module and now the card's being recognised  (though is still listed
> > >> as an ethernet controller with lspci)
> > >> 
> > >> My dmesg output is:
> > >> 
> > >> dm1105 0000:01:05.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
> > >> DVB: registering new adapter (dm1105)
> > >> dm1105 0000:01:05.0: MAC 00:00:00:00:00:00
> > >> DVB: registering adapter 0 frontend 0 (SL SI21XX DVB-S)...
> > >> Registered IR keymap rc-dm1105-nec
> > >> input: DVB on-card IR receiver as
> > >> /devices/pci0000:00/0000:00:1e.0/0000:01:05.0/rc/rc0/input6
> > >> rc0: DVB on-card IR receiver as
> > >> /devices/pci0000:00/0000:00:1e.0/0000:01:05.0/rc/rc0
> > >> 
> > >> The card is one of these:
> > >> http://www.hongsun.biz/ProView.asp?ID=90
> > >> 
> > >> Scanning doesn't appear to give me any results.  Should this be
> > >> working?
> > >> 
> > >>    Anything I can do to test the card out for you?
> > >> 
> > >> Cheers,
> > >> Matt.
> > > 
> > > Hi Matt,
> > > Is there any label on tuner can?
> > > Have you a close look picture of PCB ?
> > > 
> > > Cheers,
> > > Igor.
> > 
> > Hi Igor,
> > 
> > The label on the tuner can is SP1514LHb S1009, so I'm guessing this is a
> > near-identical card to the one that Paul was asking you about in January
> > 
> > of last year, e.g:
> > >  1: DVB-S
> > >  5: 16cc
> > >  1: Unsure, but it has an LNB in and an LNB out, so I guess it does
> > >  have loop through?
> > >  4: Si2109
> > >  L: Si labs
> > >  H: Horizontal
> > >  b: Lead free
> > 
> > Here are two images I took of the card:
> > 
> > A view of the entire board:
> > 
> > http://matt.vicke.rs/pics/pcb_full.jpg
> > 
> > And here is a closer view of the board between the tuner and the dm1105n
> > chip.
> > 
> > http://matt.vicke.rs/pics/pcb_detail.jpg
> > 
> > With your patch and the card=4 parameter the card is recognised, and the
> > dvb device created. Scanning will run (I'm attempting to locate channels
> > on Optus D1, which I can successfully scan using a set top box, so the
> > dish is correctly aligned), but the card reports tuning failed on all of
> > the Optus D1 frequencies that I attempt. I also tried running w_scan but
> > had no success.
> > 
> > Cheers,
> > Matt.
> 
> Hi Matt,
> 
> Did you read this post?
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg17269.html
> It seems the card needs some soldering :(
or you can test the card using loop output from another STB/card.
 
> 
> Cheers
> Igor
> 
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-media"
> > >> in the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
