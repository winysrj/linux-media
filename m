Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout5.freenet.de ([195.4.92.95])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1Jzemv-0006Qt-Vx
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 23:27:00 +0200
Message-ID: <4837369D.2020901@freenet.de>
Date: Fri, 23 May 2008 23:26:53 +0200
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <482EB3E5.7090607@freenet.de> <482F49BB.4060300@gmail.com>
	<48327AEF.1060809@freenet.de> <48371567.8080304@gmail.com>
In-Reply-To: <48371567.8080304@gmail.com>
Cc: "linux-dvb: linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] CAM of Mantis 2033 still not working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Manu,

the changeset 7344 3ae5e8d85a55 crashes after doing "modprobe mantis" 
and the computer hangs.
I could still log in from remote, doing an "init 6", but the machine did 
not reboot anymore. So I had to push the "Reset".

Below is /var/log/messges


May 23 23:10:51 linux-sh8m kernel: ACPI: PCI Interrupt 0000:02:01.0[A] 
-> GSI 21 (level, low) -> IRQ 21
May 23 23:10:51 linux-sh8m kernel: irq: 21, latency: 64
May 23 23:10:51 linux-sh8m kernel:  memory: 0xdfeff000, mmio: 
0xffffc200006f6000
May 23 23:10:51 linux-sh8m kernel: found a VP-2033 PCI DVB-C device on 
(02:01.0),
May 23 23:10:51 linux-sh8m kernel:     Mantis Rev 1 [1822:0008], irq: 
21, latency: 64
May 23 23:10:51 linux-sh8m kernel:     memory: 0xdfeff000, mmio: 
0xffffc200006f6000
May 23 23:10:51 linux-sh8m kernel:     MAC Address=[00:08:ca:19:e9:b6]
May 23 23:10:51 linux-sh8m kernel: mantis_alloc_buffers (0): 
DMA=0x69b90000 cpu=0xffff810069b90000 size=65536
May 23 23:10:51 linux-sh8m kernel: mantis_alloc_buffers (0): 
RISC=0x5afe0000 cpu=0xffff81005afe0000 size=1000
May 23 23:10:51 linux-sh8m kernel: DVB: registering new adapter (Mantis 
dvb adapter)
May 23 23:10:52 linux-sh8m kernel: mantis_frontend_init (0): Probing for 
CU1216 (DVB-C)
May 23 23:10:52 linux-sh8m kernel: TDA10021: i2c-addr = 0x0c, id = 0x7c
May 23 23:10:52 linux-sh8m kernel: mantis_frontend_init (0): found 
Philips CU1216 DVB-C frontend (TDA10021) @ 0x0c
May 23 23:10:52 linux-sh8m kernel: mantis_frontend_init (0): Mantis 
DVB-C Philips CU1216 frontend attach success
May 23 23:10:52 linux-sh8m kernel: DVB: registering frontend 0 (Philips 
TDA10021 DVB-C)...
May 23 23:10:52 linux-sh8m kernel: mantis_ca_init (0): Registering 
EN50221 device
May 23 23:10:52 linux-sh8m kernel: mantis_ca_init (0): Registered 
EN50221 device
May 23 23:10:52 linux-sh8m kernel: Unable to handle kernel NULL pointer 
dereference at 0000000000000000 RIP:
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff80223de6>] 
__wake_up_common+0x26/0x70
May 23 23:10:52 linux-sh8m kernel: PGD 5c0b4067 PUD 5c1e6067 PMD 0
May 23 23:10:52 linux-sh8m kernel: Oops: 0000 [1] PREEMPT
May 23 23:10:52 linux-sh8m kernel: CPU 0
May 23 23:10:52 linux-sh8m kernel: Modules linked in: mantis ip6t_LOG 
nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit
 kqemu(P) af_packet cpufreq_conservative cpufreq_ondemand 
