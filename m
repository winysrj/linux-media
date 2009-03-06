Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:57631
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800AbZCFPlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 10:41:18 -0500
Message-ID: <49B1441E.7080604@nildram.co.uk>
Date: Fri, 06 Mar 2009 15:41:18 +0000
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problems with Hauppauge CX88 based DVB-T cards
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Whilst testing some Hauppauge DVB-T cards I have run into this error at 
bootup:

---------<Start Paste>---------
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18]
BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000000
  printing eip:
e8adc107
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: cx88_dvb cx88_vp3054_i2c snd_intel8x0 snd_ac97_codec 
ac97_bus sg snd_seq_dummy ehci_hcd uhci_hcd floppy sr_mod cdrom cx8
02 cx8800 cx88xx ir_common i2c_algo_bit tveeprom videobuf_dvb 
v4l2_common dvb_core videodev v4l1_compat btcx_risc videobuf_dma_sg 
videobuf_
ore snd_seq_oss snd_seq_midi_event sk98lin snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss i2c_i801 i2c_core snd_pcm iTCO_wdt iTCO_vendor_
upport snd_timer snd soundcore snd_page_alloc serio_raw button 
dm_snapshot dm_zero dm_mirror dm_mod ata_generic raid1 ext3 mbcache jbd ata_
iix libata sd_mod scsi_mod
CPU:    0
EIP:    0060:[<e8adc107>]    Not tainted VLI
EFLAGS: 00010246   (2.6.23.1.tps.smp.2 #1)
EIP is at vp3054_i2c_probe+0x17/0x120 [cx88_vp3054_i2c]
eax: 00000000   ebx: ffffffed   ecx: 00000000   edx: dfc74a00
esi: 00000000   edi: c1a9ea34   ebp: 00000000   esp: dfdf9e2c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process modprobe (pid: 1543, ti=dfdf8000 task=dfdce000 task.ti=dfdf8000)
Stack: 00000000 c07a8872 e8afbf00 00000246 0000004c ffffffed dfd58800 
c1a9ea34
        00000000 e8af73da c0427171 00000246 00000033 00000000 0000000f 
c0440b50
        00000000 c17fcf00 00000000 00000292 e8af7150 e8afbb80 c1a9ea00 
e8afbbb4
Call Trace:
  [<e8af73da>] cx8802_dvb_probe+0x5a/0x1e60 [cx88_dvb]
  [<c0427171>] try_to_wake_up+0x41/0x380
  [<c0440b50>] kthread_bind+0x60/0x80
  [<e8af7150>] cx8802_dvb_remove+0x0/0x70 [cx88_dvb]
  [<e8ad4964>] cx8802_register_driver+0x1a4/0x20e [cx8802]
  [<c044ed3d>] sys_init_module+0x14d/0x16f0
  [<c0510690>] copy_to_user+0x30/0x60
  [<c04367b0>] msleep+0x0/0x20
  [<c040525e>] sysenter_past_esp+0x5f/0x85
  [<c043007b>] do_wait+0x94b/0xb40
  =======================
Code: 1e ed ff 89 d8 5b e9 b9 85 9a d7 89 f6 8d bc 27 00 00 00 00 83 ec 
24 89 74 24 18 31 f6 89 6c 24 20 89 c5 89 5c 24 14 89 7c 24 1c <8b>
00 89 44 24 10 83 b8 f4 03 00 00 2a 74 1a 89 f0 8b 5c 24 14

---------<End Paste>---------

I pulled the latest changes as I noticed a similar was fixed recently 
but I'm still seeing the problem on my system.

Any ideas on how to solve it?

Thanks in advance.

Lou



