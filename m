Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JfmIn-0006Hx-PT
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 03:25:49 +0200
Message-ID: <47EEEC06.5050705@shikadi.net>
Date: Sun, 30 Mar 2008 11:25:26 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: Thomas Schuering <linux-dvb@ts4.de>
References: <20080329134637.GA13258@ts4.de>
In-Reply-To: <20080329134637.GA13258@ts4.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO Dual Digital 4 w/ Ubuntu 7.10/amd64 =>
 'general protection fault' by modprobe
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

Hi Thomas,

> this is a DD4 rev. 1.0 (0fe9:db78).

Same as me.

> I'm running an up-to-date ubuntu-7.10 amd64 desktop
> (booted from USB-stick) (Linux mybox 2.6.22-14-generic #1 SMP
>  Tue Feb 12 02:46:46 UTC 2008 x86_64 GNU/Linux)

2.6.24.2 #1 PREEMPT Sat Feb 23 12:45:46 EST 2008 i686 AMD Athlon(tm) XP 
2800+ AuthenticAMD GNU/Linux

This is a Gentoo box.

> I failed to get the card running.
> Could someone please give me a hint what I missed?
> (If I should provide more details, just ask.)

It seems to work fine for me - the only issue I have is that the card 
silently drops the signal if the reception isn't great.

> Rebooting results in general protection faults[1].
> (BTW: What modules [and in which sequence] should be modprobed anyway?)

I have dvb-usb-cxusb in my "module autoload" scripts, that seems to pull 
in all the required modules.

> Note:
> To be able to boot normally I had to remove the lines with 'tuner-xc2028.ko'
> and 'tuner.ko' from /lib/modules/2.6.22-14-generic/modules.dep .

I wonder whether this is related to your problem?  lsmod lists 
tuner_xc2028 loaded, as this is the tuner on the card (see my kernel's 
messages below.)  By removing that module you may have tricked the 
kernel into thinking the module is loaded and ready when it's not, hence 
the crash.

Maybe you could get around it my manually inserting that module first, 
before anything else?

> [0] md5sum of /lib/firmware:
> 658397cb9eba9101af9031302671f49d  dvb-usb-bluebird-01.fw
> 62821fd26437eb9e0e4bcef7355f4ca7  dvb-usb-bluebird-02.fw
> c5475ab3c699e5c811bd391e8ee5dbb6  xc3028-dvico-au-01.fw

Same as me.

> [1] According to /var/log/kern.log:
> ----------------------------------------------------------------------
> [   65.027037] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
> [   65.027215] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> [   65.058552] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
> [   65.066162] nvidia: module license 'NVIDIA' taints kernel.
> [   65.318690] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
> [   65.318857] PCI: Setting latency timer of device 0000:01:00.0 to 64
> [   65.318936] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19  Wed Sep 12 14:08:38 PDT 2007
> [   65.580935] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
> [   65.677294] general protection fault: 0000 [1] SMP 
> [   65.677414] CPU 0

dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [APCJ] -> GSI 22 (level, 
high) -> IRQ 18
PCI: Setting latency timer of device 0000:00:06.0 to 64
DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
input: IR-receiver inside an USB DVB receiver as /class/input/input3
dvb-usb: schedule remote query interval to 100 msecs.
dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully initialized 
and connected.
dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
cxusb: No IR receiver detected on this device.
DVB: registering frontend 1 (Zarlink ZL10353 DVB-T)...
xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully initialized 
and connected.
usbcore: registered new interface driver dvb_usb_cxusb

Cheers,
Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
