Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54345 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361Ab0APAK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 19:10:27 -0500
Received: by bwz27 with SMTP id 27so1031837bwz.21
        for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 16:10:25 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: paul10@planar.id.au, "linux-media" <linux-media@vger.kernel.org>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Sat, 16 Jan 2010 02:10:11 +0200
References: <ce9ceb6396947b48531256e715f00390@mail.velocitynet.com.au>
In-Reply-To: <ce9ceb6396947b48531256e715f00390@mail.velocitynet.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001160210.12048.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 января 2010 01:14:49 paul10@planar.id.au wrote:
> On 15 января 2010 11:15:26 paul10@planar.id.au wrote:
> > I bought a DVB-S card to attach to my mythtv setup.  I knew it was
>
> perhaps
>
> > not going to work, and I only spent $15 on it.  However, based on the
>
> info
>
> > the guy on eBay provided, it had a pci address of 195d:1105, which I
>
> could
>
> > see some people had cards that were working.
> >
> > The card itself is a no-name jobby.  I can see the DM1105 chip on it, I
> > can't see any other chips with any significant pin count (lots with 3 -
>
> 8
>
> > pins, but nothing with enough to be important).  There is a metal case
> > around the connectors that might be hiding a frontend chip of some sort,
> > but it doesn't seem to have enough connectors in and out to be doing
>
> much
>
> > that is important beyond just providing connectivity to the LNB.
>
> Igor wrote:
> > Hi Paul,
> >
> > Frontend/tuner must lay under cover.
> > Subsystem: Device 195d:1105 indicates that there is no EEPROM in card.
> > If you send some links/pictures/photos then it would helped a lot.
> > Is there a disk with drivers for Windows?
> > Also I know about dm1105 based cards with tda10086 demod, those are not
>
> supported in the driver
> yet.
>
> > BR
> > Igor
>
> Igor,
>
> Photos:
> 1.  Front of card.  You can see the DM1105 in the foreground.  There are
> no other significant looking chips on the card.
> http://planar.id.au/Photos/img_1964.jpg
>
> 2.  Back of card - as you can see, there aren't a lot of places where a
> lot of pins are connecting - mainly the DM1105 itself
> http://planar.id.au/Photos/img_1965.jpg
>
> 3.  With the top metal plate removed, and with the other end of the card
> in better focus.
> http://planar.id.au/Photos/img_1966.jpg
>
> Is it likely that there is a tuner under the card labelled "ERIT"?  To
> take it off I have to unsolder some stuff - I can do that, but I reckon
> it's only 50% chance the card will work again when I put it back together -
> my soldering isn't so good.
>
> Thanks heaps for the assistance.
>
> Paul

Example of decipher :)

SP2636SVb

Company Name
Model Number
Size Input Option
Demodulator Chip
Chip Solution
Chassis Type
Remark

Serit
Platform

1: DVB-S
2: DVB-S2

0 : 10cc
4 : 14cc
5 : 16cc
6 : 16cc

0 : Without Loop Thru
1 :
2 :
3 : Loop Thru
 
0 : Half NIM
1 : WJCE6313
2 : STV0288
3 : CX24116
4 : Si2109
5 : CX24123
6 : STV0903

C : Conaxent
L : Silabs
M : Montage
N : Half NIM
S : ST Micro.
Z : Intel

V : Vertical
H : Horizontal

b : Pb Fre
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
