Return-path: <linux-media-owner@vger.kernel.org>
Received: from phobos01.frii.com ([216.17.128.161]:49804 "EHLO mail.frii.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752872AbZG1BVz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 21:21:55 -0400
Date: Mon, 27 Jul 2009 19:21:54 -0600
From: Mark Zimmerman <markzimm@frii.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
Subject: Re: TBS 8920 still fails to initialize - cx24116_readreg error
Message-ID: <20090728012154.GA99886@io.frii.com>
References: <20090724023315.GA96337@io.frii.com> <200907261529.13781.liplianin@me.by> <20090727014316.GA97600@io.frii.com> <200907272050.20827.liplianin@me.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907272050.20827.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 27, 2009 at 08:50:20PM +0300, Igor M. Liplianin wrote:
> On 27 ???? 2009 04:43:16 Mark Zimmerman wrote:
> > On Sun, Jul 26, 2009 at 03:29:13PM +0300, Igor M. Liplianin wrote:
> > > On 25 ???? 2009 05:22:06 Mark Zimmerman wrote:
> > > > On Fri, Jul 24, 2009 at 07:06:11PM +0300, Igor M. Liplianin wrote:
> > > > > On 24 ???? 2009 05:33:15 Mark Zimmerman wrote:
> > > > > > Greetings:
> > > > > >
> > > > > > Using current current v4l-dvb drivers, I get the following in the
> > > > > > dmesg:
> > > > > >
> > > > > > cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
> > > > > > cx88[1]/2: cx2388x based DVB/ATSC card
> > > > > > cx8802_alloc_frontends() allocating 1 frontend(s)
> > > > > > cx24116_readreg: reg=0xff (error=-6)
> > > > > > cx24116_readreg: reg=0xfe (error=-6)
> > > > > > Invalid probe, probably not a CX24116 device
> > > > > > cx88[1]/2: frontend initialization failed
> > > > > > cx88[1]/2: dvb_register failed (err = -22)
> > > > > > cx88[1]/2: cx8802 probe failed, err = -22
> > > > > >
> > > > > > Does this mean that one of the chips on this card is different than
> > > > > > expected? How can I gather useful information about this?
> > > > >
> > > > > Hi
> > > > > You can try:
> > > > > http://www.tbsdtv.com/download/tbs6920_8920_v23_linux_x86_x64.rar
> > > >
> > > > This code did not compile as-is, but after I commented out some things
> > > > in drivers I do not need, I managed to build something. The TBS card
> > > > now seems to be initialized, but it also broke support for my DViCO
> > > > FusionHDTV7 Dual Express card, which also uses a cx23885.
> > > >
> > > > I am going to move this card to another machine that does not have any
> > > > other capture cards and repeat the process. This should make it easier
> > > > to know what the TBS card/driver is doing.
> > > >
> > > > I am assuming that you are interested in using me to gather
> > > > information to update the v4l-dvb drivers so that this card can be
> > > > supported properly. Is this correct?  Please let me know what I can do
> > > > to assist.
> > >
> > > I've changed tbs 8920 initialization in
> > > http://mercurial.intuxication.org/hg/s2-liplianin. I ask you to try it.
> > > If it works, then I will commit it to linuxv.
> > > Also pay attention to remote.
> >
> > Unfortunately, there appears to be no change:
> >
> > Just for reference, here is how it looks when using the drivers
> > compiled from the source in tbs6920_8920_v23_linux_x86_x64.rar:
> >
> > Also, here are the diffs of cx88-dvb.c between your version and the one
> > from the manufacturer.  I wonder if the magic number writes at line 1142
> > could be what makes it work. I can try adding them to your source if you
> > think it is advisable.
> It is advisable to try.
> I forgot about voltage control. It must preserve that "magic" number.
> 
> http://mercurial.intuxication.org/hg/s2-liplianin/rev/b1ca288a0600 
> 

This was successful.  So that there is no miscommunication, let me
specify exactly what I tested:

I started with

hg clone http://mercurial.intuxication.org/hg/s2-liplianin/rev/b1ca288a0600

and then changed cx88-dvb.c as follows:

diff -r ecdc9c389f8a linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Mon Jul 27 18:02:25 2009 +0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Mon Jul 27 19:14:53 2009 -0600
@@ -429,15 +429,17 @@
 	switch (voltage) {
 		case SEC_VOLTAGE_13:
 			printk("LNB Voltage SEC_VOLTAGE_13\n");
+			cx_set(MO_GP0_IO, 0x00006040);
 			cx_clear(MO_GP0_IO, 0x00000020);
 			break;
 		case SEC_VOLTAGE_18:
 			printk("LNB Voltage SEC_VOLTAGE_18\n");
+			cx_set(MO_GP0_IO, 0x00006020);
 			cx_set(MO_GP0_IO, 0x00000020);
 			break;
 		case SEC_VOLTAGE_OFF:
+			printk("LNB Voltage SEC_VOLTAGE_off\n");
 			cx_clear(MO_GP0_IO, 0x00000020);
-			printk("LNB Voltage SEC_VOLTAGE_off\n");
 			break;
 	}
 
@@ -1144,6 +1146,15 @@
 	case CX88_BOARD_TBS_8920:
 	case CX88_BOARD_PROF_7300:
 	case CX88_BOARD_SATTRADE_ST4200:
+		printk(KERN_INFO "%s() setup TBS8920\n", __func__);
+		cx_write(MO_GP0_IO, 0x00008000);
+		msleep(100);
+		cx_write(MO_SRST_IO, 0);
+		msleep(10);
+		cx_write(MO_GP0_IO, 0x00008080);
+		msleep(100);
+		cx_write(MO_SRST_IO, 1);
+		msleep(100);
 		fe0->dvb.frontend = dvb_attach(cx24116_attach,
 					       &hauppauge_hvr4000_config,
 					       &core->i2c_adap);

make ; make install ; reboot

dmesg contained this:

cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
cx88[0]: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72,autodetected], frontend(s): 1
cx88[0]: TV tuner type 4, Radio tuner type -1
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
input: cx88 IR (TBS 8920 DVB-S/S2) as /devices/pci0000:00/0000:00:08.2/input/input6
cx88[0]/2: cx2388x 8802 Driver Manager
  alloc irq_desc for 17 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
