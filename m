Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout5.freenet.de ([195.4.92.95])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1JsOqd-0002YM-Or
	for linux-dvb@linuxtv.org; Sat, 03 May 2008 23:00:54 +0200
Message-ID: <481CD27A.9080300@freenet.de>
Date: Sat, 03 May 2008 23:00:42 +0200
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
References: <481B7D43.2050200@hispeed.ch>
In-Reply-To: <481B7D43.2050200@hispeed.ch>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] mantis crash...
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

Roland Scheidegger schrieb:
> This was reported before, the current mantis driver will cause a page
> fault in mantis_dvb_start_feed.
>   
Dear Roland,

I applied your patch to the code I got from

    http://jusst.de/hg/mantis

Now the mantis driver (for 2033) works fine for me.

Setup: 2.6.22.19
             vdr-1.5.18/xineliboutput

Unfortunately, as soon as I insert the CAM module, the driver crashes.
According to the logfile, it looks that "vdr" still gets the information 
about the CAM and tries to access it.
Then the driver crashes.  Maybe  someone  still has an idea how to dig 
into this.



May  3 22:34:34 linux-sh8m vdr: [7645] changing pids of channel 58 from 
901+901:902:0:204 to 701+701:702:0:204
May  3 22:34:51 linux-sh8m vdr: [7643] CAM 1: module present
May  3 22:34:54 linux-sh8m kernel: Unable to handle kernel paging 
request at ffffc20010681fff RIP:
May  3 22:34:54 linux-sh8m kernel:  [<ffffffff88132bfc>] 
:mantis:mantis_hif_read_mem+0x6c/0x250
May  3 22:34:54 linux-sh8m kernel: PGD 37ce5067 PUD 37ce4067 PMD 0
May  3 22:34:54 linux-sh8m kernel: Oops: 0002 [1] PREEMPT
May  3 22:34:54 linux-sh8m kernel: CPU 0
May  3 22:34:54 linux-sh8m kernel: Modules linked in: snd_ice1724 
snd_ice17xx_ak4xxx snd_ac97_codec snd_ak4114 snd_pcm snd_timer snd_pt2258
 snd_i2c snd_ak4xxx_adda snd_mpu401_uart snd_rawmidi snd_seq_device snd 
soundcore button mantis mb86a16 tda10021 stv0299 ip6t_LOG nf_conntr
ack_ipv6 xt_pkttype ipt_LOG xt_limit kqemu(P) af_packet 
cpufreq_conservative cpufreq_ondemand cpufreq_performance 
cpufreq_powersave thermal
 fan evdev battery ac isofs nls_iso8859_1 nls_cp437 vfat fat nls_utf8 
ntfs loop md_mod dm_mod ip6t_REJECT xt_tcpudp ipt_REJECT xt_state ipt
able_mangle iptable_nat nf_nat iptable_filter ip6table_mangle 
nf_conntrack_ipv4 nf_conntrack nfnetlink ip_tables ip6table_filter 
ip6_tables
 x_tables ipv6 vboxdrv rtc w83627hf hwmon_vid powernow_k8 freq_table 
