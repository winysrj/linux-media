Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab0IUSAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 14:00:51 -0400
Message-ID: <4C98F2C1.9090802@redhat.com>
Date: Tue, 21 Sep 2010 15:00:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
Subject: Re: [PATCH v2] tm6000+audio
References: <20100622180521.614eb85d@glory.loctelecom.ru>	<4C20D91F.500@redhat.com>	<4C212A90.7070707@arcor.de>	<4C213257.6060101@redhat.com>	<4C222561.4040605@arcor.de>	<4C224753.2090109@redhat.com>	<4C225A5C.7050103@arcor.de>	<20100716161623.2f3314df@glory.loctelecom.ru>	<4C4C4DCA.1050505@redhat.com>	<20100728113158.0f1495c0@glory.loctelecom.ru>	<4C4FD659.9050309@arcor.de>	<20100729140936.5bddd275@glory.loctelecom.ru>	<4C51ADB5.7010906@redhat.com>	<20100731122428.4ee569b4@glory.loctelecom.ru>	<4C53A837.3070700@redhat.com>	<20100825043746.225a352a@glory.local>	<4C7543DA.1070307@redhat.com>	<AANLkTimr3=1QHzX3BzUVyo6uqLdCKt8SS9sDtHfZtHGZ@mail.gmail.com>	<4C767302.7070506@redhat.com>	<20100920160715.7594ee2e@glory.local>	<4C9820E3.3050508@redhat.com> <20100921155626.65a31f29@glory.local>
In-Reply-To: <20100921155626.65a31f29@glory.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-09-2010 16:56, Dmitri Belimov escreveu:
> Hi Mauro
> 
>> Hi Dmitri,
>> Em 20-09-2010 17:07, Dmitri Belimov escreveu:
>>> Hi 
>>>
>>> I rework my last patch for audio and now audio works well. This
>>> patch can be submited to GIT tree Quality of audio now is good for
>>> SECAM-DK. For other standard I set some value from datasheet need
>>> some tests.
>>>
>>> 1. Fix pcm buffer overflow
>>> 2. Rework pcm buffer fill method
>>> 3. Swap bytes in audio stream
>>> 4. Change some registers value for TM6010
>>> 5. Change pcm buffer size
>>
>> One small compilation fix for your patch:
>>
>> diff --git a/drivers/staging/tm6000/tm6000-stds.c
>> b/drivers/staging/tm6000/tm6000-stds.c index 6bf4a73..fe22f42 100644
>> --- a/drivers/staging/tm6000/tm6000-stds.c
>> +++ b/drivers/staging/tm6000/tm6000-stds.c
>> @@ -32,7 +32,7 @@ struct tm6000_std_tv_settings {
>>  	v4l2_std_id id;
>>  	struct tm6000_reg_settings sif[12];
>>  	struct tm6000_reg_settings nosif[12];
>> -	struct tm6000_reg_settings common[25];
>> +	struct tm6000_reg_settings common[26];
>>  };
>>  
> 
> Ooops :)
> 
>> I'll do some tests on it.
> 
> Ok
> 
> With my best regards, Dmitry.

By startingt audio capture before video, using mmap() for audio, I got this OOPS:

