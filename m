Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp7-g19.free.fr ([212.27.42.64])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.merle@free.fr>) id 1JqZKt-0004Jd-GZ
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 21:48:31 +0200
Message-ID: <48162A14.9010905@free.fr>
Date: Mon, 28 Apr 2008 21:48:36 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Thomas Reitmayr <treitmayr@devbase.at>
References: <1209330946.6897.2.camel@localhost>
In-Reply-To: <1209330946.6897.2.camel@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NSLU2 dma_free_coherent issue with DIB0700	driver
 (and probably others)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,
I put Lee in CC.

Thomas Reitmayr a =E9crit :
> Hi Lee,
> I was browsing the mailing-list archive and found your email about the
> issue with DIB0700-based devices on an NSLU2. I myself use a Terratec
> Cinergy DT XS Diversity which I think had the same issue as you
> described it. I found that the cause was the rather big DMA buffer of
> 39480 bytes as specified in dib0700_devices.c.
> Looking at the kernel's arch/arm/mach-ixp4xx/common-pci.c there is a top
> limit of 4096 bytes for a DMA buffer set by the function call =

>    dmabounce_register_dev(dev, 2048, 4096);
> =

> My recipe (for SlugOS) below changes the big buffer to a smaller one and
> also increases the number of buffers (not sure if the latter is really
> needed). Now the module is working just fine, even recording on both
> adapters gives a CPU usage of just ~25%. So the smaller buffer size does
> not seem to hurt at all. Not sure why it is needed in the first place.
> =

Well, I experienced the same issue with the Terratec Cinergy Hybrid XS.
See the problem on the em28xx ML:
http://www.spinics.net/lists/linux-usb-devel/msg09511.html
This problem can occur generally on USB devices on the ixp4xx arch.
I tried to patch the linux kernel for the dma part of ixp4xx:
http://www.spinics.net/lists/arm-kernel/msg43509.html
With this patch the driver was able to tune channels instead of the famous =
BUG message.
But I could not stream video unfortunately.
So this patch did not have any following although I expected someone to pro=
pose something better.
Your solution is to decrease the buffer size and I suspect other USB driver=
s made a similar correction.

> Bye,
> -Thomas

Cheers,
Thierry
> =

> =

> PS: My recipe "v4l-dvb_0776e4801991.bb"
> =

> =3D=3D=3D=3D=3D=3D=3D=3D=3D CUT =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =

> DESCRIPTION =3D "v4l-dvb modules"
> #SECTION =3D ""
> PRIORITY =3D "optional"
> HOMEPAGE =3D "http://linuxtv.org/"
> LICENSE =3D "GPL"
> DEPENDS =3D "virtual/kernel"
> PR =3D "r0"
> =

> SRC_URI =3D "http://linuxtv.org/hg/v4l-dvb/archive/${PV}.tar.bz2"
> =

> S =3D "${WORKDIR}/${PN}-${PV}"
> =

> inherit module
> =

> MAKE_TARGETS =3D "DIR=3D${STAGING_KERNEL_DIR}"
> =

> do_configure() {
> 	# fix make target
> 	cd "${S}"
> 	sed -i 's%^install:%install modules_install:%' Makefile
> 	=

> 	# reduce buffer size (ixp4xx can handle only <=3D 4096
> 	# (see arch/arm/mach-ixp4xx/common-pci.c)
> 	cd "${S}/linux/drivers/media/dvb/dvb-usb"
> 	sed -i 's%buffersize =3D 39480%buffersize =3D 4096%' dib0700_devices.c
> 	sed -i 's%\.count =3D 4,%.count =3D 7,%' dib0700_devices.c
> 	=

> 	# do not strip here
> 	cd "${S}/v4l/scripts"
> 	sed -i 's%@strip %@#strip %' make_makefile.pl
> }
> =

> fakeroot do_install() {
> 	oe_runmake DESTDIR=3D"${D}" install
> }
> =

> FILES_${PN} =3D "/lib/modules"
> =

> =3D=3D=3D=3D=3D=3D=3D=3D=3D CUT =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =

> =

>         ---- Original Message ----
>         From: Lee Essen lee.essen at nowonline.co.uk =

>         Date: Thu Apr 3 12:48:05 CEST 2008
>         =

>         Hi,
>         =

>         Apologies if this is directed in the wrong place, as I suspect
>         this is more of a kernel/USB issue than a DVB driver issue, but
>         it does have an impact on people wanting to use this device with
>         an NSLU2 (and I suspect it will also be a problem with many
>         other devices.)
>         =

>         I have been experimenting using a variety of DVB-T USB devices
>         with an NSLU2 with my ultimate aim being to build in a dual
>         DVB-T device into the case and use it in very much the same way
>         as the HDHomeRun device.
>         =

>         Using a DTT200U based device everything worked perfectly.
>         =

>         Then I started playing with a DIB0700 based device (actually an
>         Elgato Eye-TV Diversity) and the system would just hang whenever
>         I started using dvbstream, I got slightly different behaviour if
>         I tried to tune it to an invalid frequency and eventually
>         managed to get to a state when I could interrupt it before it
>         completely locked up.
>         =

>         It seems that the driver was flagging an issue in the ARM
>         architecture around not calling dma_free_coherent() with IRQ's
>         disabled, apparently a warning was recently added to the ARM
>         kernel so it logs a message and a stack trace each time ... this
>         seemed to be happening so frequently it effectively locked the
>         system up.
>         =

>         I did a little digging, but I'm not a kernel expert at all, and
>         it seems that the ehci_hcd module is actually where the call is
>         originating rather than the DVB driver itself, so I suspect that
>         this will actually effect a significant number of the drivers
>         when used on an ARM platform.
>         =

>         For the purposes of testing I removed the warning (from
>         arch/arm/mm/ consistent line 363) and everything is fine, the
>         driver operates perfectly and I can stream video nicely. BUT -
>         clearly there is some kind of issue here that needs to be
>         resolved.
>         =

>         More information is available at the link below, and also I have
>         read comments suggesting that the issue has been discussed on
>         the arm-kernel mailing list but that no resolution has yet been
>         found.
>         =

>         http://forum.soft32.com/linux/ehci_hcd-map_single-unable-map-unsa=
fe-buffer-standard-NSLU2-ftopict461241.html
>         =

>         For reference I'm using 2.6.24 and have tried the most recent
>         drivers from linuxtv.org as well as a variety of others -- all
>         seem to have the same problem (which is expected if the problem
>         is actually in the USB system.)
>         =

>         Hope this is useful,
>         =

>         Lee.
> =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> =



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
