Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hu-out-0506.google.com ([72.14.214.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rino4tv@gmail.com>) id 1KHj0A-0006lP-8R
	for linux-dvb@linuxtv.org; Sat, 12 Jul 2008 19:35:20 +0200
Received: by hu-out-0506.google.com with SMTP id 23so2461583huc.11
	for <linux-dvb@linuxtv.org>; Sat, 12 Jul 2008 10:35:14 -0700 (PDT)
Message-ID: <45a844ef0807121035k3f7b554dn31e1a5b31ffee724@mail.gmail.com>
Date: Sat, 12 Jul 2008 19:35:13 +0200
From: "Salvatore De Astis" <rino4tv@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Pinnacle Hybrid Pro Stick 330e on Kubuntu 8.04.1 with
	kernel 2.6.24-19-generic 64bit
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0665478030=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0665478030==
Content-Type: multipart/alternative;
	boundary="----=_Part_31865_29018339.1215884114506"

------=_Part_31865_29018339.1215884114506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I have problems in the use of my 330e on my system. I have read a lot of
guides without results.
Is there somebody that can help me, please? Thanks!

My dmesg is the following:

[  131.050641] em28xx v4l2 driver version 0.0.1 loaded
[  131.051013] em28xx new video device (2304:0226): interface 0, class 255
[  131.051020] em28xx: device is attached to a USB 2.0 bus
[  131.051476] em28xx #0: Alternate settings: 8
[  131.051481] em28xx #0: Alternate setting 0, max size= 0
[  131.051485] em28xx #0: Alternate setting 1, max size= 0
[  131.051488] em28xx #0: Alternate setting 2, max size= 1448
[  131.051491] em28xx #0: Alternate setting 3, max size= 2048
[  131.051495] em28xx #0: Alternate setting 4, max size= 2304
[  131.051498] em28xx #0: Alternate setting 5, max size= 2580
[  131.051501] em28xx #0: Alternate setting 6, max size= 2892
[  131.051504] em28xx #0: Alternate setting 7, max size= 3072
[  131.489611] input: em2880/em2870 remote control as
/devices/virtual/input/input11
[  131.525471] em28xx-input.c: remote control handler attached
[  131.728272] trying to set disabled gpio? (00)
[  131.733567] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[  131.733685] attach inform (default): detected I2C address c2
[  131.740141] attach_inform: tvp5150 detected.
[  131.801856] tvp5150 3-005c: tvp5150am1 detected.
[  133.535055] successfully attached tuner
[  133.540010] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[  133.544534] analog tv open()
[  133.544540] modelock active!
[  133.547533] vbi open()
[  133.547540] modelock active!
[  133.562445] em28xx #0: V4L2 device registered as /dev/video1
[  133.562459] em28xx #0: Found Pinnacle Hybrid Pro (em2882)
[  133.562506] usbcore: registered new interface driver em28xx
[  133.618184] em28xx_audio: no version for "snd_pcm_new" found: kernel
tainted.
[  133.655241] em28xx-audio.c: probing for em28x1 non standard usbaudio
[  133.655249] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  133.655365] general protection fault: 0000 [1] SMP
[  133.655373] CPU 1
[  133.655376] Modules linked in: em28xx_audio(F) xc3028_tuner tvp5150 tuner
tea5767 tda8290 tuner_simple mt20xx tea5761 em28xx ppp_deflate zlib_deflate
bsd_comp ppp_async ppp_generic slhc ipv6 af_packet rfcomm l2cap bluetooth
ppdev acpi_cpufreq cpufreq_powersave cpufreq_stats cpufreq_userspace
cpufreq_ondemand cpufreq_conservative freq_table sbs sbshc dock
iptable_filter ip_tables x_tables ext3 jbd mbcache aes_x86_64 dm_crypt
dm_mod sbp2 parport_pc lp parport arc4 ecb blkcipher joydev pcmcia gspca
compat_ioctl32 videodev v4l2_common v4l1_compat usbhid hid cdc_acm
snd_hda_intel snd_pcm_oss evdev snd_mixer_oss snd_pcm snd_page_alloc
snd_hwdep nvidia(P) snd_seq_dummy iwl3945 iwlwifi_mac80211 cfg80211 i2c_core
snd_seq_oss battery snd_seq_midi container acer_acpi led_class psmouse video
output snd_rawmidi snd_seq_midi_event sdhci ac serio_raw snd_seq mmc_core
yenta_socket rsrc_nonstatic pcmcia_core wmi_acer snd_timer snd_seq_device
irda button crc_ccitt snd intel_agp iTCO_wdt iTCO_vendor_support pcspkr
shpchp soundcore pci_hotplug reiserfs sg sr_mod sd_mod cdrom ata_piix
ata_generic pata_acpi libata scsi_mod ehci_hcd ohci1394 ieee1394 uhci_hcd
tg3 usbcore thermal processor fan fbcon tileblit font bitblit softcursor
fuse
[  133.655559] Pid: 6297, comm: modprobe Tainted: PF       2.6.24-19-generic
#1
[  133.655564] RIP: 0010:[<ffffffff88bafbec>]  [<ffffffff88bafbec>]
:snd_pcm:snd_pcm_timer_init+0x2c/0x1a0
[  133.655588] RSP: 0018:ffff810054c05cd8  EFLAGS: 00010202
[  133.655592] RAX: 0000000000000000 RBX: ffff810054c1d000 RCX:
ffff810054c05cf0
[  133.655596] RDX: 0000000000000001 RSI: ffffffff88bb1648 RDI:
2320787838326d65
[  133.655600] RBP: ffff81005a31aa00 R08: 0000000000000000 R09:
ffff810054cc7d88
[  133.655605] R10: 0000000000000000 R11: ffffffff803bc920 R12:
0000000000000018
[  133.655609] R13: ffff81005a31aa58 R14: 0000000000000001 R15:
ffffffff88bb0e48
[  133.655614] FS:  00007f654aa766e0(0000) GS:ffff81007dc01700(0000)
knlGS:0000000000000000
[  133.655619] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  133.655623] CR2: 00007ff60f23b000 CR3: 000000005a160000 CR4:
00000000000006e0
[  133.655626] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  133.655630] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  133.655634] Process modprobe (pid: 6297, threadinfo ffff810054c04000,
task ffff81005a1ce7e0)
[  133.655638] Stack:  0000000000000003 0000000000000000 ffff81005a31aa00
0000000000000018
[  133.655647]  ffff810054c1d000 ffffffff88ba67dd ffff81005a1c3400
ffffffff802f8748
[  133.655653]  63304431436d6370 ffff81005a31aa00 0000000100000001
ffff810060521800
[  133.655660] Call Trace:
[  133.655685]  [<ffffffff88ba67dd>]
:snd_pcm:snd_pcm_dev_register+0xfd/0x220
[  133.655698]  [<ffffffff802f8748>] create_proc_entry+0x58/0xa0
[  133.655737]  [<ffffffff881cdc9f>] :snd:snd_device_register_all+0x2f/0x60
[  133.655760]  [<ffffffff881c8b8b>] :snd:snd_card_register+0x3b/0x390
[  133.655778]  [<ffffffff88ba69e3>] :snd_pcm:snd_pcm_new+0xe3/0x140
[  133.655799]  [<ffffffff88efa200>]
:em28xx_audio:em28xx_audio_init+0x170/0x1d0
[  133.655826]  [<ffffffff88e88218>]
:em28xx:em28xx_register_extension+0x88/0xd0
[  133.655845]  [<ffffffff80263c5e>] sys_init_module+0x18e/0x1a90
[  133.655927]  [<ffffffff8020c37e>] system_call+0x7e/0x83
[  133.655958]
[  133.655960]
[  133.655961] Code: 48 8b 07 8b 00 89 44 24 08 8b 47 18 89 44 24 0c 8b 43
18 01
[  133.655988] RIP  [<ffffffff88bafbec>]
:snd_pcm:snd_pcm_timer_init+0x2c/0x1a0
[  133.656005]  RSP <ffff810054c05cd8>
[  133.656010] ---[ end trace fc06ff5acec61c23 ]---
[  133.697568] em28xx_dvb: Unknown symbol dvb_dmxdev_init
[  133.697778] em28xx_dvb: Unknown symbol dvb_register_adapter
[  133.697946] em28xx_dvb: Unknown symbol dvb_dmx_release
[  133.698181] em28xx_dvb: Unknown symbol dvb_net_init
[  133.698247] em28xx_dvb: Unknown symbol dvb_dmx_swfilter
[  133.698324] em28xx_dvb: Unknown symbol dvb_dmxdev_release
[  133.698389] em28xx_dvb: Unknown symbol dvb_frontend_detach
[  133.698453] em28xx_dvb: Unknown symbol dvb_net_release
[  133.698577] em28xx_dvb: Unknown symbol dvb_unregister_frontend
[  133.698756] em28xx_dvb: Unknown symbol dvb_register_frontend
[  133.698820] em28xx_dvb: Unknown symbol dvb_unregister_adapter
[  133.698884] em28xx_dvb: Unknown symbol dvb_dmx_init

