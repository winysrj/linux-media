Return-path: <mchehab@pedra>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:56481 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752043Ab1ANRL0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 12:11:26 -0500
Date: Fri, 14 Jan 2011 18:11:24 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Robin Humble <robin.humble+dvb@anu.edu.au>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dib7000m/p: struct alignment fix
In-Reply-To: <4D2E1386.6050801@redhat.com>
Message-ID: <alpine.LRH.2.00.1101141808260.6649@pub3.ifh.de>
References: <20110112131732.GA26294@grizzly.cita.utoronto.ca> <4D2E1386.6050801@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi again,

On Wed, 12 Jan 2011, Mauro Carvalho Chehab wrote:

> Em 12-01-2011 11:17, Robin Humble escreveu:
>> Hi,
>>
>> this is basically a re-post of
>>   http://www.linuxtv.org/pipermail/linux-dvb/2010-September/032744.html
>> which fixes an Oops when tuning eg. AVerMedia DVB-T Volar, Hauppauge
>> Nova-T, Winfast DTV. it seems to be quite commonly reported on this list.
>>
>>  [  809.128579] BUG: unable to handle kernel NULL pointer dereference at 0000000000000012
>>  [  809.128586] IP: [<ffffffffa0013702>] i2c_transfer+0x16/0x124 [i2c_core]
>>  [  809.128598] PGD 669a7067 PUD 79e5f067 PMD 0
>>  [  809.128604] Oops: 0000 [#1] SMP
>>  [  809.128608] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
>>  [  809.128612] CPU 0
>>  [  809.128614] Modules linked in: tcp_lp fuse coretemp hwmon_vid cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 xfs exportfs uinput mt2060 mxl5005s af9013 dvb_usb_dib0700 ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder dib7000p dib0090 dib7000m dvb_usb_af9015 dib0070 dvb_usb dib8000 dvb_core dib3000mc ir_rc6_decoder dibx000_common snd_hda_codec_intelhdmi ir_rc5_decoder snd_hda_codec_realtek snd_hda_intel ir_nec_decoder snd_hda_codec ldusb i2c_i801 snd_hwdep snd_seq snd_seq_device rc_core atl1 asus_atk0110 snd_pcm snd_timer mii snd soundcore snd_page_alloc iTCO_wdt iTCO_vendor_support microcode raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 ata_generic firewire_ohci pata_acpi firewire_core crc_itu_t pata_jmicron i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
>>  [  809.128692]
>>  [  809.128696] Pid: 2525, comm: tzap Not tainted 2.6.35.10-72.fc14.x86_64 #1 P5E-VM HDMI/P5E-VM HDMI
>>  [  809.128700] RIP: 0010:[<ffffffffa0013702>]  [<ffffffffa0013702>] i2c_transfer+0x16/0x124 [i2c_core]
>>  [  809.128708] RSP: 0018:ffff880064a83ae8  EFLAGS: 00010296
>>  [  809.128712] RAX: ffff880064a83b58 RBX: 00000000000000eb RCX: 0000000000000000
>>  [  809.128715] RDX: 0000000000000002 RSI: ffff880064a83b38 RDI: 0000000000000002
>>  [  809.128718] RBP: ffff880064a83b28 R08: ffff880079bcf7c0 R09: 0000000050000d80
>>  [  809.128721] R10: 0000000000000005 R11: 0000000000004a38 R12: 0000000000000001
>>  [  809.128725] R13: 0000000000000000 R14: ffffc900237e8000 R15: ffffc90023907000
>>  [  809.128729] FS:  00007f2ff2dd3720(0000) GS:ffff880002000000(0000) knlGS:0000000000000000
>>  [  809.128732] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  [  809.128736] CR2: 0000000000000012 CR3: 000000007830d000 CR4: 00000000000006f0
>>  [  809.128739] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>  [  809.128743] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>  [  809.128746] Process tzap (pid: 2525, threadinfo ffff880064a82000, task ffff8800379745c0)
>>  [  809.128749] Stack:
>>  [  809.128751]  ffff880064a83af8 ffffffff8103c142 ffff880079c41a90 00000000000000eb
>>  [  809.128757] <0> 0000000000000001 0000000000000000 ffffc900237e8000 ffffc90023907000
>>  [  809.128762] <0> ffff880064a83b88 ffffffffa0407124 0000000200000030 ffff880064a83b68
>>  [  809.128768] Call Trace:
>>  [  809.128776]  [<ffffffff8103c142>] ? need_resched+0x23/0x2d
>>  [  809.128783]  [<ffffffffa0407124>] dib7000p_read_word+0x6d/0xbc [dib7000p]
>>  [  809.128789]  [<ffffffff813360eb>] ? usb_submit_urb+0x2f8/0x33a
>>  [  809.128795]  [<ffffffffa0407ae5>] dib7000p_pid_filter_ctrl+0x2d/0x90 [dib7000p]
>>  [  809.128802]  [<ffffffffa044f35f>] stk70x0p_pid_filter_ctrl+0x19/0x1e [dvb_usb_dib0700]
>>  [  809.128809]  [<ffffffffa03b4ef9>] dvb_usb_ctrl_feed+0xd7/0x123 [dvb_usb]
>>  [  809.128815]  [<ffffffffa03b4f6a>] dvb_usb_start_feed+0x13/0x15 [dvb_usb]
>>  [  809.128825]  [<ffffffffa035585c>] dmx_ts_feed_start_filtering+0x7d/0xd1 [dvb_core]
>>  [  809.128833]  [<ffffffffa03539fc>] dvb_dmxdev_start_feed.clone.1+0xbd/0xeb [dvb_core]
>>  [  809.128841]  [<ffffffffa0353cf9>] dvb_dmxdev_filter_start+0x2cf/0x31b [dvb_core]
>>  [  809.128847]  [<ffffffff81469b66>] ? _raw_spin_lock_irq+0x1f/0x21
>>  [  809.128854]  [<ffffffffa035444b>] dvb_demux_do_ioctl+0x27b/0x4c0 [dvb_core]
>>  [  809.128859]  [<ffffffff8103c15a>] ? should_resched+0xe/0x2e
>>  [  809.128867]  [<ffffffffa03528f3>] dvb_usercopy+0xe4/0x16b [dvb_core]
>>  [  809.128874]  [<ffffffffa03541d0>] ? dvb_demux_do_ioctl+0x0/0x4c0 [dvb_core]
>>  [  809.128881]  [<ffffffff811e3718>] ? inode_has_perm.clone.20+0x79/0x8f
>>  [  809.128886]  [<ffffffff810668ec>] ? remove_wait_queue+0x35/0x41
>>  [  809.128891]  [<ffffffff81469b7f>] ? _raw_spin_unlock_irqrestore+0x17/0x19
>>  [  809.128898]  [<ffffffffa0352fd1>] dvb_demux_ioctl+0x15/0x19 [dvb_core]
>>  [  809.128903]  [<ffffffff8112419b>] vfs_ioctl+0x36/0xa7
>>  [  809.128908]  [<ffffffff81124afc>] do_vfs_ioctl+0x468/0x49b
>>  [  809.128912]  [<ffffffff81124b85>] sys_ioctl+0x56/0x79
>>  [  809.128917]  [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
>>  [  809.128920] Code: 89 55 f8 48 83 c7 58 48 c7 c2 47 32 01 a0 e8 92 09 2c e1 c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 0f 1f 44 00 00 <48> 8b 47 10 48 89 fb 49 89 f6 41 89 d7 48 83 38 00 0f 84 92 00
>>  [  809.128965] RIP  [<ffffffffa0013702>] i2c_transfer+0x16/0x124 [i2c_core]
>>  [  809.128973]  RSP <ffff880064a83ae8>
>>  [  809.128975] CR2: 0000000000000012
>>  [  809.128979] ---[ end trace 6919129d55f94398 ]---
>>
>> this Oops occurs for me on all >2.6.32 kernels, including the current
>> linux-media dvb git tree, and Fedora (13,14) kernels.
>>
>> Ubuntu has a bug open for the issue:
>>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/654791
>> but the disable pid filtering workaround one person uses there doesn't
>> work for me.

Could you try this patch:

http://git.linuxtv.org/pb/media_tree.git?a=commit;h=80a5f1fdc6beb496347cbb297f9c1458c8cb9f50

and report whether it solves the problem or not?

best regards,
Patrick.
