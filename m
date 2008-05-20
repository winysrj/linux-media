Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outgoing.selfhost.de ([82.98.87.70] helo=mordac.selfhost.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bumkunjo@gmx.de>) id 1JyUQ3-00009D-Lj
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 18:10:34 +0200
From: jochen s <bumkunjo@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 20 May 2008 18:10:26 +0200
References: <20080514221252.48BF0478088@ws1-5.us4.outblaze.com>
In-Reply-To: <20080514221252.48BF0478088@ws1-5.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805201810.26848.bumkunjo@gmx.de>
Cc: stev391@email.com
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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


May 20 17:48:11   kernel: [   48.744161] ACPI: PCI Interrupt 0000:02:00.0
[A] -> GSI 16 (level, low) -> IRQ 16
May 20 17:48:11   kernel: [   48.744179] CORE cx23885[0]: subsystem: 
18ac:db78, board: DViCO FusionHDTV DVB-T Dual Express [card=10,autodetected]
May 20 17:48:11   kernel: [   48.844132] cx23885[0]: i2c bus 0 registered
May 20 17:48:11   kernel: [   48.844154] cx23885[0]: i2c bus 1 registered
May 20 17:48:11   kernel: [   48.844168] cx23885[0]: i2c bus 2 registered
May 20 17:48:11   kernel: [   48.908665] input: i2c IR (FusionHDTV) 
as /class/input/input3
May 20 17:48:11   kernel: [   48.908687] ir-kbd-i2c: i2c IR (FusionHDTV) 
detected at i2c-2/2-006b/ir0 [cx23885[0]]
May 20 17:48:11   kernel: [   48.909711] cx23885[0]: cx23885 based dvb card
May 20 17:48:11   kernel: [   48.970326] xc2028 2-0061: type set to XCeive 
xc2028/xc3028 tuner
May 20 17:48:11   kernel: [   48.970336] DVB: registering new adapter (cx23885
[0])
May 20 17:48:11   kernel: [   48.970340] DVB: registering frontend 1 (Zarlink 
ZL10353 DVB-T)...
May 20 17:48:11   kernel: [   48.970625] cx23885[0]: cx23885 based dvb card
May 20 17:48:11   kernel: [   48.976144] xc2028 3-0061: type set to XCeive 
xc2028/xc3028 tuner
May 20 17:48:11   kernel: [   48.976147] DVB: registering new adapter (cx23885
[0])
May 20 17:48:11   kernel: [   48.976151] DVB: registering frontend 2 (Zarlink 
ZL10353 DVB-T)...
May 20 17:48:11   kernel: [   48.976368] cx23885_dev_checkrevision() Hardware 
revision = 0xb0
May 20 17:48:11   kernel: [   48.976376] cx23885[0]/0: found at 0000:02:00.0, 
rev: 2, irq: 16, latency: 0, mmio: 0xfd600000
May 20 17:48:11   kernel: [   48.976383] PCI: Setting latency timer of device 
0000:02:00.0 to 64

ok - so far...

but then:

May 20 17:48:50   vdr: [7428] frontend 1 timed out while tuning to channel 2, 
tp 514
May 20 17:48:50   kernel: [   80.313642] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:48:51   kernel: [   81.247786] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:48:53   kernel: [   83.150433] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:48:53   kernel: [   83.720342] eth0: no IPv6 routers present
May 20 17:48:54   kernel: [   84.117987] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:48:56   kernel: [   86.047256] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:48:57   kernel: [   86.979688] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
...
May 20 17:48:59   kernel: [   88.486428] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:49:00   kernel: [   89.498026] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:49:02   kernel: [   91.416250] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:49:03   kernel: [   92.346871] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
...
May 20 17:49:23   kernel: [  109.368185] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:49:24   kernel: [  109.934506] xc2028 3-0061: Loading 3 firmware 
images from xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia), 
ver 2.7
May 20 17:49:24   kernel: [  109.938812] xc2028 3-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:49:24   kernel: [  110.034395] xc2028 2-0061: i2c output error: rc 
= -5 (should be 4)
May 20 17:49:24   kernel: [  110.034399] xc2028 2-0061: -5 returned from send
May 20 17:49:24   kernel: [  110.034434] xc2028 2-0061: Error -22 while 
loading base firmware
May 20 17:49:24   kernel: [  110.081951] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 17:49:24   kernel: [  110.088001] xc2028 2-0061: i2c output error: rc 
= -5 (should be 64)
May 20 17:49:24   kernel: [  110.088003] xc2028 2-0061: -5 returned from send
May 20 17:49:24   kernel: [  110.088050] xc2028 2-0061: Error -22 while 
loading base firmware
May 20 17:49:24   kernel: [  110.089843] zl10353: write to reg 62 failed (err 
= -5)!
May 20 17:49:24   kernel: [  110.091667] zl10353: write to reg 5f failed (err 
= -5)!
May 20 17:49:24   kernel: [  110.093428] zl10353: write to reg 71 failed (err 
= -5)!
May 20 17:49:24   kernel: [  110.095201] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 17:49:24   kernel: [  110.105956] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 17:49:24   kernel: [  110.116251] zl10353_read_register: readreg error 
(reg=6, ret==-5)
...

