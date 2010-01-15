Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.velocitynet.com.au ([203.17.154.21]:47290 "EHLO
	webmail2.velocitynet.com.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755410Ab0AOXOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 18:14:50 -0500
MIME-Version: 1.0
Date: Fri, 15 Jan 2010 23:14:49 +0000
From: <paul10@planar.id.au>
To: "linux-media" <linux-media@vger.kernel.org>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: DM1105: could not attach frontend 195d:1105
Message-ID: <ce9ceb6396947b48531256e715f00390@mail.velocitynet.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 января 2010 11:15:26 paul10@planar.id.au wrote:
> I bought a DVB-S card to attach to my mythtv setup.  I knew it was
perhaps
> not going to work, and I only spent $15 on it.  However, based on the
info
> the guy on eBay provided, it had a pci address of 195d:1105, which I
could
> see some people had cards that were working.

> The card itself is a no-name jobby.  I can see the DM1105 chip on it, I
> can't see any other chips with any significant pin count (lots with 3 -
8
> pins, but nothing with enough to be important).  There is a metal case
> around the connectors that might be hiding a frontend chip of some sort,
> but it doesn't seem to have enough connectors in and out to be doing
much
> that is important beyond just providing connectivity to the LNB.
>

Igor wrote:
> Hi Paul,

> Frontend/tuner must lay under cover.
> Subsystem: Device 195d:1105 indicates that there is no EEPROM in card.
> If you send some links/pictures/photos then it would helped a lot.
> Is there a disk with drivers for Windows?
> Also I know about dm1105 based cards with tda10086 demod, those are not
supported in the driver 
yet.

> BR
> Igor

Igor,

Photos:
1.  Front of card.  You can see the DM1105 in the foreground.  There are
no other significant looking chips on the card.
http://planar.id.au/Photos/img_1964.jpg

2.  Back of card - as you can see, there aren't a lot of places where a
lot of pins are connecting - mainly the DM1105 itself
http://planar.id.au/Photos/img_1965.jpg

3.  With the top metal plate removed, and with the other end of the card
in better focus.
http://planar.id.au/Photos/img_1966.jpg

Is it likely that there is a tuner under the card labelled "ERIT"?  To
take it off I have to unsolder some stuff - I can do that, but I reckon
it's only 50% chance the card will work again when I put it back together -
my soldering isn't so good.

Thanks heaps for the assistance.

Paul

