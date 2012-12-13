Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab2LMUYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 15:24:14 -0500
Date: Thu, 13 Dec 2012 18:23:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
Message-ID: <20121213182336.2cca9da6@redhat.com>
In-Reply-To: <50C79E9A.3050301@iki.fi>
References: <50B5779A.9090807@pyther.net>
	<50BFBE39.90901@pyther.net>
	<50BFC445.6020305@iki.fi>
	<50BFCBBB.5090407@pyther.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Dec 2012 22:59:06 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 12/11/2012 10:51 PM, Frank Schäfer wrote:
> > Am 10.12.2012 21:48, schrieb Antti Palosaari:
> >> On 12/10/2012 09:24 PM, Frank Schäfer wrote:
> >>> Am 10.12.2012 18:57, schrieb Antti Palosaari:
> >>>> On 12/10/2012 06:13 PM, Devin Heitmueller wrote:
> >>>>> On Mon, Dec 10, 2012 at 11:01 AM, Frank Schäfer
> >>>>>> Adding a new property to the RC profile certainly seems to be the
> >>>>>> cleanest solution.
> >>>>>> Do all protocols have paritiy checking ? Otherwise we could add a new
> >>>>>> type RC_TYPE_NEC_NO_PARITY.
> >>>>>> OTOH, introducing a new bitfield in struct rc_map might be usefull
> >>>>>> for
> >>>>>> other flags, too, in the future...
> >>>>>
> >>>>> It's probably also worth mentioning that in that mode the device
> >>>>> reports four bytes, not two.  I guess perhaps if parity is ignored it
> >>>>> reports the data in some other format?  You will probably have to do
> >>>>> some experimentation there.
> >
> > ...
> >
> >>>>
> >>>> Uh, current em28xx NEC implementation is locked to traditional 16 bit
> >>>> NEC, where is hw checksum used.
> >>>>
> >>>> Implementation should be changed to more general to support 24 and 32
> >>>> bit NEC too. There is multiple drivers doing already that, for example
> >>>> AF9015.
> >>>>
> >>>
> >>> Hmm... are there and documents (, links, books, ...) where I can learn
> >>> more about all those RC protocols ?
> >>
> >> Specification comes here:
> >> NEC send always 32 bit, 4 bytes. There is 3 different "sub" protocols:
> >>
> >> 1) 16bit NEC standard, 1 byte address code, 1 byte key code
> >> full 4 byte code: AA BB CC DD
> >> where:
> >> AA = address code
> >> BB = ~address code
> >> CC = key code
> >> DD = ~key code
> >>
> >> checksum:
> >> AA + BB = 0xff
> >> CC + DD = 0xff
> >>
> >> 2) 24bit NEC extended, 2 byte address code, 1 byte key code
> >> full 4 byte code: AA BB CC DD
> >> where:
> >> AA = address code (MSB)
> >> BB = address code (LSB)
> >> CC = key code
> >> DD = ~key code
> >>
> >> 3) 32bit NEC full, 4 byte key code
> >> full 4 byte code: AA BB CC DD
> >> where:
> >> AA =
> >> BB =
> >> CC =
> >> DD =
> >>
> >> I am not sure if there is separate parts for address and key code in
> >> case of 32bit NEC. See some existing remote keytables if there is any
> >> such table. It is very rare protocol. 1) and 2) are much more common.
> >>
> >
> > Many thanks.
> > So the problem is, that we have only a single RC_TYPE for all 3 protocol
> > variants and need a method to distinguish between them, right ?

This is not actually needed, as it is very easy to distinguish them when
doing the table lookups. Take a look at v4l-utils, at /utils/keytable/rc_keymaps:

A 16-bits NEC table:
	# table kworld_315u, type: NEC
	0x6143 KEY_POWER
	0x6101 KEY_VIDEO
	...

A 24-bits NEC table:
	# table pixelview_002t, type: NEC
	0x866b13 KEY_MUTE
	0x866b12 KEY_POWER2
	...

A 32-bits NEC table:
	# table tivo, type: NEC
	0xa10c900f KEY_MEDIA
	0xa10c0807 KEY_POWER2
	...

If you see there, there's no way for the Kernel to handle it wrong, as
there's an implicit rule when dealing with "extended NEC" protocols:

Being the IR code being given by: AA BB CC DD

On a 24-bit NEC table: AA is always different than ~BB, otherwise, it would
be a 16-bit NEC.

On a 32-bit NEC table: CC is always different than ~DD, otherwise, it would be
a 24-bit NEC.

> Yes, that is. I have said it "million" times I would like to see that 
> implemented as a one single 4 byte NEC, but it is currently what it is. 

The hard thing is that, if this is changed upstream, existing
tools/keytables will break. So, regressions will be introduced.

> What I understand David Härdeman has done some work toward that too, but 
> it is not ready.

One alternative would be to add some compatibility code at the table
read function that would convert a 16 bits or 24 bits NEC keycode table
into a 32 bits one, but doing it right can be a problem.

> See current af9015 driver as example how driver makes decision which 
> variant of NEC is used. You will need something similar. Read all 4 NEC 
> bytes from the hardware and then use driver to make decision which 
> variant it is. I am quite sure em28xx hardware supports reading all 4 
> bytes, but if not, you will need to do some other tricks.
> 
> regards
> Antti
> 

Regards,
Mauro
