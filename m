Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lindsay@softlog.com.au>) id 1L2HjF-0005wa-J0
	for linux-dvb@linuxtv.org; Tue, 18 Nov 2008 04:58:23 +0100
Received: from [127.0.0.1] by softlog.com.au (MDaemon PRO v9.5.6)
	with ESMTP id 34-md50000010111.msg
	for <linux-dvb@linuxtv.org>; Tue, 18 Nov 2008 13:57:20 +1000
Message-ID: <49223D1E.9030300@softlog.com.au>
Date: Tue, 18 Nov 2008 13:57:18 +1000
From: Lindsay Mathieson <lindsay@softlog.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <bf82ea70811110306v345c9061sc6d49f6a961647c@mail.gmail.com>	<bf82ea70811110312y487610d8v9656c3e76bf44e0@mail.gmail.com>
	<49199510.6040809@iki.fi>
In-Reply-To: <49199510.6040809@iki.fi>
Subject: Re: [linux-dvb] DigitalNow TinyTwin second tuner support
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

Antti Palosaari wrote:
> I disabled 2nd tuner by default due to bad performance I faced up with 
> my hardware. Anyhow, you can enable it by module param, use modprobe 
> dvb-usb-af9015 dual_mode=1 . Test it and please report.
>   


All this has inspired me to retry my DigitalNow TinyTwin. The results
are good (excellent) and badish. I am available to do any testing and
builds required. Thanks for all the hard work!


I installed http://linuxtv.org/hg/~anttip/af9015 drivers and firmware,
rebooted. As expected one tuner recognised (/dev/advb/adaptor0).

The Good:
A "scan au-Brisbane" picked up every local channel, quite surprising as
I was just using the crappy little antenna that came with it. Better
yet, MythTV displayed the video on the all the channels with excellent
reception - signal strength > 60%, no artifacts. That's better than any
of the other tuners I have trialled on this test PC with similar setups,
but it is in line with the windows drivers. The TinyTwin just seems to
get really good reception when driven correctly. Its worth it for the
single tuner alone.

The not so good :)

I did a "modprobe dvb-usb-af9015 dual_mode=1" and got similar results to
Rasjid - adapter1/frontend0 was not created and there were errors about
copying the firmware. However on a reboot both frontends were there.
Warm start maybe?

The Bad:

"scan au-Brisbane"  Wored ok, but a"scan -a 1 au-Brisbane" caused
adapter0 to vanish and adapter1 never found anything. The following was
in the dmesg log:

