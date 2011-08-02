Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44287 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1HBTh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 15:37:56 -0400
Received: by wyg8 with SMTP id 8so71488wyg.19
        for <linux-media@vger.kernel.org>; Tue, 02 Aug 2011 12:37:55 -0700 (PDT)
Message-ID: <4E38520F.4070809@grawet.be>
Date: Tue, 02 Aug 2011 21:37:51 +0200
From: Laurent Grawet <laurent.grawet@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Bug: Kernel oops with Kopete due to DVB device
Content-Type: multipart/mixed;
 boundary="------------020602070409000102050803"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020602070409000102050803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bug initially submitted to https://bugs.kde.org/show_bug.cgi?id=279202

Hello,

Kopete crash and kernel oopses when opening "Settings -> Configure" dialog
due to presence of DVB-S PCI card (av7110) as /dev/video0. This happens 
everytime I try to configure Kopete in presence of my DVB PCI card. 
(see attachment)

Reproducible: Always

Steps to Reproduce:
Own a DVB card and try to configure Kopete.

Actual Results:  
Kopete crash and Kernel oopses.

Expected Results:  
Configure dialog opening.


Regards,

Laurent

--------------020602070409000102050803
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg.txt"

[27457.669041] BUG: unable to handle kernel NULL pointer dereference at  =
         (null)
