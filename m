Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6aff0a99d6c5222c3fab+1628+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JNDa8-0007jt-FX
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 21:42:52 +0100
Date: Thu, 7 Feb 2008 18:42:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Richard (MQ)" <osl2008@googlemail.com>
Message-ID: <20080207184221.1ea8e823@gaivota>
In-Reply-To: <47AB6A1B.5090100@googlemail.com>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, 07 Feb 2008 20:29:15 +0000
"Richard (MQ)" <osl2008@googlemail.com> wrote:

> Richard (MQ) wrote:
> > Mauro Carvalho Chehab wrote:
> >> "Richard (MQ)" <osl2008@googlemail.com> wrote:
> >>>> tuner: Unknown parameter `tuner_xc2028'
> >> Hmm... I suspect you did something wrong at modprobe.conf.local. It seems that
> >> it is using tuner_xc2028 as a parameter to tuner module.
> >>
> >> What we need is to have a parameter "debug=1" to both tuner an tuner-xc2028
> >> modules.
> > 
> > I thought I just pasted your lines straight in...
> > 
> > I'll have another try tonight, maybe something is mis-typed. If I load
> > with modprobe -v it will show the options being used.
> 
> After booting:
> DevBox2400:~ # rmmod tuner tuner-xc2028 saa7134 tuner-simple tuner-types
> DevBox2400:~ # modprobe -vv tuner
> insmod /lib/modules/.../media/video/tuner-types.ko
> insmod /lib/modules/.../media/video/tuner-simple.ko
> insmod /lib/modules/.../media/video/tuner-xc2028.ko debug=1
> insmod /lib/modules/.../media/video/tuner.ko debug=1
> DevBox2400:~ # modprobe -vv saa7134
> insmod /lib/modules/.../kernel/drivers/media/video/saa7134/saa7134.ko
> 
> but /var/log/messages shows no sign of the debug messages:
> 
> Feb  7 20:08:49 DevBox2400 kernel: saa7130/34: v4l2 driver version
> 0.2.14 loaded
> Feb  7 20:08:49 DevBox2400 kernel: saa7133[0]: found at 0000:00:0d.0,
> rev: 209, irq: 20, latency: 32, mmio: 0xe2000000
> Feb  7 20:08:49 DevBox2400 kernel: saa7133[0]: subsystem: 1461:f936,
> board: AVerMedia Hybrid TV/Radio (A16D) [card=133,autodetected]
> Feb  7 20:08:49 DevBox2400 kernel: saa7133[0]: board init: gpio is 2f600
> Feb  7 20:08:50 DevBox2400 kernel: saa7133[0]: i2c eeprom 00: 61 14 36
> f9 00 00 00 00 00 00 00 00 00 00 00 00
> ...
> 
> modinfo confirms that tuner-xc2028 is your code. I'm completely baffled
> by this...

If you're not seeing any mesage from tuner-xc2028, it means that the driver is
selecting a different tuner.

Please send me the complete dmesg.

Also, try to force saa7134 driver to use tuner=71 with:

modprobe -vv saa7134 tuner=71

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
