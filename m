Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59186 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3AYVik (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 16:38:40 -0500
Received: by mail-ee0-f45.google.com with SMTP id b57so417060eek.18
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 13:38:39 -0800 (PST)
Message-ID: <5102FB5A.40000@gmail.com>
Date: Fri, 25 Jan 2013 22:38:34 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: j@jannau.net, jarod@redhat.com
Subject: [PATCH] crystalhd git.linuxtv.org kernel driver: FIX null pointer
 BUG in crystalhd_dioq_fetch_wait() on queue(s) overload
References: <50E3E643.7070701@gmail.com> <50E5A116.9070307@schinagl.nl> <50E8203C.20603@gmail.com> <50EB5B44.6020603@gmail.com> <50EF6042.7010908@gmail.com>
In-Reply-To: <50EF6042.7010908@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060505050403040808030702"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060505050403040808030702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch should pass at least one test case of this bug.

Signed-off-by: Thomas Schorpp <thomas.schorpp@gmail.com>

y
tom

8043-Jan 24 18:33:14 tom3 kernel: [  457.636878] BUG: unable to handle kernel NULL pointer dereference at 000000000000002c
8044:Jan 24 18:33:14 tom3 kernel: [  457.637016] IP: [<ffffffffa043a14c>] crystalhd_dioq_fetch_wait+0x25c/0x410 [crystalhd]
8045-Jan 24 18:33:14 tom3 kernel: [  457.637150] PGD 631fe067 PUD 57474067 PMD 0
8046-Jan 24 18:33:14 tom3 kernel: [  457.637238] Oops: 0000 [#1] PREEMPT SMP
8047-Jan 24 18:33:14 tom3 kernel: [  457.637326] CPU 0
8048-Jan 24 18:33:14 tom3 kernel: [  457.637361] Modules linked in: uinput parport_pc ppdev lp parport bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs acpi_cpufreq mperf cpufreq_powersave cpufreq_stats cpufreq_conservative cpufreq_performance cpufreq_ondemand freq_table fuse dm_mod ext3 jbd pciehp arc4 ath5k ath snd_hda_codec_analog mac80211 cfg80211 snd_hda_intel snd_hda_codec snd_usb_audio thinkpad_acpi snd_pcm_oss snd_mixer_oss snd_hwdep rfkill snd_pcm snd_usbmidi_lib snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device gspca_zc3xx gspca_main snd videodev pcmcia usb_storage v4l2_compat_ioctl32 psmouse yenta_socket tpm_tis pcmcia_rsrc crystalhd(O) snd_page_alloc soundcore tpm pcmcia_core tpm_bios pcspkr serio_raw i2c_i801 nvram wmi rtc_cmos battery ac evdev processor nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit xt_tcpudp iptable_filter ip_tables x
_tables ext4 mbcache jbd2 crc16
8049-Jan 24 18:33:14 tom3 kernel: usbhid hid sg sd_mod crc_t10dif ata_generic uhci_hcd ahci libahci ata_piix atkbd libata thermal xhci_hcd ehci_hcd usbcore e1000e usb_common [last unloaded: scsi_wait_scan]
8050-Jan 24 18:33:14 tom3 kernel: [  457.637841]
8051-Jan 24 18:33:14 tom3 kernel: [  457.637841] Pid: 6318, comm: ffmpeg Tainted: G           O 3.2.36-dirty #7 LENOVO 7735Y1T/7735Y1T
8052:Jan 24 18:33:14 tom3 kernel: [  457.637841] RIP: 0010:[<ffffffffa043a14c>]  [<ffffffffa043a14c>] crystalhd_dioq_fetch_wait+0x25c/0x410 [crystalhd]
8053-Jan 24 18:33:14 tom3 kernel: [  457.637841] RSP: 0018:ffff88006300dd48  EFLAGS: 00010246
8054-Jan 24 18:33:14 tom3 kernel: [  457.637841] RAX: 0000000000000000 RBX: ffff88007b1cde50 RCX: 0000000000000000
8055-Jan 24 18:33:14 tom3 kernel: [  457.637841] RDX: 0000000000000046 RSI: ffffffffa04395c3 RDI: ffffffff81493e82
8056-Jan 24 18:33:14 tom3 kernel: [  457.637841] RBP: ffff88006300ddf8 R08: 0000000000000000 R09: 0000000000000000
8057-Jan 24 18:33:14 tom3 kernel: [  457.637841] R10: 0000000000000000 R11: ffff88007b1ce510 R12: ffff88007a855d80
8058-Jan 24 18:33:14 tom3 kernel: [  457.637841] R13: 0000000000000000 R14: ffff88007a855da8 R15: ffff88007b1cde50
8059-Jan 24 18:33:14 tom3 kernel: [  457.637841] FS:  00007f559fa7b760(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
8060-Jan 24 18:33:14 tom3 kernel: [  457.637841] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
8061-Jan 24 18:33:14 tom3 kernel: [  457.637841] CR2: 000000000000002c CR3: 0000000057470000 CR4: 00000000000006f0
8062-Jan 24 18:33:14 tom3 kernel: [  457.637841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
8063-Jan 24 18:33:14 tom3 kernel: [  457.637841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
8064-Jan 24 18:33:14 tom3 kernel: [  457.637841] Process ffmpeg (pid: 6318, threadinfo ffff88006300c000, task ffff88007b1cde50)
8065-Jan 24 18:33:14 tom3 kernel: [  457.637841] Stack:
8066-Jan 24 18:33:14 tom3 kernel: [  457.637841]  0000000000000327 ffff88007b1ce510 ffff88006b199400 ffff88007c1b1090
8067-Jan 24 18:33:14 tom3 kernel: [  457.637841]  ffff88006300de14 ffff8800594145b0 ffff880059414400 ffff88007b1cde50
8068-Jan 24 18:33:14 tom3 kernel: [  457.637841]  ffff88007a855de0 0000000100026d5c 0000000000000000 ffff88007b1cde50
8069-Jan 24 18:33:14 tom3 kernel: [  457.637841] Call Trace:
8070-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffff810497e0>] ? try_to_wake_up+0x260/0x260
8071-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffffa043b7b0>] ? bc_cproc_start_capture+0x100/0x100 [crystalhd]
8072-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffffa043d566>] crystalhd_hw_get_cap_buffer+0x56/0x1a0 [crystalhd]
8073-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffffa043b83d>] bc_cproc_fetch_frame+0x8d/0x1b0 [crystalhd]
8074-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffffa0438db1>] chd_dec_api_cmd+0x81/0x100 [crystalhd]
8075-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffffa0438ec0>] chd_dec_ioctl+0x90/0x170 [crystalhd]
8076-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffff811704bc>] do_vfs_ioctl+0x9c/0x330
8077-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffff8115ebb0>] ? fget_light+0x40/0x140
8078-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffff8108d9bd>] ? trace_hardirqs_on_caller+0x11d/0x1b0
8079-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffff8117079f>] sys_ioctl+0x4f/0x80
8080-Jan 24 18:33:14 tom3 kernel: [  457.637841]  [<ffffffff8149b6eb>] system_call_fastpath+0x16/0x1b
8081-Jan 24 18:33:14 tom3 kernel: [  457.637841] Code: 89 f7 e8 18 9d 05 e1 45 85 ed 75 81 48 8b bd 78 ff ff ff e8 77 17 c4 e0 85 c0 0f 85 c7 00 00 00 4c 89 e7 e8 57 f3 ff ff 49 89 c0 <f6> 40 2c 03 0f 85 3d 01 00 00 48 8b 4d 80 48 8b 81 d0 00 00 00
8082:Jan 24 18:33:14 tom3 kernel: [  457.637841] RIP  [<ffffffffa043a14c>] crystalhd_dioq_fetch_wait+0x25c/0x410 [crystalhd]
8083-Jan 24 18:33:14 tom3 kernel: [  457.637841]  RSP <ffff88006300dd48>
8084-Jan 24 18:33:14 tom3 kernel: [  457.637841] CR2: 000000000000002c
8085-Jan 24 18:33:14 tom3 kernel: [  457.663980] ---[ end trace 784283982dcd2475 ]---

