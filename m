Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.viadmin.org ([195.145.128.101]:58638 "EHLO www.viadmin.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbZDMLko (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 07:40:44 -0400
Date: Mon, 13 Apr 2009 13:31:09 +0200
From: "H. Langos" <henrik-dvb@prak.org>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T USB dib0700 device recommendations?
Message-ID: <20090413113109.GD12581@www.viadmin.org>
References: <20090411221740.GB12581@www.viadmin.org> <49E2A0E1.4020407@retrodesignfan.eu> <d9def9db0904122354g3e6a8603mcbf69cfb96799b8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0904122354g3e6a8603mcbf69cfb96799b8d@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 13, 2009 at 08:54:09AM +0200, Markus Rechberger wrote:
> On Mon, Apr 13, 2009 at 4:18 AM, Marco Borm <linux-dvb@retrodesignfan.eu> wrote:
> > H. Langos wrote:
> >> I've been trying to minimize energy consumption [...] But before running
> >> out in the street and buying the first dib0700 device I'd like to know if
> >> there are any devices that are
> >>
> >> - especially good [...]
> >> or
> >> - especially bad [...]
> >>
> > Hi Henrik,
> >
> > one of the cards in my system is the dib0700 based "'Hauppauge Nova-T 500".
> > Compared with the "TerraTec Cinergy 1400" I would say that the receiver
> > sensitivity is worse but the main problem I have is that the card
> > consumes a loot of energy (8-13W), which is much more than the
> > Terratec(5-6W).
> 
> That's a little bit weird USB itself should provide max 5V 500mA which would be
> 2.5 Watt; if it requires more then the device has to be self powered.

I agree, it is wierd, there is a lot of hardware out there that strains the 
usb power supply way beyond the secified 500mA but that alone can't explain
the 8-13 Watt.

My guess is, that the rest of your system uses more energy because it has to
deal with a USB device instead of a PCI device. There is different hardware
involved that otherwise might not be powered at all and there's the whole USB 
protocol stack that is involved and possibly a usb hid device (the remote) that 
has to be polled x times per second. Don't let a name like "interrupt transfer
mode" fool you. USB transfers are always initiated by the host, so it has to
poll input devices a lot.

How exactly did you measure the power usage? 

Did you run the same software to test it? ("zap" uses way less energy than "vdr") 

The same channel? (Different bitrates even within the same channel can have
some effects)

I tried to minimize the effects of the software by making sure that an idle
system with the hardware installed has the same cpu load and
wakups-per-second as the system without that hardware. But it admit i didn't
measure power usage directly. Since I am only dealing with usb devices, I could 
run the usb pin 1 through an amp meter...

> Maybe you can try to use a different USB device (eg. storage) just for
> testing the
> consumption. USB is supposed to require alot power (the controller).
> You might try to unload the ehci/ohci driver too.

Yeap, thats the way to go.

And try running powertop to see if your cpu does any extra work even when
it should be idle.

> > I calculated this using measure values of the whole system captured with
> > a Conrad/Voltcraft Energy Monitor 3000.
> > Personally I am little bit shocked about that and wondering if this can
> > be true because the dib is a USB-device, but the Voltcraft is one of the
> > better measurement device.

Does it deal well with switched-mode power supplies? Those things tend to
confuse power measuring devices unless they have a good active PCF.

> > Maybe the VIA usb-hub controller on the board is the problem?!

Could be part of the problem. 

> > Would be interesting of someone has the same or other experiences with
> > this card or other PCI based cards. Hauppauge ignores all my questions,
> > so I can't recomment products of this manufacturer anyway.

Good to know. Thank you!

cheers
-henrik

