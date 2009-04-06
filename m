Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50894 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZDFAZQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 20:25:16 -0400
Subject: Test results for ir-kbd-i2c.c changes (Re: [PATCH 0/6] ir-kbd-i2c
	conversion to the new i2c binding model)
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>
In-Reply-To: <20090405164024.1459e4fe@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090405070116.17ecadef@pedra.chehab.org>
	 <20090405164024.1459e4fe@hyperion.delvare>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 20:22:59 -0400
Message-Id: <1238977379.2796.19.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-04-05 at 16:40 +0200, Jean Delvare wrote: 
> Hi Mauro,
> 
> On Sun, 5 Apr 2009 07:01:16 -0300, Mauro Carvalho Chehab wrote:

> > 
> > 3) So far, nobody gave us any positive return that the new IR model is working with
> > any of the touched drivers. So, more tests are needed. I'm expecting to have a
> > positive reply for each of the touched drivers. People, please test!
> 
> Yes, please! :)

Jean,

I tested your original patch set so you can get some real feedback.  The
news is good, but I'll bore you with the details first. :)


1. My setup:

HVR-1600: Hauppauge model 74041, rev C5B2, serial# 891351
  has no radio, has IR receiver, has IR transmitter (Zilog Z8F0811)

Hauppauge Remote: Grey top side & black bottom side;
  with 4 colored buttons Red, Green, Yellow, Blue;
  Numbers inside battery cover:
	A415-HPG
	M25909070211590

uname -a: 
Linux morgan.walls.org 2.6.27.9-73.fc9.x86_64 #1 SMP Tue Dec 16 14:54:03
EST 2008 x86_64 x86_64 x86_64 GNU/Linux

v4l-dvb: pulled this morning.


2. OK, my first test had no effect, because I'm an idiot. :)
In the cx18 driver, I didn't remove the I2C addresses in your original
patch, and I didn't add 0x71 as a valid address.



3. My second test had bad results:

# modprobe ir-kbd-i2c debug=3 hauppauge=1

Message from syslogd@morgan at Apr  5 18:47:14 ...
kernel:Oops: 0010 [1] SMP 

Message from syslogd@morgan at Apr  5 18:47:14 ...
kernel:Code:  Bad RIP value.

Message from syslogd@morgan at Apr  5 18:47:14 ...
kernel:CR2: 0000000000000000


input: i2c IR (SAA713x remote) as /devices/virtual/input/input6
ir-kbd-i2c: i2c IR (SAA713x remote) detected at i2c-1/1-0071/ir0 [cx18 i2c driver #0-0]
ir-kbd-i2c: ir_poll_key
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<0000000000000000>] 0x0
PGD 71c36067 PUD 2cca2067 PMD 0 
Oops: 0010 [1] SMP 
CPU 0 
Modules linked in: ir_kbd_i2c(+) ir_common mxl5005s s5h1409 tuner_simple tuner_types cs5345 tuner cx18 dvb_core cx2341x v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 tveeprom i2c_algo_bit fuse ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables cpufreq_ondemand powernow_k8 freq_table loop dm_multipath scsi_dh ipv6 snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm i2c_piix4 snd_timer snd_page_alloc ppdev parport_pc snd_hwdep i2c_core shpchp parport pcspkr snd soundcore sr_mod r8169 mii k8temp hwmon cdrom sg floppy dm_snapshot dm_zero dm_mirror dm_log dm_mod pata_acpi ata_generic pata_atiixp libata sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: tveeprom]
Pid: 9, comm: events/0 Not tainted 2.6.27.9-73.fc9.x86_64 #1
RIP: 0010:[<0000000000000000>]  [<0000000000000000>] 0x0
RSP: 0018:ffff880077bede58  EFLAGS: 00010286
RAX: 000000000000001b RBX: ffff88005e73ee30 RCX: 000000000000ccc6
RDX: ffffffffa031ba00 RSI: ffffffffa031ba04 RDI: ffff88005e73ec00
RBP: ffff880077bede80 R08: ffff880077bec000 R09: 000000000000ccc6
R10: 00000126a7e22b3d R11: ffff880073159bd8 R12: ffff88005e73ec00
R13: 0000000000000064 R14: ffffffffa0318371 R15: ffff880077804908
FS:  00007fa0409126f0(0000) GS:ffffffff814ad100(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000569f6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/0 (pid: 9, threadinfo ffff880077bec000, task ffff880077bbdb80)
Stack:  ffffffffa03183df ffff880077bede80 ffff88005e73ee38 ffff880077804900
 ffff88005e73ee30 ffff880077bedec0 ffffffff8104fe45 ffff880077bedec0
 ffff880077804900 ffff880077804918 ffff880077804908 ffff880077beded0
Call Trace:
 [<ffffffffa03183df>] ? ir_work+0x6e/0xd2 [ir_kbd_i2c]
 [<ffffffff8104fe45>] run_workqueue+0xa3/0x146
 [<ffffffff8104ffdd>] worker_thread+0xf5/0x109
 [<ffffffff81053741>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8104fee8>] ? worker_thread+0x0/0x109
 [<ffffffff810533d7>] kthread+0x49/0x76
 [<ffffffff810116e9>] child_rip+0xa/0x11
 [<ffffffff81010a07>] ? restore_args+0x0/0x30
 [<ffffffff8105338e>] ? kthread+0x0/0x76
 [<ffffffff810116df>] ? child_rip+0x0/0x11


Code:  Bad RIP value.
RIP  [<0000000000000000>] 0x0
 RSP <ffff880077bede58>
CR2: 0000000000000000
---[ end trace 6076b08e85151d70 ]---


That's because in ir-kbd-i2c.c:ir_poll_key(), ir->get_key() was a NULL
function pointer.

I realized that ir-kbd-i2c.c:ir_probe() would need a fix-up for address
0x71 for cx18 (and ivtv) or I would need to set the parameters via
struct IR_i2c_init_data.  

There's a usable get_key function for Hauppauge remotes in ir-kbd-i2c,
but no way via struct IR_i2c_init_data to specify that one wants to use
it from the bridge driver.  Nor is there a way to set the RC5 ir_type
from the bridge driver.  So mucking with ir-kbd-i2c.c for address 0x71
is what I did next.


4. For my third test I modified a few lines in ir-kbd-i2c:ir_probe.c:
	...
        case 0x7a:
        case 0x47:
        case 0x71:
        case 0x2d:
                if (adap->id == I2C_HW_B_CX2388x ||
                    adap->id == I2C_HW_B_CX2341X   ) {
                        /* Handled by cx88-input */
                        name = adap->id == I2C_HW_B_CX2341X ? "CX2341X remote"
                                                            : "CX2388x remote";
                        ir_type     = IR_TYPE_RC5;
                        ir->get_key = get_key_haup_xvr;
                        if (hauppauge == 1) {
	...

# modprobe ir-kbd-i2c debug=1 hauppauge=1
(pressing number buttons on the remote)
# 1345678920
# dmesg
input: i2c IR (CX2341X remote) as /devices/virtual/input/input15
ir-kbd-i2c: i2c IR (CX2341X remote) detected at i2c-1/1-0071/ir0 [cx18 i2c driver #0-0]
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=1
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=1
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=3
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=3
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=4
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=4
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=5
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=6
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=7
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=7
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=8
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=8
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=9
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=2
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=2
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=0


Success.

Regards,
Andy

