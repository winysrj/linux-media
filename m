Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Thu, 24 Apr 2008 20:11:48 +0200
From: Philipp Kolmann <philipp@kolmann.at>
To: linux-dvb@linuxtv.org
Message-ID: <20080424181148.GA3898@kolmann.at>
MIME-Version: 1.0
Content-Disposition: inline
Cc: manu@linuxtv.org
Subject: [linux-dvb] kernel oops with Terratec Cinergy C
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

Hi,

I am new to linux-dvb so please excuse if this has been discussed before here.

I just got myself today a Terratec Cinergy C DVB-C PCI Card:
05:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)

I have read some pages and found the mantis hg tree at
http://jusst.de/hg/mantis/ and compiled it for my debian unstable box
(2.6.24-1-686).

Now the card is detected and I started w_scan. After some time, I got the
following Kernel oops:

Apr 24 20:06:10 chief kernel: mantis start feed & dma
Apr 24 20:06:10 chief kernel: BUG: unable to handle kernel paging request at virtual address 08865fff
Apr 24 20:06:10 chief kernel: printing eip: f8d7d9f9 *pde = 00000000 
Apr 24 20:06:10 chief kernel: Oops: 0000 [#1] SMP 
Apr 24 20:06:10 chief kernel: Modules linked in: snd_bt87x budget budget_av budget_ci budget_core dvb_ttpci saa7146_vv saa7146 ttpci_eeprom ves1820 vmnet(P) vmblock vmmon(P) nvidia(P) binfmt_misc rfcomm l2cap bluetooth ac battery ipv6 nfs lockd nfs_acl sunrpc xfs w83627ehf hwmon_vid eeprom cpufreq_userspace sg fuse snd_usb_audio snd_usb_lib snd_hwdep vfat fat tuner tea5767 tda8290 tda18271 tda827x tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 tvaudio msp3400 bttv snd_hda_intel videodev v4l1_compat firmware_class ir_common compat_ioctl32 snd_pcm_oss i2c_algo_bit snd_pcm mantis v4l2_common videobuf_dma_sg videobuf_core lnbp21 snd_mixer_oss btcx_risc parport_pc parport mb86a16 stb6100 tda10021 tda10023 stb0899 stv0299 tveeprom psmouse rtc dvb_core pcspkr serio_raw i2c_i801 i2c_core snd_seq_dummy iTCO_wdt snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc button intel_agp agpgart evdev ext3 jbd mbcache raid1 md_mod ide_cd cdro
Apr 24 20:06:10 chief kernel:  ata_generic generic usbhid hid sd_mod floppy ahci libata jmicron ide_core scsi_mod r8169 ehci_hcd uhci_hcd usbcore thermal processor fan
Apr 24 20:06:10 chief kernel: 
Apr 24 20:06:10 chief kernel: Pid: 4678, comm: w_scan Tainted: P        (2.6.24-1-686 #1)
Apr 24 20:06:10 chief kernel: EIP: 0060:[<f8d7d9f9>] EFLAGS: 00010206 CPU: 1
Apr 24 20:06:10 chief kernel: EIP is at mantis_dma_start+0x168/0x1af [mantis]
Apr 24 20:06:10 chief kernel: EAX: 370a5000 EBX: f7104000 ECX: 00000042 EDX: f8866000
Apr 24 20:06:10 chief kernel: ESI: 0000003e EDI: f70a5000 EBP: 00010000 ESP: f57e5df0
Apr 24 20:06:10 chief kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Apr 24 20:06:10 chief kernel: Process w_scan (pid: 4678, ti=f57e4000 task=f50b8170 task.ti=f57e4000)
Apr 24 20:06:10 chief kernel: Stack: c016d33f 00000000 f7104000 f7104270 f8db2000 00000020 f7104000 f7104270 
Apr 24 20:06:10 chief kernel:        f8db2000 f7104270 f8d7f0d2 f8d8277d f8d1645b c016d9f0 00002000 00000000 
Apr 24 20:06:10 chief kernel:        00000012 f8d16f67 f7104448 00ec7000 00000000 f8ec7008 f8d88036 f8ec7000 
Apr 24 20:06:10 chief kernel: Call Trace:
Apr 24 20:06:10 chief kernel:  [<c016d33f>] __get_vm_area_node+0xbf/0x178
Apr 24 20:06:10 chief kernel:  [<f8d7f0d2>] mantis_dvb_start_feed+0xe4/0xf2 [mantis]
Apr 24 20:06:10 chief kernel:  [<f8d1645b>] dvb_demux_feed_add+0x1d/0x96 [dvb_core]
Apr 24 20:06:10 chief kernel:  [<c016d9f0>] __vmalloc_area_node+0xf1/0x10f
Apr 24 20:06:10 chief kernel:  [<f8d16f67>] dmx_section_feed_start_filtering+0xde/0x12e [dvb_core]
Apr 24 20:06:10 chief kernel:  [<f8d14ffd>] dvb_dmxdev_filter_start+0x22b/0x396 [dvb_core]
Apr 24 20:06:10 chief kernel:  [<c0176d89>] get_unused_fd_flags+0x4d/0xba
Apr 24 20:06:10 chief kernel:  [<f8d1537a>] dvb_demux_do_ioctl+0x212/0x36d [dvb_core]
Apr 24 20:06:10 chief kernel:  [<f8d14105>] dvb_usercopy+0xa9/0x100 [dvb_core]
Apr 24 20:06:10 chief kernel:  [<c0176ffc>] nameidata_to_filp+0x24/0x33
Apr 24 20:06:10 chief kernel:  [<c017703d>] do_filp_open+0x32/0x39
Apr 24 20:06:10 chief kernel:  [<f8d149b1>] dvb_demux_ioctl+0x18/0x1c [dvb_core]
Apr 24 20:06:10 chief kernel:  [<f8d15168>] dvb_demux_do_ioctl+0x0/0x36d [dvb_core]
Apr 24 20:06:10 chief kernel:  [<c0182888>] do_ioctl+0x4c/0x62
Apr 24 20:06:10 chief kernel:  [<c0182ad5>] vfs_ioctl+0x237/0x249
Apr 24 20:06:10 chief kernel:  [<c0182b2c>] sys_ioctl+0x45/0x5d
Apr 24 20:06:10 chief kernel:  [<c0103e5e>] sysenter_past_esp+0x6b/0xa1
Apr 24 20:06:10 chief kernel:  =======================
Apr 24 20:06:10 chief kernel: Code: 00 03 43 40 c7 00 00 00 00 70 8b 53 44 8d 04 8d 04 00 00 00 03 43 40 83 c1 02 89 10 8b 53 18 8b 43 44 89 4b 34 89 42 10 8b 53 18 <8b> 82 ff ff ff 0f 0d 00 00 00 80 89 82 ff ff ff 0f 8b 43 18 c7 
Apr 24 20:06:10 chief kernel: EIP: [<f8d7d9f9>] mantis_dma_start+0x168/0x1af [mantis] SS:ESP 0068:f57e5df0
Apr 24 20:06:10 chief kernel: ---[ end trace 7ec6b1d3f87d4386 ]---


If there is anything I can test, just tell me.

Thanks
Philipp

-- 
The more I learn about people, the more I like my dog!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
