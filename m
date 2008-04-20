Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett2@onetel.com>) id 1JnZxI-00053p-QL
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 15:51:46 +0200
Message-Id: <11E5EC6B-6658-4703-A2B1-F39EB49ED318@onetel.com>
From: Tim Hewett <tghewett2@onetel.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sun, 20 Apr 2008 14:49:57 +0100
Cc: Tim Hewett <tghewett2@onetel.com>
Subject: [linux-dvb] Mantis 2033 crashes
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

Same problem here with a Technisat SkyStar HD2 / Azurewave AD SP400 /  
Twinhan VP-1041 using dvbstream.

I have reverted to changeset 7301 ("hg clone -r 7301 -v http://jusst.de/hg/mantis 
") and applied this patch: http://de.pastebin.ca/957250 (this may only  
be needed for my card) and it now works again.

This is the dmesg output for the oops:

[  118.332804] stb0899_search: Unsupported delivery system
[  118.582670] stb0899_search: Unsupported delivery system
[  118.832590] stb0899_search: Unsupported delivery system
[  119.082405] stb0899_search: Unsupported delivery system
[  119.332273] stb0899_search: Unsupported delivery system
[  119.582141] stb0899_search: Unsupported delivery system
[  119.832008] stb0899_search: Unsupported delivery system
[  120.081876] stb0899_search: Unsupported delivery system
[  120.331744] stb0899_search: Unsupported delivery system
[  120.581612] stb0899_search: Unsupported delivery system
[  120.831479] stb0899_search: Unsupported delivery system
[  121.081347] stb0899_search: Unsupported delivery system
[  121.331214] stb0899_search: Unsupported delivery system
[  121.581082] stb0899_search: Unsupported delivery system
[  121.830949] stb0899_search: Unsupported delivery system
[  122.080817] stb0899_search: Unsupported delivery system
[  122.330685] stb0899_search: Unsupported delivery system
[  122.580552] stb0899_search: Unsupported delivery system
[  122.830420] stb0899_search: Unsupported delivery system
[  123.080288] stb0899_search: Unsupported delivery system
[  123.330155] stb0899_search: Unsupported delivery system
[  123.580023] stb0899_search: Unsupported delivery system
[  123.829893] stb0899_search: Unsupported delivery system
[  124.079758] stb0899_search: Unsupported delivery system
[  124.329626] stb0899_search: Unsupported delivery system
[  124.579493] stb0899_search: Unsupported delivery system
[  124.829365] stb0899_search: Unsupported delivery system
[  125.079230] stb0899_search: Unsupported delivery system
[  125.329100] stb0899_search: Unsupported delivery system
[  125.578966] stb0899_search: Unsupported delivery system
[  125.828834] stb0899_search: Unsupported delivery system
[  126.078701] stb0899_search: Unsupported delivery system
[  126.328569] stb0899_search: Unsupported delivery system
[  126.578436] stb0899_search: Unsupported delivery system
[  126.828304] stb0899_search: Unsupported delivery system
[  127.078172] stb0899_search: Unsupported delivery system
[  127.328039] stb0899_search: Unsupported delivery system
[  127.577907] stb0899_search: Unsupported delivery system
[  127.827774] stb0899_search: Unsupported delivery system
[  128.077642] stb0899_search: Unsupported delivery system
[  131.048073] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[  131.050128] stb0899_search: set DVB-S params
[  131.062412] stb6100_set_bandwidth: Bandwidth=51610000
[  131.064526] stb6100_get_bandwidth: Bandwidth=52000000
[  131.075930] stb6100_get_bandwidth: Bandwidth=52000000
[  131.108036] stb6100_set_frequency: Frequency=1008000
[  131.110150] stb6100_get_frequency: Frequency=1007991
[  131.116143] stb6100_get_bandwidth: Bandwidth=52000000
[  131.145284] mantis start feed & dma
[  131.145304] Unable to handle kernel paging request at  
ffffc200122bbfff RIP:
[  131.145306]  [<ffffffff8824aa89>] :mantis:mantis_dma_start 
+0x129/0x1e0
[  131.145314] PGD 1f4ad067 PUD 1f4ae067 PMD 0
[  131.145317] Oops: 0000 [1] SMP
[  131.145319] CPU 1
[  131.145321] Modules linked in: it87 hwmon_vid appletalk rfcomm  
l2cap bluetooth nfsd lockd auth_rpcgss sunrpc exportfs ppdev  
powernow_k8 cpufreq_powersave cpufreq_userspace cpufreq_conservative  
cpufreq_ondemand cpufreq_stats freq_table ac sbs sbshc container dock  
video output battery nls_iso8859_1 nls_cp437 vfat fat sbp2 lp  
snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy  
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq sg  
dvb_usb_af9005_remote snd_timer snd_seq_device serio_raw  
dvb_usb_af9005 snd evdev parport_pc nvidia(P) ide_cd usbhid cdc_ether  
usbnet dvb_usb_dtt200u dvb_usb mantis soundcore parport psmouse pcspkr  
cdrom mii b2c2_flexcop_pci b2c2_flexcop snd_page_alloc lnbp21 mb86a16  
stb6100 tda10021 tda10023 stb0899 stv0299 dvb_core i2c_nforce2 generic  
i2c_core shpchp pci_hotplug button ipv6 ext3 jbd mbcache sata_nv  
floppy libata ohci1394 ieee1394 forcedeth amd74xx ehci_hcd ohci_hcd  
usbcore sd_mod scsi_mod thermal processor fan fuse
[  131.145363] Pid: 6037, comm: dvbstream Tainted: P        2.6.24.4 #1
[  131.145365] RIP: 0010:[<ffffffff8824aa89>]   
[<ffffffff8824aa89>] :mantis:mantis_dma_start+0x129/0x1e0
[  131.145370] RSP: 0018:ffff81001067bce8  EFLAGS: 00010282
[  131.145372] RAX: 000000001e7aa000 RBX: ffff81001e8fe000 RCX:  
0000000000000042
[  131.145374] RDX: ffffc200022bc000 RSI: 000000000000003d RDI:  
ffff81001e8fe000
[  131.145375] RBP: 000000000000f800 R08: 0000000860d32304 R09:  
ffff81001da9e0d8
[  131.145377] R10: ffff81000100e800 R11: 0000000000000000 R12:  
0000000000000020
[  131.145379] R13: ffff81001e8fe6e0 R14: ffff81001e8fe700 R15:  
ffffc20002410008
[  131.145381] FS:  00002b7aee71b6e0(0000) GS:ffff81001f52fac0(0000)  
knlGS:0000000000000000
[  131.145383] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  131.145384] CR2: ffffc200122bbfff CR3: 000000001eba7000 CR4:  
00000000000006e0
[  131.145386] DR0: 0000000000000000 DR1: 0000000000000000 DR2:  
0000000000000000
[  131.145388] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:  
0000000000000400
[  131.145390] Process dvbstream (pid: 6037, threadinfo  
ffff81001067a000, task ffff81001d9b6100)
[  131.145391] Stack:  ffff81001e8fe000 ffff81001e8fe438  
00000000fffffe00 ffffffff8824c5b4
[  131.145395]  ffff81001e8fe438 ffffc200022f5000 ffff81001e8fe438  
ffffffff881d2b5f
[  131.145397]  0000000000000000 ffffc20002410000 0000000000000000  
0000000000000001
[  131.145400] Call Trace:
[  131.145407]  [<ffffffff8824c5b4>] :mantis:mantis_dvb_start_feed 
+0xb4/0x110
[  131.145418]   
[<ffffffff881d2b5f>] :dvb_core:dmx_ts_feed_start_filtering+0x5f/0xf0
[  131.145428]  [<ffffffff881d050f>] :dvb_core:dvb_dmxdev_filter_start 
+0x31f/0x460
[  131.145441]  [<ffffffff881d07e9>] :dvb_core:dvb_demux_do_ioctl 
+0x199/0x460
[  131.145450]  [<ffffffff881d0650>] :dvb_core:dvb_demux_do_ioctl 
+0x0/0x460
[  131.145457]  [<ffffffff881cf0ff>] :dvb_core:dvb_usercopy+0x7f/0x1a0
[  131.145467]  [<ffffffff80231973>] __wake_up+0x43/0x70
[  131.145474]  [<ffffffff80374431>] tty_ldisc_deref+0x51/0x80
[  131.145483]  [<ffffffff802ac8cd>] do_ioctl+0x7d/0xa0
[  131.145487]  [<ffffffff802ac964>] vfs_ioctl+0x74/0x2d0
[  131.145490]  [<ffffffff8029f822>] vfs_write+0x142/0x190
[  131.145495]  [<ffffffff802acc51>] sys_ioctl+0x91/0xb0
[  131.145502]  [<ffffffff8020c29e>] system_call+0x7e/0x83
[  131.145511]
[  131.145511]
[  131.145512] Code: 8b 82 ff ff ff 0f 0d 00 00 00 80 89 82 ff ff ff  
0f 48 8b 43
[  131.145518] RIP  [<ffffffff8824aa89>] :mantis:mantis_dma_start 
+0x129/0x1e0
[  131.145523]  RSP <ffff81001067bce8>
[  131.145524] CR2: ffffc200122bbfff
[  131.145526] ---[ end trace d90d4656b0b3a08b ]---