processor usbhid lirc_mceusb2(F) nvidia(P) lirc_dev ide_cd cdrom ac97_
bus snd_page_alloc ohci1394 lnbp21 stb6100 tda10023 stb0899 ieee1394 
8139too dvb_core ohci_hcd ehci_hcd usbcore k8temp i2c_piix4 lp bttv ir
_common compat_ioctl32 videodev v4l1_compat i2c_algo_bit v
May  3 22:34:54 linux-sh8m kernel: 4l2_common videobuf_dma_sg 
videobuf_core btcx_risc tveeprom i2c_core sg
May  3 22:34:54 linux-sh8m kernel: Pid: 7340, comm: kdvb-ca-0:0 Tainted: 
PF      2.6.22.19 #6
May  3 22:34:54 linux-sh8m kernel: RIP: 0010:[<ffffffff88132bfc>]  
[<ffffffff88132bfc>] :mantis:mantis_hif_read_mem+0x6c/0x250
May  3 22:34:54 linux-sh8m kernel: RSP: 0018:ffff810059a7fcd0  EFLAGS: 
00010216
May  3 22:34:54 linux-sh8m kernel: RAX: ffffc20000682000 RBX: 
0000000080000000 RCX: 0000000032382dd0
May  3 22:34:54 linux-sh8m kernel: RDX: 0000000000000ab6 RSI: 
0000000000000000 RDI: 00000000000001f4
May  3 22:34:54 linux-sh8m kernel: RBP: ffff81007c2df480 R08: 
ffff810059a7fee8 R09: ffff810059a7fde0
May  3 22:34:54 linux-sh8m kernel: R10: 0000000000000000 R11: 
ffffffff80460050 R12: ffff810059a7fde0
May  3 22:34:54 linux-sh8m kernel: R13: 0000000000000000 R14: 
ffff8100402c8000 R15: 0000000000000000
May  3 22:34:54 linux-sh8m kernel: FS:  00002b5a665b7d00(0000) 
GS:ffffffff80604000(0000) knlGS:00000000f7d0f6c0
May  3 22:34:54 linux-sh8m kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
000000008005003b
May  3 22:34:54 linux-sh8m kernel: CR2: ffffc20010681fff CR3: 
0000000077a14000 CR4: 00000000000006e0
May  3 22:34:54 linux-sh8m kernel: Process kdvb-ca-0:0 (pid: 7340, 
threadinfo ffff810059a7e000, task ffff81005aacf750)
May  3 22:34:54 linux-sh8m kernel: Stack:  ffff810059a7fd50 
ffff81005aacf750 ffff81005a1370e0 000000000000083e
May  3 22:34:54 linux-sh8m kernel:  ffffffff80656560 ffffffff805c6360 
0000000000000058 0000000000000000
May  3 22:34:54 linux-sh8m kernel:  0000000000000000 ffff810059a7fde0 
0000000000000000 ffff810059a7fee4
May  3 22:34:54 linux-sh8m kernel: Call Trace:
May  3 22:34:55 linux-sh8m vdr: [7644] frontend 0 lost lock on channel 
25, tp 113
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff880d1bc4>] 
:dvb_core:dvb_ca_en50221_read_tuple+0x34/0x190
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff880d31db>] 
:dvb_core:dvb_ca_en50221_thread+0x49b/0xa10
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff80223e07>] 
__wake_up_common+0x47/0x70
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff80223f8f>] 
__activate_task+0x2f/0x50
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff804d6b59>] 
thread_return+0x0/0x3d7
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff880d2d40>] 
:dvb_core:dvb_ca_en50221_thread+0x0/0xa10
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff880d2d40>] 
:dvb_core:dvb_ca_en50221_thread+0x0/0xa10
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff8023eceb>] kthread+0x4b/0x80
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff8020a3c8>] child_rip+0xa/0x12
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff8023eca0>] kthread+0x0/0x80
May  3 22:34:55 linux-sh8m kernel:  [<ffffffff8020a3be>] child_rip+0x0/0x12
May  3 22:34:55 linux-sh8m kernel:
May  3 22:34:55 linux-sh8m kernel:
May  3 22:34:55 linux-sh8m kernel: Code: 89 98 ff ff ff 0f 4c 8b bd 98 
00 00 00 e8 d2 b6 0f f8 f6 85
May  3 22:34:56 linux-sh8m kernel: RIP  [<ffffffff88132bfc>] 
:mantis:mantis_hif_read_mem+0x6c/0x250
May  3 22:34:56 linux-sh8m kernel:  RSP <ffff810059a7fcd0>
May  3 22:34:56 linux-sh8m kernel: CR2: ffffc20010681fff
May  3 22:34:58 linux-sh8m vdr: [7644] frontend 0 timed out while tuning 
to channel 25, tp 113

~                                                                                                                                                          

~                                                                                                                                                          

~                                                                

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
