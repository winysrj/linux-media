Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QN7RIJ008651
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 19:07:27 -0400
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QN7DYe018533
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 19:07:14 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Anton Farygin <rider@altlinux.com>, video4linux-list@redhat.com
In-Reply-To: <fsecqi$f8k$1@ger.gmane.org>
References: <fsecqi$f8k$1@ger.gmane.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 23:59:04 +0100
Message-Id: <1206572344.3912.35.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134 oops
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Mittwoch, den 26.03.2008, 23:48 +0300 schrieb Anton Farygin:
> Hello.
> 
> on v4l-dvb snapshot 9a2af878cbd5 i received this oops with xawtv. Can 
> anyone to help me ?
> 
> 
> Card:Beholder TV M6 Extra.
> 01:09.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 
> Video Broadcast Decoder (rev d1)
>          Subsystem: Unknown device 5ace:6193
> 
> 
> 
> BUG: unable to handle kernel paging request at virtual address 0c505a40
> printing eip: f8b5b694 *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: ac cpufreq_powersave cpufreq_conservative 
> cpufreq_ondemand cpufreq_userspace nfsd auth_rpcgss exportfs nvidia(P) 
> agpgart rtc_cmos rtc_core rtc_lib k8temp it87 hwmon_vid hwmon eeprom nfs 
> lockd nfs_acl sunrpc tun af_packet ext2 dm_mod usbhid ff_memless 
> saa7134_empress saa6752hs tuner tea5767 tda8290 tda18271 tda827x 
> tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 
> snd_hda_intel snd_pcm_oss ohci_hcd snd_seq_dummy snd_seq_oss 
> snd_seq_midi_event snd_seq snd_seq_device saa7134 snd_mixer_oss videodev 
> v4l1_compat parport_pc compat_ioctl32 v4l2_common parport 
> videobuf_dma_sg snd_pcm videobuf_core snd_timer serio_raw ir_kbd_i2c 
> ohci1394 snd_page_alloc snd_hwdep pcspkr ssb ir_common snd ieee1394 
> psmouse pcmcia forcedeth soundcore pcmcia_core tveeprom ide_cd 
> firmware_class cdrom ehci_hcd i2c_nforce2 i2c_core fan thermal button sg 
> evdev lirc_imon usbcore lirc_dev powernow_k8 freq_table processor ext3 
> jbd mbcache ata_generic sata_nv pata_amd pata_acpi libata sd_mod 
> scsi_mod ide_disk ide_generic generic amd74xx ide_core
> 
> Pid: 7050, comm: xawtv Tainted: P        (2.6.24-std-def-alt6.1 #1)
> EIP: 0060:[<f8b5b694>] EFLAGS: 00010a87 CPU: 1
> EIP is at empress_querycap+0x24/0x70 [saa7134_empress]
> EAX: 13a068c0 EBX: f4899ed8 ECX: 00000020 EDX: f8b5bbe3
> ESI: f8b089e4 EDI: f4899f40 EBP: f72050e0 ESP: f4899dd0
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process xawtv (pid: 7050, ti=f4898000 task=f748f830 task.ti=f4898000)
> Stack: c019f630 00000286 c0137a97 f8b5b670 f482f0c8 f8aaf5a5 00000286 
> c0137b17
>         00000286 f4899e10 ffffb90b 00000000 d9d3cdf0 00000006 f7772005 
> 00000001
>         f7c10918 c01abe74 80685600 f7c10918 f77c6000 c019fb15 f7772000 
> f79ba9e8
> Call Trace:
>   [<c019f630>] __link_path_walk+0x980/0xe00
>   [<c0137a97>] lock_timer_base+0x27/0x60
>   [<f8b5b670>] empress_querycap+0x0/0x70 [saa7134_empress]
>   [<f8aaf5a5>] __video_do_ioctl+0x1af5/0x36a0 [videodev]
>   [<c0137b17>] try_to_del_timer_sync+0x47/0x50
>   [<c01abe74>] mntput_no_expire+0x24/0xa0
>   [<c019fb15>] link_path_walk+0x65/0xc0
>   [<c0193ea2>] get_unused_fd_flags+0x52/0xd0
>   [<c019fd43>] do_path_lookup+0x73/0x200
>   [<c018f710>] shmem_permission+0x0/0x10
>   [<f8b5b79c>] ts_open+0xbc/0xe0 [saa7134_empress]
>   [<f8ab154f>] video_ioctl2+0xbf/0x210 [videodev]
>   [<f8ab1150>] video_open+0x0/0x130 [videodev]
>   [<c01a1fb8>] do_ioctl+0x78/0x90
>   [<c01a202c>] vfs_ioctl+0x5c/0x290
>   [<c01a1a12>] do_fcntl+0x102/0x310
>   [<c01a22c8>] sys_ioctl+0x68/0x80
>   [<c0105412>] syscall_call+0x7/0xb
>   =======================
> Code: 45 47 5b c3 8d 76 00 56 89 c8 53 89 cb 83 ec 0c 8b 32 ba e3 bb b5 
> f8 e8 1b 9b 6a c7 b9 20 00 00 00 69 86 2c 01 00 00 f4 00 00 00 <8b> 90 
> 80 f1 af f8 8d 43 10 e8 1e 7f 6a c7 8b 86 1c 01 00 00 05
> EIP: [<f8b5b694>] empress_querycap+0x24/0x70 [saa7134_empress] SS:ESP 
> 0068:f4899dd0
> ---[ end trace 3ae5717da5733b2d ]---
> 

some time back I tried on a not yet supported saa7134 empress-card.

I confirm this oops with whenever empress_querycap is called on current
code. However, others with older supported cards reported them still
working at least on 2.6.18, went even back to 2.6.12, mine fails even
there with vidio get/set standard.

Since this might be card specific, there is already another one which
needs special measures to establish valid output, I called for recent
status reports, since the problem seems to exist since long, to find a
starting point, but nothing came in so far.

On your card it might not be much better, we have no debug output from
it that shows the mpeg encoder really functional.

For now, please continue on the video4linux-list, it is really OT here,
mine has at least working DVB-T and analog, but debugging the encoder
problems is still not for the dvb ML. If you can, maybe Knoppix or
something, try on 2.6.18 and 2.6.12.

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
