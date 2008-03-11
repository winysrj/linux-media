Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2B9jvlA009901
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 05:45:57 -0400
Received: from mx5.orcon.net.nz (Debian-exim@mx5.orcon.net.nz [219.88.242.55])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2B9jNCU023604
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 05:45:23 -0400
Received: from Debian-exim by mx5.orcon.net.nz with local (Exim 4.67)
	(envelope-from <lennon@orcon.net.nz>) id 1JZ12s-0006D2-EJ
	for video4linux-list@redhat.com; Tue, 11 Mar 2008 22:45:19 +1300
From: Craig Whitmore <lennon@orcon.net.nz>
To: Eric Thomas <ethomas@claranet.fr>
In-Reply-To: <47D3A5FE.9000803@claranet.fr>
References: <47C40563.5000702@claranet.fr>	<47D24404.9050708@claranet.fr>
	<20080308075929.3ccbd012@gaivota>  <47D3A5FE.9000803@claranet.fr>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 22:45:10 +1300
Message-Id: <1205228710.6918.31.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux <video4linux-list@redhat.com>, g.liakhovetski@pengutronix.de,
	Brandon Philips <bphilips@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: kernel oops since changeset e3b8fb8cc214
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


On Sun, 2008-03-09 at 09:55 +0100, Eric Thomas wrote:

> > 
> > PS.: I'm c/c Brandon, since he is working on fixing a bad lock on videobuf_dma.
> 
> I guess that the best thing I can do for now is waiting.
> If Brandon or someone else wants me to test anything, feel free to
> contact me.

I get similar with the latest hg :-( Tuning in to DVB-T Channels..

I've have been using the HVR with http://dev.kewl.org patches and its
worked 100% or a LONG time. but just recently I downloaded the latest hg
and started to get crashes. If someone can suggest how to get better
debugging it would be great.

2.6.24 kernel with latest HG and MFE http://dev.kewl.org patches

cx88[0]: irq pci [0x1000] brdg_err* <---------- Lots of these before the
crash..

cx88[0]: irq pci [0x1000] brdg_err*
cx88[0]: irq pci [0x1000] brdg_err*
cx88[0]: irq pci [0x1000] brdg_err*
cx88[0]: irq pci [0x1000] brdg_err*
BUG: unable to handle kernel paging request at virtual address 1802ed7c
printing eip: c01e29d2 *pde = 00000000 
Oops: 0002 [#1] SMP 
Modules linked in: nvidia(P) ac battery ipv6 it87 hwmon_vid lirc_imon(F) lirc_dev dvb_pll cx22702 isl6421 cx24116 cx88_dvb cx88_vp3054_i2c tuner tea5767 tda8290 tda18271 tda827x tuner_xc2028 xc5000 firmware_class tda9887 tuner_simple tuner_types mt20xx tea5761 snd_hda_intel snd_pcm_oss snd_mixer_oss cx88_alsa fan cx8802 snd_pcm cx8800 cx88xx ir_common snd_timer serio_raw i2c_algo_bit snd thermal videobuf_dvb dvb_core tveeprom videodev ohci1394 soundcore psmouse v4l1_compat compat_ioctl32 v4l2_common videobuf_dma_sg videobuf_core btcx_risc ieee1394 ehci_hcd i2c_nforce2 button processor k8temp snd_page_alloc evdev ohci_hcd i2c_core pcspkr

Pid: 2596, comm: cx88[0] dvb Tainted: PF       (2.6.24 #1)
EIP: 0060:[<c01e29d2>] EFLAGS: 00010297 CPU: 0
EIP is at __reg_op+0xb0/0xc7
EAX: 1802ed80 EBX: fffffffb ECX: f7ffffff EDX: 00000000
ESI: 08000000 EDI: fffffb5f EBP: 18030000 ESP: f686ff38
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process cx88[0] dvb (pid: 2596, ti=f686e000 task=f7ccd550 task.ti=f686e000)
Stack: 00000020 00000001 00000060 00000001 00000001 00000000 36bdc000 f69a2c6c 
       f7d8e04c c01e2a54 00000002 f886941f 36bdc000 f8885a64 f8885348 f69a2c00 
       f69a2c88 f742d018 f742d0d0 f89409c3 f742d018 00000008 00000282 f887f414 
Call Trace:
 [<c01e2a54>] bitmap_release_region+0xf/0x11
 [<f886941f>] btcx_riscmem_free+0x58/0x69 [btcx_risc]
 [<f8885a64>] videobuf_dma_free+0x65/0x8f [videobuf_dma_sg]
 [<f8885348>] videobuf_dma_unmap+0x43/0x58 [videobuf_dma_sg]
 [<f89409c3>] cx88_free_buffer+0x4a/0x55 [cx88xx]
 [<f887f414>] videobuf_queue_cancel+0x72/0x8e [videobuf_core]
 [<f887f504>] __videobuf_read_stop+0xb/0x53 [videobuf_core]
 [<f887f58b>] videobuf_read_stop+0xf/0x17 [videobuf_core]
 [<f888f5ce>] videobuf_dvb_thread+0xf9/0x13c [videobuf_dvb]
 [<c011c237>] complete+0x36/0x44
 [<f888f4d5>] videobuf_dvb_thread+0x0/0x13c [videobuf_dvb]
 [<c01338a0>] kthread+0x38/0x60
 [<c0133868>] kthread+0x0/0x60
 [<c01049f7>] kernel_thread_helper+0x7/0x10
 =======================
Code: c9 eb 0c 89 f0 23 02 83 c2 04 85 c0 75 2a 41 3b 4c 24 0c 7c ee b8 01 00 00 00 eb 1e 09 70 fc 42 83 c0 04 3b 54 24 0c 7c f3 eb 0d <21> 48 fc 42 83 c0 04 3b 54 24 0c 7c f3 31 c0 83 c4 14 5b 5e 5f 
EIP: [<c01e29d2>] __reg_op+0xb0/0xc7 SS:ESP 0068:f686ff38
---[ end trace b11878c4cdde4f66 ]---

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
