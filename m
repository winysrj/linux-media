Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:52234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0JTMgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 08:36:25 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: Unloading cx8802 results in crash of ir_core:ir_unregister_class
Date: Wed, 20 Oct 2010 14:35:55 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, opensuse-kernel@opensuse.org
References: <201010201231.24173.hpj@urpla.net> <1287576963.2679.16.camel@morgan.silverblock.net>
In-Reply-To: <1287576963.2679.16.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010201435.55740.hpj@urpla.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 20 October 2010, 14:16:03 Andy Walls wrote:
> On Wed, 2010-10-20 at 12:31 +0200, Hans-Peter Jansen wrote:
> > Hi Mauro,
> >
> > since you got your fingers dirty with ir, I would like to direct
> > this issue towards you.
> >
> >
> > Unfortunately, unloading all the dvb drivers is not possible,
> > because unloading cx8802 leads to this oops:
> >
> > Welcome to openSUSE 11.1 - Kernel 2.6.34.7-4-pae (ttyS0)
> > [111047.940641] BUG: unable to handle kernel paging request at
> > 313a3030 [111047.953710] IP: [<c03654fe>]
> > sysfs_remove_group+0x7e/0xd0 [111047.964838] *pdpt =
> > 0000000029f53001 *pde = 0000000000000000 [111047.976687] Oops: 0000
> > [#1] SMP
> > [111047.983453] last sysfs file:
> > /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> > [111047.999559] Modules linked in: ip6t_LOG ipt_MASQUERADE
> > xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG xt_limit iptable_nat ]
> > [111048.204691]
> > [111048.207843] Pid: 10029, comm: rmmod Not tainted 2.6.34.7-4-pae
> > #1 P7F-E/System Product Name [111048.224918] EIP: 0060:[<c03654fe>]
> > EFLAGS: 00210206 CPU: 0 [111048.236201] EIP is at
> > sysfs_remove_group+0x7e/0xd0
> > [111048.246007] EAX: ef4ff008 EBX: 313a3030 ECX: f0600000 EDX:
> > 00000000 [111048.258879] ESI: 00000000 EDI: efb7e71c EBP: ef4ff008
> > ESP: e3ee7e64 [111048.271716]  DS: 007b ES: 007b FS: 00d8 GS: 0033
> > SS: 0068 [111048.282668] Process rmmod (pid: 10029, ti=e3ee6000
> > task=eaf00e00 task.ti=e3ee6000) [111048.298133] Stack:
> > [111048.302319]  f02cabe0 00000041 ef5208c0 ef49ac00 00200286
> > efb7e700 ef3f0000 00000000 [111048.318132] <0> ef329800 f8f84932
> > efb7e700 ef3f0000 f8f84044 00000000 f8ffffff f015f1c0
> > [111048.334811] <0> ef329800 f917c655 00000000 f8000000 f9178dd9
> > 01000000 00000000 f8ffffff [111048.351939] Call Trace:
> > [111048.357213]  [<f8f84932>] ir_unregister_class+0x32/0x60
> > [ir_core] [111048.369821]  [<f8f84044>]
> > ir_input_unregister+0x44/0x90 [ir_core] [111048.382338] 
> > [<f917c655>] cx88_ir_fini+0x25/0x50 [cx88xx] [111048.393437] 
> > [<f9178dd9>] cx88_core_put+0xb9/0x140 [cx88xx] [111048.404834] 
> > [<f91e8795>] cx8802_remove+0x82/0x169 [cx8802] [111048.416319] 
> > [<c041d966>] pci_device_remove+0x16/0x40
> > [111048.426610]  [<c04b214d>] __device_release_driver+0x6d/0xd0
> > [111048.437993]  [<c04b222f>] driver_detach+0x7f/0x90
> > [111048.447872]  [<c04b11fa>] bus_remove_driver+0x7a/0x100
> > [111048.458687]  [<c041db6e>] pci_unregister_driver+0x2e/0x80
> > [111048.469658]  [<c0279669>] sys_delete_module+0x179/0x240
> > [111048.480262]  [<c020320c>] sysenter_do_call+0x12/0x22
> > [111048.490357]  [<ffffe424>] 0xffffe424
> > [111048.497680] Code: f0 ff 0e 0f 94 c0 84 c0 75 0b 83 c4 14 5b 5e
> > 5f 5d c3 8d 76 00 83 c4 14 89 f0 5b 5e 5f 5d e9 ca e
>
> These code bytes are truncated; there are only 32 here.  There are
> supposed to be 64 of them, with the Oops-ing instruction being around
> the 48th byte.
>
> Please review your logs and provide the full Ooops.
>
> > [111048.537852] EIP: [<c03654fe>] sysfs_remove_group+0x7e/0xd0
> > SS:ESP 0068:e3ee7e64 [111048.552782] CR2: 00000000313a3030
> > [111048.559854] ---[ end trace d7231a8e672c4adc ]---
> >
> > Any ideas, what's going wrong here?
>
> I don't. Mauro might since he knows the code better.  I just decode
> Oops'es every once in a while.

