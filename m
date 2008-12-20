Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <piobair@mindspring.com>) id 1LE9de-0004Vx-9V
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 22:45:36 +0100
Message-ID: <10172429.1229809528190.JavaMail.root@elwamui-mouette.atl.sa.earthlink.net>
Date: Sat, 20 Dec 2008 16:45:27 -0500 (GMT-05:00)
From: William Melgaard <piobair@mindspring.com>
To: Matyas Sustik <linux-dvb.list@sustik.com>, linux-dvb@linuxtv.org
Mime-Version: 1.0
Subject: Re: [linux-dvb] Fusion HDTV7 again
Reply-To: William Melgaard <piobair@mindspring.com>
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

I get a segmentation fault when I try to configure Mythtv. Googleing "mythtv segmentation", I find that someone else has that problem; his dump includes a call to OpenGL. If I try to compile the trivial "hello world" in OpenGL, I get a segmentation fault. Apparently it is the Nvidia driver. I am also using a Debian AMD64 kernel, with the nv driver and a Geforce 6200 card..
WRM

-----Original Message-----
>From: Matyas Sustik <linux-dvb.list@sustik.com>
>Sent: Dec 20, 2008 2:39 PM
>To: linux-dvb@linuxtv.org
>Subject: [linux-dvb] Fusion HDTV7 again
>
>Hi All,
>
>After a dist-upgrade my HDTV7 Dual Express card stopped working.  I managed
>to get it to work before, from the logs from Dec 15:
>
>Dec 15 23:47:47 cheetah kernel: [   10.701054] cx23885 driver version 0.0.1 load
>ed
>Dec 15 23:47:47 cheetah kernel: [   10.701117] ACPI: PCI Interrupt 0000:02:00.0[
>A] -> GSI 16 (level, low) -> IRQ 16
>Dec 15 23:47:47 cheetah kernel: [   10.701237] CORE cx23885[0]: subsystem:
>18ac:d618, board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
>Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 0 registered
>Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 1 registered
>Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 2 registered
>Dec 15 23:47:47 cheetah kernel: [   10.870102] cx23885[0]: cx23885 based dvb card
>
>That was with linux-image-2.6.26-1-amd64_2.6.26-11_amd64.deb and compiled the
>cx23885 module from the mercurial repo.
>
>The current kernel is from: linux-image-2.6.26-1-amd64_2.6.26-12_amd64.deb.
>I pulled the mercurial sources again did make and make install, rebooted but
>I still get:
>
>Dec 20 13:15:02 cheetah kernel: [   11.801129] cx23885: disagrees about
>version of symbol v4l_compat_ioctl32
>Dec 20 13:15:02 cheetah kernel: [   11.801133] cx23885: Unknown symbol
>v4l_compat_ioctl32
>
>I have seen this before, but I cannot figure out what is happening.  I would
>appreciate if someone could explain to me what is going on here.  That may
>reduce my frustration somewhat.
>
>If there is some documentation on how to debug a problem like this I would be
>willing to do some debug and even work on it.  I suspect that the kernel
>interface got updated and changes for the driver is needed.  Maybe this is a
>simple enough project to get started with open source.  (Let me know if
>not...)  I have not contributed to open source yet, so please be gentle.
>
>I tried reinstalling the old linux-image package but that now does not work
>either.  There must be some other software/libs that got updated from apt-get
>dist-upgrade rendering the cx23885 module unusable at the present.
>
>Any insight would be appreciated.
>Matyas
>-
>Every hardware eventually breaks.  Every software eventually works.
>
>_______________________________________________
>linux-dvb mailing list
>linux-dvb@linuxtv.org
>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
