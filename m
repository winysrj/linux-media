Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:36983 "EHLO cnc.isely.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932854AbdLSDAU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 22:00:20 -0500
Date: Mon, 18 Dec 2017 21:00:19 -0600 (CST)
From: isely@isely.net
To: Oleksandr Ostrenko <oleksandr.ostrenko@tu-dresden.de>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [BUG] NULL pointer dereference in pvr2_v4l2_internal_check
In-Reply-To: <alpine.DEB.2.11.1712182040470.22421@lochley.isely.net>
Message-ID: <alpine.DEB.2.11.1712182048320.22421@lochley.isely.net>
References: <3d81fa8c-8ce9-cc9b-7058-32415b2e39b0@tu-dresden.de> <9fceb279-0e24-6ea4-ade0-d418372f98cf@xs4all.nl> <alpine.DEB.2.11.1712161020280.22421@lochley.isely.net> <6e422947-0f7d-9576-9d4b-a3d9e78cc145@tu-dresden.de>
 <alpine.DEB.2.11.1712182040470.22421@lochley.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Follow-up...

Looking closer at that LKML item, that was a test involving fuzzing the 
kernel (i.e. feeding it deliberate garbage).  This is related to things 
like producing a deliberately bogus USB configuration or sending 
impossible data on endpoints that don't exist.  The pvrusb2 driver was 
never written with this sort of abuse in mind.  So if someone tries to 
actively wiggle USB signals via a related jtag port or deliberately 
tries to plug in hardware that tries badly to "look" like a pvrusb2 
device, then yeah the driver is going to get angry.

<soap box>

