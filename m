Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web32703.mail.mud.yahoo.com ([68.142.207.247])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <vikinghat@yahoo.com>) id 1JSZu0-0001Mu-TJ
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 16:33:33 +0100
Date: Fri, 22 Feb 2008 07:31:39 -0800 (PST)
From: Christopher Hammond <vikinghat@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <131720.11809.qm@web32703.mail.mud.yahoo.com>
Subject: [linux-dvb] af9005 problem with frontend?
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

I have an unbranded USB DVB-T receiver bought off e-bay.  It works in MS Windows with blazevideo software OK, and according to the Windows driver it is an af9005 device, and the documentation on the driver disk refers to Easy TV.

I'm trying to use it in Mandriva 2008.0 (kernel 2.6.22.18-desktop-1mdv) so I've followed the instructions referred to at http://ventoso.org/luca/af9005/ to download the latest v4l-dvb code, make and install it.  

I plug in the USB stick and then attempt to use 
$ dvbsnoop -s pidscan

but the only output I get is the announcement:

dvbsnoop V1.4.00 -- http://dvbsnoop.sourceforge.net/

---------------------------------------------------------
Transponder PID-Scan...
---------------------------------------------------------

The dvbsnoop process then refuses to die - well so I thought till looking at the dmesg output below.  I am guessing the failure to attach a frontend is the first problem - help please.

Output from dmesg:

usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
dvb-usb: found a 'Afatech DVB-T USB1.1 stick' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'af9005.fw'
dvb-usb: found a 'Afatech DVB-T USB1.1 stick' in warm state.
dvb-usb: will use the device's hardware PID filter (table count: 32).
DVB: registering new adapter (Afatech DVB-T USB1.1 stick).
dvb-usb: no frontend was attached by 'Afatech DVB-T USB1.1 stick'
dvb-usb: Afatech DVB-T USB1.1 stick successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_af9005
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
f8c60df7
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: dvb_usb_af9005_remote dvb_usb_af9005 dvb_usb dvb_core dvb_pll ipt_IFWLOG ipt_psd ip_set_iptree iptable_raw xt_comment xt_policy xt_multiport ipt_ULOG ipt_TTL ipt_ttl ipt_TOS ipt_tos ipt_set ipt_SAME ipt_REJECT ipt_REDIRECT ipt_recent ipt_owner ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_iprange ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp ip_set_portmap ip_set_macipmap ip_set_ipmap ip_set_iphash ip_set xt_tcpmss xt_pkttype xt_physdev xt_NFQUEUE xt_NFLOG xt_MARK xt_mark xt_mac xt_limit xt_length xt_helper xt_hashlimit ip6_tables xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp
 xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables usblp af_packet snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipv6 video thermal sbs fan container button dock battery ac binfmt_misc loop nls_cp437 vfat fat nls_utf8 ntfs dm_mod usb_storage scsi_mod floppy cpufreq_ondemand cpufreq_conservative cpufreq_powersave freq_table processor irda_usb irda crc_ccitt snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd via_rhine i2c_viapro i2c_core soundcore mii ehci_hcd uhci_hcd usbcore via_agp agpgart ide_cd evdev tsdev shpchp pci_hotplug ext3 jbd ide_disk via82cxxx siimage ide_core
CPU:    0
EIP:    0060:[<f8c60df7>]    Not tainted VLI
EFLAGS: 00210297   (2.6.22.18-desktop-1mdv #1)
EIP is at af9005_generic_read_write+0x77/0x1e0 [dvb_usb_af9005]
eax: f4ccd000   ebx: 00000001   ecx: 00000000   edx: 0000b003
esi: 00000000   edi: 00000001   ebp: d7391d8c   esp: d7391d4c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process dvbsnoop (pid: 13298, ti=d7390000 task=cf0e9560 task.ti=d7390000)
Stack: 00000000 00000000 00000002 f4ccd000 000200d2 00000000 00000000 00000000
       00000000 0c20000e 00000000 00000000 00000000 0000b003 f4ccd000 00000000
       d7391dac f8c6109d 00000000 d7391da3 00000001 01000000 00000001 f4ccd768
Call Trace:
 [<c010529a>] show_trace_log_lvl+0x1a/0x30
 [<c010535b>] show_stack_log_lvl+0xab/0xd0
 [<c0105551>] show_registers+0x1d1/0x2d0
 [<c010575c>] die+0x10c/0x240
 [<c0121399>] do_page_fault+0x199/0x630
 [<c031599a>] error_code+0x72/0x78
 [<f8c6109d>] af9005_write_ofdm_register+0x3d/0xb0 [dvb_usb_af9005]
 [<f8c6139e>] af9005_pid_filter_control+0x2e/0xd0 [dvb_usb_af9005]
 [<f8c61502>] af9005_pid_filter+0xc2/0x140 [dvb_usb_af9005]
 [<f8c5b2fb>] dvb_usb_ctrl_feed+0x6b/0x120 [dvb_usb]
 [<f8c5b3cd>] dvb_usb_start_feed+0xd/0x10 [dvb_usb]
 [<f8c6d39c>] dmx_ts_feed_start_filtering+0x4c/0xd0 [dvb_core]
 [<f8c6b0d1>] dvb_dmxdev_filter_start+0xe1/0x390 [dvb_core]
 [<f8c6b4c7>] dvb_demux_do_ioctl+0x147/0x400 [dvb_core]
 [<f8c6a10a>] dvb_usercopy+0x8a/0x130 [dvb_core]
 [<f8c6ab3a>] dvb_demux_ioctl+0x1a/0x20 [dvb_core]
 [<c018f455>] do_ioctl+0x75/0xb0
 [<c018f6af>] vfs_ioctl+0x21f/0x2a0
 [<c018f789>] sys_ioctl+0x59/0x70
 [<c01041ba>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: 00 c7 45 df 00 00 00 00 c6 45 e3 00 0f 8e 5e 01 00 00 83 fb 08 0f 8f 3f 01 00 00 c6 45 e4 0e c6 45 e5 00 c6 45 e6 20 c6 45 e7 0c <0f> b6 01 88 45 e8 83 c0 01 88 01 89 d0 66 c1 e8 08 83 fe 01 88
EIP: [<f8c60df7>] af9005_generic_read_write+0x77/0x1e0 [dvb_usb_af9005] SS:ESP 0068:d7391d4c




      ___________________________________________________________ 
Rise to the challenge for Sport Relief with Yahoo! For Good  

http://uk.promotions.yahoo.com/forgood/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
