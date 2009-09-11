Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34529 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751150AbZIKJXH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 05:23:07 -0400
Subject: Kernel OOPS in "dvb_demux_release"
From: Markus Langlotz <Markus.Langlotz@gmx.de>
Reply-To: Markus.Langlotz@gmx.de
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Sep 2009 11:23:08 +0200
Message-Id: <1252660988.6867.37.camel@Paulchen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

yesterday i tried to set up my linux DBV TV (following the description
on http://www.linuxtv.org/wiki/) and got a kernal OOPS.

My hardware: WinTV NOVA-T (USB Stick) rev.D1F4
I have running an Ubuntu 4.08 (kernel 2.6.24-24).
Current v4l build from http://linuxtv.org/hg/v4l-dvb
Firmware is dvb-usb-dib0700-1.20.fw

dmesg confirms a running firmware:

[ 2451.437786] usb 2-9.2: new high speed USB device using ehci_hcd and
address 7
[ 2451.483223] usb 2-9.2: configuration #1 chosen from 1 choice
[ 2451.483456] dvb-usb: found a 'Hauppauge Nova-T Stick' in cold state,
will try to load a firmware
[ 2451.549092] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[ 2451.645168] dib0700: firmware started successfully.
[ 2451.853933] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[ 2451.853978] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[ 2451.854807] DVB: registering new adapter (Hauppauge Nova-T Stick)
[ 2451.951183] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[ 2452.026905] DiB0070: successfully identified
[ 2452.026969] input: IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:02.1/usb2/2-9/2-9.2/input/input7
[ 2452.042118] dvb-usb: schedule remote query interval to 50 msecs.
[ 2452.042123] dvb-usb: Hauppauge Nova-T Stick successfully initialized
and connected.


Afterwards my TV client (MeTV) is able to scan several channels and
starts to play the first one found. As soon as i try to chance the
channel (to whatever i like) the client hangs and dmesg shows the
following:

[ 2542.022459] BUG: unable to handle kernel NULL pointer dereference at
virtual address 00000000
[ 2542.022465] printing eip: f8a951f3 *pde = 00000000 
[ 2542.022469] Oops: 0000 [#1] SMP 
[ 2542.022471] Modules linked in: binfmt_misc af_packet rfcomm l2cap
bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ipv6 ppdev
powernow_k8 cpufreq_userspace cpufreq_stats cpufreq_powersave
cpufreq_ondemand freq_table cpufreq_conservative video output sbs sbshc
dock container battery iptable_filter ip_tables x_tables isofs
nls_iso8859_1 nls_cp437 vfat fat ac ndiswrapper sbp2 lp usb_storage
usbhid libusual hid dvb_usb_dib0700 dib7000p dib7000m dvb_usb dvb_core
dib3000mc dibx000_common dib0070 nvidia(P) agpgart snd_hda_intel
snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
snd_timer snd_seq_device i2c_nforce2 k8temp snd button i2c_core shpchp
pci_hotplug parport_pc parport evdev soundcore pcspkr ext3 jbd mbcache
sd_mod sg sr_mod cdrom sata_nv pata_amd pata_acpi ehci_hcd ohci1394
ohci_hcd ata_generic ieee1394 usbcore forcedeth libata scsi_mod thermal
processor fan fbcon tileblit font bitblit softcursor fuse
[ 2542.022513] 
[ 2542.022515] Pid: 8068, comm: me-tv Tainted: P
(2.6.24-24-generic #1)
[ 2542.022517] EIP: 0060:[<f8a951f3>] EFLAGS: 00210217 CPU: 1
[ 2542.022527] EIP is at dvb_dmxdev_delete_pids+0x13/0x60 [dvb_core]
[ 2542.022529] EAX: 00000000 EBX: f8c850c0 ECX: 00000000 EDX: d8afa000
[ 2542.022531] ESI: fffffff8 EDI: f8c850c4 EBP: f8c850c0 ESP: d8afbf38
[ 2542.022533]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 2542.022535] Process me-tv (pid: 8068, ti=d8afa000 task=e9feab80
task.ti=d8afa000)
[ 2542.022537] Stack: f8c850c0 cc88e90c f7ae7cc0 cc88e950 f8a953ab
42b01ea1 d2ed3000 f8c85138 
[ 2542.022541]        00000008 d2ed3000 f7ae7cc0 dfbc2218 c0192e37
00000000 00000000 f7ae7cc0 
[ 2542.022545]        f7d69280 dfbc2218 d2ed3000 f70c8900 00000000
d8afa000 c018fdc9 d2ed3000 
[ 2542.022549] Call Trace:
[ 2542.022555]  [<f8a953ab>] dvb_demux_release+0x16b/0x170 [dvb_core]
[ 2542.022570]  [<c0192e37>] __fput+0xa7/0x190
[ 2542.022582]  [<c018fdc9>] filp_close+0x49/0x80
[ 2542.022588]  [<c019144e>] sys_close+0x6e/0xd0
[ 2542.022593]  [<c01043b2>] sysenter_past_esp+0x6b/0xa9
[ 2542.022609]  =======================
[ 2542.022610] Code: ff ff c7 43 04 00 00 00 00 eb c5 8d b6 00 00 00 00
8d bc 27 00 00 00 00 55 89 c5 57 56 53 8b 40 04 8d 7d 04 89 c1 8d 70 f8
39 f9 <8b> 56 08 89 f8 74 37 8d 5a f8 eb 02 89 c3 8b 41 04 8b 11 89 42 
[ 2542.022629] EIP: [<f8a951f3>] dvb_dmxdev_delete_pids+0x13/0x60
[dvb_core] SS:ESP 0068:d8afbf38
[ 2542.022639] ---[ end trace 0a443d8e9c7877f1 ]---

Afterwards i can't kill the me-tv process (stays as zombie) and a second
instance of me-tv isn't able to find a demuxer 'Oeffnen des Video
Streams gescheitert: Kein Demuxerplugin'.

Any suggestions?

        Greeting - Markus


