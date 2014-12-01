Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38512 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaLAJUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 04:20:34 -0500
Date: Mon, 1 Dec 2014 07:20:28 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "=?UTF-8?B?SXN0dsOhbiw=?= Varga" <istvan_v@mailbox.hu>
Cc: linux-media@vger.kernel.org,
	Rodney Baker <rodney@jeremiah31-10.net>
Subject: Re: Kernel 3.17.0 broke xc4000-based DTV1800h
Message-ID: <20141201072028.6466a2b3@recife.lan>
In-Reply-To: <CA+QJwyh2OupTtNJ89TWgyBZm0dhaHQ2Ax1XPDPjaFat-aTKsCA@mail.gmail.com>
References: <CA+QJwyh2OupTtNJ89TWgyBZm0dhaHQ2Ax1XPDPjaFat-aTKsCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi István,

Em Sun, 30 Nov 2014 18:38:24 +0100
"István, Varga" <istvan_v@mailbox.hu> escreveu:

> > On 16 Oct 2014, at 17:33, Rodney Baker <rodney.baker <at> iinet.net.au> wrote:
> >
> > Since installing kernel 3.17.0-1.gc467423-desktop (on openSuSE 13.1) my
> > xc4000/zl10353/cx88 based DTV card has failed to initialise on boot.
> 
> Apparently, the default firmware file name has been changed to
> dvb-fe-xc4000-1.4.1.fw,

Actually, changeset da7bfa2c5df3 added support for both names. It tries
first dvb-fe-xc4000-1.4.1.fw. If not found, it falls back to 
dvb-fe-xc4000-1.4.fw.

> and the firmware package for the kernel now includes this file from
> kernellabs.com.

Yeah, Xceive granted a license to redistribute such firmware file via
Hauppauge. The firmware we sent to linux-firmware is this one with
the proper license.

> However, this firmware file is incomplete (only includes minimal DVB-T
> support for the
> PCTV 340e), and also incompatible with the driver. That is why trying
> to load it results
> in i2c errors.

Hmm... I remember I did some tests with PCTV 340e using that firmware
and it works for me.

There were a bug at xc4000 that were causing PCTV 340e to not work,
that got fixed on changeset 4c07e32884ab6957. Basically, get_frequency()
were returning the wrong frequency, with caused dib7000p to adjust IF
to a wrong value. With that change, at least for pctv 340e, xc4000 driver
is working fine.

Such change shouldn't affect devices with zl10153, as this demod doesn't
call tuner's get_frequency().

> 
> To get a firmware file that actually works, download this package, and build it:
>   http://juropnet.hu/~istvan_v/xc4000_firmware.tar.gz
> Actually, it was posted to the linux-media list in the past, but the
> file did not end up being
> included with the kernel firmware packages for some reason.

For a firmware to be added at the Kernel firmware, the manufacturer
has to grant a license to redistribute the binaries. I was not aware
that there are actually two different versions of the xc4000 firmware
with the same name. This is a really bad idea.

What we should do is to name those versions differently, and pass the
firmware name as a parameter to the xc4000 attach function.

On a quick look, it seems that those are the devices that use the
xc4000 tuner:

cx23885:
	Leadtek Winfast PxDVR3200 H XC4000
cx88:
	Leadtek WinFast DTV1800 H (XC4000)
	Leadtek WinFast DTV2000 H PLUS

dib0700:
	PCTV 340e

Do you know if the firmware that works with Leadtek devices also work
without any regressions with PCTV 340e? If so, then if Leadtek could
get a license from Xceive to redistribute the firmwares at the Kernel,
we could update the firmware file at the linux-firmware tree.

However, if the firmware doesn't work properly with PCTV 340e and/or
Leadtek/Xceive cannot grant a license to redistribute the other version
of the firmware, the best would be to rename the firmware file used
by Leadtek devices to dvb-fe-xc4000-leadtek-1.4.fw, in order to avoid
confusion.

I won't doubt that the version that works with dib0700 would be different
than the ones that work with other devices, as the IF used on dib0700
could be different (I think most dib0700 devices use a zero-IF tuner).

> The include path to
> tuner-xc2028-types.h needs to be changed in build_fw.c, since the
> "tuners" subdirectory is
> now in "drivers/media", rather than "drivers/media/common". After
> that, running make will
> produce a correct firmware file named dvb-fe-xc4000-1.4.fw.
> 
> Some distributions include older firmware files from this page:
>   http://istvanv.users.sourceforge.net/v4l/xc4000.html
> These are slightly different from the newer one, and are extracted
> from the Windows
> drivers, rather than from the xc4000_firmwares.h file provided by
> Xceive, but should still
> work nevertheless.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
