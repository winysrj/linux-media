Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KtOXS-0007BZ-Cg
	for linux-dvb@linuxtv.org; Fri, 24 Oct 2008 17:25:25 +0200
From: Darron Broad <darron@kewl.org>
To: Matthias Schwarzott <zzam@gentoo.org>
In-reply-to: <200810241247.08480.zzam@gentoo.org> 
References: <200810241247.08480.zzam@gentoo.org>
Date: Fri, 24 Oct 2008 16:25:18 +0100
Message-ID: <4360.1224861918@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] [resent] cx88-dvb: Fix Oops in case i2c bus
	failed to register
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <200810241247.08480.zzam@gentoo.org>, Matthias Schwarzott wrote:

Hiya.

>Hi!
>
>@Mauro: Please pull this patch
>There already is an report at kernel bugzilla about this issue: 
>http://bugzilla.kernel.org/show_bug.cgi?id=9455
>
>When enabling extra checks for the i2c-bus of cx88 based cards by
>loading i2c_algo_bit with bit_test=1 this may trigger an oops
>when loading cx88_dvb.
>
>This is caused by the extra check code that detects that the
>sda-line is stuck high and thus does not register the i2c-bus.
>
>cx88-dvb however does not check if the i2c-bus is valid and just
>uses core->i2c_adap to attach dvb frontend modules.
>This leads to an oops at the first call to i2c_transfer:
>
># modprobe i2c_algo_bit bit_test=1
># modprobe cx8802

Thanks for this information. If you don't mind, would you let
me utilise this fix in another way?

I have been auditing MFE additions and I need to change
something elsewhere and can see an alternative to
to bailing out in dvb_register?

Thanks


>cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
>cx88[0]: quirk: PCIPCI_NATOMA -- set TBFX
>cx88[0]: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S 
>[card=37,autodetected], frontend(s): 1
>cx88[0]: TV tuner type 4, Radio tuner type -1
>cx88[0]: SDA stuck high!
>cx88[0]: i2c register FAILED
>input: cx88 IR (Hauppauge Nova-S-Plus  as /class/input/input5
>cx88[0]/2: cx2388x 8802 Driver Manager
>cx88-mpeg driver manager 0000:00:10.2: enabling device (0154 -> 0156)
>cx88-mpeg driver manager 0000:00:10.2: PCI INT A -> Link[LNKD] -> GSI 9 
>(level, low) -> IRQ 9
>cx88[0]/2: found at 0000:00:10.2, rev: 5, irq: 9, latency: 64, mmio: 
>0xfb000000
>cx8802_probe() allocating 1 frontend(s)
>cx88/2: cx2388x dvb driver version 0.0.6 loaded
>cx88/2: registering cx8802 driver, type: dvb access: shared
>cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S [card=37]
>cx88[0]/2: cx2388x based DVB/ATSC card
>BUG: unable to handle kernel NULL pointer dereference at 00000000
>IP: [<e084d4ef>] :i2c_core:i2c_transfer+0x1f/0x80
>*pde = 00000000
>Modules linked in: cx88_dvb(+) cx8802 cx88xx ir_common i2c_algo_bit tveeprom 
>videobuf_dvb btcx_risc
>mga drm ipv6 fscpos eeprom nfsd exportfs stv0299 b2c2_flexcop_pci b2c2_flexcop 
>cx24123 s5h1420 ves1x93
>dvb_ttpci dvb_core saa7146_vv saa7146 videobuf_dma_sg videobuf_core videodev 
>v4l1_compat ttpci_eeprom
>lirc_serial lirc_dev usbhid rtc uhci_hcd 8139too i2c_piix4 i2c_core usbcore 
>evdev
>Pid: 4249, comm: modprobe Not tainted (2.6.27-gentoo #3)
>EIP: 0060:[<e084d4ef>] EFLAGS: 00010296 CPU: 0
>EIP is at i2c_transfer+0x1f/0x80 [i2c_core]
>EAX: 00000000 EBX: ffffffa1 ECX: 00000002 EDX: d6c71e3c
>ESI: d80cd050 EDI: d8093c00 EBP: d6c71e20 ESP: d6c71e0c
>DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>---[ end trace b32d87d0f0db1832 ]---
>
>I added a check for i2c registration success before attaching frontends.
>
>Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
>
>--Boundary-00=_seaAJIF74ESp9Id
>Content-Type: text/x-diff;
>  charset="iso 8859-15";
>  name="cx88-dvb-oops-i2c.diff"
>Content-Transfer-Encoding: 7bit
>Content-Disposition: attachment;
>	filename="cx88-dvb-oops-i2c.diff"
>
>cx88-dvb: Fix Oops in case i2c bus failed to register
>
>When enabling extra checks for the i2c-bus of cx88 based cards by
>loading i2c_algo_bit with bit_test=1 this may trigger an oops
>when loading cx88_dvb.
>
>This is caused by the extra check code that detects that the
>sda-line is stuck high and thus does not register the i2c-bus.
>
>cx88-dvb however does not check if the i2c-bus is valid and just
>uses core->i2c_adap to attach dvb frontend modules.
>This leads to an oops at the first call to i2c_transfer:
>
># modprobe i2c_algo_bit bit_test=1
># modprobe cx8802
>
>cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
>cx88[0]: quirk: PCIPCI_NATOMA -- set TBFX
>cx88[0]: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S [card=37,autodetected], frontend(s): 1
>cx88[0]: TV tuner type 4, Radio tuner type -1
>cx88[0]: SDA stuck high!
>cx88[0]: i2c register FAILED
>input: cx88 IR (Hauppauge Nova-S-Plus  as /class/input/input5
>cx88[0]/2: cx2388x 8802 Driver Manager
>cx88-mpeg driver manager 0000:00:10.2: enabling device (0154 -> 0156)
>cx88-mpeg driver manager 0000:00:10.2: PCI INT A -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
>cx88[0]/2: found at 0000:00:10.2, rev: 5, irq: 9, latency: 64, mmio: 0xfb000000
>cx8802_probe() allocating 1 frontend(s)
>cx88/2: cx2388x dvb driver version 0.0.6 loaded
>cx88/2: registering cx8802 driver, type: dvb access: shared
>cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S [card=37]
>cx88[0]/2: cx2388x based DVB/ATSC card
>BUG: unable to handle kernel NULL pointer dereference at 00000000
>IP: [<e084d4ef>] :i2c_core:i2c_transfer+0x1f/0x80
>*pde = 00000000
>Modules linked in: cx88_dvb(+) cx8802 cx88xx ir_common i2c_algo_bit tveeprom videobuf_dvb btcx_risc
>mga drm ipv6 fscpos eeprom nfsd exportfs stv0299 b2c2_flexcop_pci b2c2_flexcop cx24123 s5h1420 ves1x93
>dvb_ttpci dvb_core saa7146_vv saa7146 videobuf_dma_sg videobuf_core videodev v4l1_compat ttpci_eeprom
>lirc_serial lirc_dev usbhid rtc uhci_hcd 8139too i2c_piix4 i2c_core usbcore evdev
>Pid: 4249, comm: modprobe Not tainted (2.6.27-gentoo #3)
>EIP: 0060:[<e084d4ef>] EFLAGS: 00010296 CPU: 0
>EIP is at i2c_transfer+0x1f/0x80 [i2c_core]
>EAX: 00000000 EBX: ffffffa1 ECX: 00000002 EDX: d6c71e3c
>ESI: d80cd050 EDI: d8093c00 EBP: d6c71e20 ESP: d6c71e0c
>DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>---[ end trace b32d87d0f0db1832 ]---
>
>I added a check for i2c registration success before attaching frontends.
>
>Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
>
>Index: v4l-dvb/linux/drivers/media/video/cx88/cx88-dvb.c
>===================================================================
>--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-dvb.c
>+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-dvb.c
>@@ -605,6 +605,11 @@ static int dvb_register(struct cx8802_de
> 	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
> 	int mfe_shared = 0; /* bus not shared by default */
> 
>+	if (0 != core->i2c_rc) {
>+		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
>+		goto frontend_detach;
>+	}
>+
> 	/* Get the first frontend */
> 	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
> 	if (!fe0)
>
>--Boundary-00=_seaAJIF74ESp9Id
>Content-Type: text/plain; charset="us-ascii"
>MIME-Version: 1.0
>Content-Transfer-Encoding: 7bit
>Content-Disposition: inline
>
>_______________________________________________
>linux-dvb mailing list
>linux-dvb@linuxtv.org
>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>--Boundary-00=_seaAJIF74ESp9Id--
>
>

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
