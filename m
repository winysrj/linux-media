Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50238 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0EGAKw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 20:10:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by tyrex.lisa.loc (Postfix) with ESMTP id 78A41968D5C9
	for <linux-media@vger.kernel.org>; Fri,  7 May 2010 02:10:48 +0200 (CEST)
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-media@vger.kernel.org
Subject: dvb_ttpci: PES packet shortened; cx8800 and dvb_ttpci crashes on rmmod (2.6.34-rc6)
Date: Fri, 7 May 2010 02:10:40 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005070210.40924.hpj@urpla.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

on a crusade to get a setup with one FF Hauppauge WinTV Nexus-S + CAM and 
two Hauppauge WinTV-HVR400 to behave well (again) with vdr (1.6.0 now), 
finally I've been arrived at kernel 2.6.34-rc6 and still suffering.. :-(

Accessing sky channels via CAM/AlphaCrypt could result in floods of 
	PES packet shortened to xxxx bytes (expected: yyyy bytes)
in vdr logs. Once this starts, the display is distorted from heavy pixel 
junk, and nothing cures this issue other than rebooting. :-(... Is this 
a known problem? Any idea on how to debug/fix such an problem?

The "normal" course of actions in this case is: reloading modules, but 
neither cx8800 nor dvb_ttpci do unload properly ATM:

[  324.584972] cx8800 0000:07:02.0: PCI INT A disabled
[  324.630743] cx8800 0000:07:01.0: PCI INT A disabled
[  324.630838] BUG: unable to handle kernel paging request at 38352e34
[  324.643415] IP: [<c036565e>] sysfs_remove_group+0x7e/0xd0
[  324.654404] *pdpt = 0000000023528001 *pde = 0000000000000000 
[  324.666116] Oops: 0000 [#1] SMP 
[  324.672707] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[  324.688553] Modules linked in: ip6t_LOG ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG xt_limit iptable_nat nf
_nat nfsd autofs4 af_packet nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_conservative cpufreq_userspace cpufreq_
powersave acpi_cpufreq speedstep_lib ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_physdev xt_stat
e iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_ta
bles ip6table_filter ip6_tables x_tables bridge stp llc fuse aufs loop dm_mod isl6421 cx24116 stv0299 ves1x93 tuner dvb_
ttpci dvb_core snd_hda_intel saa7146_vv snd_hda_codec cx8800(-) cx88xx v4l2_common ir_common videodev i2c_algo_bit snd_h
wdep saa7146 v4l1_compat tveeprom snd_pcm ir_core snd_timer videobuf_dma_sg snd tpm_tis iTCO_wdt i2c_i801 videobuf_core 
tpm btcx_risc pcspkr button sr_mod tpm_bios cdrom iTCO_vendor_support pl2303 usbserial e1000e usbhid ttpci_eeprom soundc
ore snd_page_alloc kvm_intel sg kvm ehci_hcd usbcore edd xfs exportfs fan thermal processor thermal_sys sd_mod ata_piix 
libata arcmsr scsi_mod [last unloaded: cx88_alsa]
[  324.890574] 
[  324.893587] Pid: 7320, comm: modprobe Not tainted 2.6.34-rc6-4-pae #1 P7F-E/System Product Name
[  324.911008] EIP: 0060:[<c036565e>] EFLAGS: 00010202 CPU: 4
[  324.922133] EIP is at sysfs_remove_group+0x7e/0xd0
[  324.931832] EAX: e6a50e08 EBX: 38352e34 ECX: e7e00000 EDX: 00000000
[  324.944559] ESI: 00000000 EDI: e641285c EBP: e6a50e08 ESP: e2b9be70
[  324.957181]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  324.968084] Process modprobe (pid: 7320, ti=e2b9a000 task=e51b0270 task.ti=e2b9a000)
[  324.983565] Stack:
[  324.987715]  00000286 00000001 e64da9dc e6a50a00 00000286 e6412840 e6889000 00000000
[  325.003149] <0> e6bb2800 f03ae932 e6412840 e6889000 f03ae044 00000000 faffffff e6c8f180
[  325.019671] <0> e6bb2800 f04ba5e5 00000000 fa000000 f04b6dd9 01000000 00000000 faffffff
[  325.036573] Call Trace:
[  325.041554]  [<f03ae932>] ir_unregister_class+0x32/0x60 [ir_core]
[  325.053888]  [<f03ae044>] ir_input_unregister+0x44/0x90 [ir_core]
[  325.066202]  [<f04ba5e5>] cx88_ir_fini+0x25/0x50 [cx88xx]
[  325.077213]  [<f04b6dd9>] cx88_core_put+0xb9/0x140 [cx88xx]
[  325.088434]  [<f04f4156>] cx8800_finidev+0x7e/0x89 [cx8800]
[  325.099765]  [<c041e6d6>] pci_device_remove+0x16/0x40
[  325.110004]  [<c04b2eed>] __device_release_driver+0x6d/0xd0
[  325.121232]  [<c04b2fcf>] driver_detach+0x7f/0x90
[  325.130751]  [<c04b1f9a>] bus_remove_driver+0x7a/0x100
[  325.141196]  [<c041e8de>] pci_unregister_driver+0x2e/0x80
[  325.152163]  [<c0278fe9>] sys_delete_module+0x179/0x250
[  325.162684]  [<c0202e4c>] sysenter_do_call+0x12/0x22
[  325.172618]  [<ffffe424>] 0xffffe424
[  325.179852] Code: f0 ff 0e 0f 94 c0 84 c0 75 0b 83 c4 14 5b 5e 5f 5d c3 8d 76 00 83 c4 14 89 f0 5b 5e 5f 5d e9 ca e6 
ff ff 66 90 31 f6 85 db 74 a3 <8b> 03 85 c0 74 07 f0 ff 03 89 de eb 96 ba 9d 00 00 00 b8 e8 81 
[  325.220532] EIP: [<c036565e>] sysfs_remove_group+0x7e/0xd0 SS:ESP 0068:e2b9be70
[  325.235367] CR2: 0000000038352e34
[  325.242044] ---[ end trace ad00d5df5a39e6b6 ]---

This one I was able to work around by blacklisting ir_common and ir_core 
(this is a server install anyway), but unloading dvb_ttpci results in:

[   64.526813] cx24116_load_firmware: FW version 1.22.82.0
[   64.526823] cx24116_firmware_ondemand: Firmware upload complete
[  131.523444] cx88/2: unregistering cx8802 driver, type: dvb access: shared
[  131.523451] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[  131.524048] cx88[1]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[  131.554953] cx88-mpeg driver manager 0000:07:02.2: PCI INT A disabled
[  131.555024] cx88-mpeg driver manager 0000:07:01.2: PCI INT A disabled
[  143.260583] cx88_audio 0000:07:02.1: PCI INT A disabled
[  143.260670] cx88_audio 0000:07:01.1: PCI INT A disabled
[  171.110862] cx8800 0000:07:02.0: PCI INT A disabled
[  171.156445] cx8800 0000:07:01.0: PCI INT A disabled
[  292.349178] saa7146: unregister extension 'dvb'.
[  292.413289] BUG: unable to handle kernel NULL pointer dereference at (null)
[  292.427349] IP: [<f042b426>] v4l2_device_unregister+0x16/0x50 [videodev]
[  292.440898] *pdpt = 0000000021ee4001 *pde = 0000000000000000 
[  292.452550] Oops: 0000 [#1] SMP 
[  292.459114] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[  292.474774] Modules linked in: ip6t_LOG ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG xt_limit iptable_nat 
nf_nat nfsd autofs4 af_packet nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_conservative cpufreq_userspace 
cpufreq_powersave acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 speedstep_lib ip6table_raw xt_NOTRACK ipt_REJECT xt_physdev 
xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 
ip_tables ip6table_filter ip6_tables x_tables bridge stp llc fuse aufs loop dm_mod stv0299 dvb_ttpci(-) dvb_core button 
saa7146_vv saa7146 ttpci_eeprom videodev v4l1_compat videobuf_dma_sg videobuf_core sr_mod cdrom pcspkr pl2303 iTCO_wdt 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer i2c_i801 e1000e usbserial iTCO_vendor_support snd soundcore 
snd_page_alloc tpm_tis tpm tpm_bios kvm_intel sg kvm usbhid ehci_hcd usbcore edd xfs exportfs fan thermal processor 
thermal_sys sd_mod ata_piix libata arcmsr scsi_mod [last unloaded: v4l2_common]
[  292.497065] 
[  292.497069] Pid: 7285, comm: modprobe Not tainted 2.6.34-rc6-4-pae #1 P7F-E/System Product Name
[  292.497074] EIP: 0060:[<f042b426>] EFLAGS: 00010203 CPU: 4
[  292.497081] EIP is at v4l2_device_unregister+0x16/0x50 [videodev]
[  292.497084] EAX: 00000000 EBX: 00000000 ECX: e7e00000 EDX: 00000001
[  292.497087] ESI: e683fd8c EDI: e683fd90 EBP: e683fd80 ESP: e1ed3e10
[  292.497090]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  292.497094] Process modprobe (pid: 7285, ti=e1ed2000 task=e695e230 task.ti=e1ed2000)
[  292.497096] Stack:
[  292.497098]  00000000 e683fd80 e7994480 f04a5b12 e683fd80 c04027ea e67c409c e683fd80
[  292.497103] <0> f04a51ff c04b0166 e67c409c e683fd80 e67c4000 e683fd80 f15cc0b9 26562000
[  292.497108] <0> 00000000 f15d8d06 00000000 c0232e8a 26562000 00000000 e6562000 e64c8000
[  292.497114] Call Trace:
[  292.497133]  [<f04a5b12>] saa7146_vv_release+0x32/0x120 [saa7146_vv]
[  292.497145]  [<f15cc0b9>] av7110_exit_v4l+0x39/0x50 [dvb_ttpci]
[  292.497161]  [<f15d8d06>] av7110_detach+0xae/0x1bf [dvb_ttpci]
[  292.497181]  [<f0487485>] saa7146_remove_one+0xd5/0x230 [saa7146]
[  292.497190]  [<c041e6d6>] pci_device_remove+0x16/0x40
[  292.497198]  [<c04b2eed>] __device_release_driver+0x6d/0xd0
[  292.497204]  [<c04b2fcf>] driver_detach+0x7f/0x90
[  292.497211]  [<c04b1f9a>] bus_remove_driver+0x7a/0x100
[  292.497216]  [<c041e8de>] pci_unregister_driver+0x2e/0x80
[  292.497224]  [<f0486eb7>] saa7146_unregister_extension+0x27/0x60 [saa7146]
[  292.497232]  [<c0278fe9>] sys_delete_module+0x179/0x250
[  292.497240]  [<c0202e4c>] sysenter_do_call+0x12/0x22
[  292.497249]  [<ffffe424>] 0xffffe424
[  292.497250] Code: e8 40 7a 08 d0 c7 03 00 00 00 00 5b c3 90 8d b4 26 00 00 00 00 57 85 c0 56 89 c6 53 74 3a e8 d2 ff ff 
ff 8b 5e 04 8d 7e 04 39 fb <8b> 03 74 29 89 c6 eb 06 66 90 89 f3 89 c6 89 d8 e8 75 fe ff ff 
[  292.497277] EIP: [<f042b426>] v4l2_device_unregister+0x16/0x50 [videodev] SS:ESP 0068:e1ed3e10
[  292.497286] CR2: 0000000000000000
[  292.497312] ---[ end trace caa25a9113f98bec ]---


Hmm, blacklisting saa7146_vv and friends wouldn't make much sense, I guess..

BTW, the kernel is build on openSUSE build service:
http://download.opensuse.org/repositories/home:/frispete:/kernel-head/openSUSE_11.1
http://download.opensuse.org/repositories/home:/frispete:/kernel-head/openSUSE_11.2

These crashes are from the 11.1/i586 version.

Adding v4l-dvb-kmp-pae-hg20100429_2331 to the game reduces the tendency to 
generate these "PES packet shortened" messages from vdr, but now Sport1 and
Sport2 channels do these reliable with low distortions, but very disturbing
never the less:

May  7 02:03:47 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:48 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:48 tyrex vdr: [7968] PES packet shortened to 3102 bytes (expected: 3470 bytes)
May  7 02:03:48 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:48 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:48 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:49 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:49 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:50 tyrex vdr: [7968] PES packet shortened to 3102 bytes (expected: 3470 bytes)
May  7 02:03:50 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:50 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:50 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:50 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:51 tyrex vdr: [7968] PES packet shortened to 3312 bytes (expected: 3470 bytes)
May  7 02:03:52 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:52 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:52 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:52 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:53 tyrex vdr: [7968] PES packet shortened to 3102 bytes (expected: 3470 bytes)
May  7 02:03:53 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:53 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:54 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:55 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:55 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:56 tyrex vdr: [7968] PES packet shortened to 3102 bytes (expected: 3470 bytes)
May  7 02:03:56 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:56 tyrex vdr: [7968] PES packet shortened to 3312 bytes (expected: 3470 bytes)
May  7 02:03:56 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:56 tyrex vdr: [7968] PES packet shortened to 3102 bytes (expected: 3470 bytes)
May  7 02:03:57 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:57 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:57 tyrex vdr: [7968] PES packet shortened to 3128 bytes (expected: 3470 bytes)
May  7 02:03:57 tyrex vdr: [7968] PES packet shortened to 3102 bytes (expected: 3470 bytes)
May  7 02:03:57 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)
May  7 02:03:57 tyrex vdr: [7968] PES packet shortened to 3286 bytes (expected: 3470 bytes)

My v4l-vdr hg builds for this kernel can be found here:
http://download.opensuse.org/repositories/home:/frispete:/dvb/openSUSE_11.1_kernel-head

This package needs a ton of #include <kernel/slab.h> for the current kernel. 
You can find them included in the src rpm. Should I publish the combined 
patch here?

Pete
