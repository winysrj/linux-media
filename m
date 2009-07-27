Return-path: <linux-media-owner@vger.kernel.org>
Received: from phobos03.frii.com ([216.17.128.163]:56853 "EHLO mail.frii.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754513AbZG0BnR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2009 21:43:17 -0400
Date: Sun, 26 Jul 2009 19:43:16 -0600
From: Mark Zimmerman <markzimm@frii.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
Subject: Re: TBS 8920 still fails to initialize - cx24116_readreg error
Message-ID: <20090727014316.GA97600@io.frii.com>
References: <20090724023315.GA96337@io.frii.com> <200907241906.11914.liplianin@me.by> <20090725022206.GA17704@io.frii.com> <200907261529.13781.liplianin@me.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907261529.13781.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 26, 2009 at 03:29:13PM +0300, Igor M. Liplianin wrote:
> On 25 ???? 2009 05:22:06 Mark Zimmerman wrote:
> > On Fri, Jul 24, 2009 at 07:06:11PM +0300, Igor M. Liplianin wrote:
> > > On 24 ???? 2009 05:33:15 Mark Zimmerman wrote:
> > > > Greetings:
> > > >
> > > > Using current current v4l-dvb drivers, I get the following in the
> > > > dmesg:
> > > >
> > > > cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
> > > > cx88[1]/2: cx2388x based DVB/ATSC card
> > > > cx8802_alloc_frontends() allocating 1 frontend(s)
> > > > cx24116_readreg: reg=0xff (error=-6)
> > > > cx24116_readreg: reg=0xfe (error=-6)
> > > > Invalid probe, probably not a CX24116 device
> > > > cx88[1]/2: frontend initialization failed
> > > > cx88[1]/2: dvb_register failed (err = -22)
> > > > cx88[1]/2: cx8802 probe failed, err = -22
> > > >
> > > > Does this mean that one of the chips on this card is different than
> > > > expected? How can I gather useful information about this?
> > >
> > > Hi
> > > You can try:
> > > http://www.tbsdtv.com/download/tbs6920_8920_v23_linux_x86_x64.rar
> >
> > This code did not compile as-is, but after I commented out some things
> > in drivers I do not need, I managed to build something. The TBS card
> > now seems to be initialized, but it also broke support for my DViCO
> > FusionHDTV7 Dual Express card, which also uses a cx23885.
> >
> > I am going to move this card to another machine that does not have any
> > other capture cards and repeat the process. This should make it easier
> > to know what the TBS card/driver is doing.
> >
> > I am assuming that you are interested in using me to gather
> > information to update the v4l-dvb drivers so that this card can be
> > supported properly. Is this correct?  Please let me know what I can do
> > to assist.
> I've changed tbs 8920 initialization in http://mercurial.intuxication.org/hg/s2-liplianin.
> I ask you to try it.
> If it works, then I will commit it to linuxv.
> Also pay attention to remote.
> 

Unfortunately, there appears to be no change:

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
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
  alloc irq_desc for 22 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] -> GSI 22 (level, low) -> IRQ 22
VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
cx24116_readreg: reg=0xff (error=-6)
cx24116_readreg: reg=0xfe (error=-6)
Invalid probe, probably not a CX24116 device
cx88[0]/2: frontend initialization failed
cx88[0]/2: dvb_register failed (err = -22)
cx88[0]/2: cx8802 probe failed, err = -22

Just for reference, here is how it looks when using the drivers
compiled from the source in tbs6920_8920_v23_linux_x86_x64.rar:

cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx88[0]: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72,autodetected], frontend(s): 1
cx88[0]: TV tuner type 4, Radio tuner type -1
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
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
cx88/2: cx2388x dvb driver version 0.0.6 loaded
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

vtest$ ls -laR /dev/dvb
/dev/dvb:
total 0
drwxr-xr-x  3 root root   60 2009-07-26 19:32 .
drwxr-xr-x 18 root root 3480 2009-07-26 19:32 ..
drwxr-xr-x  2 root root  120 2009-07-26 19:32 adapter0

/dev/dvb/adapter0:
total 0
drwxr-xr-x 2 root root     120 2009-07-26 19:32 .
drwxr-xr-x 3 root root      60 2009-07-26 19:32 ..
crw-rw---- 1 root video 212, 1 2009-07-26 19:32 demux0
crw-rw---- 1 root video 212, 2 2009-07-26 19:32 dvr0
crw-rw---- 1 root video 212, 0 2009-07-26 19:32 frontend0
crw-rw---- 1 root video 212, 3 2009-07-26 19:32 net0

Also, here are the diffs of cx88-dvb.c between your version and the one from
the manufacturer.  I wonder if the magic number writes at line 1142 could be
what makes it work. I can try adding them to your source if you think it is
advisable.

--- linux/drivers/media/video/cx88/cx88-dvb.c   2009-07-26 18:00:00.000000000 -0600
+++ /home/mark/tbs8920/linux-s2api-tbs6920-8920-v23/linux/drivers/media/video/cx88/cx88-dvb.c   2009-06-07 18:15:11.000000000 -0600
@@ -428,14 +428,17 @@
        switch (voltage) {
                case SEC_VOLTAGE_13:
                        printk("LNB Voltage SEC_VOLTAGE_13\n");
-                       cx_write(MO_GP0_IO, 0x00006040);
+                       cx_set(MO_GP0_IO, 0x00006040);
+                       cx_clear(MO_GP0_IO, 0x00000020);
                        break;
                case SEC_VOLTAGE_18:
                        printk("LNB Voltage SEC_VOLTAGE_18\n");
-                       cx_write(MO_GP0_IO, 0x00006060);
+                       cx_set(MO_GP0_IO, 0x00006020);
+                       cx_set(MO_GP0_IO, 0x00000040);
                        break;
                case SEC_VOLTAGE_OFF:
                        printk("LNB Voltage SEC_VOLTAGE_off\n");
+                       cx_clear(MO_GP0_IO, 0x00000020);
                        break;
        }
 
@@ -1021,7 +1024,6 @@
                }
                break;
         case CX88_BOARD_PINNACLE_HYBRID_PCTV:
-       case CX88_BOARD_WINFAST_DTV1800H:
                fe0->dvb.frontend = dvb_attach(zl10353_attach,
                                               &cx88_pinnacle_hybrid_pctv,
                                               &core->i2c_adap);
@@ -1142,6 +1144,15 @@
        case CX88_BOARD_TBS_8920:
        case CX88_BOARD_PROF_7300:
        case CX88_BOARD_SATTRADE_ST4200:
+               printk(KERN_INFO "%s() setup TBS8920\n", __func__);
+               cx_write(MO_GP0_IO, 0x00008000);
+               msleep(100);
+               cx_write(MO_SRST_IO, 0);
+               msleep(10);
+               cx_write(MO_GP0_IO, 0x00008080);
+               msleep(100);
+               cx_write(MO_SRST_IO, 1);
+               msleep(100);
                fe0->dvb.frontend = dvb_attach(cx24116_attach,
                                               &hauppauge_hvr4000_config,
                                               &core->i2c_adap);
@@ -1179,7 +1190,7 @@
                fe1->dvb.frontend->ops.ts_bus_ctrl = cx88_dvb_bus_ctrl;
 
        /* Put the analog decoder in standby to keep it quiet */
-       call_all(core, tuner, s_standby);
+       cx88_call_i2c_clients(core, TUNER_SET_STANDBY, NULL);
 
        /* register everything */
        return videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,

-- Mark