8081-Jan 24 18:33:14 tom3 kernel: [ 457.637841] Code: 89 f7 e8 18 9d 05 e1 45 85 ed 75 81 48 8b bd 78 ff ff ff e8 77 17 c4 e0 85 c0 0f 85 c7 00 00 00 4c 89 e7 e8 57 f3 ff ff 49 89 c0 <f6> 40 2c 03 0f 85 3d 01 00 00 48 8b 4d 80 48 8b 81 d0 00 00 00

$ linux-stable/scripts/decodecode < oops.txt
All code
========
    0:	89 f7                	mov    %esi,%edi
    2:	e8 18 9d 05 e1       	callq  0xffffffffe1059d1f
    7:	45 85 ed             	test   %r13d,%r13d
    a:	75 81                	jne    0xffffffffffffff8d
    c:	48 8b bd 78 ff ff ff 	mov    -0x88(%rbp),%rdi
   13:	e8 77 17 c4 e0       	callq  0xffffffffe0c4178f
   18:	85 c0                	test   %eax,%eax
   1a:	0f 85 c7 00 00 00    	jne    0xe7
   20:	4c 89 e7             	mov    %r12,%rdi
   23:	e8 57 f3 ff ff       	callq  0xfffffffffffff37f
   28:	49 89 c0             	mov    %rax,%r8
   2b:*	f6 40 2c 03          	testb  $0x3,0x2c(%rax)     <-- trapping instruction
   2f:	0f 85 3d 01 00 00    	jne    0x172
   35:	48 8b 4d 80          	mov    -0x80(%rbp),%rcx
   39:	48 8b 81 d0 00 00 00 	mov    0xd0(%rcx),%rax

