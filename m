Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42784 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZKVBER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 20:04:17 -0500
Received: by bwz27 with SMTP id 27so4243702bwz.21
        for <linux-media@vger.kernel.org>; Sat, 21 Nov 2009 17:04:21 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: IR Receiver on an Tevii S470
Date: Sun, 22 Nov 2009 03:03:36 +0200
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org
References: <4B0459B1.50600@fechner.net> <4B081F0B.1060204@fechner.net> <1258836102.1794.7.camel@localhost>
In-Reply-To: <1258836102.1794.7.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911220303.36715.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 ноября 2009 22:41:42 Andy Walls wrote:
> On Sat, 2009-11-21 at 18:10 +0100, Matthias Fechner wrote:
> > Hi,
> >
> > Matthias Fechner schrieb:
> > > I bought some days ago a Tevii S470 DVB-S2 (PCI-E) card and got it
> > > running with the driver from:
> > > http://mercurial.intuxication.org/hg/s2-liplianin
> > >
> > > But I was not successfull in got the IR receiver working.
> > > It seems that it is not supported yet by the driver.
> > >
> > > Is there maybe some code available to get the IR receiver with evdev
> > > running?
>
> What bridge chip does the TeVii S470 use: a CX23885, CX23887, or
> CX23888?
>
> Does the TeVii S470 have a separate microcontroller chip for IR
> somewhere on the board, or does it not have one?  (If you can't tell,
> just provide a list of the chip markings on the board.)
>
>
> If the card is using the built in IR controller of the CX23888 than that
> should be pretty easy to get working, we'll just need you to do some
> experimentation with a patch.
>
> If the card is using the built in IR controller in the CX23885, then
> you'll have to wait until I port my CX23888 IR controller changes to
> work with the IR controller in the CX23885.  That should be somewhat
> straightforward, but will take time.  Then we'll still need you to
> experiment with a patch.
>
> If the card is using a separate IR microcontroller, I'm not sure where
> to begin.... :P
>
> Regards,
> Andy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
It's cx23885 definitely.
Remote uses NEC codes.
In any case I can test.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
