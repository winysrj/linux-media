Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57943 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbBWWzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 17:55:49 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so21174551wiv.2
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2015 14:55:48 -0800 (PST)
Message-ID: <54EBAFB8.9010105@gmail.com>
Date: Mon, 23 Feb 2015 23:54:48 +0100
From: Gilles Risch <gilles.risch@gmail.com>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Subject: Re: Linux TV support Elgato EyeTV hybrid
References: <CALnjqVkteEsFGQXRdh3exzGrqdC=Qw4guSGRT_pCF50WjGqy1g@mail.gmail.com> <CAAZRmGwmNhczjXNXdKkotS0YZ8Tc+kKb4b+SyNN_8KVj2H8xuQ@mail.gmail.com> <54E9DDFE.4010507@gmail.com> <54EA3633.3030805@southpole.se> <54EA4A3B.9060000@iki.fi> <54EB8C86.3040700@gmail.com> <54EB8F38.9080806@southpole.se>
In-Reply-To: <54EB8F38.9080806@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/23/2015 09:36 PM, Benjamin Larsson wrote:
> On 02/23/2015 09:24 PM, Gilles Risch wrote:
>> On 02/22/2015 10:29 PM, Antti Palosaari wrote:
>>> On 02/22/2015 10:04 PM, Benjamin Larsson wrote:
>>>> On 02/22/2015 02:47 PM, Gilles Risch wrote:
> [...]
Not sure if it helps, but I also tried:
     $ modprobe em28xx card=82
     $ modprobe xc5000
     $ echo 0fd9 0018 > /sys/bus/usb/drivers/em28xx/new_id
     $ dmesg