[ 3154.916559] BUG: unable to handle kernel paging request at ffffeae380217f38
[ 3154.923520] IP: [<ffffffffa0164029>] get_page+0xe/0x3d [snd_pcm]
[ 3154.929518] PGD 0 
[ 3154.931534] Oops: 0000 [#1] SMP 
[ 3154.934772] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
[ 3154.942571] CPU 1 
[ 3154.944400] Modules linked in: tm6000_alsa(C) tuner_xc2028 tuner ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder tm6000(C) ir_rc5_decoder v4l2_common ir_nec_decoder videodev v4l2_compat_ioctl32 videobuf_vmalloc videobuf_core ir_common ir_core fuse ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT bridge stp llc cpufreq_ondemand xt_physdev iptable_filter ip6t_REJECT ip6table_filter ip6_tables ipv6 binfmt_misc parport kvm_intel kvm uinput tpm_infineon rtc_cmos rtc_core rtc_lib hp_wmi wmi psmouse serio_raw iTCO_wdt iTCO_vendor_support tg3 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc i7core_edac edac_core nouveau ttm drm_kms_helper video output firewire_ohci firewire_core crc_itu_t ahci libahci ehci_hcd uhci_hcd floppy [last unloaded: tuner_xc2028]
[ 3155.028977] 
[ 3155.030464] Pid: 23437, comm: arecord Tainted: G         C  2.6.35+ #4 0AE4h/HP Z400 Workstation
[ 3155.039261] RIP: 0010:[<ffffffffa0164029>]  [<ffffffffa0164029>] get_page+0xe/0x3d [snd_pcm]
[ 3155.047725] RSP: 0000:ffff8800aed1bd48  EFLAGS: 00010246
[ 3155.053014] RAX: 0000000410009921 RBX: ffff8800aed1bdd8 RCX: ffff8800aec07c58
[ 3155.060120] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffeae380217f38
[ 3155.067226] RBP: ffff8800aed1bd58 R08: 0000000000000000 R09: 0000000000000000
[ 3155.074334] R10: 0000000000000000 R11: ffff8800c8eeac68 R12: ffffeae380217f38
[ 3155.081441] R13: 0000000000000000 R14: ffff8800c8eeabc0 R15: 00003ffffffff000
[ 3155.088548] FS:  00007ff1f16d1700(0000) GS:ffff880002e20000(0000) knlGS:0000000000000000
[ 3155.096605] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3155.102326] CR2: ffffeae380217f38 CR3: 00000000aed00000 CR4: 00000000000006e0
[ 3155.109432] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3155.116538] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3155.123645] Process arecord (pid: 23437, threadinfo ffff8800aed1a000, task ffff880118c4a620)
[ 3155.132050] Stack:
[ 3155.134052]  ffff8800aed1bdd8 ffffeae380217f38 ffff8800aed1bd78 ffffffffa0165c03
[ 3155.141279] <0> ffff8800c0715a20 0000000000000000 ffff8800aed1be28 ffffffff820f276d
[ 3155.148962] <0> ffffffff8301b620 ffff880000000000 ffff880000000001 ffff8800c8eeac68
[ 3155.156827] Call Trace:
[ 3155.159268]  [<ffffffffa0165c03>] snd_pcm_mmap_data_fault+0x90/0xa2 [snd_pcm]
[ 3155.166378]  [<ffffffff820f276d>] __do_fault+0x58/0x4ac
[ 3155.171582]  [<ffffffff820f3698>] handle_mm_fault+0x3c5/0x8c2
[ 3155.177307]  [<ffffffff824b5713>] ? do_page_fault+0x200/0x491
[ 3155.183031]  [<ffffffff8212e408>] ? vfs_ioctl+0x32/0xa6
[ 3155.188239]  [<ffffffff82039fa9>] ? need_resched+0x35/0x3b
[ 3155.193702]  [<ffffffff824b591b>] do_page_fault+0x408/0x491
[ 3155.199253]  [<ffffffff824b26f5>] page_fault+0x25/0x30
[ 3155.204371] Code: 66 31 c0 eb 16 48 89 c6 e8 67 fe ff ff eb 0c b8 fa ff ff ff eb 05 b8 ea ff ff ff c9 c3 55 48 89 e5 41 54 53 0f 1f 44 00 00 31 d2 <4c> 8b 27 48 89 fb 49 c1 ec 0f 48 c7 c7 08 f7 16 a0 41 83 e4 01 
[ 3155.223920] RIP  [<ffffffffa0164029>] get_page+0xe/0x3d [snd_pcm]
[ 3155.230003]  RSP <ffff8800aed1bd48>
[ 3155.233476] CR2: ffffeae380217f38
[ 3155.238030] tm6000 tm6000_irq_callback :urb resubmit failed (error=-27)
[ 3155.244650] tm6000 tm6000_irq_callback :urb resubmit failed (error=-27)
[ 3155.251269] tm6000 tm6000_irq_callback :urb resubmit failed (error=-27)
[ 3155.257885] tm6000 tm6000_irq_callback :urb resubmit failed (error=-27)
[ 3155.264513] tm6000 tm6000_irq_callback :urb resubmit failed (error=-27)
[ 3155.337107] [drm] nouveau 0000:0f:00.0: Setting dpms mode 0 on vga encoder (output 0)
[ 3155.346780] ---[ end trace c95d6e8a92cbb590 ]---
[ 3155.352182] tm6000 tm6000_irq_callback :urb resubmit failed (error=-27)
[ 3155.358786] tm6000 tm6000_irq_callback :urb resubmit failed (error=-27)
[ 3155.365390] tm6000 tm6000_irq_callback :urb resubmit failed (error=-27)


