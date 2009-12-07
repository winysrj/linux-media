Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55530 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbZLGBXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 20:23:14 -0500
Received: by bwz27 with SMTP id 27so3166658bwz.21
        for <linux-media@vger.kernel.org>; Sun, 06 Dec 2009 17:23:19 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>,
	Matthias Fechner <idefix@fechner.net>,
	linux-media@vger.kernel.org
Subject: Re: IR Receiver on an Tevii S470
Date: Mon, 7 Dec 2009 03:23:14 +0200
References: <4B0459B1.50600@fechner.net> <200911220303.36715.liplianin@me.by> <1260135654.3101.15.camel@palomino.walls.org>
In-Reply-To: <1260135654.3101.15.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912070323.14440.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 декабря 2009 23:40:54 Andy Walls wrote:
> On Sun, 2009-11-22 at 03:03 +0200, Igor M. Liplianin wrote:
> > On 21 ноября 2009 22:41:42 Andy Walls wrote:
> > > > Matthias Fechner schrieb:
> > > > > I bought some days ago a Tevii S470 DVB-S2 (PCI-E) card and got it
> > > > > running with the driver from:
> > > > > http://mercurial.intuxication.org/hg/s2-liplianin
> > > > >
> > > > > But I was not successfull in got the IR receiver working.
> > > > > It seems that it is not supported yet by the driver.
> > > > >
> > > > > Is there maybe some code available to get the IR receiver with
> > > > > evdev running?
> > >
> > > If the card is using the built in IR controller in the CX23885, then
> > > you'll have to wait until I port my CX23888 IR controller changes to
> > > work with the IR controller in the CX23885.  That should be somewhat
> > > straightforward, but will take time.  Then we'll still need you to
> > > experiment with a patch.
> >
> > It's cx23885 definitely.
> > Remote uses NEC codes.
> > In any case I can test.
>
> On Mon, 2009-11-23, Igor M. Liplianin wrote:
> > Receiver connected to cx23885 IR_RX(pin 106). It is not difficult to
> > track.
>
> Igor,
Hi Andy,

>
> As I make patches for test, perhaps you can help answer some questions
> which will save some experimentation:
>
>
> 1. Does the remote for the TeVii S470 use the same codes as
>
> linux/drivers/media/common/ir-keymaps.c : ir_codes_tevii_nec[]
That is correct table for cx88 based TeVii card with the same remote.
I believe there is no difference for cx23885.

>
> or some other remote code table we have in the kernel?
>
>
> 2. Does the remote for the TeVii S470, like other TeVii remotes, use a
> standard NEC address of 0x00 (so that Addr'Addr is 0xff00) ?  Or does it
> use another address?
Again like in cx88, the address is standard.

>
>
> 3. When you traced board wiring from the IR receiver to the IR_RX pin on
> the CX23885, did you notice any external components that might modify
> the signal?  For example, a capacitor that integrates carrier bursts
> into baseband pulses.
Yet again I believe there is no capacitors.
Very same scheme like in cx88 variants for TeVii and others.

>
>
> Thanks.
>
> Regards,
> Andy

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
