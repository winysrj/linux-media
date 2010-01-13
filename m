Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:48750 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754226Ab0AMTqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 14:46:06 -0500
Received: from mail-in-05-z2.arcor-online.net (mail-in-05-z2.arcor-online.net [151.189.8.17])
	by mx.arcor.de (Postfix) with ESMTP id 9356333A833
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 20:46:03 +0100 (CET)
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net [151.189.21.54])
	by mail-in-05-z2.arcor-online.net (Postfix) with ESMTP id 87CC02DB191
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 20:46:03 +0100 (CET)
Received: from [192.168.2.102] (dslb-094-222-026-034.pools.arcor-ip.net [94.222.26.34])
	(Authenticated sender: stefan.ringel@arcor.de)
	by mail-in-14.arcor-online.net (Postfix) with ESMTPA id 1F38528ACA8
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 20:46:03 +0100 (CET)
Message-ID: <4B4E22ED.8020408@arcor.de>
Date: Wed, 13 Jan 2010 20:45:49 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
Content-Type: multipart/mixed;
 boundary="------------050304050308000204020201"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050304050308000204020201
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I found a bug in tm6000 module.

-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------050304050308000204020201
Content-Type: text/plain;
 name="bug_video_init.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="bug_video_init.txt"

Jan 13 20:23:22 linux-v5dy kernel: [  186.452166] BUG: unable to handle k=
ernel NULL pointer dereference at (null)
Jan 13 20:23:22 linux-v5dy kernel: [  186.452189] IP: [<ffffffffa1720c62>=
] tm6000_read_write_usb+0x92/0x490 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.452212] PGD 55136067 PUD 553920=
67 PMD 0=20
Jan 13 20:23:22 linux-v5dy kernel: [  186.452223] Oops: 0000 [#1] PREEMPT=
 SMP=20
Jan 13 20:23:22 linux-v5dy kernel: [  186.452232] last sysfs file: /sys/d=
evices/system/cpu/cpu1/cache/index2/shared_cpu_map
Jan 13 20:23:22 linux-v5dy kernel: [  186.452244] CPU 0=20
Jan 13 20:23:22 linux-v5dy kernel: [  186.452249] Modules linked in: mxb =
hexium_orion gspca_sunplus ov7670 tm6000 gspca_jeilinj gspca_sq905 gspca_=
sn9c20x gspca_spca561 vivi radio_maestro tuner gspca_stk014 dvb_usb_umt_0=
10 gspca_benq dvb_usb_nova_t_usb2 au0828 tda9875 gspca_etoms vpx3220 radi=
o_gemtek_pci cpia_usb saa6588 vp27smpx konicawc gspca_spca505 upd64031a t=
vaudio radio_mr800 bt819 saa7110 gspca_conex gspca_mars gspca_finepix qui=
ckcam_messenger cs53l32a dvb_usb_dibusb_mc tvp5150 cx2341x gspca_stv0680 =
cx88xx usbvision mantis ths7303 m52790 gspca_spca506 gspca_spca501 gspca_=
ov534 w9968cf saa7185 dvb_ttpci ks0127 cpia2 dvb_usb_dibusb_mb zr36067 hd=
pvr radio_si4713 tvp514x budget_av cx231xx gspca_sonixj gspca_ov519 saa67=
52hs cs5345 cafe_ccic saa5249 upd64083 ultracam mt9v011 radio_maxiradio g=
spca_spca500 gspca_pac7311 saa7115 dsbr100 au8522 saa7134 cpia_pp wm8775 =
dvb_usb_a800 si4713_i2c tda9840 bttv gspca_stv06xx tlv320aic23b saa717x o=
vcamchip hexium_gemini ibmcam tef6862 radio_usb_si470x adv7343 saa7127 ms=
p3400 em2
Jan 13 20:23:22 linux-v5dy kernel: 8xx saa7191 bt866 gspca_tv8532 tea6420=
 gspca_pac7302 gspca_zc3xx gspca_pac207 gspca_vc032x gspca_mr97310a adv71=
80 gspca_gl860 saa5246a tda7432 dvb_usb_ec168 budget_patch ov511 dvb_usb_=
dw2102 stradis snd_tea575x_tuner se401 dvb_usb_anysee pwc bw_qcam uvcvide=
o stv680 b2c2_flexcop_usb dvb_usb_cinergyT2 dvb_usb_au6610 dvb_usb_m920x =
dvb_usb_dib0700 dvb_usb_vp702x et61x251 v4l2_common zc0301 stkwebcam dvb_=
usb_cxusb mantis_core dm1105 dvb_usb_opera c_qcam dvb_usb_dtv5100 zr364xx=
 saa7146_vv dvb_usb_vp7045 vicam dvb_usb_gl861 dvb_usb_dtt200u dvb_usb_di=
gitv dvb_usb_friio budget usbvideo soc_camera_platform radio_tea5764 budg=
et_ci dvb_usb_gp8psk gspca_main ir_kbd_i2c dvb_usb_ce6230 meye b2c2_flexc=
op_pci cpia dvb_usb_af9005 dvb_usb_af9015 sn9c102 s2255drv dvb_usb_ttusb2=
 dvb_usb_dibusb_common w9966 lgdt3305 budget_core stv0299 pluto2 dib7000m=
 dib7000p tcm825x b2c2_flexcop smssdio ir_common zr36050 lgdt330x zr36016=
 smsusb videobuf_vmalloc or51132 videodev ttusb_dec zr36060 smsdvb saa716=
4 dib3000mc=20
Jan 13 20:23:22 linux-v5dy kernel: dib8000 tuner_simple dvb_usb videobuf_=
dma_sg dvb_ttusb_budget or51211 firedtv videobuf_dvb videobuf_dma_contig =
earth_pt1 stv0288 stb0899 sp887x v4l2_compat_ioctl32 s5h1409 mt2266 soc_m=
ediabus ds3000 tuner_types tda10023 tua6100 mt20xx btcx_risc tda18271 cx2=
2702 videocodec tda10086 tea5767 mt312 s921 max2165 dvb_dummy_fe tda8261 =
qt1010 af9013 cx88_vp3054_i2c tda1004x tda665x nxt200x ves1820 bcm3510 is=
l6423 zl10036 mxl5007t drx397xD sp8870 cx24113 tda8290 l64781 cx24110 tda=
827x dabusb saa7146 ttpci_eeprom stb6100 tda10048 tda826x ttusbdecfe s5h1=
411 lgdt3304 ves1x93 stv0297 dib3000mb tda8083 lnbp21 zl10039 dibx000_com=
mon snd_bt87x ir_core tda9887 isl6421 mt2060 mb86a16 zl10353 tda10021 dvb=
_usb_af9005_remote cx22700 lgs8gxx s5h1420 mt352 v4l1_compat dvb_core isl=
6405 xc5000 ec100 tea5761 stv6110x mxl5005s dvb_pll dib0090 stb6000 v4l2_=
int_device mt2131 videobuf_core tveeprom stv0900 lgs8gl5 atbm8830 stv6110=
 mc44s803 cx24116 cx24123 stv090x dib0070 si21xx tuner_xc2028 nxt6000 itd=
1000 smsmdtv
Jan 13 20:23:22 linux-v5dy kernel: sony_laptop rfkill mmc_core i2c_algo_b=
it ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_o=
ss snd_seq snd_seq_device edd vmnet ppdev parport_pc parport vmblock vsoc=
k vmci vmmon af_packet ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTR=
ACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_con=
ntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables=
 ip6table_filter cpufreq_conservative cpufreq_userspace ip6_tables cpufre=
q_powersave x_tables powernow_k8 fuse nls_iso8859_1 nls_cp437 vfat fat lo=
op dm_mod snd_hda_codec_intelhdmi snd_hda_codec_analog amd64_edac_mod snd=
_hda_intel ohci1394 snd_hda_codec edac_core sg sr_mod snd_hwdep ieee1394 =
edac_mce_amd nvidia(P) cdrom snd_pcm k8temp snd_timer serio_raw forcedeth=
 i2c_nforce2 snd snd_page_alloc asus_atk0110 pcspkr button ext4 jbd2 crc1=
6 fan processor ide_pci_generic amd74xx ide_core ata_generic thermal ther=
mal_sys pata_amd sata_nv
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] Pid: 5751, comm: v4l_id=
 Tainted: P           2.6.32-41.6-desktop #1 System Product Name
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] RIP: 0010:[<ffffffffa17=
20c62>]  [<ffffffffa1720c62>] tm6000_read_write_usb+0x92/0x490 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] RSP: 0000:ffff8800551a1=
b28  EFLAGS: 00010202
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] RAX: 0000000000000000 R=
BX: ffff880055161800 RCX: 00000000000000fe
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] RDX: 0000000000000000 R=
SI: 0000000000000000 RDI: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] RBP: 0000000000000040 R=
08: 00000000000000cb R09: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] R10: 0000000000000001 R=
11: 0000000000000001 R12: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] R13: 0000000000000000 R=
14: ffff880055161800 R15: 00000000000000cb
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] FS:  00007ff8730436f0(0=
000) GS:ffff880001e00000(0000) knlGS:0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] CS:  0010 DS: 0000 ES: =
0000 CR0: 000000008005003b
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] CR2: 0000000000000000 C=
R3: 0000000056d17000 CR4: 00000000000006f0
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] DR0: 0000000000000000 D=
R1: 0000000000000000 DR2: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] DR3: 0000000000000000 D=
R6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] Process v4l_id (pid: 57=
51, threadinfo ffff8800551a0000, task ffff88007f244040)
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] Stack:
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  ffff88007f244400 ffff8=
800551a1fd8 0000000000000286 ffffffff81060303
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] <0> ffff8800551a0000 ff=
ff8800551a1bc8 00000000ffffffff 0000000000000286
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] <0> ffffffff81c969c0 ff=
ffffff8106103a ffff88007ec64640 ffff88007f244040
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] Call Trace:
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffffa1721106>] t=
m6000_set_reg+0x26/0xf0 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffffa1724be2>] t=
m6000_load_std+0x42/0x90 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffffa1724def>] t=
m6000_set_standard+0x1bf/0x1e0 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffffa172164f>] t=
m6000_init_analog_mode+0x1ff/0x290 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffffa1723858>] t=
m6000_open+0x118/0x320 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffffa11dc403>] v=
4l2_open+0x73/0xc0 [videodev]
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffff81120031>] c=
hrdev_open+0x171/0x290
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffff81119caf>] _=
_dentry_open+0x14f/0x3e0
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffff8112982a>] d=
o_filp_open+0x2ca/0xa80
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffff811199fa>] d=
o_sys_open+0x6a/0x180
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<ffffffff81002ffb>] s=
ystem_call_fastpath+0x16/0x1b
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  [<00007ff872bb0a20>] 0=
x7ff872bb0a20
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] Code: d0 80 00 00 e8 70=
 0c 9f df 49 89 c4 40 84 ed 0f 88 e4 00 00 00 49 8b 86 20 06 00 00 48 8b =