Don't misinterpret me here about fuzzing.  I believe it to be a valid 
exercise, especially in cases where the "right pattern" of garbage might 
be found as a way to exploit the kernel.  This is a *major* concern when 
you're dealing with bus interfaces that can provide direct hardware 
access to RAM, e.g. Thunderbolt (because it's just PCI-Express lanes).  
But USB does not have that sort of abstraction capability; nothing 
coming in from pvrusb2 hardware can ever be "executed" by the driver, 
and there's nothing in the protocol where received data can somehow be 
misconstrued as a pointer or influence a pointer into arbitrary memory.  
The protocol is just too simplistic for that.  I'd actually be more 
concerned about the USB stack itself getting fooled.  The pvrusb2 driver 
just sends small packets, receives strictly small bits of data in 
response, and anything that comes back as part of a stream is treated 
strictly as that - a stream of media content nothing more.

Anyway, back to the topic at hand...

</soap box>

So that's different than issues with correctly handling all possible 
hot-unplug races, which is what I believe needs to be investigated here.

  -Mike

On Mon, 18 Dec 2017, isely@isely.net wrote:

> 
> It might be related.  I have some digging to do, and it's been quite a 
> while since I've seen any issues in that area of logic.
> 
> However that said, one the hardest areas of that driver was implementing 
> a proper tear-down after a hot-unplug event.  That sort of thing is 
> going to inherently be a race no matter what.  The driver has to support 
> this event regardless of what else is going on at the time and there's 
> obviously not going to be any synchronization with the moment when a 
> human pulls the plug.  I remember when I last worked on this area that 
> it took a couple of attempts to get this handled and even then I wasn't 
> 100% convinced I got it right.  I need to review this logic.  That 
> implementation was a long time ago and I've certainly learned more about 
> this sort of problem domain since then.
> 
> I will try to get to this in the next few days.  I'm currently embroiled 
> in an entirely different puzzle which has a deadline of this Friday.
> 
>   -Mike
> 
> 
> On Mon, 18 Dec 2017, Oleksandr Ostrenko wrote:
> 
> > Dear Mike,
> > 
> > I thought the info below may help you in finding the root cause of the issue.
> > 
> > Upon unplugging a different pvrusb2 device I get a different error message
> > (see attachment), like the one summarized here:
> > 
> > https://lkml.org/lkml/2017/11/3/446
> > 
> > Is it related to this bug?
> > 
> > Best regards,
> > Oleksandr
> > 
> > On Saturday, December 16, 2017 5:21:50 PM CET isely@isely.net wrote:
> > > I will do what I can.  Kind of surprising to have something like this
> > > happen now after so many years of stability.  There must have been some
> > > kind of environmental change that set this up.
> > > 
> > >   -Mike
> > > 
> > > On Sat, 16 Dec 2017, Hans Verkuil wrote:
> > > > Hi Mike,
> > > > > Can you take a look?
> > > > > Regards,
> > > > > 	Hans
> > > > > On 16/12/17 00:02, Oleksandr Ostrenko wrote:
> > > > > Dear all,
> > > > > > > Unplugging the TV tuner (WinTV HVR-1900) from USB port causes a NULL
> > > > > pointer dereference in pvr2_v4l2_internal_check:
> > > > > > > [ 2128.129776] usb 1-1: USB disconnect, device number 6
> > > > > [ 2128.129987] pvrusb2: Device being rendered inoperable
> > > > > [ 2128.130055] BUG: unable to handle kernel NULL pointer dereference at
> > > > > 0000000000000360 [ 2128.130082] IP: pvr2_v4l2_internal_check+0x41/0x60
> > > > > [pvrusb2]
> > > > > [ 2128.130085] PGD 0 P4D 0
> > > > > [ 2128.130092] Oops: 0000 [#1] PREEMPT SMP
> > > > > [ 2128.130097] Modules linked in: tda10048 tda18271 tda8290 tuner
> > > > > lirc_zilog(C) lirc_dev cx25840 rc_core pvrusb2(O) tveeprom cx2341x
> > > > > dvb_core v4l2_common rfcomm af_packet 8021q garp mrp stp llc
> > > > > nf_log_ipv6 xt_comment nf_log_ipv4 nf_log_common xt_LOG xt_limit
> > > > > ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT
> > > > > nf_reject_ipv4 xt_pkttype xt_tcpudp iptable_filter snd_hda_codec_hdmi
> > > > > ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
> > > > > nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
> > > > > ip6table_filter ip6_tables x_tables bnep arc4 xfs libcrc32c
> > > > > snd_hda_codec_realtek intel_rapl snd_hda_codec_generic
> > > > > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iwlmvm
> > > > > snd_hda_intel raid1 irqbypass crct10dif_pclmul snd_hda_codec mac80211
> > > > > crc32_pclmul snd_hda_core
> > > > > [ 2128.130176]  ghash_clmulni_intel snd_hwdep pcbc snd_pcm iwlwifi
> > > > > snd_timer dell_laptop aesni_intel md_mod hid_multitouch dell_wmi
> > > > > iTCO_wdt aes_x86_64 snd rtsx_pci_ms iTCO_vendor_support btusb
> > > > > crypto_simd uvcvideo dell_smbios btrtl glue_helper dell_smm_hwmon
> > > > > wmi_bmof dcdbas joydev hci_uart cryptd pcspkr cfg80211
> > > > > videobuf2_vmalloc memstick btbcm serdev videobuf2_memops r8169 btqca
> > > > > soundcore btintel videobuf2_v4l2 mii int3403_thermal i2c_i801
> > > > > videobuf2_core videodev bluetooth battery ac sparse_keymap ecdh_generic
> > > > > fan thermal idma64 pinctrl_sunrisepoint pinctrl_intel tpm_crb tpm_tis
> > > > > tpm_tis_core tpm processor_thermal_device intel_lpss_acpi
> > > > > intel_soc_dts_iosf int3402_thermal dell_rbtn int340x_thermal_zone
> > > > > mei_me rfkill int3400_thermal intel_lpss_pci acpi_pad mei
> > > > > acpi_thermal_rel intel_lpss intel_pch_thermal
> > > > > [ 2128.130252]  acpi_als kfifo_buf shpchp industrialio btrfs xor
> > > > > zstd_decompress zstd_compress xxhash hid_generic usbhid i915 raid6_pq
> > > > > rtsx_pci_sdmmc mmc_core mxm_wmi crc32c_intel i2c_algo_bit
> > > > > drm_kms_helper syscopyarea sysfillrect sysimgblt xhci_pci fb_sys_fops
> > > > > serio_raw xhci_hcd rtsx_pci drm usbcore wmi video i2c_hid button sg
> > > > > dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua [
> > > > > 2128.130300] CPU: 6 PID: 2310 Comm: pvrusb2-context Tainted: G C O   > >
> > > 4.14.6-1.g45f120a-default #1 [ 2128.130303] Hardware name: Dell Inc.
> > > > > Inspiron 7559/0H0CC0, BIOS 1.1.8 04/17/2016 [ 2128.130306] task:
> > > > > ffff880cae4f6000 task.stack: ffffb3a7c2548000 [ 2128.130320] RIP:
> > > > > 0010:pvr2_v4l2_internal_check+0x41/0x60 [pvrusb2] [ 2128.130324] RSP:
> > > > > 0018:ffffb3a7c254bec8 EFLAGS: 00010246
> > > > > [ 2128.130328] RAX: 0000000000000000 RBX: ffff880caf05e780 RCX:
> > > > > ffffffffc0ffe970 [ 2128.130331] RDX: ffff880c90ca1b60 RSI:
> > > > > 0000000000000001 RDI: 0000000000000000 [ 2128.130334] RBP:
> > > > > ffff880cac83eb00 R08: ffffffffc1016a78 R09: 00000000000003d2 [
> > > > > 2128.130337] R10: 00000000000003a9 R11: 00000000003d0900 R12:
> > > > > ffffb3a7c24ffc18 [ 2128.130340] R13: ffff880cae4f6000 R14:
> > > > > 0000000000000000 R15: ffffffffc1000ae0 [ 2128.130344] FS: > >
> > > 0000000000000000(0000) GS:ffff880cc1d80000(0000) knlGS:0000000000000000
> > > > > [ 2128.130347] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > [ 2128.130350] CR2: 0000000000000360 CR3: 000000024ec09005 CR4:
> > > > > 00000000003606e0 [ 2128.130354] DR0: 0000000000000000 DR1:
> > > > > 0000000000000000 DR2: 0000000000000000 [ 2128.130357] DR3:
> > > > > 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 [
> > > > > 2128.130359] Call Trace:
> > > > > [ 2128.130378]  pvr2_context_thread_func+0xa6/0x2a0 [pvrusb2]
> > > > > [ 2128.130388]  ? finish_wait+0x80/0x80
> > > > > [ 2128.130394]  kthread+0x118/0x130
> > > > > [ 2128.130399]  ? kthread_create_on_node+0x40/0x40
> > > > > [ 2128.130406]  ret_from_fork+0x25/0x30
> > > > > [ 2128.130412] Code: 8b 7f 38 e8 d2 e4 ff ff 48 8b 7b 40 e8 c9 e4 ff ff
> > > > > 48 8b 43 38 48 8b 90 60 03 00 00 48 05 60 03 00 00 48 39 d0 75 d6 48 8b
> > > > > 43 40 <48> 8b 90 60 03 00 00 48 05 60 03 00 00 48 39 d0 75 c0 48 89 df
> > > > > [ 2128.130491] RIP: pvr2_v4l2_internal_check+0x41/0x60 [pvrusb2] RSP:
> > > > > ffffb3a7c254bec8 [ 2128.130494] CR2: 0000000000000360
> > > > > [ 2128.130499] ---[ end trace b7d1a2a4867177f2 ]---
> > > > > > > Upon reconnect the device is no longer recognized by the driver and
> > > no
> > > > > firmware is uploaded:
> > > > > > > [ 2135.323115] usb 1-1: new high-speed USB device number 7 using
> > > > > xhci_hcd
> > > > > [ 2135.481292] usb 1-1: New USB device found, idVendor=2040,
> > > > > idProduct=7300
> > > > > [ 2135.481302] usb 1-1: New USB device strings: Mfr=1, Product=2,
> > > > > SerialNumber=3 [ 2135.481306] usb 1-1: Product: WinTV
> > > > > [ 2135.481310] usb 1-1: Manufacturer: Hauppauge
> > > > > [ 2135.481313] usb 1-1: SerialNumber: 7300-00-F04BADA0
> > > > > [ 2135.482726] pvrusb2: Hardware description: WinTV HVR-1900 Model 73xxx
> > > > > > > This effectively breaks the driver until after a reboot of the
> > > kernel.
> > > > > Can this be fixed by simply adding respective checks in the function
> > > > > itself or is this a part of a bigger issue?
> > > > > > > Thanks,
> > > > > Oleksandr
> > 
> 
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