[   18.580472] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[   18.651520] dvb-usb: found a 'DigitalNow TinyTwin DVB-T Receiver' in
warm state.
[   18.653716] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   18.654146] DVB: registering new adapter (DigitalNow TinyTwin DVB-T
Receiver)
[   19.075397] af9013: firmware version:4.95.0
[   19.078525] DVB: registering adapter 0 frontend 0 (Afatech AF9013
DVB-T)...
[   19.124192] MXL5005S: Attached at address 0xc6
[   19.124200] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   19.124546] DVB: registering new adapter (DigitalNow TinyTwin DVB-T
Receiver)
[   19.840938] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
[   19.843561] af9013: firmware version:4.95.0
[   19.854940] DVB: registering adapter 1 frontend 0 (Afatech AF9013
DVB-T)...
[   19.857416] MXL5005S: Attached at address 0xc6
[   19.857425] dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully
initialized and connected.
[   19.865120] usbcore: registered new interface driver dvb_usb_af9015
[   21.051565] lp0: using parport0 (interrupt-driven).
[   21.208198] Adding 2931820k swap on /dev/sda5.  Priority:-1 extents:1
across:2931820k
[  132.658475] EXT3 FS on sda1, internal journal
[  133.822855] type=1505 audit(1226979475.926:2):
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
name2="default" pid=4757
[  133.823238] type=1505 audit(1226979475.926:3):
operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=4757
[  133.895870] type=1505 audit(1226979475.998:4):
operation="profile_load" name="/usr/sbin/mysqld" name2="default" pid=4761
[  134.002705] ip_tables: (C) 2000-2006 Netfilter Core Team
[  134.634248] ACPI: WMI: Mapper loaded
[  135.752137] warning: `avahi-daemon' uses 32-bit capabilities (legacy
support in use)
[  135.979368] NET: Registered protocol family 10
[  135.981872] lo: Disabled Privacy Extensions
[  137.822364] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[  137.822373] apm: overridden by ACPI.
[  137.978810] ppdev: user-space parallel port driver
[  146.119109] Bluetooth: Core ver 2.13
[  146.121766] NET: Registered protocol family 31
[  146.121775] Bluetooth: HCI device and connection manager initialized
[  146.121780] Bluetooth: HCI socket layer initialized
[  146.159765] Bluetooth: L2CAP ver 2.11
[  146.159772] Bluetooth: L2CAP socket layer initialized
[  146.184114] Bluetooth: SCO (Voice Link) ver 0.6
[  146.184123] Bluetooth: SCO socket layer initialized
[  146.208068] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[  146.208077] Bluetooth: BNEP filters: protocol multicast
[  146.260898] Bridge firewalling registered
[  146.261994] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[  146.277457] Bluetooth: RFCOMM socket layer initialized
[  146.277832] Bluetooth: RFCOMM TTY layer initialized
[  146.277841] Bluetooth: RFCOMM ver 1.10
[  150.384692] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[  150.736597] NET: Registered protocol family 17
[  161.368023] eth0: no IPv6 routers present
[  498.629022] hub 1-0:1.0: port 2 disabled by hub (EMI?), re-enabling...
[  498.629035] usb 1-2: USB disconnect, address 2
[  498.631235] af9015: recv bulk message failed:-22
[  498.631244] af9013: I2C read failed reg:d2e1
[  498.640057] BUG: unable to handle kernel NULL pointer dereference at
0000054c
[  498.640066] IP: [<c037d536>] mutex_lock_interruptible+0x16/0x40
[  498.640077] *pde = 00000000
[  498.640083] Oops: 0002 [#1] SMP
[  498.640088] Modules linked in: af_packet rfcomm bridge stp bnep sco
l2cap bluetooth ppdev ipv6 speedstep_lib cpufreq_powersave
cpufreq_userspace cpufreq_ondemand cpufreq_stats freq_table
cpufreq_conservative video output container sbs sbshc wmi pci_slot
battery iptable_filter ip_tables x_tables ac lp mxl5005s af9013 evdev
dvb_usb_af9015 dvb_usb snd_intel8x0 dvb_core snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy parport_pc parport
snd_seq_oss snd_seq_midi snd_rawmidi psmouse serio_raw
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcspkr button
soundcore sis_agp agpgart i2c_sis96x snd_page_alloc shpchp pci_hotplug
i2c_core ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg ata_generic
usbhid hid pata_sis pata_acpi 8139cp ohci_hcd ehci_hcd libata 8139too
mii usbcore scsi_mod dock thermal processor fan fbcon tileblit font
bitblit softcursor fuse
[  498.640161]
[  498.640165] Pid: 6848, comm: kdvb-ad-1-fe-0 Not tainted
(2.6.27-7-generic #1)
[  498.640168] EIP: 0060:[<c037d536>] EFLAGS: 00010246 CPU: 0
[  498.640172] EIP is at mutex_lock_interruptible+0x16/0x40
[  498.640177] EAX: ffffffff EBX: 0000054c ECX: 00000002 EDX: f2961f08
[  498.640180] ESI: fffffff5 EDI: f78ebc20 EBP: f2961ea0 ESP: f2961e9c
[  498.640183]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  498.640186] Process kdvb-ad-1-fe-0 (pid: 6848, ti=f2960000
task=e5d06480 task.ti=f2960000)
[  498.640189] Stack: f8ad8ba8 f2961edc f8ad345f 00000002 f2961f08
0000054c f2961f3c 00000000
[  498.640197]        f2961ef0 f8c3c1a8 f8c3ece8 0000d2e1 0000003a
f8ad8ba8 f78ebc00 f78ebc20
[  498.640205]        f2961ef8 f89255c9 00000002 f2961f08 0000d730
f2961f3f 0000d730 f2961f2c
[  498.640213] Call Trace:
[  498.640219]  [<f8ad345f>] ? af9015_i2c_xfer+0x2f/0x1c0 [dvb_usb_af9015]
[  498.640231]  [<f8c3c1a8>] ? af9013_read_reg+0x88/0x90 [af9013]
[  498.640245]  [<f89255c9>] ? i2c_transfer+0x69/0xa0 [i2c_core]
[  498.640259]  [<f8c3c181>] ? af9013_read_reg+0x61/0x90 [af9013]
[  498.640265]  [<f8c3c614>] ? af9013_write_reg_bits+0x34/0x90 [af9013]
[  498.640272]  [<f8c3c758>] ? af9013_lock_led+0x38/0x60 [af9013]
[  498.640278]  [<f8c3de44>] ? af9013_sleep+0x24/0x50 [af9013]
[  498.640284]  [<f8acc182>] ? dvb_usb_fe_sleep+0x22/0x30 [dvb_usb]
[  498.640294]  [<f8b09f96>] ? dvb_frontend_thread+0x126/0x610 [dvb_core]
[  498.640312]  [<c01474b0>] ? autoremove_wake_function+0x0/0x50
[  498.640320]  [<f8b09e70>] ? dvb_frontend_thread+0x0/0x610 [dvb_core]
[  498.640332]  [<c0147141>] ? kthread+0x41/0x80
[  498.640340]  [<c0147100>] ? kthread+0x0/0x80
[  498.640344]  [<c0105297>] ? kernel_thread_helper+0x7/0x10
[  498.640350]  =======================
[  498.640352] Code: 10 5b 5e 5f 5d c3 eb 0d 90 90 90 90 90 90 90 90 90
90 90 90 90 55 89 e5 53 e8 77 7d d8 ff 89 c3 e8 90 f8 ff ff b8 ff ff ff
ff 90 <0f> c1 03 31 d2 85 c0 7e 09 89 d0 5b 5d c3 8d 74 26 00 89 d8 e8
[  498.640392] EIP: [<c037d536>] mutex_lock_interruptible+0x16/0x40
SS:ESP 0068:f2961e9c
[  498.640399] ---[ end trace be81ece8b3ffd2cc ]---



-- 
Lindsay
Softlog Systems




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
