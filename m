Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:60212 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763779AbZARKzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 05:55:51 -0500
Received: by ug-out-1314.google.com with SMTP id 39so134441ugf.37
        for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 02:55:47 -0800 (PST)
Message-ID: <49730AAA.4030209@byteworkshop.co.uk>
Date: Sun, 18 Jan 2009 10:55:38 +0000
From: Tony Broad <tony@byteworkshop.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: budget.c driver: Kernel oops: "BUG: unable to handle kernel paging
 request at ffffffff"
Content-Type: multipart/mixed;
 boundary="------------060402040603020802080803"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060402040603020802080803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I'm using a "Hauppauge WinTV-NOVA-T DVB card" of PCI id "13c2:1005" with
kernel 2.6.27.9.

I've recently experienced the following fairly consistent kernel oops on
startup in grundig_29504_401_tuner_set_params from budget.c. As you
might expect, following this failure, the card doesn't work.

I'm not a kernel developer, nevertheless I seem to have managed to track
this down to a non-existent initialisation of
budget->dvb_frontend->tuner_priv.

The attached patch fixes the problem for me (and I've managed to tune
the card successfully as a result), but I don't know of anyone else
using the driver so I can't test it on other people.

Please let me know if this works for you or if I've done something
terribly wrong ;-(

Cheers,

Tony
--

Kernel failure message 1:
BUG: unable to handle kernel paging request at ffffffff
IP: [<f8981e11>] :budget:grundig_29504_401_tuner_set_params+0x3b/0xf8
*pde = 007e0067 *pte = 00000000
Oops: 0000 [#1] SMP
Modules linked in: bridge stp bnep rfcomm l2cap asb100 hwmon_vid hwmon
fuse ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT
xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter
ip6_tables x_tables ipv6 loop dm_multipath scsi_dh ppdev snd_cmipci
gameport snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_pcm_oss snd_mixer_oss l64781 snd_pcm snd_page_alloc snd_opl3_lib
snd_timer parport_pc snd_hwdep parport btusb snd_mpu401_uart budget
budget_core snd_rawmidi bluetooth saa7146 snd_seq_device ttpci_eeprom
snd soundcore sr_mod i2c_sis96x cdrom dvb_core sis900 i2c_core floppy
pcspkr mii sata_sil sg dm_snapshot dm_zero dm_mirror dm_log dm_mod
pata_sis ata_generic pata_acpi libata sd_mod scsi_mod crc_t10dif ext3
jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]

Pid: 2319, comm: kdvb-fe-0 Not tainted (2.6.27.9-73.fc9.i686 #1)
EIP: 0060:[<f8981e11>] EFLAGS: 00010286 CPU: 0
EIP is at grundig_29504_401_tuner_set_params+0x3b/0xf8 [budget]
EAX: f6417f00 EBX: f6f53808 ECX: 00000000 EDX: ffffffff
ESI: f6f94404 EDI: f6417f00 EBP: f6417f10 ESP: f6417ef0
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kdvb-fe-0 (pid: 2319, ti=f6417000 task=f642b2c0 task.ti=f6417000)
Stack: f6e39800 00000000 00000004 f6417f00 c064523c f6f53808 f6f53800
f6f94404
        f6417f54 f8b2e45a f6417f24 00000286 f6417f4c f6417f38 00000000
00000286
        f6417f3c c064520f f642b2c0 f6417f6c c064456f 00000001 f6f94400
00000001
Call Trace:
  [<c064523c>] ? _spin_lock_irqsave+0x29/0x30
  [<f8b2e45a>] ? apply_frontend_param+0x27/0x357 [l64781]
  [<c064520f>] ? _spin_lock_irq+0x1c/0x20
  [<c064456f>] ? __down_common+0x91/0xbf
  [<f894f25d>] ? dvb_frontend_swzigzag_autotune+0x17d/0x1a4 [dvb_core]
  [<f894f780>] ? dvb_frontend_swzigzag+0x1ac/0x209 [dvb_core]
  [<f894fcc8>] ? dvb_frontend_thread+0x2eb/0x3b3 [dvb_core]
  [<c043c166>] ? autoremove_wake_function+0x0/0x33
  [<f894f9dd>] ? dvb_frontend_thread+0x0/0x3b3 [dvb_core]
  [<c043bec3>] ? kthread+0x3b/0x61
  [<c043be88>] ? kthread+0x0/0x61
  [<c040494b>] ? kernel_thread_helper+0x7/0x10
  =======================
Code: ec 14 8b 80 00 02 00 00 8b 93 08 02 00 00 8d 7d e4 8b 40 20 89 45
e0 31 c0 85 d2 f3 ab 8d 45 f0 66 c7 45 e8 04 00 89 45 ec 74 09 <0f> b6
02 66 89 45 e4 eb 06 66 c7 45 e4 61 00 8b 0e be 0a 8b 02
EIP: [<f8981e11>] grundig_29504_401_tuner_set_params+0x3b/0xf8 [budget]
SS:ESP 0068:f6417ef0
---[ end trace a5d7a53bd60d29d2 ]---


--------------060402040603020802080803
Content-Type: text/plain;
 name="kerneloops.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kerneloops.txt"

Kernel failure message 1:
BUG: unable to handle kernel paging request at ffffffff
IP: [<f8981e11>] :budget:grundig_29504_401_tuner_set_params+0x3b/0xf8
*pde = 007e0067 *pte = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: bridge stp bnep rfcomm l2cap asb100 hwmon_vid hwmon fuse ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop dm_multipath scsi_dh ppdev snd_cmipci gameport snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss l64781 snd_pcm snd_page_alloc snd_opl3_lib snd_timer parport_pc snd_hwdep parport btusb snd_mpu401_uart budget budget_core snd_rawmidi bluetooth saa7146 snd_seq_device ttpci_eeprom snd soundcore sr_mod i2c_sis96x cdrom dvb_core sis900 i2c_core floppy pcspkr mii sata_sil sg dm_snapshot dm_zero dm_mirror dm_log dm_mod pata_sis ata_generic pata_acpi libata sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]

Pid: 2319, comm: kdvb-fe-0 Not tainted (2.6.27.9-73.fc9.i686 #1)
EIP: 0060:[<f8981e11>] EFLAGS: 00010286 CPU: 0
EIP is at grundig_29504_401_tuner_set_params+0x3b/0xf8 [budget]
EAX: f6417f00 EBX: f6f53808 ECX: 00000000 EDX: ffffffff
ESI: f6f94404 EDI: f6417f00 EBP: f6417f10 ESP: f6417ef0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kdvb-fe-0 (pid: 2319, ti=f6417000 task=f642b2c0 task.ti=f6417000)
Stack: f6e39800 00000000 00000004 f6417f00 c064523c f6f53808 f6f53800 f6f94404 
       f6417f54 f8b2e45a f6417f24 00000286 f6417f4c f6417f38 00000000 00000286 
       f6417f3c c064520f f642b2c0 f6417f6c c064456f 00000001 f6f94400 00000001 
Call Trace:
 [<c064523c>] ? _spin_lock_irqsave+0x29/0x30
 [<f8b2e45a>] ? apply_frontend_param+0x27/0x357 [l64781]
 [<c064520f>] ? _spin_lock_irq+0x1c/0x20
 [<c064456f>] ? __down_common+0x91/0xbf
 [<f894f25d>] ? dvb_frontend_swzigzag_autotune+0x17d/0x1a4 [dvb_core]
 [<f894f780>] ? dvb_frontend_swzigzag+0x1ac/0x209 [dvb_core]
 [<f894fcc8>] ? dvb_frontend_thread+0x2eb/0x3b3 [dvb_core]
 [<c043c166>] ? autoremove_wake_function+0x0/0x33
 [<f894f9dd>] ? dvb_frontend_thread+0x0/0x3b3 [dvb_core]
 [<c043bec3>] ? kthread+0x3b/0x61
 [<c043be88>] ? kthread+0x0/0x61
 [<c040494b>] ? kernel_thread_helper+0x7/0x10
 =======================
Code: ec 14 8b 80 00 02 00 00 8b 93 08 02 00 00 8d 7d e4 8b 40 20 89 45 e0 31 c0 85 d2 f3 ab 8d 45 f0 66 c7 45 e8 04 00 89 45 ec 74 09 <0f> b6 02 66 89 45 e4 eb 06 66 c7 45 e4 61 00 8b 0e be 0a 8b 02 
EIP: [<f8981e11>] grundig_29504_401_tuner_set_params+0x3b/0xf8 [budget] SS:ESP 0068:f6417ef0
---[ end trace a5d7a53bd60d29d2 ]---




--------------060402040603020802080803
Content-Type: text/plain;
 name="ObjDump.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ObjDump.txt"

00000dd6 <grundig_29504_401_tuner_set_params>:
     dd6:       55                      push   %ebp
     dd7:       b9 03 00 00 00          mov    $0x3,%ecx
     ddc:       89 e5                   mov    %esp,%ebp
     dde:       57                      push   %edi
     ddf:       56                      push   %esi
     de0:       89 d6                   mov    %edx,%esi
     de2:       53                      push   %ebx
     de3:       89 c3                   mov    %eax,%ebx
     de5:       83 ec 14                sub    $0x14,%esp
     de8:       8b 80 00 02 00 00       mov    0x200(%eax),%eax
     dee:       8b 93 08 02 00 00       mov    0x208(%ebx),%edx
     df4:       8d 7d e4                lea    -0x1c(%ebp),%edi
     df7:       8b 40 20                mov    0x20(%eax),%eax
     dfa:       89 45 e0                mov    %eax,-0x20(%ebp)
     dfd:       31 c0                   xor    %eax,%eax
     dff:       85 d2                   test   %edx,%edx
     e01:       f3 ab                   rep stos %eax,%es:(%edi)
     e03:       8d 45 f0                lea    -0x10(%ebp),%eax
     e06:       66 c7 45 e8 04 00       movw   $0x4,-0x18(%ebp)
     e0c:       89 45 ec                mov    %eax,-0x14(%ebp)
     e0f:       74 09                   je     e1a <grundig_29504_401_tuner_set_params+0x44>
     e11:       0f b6 02                movzbl (%edx),%eax
     e14:       66 89 45 e4             mov    %ax,-0x1c(%ebp)
     e18:       eb 06                   jmp    e20 <grundig_29504_401_tuner_set_params+0x4a>
     e1a:       66 c7 45 e4 61 00       movw   $0x61,-0x1c(%ebp)
     e20:       8b 0e                   mov    (%esi),%ecx
     e22:       be 0a 8b 02 00          mov    $0x28b0a,%esi
     e27:       8d 91 48 39 27 02       lea    0x2273948(%ecx),%edx
     e2d:       89 d0                   mov    %edx,%eax
     e2f:       31 d2                   xor    %edx,%edx
     e31:       f7 f6                   div    %esi


        struct budget *budget = fe->dvb->priv;
     df7:    8b 40 20                  mov    0x20(%eax),%eax
     dfa:    89 45 e0                  mov    %eax,-0x20(%ebp)
        u8 *tuner_addr = fe->tuner_priv;
        u32 div;
        u8 cfg, cpump, band_select;
        u8 data[4];
        struct i2c_msg msg = { .flags = 0, .buf = data, .len = sizeof(data) };
     dfd:    31 c0                     xor    %eax,%eax

        if (tuner_addr)
     dff:    85 d2                     test   %edx,%edx
        struct budget *budget = fe->dvb->priv;
        u8 *tuner_addr = fe->tuner_priv;
        u32 div;
        u8 cfg, cpump, band_select;
        u8 data[4];
        struct i2c_msg msg = { .flags = 0, .buf = data, .len = sizeof(data) };
     e01:    f3 ab                     rep stos %eax,%es:(%edi)
     e03:    8d 45 f0                  lea    -0x10(%ebp),%eax
     e06:    66 c7 45 e8 04 00         movw   $0x4,-0x18(%ebp)
     e0c:    89 45 ec                  mov    %eax,-0x14(%ebp)

        if (tuner_addr)
     e0f:    74 09                     je     e1a <grundig_29504_401_tuner_set_params+0x44>
             msg.addr = *tuner_addr;
     e11:    0f b6 02                  movzbl (%edx),%eax
     e14:    66 89 45 e4               mov    %ax,-0x1c(%ebp)
     e18:    eb 06                     jmp    e20 <grundig_29504_401_tuner_set_params+0x4a>


--------------060402040603020802080803
Content-Type: text/plain;
 name="linux-2.6.27-budget-dvb-set-params-oops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.27-budget-dvb-set-params-oops.patch"

diff -uNrp kernel-2.6.27.orig/drivers/media/dvb/ttpci/budget.c kernel-2.6.27.new/drivers/media/dvb/ttpci/budget.c
--- kernel-2.6.27.orig/drivers/media/dvb/ttpci/budget.c	2009-01-12 18:18:17.000000000 +0000
+++ kernel-2.6.27.new/drivers/media/dvb/ttpci/budget.c	2009-01-12 18:18:55.000000000 +0000
@@ -460,6 +460,7 @@ static void frontend_init(struct budget 
 		budget->dvb_frontend = dvb_attach(l64781_attach, &grundig_29504_401_config, &budget->i2c_adap);
 		if (budget->dvb_frontend) {
 			budget->dvb_frontend->ops.tuner_ops.set_params = grundig_29504_401_tuner_set_params;
+			budget->dvb_frontend->tuner_priv = NULL;
 			break;
 		}
 		break;


--------------060402040603020802080803--
