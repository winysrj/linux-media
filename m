Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33156 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0AOPVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 10:21:16 -0500
Received: by bwz27 with SMTP id 27so653493bwz.21
        for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 07:21:14 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: paul10@planar.id.au, "linux-media" <linux-media@vger.kernel.org>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Fri, 15 Jan 2010 17:21:02 +0200
References: <ea6e586942d83e4c727f335a200815a0@mail.velocitynet.com.au>
In-Reply-To: <ea6e586942d83e4c727f335a200815a0@mail.velocitynet.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001151721.02778.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 января 2010 11:15:26 paul10@planar.id.au wrote:
> I bought a DVB-S card to attach to my mythtv setup.  I knew it was perhaps
> not going to work, and I only spent $15 on it.  However, based on the info
> the guy on eBay provided, it had a pci address of 195d:1105, which I could
> see some people had cards that were working.
>
> The card itself is a no-name jobby.  I can see the DM1105 chip on it, I
> can't see any other chips with any significant pin count (lots with 3 - 8
> pins, but nothing with enough to be important).  There is a metal case
> around the connectors that might be hiding a frontend chip of some sort,
> but it doesn't seem to have enough connectors in and out to be doing much
> that is important beyond just providing connectivity to the LNB.
>
> I've got the latest kernel (2.6.33-rc4) and I've checked the code and it
> looks like the latest DM1105 code.  When booting I get:
>
> [    9.766188] dm1105 0000:06:00.0: PCI INT A -> GSI 20 (level, low) ->
> IRQ 20
> [   10.047331] dm1105 0000:06:00.0: MAC 00:00:00:00:00:00
> [   12.464628] dm1105 0000:06:00.0: could not attach frontend
> [   12.479830] dm1105 0000:06:00.0: PCI INT A disabled
>
> With lspci -vv I get:
> 06:00.0 Ethernet controller: Device 195d:1105 (rev 10)
>         Subsystem: Device 195d:1105
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin A routed to IRQ 20
>         Region 0: I/O ports at b000 [size=256]
>
> No DVB devices are created.
>
> I see from other people using a card with this chipset that there probably
> would be a tuner/frontend as well as the DM1105. I've also tried card=5 in
> the insmod parameters.
>
> It seems to me that the card probably has a tuner/frontend on id different
> from the Axess board, but I'm not sure how I'd work out what that is.  Is
> it possible that it doesn't have any chips on it other than the DM1105?
> Should I take the board apart a bit to find out?
>
> Thanks,
>
> Paul
>
Hi Paul,

Frontend/tuner must lay under cover.
Subsystem: Device 195d:1105 indicates that there is no EEPROM in card.
If you send some links/pictures/photos then it would helped a lot.
Is there a disk with drivers for Windows?
Also I know about dm1105 based cards with tda10086 demod, those are not supported in the driver 
yet.

BR
Igor
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