[  142.728289] usb 8-6: new high-speed USB device number 3 using ehci_hcd
[  142.862556] usb 8-6: New USB device found, idVendor=0fd9, idProduct=0018
[  142.862565] usb 8-6: New USB device strings: Mfr=3, Product=1, 
SerialNumber=2
[  142.862571] usb 8-6: Product: EyeTV Hybrid
[  142.862576] usb 8-6: Manufacturer: Elgato
[  142.862581] usb 8-6: SerialNumber: 100904010917
[  142.863146] em28xx: New device Elgato EyeTV Hybrid @ 480 Mbps 
(0fd9:0018, interface 0, class 0)
[  142.863153] em28xx: Audio interface 0 found (Vendor Class)
[  142.863159] em28xx: Video interface 0 found: isoc
[  142.863163] em28xx: DVB interface 0 found: isoc
[  142.863993] em28xx: chip ID is em2884
[  142.927681] em2884 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x1a01bca5
[  142.927688] em2884 #0: EEPROM info:
[  142.927694] em2884 #0:     microcode start address = 0x0004, boot 
configuration = 0x01
[  142.935299] em2884 #0:     I2S audio, 5 sample rates
[  142.935306] em2884 #0:     500mA max power
[  142.935312] em2884 #0:     Table at offset 0x27, strings=0x1a78, 
0x1a92, 0x0e6a
[  142.935466] em2884 #0: Identified as Terratec Cinergy HTC Stick (card=82)
[  142.935474] em2884 #0: analog set to isoc mode.
[  142.935478] em2884 #0: dvb set to isoc mode.
[  142.975149] em2884 #0: Binding audio extension
[  142.975152] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  142.975153] em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho Chehab
[  142.975180] em2884 #0: Endpoint 0x83 high-speed on intf 0 alt 7 
interval = 8, size 196
[  142.975184] em2884 #0: Number of URBs: 1, with 64 packets and 192 size
[  142.975537] em2884 #0: Audio extension successfully initialized
[  142.975540] em28xx: Registered (Em28xx Audio Extension) extension
[  143.003553] WARNING: You are using an experimental version of the 
media stack.
[  143.003554]     As the driver is backported to an older kernel, it 
doesn't offer
[  143.003555]     enough quality for its usage in production.
[  143.003556]     Use it with care.
[  143.003556] Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
[  143.003557]     135f9be9194cf7778eb73594aa55791b229cf27c [media] 
dvb_frontend: start media pipeline while thread is running
[  143.003558]     0f0fa90bd035fa15106799b813d4f0315d99f47e [media] 
cx231xx: enable tuner->decoder link at videobuf start
[  143.003560]     9239effd53d47e3cd9c653830c8465c0a3a427dc [media] 
dvb-frontend: enable tuner link when the FE thread starts
[  143.010977] em2884 #0: Binding DVB extension
[  143.567751] usb 8-6: firmware: agent loaded 
dvb-usb-terratec-htc-stick-drxk.fw into memory
[  143.585103] drxk: status = 0x639260d9
[  143.585113] drxk: detected a drx-3926k, spin A3, xtal 20.250 MHz
[  147.656822] drxk: DRXK driver version 0.9.4300
[  147.695203] drxk: frontend initialized.
[  147.764493] tda18271 11-0060: creating new instance
[  147.766552] TDA18271HD/C2 detected @ 11-0060
[  147.997562] DVB: registering new adapter (em2884 #0)
[  147.997571] usb 8-6: DVB: registering adapter 0 frontend 0 (DRXK 
DVB-C DVB-T)...
[  147.998567] em2884 #0: DVB extension successfully initialized
[  147.998571] em28xx: Registered (Em28xx dvb Extension) extension
[  148.023086] WARNING: You are using an experimental version of the 
media stack.
[  148.023087]     As the driver is backported to an older kernel, it 
doesn't offer
[  148.023088]     enough quality for its usage in production.
[  148.023089]     Use it with care.
[  148.023089] Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
[  148.023090]     135f9be9194cf7778eb73594aa55791b229cf27c [media] 
dvb_frontend: start media pipeline while thread is running
[  148.023091]     0f0fa90bd035fa15106799b813d4f0315d99f47e [media] 
cx231xx: enable tuner->decoder link at videobuf start
[  148.023092]     9239effd53d47e3cd9c653830c8465c0a3a427dc [media] 
dvb-frontend: enable tuner link when the FE thread starts
[  148.034348] em2884 #0: Registering input extension
[  148.064107] Registered IR keymap rc-nec-terratec-cinergy-xs
[  148.064420] input: em28xx IR (em2884 #0) as 
/devices/pci0000:00/0000:00:1d.7/usb8/8-6/rc/rc0/input11
[  148.064808] rc0: em28xx IR (em2884 #0) as 
/devices/pci0000:00/0000:00:1d.7/usb8/8-6/rc/rc0
[  148.065325] em2884 #0: Input extension successfully initalized
[  148.065333] em28xx: Registered (Em28xx Input Extension) extension

The dmesg shows that a TDA18271HD/C2 tuner has been detected.

A w_scan produced a kernel Oops:
[  193.580994] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000010
[  193.581054] IP: [<ffffffffa05a9289>] 
media_entity_pipeline_start+0x30/0x2d2 [media]
[  193.581101] PGD 576ea067 PUD 576de067 PMD 0
[  193.581131] Oops: 0000 [#1] SMP
[  193.581155] CPU 0
[  193.581167] Modules linked in: rc_nec_terratec_cinergy_xs(O) 
em28xx_rc(O) rc_core(O) tda18271(O) drxk(O) em28xx_dvb(O) dvb_core(O) 
em28xx_alsa(O) xc5000(O) em28xx(O) tveeprom(O) v4l2_common(O) 
videodev(O) media(O) cryptd aes_x86_64 aes_generic ppdev lp bnep rfcomm 
bluetooth pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) 
binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc 
loop tpm_infineon snd_hda_codec_analog arc4 iwlwifi joydev mac80211 i915 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc cfg80211 
drm_kms_helper snd_seq snd_seq_device drm snd_timer hp_wmi sparse_keymap 
i2c_algo_bit i2c_core snd rfkill hp_accel lis3lv02d acpi_cpufreq 
soundcore input_polldev evdev battery parport_pc parport video ac 
psmouse mperf serio_raw pcspkr iTCO_wdt iTCO_vendor_support wmi 
processor tpm_tis tpm tpm_bios power_supply button container coretemp 
ext4 crc16 jbd2 mbcache usb_storage sg sd_mod sr_mod cdrom crc_t10dif 
firewire_ohci firewire_core crc_itu_t ahci libahci tg3 libphy libata 
scsi_mod uhci_hcd fan thermal thermal_sys ehci_hcd usbcore usb_common 
[last unloaded: scsi_wait_scan]
[  193.581911]
[  193.581922] Pid: 4106, comm: kdvb-ad-0-fe-0 Tainted: G O 
3.2.0-4-amd64 #1 Debian 3.2.65-1+deb7u1 Hewlett-Packard HP Compaq 6730b 
(GW687AV)/30DD
[  193.581998] RIP: 0010:[<ffffffffa05a9289>] [<ffffffffa05a9289>] 
media_entity_pipeline_start+0x30/0x2d2 [media]
[  193.582053] RSP: 0018:ffff880053809ce0  EFLAGS: 00010246
[  193.582082] RAX: 0000000000000000 RBX: ffff880053809d18 RCX: 
0000002d12531e61
[  193.582119] RDX: 0000000000000000 RSI: ffff880075b2825c RDI: 
0000000000000000
[  193.582155] RBP: ffff880053809e60 R08: ffff880053808000 R09: 
0000000000000001
[  193.582191] R10: 0000000000000046 R11: ffffffff81600000 R12: 
ffffffffa06102cb
[  193.582228] R13: 0000000000000000 R14: 0000000000000000 R15: 
ffff880075b2825c
[  193.582265] FS:  0000000000000000(0000) GS:ffff88007b600000(0000) 
knlGS:0000000000000000
[  193.582306] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  193.582336] CR2: 0000000000000010 CR3: 000000005776f000 CR4: 
00000000000406f0
[  193.583407] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  193.584435] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  193.584969] Process kdvb-ad-0-fe-0 (pid: 4106, threadinfo 
ffff880053808000, task ffff8800577cc040)
[  193.584969] Stack:
[  193.584969]  0000000000000000 0000000000000000 0000000000000000 
0000000000000000
[  193.584969]  0000000000000000 0000000000000000 0000000000000000 
0000000000000000
[  193.584969]  0000000000000000 0000000000000000 0000000000000001 
0000000000000000
[  193.584969] Call Trace:
[  193.584969]  [<ffffffff8104186e>] ? load_balance+0x85/0x629
[  193.584969]  [<ffffffff810139e1>] ? paravirt_read_tsc+0x5/0x8
[  193.584969]  [<ffffffff8100d02f>] ? load_TLS+0x7/0xa
[  193.584969]  [<ffffffff8100d66c>] ? __switch_to+0x101/0x265
[  193.584969]  [<ffffffffa06102cb>] ? 
dvb_frontend_reinitialise+0x1d/0x1d [dvb_core]
[  193.584969]  [<ffffffffa061047a>] ? dvb_frontend_thread+0x1af/0x60f 
[dvb_core]
[  193.584969]  [<ffffffff8134fa19>] ? __schedule+0x5f9/0x610
[  193.584969]  [<ffffffffa06102cb>] ? 
dvb_frontend_reinitialise+0x1d/0x1d [dvb_core]
[  193.584969]  [<ffffffff8105f791>] ? kthread+0x76/0x7e
[  193.584969]  [<ffffffff81358034>] ? kernel_thread_helper+0x4/0x10
[  193.584969]  [<ffffffff8105f71b>] ? kthread_worker_fn+0x139/0x139
[  193.584969]  [<ffffffff81358030>] ? gs_change+0x13/0x13
[  193.584969] Code: 57 49 89 f7 41 56 49 89 fe 41 55 41 54 53 48 8d 9d 
b8 fe ff ff 48 81 ec 58 01 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 c8 
31 c0 <48> 8b 47 10 48 05 a8 03 00 00 48 89 c7 48 89 85 a0 fe ff ff e8
[  193.584969] RIP  [<ffffffffa05a9289>] 
media_entity_pipeline_start+0x30/0x2d2 [media]
[  193.584969]  RSP <ffff880053809ce0>
[  193.584969] CR2: 0000000000000010
[  193.618528] ---[ end trace 2ced670cbbf01c41 ]---
[  205.758123] em2884 #0: submit of audio urb failed (error=-90)
[  222.737368] usb 8-6: USB disconnect, device number 3
[  222.737556] em2884 #0: Disconnecting em2884 #0
[  222.737565] em2884 #0: Closing audio extension
[  222.743949] em2884 #0: Closing DVB extension
[  222.745029] ------------[ cut here ]------------
[  222.745045] WARNING: at 
/build/linux-p4iNsg/linux-3.2.65/kernel/fork.c:190 
__put_task_struct+0x20/0xb9()
[  222.745052] Hardware name: HP Compaq 6730b (GW687AV)
[  222.745057] Modules linked in: rc_nec_terratec_cinergy_xs(O) 
em28xx_rc(O) rc_core(O) tda18271(O) drxk(O) em28xx_dvb(O) dvb_core(O) 
em28xx_alsa(O) xc5000(O) em28xx(O) tveeprom(O) v4l2_common(O) 
videodev(O) media(O) cryptd aes_x86_64 aes_generic ppdev lp bnep rfcomm 
bluetooth pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) 
binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc 
loop tpm_infineon snd_hda_codec_analog arc4 iwlwifi joydev mac80211 i915 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc cfg80211 
drm_kms_helper snd_seq snd_seq_device drm snd_timer hp_wmi sparse_keymap 
i2c_algo_bit i2c_core snd rfkill hp_accel lis3lv02d acpi_cpufreq 
soundcore input_polldev evdev battery parport_pc parport video ac 
psmouse mperf serio_raw pcspkr iTCO_wdt iTCO_vendor_support wmi 
processor tpm_tis tpm tpm_bios power_supply button container coretemp 
ext4 crc16 jbd2 mbcache usb_storage sg sd_mod sr_mod cdrom crc_t10dif 
firewire_ohci firewire_core crc_itu_t ahci libahci tg3 libphy libata 
scsi_mod uhci_hcd fan thermal thermal_sys ehci_hcd usbcore usb_common 
[last unloaded: scsi_wait_scan]
[  222.745293] Pid: 122, comm: khubd Tainted: G      D    O 
3.2.0-4-amd64 #1 Debian 3.2.65-1+deb7u1
[  222.745299] Call Trace:
[  222.745311]  [<ffffffff81046d61>] ? warn_slowpath_common+0x78/0x8c
[  222.745321]  [<ffffffff810448f4>] ? __put_task_struct+0x20/0xb9
[  222.745332]  [<ffffffff8105f810>] ? kthread_stop+0x77/0xa5
[  222.745343]  [<ffffffff811adbb4>] ? add_uevent_var+0xdc/0xdc
[  222.745358]  [<ffffffffa060f477>] ? dvb_frontend_stop+0x35/0x9e 
[dvb_core]
[  222.745366]  [<ffffffff811adbb4>] ? add_uevent_var+0xdc/0xdc
[  222.745379]  [<ffffffffa060f504>] ? dvb_unregister_frontend+0x24/0xd2 
[dvb_core]
[  222.745390]  [<ffffffffa062855b>] ? em28xx_dvb_fini+0x15a/0x1be 
[em28xx_dvb]
[  222.745400]  [<ffffffff810ec482>] ? kfree+0x5b/0x6c
[  222.745409]  [<ffffffffa0628571>] ? em28xx_dvb_fini+0x170/0x1be 
[em28xx_dvb]
[  222.745421]  [<ffffffffa05e6582>] ? em28xx_close_extension+0x29/0x7c 
[em28xx]
[  222.745432]  [<ffffffffa05e7a0b>] ? em28xx_usb_disconnect+0x54/0x73 
[em28xx]
[  222.745461]  [<ffffffffa001148a>] ? usb_unbind_interface+0x4d/0x111 
[usbcore]
[  222.745478]  [<ffffffff812530cf>] ? __device_release_driver+0x7d/0xc9
[  222.745486]  [<ffffffff81253136>] ? device_release_driver+0x1b/0x27
[  222.745495]  [<ffffffff81252d30>] ? bus_remove_device+0xd2/0xe7
[  222.745504]  [<ffffffff81250884>] ? device_del+0x11a/0x168
[  222.745528]  [<ffffffffa000f9f5>] ? usb_disable_device+0x6b/0x175 
[usbcore]
[  222.745551]  [<ffffffffa0009915>] ? usb_disconnect+0x6f/0xd0 [usbcore]
[  222.745574]  [<ffffffffa000b08c>] ? hub_thread+0x574/0xec3 [usbcore]
[  222.745583]  [<ffffffff810380cd>] ? set_next_entity+0x32/0x55
[  222.745593]  [<ffffffff8105fde3>] ? add_wait_queue+0x3c/0x3c
[  222.745616]  [<ffffffffa000ab18>] ? usb_remote_wakeup+0x2f/0x2f [usbcore]
[  222.745626]  [<ffffffff8105f791>] ? kthread+0x76/0x7e
[  222.745636]  [<ffffffff81358034>] ? kernel_thread_helper+0x4/0x10
[  222.745645]  [<ffffffff8105f71b>] ? kthread_worker_fn+0x139/0x139
[  222.745653]  [<ffffffff81358030>] ? gs_change+0x13/0x13
[  222.745659] ---[ end trace 2ced670cbbf01c42 ]---
[  222.745677] BUG: unable to handle kernel NULL pointer dereference 
at           (null)
[  222.747977] IP: [<ffffffff810645e6>] exit_creds+0x12/0x5a
[  222.748012] PGD 75faa067 PUD 36f79067 PMD 0
[  222.748012] Oops: 0000 [#2] SMP
[  222.748012] CPU 1
[  222.748012] Modules linked in: rc_nec_terratec_cinergy_xs(O) 
em28xx_rc(O) rc_core(O) tda18271(O) drxk(O) em28xx_dvb(O) dvb_core(O) 
em28xx_alsa(O) xc5000(O) em28xx(O) tveeprom(O) v4l2_common(O) 
videodev(O) media(O) cryptd aes_x86_64 aes_generic ppdev lp bnep rfcomm 
bluetooth pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) 
binfmt_misc uinput nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc 
loop tpm_infineon snd_hda_codec_analog arc4 iwlwifi joydev mac80211 i915 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc cfg80211 
drm_kms_helper snd_seq snd_seq_device drm snd_timer hp_wmi sparse_keymap 
i2c_algo_bit i2c_core snd rfkill hp_accel lis3lv02d acpi_cpufreq 
soundcore input_polldev evdev battery parport_pc parport video ac 
psmouse mperf serio_raw pcspkr iTCO_wdt iTCO_vendor_support wmi 
processor tpm_tis tpm tpm_bios power_supply button container coretemp 
ext4 crc16 jbd2 mbcache usb_storage sg sd_mod sr_mod cdrom crc_t10dif 
firewire_ohci firewire_core crc_itu_t ahci libahci tg3 libphy libata 
scsi_mod uhci_hcd fan thermal thermal_sys ehci_hcd usbcore usb_common 
[last unloaded: scsi_wait_scan]
[  222.748012]
[  222.748012] Pid: 122, comm: khubd Tainted: G      D W  O 
3.2.0-4-amd64 #1 Debian 3.2.65-1+deb7u1 Hewlett-Packard HP Compaq 6730b 
(GW687AV)/30DD
[  222.748012] RIP: 0010:[<ffffffff810645e6>] [<ffffffff810645e6>] 
exit_creds+0x12/0x5a
[  222.748012] RSP: 0018:ffff880036c91bb0  EFLAGS: 00010283
[  222.748012] RAX: 0000000000000000 RBX: ffff8800577cc040 RCX: 
0000000000001f70
[  222.748012] RDX: 0000000000000000 RSI: 0000000000000046 RDI: 
0000000000000000
[  222.748012] RBP: 0000000000000000 R08: 0000000000000002 R09: 
00000000fffffffe
[  222.748012] R10: 0000000000000000 R11: 0000000000000002 R12: 
ffff8800773b80c0
[  222.748012] R13: ffffffffa05f3e28 R14: 0000000000000000 R15: 
ffff880036e5e800
[  222.748012] FS:  0000000000000000(0000) GS:ffff88007b680000(0000) 
knlGS:0000000000000000
[  222.748012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  222.748012] CR2: 0000000000000000 CR3: 0000000075002000 CR4: 
00000000000406e0
[  222.748012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  222.748012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  222.748012] Process khubd (pid: 122, threadinfo ffff880036c90000, 
task ffff880075b57800)
[  222.748012] Stack:
[  222.748012]  ffff8800577cc040 ffffffff81044933 0000000000000000 
ffff8800577cc040
[  222.748012]  0000000000000000 ffffffff8105f810 ffffffff811adbb4 
ffff880075b28000
[  222.748012]  ffff880057498000 ffffffffa060f477 ffffffff811adbb4 
ffff880075b28000
[  222.748012] Call Trace:
[  222.748012]  [<ffffffff81044933>] ? __put_task_struct+0x5f/0xb9
[  222.748012]  [<ffffffff8105f810>] ? kthread_stop+0x77/0xa5
[  222.748012]  [<ffffffff811adbb4>] ? add_uevent_var+0xdc/0xdc
[  222.748012]  [<ffffffffa060f477>] ? dvb_frontend_stop+0x35/0x9e 
[dvb_core]
[  222.859262]  [<ffffffff811adbb4>] ? add_uevent_var+0xdc/0xdc
[  222.859262]  [<ffffffffa060f504>] ? dvb_unregister_frontend+0x24/0xd2 
[dvb_core]
[  222.859262]  [<ffffffffa062855b>] ? em28xx_dvb_fini+0x15a/0x1be 
[em28xx_dvb]
[  222.859262]  [<ffffffff810ec482>] ? kfree+0x5b/0x6c
[  222.859262]  [<ffffffffa0628571>] ? em28xx_dvb_fini+0x170/0x1be 
[em28xx_dvb]
[  222.859262]  [<ffffffffa05e6582>] ? em28xx_close_extension+0x29/0x7c 
[em28xx]
[  222.859262]  [<ffffffffa05e7a0b>] ? em28xx_usb_disconnect+0x54/0x73 
[em28xx]
[  222.859262]  [<ffffffffa001148a>] ? usb_unbind_interface+0x4d/0x111 
[usbcore]
[  222.859262]  [<ffffffff812530cf>] ? __device_release_driver+0x7d/0xc9
[  222.859262]  [<ffffffff81253136>] ? device_release_driver+0x1b/0x27
[  222.859262]  [<ffffffff81252d30>] ? bus_remove_device+0xd2/0xe7
[  222.859262]  [<ffffffff81250884>] ? device_del+0x11a/0x168
[  222.859262]  [<ffffffffa000f9f5>] ? usb_disable_device+0x6b/0x175 
[usbcore]
[  222.859262]  [<ffffffffa0009915>] ? usb_disconnect+0x6f/0xd0 [usbcore]
[  222.859262]  [<ffffffffa000b08c>] ? hub_thread+0x574/0xec3 [usbcore]
[  222.859262]  [<ffffffff810380cd>] ? set_next_entity+0x32/0x55
[  222.859262]  [<ffffffff8105fde3>] ? add_wait_queue+0x3c/0x3c
[  222.859262]  [<ffffffffa000ab18>] ? usb_remote_wakeup+0x2f/0x2f [usbcore]
[  222.859262]  [<ffffffff8105f791>] ? kthread+0x76/0x7e
[  222.859262]  [<ffffffff81358034>] ? kernel_thread_helper+0x4/0x10
[  222.859262]  [<ffffffff8105f71b>] ? kthread_worker_fn+0x139/0x139
[  222.859262]  [<ffffffff81358030>] ? gs_change+0x13/0x13
[  222.859262] Code: f0 e8 8c ae 0f 00 48 8b 7b f8 e8 83 ae 0f 00 48 8d 
7b e0 5b e9 53 7e 08 00 53 48 8b 87 88 03 00 00 48 89 fb 48 8b bf 80 03 
00 00 <8b> 00 48 c7 83 80 03 00 00 00 00 00 00 e8 70 fd ff ff 48 8b bb
[  222.859262] RIP  [<ffffffff810645e6>] exit_creds+0x12/0x5a
[  222.859262]  RSP <ffff880036c91bb0>
[  222.859262] CR2: 0000000000000000
[  222.993936] ---[ end trace 2ced670cbbf01c43 ]---

Regards,
Gilles