cpufreq_performance cpufreq_powersave thermal fan evdev b
utton battery ac isofs nls_iso8859_1 nls_cp437 vfat fat nls_utf8 ntfs 
loop md_mod dm_mod ip6t_REJECT xt_tcpudp ipt_
REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter 
ip6table_mangle nf_conntrack_ipv4 nf_conntrack nfn
etlink ip_tables ip6table_filter ip6_tables x_tables ipv6 vboxdrv rtc 
w83627hf hwmon_vid powernow_k8 freq_table pro
cessor lirc_mceusb2(F) usbhid lirc_dev lnbp21 mb86a16 nvidia(P) stb6100 
snd_ice1724 tda10021 snd_ice17xx_ak4xxx ide
_cd snd_ac97_codec ac97_bus cdrom snd_ak4114 ohci1394 tda10023 stb0899 
snd_pcm snd_timer snd_page_alloc snd_pt2258
snd_i2c snd_ak4xxx_adda snd_mpu401_uart snd_rawmidi snd_seq_device 
ieee1394 8139too snd soundcore stv0299 dvb_core
k8temp ehci_hcd ohci_hcd i2c_piix4 usbcore lp bttv ir_common 
compat_ioctl32 videodev v4l1_compat i2c_algo_bit v
May 23 23:10:52 linux-sh8m kernel: 4l2_common videobuf_dma_sg 
videobuf_core btcx_risc tveeprom i2c_core sg
May 23 23:10:52 linux-sh8m kernel: Pid: 4, comm: events/0 Tainted: 
PF      2.6.22.19 #6
May 23 23:10:52 linux-sh8m kernel: RIP: 0010:[<ffffffff80223de6>]  
[<ffffffff80223de6>] __wake_up_common+0x26/0x70
May 23 23:10:52 linux-sh8m kernel: RSP: 0000:ffff810037c8be50  EFLAGS: 
00010017
May 23 23:10:52 linux-sh8m kernel: RAX: 0000000000000000 RBX: 
0000000000000286 RCX: 0000000000000000
May 23 23:10:52 linux-sh8m kernel: RDX: 0000000000000001 RSI: 
0000000000000003 RDI: ffff810073af07d8
May 23 23:10:52 linux-sh8m kernel: RBP: ffff810037c8be80 R08: 
0000000000000000 R09: 00000000ffffffff
May 23 23:10:52 linux-sh8m kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: ffff810037ff7fc0
May 23 23:10:52 linux-sh8m kernel: R13: ffff810073af07d8 R14: 
0000000000000001 R15: 0000000000000000
May 23 23:10:52 linux-sh8m kernel: FS:  00002ada904de6f0(0000) 
GS:ffffffff80604000(0000) knlGS:0000000000000000
May 23 23:10:52 linux-sh8m kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
000000008005003b
May 23 23:10:52 linux-sh8m kernel: CR2: 0000000000000000 CR3: 
0000000059e78000 CR4: 00000000000006e0
May 23 23:10:52 linux-sh8m kernel: Process events/0 (pid: 4, threadinfo 
ffff810037c8a000, task ffff810037c80040)
May 23 23:10:52 linux-sh8m kernel: Stack:  0000000300000000 
0000000000000286 ffff810037ff7fc0 ffffffff88db46e0
May 23 23:10:52 linux-sh8m kernel:  0000000000000000 0000000000000000 
ffff810037c8bea0 ffffffff80225865
May 23 23:10:52 linux-sh8m kernel:  ffff810073af07b0 ffff810073af07b8 
ffff810073af07b0 ffffffff8023aff7
May 23 23:10:52 linux-sh8m kernel: Call Trace:
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff88db46e0>] 
:mantis:mantis_hifevm_work+0x0/0x300
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff80225865>] __wake_up+0x25/0x60
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8023aff7>] 
run_workqueue+0xb7/0x1a0
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8023b6f0>] 
worker_thread+0x0/0x130
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8023b6f0>] 
worker_thread+0x0/0x130
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8023b7b3>] 
worker_thread+0xc3/0x130
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8023f150>] 
autoremove_wake_function+0x0/0x30
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8023b6f0>] 
worker_thread+0x0/0x130
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8023eceb>] kthread+0x4b/0x80
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8020a3c8>] child_rip+0xa/0x12
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8023eca0>] kthread+0x0/0x80
May 23 23:10:52 linux-sh8m kernel:  [<ffffffff8020a3be>] child_rip+0x0/0x12
May 23 23:10:52 linux-sh8m kernel:
May 23 23:10:52 linux-sh8m kernel:
May 23 23:10:52 linux-sh8m kernel: Code: 48 8b 18 75 08 eb 34 0f 1f 00 
48 89 d3 48 8d 78 e8 44 8b 60
May 23 23:10:52 linux-sh8m kernel: RIP  [<ffffffff80223de6>] 
__wake_up_common+0x26/0x70
May 23 23:10:52 linux-sh8m kernel:  RSP <ffff810037c8be50>
May 23 23:10:52 linux-sh8m kernel: CR2: 0000000000000000
May 23 23:10:52 linux-sh8m kernel: note: events/0[4] exited with 
preempt_count 1
May 23 23:10:52 linux-sh8m kernel: mantis_hif_init (0): Adapter(0) 
Initializing Mantis Host Interface




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
