Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LE9VU-0003bq-BB
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 22:37:10 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Matyas Sustik <linux-dvb.list@sustik.com>
In-Reply-To: <494D4A00.6020305@sustik.com>
References: <494D4A00.6020305@sustik.com>
Date: Sat, 20 Dec 2008 22:37:58 +0100
Message-Id: <1229809078.4702.34.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fusion HDTV7 again
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

Hi Matyas,

Am Samstag, den 20.12.2008, 13:39 -0600 schrieb Matyas Sustik:
> Hi All,
> 
> After a dist-upgrade my HDTV7 Dual Express card stopped working.  I managed
> to get it to work before, from the logs from Dec 15:
> 
> Dec 15 23:47:47 cheetah kernel: [   10.701054] cx23885 driver version 0.0.1 load
> ed
> Dec 15 23:47:47 cheetah kernel: [   10.701117] ACPI: PCI Interrupt 0000:02:00.0[
> A] -> GSI 16 (level, low) -> IRQ 16
> Dec 15 23:47:47 cheetah kernel: [   10.701237] CORE cx23885[0]: subsystem:
> 18ac:d618, board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
> Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 0 registered
> Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 1 registered
> Dec 15 23:47:47 cheetah kernel: [   10.842540] cx23885[0]: i2c bus 2 registered
> Dec 15 23:47:47 cheetah kernel: [   10.870102] cx23885[0]: cx23885 based dvb card
> 
> That was with linux-image-2.6.26-1-amd64_2.6.26-11_amd64.deb and compiled the
> cx23885 module from the mercurial repo.
> 
> The current kernel is from: linux-image-2.6.26-1-amd64_2.6.26-12_amd64.deb.
> I pulled the mercurial sources again did make and make install, rebooted but
> I still get:
> 
> Dec 20 13:15:02 cheetah kernel: [   11.801129] cx23885: disagrees about
> version of symbol v4l_compat_ioctl32
> Dec 20 13:15:02 cheetah kernel: [   11.801133] cx23885: Unknown symbol
> v4l_compat_ioctl32
> 
> I have seen this before, but I cannot figure out what is happening.  I would
> appreciate if someone could explain to me what is going on here.  That may
> reduce my frustration somewhat.
> 
> If there is some documentation on how to debug a problem like this I would be
> willing to do some debug and even work on it.  I suspect that the kernel
> interface got updated and changes for the driver is needed.  Maybe this is a
> simple enough project to get started with open source.  (Let me know if
> not...)  I have not contributed to open source yet, so please be gentle.
> 
> I tried reinstalling the old linux-image package but that now does not work
> either.  There must be some other software/libs that got updated from apt-get
> dist-upgrade rendering the cx23885 module unusable at the present.
> 
> Any insight would be appreciated.
> Matyas
> -

if you install the first time mercurial v4l-dvb on older kernels,
it always can happen that module names have changed and new modules are
added.

Since you don't know what is going on in details, you are not aware of.

In this case the old compat-ioctl32 is not replaced by the new
v4l2-compat-ioctl32 module.

If you do on top of the modules of your kernel version
"less modules.symbols |grep ioctl32",
you likely will see this.
alias symbol:v4l_compat_ioctl32 compat_ioctl32
alias symbol:v4l_compat_ioctl32 v4l2-compat-ioctl32

But it should be only that.
less modules.symbols |grep ioctl32
alias symbol:v4l_compat_ioctl32 v4l2-compat-ioctl32

On top of the mercurial v4l-dvb do
"make rmmod", since some complaints are visible do it again.

Then "make rminstall" should remove all old modules,
but renamed ones or such in distribution specific wrong locations
remain.

Check with "ls -R |grep .ko" on top of your kernel's media modules
folder.

Delete the media folder or the modules.

Now on "make install" everything is created new and a "depmod -a" on the
end of it will automatically create all dependencies and module.symbols.

Only in case of a deprecated module is not unloaded with "make rmmod",
you might have to do this manually or reboot.

>From now on everything will work automatically until again modules are
changed.

Use "modprobe -v" for loading, since this will also reveal possibly
conflicting kernel modules in other locations than the media folder.

Cheers,
Hermann








_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
