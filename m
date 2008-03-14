Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+2f2457f4b8686c4b8dda+1664+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JaF7x-0001CK-2P
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 19:59:37 +0100
Date: Fri, 14 Mar 2008 15:58:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080314155851.52677f28@gaivota>
In-Reply-To: <1205518856.6094.14.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu> <20080314121423.670f31a0@gaivota>
	<1205518856.6094.14.camel@ubuntu>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, "Richard \(MQ\)" <osl2008@googlemail.com>
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
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

On Sat, 15 Mar 2008 03:20:56 +0900
timf <timf@iinet.net.au> wrote:

> Hi Mauro,
> 
> On Fri, 2008-03-14 at 12:14 -0300, Mauro Carvalho Chehab wrote:
> > On Fri, 14 Mar 2008 10:16:48 +0900
> > timf <timf@iinet.net.au> wrote:
> > 
> > > Hi Mauro,
> > > Improved, but still no tuner-xc3028, no dvb.
> > > Relevant part of my dmesg:
> > 
> > > [   15.120000] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> > > [   15.120000] tuner' 2-0061: tuner type not set
> > > [   15.120000] tuner' 2-0061: tuner type not set
> > 
> > The above messages are very weird... are you passing any option to saa7134? It
> > should autodetect tuner=71...
> > 
> > Cheers,
> > Mauro
> 
> OK, I have just done a completely new install of ubuntu 7.10.
> (dmesg1.txt, lspci1.txt, lsmod1.txt)
> 
> Then v4l-dvb via mercurial (download-via-mercurial.txt)
> 
> Then sudo cp xc3028-v27.fw /lib/firmware/2.6.22-14-generic
> (lib-firmware-2.6.22-14-generic.txt)
> 
> Then cd v4l-dvb, make, sudo make install, reboot
> (dmesg2.txt, lspci2.txt, lsmod2.txt)
> 
> Then cd v4l-dvb, patch -p1 < a16d-patch1.diff,
> (patch-result.txt)
> make, sudo make install, reboot
> (dmesg3.txt, lspci3.txt, lsmod3.txt)
> 
> Nothing done to /etc/modprobe.d /etc/modules

Very weird. It shouldn't print that messages.

Please add this at modprobe.conf (or modprobe.d):

	options tuner-xc2028 debug=1
	options tuner debug=1

Also, let's remove the old v4l modules from your kernel:
	make rminstall
	make rmmod

Now, do two tests, with v4l-dvb tree + the patch:

1) do a modprobe saa7134 and collect the logs that start after you modprobe saa7134;

2) do:
	make rmmod
	modprobe saa7134 tuner=71 i2c_scan=1

   also, collect the logs

---

You should notice that the driver is currently without support for DVB. After
fixing analog, we will need to patch cx88-dvb to inform the kernel about the
demod chip in use by this board, and provide the proper configuration
parameters for the demod.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