------=_Part_31865_29018339.1215884114506
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,<br>I have problems in the use of my 330e on my system. I have read a lo=
t of guides without results.<br>Is there somebody that can help me, please?=
 Thanks!<br><br>My dmesg is the following:<br><br>[&nbsp; 131.050641] em28x=
x v4l2 driver version 0.0.1 loaded<br>
[&nbsp; 131.051013] em28xx new video device (2304:0226): interface 0, class=
 255<br>[&nbsp; 131.051020] em28xx: device is attached to a USB 2.0 bus<br>=
[&nbsp; 131.051476] em28xx #0: Alternate settings: 8<br>[&nbsp; 131.051481]=
 em28xx #0: Alternate setting 0, max size=3D 0<br>
[&nbsp; 131.051485] em28xx #0: Alternate setting 1, max size=3D 0<br>[&nbsp=
; 131.051488] em28xx #0: Alternate setting 2, max size=3D 1448<br>[&nbsp; 1=
31.051491] em28xx #0: Alternate setting 3, max size=3D 2048<br>[&nbsp; 131.=
051495] em28xx #0: Alternate setting 4, max size=3D 2304<br>
[&nbsp; 131.051498] em28xx #0: Alternate setting 5, max size=3D 2580<br>[&n=
bsp; 131.051501] em28xx #0: Alternate setting 6, max size=3D 2892<br>[&nbsp=
; 131.051504] em28xx #0: Alternate setting 7, max size=3D 3072<br>[&nbsp; 1=
31.489611] input: em2880/em2870 remote control as /devices/virtual/input/in=
put11<br>
[&nbsp; 131.525471] em28xx-input.c: remote control handler attached<br>[&nb=
sp; 131.728272] trying to set disabled gpio? (00)<br>[&nbsp; 131.733567] tu=
ner 3-0061: chip found @ 0xc2 (em28xx #0)<br>[&nbsp; 131.733685] attach inf=
orm (default): detected I2C address c2<br>
[&nbsp; 131.740141] attach_inform: tvp5150 detected.<br>[&nbsp; 131.801856]=
 tvp5150 3-005c: tvp5150am1 detected.<br>[&nbsp; 133.535055] successfully a=
ttached tuner<br>[&nbsp; 133.540010] em28xx #0: V4L2 VBI device registered =
as /dev/vbi0<br>
[&nbsp; 133.544534] analog tv open()<br>[&nbsp; 133.544540] modelock active=
!<br>[&nbsp; 133.547533] vbi open()<br>[&nbsp; 133.547540] modelock active!=
<br>[&nbsp; 133.562445] em28xx #0: V4L2 device registered as /dev/video1<br=
>[&nbsp; 133.562459] em28xx #0: Found Pinnacle Hybrid Pro (em2882)<br>
[&nbsp; 133.562506] usbcore: registered new interface driver em28xx<br>[&nb=
sp; 133.618184] em28xx_audio: no version for &quot;snd_pcm_new&quot; found:=
 kernel tainted.<br>[&nbsp; 133.655241] em28xx-audio.c: probing for em28x1 =
non standard usbaudio<br>
[&nbsp; 133.655249] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger<br=
>[&nbsp; 133.655365] general protection fault: 0000 [1] SMP<br>[&nbsp; 133.=
655373] CPU 1<br>[&nbsp; 133.655376] Modules linked in: em28xx_audio(F) xc3=
028_tuner tvp5150 tuner tea5767 tda8290 tuner_simple mt20xx tea5761 em28xx =
ppp_deflate zlib_deflate bsd_comp ppp_async ppp_generic slhc ipv6 af_packet=
 rfcomm l2cap bluetooth ppdev acpi_cpufreq cpufreq_powersave cpufreq_stats =
cpufreq_userspace cpufreq_ondemand cpufreq_conservative freq_table sbs sbsh=
c dock iptable_filter ip_tables x_tables ext3 jbd mbcache aes_x86_64 dm_cry=
pt dm_mod sbp2 parport_pc lp parport arc4 ecb blkcipher joydev pcmcia gspca=
 compat_ioctl32 videodev v4l2_common v4l1_compat usbhid hid cdc_acm snd_hda=
_intel snd_pcm_oss evdev snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep nvi=
dia(P) snd_seq_dummy iwl3945 iwlwifi_mac80211 cfg80211 i2c_core snd_seq_oss=
 battery snd_seq_midi container acer_acpi led_class psmouse video output sn=
d_rawmidi snd_seq_midi_event sdhci ac serio_raw snd_seq mmc_core yenta_sock=
et rsrc_nonstatic pcmcia_core wmi_acer snd_timer snd_seq_device irda button=
 crc_ccitt snd intel_agp iTCO_wdt iTCO_vendor_support pcspkr shpchp soundco=
re pci_hotplug reiserfs sg sr_mod sd_mod cdrom ata_piix ata_generic pata_ac=
pi libata scsi_mod ehci_hcd ohci1394 ieee1394 uhci_hcd tg3 usbcore thermal =
processor fan fbcon tileblit font bitblit softcursor fuse<br>
[&nbsp; 133.655559] Pid: 6297, comm: modprobe Tainted: PF&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; 2.6.24-19-generic #1<br>[&nbsp; 133.655564] RIP: 0010:[&=
lt;ffffffff88bafbec&gt;]&nbsp; [&lt;ffffffff88bafbec&gt;] :snd_pcm:snd_pcm_=
timer_init+0x2c/0x1a0<br>[&nbsp; 133.655588] RSP: 0018:ffff810054c05cd8&nbs=
p; EFLAGS: 00010202<br>
[&nbsp; 133.655592] RAX: 0000000000000000 RBX: ffff810054c1d000 RCX: ffff81=
0054c05cf0<br>[&nbsp; 133.655596] RDX: 0000000000000001 RSI: ffffffff88bb16=
48 RDI: 2320787838326d65<br>[&nbsp; 133.655600] RBP: ffff81005a31aa00 R08: =
0000000000000000 R09: ffff810054cc7d88<br>
[&nbsp; 133.655605] R10: 0000000000000000 R11: ffffffff803bc920 R12: 000000=
0000000018<br>[&nbsp; 133.655609] R13: ffff81005a31aa58 R14: 00000000000000=
01 R15: ffffffff88bb0e48<br>[&nbsp; 133.655614] FS:&nbsp; 00007f654aa766e0(=
0000) GS:ffff81007dc01700(0000) knlGS:0000000000000000<br>
[&nbsp; 133.655619] CS:&nbsp; 0010 DS: 0000 ES: 0000 CR0: 000000008005003b<=
br>[&nbsp; 133.655623] CR2: 00007ff60f23b000 CR3: 000000005a160000 CR4: 000=
00000000006e0<br>[&nbsp; 133.655626] DR0: 0000000000000000 DR1: 00000000000=
00000 DR2: 0000000000000000<br>
[&nbsp; 133.655630] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000=
0000000400<br>[&nbsp; 133.655634] Process modprobe (pid: 6297, threadinfo f=
fff810054c04000, task ffff81005a1ce7e0)<br>[&nbsp; 133.655638] Stack:&nbsp;=
 0000000000000003 0000000000000000 ffff81005a31aa00 0000000000000018<br>
