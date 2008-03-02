Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JVw4B-0004Dh-81
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 22:49:55 +0100
Message-ID: <47CB20ED.5070403@philpem.me.uk>
Date: Sun, 02 Mar 2008 21:49:33 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Nicolas Will <nico@youplala.net>
References: <47A98F3D.9070306@raceme.org>		<1202403104.5780.42.camel@eddie.sth.aptilo.com>		<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>		<47C4661C.4030408@philpem.me.uk>		<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>		<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>		<47C7076B.6060903@philpem.me.uk>
	<47C879BA.7080002@philpem.me.uk>		<1204356192.6583.0.camel@youkaida>	<47CA609F.3010209@philpem.me.uk>		<8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>		<47CAB51F.9030103@philpem.me.uk>	<1204479088.6236.32.camel@youkaida>
	<47CAEFC3.2020305@philpem.me.uk>
In-Reply-To: <47CAEFC3.2020305@philpem.me.uk>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

And now the icing on the cake:

[17296.754309] <<< b5 7d
[17296.754311] I2C read failed on address a
[17298.643002] >>> 02 15 81 fd
[17298.643012] ep 0 read error (status = -19)
[17298.643013] <<< b5 7d
[17298.643015] I2C read failed on address a
[17300.535677] >>> 02 15 81 fd
[17300.535687] ep 0 read error (status = -19)
[17300.535688] <<< b5 7d
[17300.535690] I2C read failed on address a
[17302.193280] usbcore: deregistering interface driver dvb_usb_dib0700
[17302.314293] dib0700: loaded with support for 6 different device-types
[17302.420405] BUG: unable to handle kernel paging request at virtual address 
fa23bda0
[17302.420412] printing eip: f89bd162 *pde = 374ac067 *pte = 00000000
[17302.420417] Oops: 0000 [#1] SMP
[17302.420420] Modules linked in: dvb_usb_dib0700 dib7000p dib7000m dvb_usb 
dib0070 isofs udf video output container sbs sbshc ac dock battery mt2060 
dib3000mc dibx000_common iptable_filter ip_tables x_tables af_packet lp 
dvb_pll ipv6 cx22702 wlan_wep isl6421 cx24123 cx88_dvb cx88_vp3054_i2c 
wlan_scan_sta ath_rate_sample snd_hda_intel tuner tea5767 tda8290 snd_hwdep 
tda18271 tda827x tuner_xc2028 xc5000 snd_seq_dummy tda9887 cx88_alsa 
snd_pcm_oss snd_mixer_oss tuner_simple tuner_types snd_seq_oss mt20xx tea5761 
ath_pci wlan ath_hal(P) sr_mod cdrom snd_pcm nvidia(P) snd_seq_midi cx8802 
cx8800 snd_page_alloc cx88xx snd_rawmidi snd_seq_midi_event ir_common 
i2c_algo_bit videodev v4l1_compat compat_ioctl32 v4l2_common atiixp 
videobuf_dvb dvb_core snd_seq snd_timer snd_seq_device tveeprom 
videobuf_dma_sg videobuf_core btcx_risc snd i2c_piix4 button ati_agp agpgart 
ide_core i2c_core parport_pc parport soundcore shpchp pci_hotplug k8temp evdev 
pcspkr pata_atiixp ext3 jbd mbcache sg sd_mod ata_generic floppy uhci_hcd 
pata_acpi ahci ohci_hcd ehci_hcd libata usbcore scsi_mod ssb r8169 thermal 
processor fan fuse
[17302.420479]
[17302.420481] Pid: 9917, comm: kdvb-ad-1-fe-0 Tainted: P 
(2.6.24-11-generic #1)
[17302.420484] EIP: 0060:[<f89bd162>] EFLAGS: 00010286 CPU: 0
[17302.420493] EIP is at i2c_transfer+0x22/0x60 [i2c_core]
[17302.420496] EAX: fa23bda0 EBX: ffffffda ECX: 00000003 EDX: dddebf00
[17302.420498] ESI: dddebf00 EDI: f77a255c EBP: 00000003 ESP: dddebed8
[17302.420500]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[17302.420503] Process kdvb-ad-1-fe-0 (pid: 9917, ti=dddea000 task=d8c59680 
task.ti=dddea000)
[17302.420505] Stack: dddebf00 f7515a28 dddebf00 dddebf54 dddebf68 f9c811bb 
00000000 00000000
[17302.420510]        ddadb700 00000000 0000000a 00000004 dddebf58 00000074 
00000002 dddebf9a
[17302.420515]        0000000a 00000004 dddebf54 00000282 00000282 00000024 
dddebf00 00000001
[17302.420520] Call Trace:
[17302.420529]  [<f9c811bb>] dibx000_i2c_gated_tuner_xfer+0x10b/0x1b0 
[dibx000_common]
[17302.420563]  [<c0136f2e>] del_timer_sync+0xe/0x20
[17302.420576]  [<f89bd17e>] i2c_transfer+0x3e/0x60 [i2c_core]
[17302.420590]  [<fa3800dc>] mt2060_writereg+0x3c/0x60 [mt2060]
[17302.420601]  [<f8a56a4e>] dvb_frontend_thread+0x1ae/0x300 [dvb_core]
[17302.420620]  [<c0141b80>] autoremove_wake_function+0x0/0x40
[17302.420632]  [<f8a568a0>] dvb_frontend_thread+0x0/0x300 [dvb_core]
[17302.420644]  [<c01418c2>] kthread+0x42/0x70
[17302.420647]  [<c0141880>] kthread+0x0/0x70
[17302.420653]  [<c0106677>] kernel_thread_helper+0x7/0x10
[17302.420665]  =======================
[17302.420666] Code: ff 83 c4 04 0f b6 c0 5b c3 83 ec 14 89 5c 24 04 bb da ff 
ff ff 89 7c 24 0c 89 c7 89 6c 24 10 89 cd 89 74 24 08 89 14 24 8b 40 0c <8b> 
00 85 c0 74 1f 8d 77 20 89 f0 e8 1e af 95 c7 8b 5f 0c 89 e9
[17302.420689] EIP: [<f89bd162>] i2c_transfer+0x22/0x60 [i2c_core] SS:ESP 
0068:dddebed8
[17302.420697] ---[ end trace 8ec949325fb5108c ]---

I give up.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
