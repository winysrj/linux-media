Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:46426 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab3ERHgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 May 2013 03:36:09 -0400
Message-ID: <51972F64.3080009@dct.mine.nu>
Date: Sat, 18 May 2013 09:36:04 +0200
From: Karsten Malcher <debian@dct.mine.nu>
Reply-To: debian@dct.mine.nu
MIME-Version: 1.0
To: gennarone@gmail.com
CC: poma <pomidorabelisima@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Kernel freezing with RTL2832U+R820T
References: <51898A55.8050005@dct.mine.nu> <5189B5E1.3050201@gmail.com> <51965C42.4060801@dct.mine.nu> <5196902E.5030801@gmail.com>
In-Reply-To: <5196902E.5030801@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gianluca,

the crash / freezing occurs before disconnect in normal operation.
So the patch will not solve this problem.

Regards
Karsten

Am 17.05.2013 22:16, schrieb Gianluca Gennari:
>> The driver is working but after some time the system crashes and does
>> not react any more.
>> Just doing the simple test "rtl_test -s 3.2e6".
> Hi Karsten,
> this patch should fix the system crash after disconnecting the USB stick:
>
> https://patchwork.kernel.org/patch/2524651/
>
> Regards,
> Gianluca
>
>> Here is what the syslog shows:
>>
>> May 17 18:15:57 PC10 anacron[4446]: Updated timestamp for job
>> `cron.daily' to 2013-05-17
>> May 17 18:17:01 PC10 /USR/SBIN/CRON[4537]: (root) CMD (   cd /&&
>> run-parts --report /etc/cron.hourly)
>> May 17 18:25:34 PC10 kernel: [  890.646246] usb 1-2.1.1: USB disconnect,
>> device number 5
>> May 17 18:25:34 PC10 kernel: [  890.646997] usb 1-2.1.1: dvb_usb_v2:
>> 'MSI Mega Sky 55801 DVB-T USB2.0' successfully deinitialized and
>> disconnected
>> May 17 18:25:35 PC10 acpid: input device has been disconnected, fd 18
>> May 17 18:26:00 PC10 kernel: [  916.432558] usb 1-2.1.1: new high-speed
>> USB device number 6 using ehci_hcd
>> May 17 18:26:00 PC10 kernel: [  916.536923] usb 1-2.1.1: New USB device
>> found, idVendor=0bda, idProduct=2838
>> May 17 18:26:00 PC10 kernel: [  916.536934] usb 1-2.1.1: New USB device
>> strings: Mfr=1, Product=2, SerialNumber=3
>> May 17 18:26:00 PC10 kernel: [  916.536941] usb 1-2.1.1: Product:
>> RTL2838UHIDIR
>> May 17 18:26:00 PC10 kernel: [  916.536946] usb 1-2.1.1: Manufacturer:
>> Realtek
>> May 17 18:26:00 PC10 kernel: [  916.536951] usb 1-2.1.1: SerialNumber:
>> 00000001
>> May 17 18:26:00 PC10 udevd[4852]: failed to execute
>> '/lib/udev/mtp-probe' 'mtp-probe
>> /sys/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.1/1-2.1.1 1 6': No
>> such file or directory
>> May 17 18:26:00 PC10 kernel: [  916.609927] usb 1-2.1.1: dvb_usb_v2:
>> found a 'Realtek RTL2832U reference design' in warm state
>> May 17 18:26:00 PC10 kernel: [  916.610029] usbcore: registered new
>> interface driver dvb_usb_rtl28xxu
>> May 17 18:26:01 PC10 kernel: [  916.677157] usb 1-2.1.1: dvb_usb_v2:
>> will pass the complete MPEG2 transport stream to the software demuxer
>> May 17 18:26:01 PC10 kernel: [  916.677193] DVB: registering new adapter
>> (Realtek RTL2832U reference design)
>> May 17 18:26:01 PC10 kernel: [  916.700879] usb 1-2.1.1: DVB:
>> registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
>> May 17 18:26:01 PC10 kernel: [  916.794880] dvb_usb_rtl2832u: disagrees
>> about version of symbol dvb_usb_device_init
>> May 17 18:26:01 PC10 kernel: [  916.794892] dvb_usb_rtl2832u: Unknown
>> symbol dvb_usb_device_init (err -22)
>> May 17 18:26:01 PC10 kernel: [  916.794902] dvb_usb_rtl2832u: disagrees
>> about version of symbol dvb_usb_device_init
>> May 17 18:26:01 PC10 kernel: [  916.794915] dvb_usb_rtl2832u: Unknown
>> symbol dvb_usb_device_init (err -22)
>> May 17 18:26:01 PC10 kernel: [  916.808351] r820t 3-001a: creating new
>> instance
>> May 17 18:26:01 PC10 kernel: [  916.820371] r820t 3-001a: Rafael Micro
>> r820t successfully identified
>> May 17 18:26:01 PC10 kernel: [  916.827020] Registered IR keymap rc-empty
>> May 17 18:26:01 PC10 kernel: [  916.827277] input: Realtek RTL2832U
>> reference design as
>> /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.1/1-2.1.1/rc/rc0/input12
>> May 17 18:26:01 PC10 kernel: [  916.827531] rc0: Realtek RTL2832U
>> reference design as
>> /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.1/1-2.1.1/rc/rc0
>> May 17 18:26:01 PC10 kernel: [  916.827544] usb 1-2.1.1: dvb_usb_v2:
>> schedule remote query interval to 400 msecs
>> May 17 18:26:01 PC10 kernel: [  916.840839] usb 1-2.1.1: dvb_usb_v2:
>> 'Realtek RTL2832U reference design' successfully initialized and connected
>> May 17 18:26:14 PC10 acpid: input device has been disconnected, fd 18
>> May 17 18:26:14 PC10 kernel: [  930.576375] r820t 3-001a: destroying
>> instance
>> May 17 18:26:14 PC10 kernel: [  930.578921] usb 1-2.1.1: dvb_usb_v2:
>> 'Realtek RTL2832U reference design' successfully deinitialized and
>> disconnected
>> May 17 18:26:15 PC10 kernel: [  931.048882] usb 1-2.1.1: dvb_usb_v2:
>> found a 'Realtek RTL2832U reference design' in warm state
>> May 17 18:26:15 PC10 kernel: [  931.117410] usb 1-2.1.1: dvb_usb_v2:
>> will pass the complete MPEG2 transport stream to the software demuxer
>> May 17 18:26:15 PC10 kernel: [  931.117446] DVB: registering new adapter
>> (Realtek RTL2832U reference design)
>> May 17 18:26:15 PC10 kernel: [  931.123284] usb 1-2.1.1: DVB:
>> registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
>> May 17 18:26:15 PC10 kernel: [  931.123451] r820t 3-001a: creating new
>> instance
>> May 17 18:26:15 PC10 kernel: [  931.135279] r820t 3-001a: Rafael Micro
>> r820t successfully identified
>> May 17 18:26:15 PC10 kernel: [  931.143162] Registered IR keymap rc-empty
>> May 17 18:26:15 PC10 kernel: [  931.143422] input: Realtek RTL2832U
>> reference design as
>> /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.1/1-2.1.1/rc/rc1/input13
>> May 17 18:26:15 PC10 kernel: [  931.143658] rc1: Realtek RTL2832U
>> reference design as
>> /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.1/1-2.1.1/rc/rc1
>> May 17 18:26:15 PC10 kernel: [  931.143670] usb 1-2.1.1: dvb_usb_v2:
>> schedule remote query interval to 400 msecs
>> May 17 18:26:15 PC10 kernel: [  931.156039] usb 1-2.1.1: dvb_usb_v2:
>> 'Realtek RTL2832U reference design' successfully initialized and connected
>> May 17 18:26:47 PC10 acpid: input device has been disconnected, fd 18
>> May 17 18:26:47 PC10 kernel: [  963.468382] r820t 3-001a: destroying
>> instance
>> May 17 18:26:47 PC10 kernel: [  963.469754] usb 1-2.1.1: dvb_usb_v2:
>> 'Realtek RTL2832U reference design' successfully deinitialized and
>> disconnected
>> May 17 18:27:21 PC10 kernel: [  996.728959] ------------[ cut here
>> ]------------
>> May 17 18:27:21 PC10 kernel: [  996.728972] kernel BUG at
>> /build/buildd-linux_3.2.23-1-amd64-zj7gxu/linux-3.2.23/mm/slab.c:3111!
>> May 17 18:27:21 PC10 kernel: [  996.728980] invalid opcode: 0000 [#1] SMP
>> May 17 18:27:21 PC10 kernel: [  996.728988] CPU 2
>> May 17 18:27:21 PC10 kernel: [  996.728992] Modules linked in: r820t(O)
>> rtl2832(O) dvb_usb(O) dvb_usb_rtl28xxu(O) rtl2830(O) qt1010(O)
>> zl10353(O) dvb_usb_gl861(O) dvb_usb_v2(O) dvb_core(O) rc_core(O)
>> pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) ppdev lp
>> snd_hrtimer cpufreq_conservative cpufreq_stats cpufreq_powersave
>> cpufreq_userspace fuse ext3 jbd w83627ehf hwmon_vid loop
>> snd_hda_codec_hdmi nvidia(P) parport_pc parport sp5100_tco
>> snd_hda_codec_via i2c_piix4 i2c_core powernow_k8 edac_mce_amd mperf
>> edac_core k10temp processor psmouse evdev pcspkr serio_raw snd_hda_intel
>> snd_hda_codec snd_seq_midi snd_seq_midi_event snd_hwdep snd_pcm_oss
>> snd_rawmidi snd_mixer_oss wmi snd_pcm snd_seq button snd_seq_device
>> snd_page_alloc snd_timer snd soundcore thermal_sys ext4 crc16 jbd2
>> mbcache microcode usbhid hid sg sr_mod cdrom sd_mod crc_t10dif
>> ata_generic pata_atiixp ohci_hcd ahci libahci r8169 mii ehci_hcd libata
>> scsi_mod floppy usbcore usb_common [last unloaded: scsi_wait_scan]
>> May 17 18:27:21 PC10 kernel: [  996.729142]
>> May 17 18:27:21 PC10 kernel: [  996.729150] Pid: 3129, comm: Xorg
>> Tainted: P           O 3.2.0-3-amd64 #1 To Be Filled By O.E.M. To Be
>> Filled By O.E.M./M3A770DE
>> May 17 18:27:21 PC10 kernel: [  996.729162] RIP:
>> 0010:[<ffffffff810eab41>]  [<ffffffff810eab41>] ____cache_alloc+0xed/0x1fa
>> May 17 18:27:21 PC10 kernel: [  996.729181] RSP: 0018:ffff8802247dbc08
>> EFLAGS: 00010046
>> May 17 18:27:21 PC10 kernel: [  996.729187] RAX: ffff88020bdaf000 RBX:
>> ffff88022f000680 RCX: 000000000000000f
>> May 17 18:27:21 PC10 kernel: [  996.729194] RDX: ffff88022f0023d0 RSI:
>> dead000000200200 RDI: ffff88020bdaf000
>> May 17 18:27:21 PC10 kernel: [  996.729200] RBP: 0000000000000000 R08:
>> 0000000000000007 R09: ffff88022f011000
>> May 17 18:27:21 PC10 kernel: [  996.729206] R10: 0000000000000004 R11:
>> 0000000000000004 R12: 00000000000412d0
>> May 17 18:27:21 PC10 kernel: [  996.729213] R13: ffff88022f0023c0 R14:
>> ffff880226cd4400 R15: 0000000000000002
>> May 17 18:27:21 PC10 kernel: [  996.729221] FS:  00007fdf0cb67880(0000)
>> GS:ffff88022fc80000(0000) knlGS:0000000000000000
>> May 17 18:27:21 PC10 kernel: [  996.729228] CS:  0010 DS: 0000 ES: 0000
>> CR0: 0000000080050033
>> May 17 18:27:21 PC10 kernel: [  996.729234] CR2: 00007f2198e0f008 CR3:
>> 0000000225d98000 CR4: 00000000000006e0
>> May 17 18:27:21 PC10 kernel: [  996.729241] DR0: 0000000000000000 DR1:
>> 0000000000000000 DR2: 0000000000000000
>> May 17 18:27:21 PC10 kernel: [  996.729248] DR3: 0000000000000000 DR6:
>> 00000000ffff0ff0 DR7: 0000000000000400
>> May 17 18:27:21 PC10 kernel: [  996.729255] Process Xorg (pid: 3129,
>> threadinfo ffff8802247da000, task ffff8802242ea930)
>> May 17 18:27:21 PC10 kernel: [  996.729261] Stack:
>> May 17 18:27:21 PC10 kernel: [  996.729265]  ffff880225940008
>> ffff88022f0023d0 ffff88020bdaf000 ffff88022f0023e0
>> May 17 18:27:21 PC10 kernel: [  996.729278]  ffff880225093200
>> ffff880224ecefe8 00000000000000c8 ffffffffa095aab8
>> May 17 18:27:21 PC10 kernel: [  996.729289]  ffff88022f000680
>> 00000000000002d0 00000000000002d0 ffffffff810eb684
>> May 17 18:27:21 PC10 kernel: [  996.729300] Call Trace:
>> May 17 18:27:21 PC10 kernel: [  996.729570]  [<ffffffffa095aab8>] ?
>> os_alloc_mem+0x75/0xb7 [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.729581]  [<ffffffff810eb684>] ?
>> __kmalloc+0x9f/0x112
>> May 17 18:27:21 PC10 kernel: [  996.729820]  [<ffffffffa095aab8>] ?
>> os_alloc_mem+0x75/0xb7 [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.730064]  [<ffffffffa0929e92>] ?
>> _nv014822rm+0x30/0x3f [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.730288]  [<ffffffffa0366455>] ?
>> _nv001209rm+0xda5/0x3391 [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.730509]  [<ffffffffa03657eb>] ?
>> _nv001209rm+0x13b/0x3391 [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.730723]  [<ffffffffa034198e>] ?
>> _nv000966rm+0xd5/0x235 [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.730967]  [<ffffffffa09281dc>] ?
>> _nv001108rm+0x3ac/0xaaf [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.731204]  [<ffffffffa09342a7>] ?
>> rm_ioctl+0x76/0x100 [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.731441]  [<ffffffffa0952950>] ?
>> nv_kern_ioctl+0x34f/0x3bb [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.731676]  [<ffffffffa09529f5>] ?
>> nv_kern_unlocked_ioctl+0x1a/0x1e [nvidia]
>> May 17 18:27:21 PC10 kernel: [  996.731687]  [<ffffffff81106911>] ?
>> do_vfs_ioctl+0x459/0x49a
>> May 17 18:27:21 PC10 kernel: [  996.731697]  [<ffffffff8110699d>] ?
>> sys_ioctl+0x4b/0x72
>> May 17 18:27:21 PC10 kernel: [  996.731708]  [<ffffffff8100ee8e>] ?
>> math_state_restore+0x4b/0x55
>> May 17 18:27:21 PC10 kernel: [  996.731719]  [<ffffffff8134fc92>] ?
>> system_call_fastpath+0x16/0x1b
>> May 17 18:27:21 PC10 kernel: [  996.731725] Code: 00 00 00 49 8b 45 00
>> 4c 39 e8 75 17 49 8b 45 20 48 3b 44 24 18 41 c7 45 60 01 00 00 00 0f 84
>> a8 00 00 00 8b 4b 18 39 48 20 72 2d<0f>  0b 44 8b 40 24 8b 4b 0c ff c6
>> 41 8b 3e 89 70 20 41 0f af c8
>> May 17 18:27:21 PC10 kernel: [  996.731811] RIP  [<ffffffff810eab41>]
>> ____cache_alloc+0xed/0x1fa
>> May 17 18:27:21 PC10 kernel: [  996.731821]  RSP<ffff8802247dbc08>
>> May 17 18:27:21 PC10 kernel: [  996.731827] ---[ end trace
>> 0eacac80028afd2a ]---
>>
>>
>> Karsten
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