b4 24 80 00 00 00 4c 89 e7 41 0f b7 d5 <8b> 18 e8 57 97 b1 df 49 8b be 20=
 06 00 00 c1 e3 08 81 cb 00 00=20
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] RIP  [<ffffffffa1720c62=
>] tm6000_read_write_usb+0x92/0x490 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.453006]  RSP <ffff8800551a1b28>=

Jan 13 20:23:22 linux-v5dy kernel: [  186.453006] CR2: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.453802] ---[ end trace 6c054c4c=
a9faaf8d ]---
Jan 13 20:23:22 linux-v5dy udevd-work[2775]: 'v4l_id /dev/.tmp-char-81:1'=
 unexpected exit with status 0x0009
Jan 13 20:23:22 linux-v5dy kernel: [  186.472394] usb 1-9: uevent
Jan 13 20:23:22 linux-v5dy kernel: [  186.472523] usb usb1: uevent
Jan 13 20:23:22 linux-v5dy kernel: [  186.477674] usb 1-9: uevent
Jan 13 20:23:22 linux-v5dy kernel: [  186.477780] usb usb1: uevent
Jan 13 20:23:22 linux-v5dy kernel: [  186.510208] tm6000: open called (de=
v=3Dvideo1)
Jan 13 20:23:22 linux-v5dy kernel: [  186.510366] BUG: unable to handle k=
ernel NULL pointer dereference at (null)
Jan 13 20:23:22 linux-v5dy kernel: [  186.510384] IP: [<ffffffffa1720c62>=
] tm6000_read_write_usb+0x92/0x490 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.510410] PGD 5e55e067 PUD 5536c0=
67 PMD 0=20
Jan 13 20:23:22 linux-v5dy kernel: [  186.510423] Oops: 0000 [#2] PREEMPT=
 SMP=20
Jan 13 20:23:22 linux-v5dy kernel: [  186.510434] last sysfs file: /sys/d=
evices/pci0000:00/0000:00:0a.1/usb1/uevent
Jan 13 20:23:22 linux-v5dy kernel: [  186.510448] CPU 0=20
Jan 13 20:23:22 linux-v5dy kernel: [  186.510456] Modules linked in: hopp=
er tea6415c mxb hexium_orion gspca_sunplus ov7670 tm6000 gspca_jeilinj gs=
pca_sq905 gspca_sn9c20x gspca_spca561 vivi radio_maestro tuner gspca_stk0=
14 dvb_usb_umt_010 gspca_benq dvb_usb_nova_t_usb2 au0828 tda9875 gspca_et=
oms vpx3220 radio_gemtek_pci cpia_usb saa6588 vp27smpx konicawc gspca_spc=
a505 upd64031a tvaudio radio_mr800 bt819 saa7110 gspca_conex gspca_mars g=
spca_finepix quickcam_messenger cs53l32a dvb_usb_dibusb_mc tvp5150 cx2341=
x gspca_stv0680 cx88xx usbvision mantis ths7303 m52790 gspca_spca506 gspc=
a_spca501 gspca_ov534 w9968cf saa7185 dvb_ttpci ks0127 cpia2 dvb_usb_dibu=
sb_mb zr36067 hdpvr radio_si4713 tvp514x budget_av cx231xx gspca_sonixj g=
spca_ov519 saa6752hs cs5345 cafe_ccic saa5249 upd64083 ultracam mt9v011 r=
adio_maxiradio gspca_spca500 gspca_pac7311 saa7115 dsbr100 au8522 saa7134=
 cpia_pp wm8775 dvb_usb_a800 si4713_i2c tda9840 bttv gspca_stv06xx tlv320=
aic23b saa717x ovcamchip hexium_gemini ibmcam tef6862 radio_usb_si470x ad=
v7343 saa
Jan 13 20:23:22 linux-v5dy kernel: 7127 msp3400 em28xx saa7191 bt866 gspc=
a_tv8532 tea6420 gspca_pac7302 gspca_zc3xx gspca_pac207 gspca_vc032x gspc=
a_mr97310a adv7180 gspca_gl860 saa5246a tda7432 dvb_usb_ec168 budget_patc=
h ov511 dvb_usb_dw2102 stradis snd_tea575x_tuner se401 dvb_usb_anysee pwc=
 bw_qcam uvcvideo stv680 b2c2_flexcop_usb dvb_usb_cinergyT2 dvb_usb_au661=
0 dvb_usb_m920x dvb_usb_dib0700 dvb_usb_vp702x et61x251 v4l2_common zc030=
1 stkwebcam dvb_usb_cxusb mantis_core dm1105 dvb_usb_opera c_qcam dvb_usb=
_dtv5100 zr364xx saa7146_vv dvb_usb_vp7045 vicam dvb_usb_gl861 dvb_usb_dt=
t200u dvb_usb_digitv dvb_usb_friio budget usbvideo soc_camera_platform ra=
dio_tea5764 budget_ci dvb_usb_gp8psk gspca_main ir_kbd_i2c dvb_usb_ce6230=
 meye b2c2_flexcop_pci cpia dvb_usb_af9005 dvb_usb_af9015 sn9c102 s2255dr=
v dvb_usb_ttusb2 dvb_usb_dibusb_common w9966 lgdt3305 budget_core stv0299=
 pluto2 dib7000m dib7000p tcm825x b2c2_flexcop smssdio ir_common zr36050 =
lgdt330x zr36016 smsusb videobuf_vmalloc or51132 videodev ttusb_dec zr360=
60 smsdvb sa
Jan 13 20:23:22 linux-v5dy kernel: a7164 dib3000mc dib8000 tuner_simple d=
vb_usb videobuf_dma_sg dvb_ttusb_budget or51211 firedtv videobuf_dvb vide=
obuf_dma_contig earth_pt1 stv0288 stb0899 sp887x v4l2_compat_ioctl32 s5h1=
409 mt2266 soc_mediabus ds3000 tuner_types tda10023 tua6100 mt20xx btcx_r=
isc tda18271 cx22702 videocodec tda10086 tea5767 mt312 s921 max2165 dvb_d=
ummy_fe tda8261 qt1010 af9013 cx88_vp3054_i2c tda1004x tda665x nxt200x ve=
s1820 bcm3510 isl6423 zl10036 mxl5007t drx397xD sp8870 cx24113 tda8290 l6=
4781 cx24110 tda827x dabusb saa7146 ttpci_eeprom stb6100 tda10048 tda826x=
 ttusbdecfe s5h1411 lgdt3304 ves1x93 stv0297 dib3000mb tda8083 lnbp21 zl1=
0039 dibx000_common snd_bt87x ir_core tda9887 isl6421 mt2060 mb86a16 zl10=
353 tda10021 dvb_usb_af9005_remote cx22700 lgs8gxx s5h1420 mt352 v4l1_com=
pat dvb_core isl6405 xc5000 ec100 tea5761 stv6110x mxl5005s dvb_pll dib00=
90 stb6000 v4l2_int_device mt2131 videobuf_core tveeprom stv0900 lgs8gl5 =
atbm8830 stv6110 mc44s803 cx24116 cx24123 stv090x dib0070 si21xx tuner_xc=
2028 nxt6000
Jan 13 20:23:22 linux-v5dy kernel: itd1000 smsmdtv sony_laptop rfkill mmc=
_core i2c_algo_bit ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit snd_pcm=
_oss snd_mixer_oss snd_seq snd_seq_device edd vmnet ppdev parport_pc parp=
ort vmblock vsock vmci vmmon af_packet ip6t_REJECT nf_conntrack_ipv6 ip6t=
able_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6tab=
le_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defra=
g_ipv4 ip_tables ip6table_filter cpufreq_conservative cpufreq_userspace i=
p6_tables cpufreq_powersave x_tables powernow_k8 fuse nls_iso8859_1 nls_c=
p437 vfat fat loop dm_mod snd_hda_codec_intelhdmi snd_hda_codec_analog am=
d64_edac_mod snd_hda_intel ohci1394 snd_hda_codec edac_core sg sr_mod snd=
_hwdep ieee1394 edac_mce_amd nvidia(P) cdrom snd_pcm k8temp snd_timer ser=
io_raw forcedeth i2c_nforce2 snd snd_page_alloc asus_atk0110 pcspkr butto=
n ext4 jbd2 crc16 fan processor ide_pci_generic amd74xx ide_core ata_gene=
ric thermal thermal_sys pata_amd sata_nv
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] Pid: 5769, comm: hald-p=
robe-vide Tainted: P      D    2.6.32-41.6-desktop #1 System Product Name=

Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] RIP: 0010:[<ffffffffa17=
20c62>]  [<ffffffffa1720c62>] tm6000_read_write_usb+0x92/0x490 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] RSP: 0018:ffff8800551a5=
b78  EFLAGS: 00010202
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] RAX: 0000000000000000 R=
BX: ffff880055161800 RCX: 000000000000003f
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] RDX: 0000000000000000 R=
SI: 0000000000000000 RDI: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] RBP: 0000000000000040 R=
08: 0000000000000001 R09: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] R10: 0000000000000001 R=
11: 0000000000000082 R12: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] R13: 0000000000000000 R=
14: ffff880055161800 R15: 0000000000000001
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] FS:  00007f1e2f6a06f0(0=
000) GS:ffff880001e00000(0000) knlGS:0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] CS:  0010 DS: 0000 ES: =
0000 CR0: 0000000080050033
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] CR2: 0000000000000000 C=
R3: 00000000639d9000 CR4: 00000000000006f0
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] DR0: 0000000000000000 D=
R1: 0000000000000000 DR2: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] DR3: 0000000000000000 D=
R6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] Process hald-probe-vide=
 (pid: 5769, threadinfo ffff8800551a4000, task ffff8800551ac080)
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] Stack:
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  00000000ffffffcd fffff=
fff81050f02 00000000000000ba ffffffff81c96364
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] <0> 0000000000000036 ff=
ff8800551a5bd8 0000000000000036 0000000000000202
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] <0> ffff8800551a5be6 ff=
ff8800551a5be7 0000000f551a5c58 0000000000000202
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] Call Trace:
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffffa1721106>] t=
m6000_set_reg+0x26/0xf0 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffffa172147d>] t=
m6000_init_analog_mode+0x2d/0x290 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffffa1723858>] t=
m6000_open+0x118/0x320 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffffa11dc403>] v=
4l2_open+0x73/0xc0 [videodev]
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffff81120031>] c=
hrdev_open+0x171/0x290
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffff81119caf>] _=
_dentry_open+0x14f/0x3e0
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffff8112982a>] d=
o_filp_open+0x2ca/0xa80
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffff811199fa>] d=
o_sys_open+0x6a/0x180
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<ffffffff81002ffb>] s=
ystem_call_fastpath+0x16/0x1b
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  [<00007f1e2ee47390>] 0=
x7f1e2ee47390
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] Code: d0 80 00 00 e8 70=
 0c 9f df 49 89 c4 40 84 ed 0f 88 e4 00 00 00 49 8b 86 20 06 00 00 48 8b =
b4 24 80 00 00 00 4c 89 e7 41 0f b7 d5 <8b> 18 e8 57 97 b1 df 49 8b be 20=
 06 00 00 c1 e3 08 81 cb 00 00=20
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] RIP  [<ffffffffa1720c62=
>] tm6000_read_write_usb+0x92/0x490 [tm6000]
Jan 13 20:23:22 linux-v5dy kernel: [  186.511009]  RSP <ffff8800551a5b78>=

Jan 13 20:23:22 linux-v5dy kernel: [  186.511009] CR2: 0000000000000000
Jan 13 20:23:22 linux-v5dy kernel: [  186.520032] ---[ end trace 6c054c4c=
a9faaf8e ]---

--------------050304050308000204020201--
