Return-path: <mchehab@gaivota>
Received: from fmmailgate04.web.de ([217.72.192.242]:47104 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0L3An7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 19:43:59 -0500
From: devzero@web.de
To: "Randy Dunlap" <rdunlap@xenotime.net>
Cc: linux-media@vger.kernel.org
Message-ID: <203751429.3829655.1293669837835.JavaMail.fmail@mwmweb063>
In-Reply-To: <511456980.3809534.1293660988971.JavaMail.fmail@mwmweb063>
References: <951502855.3794233.1293658070094.JavaMail.fmail@mwmweb063>,
 <20101229133442.53849184.rdunlap@xenotime.net>,
 <511456980.3809534.1293660988971.JavaMail.fmail@mwmweb063>
Subject: Re: bug? oops with mem2mem_testdev module
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Dec 2010 01:43:57 +0100 (CET)
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

>sorry, that must be the f....n webmailer.
apparently, it seems related to IE8.... sadly, i have no linux desktop where i`m at for the moment ....

so, i added my findings to bugzilla - except the mem2mem one, as this got a response and the cause seems to be already known.....

here they are for reference:

system freeze when loading g_webcam gadget driver -> https://bugzilla.kernel.org/show_bug.cgi?id=25892
g_printer oops on module unload  -> https://bugzilla.kernel.org/show_bug.cgi?id=25882 
spi_butterfly oops -> https://bugzilla.kernel.org/show_bug.cgi?id=25872

regards
roland

>i chose "text mail" and did nothing but copy/paste from putty....
>rather curious.....will repost
>
>p.osciak@samsung.com (from modinfo) is bouncing, btw.
>
>-----Ursprüngliche Nachricht-----
>Von: "Randy Dunlap"  
>Gesendet: 29.12.2010 22:34:42
>An: "Roland Kletzing"  
>Betreff: Re: bug? oops with mem2mem_testdev module
>
>>On Wed, 29 Dec 2010 22:27:50 +0100 (CET) Roland Kletzing wrote:
>>
>>> Hello, 
>>> 
>>> i assume this is not expected behaviour.
>>> see below
>>> kernel is 2.6.37-rc7
>>> 
>>> regards
>>> roland
>>> 
>>> 
>>> [root@ubuntu]:~# modprobe mem2mem_testdev;modprobe -r mem2mem_testdev;modprobe mem2mem_testdevKilled
>>> 
>>> [ 80.266552] m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as /dev/video0[ 80.292786] m2m-testdev m2m-testdev.0: Removing mem2mem-testdev[ 80.323013] BUG: unable to handle kernel paging request at 7562696c[ 80.323685] IP: [ ] __kmalloc_track_caller+0x95/0x1c0[ 80.324094] *pde = 00000000[ 80.324094] Oops: 0000 [#1] SMP[ 80.324094] last sysfs file: /sys/module/videobuf_vmalloc/refcnt[ 80.324094] Modules linked in: videobuf_core snd_ens1371 gameport snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm snd_timer snd psmouse soundcore snd_page_alloc intel_agp lp ppdev serio_raw parport_pc intel_gtt shpchp vmw_balloon agpgart i2c_piix4 parport pcnet32 mptspi mptscsih floppy mii mptbase scsi_transport_spi [last unloaded: videobuf_vmalloc][ 80.324094][ 80.324094] Pid: 731, comm: modprobe Not tainted 2.6.37-rc7 #3 440BX Desktop Reference Platform/VMware Virtual Platform[ 80.324094] EIP: 0060:[ ] EFLAGS: 00010006 CPU: 0[ 80.324094] EIP is at __kmalloc_track_caller+0x95/0x1c0[ 80.324094] EAX: df406ff8 EBX: 0000013c ECX: 7562696c EDX: 00000000[ 80.324094] ESI: df002500 EDI: 000000d0 EBP: de771e70 ESP: de771e44[ 80.324094] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068[ 80.324094] Process modprobe (pid: 731, ti=de770000 task=de4d5860 task.ti=de770000)[ 80.324094] Stack:[ 80.324094] ffffffff 00000757 00000000 c04f5d4e de4220c4 c035ef4b 00000246 7562696c[ 80.324094] de50a9c0 000000d0 000000ab de771e90 c04f5d78 df002180 00000000 00000080[ 80.324094] 00000020 df0007b0 de422000 de771ee0 c035ef4b ffffffff c0755692 00000757[ 80.324094] Call Trace:[ 80.324094] [ ] ? __alloc_skb+0x2e/0x100[ 80.324094] [ ] ? kobject_uevent_env+0x29b/0x430[ 80.324094] [ ] ? __alloc_skb+0x58/0x100[ 80.324094] [ ] ? kobject_uevent_env+0x29b/0x430[ 80.324094] [ ] ? kobject_uevent+0xa/0x10[ 80.324094] [ ] ? kobject_release+0x74/0x80[ 80.324094] [ ] ? kobject_release+0x0/0x80[ 80.324094] [ ] ? kref_put+0x2d/0x60[ 80.324094] [ ] ? kobject_put+0x1d/0x50[ 80.324094] [ ] ? free_sect_attrs+0x32/0x40[ 80.324094] [ ] ? free_module+0x143/0x1c0[ 80.324094] [ ] ? sys_delete_module+0x16e/0x200[ 80.324094] [ ] ? sysenter_do_call+0x12/0x28[ 80.324094] Code: 9c 58 8d 44 20 00 89 45 ec fa 8d 44 20 00 90 8b 06 64 03 05 94 80 8c c0 8b 10 85 d2 89 55 f0 0f 84 0b 01 00 00 8b 56 10 8b 4d f0   14 11 89 10 8b 45 ec 50 9d 8d 44 20 00 8b 55 f0 85 d2 75 46[ 80.324094] EIP: [ ] __kmalloc_track_caller+0x95/0x1c0 SS:ESP 0068:de771e44[ 80.324094] CR2: 000000007562696c[ 80.324094] ---[ end trace 1c390fe96c782b4a ]---[ 80.336810] BUG: unable to handle kernel paging request at 7562696c[ 80.337045] IP: [ ] kmem_cache_alloc_notrace+0x52/0xa0[ 80.337207] *pde = 00000000[ 80.337323] Oops: 0000 [#2] SMP[ 80.337454] last sysfs file: /sys/module/videobuf_vmalloc/refcnt[ 80.337596] Modules linked in: videobuf_core snd_ens1371 gameport snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm snd_timer snd psmouse soundcore snd_page_alloc intel_agp lp ppdev serio_raw parport_pc intel_gtt shpchp vmw_balloon agpgart i2c_piix4 parport pcnet32 mptspi mptscsih floppy mii mptbase scsi_transport_spi [last unloaded: videobuf_vmalloc][ 80.338648][ 80.338812] Pid: 706, comm: bash Tainted: G D 2.6.37-rc7 #3 440BX Desktop Reference Platform/VMware Virtual Platform[ 80.339076] EIP: 0060:[ ] EFLAGS: 00010006 CPU: 0[ 80.339208] EIP is at kmem_cache_alloc_notrace+0x52/0xa0[ 80.339336] EAX: df406ff8 EBX: 7562696c ECX: c02258bc EDX: 00000000[ 80.339473] ESI: df002500 EDI: 000080d0 EBP: de51ff18 ESP: de51ff00[ 80.339611] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068[ 80.339739] Process bash (pid: 706, ti=de51e000 task=de4d25e0 task.ti=de51e000)[ 80.339957] Stack:[ 80.340056] 0871c3c8 c02258bc 00000246 cbe22c40 df002500 de106bd0 de51ff38 c02258bc[ 80.340072] 00000040 000080d0 de51ff38 de106bd0 00000000 0871c3c8 de51ff60 c0225990[ 80.340072] 00000000 00000000 c072e378 cbf5f8f4 de51ffb4 ffffffea 00000000 0871c3c8[ 80.340072] Call Trace:[ 80.340072] [ ] ? alloc_pipe_info+0x6c/0xf0[ 80.340072] [ ] ? alloc_pipe_info+0x6c/0xf0[ 80.340072] [ ] ? create_write_pipe+0x50/0x190[ 80.340072] [ ] ? do_pipe_flags+0x3f/0x110[ 80.340072] [ ] ? sys_pipe2+0x1e/0x60[ 80.340072] [ ] ? sys_rt_sigprocmask+0x99/0xf0[ 80.340072] [ ] ? sys_pipe+0x1e/0x20[ 80.340072] [ ] ? sysenter_do_call+0x12/0x28[ 80.340072] Code: 4d ec e8 12 43 3c 00 8b 4d ec 9c 58 8d 44 20 00 89 45 f0 fa 8d 44 20 00 90 8b 06 64 03 05 94 80 8c c0 8b 18 85 db 74 3c 8b 56 10   14 13 89 10 8b 45 f0 50 9d 8d 44 20 00 85 db 75 14 89 d8 8b[ 80.340072] EIP: [ ] kmem_cache_alloc_notrace+0x52/0xa0 SS:ESP 0068:de51ff00[ 80.340072] CR2: 000000007562696c[ 80.340072] ---[ end trace 1c390fe96c782b4b ]---
>>
>>
>>Ugh, what happened to all of the CRs and/or LFs?
>>
>>This (and the others that you have posted today) is very unreadable/unusable.
>>
>>---
>>~Randy
>>*** Remember to use Documentation/SubmitChecklist when testing your code ***
>>desserts:  http://www.xenotime.net/linux/recipes/
___________________________________________________________
Empfehlen Sie WEB.DE DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 100,- Euro! https://freundschaftswerbung.web.de