Sorry, Andy, that one was catched with a (non line wrapping) serial console.
Here's the full Oops:

Oct 20 04:15:12 tyrex kernel: [111047.814534] cx88/2: unregistering cx8802 driver, type: dvb access: shared
Oct 20 04:15:12 tyrex kernel: [111047.814543] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
Oct 20 04:15:12 tyrex kernel: [111047.815254] cx88[1]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
Oct 20 04:15:12 tyrex kernel: [111047.819013] cx88_audio 0000:07:02.1: PCI INT A disabled
Oct 20 04:15:12 tyrex kernel: [111047.819150] cx88_audio 0000:07:01.1: PCI INT A disabled
Oct 20 04:15:12 tyrex kernel: [111047.824359] cx8800 0000:07:02.0: PCI INT A disabled
Oct 20 04:15:12 tyrex kernel: [111047.824413] cx8800 0000:07:01.0: PCI INT A disabled
Oct 20 04:15:12 tyrex kernel: [111047.826168] cx88-mpeg driver manager 0000:07:02.2: PCI INT A disabled
Oct 20 04:15:13 tyrex kernel: [111047.940606] cx88-mpeg driver manager 0000:07:01.2: PCI INT A disabled
Oct 20 04:15:13 tyrex kernel: [111047.940641] BUG: unable to handle kernel paging request at 313a3030
Oct 20 04:15:13 tyrex kernel: [111047.953710] IP: [<c03654fe>] sysfs_remove_group+0x7e/0xd0
Oct 20 04:15:13 tyrex kernel: [111047.964838] *pdpt = 0000000029f53001 *pde = 0000000000000000 
Oct 20 04:15:13 tyrex kernel: [111047.976687] Oops: 0000 [#1] SMP 
Oct 20 04:15:13 tyrex kernel: [111047.983453] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
Oct 20 04:15:13 tyrex kernel: [111047.999559] Modules linked in: ip6t_LOG ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG xt_limi
t iptable_nat nf_nat tun nfsd autofs4 af_packet nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_conservative cpufreq_userspace cpu
freq_powersave acpi_cpufreq speedstep_lib ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_physdev xt_state mperf ip
table_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filte
r ip6_tables x_tables bridge stp llc fuse aufs loop dm_mod isl6421 cx24116 videobuf_dvb tuner lnbp21 stv0299 cx8802(-) snd_hda_intel cx
88xx dvb_ttpci snd_hda_codec dvb_core ir_common saa7146_vv v4l2_common snd_hwdep i2c_algo_bit saa7146 tveeprom snd_pcm videodev ir_core
 tpm_tis v4l1_compat snd_timer videobuf_dma_sg snd tpm pl2303 soundcore videobuf_core ttpci_eeprom button usbserial tpm_bios sr_mod pcs
pkr i2c_i801 btcx_risc cdrom e1000e snd_page_alloc iTCO_wdt iTCO_vendor_support k
Oct 20 04:15:13 tyrex kernel: vm_intel sg kvm usbhid ehci_hcd usbcore edd xfs exportfs fan thermal processor thermal_sys sd_mod ata_pii
x libata arcmsr scsi_mod [last unloaded: cx8800]
Oct 20 04:15:13 tyrex kernel: [111048.204691] 
Oct 20 04:15:13 tyrex kernel: [111048.207843] Pid: 10029, comm: rmmod Not tainted 2.6.34.7-4-pae #1 P7F-E/System Product Name
Oct 20 04:15:13 tyrex kernel: [111048.224918] EIP: 0060:[<c03654fe>] EFLAGS: 00210206 CPU: 0
Oct 20 04:15:13 tyrex kernel: [111048.236201] EIP is at sysfs_remove_group+0x7e/0xd0
Oct 20 04:15:13 tyrex kernel: [111048.246007] EAX: ef4ff008 EBX: 313a3030 ECX: f0600000 EDX: 00000000
Oct 20 04:15:13 tyrex kernel: [111048.258879] ESI: 00000000 EDI: efb7e71c EBP: ef4ff008 ESP: e3ee7e64
Oct 20 04:15:13 tyrex kernel: [111048.271716]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 20 04:15:13 tyrex kernel: [111048.282668] Process rmmod (pid: 10029, ti=e3ee6000 task=eaf00e00 task.ti=e3ee6000)
Oct 20 04:15:13 tyrex kernel: [111048.298133] Stack:
Oct 20 04:15:13 tyrex kernel: [111048.302319]  f02cabe0 00000041 ef5208c0 ef49ac00 00200286 efb7e700 ef3f0000 00000000
Oct 20 04:15:13 tyrex kernel: [111048.318132] <0> ef329800 f8f84932 efb7e700 ef3f0000 f8f84044 00000000 f8ffffff f015f1c0
Oct 20 04:15:13 tyrex kernel: [111048.334811] <0> ef329800 f917c655 00000000 f8000000 f9178dd9 01000000 00000000 f8ffffff
Oct 20 04:15:13 tyrex kernel: [111048.351939] Call Trace:
Oct 20 04:15:13 tyrex kernel: [111048.357213]  [<f8f84932>] ir_unregister_class+0x32/0x60 [ir_core]
Oct 20 04:15:13 tyrex kernel: [111048.369821]  [<f8f84044>] ir_input_unregister+0x44/0x90 [ir_core]
Oct 20 04:15:13 tyrex kernel: [111048.382338]  [<f917c655>] cx88_ir_fini+0x25/0x50 [cx88xx]
Oct 20 04:15:13 tyrex kernel: [111048.393437]  [<f9178dd9>] cx88_core_put+0xb9/0x140 [cx88xx]
Oct 20 04:15:13 tyrex kernel: [111048.404834]  [<f91e8795>] cx8802_remove+0x82/0x169 [cx8802]
Oct 20 04:15:13 tyrex kernel: [111048.416319]  [<c041d966>] pci_device_remove+0x16/0x40
Oct 20 04:15:13 tyrex kernel: [111048.426610]  [<c04b214d>] __device_release_driver+0x6d/0xd0
Oct 20 04:15:13 tyrex kernel: [111048.437993]  [<c04b222f>] driver_detach+0x7f/0x90
Oct 20 04:15:13 tyrex kernel: [111048.447872]  [<c04b11fa>] bus_remove_driver+0x7a/0x100
Oct 20 04:15:13 tyrex kernel: [111048.458687]  [<c041db6e>] pci_unregister_driver+0x2e/0x80
Oct 20 04:15:13 tyrex kernel: [111048.469658]  [<c0279669>] sys_delete_module+0x179/0x240
Oct 20 04:15:13 tyrex kernel: [111048.480262]  [<c020320c>] sysenter_do_call+0x12/0x22
Oct 20 04:15:13 tyrex kernel: [111048.490357]  [<ffffe424>] 0xffffe424
Oct 20 04:15:13 tyrex kernel: [111048.497680] Code: f0 ff 0e 0f 94 c0 84 c0 75 0b 83 c4 14 5b 5e 5f 5d c3 8d 76 00 83 c4 14 89 f0 5b 5e
 5f 5d e9 ca e6 ff ff 66 90 31 f6 85 db 74 a3 <8b> 03 85 c0 74 07 f0 ff 03 89 de eb 96 ba 9d 00 00 00 b8 64 83 
Oct 20 04:15:13 tyrex kernel: [111048.537852] EIP: [<c03654fe>] sysfs_remove_group+0x7e/0xd0 SS:ESP 0068:e3ee7e64
Oct 20 04:15:13 tyrex kernel: [111048.552782] CR2: 00000000313a3030
Oct 20 04:15:13 tyrex kernel: [111048.559854] ---[ end trace d7231a8e672c4adc ]---
Oct 20 04:15:13 tyrex kernel: [111048.574840] saa7146: unregister extension 'dvb'.

BTW, is it better to keep the overlong Code: line intact? 

> Regards,
> Andy

Thanks for your participation,
Pete