[27457.669044] IP: [<ffffffff81331e79>] __mutex_lock_common+0xcb/0x193
[27457.669048] PGD 1b4e03067 PUD 1b471a067 PMD 0=20
[27457.669050] Oops: 0002 [#1] SMP=20
[27457.669052] last sysfs file: /sys/devices/virtual/video4linux/video0/d=
ev
[27457.669054] CPU 0=20
[27457.669054] Modules linked in: parport_pc ppdev lp parport bnep vboxne=
tadp(O) vboxnetflt(O) vboxdrv(O) rfcomm bluetooth rfkill crc16 acpi_cpufr=
eq mperf cpufreq_conservative cpufreq_powersave cpufreq_userspace cpufreq=
_stats snd_hrtimer act_police cls_flow cls_fw cls_u32 sch_tbf sch_prio sc=
h_htb sch_hfsc sch_ingress sch_sfq xt_realm xt_connlimit xt_addrtype ipta=
ble_raw xt_comment xt_recent ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP =
ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah nf_nat_tftp nf_nat_sn=
mp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat=
_irc nf_nat_h323 ip6_queue nf_nat_ftp nf_nat_amanda nf_conntrack_proto_ud=
plite nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_p=
roto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink n=
f_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntra=
ck_h323 ts_kmp nf_conntrack_ftp nf_conntrack_amanda xt_TPROXY xt_NFLOG nf=
netlink_log nf_tproxy_core xt_time xt_TCPMSS xt_tcpmss xt_sctp xt_policy =
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_multiport xt_mark xt_mac xt_=
limit xt_length xt_iprange xt_AUDIT xt_helper xt_hashlimit xt_DSCP xt_dsc=
p xt_dccp ipt_LOG xt_connmark iptable_nat xt_CLASSIFY nf_nat ip6t_LOG ip6=
t_REJECT xt_tcpudp xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack=
_ipv6 nf_defrag_ipv6 iptable_mangle xt_conntrack nf_conntrack ip6table_ra=
w ip6table_mangle nfnetlink iptable_filter ip_tables ip6table_filter ip6_=
tables x_tables microcode fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl=
 sunrpc w83627ehf hwmon_vid coretemp firewire_sbp2 loop snd_hda_codec_hdm=
i ftdi_sio usbserial stv0299 ves1x93 nvidia(P) snd_hda_codec_analog snd_h=
da_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_se=
q_midi snd_rawmidi snd_seq_midi_event snd_seq dvb_ttpci dvb_core snd_time=
r snd_seq_device saa7146_vv videodev snd media v4l2_compat_ioctl32 saa714=
6 videobuf_dma_sg videobuf_core ttpci_eeprom i2c_i801 soundcore snd_page_=
alloc i7core_edac pcspkr evdev i2c_core edac_core processor psmouse serio=
_raw thermal_sys wmi ext3 jbd mbcache dm_mod raid1 md_mod sg sr_mod cdrom=
 sd_mod usb_storage hid_logitech crc_t10dif ff_memless uas usbhid hid uhc=
i_hcd dc395x firewire_ohci firewire_core ahci libahci libata scsi_mod but=
ton ehci_hcd usbcore crc_itu_t sky2 [last unloaded: scsi_wait_scan]
[27457.669132]=20
[27457.669134] Pid: 12073, comm: kopete Tainted: P           O 2.6.39-2-a=
md64 #1 System manufacturer System Product Name/P6T DELUXE V2
[27457.669136] RIP: 0010:[<ffffffff81331e79>]  [<ffffffff81331e79>] __mut=
ex_lock_common+0xcb/0x193
[27457.669139] RSP: 0018:ffff88014e403ac8  EFLAGS: 00010246
[27457.669140] RAX: 0000000000000000 RBX: ffff8801b56749d8 RCX: ffff8801b=
56749f0
[27457.669141] RDX: ffff88014e403ae8 RSI: 0000000000000002 RDI: ffff8801b=
56749dc
[27457.669143] RBP: ffff8801a44d4240 R08: 0000000000000002 R09: 000000000=
0000000
[27457.669144] R10: 0000000000002f29 R11: ffff8801bfffcc00 R12: 000000000=
0000002
[27457.669145] R13: ffff8801b56749dc R14: ffff8801b56749e0 R15: ffff88014=
e402010
[27457.669147] FS:  00007f2f2d786760(0000) GS:ffff8801bfc00000(0000) knlG=
S:0000000000000000
[27457.669148] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[27457.669150] CR2: 0000000000000000 CR3: 0000000128b4a000 CR4: 000000000=
00006f0
[27457.669151] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[27457.669152] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[27457.669154] Process kopete (pid: 12073, threadinfo ffff88014e402000, t=
ask ffff8801a44d4240)
[27457.669155] Stack:
[27457.669156]  000000000000001e ffffffff810cb01a ffffea0005c86780 000000=
0000000000
[27457.669158]  ffff8801b56749e0 0000000000000000 ffff88014e402000 ffff88=
0100000000
[27457.669161]  0000000005c86780 ffff8801b56749d8 ffff88014e403da8 ffff88=
01b49f5400
[27457.669163] Call Trace:
[27457.669166]  [<ffffffff810cb01a>] ? zone_statistics+0x41/0x74
[27457.669170]  [<ffffffff8133200d>] ? mutex_lock+0x1a/0x33
[27457.669175]  [<ffffffffa01d0c4c>] ? videobuf_reqbufs+0x64/0x19f [video=
buf_core]
[27457.669180]  [<ffffffffa029c2ee>] ? __video_do_ioctl+0x1f68/0x4493 [vi=
deodev]
[27457.669184]  [<ffffffff810bc1be>] ? __alloc_pages_nodemask+0x13d/0x7c4=

[27457.669186]  [<ffffffff810b5d5a>] ? find_get_page+0x3b/0x5e
[27457.669188]  [<ffffffff810b76b3>] ? filemap_fault+0x1a3/0x34e
[27457.669191]  [<ffffffff810f88ee>] ? lookup_page_cgroup+0x2d/0x42
[27457.669193]  [<ffffffff810f564b>] ? mem_cgroup_update_page_stat+0x16/0=
xdd
[27457.669195]  [<ffffffff810d2404>] ? __do_fault+0x3f9/0x430
[27457.669200]  [<ffffffffa029eaee>] ? video_usercopy+0x2d5/0x388 [videod=
ev]
[27457.669205]  [<ffffffffa029a386>] ? v4l2_video_std_construct+0x52/0x52=
 [videodev]
[27457.669210]  [<ffffffffa02993c0>] ? v4l2_ioctl+0x7f/0x122 [videodev]
[27457.669213]  [<ffffffff811089e1>] ? do_vfs_ioctl+0x445/0x492
[27457.669215]  [<ffffffff81108a79>] ? sys_ioctl+0x4b/0x72
[27457.669217]  [<ffffffff81338e52>] ? system_call_fastpath+0x16/0x1b
[27457.669218] Code: f3 90 eb 93 4c 8d 6b 04 4c 8d 73 08 4c 89 ef e8 c2 0=
a 00 00 48 8b 43 10 48 8d 54 24 20 4c 89 74 24 20 48 89 53 10 48 89 44 24=
 28=20
[27457.669228]  89 10 83 ca ff 48 89 6c 24 30 89 d0 87 03 ff c8 74 53 44 =
88=20
[27457.669233] RIP  [<ffffffff81331e79>] __mutex_lock_common+0xcb/0x193
[27457.669235]  RSP <ffff88014e403ac8>
[27457.669236] CR2: 0000000000000000
[27457.669238] ---[ end trace 77418d8930e31700 ]---


--------------020602070409000102050803--
