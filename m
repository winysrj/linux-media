Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB82026b011529
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 21:00:03 -0500
Received: from si01.xit.com.hk (si01.xit.com.hk [202.67.236.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB81wRH9005399
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 20:58:28 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by si01.xit.com.hk (Postfix) with ESMTP id 419C7C7066
	for <video4linux-list@redhat.com>; Mon,  8 Dec 2008 09:58:25 +0800 (HKT)
Received: from si01.xit.com.hk ([127.0.0.1])
	by localhost (si01.xit.com.hk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4nyUHIhPPwZI for <video4linux-list@redhat.com>;
	Mon,  8 Dec 2008 09:58:24 +0800 (HKT)
Received: from [192.168.128.30] (pcd343119.netvigator.com [203.218.133.119])
	by si01.xit.com.hk (Postfix) with ESMTP id 79427C7065
	for <video4linux-list@redhat.com>; Mon,  8 Dec 2008 09:58:24 +0800 (HKT)
Message-ID: <493C7F5A.4000809@xit.com.hk>
Date: Mon, 08 Dec 2008 09:58:50 +0800
From: Chris Ruehl <v4l@xit.com.hk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <493912BB.5040400@xit.com.hk>
In-Reply-To: <493912BB.5040400@xit.com.hk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: hg - cx88-alsa brocken with 2.6.27
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


> Hallo,
>
> I try to load the cx88-alsa with my HVR4000 but with the 2.6.27.x I 
> got a null-pointer assignment
> - I had a look in the code but not see any serious.
>
> I got 2 sound cards working in my system Xonar D2x and Intel HD (both 
> working)
>
> here is the dump.   Sorry I have not enough time for a closer look - 
> but ask me if more infos needed.
>
> cheers
> Chris
>
>
> cx2388x alsa driver version 0.0.6 loaded
> cx88_audio 0000:11:0c.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<f91698a7>] :cx88_alsa:cx88_audio_initdev+0xeb/0x309
> *pdpt = 0000000035136001 *pde = 0000000000000000
> Oops: 0002 [#1] SMP
> Modules linked in: cx88_alsa(+) wmi pci_slot iptable_filter ip_tables 
> x_tables cx22702 isl6421 cx24116 cx88_dvb cx88_vp3054_i2c wm8775 
> tuner_simple tuner_types tda9887 tda8290 tuner snd_virtuoso 
> snd_oxygen_lib snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm 
> snd_page_alloc snd_mpu401_uart snd_hwdep snd_seq_dummy snd_seq_oss 
> cx8802 snd_seq_midi cx8800 cx88xx snd_seq_midi_event ir_common 
> i2c_algo_bit videodev snd_seq tveeprom v4l1_compat videobuf_dvb 
> snd_rawmidi compat_ioctl32 dvb_core snd_timer v4l2_common 
> snd_seq_device btcx_risc nvidia(P) videobuf_dma_sg videobuf_core snd 
> i2c_core e1000e dm_mirror dm_log dm_snapshot fuse
>
> Pid: 5709, comm: modprobe Tainted: P          (2.6.27.7 #4)
> EIP: 0060:[<f91698a7>] EFLAGS: 00010202 CPU: 0
> EIP is at cx88_audio_initdev+0xeb/0x309 [cx88_alsa]
> EAX: f792f010 EBX: f792f000 ECX: 00000000 EDX: ffffffff
> ESI: f51c0c00 EDI: 00000000 EBP: f78ee800 ESP: f4da3e9c
> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 5709, ti=f4da2000 task=f6b52680 task.ti=f4da2000)
> Stack: f792f010 f78ee8d4 c02340a9 f916b084 f916b050 f78ee800 f916b084 
> c023460f
>       f78ee85c 00000000 f916b084 c028a6a2 f78ee85c f78ee918 f916b084 
> c028a76b
>       00000000 00000000 c040ab24 c028a123 f783593c f7835940 f78ee8b0 
> 00000000
> Call Trace:
> [<c02340a9>] pci_match_device+0x13/0x8b
> [<c023460f>] pci_device_probe+0x36/0x55
> [<c028a6a2>] driver_probe_device+0x9d/0x12f
> [<c028a76b>] __driver_attach+0x37/0x55
> [<c028a123>] bus_for_each_dev+0x35/0x5c
> [<c028a555>] driver_attach+0x11/0x13
> [<c028a734>] __driver_attach+0x0/0x55
> [<c0289ba6>] bus_add_driver+0x91/0x1a7
> [<f9169772>] cx88_audio_init+0x0/0x2a [cx88_alsa]
> [<c028a8d1>] driver_register+0x7d/0xd6
> [<f9169772>] cx88_audio_init+0x0/0x2a [cx88_alsa]
> [<f9169772>] cx88_audio_init+0x0/0x2a [cx88_alsa]
> [<c02347d1>] __pci_register_driver+0x3c/0x67
> [<c010111f>] _stext+0x37/0xfb
> [<c013d07e>] sys_init_module+0x87/0x174
> [<c0102fc5>] sysenter_do_call+0x12/0x25
> =======================
> Code: 04 24 75 27 50 8b 07 83 c0 10 50 68 a4 9c 16 f9 e8 63 f3 1d c7 
> 89 d8 89 ea bb fb ff ff ff e8 e8 c9 b2 ff 83 c4 0c e9 14 02 00 00 <89> 
> 1f 89 77 4c 89 6f 44 c7 47 48 ff ff ff ff c7 47 50 00 00 00
> EIP: [<f91698a7>] cx88_audio_initdev+0xeb/0x309 [cx88_alsa] SS:ESP 
> 0068:f4da3e9c
> ---[ end trace e9e859edcab46f62 ]---
>

Hi all,

I had time to have a closer look to the cx88-alsa and its seems not the 
problem here.
to got my intel HD sound-chip to work I complied the alsa-drivers-1.0.8a 
and if I install the drivers and
load the cx88-alsa I got the OOPS. Without the alsa-drivers installed 
everything working fine.

I will contact the alsa-team.

regards
Chris

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
