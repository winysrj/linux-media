Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sub87-230-124-80.he-dsl.de ([87.230.124.80] helo=ts4.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@ts4.de>) id 1Jg18w-0002PV-6Z
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 19:16:31 +0200
Received: from tom by ts4.de with local (Exim 4.62)
	(envelope-from <linux-dvb@ts4.de>) id 1Jg18O-0005sN-02
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 19:15:56 +0200
Date: Sun, 30 Mar 2008 19:15:55 +0200
From: Thomas Schuering <linux-dvb@ts4.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080330171555.GA22523@ts4.de>
References: <20080329134637.GA13258@ts4.de> <47EEEC06.5050705@shikadi.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47EEEC06.5050705@shikadi.net>
Subject: Re: [linux-dvb] Xcv2028/3028 init: general protection fault (was:
	DViCO Dual Digital 4 w/ Ubuntu 7.10/amd64 => 'general
	protection fault' by modprobe)
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

Hi Adam,

> I wonder whether this is related to your problem? 
> lsmod lists tuner_xc2028 loaded, as this is the tuner on the card (see my
> kernel's messages below.) By removing that module you may have tricked the
> kernel into thinking the module is loaded and ready when it's not, hence
> the crash.

I know, the module is necessary for the CARD to work properly.
When I don't exclude it from modules.dep the PC doesn't boot normally.
That's my problem.

The init of xc2028 seg faults.
WITH tuner-xc2028 in /lib/modules/2.6.22-14-generic/modules.dep
modprobe FAILS during the boot-phase.


> Maybe you could get around it my manually inserting that module first, 
> before anything else?

Let's see if we get more debug-details.

I rmmod'ed all modules and re-installed them in the following sequence:
modprobe -v dvb-core      debug=1
modprobe -v dvb-usb       debug=1
modprobe -v dvb-pll       debug=1
modprobe -v tuner-xc2028  debug=1
modprobe -v zl10353       debug=1
modprobe -v dvb-usb-cxusb debug=1

The last modprobe added to /var/log/kern.log:
----------------------------------------------------------------------
 kernel: [20347.882552] check for warm 1660 932
 kernel: [20347.882557] check for cold fe9 d500
 kernel: [20347.882559] check for warm fe9 d501
 kernel: [20347.882561] check for cold fe9 db50
 kernel: [20347.882563] check for warm fe9 db51
 kernel: [20347.882565] check for cold fe9 db54
 kernel: [20347.882566] check for warm fe9 db55
 kernel: [20347.882568] check for cold fe9 db58
 kernel: [20347.882570] check for warm fe9 db59
 kernel: [20347.882572] check for cold fe9 db00
 kernel: [20347.882574] check for warm fe9 db01
 kernel: [20347.882576] check for cold fe9 db10
 kernel: [20347.882578] check for warm fe9 db11
 kernel: [20347.882580] check for warm fe9 db78
 kernel: [20347.882582] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
 kernel: [20347.882588] power control: 1
 kernel: [20347.885522] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
 kernel: [20347.885760] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
 kernel: [20348.041391] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
 kernel: [20348.041615] xc2028: Xcv2028/3028 init called!
 kernel: [20348.041618] xc2028: video_dev =0000000000000000
 kernel: [20348.041774] xc2028: usage count is 31
 kernel: [20348.041796] general protection fault: 0000 [1] SMP 
 kernel: [20348.041800] CPU 0 
 kernel: [20348.041803] Modules linked in: dvb_usb_cxusb zl10353 tuner_xc2028 dvb_pll dvb_usb dvb_core compat_ioctl32 videodev v4l1_compat ir_common v4l2_common tveeprom snd_rtctimer binfmt_misc rfcomm l2cap bluetooth vboxdrv ppdev acpi_cpufreq cpufreq_stats cpufreq_conservative cpufreq_ondemand freq_table cpufreq_userspace cpufreq_powersave container ac video sbs dock button battery ext2 coretemp w83627ehf i2c_isa sbp2 parport_pc lp parport loop snd_hda_intel snd_pcm_oss snd_mixer_oss ipv6 snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd sky2 nvidia(P) psmouse soundcore pcspkr serio_raw intel_agp snd_page_alloc i2c_core iTCO_wdt iTCO_vendor_support shpchp pci_hotplug evdev ext3 jbd mbcache sg sd_mod sr_mod cdrom usb_storage ide_core libusual ohci1394 ieee1394 ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse apparmor commoncap
 kernel: [20348.041871] Pid: 6629, comm: modprobe Tainted: P       2.6.22-14-generic #1
 kernel: [20348.041874] RIP: 0010:[_end+136964174/2130324728]  [_end+136964174/2130324728] :tuner_xc2028:xc2028_attach+0x166/0x240
 kernel: [20348.041882] RSP: 0018:ffff810125495bd8  EFLAGS: 00010206
 kernel: [20348.041886] RAX: 0020000000a08c00 RBX: ffffffff88900500 RCX: 0000000000000080
 kernel: [20348.041889] RDX: 00000000ffffffff RSI: ffffffff888fe1a0 RDI: ffff81013143ce78
 kernel: [20348.041892] RBP: ffff810125495c08 R08: 0000000000000000 R09: 0000000000000000
 kernel: [20348.041895] R10: 0000000000000000 R11: 0000000000000005 R12: ffff81013143cc08
 kernel: [20348.041898] R13: 0000000000000000 R14: ffff810103e6c040 R15: 0000000000000000
 kernel: [20348.041902] FS:  00002b8069e836e0(0000) GS:ffffffff80561000(0000) knlGS:0000000000000000
 kernel: [20348.041906] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 kernel: [20348.041908] CR2: 00000000008fcf80 CR3: 000000016c864000 CR4: 00000000000006e0
 kernel: [20348.041912] Process modprobe (pid: 6629, threadinfo ffff810125494000, task ffff81016554d4a0)
 kernel: [20348.041915] Stack:  ffff810100000000 ffff810103e6cdb8 0000000000000000 ffff810103e6cdb0
 kernel: [20348.041921]  ffff810103e6c000 ffffffff88c3ed7b ffff810103e6ca28 0000000000000061
 kernel: [20348.041927]  0000000000000000 0000000000000000 ffffffff88c3f420 0000000000000000
 kernel: [20348.041931] Call Trace:
 kernel: [20348.041941]  [_end+140384883/2130324728] :dvb_usb_cxusb:cxusb_dvico_xc3028_tuner_attach+0x5b/0xe0
 kernel: [20348.041949]  [_end+140386584/2130324728] :dvb_usb_cxusb:dvico_bluebird_xc2028_callback+0x0/0xa0
 kernel: [20348.041958]  [_end+136916456/2130324728] :dvb_usb:dvb_usb_adapter_frontend_init+0x80/0x100
 kernel: [20348.041965]  [_end+136914564/2130324728] :dvb_usb:dvb_usb_device_init+0x40c/0x650
 kernel: [20348.041980]  [_end+140381683/2130324728] :dvb_usb_cxusb:cxusb_probe+0xab/0x100
 kernel: [20348.041998]  [_end+127797193/2130324728] :usbcore:usb_probe_interface+0xd1/0x120
 kernel: [20348.042010]  [driver_probe_device+163/432] driver_probe_device+0xa3/0x1b0
 kernel: [20348.042018]  [__driver_attach+201/208] __driver_attach+0xc9/0xd0
 kernel: [20348.042024]  [__driver_attach+0/208] __driver_attach+0x0/0xd0
 kernel: [20348.042029]  [bus_for_each_dev+77/128] bus_for_each_dev+0x4d/0x80
 kernel: [20348.042039]  [bus_add_driver+175/496] bus_add_driver+0xaf/0x1f0
 kernel: [20348.042057]  [_end+127795617/2130324728] :usbcore:usb_register_driver+0xa9/0x120
 kernel: [20348.042066]  [_end+128015635/2130324728] :dvb_usb_cxusb:cxusb_module_init+0x1b/0x35
 kernel: [20348.042072]  [sys_init_module+411/6576] sys_init_module+0x19b/0x19b0
 kernel: [20348.042101]  [system_call+126/131] system_call+0x7e/0x83
 kernel: [20348.042112] 
 kernel: [20348.042114] 
 kernel: [20348.042114] Code: 8b 90 10 03 00 00 48 8b 73 28 31 c0 0f b6 c9 49 c7 c0 61 e4 
 kernel: [20348.042126] RIP  [_end+136964174/2130324728] :tuner_xc2028:xc2028_attach+0x166/0x240
 kernel: [20348.042132]  RSP <ffff810125495bd8>

----------------------------------------------------------------------

'xc2028: video_dev =0000000000000000' looks strange.
I don't know why just one adapter is found.

$ lsmod | grep i2c
----------------------------------------------------------------------
i2c_isa                 6400  1 w83627ehf
i2c_core               30208  9 zl10353,tuner_xc2028,dvb_pll,dvb_usb,v4l2_common,tveeprom,w83627ehf,i2c_isa,nvidia
----------------------------------------------------------------------




> dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [APCJ] -> GSI 22 (level, 
> high) -> IRQ 18
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
> DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
> xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner

That tuner_info isn't executed on my system.
Seems the memcpy before breaks.
--- tuner-xc2028.c ---
        memcpy(&fe->ops.tuner_ops, &xc2028_dvb_tuner_ops,
               sizeof(xc2028_dvb_tuner_ops));
--- tuner-xc2028.c ---


Thank you for including the log of a working installation.


Regards, Thomas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
