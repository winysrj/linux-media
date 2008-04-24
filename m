Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]
	helo=gw) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <magnus@alefors.se>) id 1Jp5ZE-0008Jl-JC
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 19:49:09 +0200
Received: from [192.168.0.10] (aria.alefors.se [192.168.0.10])
	by gw (Postfix) with ESMTP id 74A90157A3
	for <linux-dvb@linuxtv.org>; Thu, 24 Apr 2008 19:49:03 +0200 (CEST)
Message-ID: <4810C80E.7090507@alefors.se>
Date: Thu, 24 Apr 2008 19:49:02 +0200
From: =?UTF-8?B?TWFnbnVzIEjDtnJsaW4=?= <magnus@alefors.se>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Mantis VP-2040 problems
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

Hi again. After adding the correct pci id's I thought I had my 
AD-CP400's up and running. I don't have dvb-c at home but scan seemed to 
work and just exited after failing to find anything. But when I 
delivered the machine to my friend with cable tv, scan crashes (tried 
several mantis hg versions). Any ideas? Are there differences between 
this card and the Cinergy C that some people seem to have up and running?
/Magnus H


[ 1300.786737] mantis start feed & dma
[ 1300.786762] BUG: unable to handle kernel paging request at virtual 
address 08a5bfff
[ 1300.809705] printing eip: f8a78b59 *pde = 00000000
[ 1300.824387] Oops: 0000 [#1] SMP
[ 1300.834140] Modules linked in: cpufreq_powersave acpi_cpufreq 
freq_table ipv6 ac sbs battery container dock video output sbshc 
iptable_filter ip_tables x_tables w83627ehf hwmon_vid lp loop af_packet 
mantis lnbp21 mb86a16 stb6100 tda10021 tda10023 stb0899 stv0299 dvb_core 
snd_hda_intel i2c_core snd_pcm snd_timer snd_page_alloc snd_hwdep snd 
intel_agp agpgart parport_pc parport soundcore button iTCO_wdt 
iTCO_vendor_support shpchp pci_hotplug evdev pcspkr ext3 jbd mbcache sg 
sd_mod ata_piix ata_generic floppy pata_acpi libata ehci_hcd uhci_hcd 
scsi_mod r8169 usbcore dm_mirror dm_snapshot dm_mod thermal processor 
fan fbcon tileblit font bitblit softcursor fuse
[ 1301.011734]
[ 1301.016200] Pid: 5355, comm: scan Not tainted (2.6.24-16-generic #1)
[ 1301.035195] EIP: 0060:[<f8a78b59>] EFLAGS: 00210206 CPU: 0
[ 1301.051602] EIP is at mantis_dma_start+0x129/0x200 [mantis]
[ 1301.068254] EAX: 3705f000 EBX: 0000003d ECX: 00000042 EDX: f8a5c000
[ 1301.086990] ESI: f705f0f0 EDI: f7215800 EBP: 0000f800 ESP: f72e9e08
[ 1301.105724]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1301.121866] Process scan (pid: 5355, ti=f72e8000 task=f72fb0e0 
task.ti=f72e8000)
[ 1301.143453] Stack: 000200d2 00000163 f7215800 f7215cb4 00000000 
00000020 f7215800 f7215cb4
[ 1301.168881]        00000000 f90cc000 f8a7a5ce f8a7eabb f8a63b0d 
00000002 00000163 00000012
[ 1301.194311]        00000000 f8a64875 f7215c48 f7215a70 00000000 
f91e103a f90c0036 f91e1000
[ 1301.219742] Call Trace:
[ 1301.227638]  [<f8a7a5ce>] mantis_dvb_start_feed+0xae/0x110 [mantis]
[ 1301.246421]  [<f8a63b0d>] dvb_demux_feed_add+0x1d/0xb0 [dvb_core]
[ 1301.264690]  [<f8a64875>] dmx_section_feed_start_filtering+0xc5/0x160 
[dvb_core]
[ 1301.286854]  [<f8a62271>] dvb_dmxdev_filter_start+0x201/0x390 [dvb_core]
[ 1301.306937]  [<f8a6253c>] dvb_demux_do_ioctl+0x13c/0x3b0 [dvb_core]
[ 1301.325722]  [<f8a6c7b5>] dvb_ringbuffer_init+0x25/0x30 [dvb_core]
[ 1301.344251]  [<f8a610e7>] dvb_usercopy+0x67/0x140 [dvb_core]
[ 1301.361227]  [<c018b5d5>] nameidata_to_filp+0x35/0x40
[ 1301.376370]  [<c018ffc0>] chrdev_open+0x0/0x190
[ 1301.389970]  [<c018b630>] do_filp_open+0x50/0x60
[ 1301.403826]  [<c014431c>] hrtimer_nanosleep+0x5c/0xd0
[ 1301.418983]  [<f8a61bb8>] dvb_demux_ioctl+0x18/0x20 [dvb_core]
[ 1301.436470]  [<f8a62400>] dvb_demux_do_ioctl+0x0/0x3b0 [dvb_core]
[ 1301.454738]  [<c0199628>] do_ioctl+0x78/0x90
[ 1301.467557]  [<c019986e>] vfs_ioctl+0x22e/0x2b0
[ 1301.481153]  [<c018b6fe>] do_sys_open+0xbe/0xe0
[ 1301.494750]  [<c0199946>] sys_ioctl+0x56/0x70
[ 1301.507828]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[ 1301.522987]  [<c0310000>] vcc_getsockopt+0x150/0x170
[ 1301.537881]  =======================
[ 1301.548567] Code: 00 03 47 40 c7 00 00 00 00 70 8b 57 44 8d 04 8d 04 
00 00 00 03 47 40 83 c1 02 89 10 8b 57 18 8b 47 44 89 4f 34 89 42 10 8b 
57 18 <8b> 82 ff ff ff 0f 0d 00 00 00 80 89 82 ff ff ff 0f 8b 47 18 c7
[ 1301.608299] EIP: [<f8a78b59>] mantis_dma_start+0x129/0x200 [mantis] 
SS:ESP 0068:f72e9e08
[ 1301.632628] ---[ end trace 3bf4ab4bed07c2a7 ]---


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
