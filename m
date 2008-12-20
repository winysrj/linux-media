Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb.list@sustik.com>) id 1LE7gS-0003VH-EX
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 20:40:24 +0100
Received: from [192.168.1.17] (really [66.69.251.66])
	by hrndva-omta05.mail.rr.com with ESMTP
	id <20081220193944.GODU13791.hrndva-omta05.mail.rr.com@[192.168.1.17]>
	for <linux-dvb@linuxtv.org>; Sat, 20 Dec 2008 19:39:44 +0000
Message-ID: <494D4A00.6020305@sustik.com>
Date: Sat, 20 Dec 2008 13:39:44 -0600
From: Matyas Sustik <linux-dvb.list@sustik.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Fusion HDTV7 again
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

Hi All,

After a dist-upgrade my HDTV7 Dual Express card stopped working.  I managed
to get it to work before, from the logs from Dec 15:

Dec 15 23:47:47 cheetah kernel: [   10.701054] cx23885 driver version 0.0.1 load
ed
Dec 15 23:47:47 cheetah kernel: [   10.701117] ACPI: PCI Interrupt 0000:02:00.0[
A] -> GSI 16 (level, low) -> IRQ 16
Dec 15 23:47:47 cheetah kernel: [   10.701237] CORE cx23885[0]: subsystem:
18ac:d618, board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 0 registered
Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 1 registered
Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 2 registered
Dec 15 23:47:47 cheetah kernel: [   10.870102] cx23885[0]: cx23885 based dvb card

That was with linux-image-2.6.26-1-amd64_2.6.26-11_amd64.deb and compiled the
cx23885 module from the mercurial repo.

The current kernel is from: linux-image-2.6.26-1-amd64_2.6.26-12_amd64.deb.
I pulled the mercurial sources again did make and make install, rebooted but
I still get:

Dec 20 13:15:02 cheetah kernel: [   11.801129] cx23885: disagrees about
version of symbol v4l_compat_ioctl32
Dec 20 13:15:02 cheetah kernel: [   11.801133] cx23885: Unknown symbol
v4l_compat_ioctl32

I have seen this before, but I cannot figure out what is happening.  I would
appreciate if someone could explain to me what is going on here.  That may
reduce my frustration somewhat.

If there is some documentation on how to debug a problem like this I would be
willing to do some debug and even work on it.  I suspect that the kernel
interface got updated and changes for the driver is needed.  Maybe this is a
simple enough project to get started with open source.  (Let me know if
not...)  I have not contributed to open source yet, so please be gentle.

I tried reinstalling the old linux-image package but that now does not work
either.  There must be some other software/libs that got updated from apt-get
dist-upgrade rendering the cx23885 module unusable at the present.

Any insight would be appreciated.
Matyas
-
Every hardware eventually breaks.  Every software eventually works.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