Code starting with the faulting instruction
===========================================
    0:	f6 40 2c 03          	testb  $0x3,0x2c(%rax)
    4:	0f 85 3d 01 00 00    	jne    0x147
    a:	48 8b 4d 80          	mov    -0x80(%rbp),%rcx
    e:	48 8b 81 d0 00 00 00 	mov    0xd0(%rcx),%rax

$ gdb /mnt/data/usr/local/src/crystalhd/driver/linux/crystalhd.ko
(gdb) l *(crystalhd_dioq_fetch_wait + 604)
0x216c is in crystalhd_dioq_fetch_wait (/mnt/data/usr/local/src/crystalhd/driver/linux/crystalhd_misc.c:516).
511				/* Lock against checks from get status calls */
512				if(down_interruptible(&hw->fetch_sem))
513					goto sem_error;
514				r_pkt = crystalhd_dioq_fetch(ioq);
515				/* If format change packet, then return with out checking anything */
516				if (r_pkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE)) <--- x86 testb instruction XXXXXX
517					goto sem_rel_return;
518				if (hw->adp->pdev->device == BC_PCI_DEVID_LINK) {
519					picYcomp = link_GetRptDropParam(hw, hw->PICHeight, hw->PICWidth, (void *)r_pkt);
520				}
(gdb) l *(crystalhd_dioq_fetch_wait + 0x410)
0x2320 is in bc_kern_dma_free (/mnt/data/usr/local/src/crystalhd/driver/linux/crystalhd_misc.c:262).
257	 * Return:
258	 *     none.
259	 */
260	void bc_kern_dma_free(struct crystalhd_adp *adp, uint32_t sz, void *ka,
261			      dma_addr_t phy_addr)
262	{
263		if (!adp || !ka || !sz || !phy_addr) {
264			printk(KERN_ERR "%s: Invalid arg\n", __func__);
265			return;
266		}

--------------060505050403040808030702
Content-Type: text/x-diff;
 name="crystalhd-nullpointer-bugfix.schorpp.01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crystalhd-nullpointer-bugfix.schorpp.01.patch"

diff --git a/driver/linux/crystalhd_misc.c b/driver/linux/crystalhd_misc.c
index 410ab9d..b3ce457 100644
--- a/driver/linux/crystalhd_misc.c
+++ b/driver/linux/crystalhd_misc.c
@@ -512,7 +512,10 @@ void *crystalhd_dioq_fetch_wait(struct crystalhd_hw *hw, uint32_t to_secs, uint3
 			if(down_interruptible(&hw->fetch_sem))
 				goto sem_error;
 			r_pkt = crystalhd_dioq_fetch(ioq);
-			/* If format change packet, then return with out checking anything */
+			/* If no packet then up and return zero otherwise will *0 BUG the kernel on heavy dioq load */
+			if (!r_pkt) 
+				goto sem_rel_return;
+			/* If format change packet then return without checking anything */
 			if (r_pkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE))
 				goto sem_rel_return;
 			if (hw->adp->pdev->device == BC_PCI_DEVID_LINK) {

--------------060505050403040808030702--
