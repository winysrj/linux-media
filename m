Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38534 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbaLAMwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 07:52:39 -0500
Date: Mon, 1 Dec 2014 10:52:35 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "=?UTF-8?B?SXN0dsOhbiw=?= Varga" <istvan_v@mailbox.hu>
Cc: linux-media@vger.kernel.org
Subject: Re: Kernel 3.17.0 broke xc4000-based DTV1800h
Message-ID: <20141201105235.5cacf881@recife.lan>
In-Reply-To: <CA+QJwyh-3YL1UCR7Q1d3jy8z49YM2yqNp_WmiD3zXLRzEuC-Uw@mail.gmail.com>
References: <CA+QJwyh2OupTtNJ89TWgyBZm0dhaHQ2Ax1XPDPjaFat-aTKsCA@mail.gmail.com>
	<20141201072028.6466a2b3@recife.lan>
	<CA+QJwyh-3YL1UCR7Q1d3jy8z49YM2yqNp_WmiD3zXLRzEuC-Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 01 Dec 2014 13:24:50 +0100
"István, Varga" <istvan_v@mailbox.hu> escreveu:

> 2014-12-01 10:20 GMT+01:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> 
> > Hi István,
> >
> > Yeah, Xceive granted a license to redistribute such firmware file via
> > Hauppauge. The firmware we sent to linux-firmware is this one with
> > the proper license.
> 
> Hi, does the license apply specifically to the kernellabs.com firmware file,
> or the header files released by Xceive (xc4000_firmwares.h, xc4000_scodes.h) ?

My understanding is that it covers that specific firmware file.

> In the latter case, it should cover my firmware file
> (dvb-fe-xc4000-1.4.fw) as well,
> because it is generated from the same headers. Also, it is no longer generated
> from the Leadtek Windows drivers (like it was in the past before I had access to
> the Xceive header files), so it should in theory only be licensed by
> Xceive, rather
> than Leadtek.

True, just Xceive's SOB would be enough, but in general, it is easier
to get chipset manufacturer's license via the hardware manufacturer
(Leadtek, in this case).

So, we need either someone at Xceive to SOB the patch or someone at Leadtek
that has internally some authorization to release the firmware files in their
behalf.

> 
> > Hmm... I remember I did some tests with PCTV 340e using that firmware
> > and it works for me.
> 
> >From a quick look at the contents of dvb-fe-xc4000-1.4.1.fw (the kernellabs.com
> file), it appears to be missing all the firmware data related to
> analog TV and radio
> standards, and all scodes are (incorrectly) a copy of the one needed for
> int_freq = 5400.

Maybe the scodes are patched for some specific interworking scenario with
dib0700.

> Therefore, it only works with the demodulator used on the PCTV
> 340e, which is using that frequency, but not with the Leadtek cards
> with zl10153,
> since those require 4560 instead. It also seems to be missing some standard and
> firmware type flags. 

I see.

> I am not sure if those are responsible for the
> I2C errors, or
> simply the lack of the analog firmwares. Perhaps the latter if the errors do not
> occur with the (currently DVB-only) PCTV 340e.

Maybe.

> > Such change shouldn't affect devices with zl10153, as this demod doesn't
> > call tuner's get_frequency().
> 
> The get_frequency() change is not an issue,

It used to be for PCTV 340e before the fixup patch, after some changes that
happened at dib0700 driver.

> the kernellabs.com firmware that is
> now the default and part of the kernel packages does not include data that is
> required for the Leadtek cards to work.

I see.
> 
> > However, if the firmware doesn't work properly with PCTV 340e and/or
> > Leadtek/Xceive cannot grant a license to redistribute the other version
> > of the firmware, the best would be to rename the firmware file used
> > by Leadtek devices to dvb-fe-xc4000-leadtek-1.4.fw, in order to avoid
> > confusion.
> 
> Although I did not test it, the firmware should work with the PCTV 340e as
> well. It definitely does with the Leadtek devices in DVB-T mode, and on the
> PCTV 340e the only difference is the IF (5400 vs. 4560).
