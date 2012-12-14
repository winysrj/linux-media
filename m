Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2LNTse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 14:48:34 -0500
Date: Fri, 14 Dec 2012 17:39:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	David =?UTF-8?B?SMOk?= =?UTF-8?B?cmRlbWFu?= <david@hardeman.nu>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
Message-ID: <20121214173950.79bb963e@redhat.com>
In-Reply-To: <50CB46CE.60407@googlemail.com>
References: <50B5779A.9090807@pyther.net>
	<50BFECEA.9060808@iki.fi>
	<50BFFFF6.1000204@pyther.net>
	<50C11301.10205@googlemail.com>
	<50C12302.80603@pyther.net>
	<50C34628.5030407@googlemail.com>
	<50C34A50.6000207@pyther.net>
	<50C35AD1.3040000@googlemail.com>
	<50C48891.2050903@googlemail.com>
	<50C4A520.6020908@pyther.net>
	<CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com>
	<50C4BA20.8060003@googlemail.com>
	<50C4BAFB.60304@googlemail.com>
	<50C4C525.6020006@googlemail.com>
	<50C4D011.6010700@pyther.net>
	<50C60220.8050908@googlemail.com>
	<CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
	<50C60772.2010904@googlemail.com>
	<CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com>
	<50C6226C.8090302@iki! .fi>
	<50C636E7.8060003@googlemail.com>
	<50C64AB0.7020407@iki.fi>
	<50C79CD6.4060501@googlemail.com>
	<50C79E9A.3050301@iki.fi>
	<20121213182336.2cca9da6@redhat.!
 com>
	<50CB46CE.60407@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Dec 2012 16:33:34 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 13.12.2012 21:23, schrieb Mauro Carvalho Chehab:
> > Em Tue, 11 Dec 2012 22:59:06 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> On 12/11/2012 10:51 PM, Frank Schäfer wrote:
> >>> Am 10.12.2012 21:48, schrieb Antti Palosaari:
> >>>> On 12/10/2012 09:24 PM, Frank Schäfer wrote:
> >>>>> Am 10.12.2012 18:57, schrieb Antti Palosaari:
> >>>>> Specification comes here:
> >>>>> NEC send always 32 bit, 4 bytes. There is 3 different "sub" protocols:
> >>>>>
> >>>>> 1) 16bit NEC standard, 1 byte address code, 1 byte key code
> >>>>> full 4 byte code: AA BB CC DD
> >>>>> where:
> >>>>> AA = address code
> >>>>> BB = ~address code
> >>>>> CC = key code
> >>>>> DD = ~key code
> >>>>>
> >>>>> checksum:
> >>>>> AA + BB = 0xff
> >>>>> CC + DD = 0xff
> >>>>>
> >>>>> 2) 24bit NEC extended, 2 byte address code, 1 byte key code
> >>>>> full 4 byte code: AA BB CC DD
> >>>>> where:
> >>>>> AA = address code (MSB)
> >>>>> BB = address code (LSB)
> >>>>> CC = key code
> >>>>> DD = ~key code
> >>>>>
> >>>>> 3) 32bit NEC full, 4 byte key code
> >>>>> full 4 byte code: AA BB CC DD
> >>>>> where:
> >>>>> AA =
> >>>>> BB =
> >>>>> CC =
> >>>>> DD =
> >>>>>
> >>>>> I am not sure if there is separate parts for address and key code in
> >>>>> case of 32bit NEC. See some existing remote keytables if there is any
> >>>>> such table. It is very rare protocol. 1) and 2) are much more common.
> >>>>>
> >>> Many thanks.
> >>> So the problem is, that we have only a single RC_TYPE for all 3 protocol
> >>> variants and need a method to distinguish between them, right ?
> > This is not actually needed, as it is very easy to distinguish them when
> > doing the table lookups. Take a look at v4l-utils, at /utils/keytable/rc_keymaps:
> >
> > A 16-bits NEC table:
> > 	# table kworld_315u, type: NEC
> > 	0x6143 KEY_POWER
> > 	0x6101 KEY_VIDEO
> > 	...
> 
> So 0x6143 is not the same as 0x006143 and 0x00006143 ???
> 
> And even when assuming that 00 bytes are unused: 

I never seen that.

> do you really think the
> driver should parse the whole rc map and check all scancodes to find out
> which sub-protocol is used ?

Scancode search can use a b-tree (I think it currently does).

In any case, the typical usage is that the IR table will match the
IR device in usage. So, a not-found scancode just means that some
error happened during the transmission.

> > On a 24-bit NEC table: AA is always different than ~BB, otherwise, it would
> > be a 16-bit NEC.
> 
> No, if AA != ~BB it can't be 16 bit, but if AA == ~BB, it can still be
> 16, 24 or 32bit !

Have you ever seen any remote using something like that??? 

The hole point of the IR address is to distinguish a given IR device from the
others. The specs define specific addresses for VCR, TV Set, DVD, etc.

So, no, if AA == ~BB it must be a 16 or 24 bits NEC protocol, as there's just 8
bits (or 16 bits) to differentiate the IR address for a given remote 
from other NEC IR addresses.

> > On a 32-bit NEC table: CC is always different than ~DD, otherwise, it would be
> > a 24-bit NEC.
> 
> Right, if CC != ~DD it must be 32 bit.
> 
> 
> So what if we get 52 AD 76 89 from the hardware ? This can be 32, 24 or
> 16 bit !

It is 16 bits, except if someone at the manufacturer is completely
senseless, and explicitly wants to cause troubles to their customers
by using an IR address and IR commands that could be produced by
some other vendor's remotes.

In any case, the RC core will still support such crappy device, as the
IR keytable can have a mix of 16 bits/24 bits/32 bits NEC codes inside
it.

We do have some tables with multiple IR's inside. For example, the
Hauppauge RC5 table contains keycodes for 3 different types of Hauppauge
controls. The same happens to one NEC's terratec table, where we're
storing there both the codes of different IR models.

The rationale is that the same board may be sold with different remotes.

> Anyway, first we have to GET the bytes from the hardware. That's our
> current problem !
> And the hardware seems to need a different setup for reg 0x50 for the
> different NEC sub protocols.
> Which means that the we need to know the sub protocol BEFORE we get any
> bytes from the device.

No. All em28xx needs is to make sure that the NEC protocol will return
the full 32 bits scancode.

Regards,
Mauro
