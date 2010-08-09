Return-path: <mchehab@pedra>
Received: from keetweej.vanheusden.com ([83.163.219.98]:48288 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab0HIO4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 10:56:30 -0400
Date: Mon, 9 Aug 2010 16:56:21 +0200
From: folkert <folkert@vanheusden.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle Systems, Inc. PCTV 330e & 2.6.34 &
	/dev/dvb
Message-ID: <20100809145621.GB6126@belle.intranet.vanheusden.com>
References: <20100809133252.GW6126@belle.intranet.vanheusden.com> <AANLkTimtHwW_PQ1vNQVaMKXXYdyVroZzwAfomu+Yw02C@mail.gmail.com> <20100809143550.GZ6126@belle.intranet.vanheusden.com> <AANLkTinJbdrHQPk9mudEAPtB7L_S11hS_ArX+DDsnBD6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinJbdrHQPk9mudEAPtB7L_S11hS_ArX+DDsnBD6@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> >> > I have a:
> >> > Bus 001 Device 006: ID 2304:0226 Pinnacle Systems, Inc. PCTV 330e
> >> > inserted in a system with kernel 2.6.34.
> >>
> >> The PCTV 330e support for digital hasn't been merged upstream yet.
> >> See here:
> >> http://www.kernellabs.com/blog/?cat=35
> >
> > Does that mean teletext won't work either?
> 
> Teletext support is completely different that digital (DVB) support.
> VBI support (including teletext) was added to the in-kernel em28xx
> driver back in January.

Ah and I see in the code that you are the maintainer :-)

Something seems to be odd with the vbi support:
mauer:~# alevt -vbi /dev/vbi0
DMX_SET_FILTER: Invalid argument
alevt: v4l2: broken vbi format specification
alevt: cannot open device: /dev/vbi0

open("/dev/vbi0", O_RDWR)               = 3
ioctl(3, 0x403c6f2b, 0x7fff2617e5d0)    = -1 EINVAL (Invalid argument)
dup(2)                                  = 4
fcntl(4, F_GETFL)                       = 0x8002 (flags O_RDWR|O_LARGEFILE)
fstat(4, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 8), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f26789a2000
lseek(4, 0, SEEK_CUR)                   = -1 ESPIPE (Illegal seek)
write(4, "DMX_SET_FILTER: Invalid argument\n", 33DMX_SET_FILTER: Invalid argument
) = 33
close(4)                                = 0
munmap(0x7f26789a2000, 4096)            = 0
close(3)                                = 0
open("/dev/vbi0", O_RDONLY)             = 3
ioctl(3, VIDIOC_G_FMT or VT_SENDSIG, 0x7fff26180000) = 0
write(2, "alevt: ", 7alevt: )                  = 7
write(2, "v4l2: broken vbi format specification", 37v4l2: broken vbi format specification) = 37
write(2, "\n", 1
)                       = 1
close(3)                                = 0

[1019162.700435] tvp5150 1-005c: tvp5150am1 detected.
[1019163.340012] xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[1019164.280579] MTS (4), id 00000000000000ff:
[1019164.280652] xc2028 1-0061: Loading firmware for type=MTS (4), id 0000000100000007.


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