May 20 18:01:00   kernel: [  791.122235] xc2028 3-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 18:01:01   kernel: [  791.998348] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 18:01:02   kernel: [  793.049839] xc2028 2-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 18:01:02   kernel: [  793.144856] xc2028 3-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
May 20 18:01:03   kernel: [  794.054455] xc2028 2-0061: i2c output error: rc 
= -5 (should be 4)
May 20 18:01:03   kernel: [  794.054460] xc2028 2-0061: -5 returned from send
May 20 18:01:03   kernel: [  794.054528] xc2028 2-0061: Error -22 while 
loading base firmware
May 20 18:01:03   kernel: [  794.056622] zl10353: write to reg 62 failed (err 
= -5)!
May 20 18:01:03   kernel: [  794.058744] zl10353: write to reg 5f failed (err 
= -5)!
May 20 18:01:03   kernel: [  794.060858] zl10353: write to reg 71 failed (err 
= -5)!
May 20 18:01:03   kernel: [  794.063013] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 18:01:03   kernel: [  794.075006] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 18:01:03   kernel: [  794.087060] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 18:01:03   kernel: [  794.098969] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 18:01:03   kernel: [  794.111100] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 18:01:03   kernel: [  794.122939] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 18:01:03   kernel: [  794.135009] zl10353_read_register: readreg error 
(reg=6, ret==-5)
May 20 18:01:03   kernel: [  794.148908] zl10353_read_register: readreg error 
(reg=6, ret==-5)

any idea to help me? 

thanks in advance, jochen

Am Donnerstag 15 Mai 2008 00:12:52 schrieb stev391@email.com:
>  Thom,
>
> Disclaimer: This not guranteed to work and will break any webcams you
> have running on ubuntu, this is reversable by reinstalling the "linux-*"
> packages that you have already installed.
>
> I can't seem to find any information about that version of Mythbuntu, is
> it supposed to be version 8.04? Anyway the following will work for
> previous versions as well.
> All commands to be run in a terminal.
>
> Step 1, Install the required packages to retrieve and compile the source
> (you also need to install the linux-headers that match your kernel, which
> is done by the following command as well)
> sudo apt-get install mercurial build-essential patch linux-headers-`uname
> -r`
>
> Step 2, Retrieve the v4l-dvb sources
> hg clone http://linuxtv.org/hg/v4l-dvb
>
> Step 3, Apply patch (which was an attachment on the previous email)
> cd v4l-dvb
> patch -p1 < ../DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v2.patch
>
> Step 4, Compile which will take awhile... (maybe time to make a cup of
> coffee)
> make all
>
> Step 5 Remove the old modules as this causes issues when loading the
> modules later(this depends on version of ubuntu)
> 8.04:  cd /lib/modules/`uname -r`/ubuntu/media
> cd /lib/modules/`uname -r`/kernel/drivers/media
> sudo rm -r common
> sudo rm -r dvb
> sudo rm -r radio
> sudo rm -r video
>
> Step 6: return to v4l-dvb directory and run:
> sudo make install
>
> Step 7: Update the initramfs:
> sudo dpkg-reconfigure linux-ubuntu-modules-`uname -r`
>
> Step 8: Reboot and see if it worked
> sudo shutdown -r now
>
> If this didn't work with my patch please send me the output of dmesg and
> any relevant logs of the application that you used to identify the
> problem with (eg mythbackend log). Then try replacing step 2 & 3 with
> (This uses the older branch by Chris Pascoe, whose code I'm trying to
> update to bring into the main v4l-dvb):
> hg clone http://linuxtv.org/hg/~pascoe/xc-test/
> cd xc-test
>
> If this still doesn't work and your dvb system is broken just reinstall
> your linux-* packages.
>
> Regards,
> Stephen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
