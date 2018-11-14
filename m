Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:45593 "EHLO
        v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727731AbeKNXDZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 18:03:25 -0500
Subject: Re: cec kernel oops with pulse8 usb cec adapter
To: Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b067e063-641c-0498-4989-3edda5296f9a@mbox200.swipnet.se>
 <e2bb2b91-861b-8cdc-4ad4-939e50019214@xs4all.nl>
 <20181022085910.2gndxc75zcqkto5z@gofer.mess.org>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <0574214e-3172-717f-bfa8-f9da7a370942@mbox200.swipnet.se>
Date: Wed, 14 Nov 2018 14:00:12 +0100
MIME-Version: 1.0
In-Reply-To: <20181022085910.2gndxc75zcqkto5z@gofer.mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-10-22 10:59, Sean Young wrote:
> On Sat, Oct 20, 2018 at 11:12:16PM +0200, Hans Verkuil wrote:
>> Hi Sean,
>>
>> Can you take a look at this, it appears to be an RC issue, see my analysis below.
>>
>> On 10/20/2018 03:26 PM, Torbjorn Jansson wrote:
>>> Hello
>>>
>>> i'm using the pulse8 usb cec adapter to control my tv.
>>> i have a few scripts that poll the power status of my tv and after a while it stops working returning errors when trying to check if tv is on or off.
>>> this i think matches a kernel oops i'm seeing that i suspect is related to this.
>>>
>>> i have sometimes been able to recover from this problem by completely cutting power to my tv and also unplugging the usb cec adapter.
>>> i have a feeling that the tv is at least partly to blame for cec-ctl not working but in any case there shouldn't be a kernel oops.
>>>
>>>
>>> also every now and then i see this in dmesg:
>>> cec cec0: transmit: failed 05
>>> cec cec0: transmit: failed 06
>>> but that doesn't appear to do any harm as far as i can tell.
>>>
>>> any idea whats causing the oops?
>>>
>>> the ops:
>>>
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>>> PGD 0 P4D 0
>>> Oops: 0000 [#1] SMP PTI
>>> CPU: 9 PID: 27687 Comm: kworker/9:2 Tainted: P           OE 4.18.12-200.fc28.x86_64 #1
>>> Hardware name: Supermicro C7X99-OCE-F/C7X99-OCE-F, BIOS 2.1a 06/15/2018
>>> Workqueue: events pulse8_irq_work_handler [pulse8_cec]
>>> RIP: 0010:ir_lirc_scancode_event+0x3d/0xb0 [rc_core]
>>
>> Huh. ir_lirc_scancode_event() calls spin_lock_irqsave(&dev->lirc_fh_lock, flags);
>>
>> The spinlock dev->lirc_fh_lock is initialized in ir_lirc_register(), which is called
>> from rc_register_device(), except when the protocol is CEC:
>>
>>          /* Ensure that the lirc kfifo is setup before we start the thread */
>>          if (dev->allowed_protocols != RC_PROTO_BIT_CEC) {
>>                  rc = ir_lirc_register(dev);
>>                  if (rc < 0)
>>                          goto out_rx;
>>          }
>>
>> So it looks like ir_lirc_scancode_event() fails because dev->lirc_fh_lock was never
>> initialized.
>>
>> Could this be fall-out from the lirc changes you did not too long ago?
> 
> Yes, this is broken. My bad, sorry. I think this must have been broken since
> v4.16. I can write a patch but I don't have a patch but I'm on the train
> to ELCE in Edinburgh now, with no hardware to test on.
> 
> 
> Sean

since there now is a patch that appears to be working and fixing this problem 
i'd like to ask for some troubleshooting advice with another cec issue i have 
that i haven't figured out why it is happening and exactly whats causing it.

i'm not sure if it is a hardware issue or a software issue or both.

this is what is happening:
i have a script that polls the tv for current status by running:
cec-ctl --to=0 --give-device-power-status
after a fresh reboot this works fine for a while then sometime later it stops 
working and errors with:
-
# cec-ctl --to=0 --give-device-power-status
Driver Info:
         Driver Name                : pulse8-cec
         Adapter Name               : serio0
         Capabilities               : 0x0000003f
                 Physical Address
                 Logical Addresses
                 Transmit
                 Passthrough
                 Remote Control Support
                 Monitor All
         Driver version             : 4.18.16
         Available Logical Addresses: 1
         Physical Address           : 1.4.0.0
         Logical Address Mask       : 0x0800
         CEC Version                : 2.0
         Vendor ID                  : 0x000c03
         Logical Addresses          : 1 (Allow RC Passthrough)

           Logical Address          : 11 (Playback Device 3)
             Primary Device Type    : Playback
             Logical Address Type   : Playback
             All Device Types       : Playback
             RC TV Profile          : None
             Device Features        :
                 None


Transmit from Playback Device 3 to TV (11 to 0):
CEC_MSG_GIVE_DEVICE_POWER_STATUS (0x8f)
         Sequence: 119437 Tx Timestamp: 865389.535s
         Tx, Error (1), Max Retries
-

once this happens i can never get back any status and also running:
cec-ctl -M
gives me a lot of:
Transmitted by Playback Device 3 to TV (11 to 0): 
CEC_MSG_GIVE_DEVICE_POWER_STATUS (0x8f)
         Tx, Error (1), Max Retries
once for every run of my status checking script.

i know polling like this is not the best option and a better way would be to 
listen for events and then take action when status changes but that's not 
easily doable with what i need it for.

anyway, once i start getting the above errors when i poll it will not give me 
back any good status any more (everything errors out)

also sending commands to tv to turn on or off like:
cec-ctl --to=0 --image-view-on
or
cec-ctl --to=0 --standby
doesn't work.

BUT if i remove power to tv and wait for standby led to go out completely then 
power it back on i can use above two commands to turn on/off the tv even when 
they return errors and i still can't poll for current status.

so even with the errors always returned at this stage the on/off commands still 
gets sent and works.

do you think this behavior is a sw or hw issue or both?


if i'm not mistaken i could unplug usb cable to pulse8 cec adapter and reinsert 
to make it work properly again (no errors and correct response like a fresh start)
but i'm not 100% sure of this.
when i tried it now i get a new kernel oops:
-
[866129.392139] usb 7-2: USB disconnect, device number 3
[866129.409568] cdc_acm 7-2:1.1: acm_start_wb - usb_submit_urb(write bulk) 
failed: -19
[866129.409576] cdc_acm 7-2:1.1: acm_start_wb - usb_submit_urb(write bulk) 
failed: -19
[866129.409635] WARNING: CPU: 10 PID: 1571 at drivers/media/cec/cec-adap.c:1243 
cec_adap_unconfigure+0x9c/0xa0 [cec]
[866129.409639] Modules linked in: loop fuse 8021q garp mrp xt_CHECKSUM 
iptable_mangle ip6t_REJECT nf_reject_ipv6 tun xt_nat macvlan ebtable_filter 
ebtables xfs devlink ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype xt_conntrack nf_nat nf_conntrack 
br_netfilter bridge stp llc nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs 
fscache target_core_user uio target_core_pscsi target_core_file 
target_core_iblock iscsi_target_mod target_core_mod bonding ip6table_filter 
ip6_tables nct6775 rc_cec hwmon_vid pulse8_cec cec vfat fat dm_multipath 
scsi_dh_rdac scsi_dh_emc scsi_dh_alua nvidia_drm(POE) nvidia_modeset(POE) 
intel_rapl snd_hda_codec_hdmi nvidia_uvm(POE) x86_pkg_temp_thermal 
intel_powerclamp cx25840 coretemp nvidia(POE) joydev rc_tt_1500 sp2 si2157 
si2168 snd_hda_codec_realtek
[866129.409707]  kvm_intel snd_hda_codec_generic snd_hda_intel cx23885 kvm 
snd_hda_codec altera_ci tda18271 iTCO_wdt iTCO_vendor_support snd_hda_core 
altera_stapl crct10dif_pclmul tveeprom crc32_pclmul ir_rc6_decoder cx2341x 
ghash_clmulni_intel videobuf2_dma_sg dvb_usb_dvbsky videobuf2_memops dvb_usb_v2 
intel_cstate videobuf2_dvb snd_hwdep videobuf2_v4l2 m88ds3103 snd_seq 
videobuf2_common intel_uncore rc_rc6_mce cp210x snd_seq_device dvb_core mceusb 
intel_rapl_perf snd_pcm cdc_acm rc_core v4l2_common videodev ipmi_ssif 
drm_kms_helper snd_timer snd media drm i2c_mux mei_me i2c_i801 soundcore mei 
lpc_ich ipmi_si ipmi_devintf ipmi_msghandler pcc_cpufreq nfsd auth_rpcgss 
binfmt_misc nfs_acl lockd grace sunrpc dm_thin_pool dm_cache_smq dm_cache 
dm_persistent_data libcrc32c dm_bio_prison mxm_wmi uas crc32c_intel
[866129.409778]  igb usb_storage megaraid_sas dca i2c_algo_bit wmi vfio_pci 
irqbypass vfio_virqfd vfio_iommu_type1 vfio i2c_dev
[866129.409795] CPU: 10 PID: 1571 Comm: inputattach Tainted: P           OE 
4.18.16-200.local.fc28.x86_64 #1
[866129.409798] Hardware name: Supermicro C7X99-OCE-F/C7X99-OCE-F, BIOS 2.1a 
06/15/2018
[866129.409804] RIP: 0010:cec_adap_unconfigure+0x9c/0xa0 [cec]
[866129.409806] Code: 2c 05 00 00 e8 c5 fa ff ff 48 8d bb 28 04 00 00 31 c9 ba 
01 00 00 00 be 01 00 00 00 e8 ad 9f 73 e8 48 89 df 5b e9 a4 fe ff ff <0f> 0b eb 
98 0f 1f 44 00 00 41 57 4c 8d bf c8 03 00 00 41 56 41 55
[866129.409859] RSP: 0018:ffff9d02872b7cf0 EFLAGS: 00010286
[866129.409863] RAX: 00000000ffffffff RBX: ffff8a65f158c800 RCX: 0000000000000000
[866129.409866] RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8a65f5626b00
[866129.409869] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8a65f0437d88
[866129.409872] R10: 0000000000000000 R11: ffffffffaa9a41ee R12: 000000000000ffff
[866129.409875] R13: ffff8a65f158cb80 R14: 0000000000000060 R15: 0000000000000000
[866129.409879] FS:  00007f3bc63e4740(0000) GS:ffff8a65ff480000(0000) 
knlGS:0000000000000000
[866129.409882] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[866129.409885] CR2: 00007f681a1c4380 CR3: 000000102944e001 CR4: 00000000003606e0
[866129.409889] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[866129.409892] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[866129.409894] Call Trace:
[866129.409905]  __cec_s_phys_addr+0x78/0x220 [cec]
[866129.409911]  cec_unregister_adapter+0xd3/0x120 [cec]
[866129.409917]  pulse8_disconnect+0x1a/0x60 [pulse8_cec]
[866129.409926]  serio_disconnect_driver+0x31/0x40
[866129.409930]  serio_driver_remove+0x11/0x20
[866129.409938]  device_release_driver_internal+0x180/0x250
[866129.409944]  serio_unregister_port+0x1d/0x40
[866129.409950]  serport_ldisc_read+0x132/0x190
[866129.409958]  ? finish_wait+0x80/0x80
[866129.409966]  tty_read+0x94/0x120
[866129.409974]  __vfs_read+0x36/0x180
[866129.409979]  vfs_read+0x8a/0x140
[866129.409984]  ksys_read+0x4f/0xb0
[866129.409992]  do_syscall_64+0x5b/0x160
[866129.410000]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[866129.410005] RIP: 0033:0x7f3bc5b8de21
[866129.410007] Code: fe ff ff 50 48 8d 3d 46 b6 09 00 e8 f9 04 02 00 66 0f 1f 
84 00 00 00 00 00 48 8d 05 c1 3b 2d 00 8b 00 85 c0 75 13 31 c0 0f 05 <48> 3d 00 
f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54 49 89 d4 55 48
[866129.410060] RSP: 002b:00007ffd9bda4508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[866129.410064] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f3bc5b8de21
[866129.410066] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
[866129.410069] RBP: 00007ffd9bda453c R08: 00007ffd9bda4490 R09: 0000000000000010
[866129.410072] R10: fffffffffffffac5 R11: 0000000000000246 R12: 00007f3bc63e46c0
[866129.410075] R13: 00007ffd9bda4678 R14: 0000000000000010 R15: 0000000000604e10
[866129.410079] ---[ end trace 5c8dcc19f7a6ee3c ]---
[866129.410219] pulse8-cec serio0: disconnected
[866129.410294] cdc_acm 7-2:1.0: failed to set dtr/rts
-

advice?
