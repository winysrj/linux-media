Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-yx0-f171.google.com ([209.85.210.171])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mhaugstrup@gmail.com>) id 1MrhFi-0001Zg-UI
	for linux-dvb@linuxtv.org; Sun, 27 Sep 2009 02:04:36 +0200
Received: by yxe1 with SMTP id 1so4295020yxe.3
	for <linux-dvb@linuxtv.org>; Sat, 26 Sep 2009 17:04:00 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 27 Sep 2009 02:04:00 +0200
Message-ID: <9597d9450909261704g64fadcd1vab84fb5be1d11308@mail.gmail.com>
From: Mikkel Haugstrup <mhaugstrup@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] AF9035 + FC0011 Tuner
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi

Purchased a cheap DVB-T usb stick because i was under the impression
it would work under linux, but sadly the hardware revision has been
bumped. The card is labeled Greentek DTVR-1, and thru disassembly i
can visually identify the demod as a Afatech AF9035 and the tuner to
be a Fiti-power FC0011.

Im running a Ubuntu 9.04 amd64 with latest kernel (2.6.28-15)

Initially i've tried to compile a custom kernel using the patches
supplied to/by Terratec. In short I followed the Method B described
here: http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_Stick.

After a reboot I've the following when doing a dmesg:
mhj@mhj-laptop:~/Desktop$ dmesg | grep 9035
[   15.944874] af9035: tuner ID:40 not supported, please report!
[   15.944902] usbcore: registered new interface driver dvb_usb_af9035

As nothing turns up under /dev/dvb I guess I still lack support for
the FC0011 tuner, so I went on and examined the rar file from method C
which seems to contain some source code for the FC0011 tuner. The
AF903x_SRC.tar.gz seems only to include precompiled versions but the
src rpm also seems to contain source code.

mhj@mhj-laptop:~/Desktop/Linux_PC_AF9035_Afatech_2008.12.17/Linux-64bit_AF9035_20081217$
ls AF903x_SRC/*Fiti* -1
AF903x_SRC/Fitipower_FC0011.h
AF903x_SRC/Fitipower_FC0011.o
AF903x_SRC/Fitipower_FC0011_Script.h

mhj@mhj-laptop:~/Desktop/Linux_PC_AF9035_Afatech_2008.12.17/Linux-64bit_AF9035_20081217$
ls AF903x-64bit-2.0-1.src/AF903x_SRC/*Fiti* -1
AF903x-64bit-2.0-1.src/AF903x_SRC/Fitipower_FC0011.c
AF903x-64bit-2.0-1.src/AF903x_SRC/Fitipower_FC0011.h
AF903x-64bit-2.0-1.src/AF903x_SRC/Fitipower_FC0011.o
AF903x-64bit-2.0-1.src/AF903x_SRC/Fitipower_FC0011_Script.h


mhj@mhj-laptop:~/Desktop/Linux_PC_AF9035_Afatech_2008.12.17/Linux-64bit_AF9035_20081217$
cat ReadMe.txt | grep FC0011
	2.Tuner support: NXP18291, MT2266, TUA9001 and FC0011 are supported.

I have yet to make it compile succesfully on Ubuntu 9.04, was hoping
to get some pointers on how to do it, the wiki mentions that kernels
from 2.6.17-27 is supported, so my questions are.
Have anyone successfully used the AF9035+FC0011 combo under Ubuntu
9.04? Any other linux? Did you use the above code?

If all no, could anybody give pointers on how to go ahead and try to
make it work?

Kind regards
Mikkel

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