Tim.

>> Bas v.d. Wiel schrieb:
>> > I tried using the very latest code from Manu that has some  
>> beginning
>> > support for the CI module. This only crashes the mantis module  
>> with a
>> > huge error message (I'll post the exact error later, can't access  
>> the
>> > machine right now) as soon as I insert my Alphacrypt. Same  
>> happens when
>> > I switch the PC on with the cam already inserted. When there's  
>> nothing
>> > in the CI slot, everything loads up alright and the CA device gets
>> > registered properly.
>> >
>> It crashes here, when I start vdr-1.4.7 (on 2.6.24.4) even without  
>> the
>> CAM (Alphacrypt light) inserted.
>>
>> I got the latest code with
>>
>>     hg clone http://jusst.de/hg/mantis
>>
>> However, tuning and watching unencrypted channels works perfectly  
>> with
>> code from
>>
>>     hg clone http://jusst.de/hg/mantis_old_1
>>
>> or
>>
>>     http://jusst.de/manu/mantis-v4l-dvb.tar.bz2
>> <http://jusst.de/manu/mantis-v4l-dvb.tar.bz2>
>>
>>
>> The card registers with
>>
>>     mantis_frontend_init (0): Probing for CU1216 (DVB-C)
>>     TDA10021: i2c-addr = 0x0c, id = 0x7c
>>     mantis_frontend_init (0): found Philips CU1216 DVB-C frontend
>> (TDA10021) @ 0x0c
>>     mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend
>> attach success
>>     DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
>>     mantis_ca_init (0): Registering EN50221 device
>>     mantis_ca_init (0): Registered EN50221 device
>>     mantis_hif_init (0): Adapter(0) Initializing Mantis Host  
>> Interface
>>
>> > If there's anything I can do to help debug this driver, I'd be  
>> happy
>> > to
>> >
>> Same applies to me!
>>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