[&nbsp; 133.655647]&nbsp; ffff810054c1d000 ffffffff88ba67dd ffff81005a1c340=
0 ffffffff802f8748<br>[&nbsp; 133.655653]&nbsp; 63304431436d6370 ffff81005a=
31aa00 0000000100000001 ffff810060521800<br>[&nbsp; 133.655660] Call Trace:=
<br>[&nbsp; 133.655685]&nbsp; [&lt;ffffffff88ba67dd&gt;] :snd_pcm:snd_pcm_d=
ev_register+0xfd/0x220<br>
[&nbsp; 133.655698]&nbsp; [&lt;ffffffff802f8748&gt;] create_proc_entry+0x58=
/0xa0<br>[&nbsp; 133.655737]&nbsp; [&lt;ffffffff881cdc9f&gt;] :snd:snd_devi=
ce_register_all+0x2f/0x60<br>[&nbsp; 133.655760]&nbsp; [&lt;ffffffff881c8b8=
b&gt;] :snd:snd_card_register+0x3b/0x390<br>
[&nbsp; 133.655778]&nbsp; [&lt;ffffffff88ba69e3&gt;] :snd_pcm:snd_pcm_new+0=
xe3/0x140<br>[&nbsp; 133.655799]&nbsp; [&lt;ffffffff88efa200&gt;] :em28xx_a=
udio:em28xx_audio_init+0x170/0x1d0<br>[&nbsp; 133.655826]&nbsp; [&lt;ffffff=
ff88e88218&gt;] :em28xx:em28xx_register_extension+0x88/0xd0<br>
[&nbsp; 133.655845]&nbsp; [&lt;ffffffff80263c5e&gt;] sys_init_module+0x18e/=
0x1a90<br>[&nbsp; 133.655927]&nbsp; [&lt;ffffffff8020c37e&gt;] system_call+=
0x7e/0x83<br>[&nbsp; 133.655958]<br>[&nbsp; 133.655960]<br>[&nbsp; 133.6559=
61] Code: 48 8b 07 8b 00 89 44 24 08 8b 47 18 89 44 24 0c 8b 43 18 01<br>
[&nbsp; 133.655988] RIP&nbsp; [&lt;ffffffff88bafbec&gt;] :snd_pcm:snd_pcm_t=
imer_init+0x2c/0x1a0<br>[&nbsp; 133.656005]&nbsp; RSP &lt;ffff810054c05cd8&=
gt;<br>[&nbsp; 133.656010] ---[ end trace fc06ff5acec61c23 ]---<br>[&nbsp; =
133.697568] em28xx_dvb: Unknown symbol dvb_dmxdev_init<br>
[&nbsp; 133.697778] em28xx_dvb: Unknown symbol dvb_register_adapter<br>[&nb=
sp; 133.697946] em28xx_dvb: Unknown symbol dvb_dmx_release<br>[&nbsp; 133.6=
98181] em28xx_dvb: Unknown symbol dvb_net_init<br>[&nbsp; 133.698247] em28x=
x_dvb: Unknown symbol dvb_dmx_swfilter<br>
[&nbsp; 133.698324] em28xx_dvb: Unknown symbol dvb_dmxdev_release<br>[&nbsp=
; 133.698389] em28xx_dvb: Unknown symbol dvb_frontend_detach<br>[&nbsp; 133=
.698453] em28xx_dvb: Unknown symbol dvb_net_release<br>[&nbsp; 133.698577] =
em28xx_dvb: Unknown symbol dvb_unregister_frontend<br>
[&nbsp; 133.698756] em28xx_dvb: Unknown symbol dvb_register_frontend<br>[&n=
bsp; 133.698820] em28xx_dvb: Unknown symbol dvb_unregister_adapter<br>[&nbs=
p; 133.698884] em28xx_dvb: Unknown symbol dvb_dmx_init<br><br>

------=_Part_31865_29018339.1215884114506--


--===============0665478030==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0665478030==--