cx88-mpeg driver manager 0000:00:08.2: PCI INT A -> GSI 17 (level, low) -> IRQ 17
cx88[0]/2: found at 0000:00:08.2, rev: 5, irq: 17, latency: 32, mmio: 0xf9000000
IRQ 17/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx8800 0000:00:08.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
cx88[0]/0: found at 0000:00:08.0, rev: 5, irq: 17, latency: 32, mmio: 0xfa000000
IRQ 17/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88/2: cx2388x dvb driver version 0.0.7 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
dvb_register() setup TBS8920
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
  alloc irq_desc for 22 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] -> GSI 22 (level, low) -> IRQ 22
VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
DVB: registering new adapter (cx88[0])
DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...

Then, I tried szap-s2 (without an attached satellite dish; I will not
have one until next week).

vtest$ ./szap-s2 -M 5 -S 1 PBS
reading channels from file '/home/mark/.szap/channels.conf'
zapping to 7 'PBS':
delivery DVB-S2, modulation 8PSK
sat 0, frequency 12140 MHz V, symbolrate 30000000, coderate auto, rolloff 0.35
vpid 0x0031, apid 0x0034, sid 0x0003
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 | 
^C

which added this to dmesg:

cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe-cx24116.fw)...
cx88-mpeg driver manager 0000:00:08.2: firmware: requesting dvb-fe-cx24116.fw
cx24116_firmware_ondemand: Waiting for firmware upload(2)...
cx24116_load_firmware: FW version 1.23.86.1
cx24116_firmware_ondemand: Firmware upload complete
LNB Voltage SEC_VOLTAGE_13
LNB Voltage SEC_VOLTAGE_off

I think that this is all that I can test without a satellite dish;
please let me know if there is anything else I can do.

Thanks for looking at this.
-- Mark
