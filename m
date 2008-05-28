Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4S4kjvg011059
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 00:46:45 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4S4kX7B017712
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 00:46:34 -0400
Received: by ug-out-1314.google.com with SMTP id s2so42906uge.6
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 21:46:33 -0700 (PDT)
Date: Wed, 28 May 2008 14:47:54 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080528144754.19dd6def@glory.loctelecom.ru>
In-Reply-To: <1211331167.4235.26.camel@pc10.localdom.local>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
	<20080520152426.5540ee7f@glory.loctelecom.ru>
	<1211331167.4235.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Bvq792+YEf2oADXWGfroQ6J"
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Beholder card M6 with MPEG2 coder
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

--MP_/Bvq792+YEf2oADXWGfroQ6J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi All

This is my test patch for MPEG2 encoder.
I removed start TS in each buffer_prepare function. Made ts_start and ts_st=
op functions.
Rework I2S initialization to more correct. More correct defines fo M6 famil=
y.

Now workflow is:
1. Start videoport (when module loaded)
2. Start audioport (when module loaded)
3. Reset TS cache, set DMA, start TS (when read /dev/video1)

But when I try read from /dev/video1 I received segfailt in function=20
saa7134_ts_start -> saa7134_set_dmabits(dev) -> assert_spin_locked(&dev->sl=
ock)

Anybody can help me solve this problem????

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:02:00.0, rev: 240, irq: 16, latency: 32, mmio: 0x=
e0002000
saa7133[0]: subsystem: 5ace:6193, board: Beholder BeholdTV M6 Extra [card=
=3D144,autodetected]
saa7133[0]: board init: gpio is c040000
saa6752hs 0-0020: saa6752hs: chip found @ 0x40
input: BeholdTV as /class/input/input7
ir-kbd-i2c: BeholdTV detected at i2c-0/0-002d/ir0 [saa7133[0]]
saa7133[0]: i2c eeprom 00: ce 5a 93 61 54 20 00 00 00 00 00 00 00 00 00 01
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
Manufacturer ID=3D 0x20, Chip ID =3D 2020. It is not a TEA5761
tuner' 0-0043: chip found @ 0x86 (saa7133[0])
tda9887 0-0043: creating new instance
tda9887 0-0043: tda988[5/6/7] found
All bytes are equal. It is not a TEA5767
tuner' 0-0060: chip found @ 0xc0 (saa7133[0])
tuner-simple 0-0060: creating new instance
tuner-simple 0-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7133[0]: registered device video1 [mpeg]
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xe0002000 irq 16 registered as card -1
DEBUG: saa7134_ts_start()
 packets =3D 312, buffs =3D 32
------------[ cut here ]------------
kernel BUG at /home/dimon/work/beholder/linux/kernel/v4l-dvb/v4l/saa7134-co=
re.c:479!
invalid opcode: 0000 [#1] SMP=20
Modules linked in: saa7134_alsa(F) saa7134_empress tuner_simple(F) tuner_ty=
pes tea5767(F) tda9887(F) tda8290(F) tea5761(F) tuner(F) saa7134(F) videode=
v v4l1_compat v4l2_common(F) videobuf_dma_sg videobuf_core ir_kbd_i2c(F) ir=
_common tveeprom(F) xt_tcpudp ipt_MASQUERADE iptable_nat nf_nat nf_conntrac=
k_ipv4 nf_conntrack iptable_filter ip_tables x_tables ppdev lp ac battery n=
ls_utf8 nls_cp437 vfat fat loop snd_cmipci snd_pcm_oss snd_mixer_oss snd_pc=
m saa6752hs(F) snd_page_alloc snd_opl3_lib snd_hwdep snd_mpu401_uart snd_se=
q_dummy parport_pc parport snd_seq_oss snd_seq_midi snd_seq_midi_event snd_=
seq floppy rtc snd_timer pcspkr psmouse snd_rawmidi snd_seq_device i2c_i801=
 snd soundcore compat_ioctl32 i2c_core button intel_agp agpgart evdev ext3 =
jbd mbcache ide_cd_mod cdrom ide_disk piix ide_core ehci_hcd uhci_hcd 8139t=
oo 8139cp mii usbcore thermal processor fan [last unloaded: ir_common]

Pid: 6681, comm: cat Tainted: GF        (2.6.25 #1)
EIP: 0060:[<d0963f86>] EFLAGS: 00010246 CPU: 0
EIP is at saa7134_set_dmabits+0x18/0x1e2 [saa7134]
EAX: 0000003b EBX: c03ab000 ECX: d0812000 EDX: 0000003b
ESI: c03ab000 EDI: 00001000 EBP: 0804e000 ESP: c615df3c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cat (pid: 6681, ti=3Dc615c000 task=3Dc0650920 task.ti=3Dc615c000)
Stack: 0804e000 00000000 c03ab000 00001000 0804e000 d0965b8a d096ec47 00000=
138=20
       00000020 d096ec2c c03ab000 cfbd8080 d09213e3 cfbd8080 0804e000 d0921=
3bf=20
       00001000 c0159167 c615dfa0 cfbd8080 fffffff7 0804e000 c615c000 c0159=
55a=20
Call Trace:
 [<d0965b8a>] saa7134_ts_start+0x8c/0x10e [saa7134]
 [<d09213e3>] ts_read+0x24/0x4b [saa7134_empress]
 [<d09213bf>] ts_read+0x0/0x4b [saa7134_empress]
 [<c0159167>] vfs_read+0x81/0xf4
 [<c015955a>] sys_read+0x3c/0x63
 [<c01036a6>] sysenter_past_esp+0x5f/0x85
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 83 c4 14 c7 44 24 10 29 df 96 d0 5b 5e 5f e9 3b 82 7b ef 55 57 56 53 =
89 c3 83 ec 04 8b 40 18 0f b6 d4 25 ff 00 00 00 39 c2 75 04 <0f> 0b eb fe 8=
3 bb a4 06 00 00 00 0f 85 b1 01 00 00 8b 83 b0 05=20
EIP: [<d0963f86>] saa7134_set_dmabits+0x18/0x1e2 [saa7134] SS:ESP 0068:c615=
df3c
---[ end trace 78f2b1dfcb9f215d ]---
DEBUG: saa7134_ts_stop()


diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa6752hs.c
--- a/linux/drivers/media/video/saa7134/saa6752hs.c	Wed May 14 23:14:04 200=
8 +0000
+++ b/linux/drivers/media/video/saa7134/saa6752hs.c	Wed May 28 02:50:47 200=
8 +1000
@@ -506,6 +506,14 @@ static int saa6752hs_init(struct i2c_cli
 	buf[1] =3D 0x05;
 	i2c_master_send(client,buf,2);
=20
+/* FIXME start: Vendor specific patch for Beholder M6 */
+   /* Set leading null byte for TS */
+   buf[0] =3D 0xF6;
+   buf[1] =3D 0x00;
+   buf[2] =3D 0x01;
+   i2c_master_send(client,buf,3);
+/* FIXME stop */
+
 	/* compute PAT */
 	memcpy(localPAT, PAT, sizeof(PAT));
 	localPAT[17] =3D 0xe0 | ((h->params.ts_pid_pmt >> 8) & 0x0f);
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed May 14 23:14:04=
 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed May 28 02:50:47=
 2008 +1000
@@ -3979,7 +3979,8 @@ struct saa7134_board saa7134_boards[] =3D=20
 	[SAA7134_BOARD_BEHOLD_M6] =3D {
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
-		.name           =3D "Beholder BeholdTV M6 / BeholdTV M6 Extra",
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           =3D "Beholder BeholdTV M6",
 		.audio_clock    =3D 0x00187de7,
 		.tuner_type     =3D TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     =3D UNSET,
@@ -4005,6 +4006,83 @@ struct saa7134_board saa7134_boards[] =3D=20
 			.amux =3D LINE2,
 		},
 		.mpeg  =3D SAA7134_MPEG_EMPRESS,
+		.video_out =3D CCIR656,
+		.vid_port_opts  =3D ( SET_T_CODE_POLARITY_NON_INVERTED |
+		                    SET_CLOCK_NOT_DELAYED |
+				    SET_CLOCK_INVERTED |
+				    SET_VSYNC_OFF ),
+	},
+	[SAA7134_BOARD_BEHOLD_M63] =3D {
+		/* Igor Kuznetsov <igk@igk.ru> */
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           =3D "Beholder BeholdTV M63",
+		.audio_clock    =3D 0x00187de7,
+		.tuner_type     =3D TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     =3D UNSET,
+		.tuner_addr     =3D ADDR_UNSET,
+		.radio_addr     =3D ADDR_UNSET,
+		.tda9887_conf   =3D TDA9887_PRESENT,
+		.inputs         =3D {{
+			.name =3D name_tv,
+			.vmux =3D 3,
+			.amux =3D TV,
+			.tv   =3D 1,
+		},{
+			.name =3D name_comp1,
+			.vmux =3D 1,
+			.amux =3D LINE1,
+		},{
+			.name =3D name_svideo,
+			.vmux =3D 8,
+			.amux =3D LINE1,
+		}},
+		.radio =3D {
+			.name =3D name_radio,
+			.amux =3D LINE2,
+		},
+		.mpeg  =3D SAA7134_MPEG_EMPRESS,
+		.video_out =3D CCIR656,
+		.vid_port_opts  =3D ( SET_T_CODE_POLARITY_NON_INVERTED |
+		                    SET_CLOCK_NOT_DELAYED |
+				    SET_CLOCK_INVERTED |
+				    SET_VSYNC_OFF ),
+	},
+	[SAA7134_BOARD_BEHOLD_M6_EXTRA] =3D {
+		/* Igor Kuznetsov <igk@igk.ru> */
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           =3D "Beholder BeholdTV M6 Extra",
+		.audio_clock    =3D 0x00187de7,
+		.tuner_type     =3D TUNER_PHILIPS_FM1216ME_MK3,  /* FIXME: Must be PHILI=
PS_FM1216ME_MK5*/
+		.radio_type     =3D UNSET,
+		.tuner_addr     =3D ADDR_UNSET,
+		.radio_addr     =3D ADDR_UNSET,
+		.tda9887_conf   =3D TDA9887_PRESENT,
+		.inputs         =3D {{
+			.name =3D name_tv,
+			.vmux =3D 3,
+			.amux =3D TV,
+			.tv   =3D 1,
+		},{
+			.name =3D name_comp1,
+			.vmux =3D 1,
+			.amux =3D LINE1,
+		},{
+			.name =3D name_svideo,
+			.vmux =3D 8,
+			.amux =3D LINE1,
+		}},
+		.radio =3D {
+			.name =3D name_radio,
+			.amux =3D LINE2,
+		},
+		.mpeg  =3D SAA7134_MPEG_EMPRESS,
+		.video_out =3D CCIR656,
+		.vid_port_opts  =3D ( SET_T_CODE_POLARITY_NON_INVERTED |
+		                    SET_CLOCK_NOT_DELAYED |
+				    SET_CLOCK_INVERTED |
+				    SET_VSYNC_OFF ),
 	},
 	[SAA7134_BOARD_TWINHAN_DTV_DVB_3056] =3D {
 		.name           =3D "Twinhan Hybrid DTV-DVB 3056 PCI",
@@ -5272,13 +5350,13 @@ struct pci_device_id saa7134_pci_tbl[] =3D
 		.device       =3D PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    =3D 0x5ace,
 		.subdevice    =3D 0x6193,
-		.driver_data  =3D SAA7134_BOARD_BEHOLD_M6,
+		.driver_data  =3D SAA7134_BOARD_BEHOLD_M6_EXTRA,
 	}, {
 		.vendor       =3D PCI_VENDOR_ID_PHILIPS,
 		.device       =3D PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    =3D 0x5ace,
 		.subdevice    =3D 0x6191,
-		.driver_data  =3D SAA7134_BOARD_BEHOLD_M6,
+		.driver_data  =3D SAA7134_BOARD_BEHOLD_M63,
 	},{
 		.vendor       =3D PCI_VENDOR_ID_PHILIPS,
 		.device       =3D PCI_DEVICE_ID_PHILIPS_SAA7133,
@@ -5702,6 +5780,8 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 		dev->has_remote =3D SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 14 23:14:=
04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 28 05:28:=
56 2008 +1000
@@ -64,9 +64,9 @@ static void ts_reset_encoder(struct saa7
 		return;
=20
 	saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
-	msleep(10);
+	msleep(16);
 	saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
-	msleep(100);
+	msleep(32);
 	dev->empress_started =3D 0;
 }
=20
@@ -126,6 +126,9 @@ static int ts_release(struct inode *inod
 	/* stop the encoder */
 	ts_reset_encoder(dev);
=20
+	/* stop TS */
+	saa7134_ts_stop(dev);
+
 	/* Mute audio */
 	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
 		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
@@ -140,6 +143,9 @@ ts_read(struct file *file, char __user *
=20
 	if (!dev->empress_started)
 		ts_init_encoder(dev);
+
+	/* start TS */
+	saa7134_ts_start(dev);
=20
 	return videobuf_read_stream(&dev->empress_tsq,
 				    data, count, ppos, 0,
@@ -172,8 +178,7 @@ static int empress_querycap(struct file=20
 static int empress_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct saa7134_fh *fh =3D priv;
-	struct saa7134_dev *dev =3D fh->dev;
+	struct saa7134_dev *dev =3D file->private_data;
=20
 	strcpy(cap->driver, "saa7134");
 	strlcpy(cap->card, saa7134_boards[dev->board].name,
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Wed May 14 23:14:04=
 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Wed May 28 02:50:48=
 2008 +1000
@@ -541,6 +541,8 @@ void saa7134_set_i2c_ir(struct saa7134_d
 		break;
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
 		snprintf(ir->c.name, sizeof(ir->c.name), "BeholdTV");
 		ir->get_key   =3D get_key_beholdm6xx;
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-reg.h
--- a/linux/drivers/media/video/saa7134/saa7134-reg.h	Wed May 14 23:14:04 2=
008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-reg.h	Wed May 28 02:50:48 2=
008 +1000
@@ -368,6 +368,7 @@
 #define SAA7135_DSP_RWCLEAR			0x586
 #define SAA7135_DSP_RWCLEAR_RERR		    1
=20
+#define SAA7133_I2S_AUDIO_CONTROL               0x591
 /* ------------------------------------------------------------------ */
 /*
  * Local variables:
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-ts.c
--- a/linux/drivers/media/video/saa7134/saa7134-ts.c	Wed May 14 23:14:04 20=
08 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-ts.c	Wed May 28 07:51:32 20=
08 +1000
@@ -62,10 +62,6 @@ static int buffer_activate(struct saa713
 		saa_writel(SAA7134_RS_BA2(5),saa7134_buffer_base(buf));
 	}
=20
-	/* start DMA */
-	saa7134_set_dmabits(dev);
-
-	mod_timer(&dev->ts_q.timeout, jiffies+BUFFER_TIMEOUT);
 	return 0;
 }
=20
@@ -75,7 +71,6 @@ static int buffer_prepare(struct videobu
 	struct saa7134_dev *dev =3D q->priv_data;
 	struct saa7134_buf *buf =3D container_of(vb,struct saa7134_buf,vb);
 	unsigned int lines, llength, size;
-	u32 control;
 	int err;
=20
 	dprintk("buffer_prepare [%p,%s]\n",buf,v4l2_field_names[field]);
@@ -84,6 +79,7 @@ static int buffer_prepare(struct videobu
 	lines =3D dev->ts.nr_packets;
=20
 	size =3D lines * llength;
+=09
 	if (0 !=3D buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
=20
@@ -110,17 +106,6 @@ static int buffer_prepare(struct videobu
 			goto oops;
 	}
=20
-	/* dma: setup channel 5 (=3D TS) */
-	control =3D SAA7134_RS_CONTROL_BURST_16 |
-		  SAA7134_RS_CONTROL_ME |
-		  (buf->pt->dma >> 12);
-
-	saa_writeb(SAA7134_TS_DMA0, ((lines-1)&0xff));
-	saa_writeb(SAA7134_TS_DMA1, (((lines-1)>>8)&0xff));
-	saa_writeb(SAA7134_TS_DMA2, ((((lines-1)>>16)&0x3f) | 0x00)); /* TSNOPIT=
=3D0, TSCOLAP=3D0 */
-	saa_writel(SAA7134_RS_PITCH(5),TS_PACKET_SIZE);
-	saa_writel(SAA7134_RS_CONTROL(5),control);
-
 	buf->vb.state =3D VIDEOBUF_PREPARED;
 	buf->activate =3D buffer_activate;
 	buf->vb.field =3D field;
@@ -179,10 +164,8 @@ MODULE_PARM_DESC(ts_nr_packets,"size of=20
=20
 int saa7134_ts_init_hw(struct saa7134_dev *dev)
 {
-	/* deactivate TS softreset */
-	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
 	/* TSSOP high active, TSVAL high active, TSLOCK ignored */
-	saa_writeb(SAA7134_TS_PARALLEL, 0xec);
+	saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
 	saa_writeb(SAA7134_TS_PARALLEL_SERIAL, (TS_PACKET_SIZE-1));
 	saa_writeb(SAA7134_TS_DMA0, ((dev->ts.nr_packets-1)&0xff));
 	saa_writeb(SAA7134_TS_DMA1, (((dev->ts.nr_packets-1)>>8)&0xff));
@@ -202,7 +185,7 @@ int saa7134_ts_init1(struct saa7134_dev=20
 		tsbufs =3D VIDEO_MAX_FRAME;
 	if (ts_nr_packets < 4)
 		ts_nr_packets =3D 4;
-	if (ts_nr_packets > 312)
+	if (ts_nr_packets >=3D 312)
 		ts_nr_packets =3D 312;
 	dev->ts.nr_bufs    =3D tsbufs;
 	dev->ts.nr_packets =3D ts_nr_packets;
@@ -250,6 +233,60 @@ void saa7134_irq_ts_done(struct saa7134_
 	spin_unlock(&dev->slock);
 }
=20
+/* Test function for start TS */
+//void saa7134_ts_start(struct videobuf_queue *q, struct videobuf_buffer *=
vb)
+void saa7134_ts_start(struct saa7134_dev *dev)
+{
+//	struct saa7134_dev *dev =3D q->priv_data;
+//	struct saa7134_buf *buf =3D container_of(vb,struct saa7134_buf,vb);
+	unsigned int lines;
+	u32 control;
+
+	printk("DEBUG: saa7134_ts_start()\n");
+
+	lines =3D dev->ts.nr_packets;
+
+	printk(" packets =3D %d, buffs =3D %d\n",dev->ts.nr_packets, dev->ts.nr_b=
ufs);
+
+	/* dma: setup channel 5 (=3D TS) */
+	control =3D SAA7134_RS_CONTROL_BURST_16 |
+		  SAA7134_RS_CONTROL_ME |
+		  (dev->ts.pt_ts.dma >> 12);
+
+	saa_writeb(SAA7134_TS_DMA0, ((lines-1)&0xff));
+	saa_writeb(SAA7134_TS_DMA1, (((lines-1)>>8)&0xff));
+	saa_writeb(SAA7134_TS_DMA2, ((((lines-1)>>16)&0x3f) | 0x00)); /* TSNOPIT=
=3D0, TSCOLAP=3D0 */
+	saa_writel(SAA7134_RS_PITCH(5),TS_PACKET_SIZE);
+	saa_writel(SAA7134_RS_CONTROL(5),control);
+
+	/* start DMA */
+	saa7134_set_dmabits(dev);
+
+	mod_timer(&dev->ts_q.timeout, jiffies+BUFFER_TIMEOUT);
+
+	/* Clear TS cache */
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x03);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x01);
+
+	/* TS clock non-inverted */
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+
+	/* Start TS stream */
+	saa_writeb(SAA7134_TS_SERIAL0, 0x40);
+	saa_writeb(SAA7134_TS_PARALLEL, 0xEC);
+}
+
+/* Test function for stop TS */
+void saa7134_ts_stop(struct saa7134_dev *dev)
+{
+	printk("DEBUG: saa7134_ts_stop()\n");
+	saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
+}
+
+EXPORT_SYMBOL(saa7134_ts_start);
+EXPORT_SYMBOL(saa7134_ts_stop);
 /* ----------------------------------------------------------- */
 /*
  * Local variables:
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Wed May 14 23:14:=
04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Wed May 28 02:50:=
48 2008 +1000
@@ -928,13 +928,34 @@ void saa7134_enable_i2s(struct saa7134_d
=20
 	if (!card_is_empress(dev))
 		return;
-	i2s_format =3D (dev->input->amux =3D=3D TV) ? 0x00 : 0x01;
-
-	/* enable I2S audio output for the mpeg encoder */
-	saa_writeb(SAA7134_I2S_OUTPUT_SELECT,  0x80);
-	saa_writeb(SAA7134_I2S_OUTPUT_FORMAT,  i2s_format);
-	saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,   0x0F);
-	saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x01);
+
+	if (dev->pci->device =3D=3D PCI_DEVICE_ID_PHILIPS_SAA7130)
+		return;
+
+	/* configure GPIO for out */
+	saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x0E000000, 0x00000000);
+
+	switch (dev->pci->device) {
+	    case PCI_DEVICE_ID_PHILIPS_SAA7133:
+	    case PCI_DEVICE_ID_PHILIPS_SAA7135:
+                /* Set I2S format (SONY) =C2=A0*/
+		saa_writeb(SAA7133_I2S_AUDIO_CONTROL, 0x00);
+		/* Start I2S */
+		saa_writeb(SAA7134_I2S_AUDIO_OUTPUT, 0x11);
+		break;
+
+	    case PCI_DEVICE_ID_PHILIPS_SAA7134:
+		i2s_format =3D (dev->input->amux =3D=3D TV) ? 0x00 : 0x01;
+
+		/* enable I2S audio output for the mpeg encoder */
+		saa_writeb(SAA7134_I2S_OUTPUT_SELECT, 0x80);
+		saa_writeb(SAA7134_I2S_OUTPUT_FORMAT, i2s_format);
+		saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,  0x0F);
+		saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,  0x01);
+
+	    default:
+		break;
+	}
 }
=20
 int saa7134_tvaudio_rx2mode(u32 rx)
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Wed May 14 23:14:04=
 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Wed May 28 02:50:48=
 2008 +1000
@@ -2475,7 +2475,6 @@ int saa7134_videoport_init(struct saa713
 		video_reg &=3D ~VP_T_CODE_P_INVERTED;
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL1, video_reg);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL2, video_out[vo][2]);
-	saa_writeb(SAA7134_VIDEO_PORT_CTRL3, video_out[vo][3]);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL4, video_out[vo][4]);
 	video_reg =3D video_out[vo][5];
 	if (vid_port_opts & SET_CLOCK_NOT_DELAYED)
@@ -2491,6 +2490,9 @@ int saa7134_videoport_init(struct saa713
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL6, video_reg);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL7, video_out[vo][7]);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL8, video_out[vo][8]);
+
+	/* Start videoport */
+	saa_writeb(SAA7134_VIDEO_PORT_CTRL3, video_out[vo][3]);
=20
 	return 0;
 }
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Wed May 14 23:14:04 2008 =
+0000
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed May 28 03:21:45 2008 =
+1000
@@ -271,7 +271,8 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
 #define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
 #define SAA7134_BOARD_BEHOLD_H6      142
-
+#define SAA7134_BOARD_BEHOLD_M63      143
+#define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
=20
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8
@@ -708,6 +709,8 @@ void saa7134_ts_unregister(struct saa713
=20
 int saa7134_ts_init_hw(struct saa7134_dev *dev);
=20
+void saa7134_ts_start(struct saa7134_dev *dev);
+void saa7134_ts_stop(struct saa7134_dev *dev);
 /* ----------------------------------------------------------- */
 /* saa7134-vbi.c                                               */
=20


With my best regards, Dmitry.

--MP_/Bvq792+YEf2oADXWGfroQ6J
Content-Type: text/x-patch; name=empress_test_02.diff
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=empress_test_02.diff

diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa6752hs.c
--- a/linux/drivers/media/video/saa7134/saa6752hs.c	Wed May 14 23:14:04 200=
8 +0000
+++ b/linux/drivers/media/video/saa7134/saa6752hs.c	Wed May 28 02:50:47 200=
8 +1000
@@ -506,6 +506,14 @@ static int saa6752hs_init(struct i2c_cli
 	buf[1] =3D 0x05;
 	i2c_master_send(client,buf,2);
=20
+/* FIXME start: Vendor specific patch for Beholder M6 */
+   /* Set leading null byte for TS */
+   buf[0] =3D 0xF6;
+   buf[1] =3D 0x00;
+   buf[2] =3D 0x01;
+   i2c_master_send(client,buf,3);
+/* FIXME stop */
+
 	/* compute PAT */
 	memcpy(localPAT, PAT, sizeof(PAT));
 	localPAT[17] =3D 0xe0 | ((h->params.ts_pid_pmt >> 8) & 0x0f);
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed May 14 23:14:04=
 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed May 28 02:50:47=
 2008 +1000
@@ -3979,7 +3979,8 @@ struct saa7134_board saa7134_boards[] =3D=20
 	[SAA7134_BOARD_BEHOLD_M6] =3D {
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
-		.name           =3D "Beholder BeholdTV M6 / BeholdTV M6 Extra",
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           =3D "Beholder BeholdTV M6",
 		.audio_clock    =3D 0x00187de7,
 		.tuner_type     =3D TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     =3D UNSET,
@@ -4005,6 +4006,83 @@ struct saa7134_board saa7134_boards[] =3D=20
 			.amux =3D LINE2,
 		},
 		.mpeg  =3D SAA7134_MPEG_EMPRESS,
+		.video_out =3D CCIR656,
+		.vid_port_opts  =3D ( SET_T_CODE_POLARITY_NON_INVERTED |
+		                    SET_CLOCK_NOT_DELAYED |
+				    SET_CLOCK_INVERTED |
+				    SET_VSYNC_OFF ),
+	},
+	[SAA7134_BOARD_BEHOLD_M63] =3D {
+		/* Igor Kuznetsov <igk@igk.ru> */
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           =3D "Beholder BeholdTV M63",
+		.audio_clock    =3D 0x00187de7,
+		.tuner_type     =3D TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     =3D UNSET,
+		.tuner_addr     =3D ADDR_UNSET,
+		.radio_addr     =3D ADDR_UNSET,
+		.tda9887_conf   =3D TDA9887_PRESENT,
+		.inputs         =3D {{
+			.name =3D name_tv,
+			.vmux =3D 3,
+			.amux =3D TV,
+			.tv   =3D 1,
+		},{
+			.name =3D name_comp1,
+			.vmux =3D 1,
+			.amux =3D LINE1,
+		},{
+			.name =3D name_svideo,
+			.vmux =3D 8,
+			.amux =3D LINE1,
+		}},
+		.radio =3D {
+			.name =3D name_radio,
+			.amux =3D LINE2,
+		},
+		.mpeg  =3D SAA7134_MPEG_EMPRESS,
+		.video_out =3D CCIR656,
+		.vid_port_opts  =3D ( SET_T_CODE_POLARITY_NON_INVERTED |
+		                    SET_CLOCK_NOT_DELAYED |
+				    SET_CLOCK_INVERTED |
+				    SET_VSYNC_OFF ),
+	},
+	[SAA7134_BOARD_BEHOLD_M6_EXTRA] =3D {
+		/* Igor Kuznetsov <igk@igk.ru> */
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           =3D "Beholder BeholdTV M6 Extra",
+		.audio_clock    =3D 0x00187de7,
+		.tuner_type     =3D TUNER_PHILIPS_FM1216ME_MK3,  /* FIXME: Must be PHILI=
PS_FM1216ME_MK5*/
+		.radio_type     =3D UNSET,
+		.tuner_addr     =3D ADDR_UNSET,
+		.radio_addr     =3D ADDR_UNSET,
+		.tda9887_conf   =3D TDA9887_PRESENT,
+		.inputs         =3D {{
+			.name =3D name_tv,
+			.vmux =3D 3,
+			.amux =3D TV,
+			.tv   =3D 1,
+		},{
+			.name =3D name_comp1,
+			.vmux =3D 1,
+			.amux =3D LINE1,
+		},{
+			.name =3D name_svideo,
+			.vmux =3D 8,
+			.amux =3D LINE1,
+		}},
+		.radio =3D {
+			.name =3D name_radio,
+			.amux =3D LINE2,
+		},
+		.mpeg  =3D SAA7134_MPEG_EMPRESS,
+		.video_out =3D CCIR656,
+		.vid_port_opts  =3D ( SET_T_CODE_POLARITY_NON_INVERTED |
+		                    SET_CLOCK_NOT_DELAYED |
+				    SET_CLOCK_INVERTED |
+				    SET_VSYNC_OFF ),
 	},
 	[SAA7134_BOARD_TWINHAN_DTV_DVB_3056] =3D {
 		.name           =3D "Twinhan Hybrid DTV-DVB 3056 PCI",
@@ -5272,13 +5350,13 @@ struct pci_device_id saa7134_pci_tbl[] =3D
 		.device       =3D PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    =3D 0x5ace,
 		.subdevice    =3D 0x6193,
-		.driver_data  =3D SAA7134_BOARD_BEHOLD_M6,
+		.driver_data  =3D SAA7134_BOARD_BEHOLD_M6_EXTRA,
 	}, {
 		.vendor       =3D PCI_VENDOR_ID_PHILIPS,
 		.device       =3D PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    =3D 0x5ace,
 		.subdevice    =3D 0x6191,
-		.driver_data  =3D SAA7134_BOARD_BEHOLD_M6,
+		.driver_data  =3D SAA7134_BOARD_BEHOLD_M63,
 	},{
 		.vendor       =3D PCI_VENDOR_ID_PHILIPS,
 		.device       =3D PCI_DEVICE_ID_PHILIPS_SAA7133,
@@ -5702,6 +5780,8 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 		dev->has_remote =3D SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 14 23:14:=
04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 28 05:28:=
56 2008 +1000
@@ -64,9 +64,9 @@ static void ts_reset_encoder(struct saa7
 		return;
=20
 	saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
-	msleep(10);
+	msleep(16);
 	saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
-	msleep(100);
+	msleep(32);
 	dev->empress_started =3D 0;
 }
=20
@@ -126,6 +126,9 @@ static int ts_release(struct inode *inod
 	/* stop the encoder */
 	ts_reset_encoder(dev);
=20
+	/* stop TS */
+	saa7134_ts_stop(dev);
+
 	/* Mute audio */
 	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
 		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
@@ -140,6 +143,9 @@ ts_read(struct file *file, char __user *
=20
 	if (!dev->empress_started)
 		ts_init_encoder(dev);
+
+	/* start TS */
+	saa7134_ts_start(dev);
=20
 	return videobuf_read_stream(&dev->empress_tsq,
 				    data, count, ppos, 0,
@@ -172,8 +178,7 @@ static int empress_querycap(struct file=20
 static int empress_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct saa7134_fh *fh =3D priv;
-	struct saa7134_dev *dev =3D fh->dev;
+	struct saa7134_dev *dev =3D file->private_data;
=20
 	strcpy(cap->driver, "saa7134");
 	strlcpy(cap->card, saa7134_boards[dev->board].name,
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Wed May 14 23:14:04=
 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Wed May 28 02:50:48=
 2008 +1000
@@ -541,6 +541,8 @@ void saa7134_set_i2c_ir(struct saa7134_d
 		break;
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
 		snprintf(ir->c.name, sizeof(ir->c.name), "BeholdTV");
 		ir->get_key   =3D get_key_beholdm6xx;
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-reg.h
--- a/linux/drivers/media/video/saa7134/saa7134-reg.h	Wed May 14 23:14:04 2=
008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-reg.h	Wed May 28 02:50:48 2=
008 +1000
@@ -368,6 +368,7 @@
 #define SAA7135_DSP_RWCLEAR			0x586
 #define SAA7135_DSP_RWCLEAR_RERR		    1
=20
+#define SAA7133_I2S_AUDIO_CONTROL               0x591
 /* ------------------------------------------------------------------ */
 /*
  * Local variables:
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-ts.c
--- a/linux/drivers/media/video/saa7134/saa7134-ts.c	Wed May 14 23:14:04 20=
08 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-ts.c	Wed May 28 07:51:32 20=
08 +1000
@@ -62,10 +62,6 @@ static int buffer_activate(struct saa713
 		saa_writel(SAA7134_RS_BA2(5),saa7134_buffer_base(buf));
 	}
=20
-	/* start DMA */
-	saa7134_set_dmabits(dev);
-
-	mod_timer(&dev->ts_q.timeout, jiffies+BUFFER_TIMEOUT);
 	return 0;
 }
=20
@@ -75,7 +71,6 @@ static int buffer_prepare(struct videobu
 	struct saa7134_dev *dev =3D q->priv_data;
 	struct saa7134_buf *buf =3D container_of(vb,struct saa7134_buf,vb);
 	unsigned int lines, llength, size;
-	u32 control;
 	int err;
=20
 	dprintk("buffer_prepare [%p,%s]\n",buf,v4l2_field_names[field]);
@@ -84,6 +79,7 @@ static int buffer_prepare(struct videobu
 	lines =3D dev->ts.nr_packets;
=20
 	size =3D lines * llength;
+=09
 	if (0 !=3D buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
=20
@@ -110,17 +106,6 @@ static int buffer_prepare(struct videobu
 			goto oops;
 	}
=20
-	/* dma: setup channel 5 (=3D TS) */
-	control =3D SAA7134_RS_CONTROL_BURST_16 |
-		  SAA7134_RS_CONTROL_ME |
-		  (buf->pt->dma >> 12);
-
-	saa_writeb(SAA7134_TS_DMA0, ((lines-1)&0xff));
-	saa_writeb(SAA7134_TS_DMA1, (((lines-1)>>8)&0xff));
-	saa_writeb(SAA7134_TS_DMA2, ((((lines-1)>>16)&0x3f) | 0x00)); /* TSNOPIT=
=3D0, TSCOLAP=3D0 */
-	saa_writel(SAA7134_RS_PITCH(5),TS_PACKET_SIZE);
-	saa_writel(SAA7134_RS_CONTROL(5),control);
-
 	buf->vb.state =3D VIDEOBUF_PREPARED;
 	buf->activate =3D buffer_activate;
 	buf->vb.field =3D field;
@@ -179,10 +164,8 @@ MODULE_PARM_DESC(ts_nr_packets,"size of=20
=20
 int saa7134_ts_init_hw(struct saa7134_dev *dev)
 {
-	/* deactivate TS softreset */
-	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
 	/* TSSOP high active, TSVAL high active, TSLOCK ignored */
-	saa_writeb(SAA7134_TS_PARALLEL, 0xec);
+	saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
 	saa_writeb(SAA7134_TS_PARALLEL_SERIAL, (TS_PACKET_SIZE-1));
 	saa_writeb(SAA7134_TS_DMA0, ((dev->ts.nr_packets-1)&0xff));
 	saa_writeb(SAA7134_TS_DMA1, (((dev->ts.nr_packets-1)>>8)&0xff));
@@ -202,7 +185,7 @@ int saa7134_ts_init1(struct saa7134_dev=20
 		tsbufs =3D VIDEO_MAX_FRAME;
 	if (ts_nr_packets < 4)
 		ts_nr_packets =3D 4;
-	if (ts_nr_packets > 312)
+	if (ts_nr_packets >=3D 312)
 		ts_nr_packets =3D 312;
 	dev->ts.nr_bufs    =3D tsbufs;
 	dev->ts.nr_packets =3D ts_nr_packets;
@@ -250,6 +233,60 @@ void saa7134_irq_ts_done(struct saa7134_
 	spin_unlock(&dev->slock);
 }
=20
+/* Test function for start TS */
+//void saa7134_ts_start(struct videobuf_queue *q, struct videobuf_buffer *=
vb)
+void saa7134_ts_start(struct saa7134_dev *dev)
+{
+//	struct saa7134_dev *dev =3D q->priv_data;
+//	struct saa7134_buf *buf =3D container_of(vb,struct saa7134_buf,vb);
+	unsigned int lines;
+	u32 control;
+
+	printk("DEBUG: saa7134_ts_start()\n");
+
+	lines =3D dev->ts.nr_packets;
+
+	printk(" packets =3D %d, buffs =3D %d\n",dev->ts.nr_packets, dev->ts.nr_b=
ufs);
+
+	/* dma: setup channel 5 (=3D TS) */
+	control =3D SAA7134_RS_CONTROL_BURST_16 |
+		  SAA7134_RS_CONTROL_ME |
+		  (dev->ts.pt_ts.dma >> 12);
+
+	saa_writeb(SAA7134_TS_DMA0, ((lines-1)&0xff));
+	saa_writeb(SAA7134_TS_DMA1, (((lines-1)>>8)&0xff));
+	saa_writeb(SAA7134_TS_DMA2, ((((lines-1)>>16)&0x3f) | 0x00)); /* TSNOPIT=
=3D0, TSCOLAP=3D0 */
+	saa_writel(SAA7134_RS_PITCH(5),TS_PACKET_SIZE);
+	saa_writel(SAA7134_RS_CONTROL(5),control);
+
+	/* start DMA */
+	saa7134_set_dmabits(dev);
+
+	mod_timer(&dev->ts_q.timeout, jiffies+BUFFER_TIMEOUT);
+
+	/* Clear TS cache */
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x03);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+	saa_writeb(SAA7134_TS_SERIAL1, 0x01);
+
+	/* TS clock non-inverted */
+	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
+
+	/* Start TS stream */
+	saa_writeb(SAA7134_TS_SERIAL0, 0x40);
+	saa_writeb(SAA7134_TS_PARALLEL, 0xEC);
+}
+
+/* Test function for stop TS */
+void saa7134_ts_stop(struct saa7134_dev *dev)
+{
+	printk("DEBUG: saa7134_ts_stop()\n");
+	saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
+}
+
+EXPORT_SYMBOL(saa7134_ts_start);
+EXPORT_SYMBOL(saa7134_ts_stop);
 /* ----------------------------------------------------------- */
 /*
  * Local variables:
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Wed May 14 23:14:=
04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Wed May 28 02:50:=
48 2008 +1000
@@ -928,13 +928,34 @@ void saa7134_enable_i2s(struct saa7134_d
=20
 	if (!card_is_empress(dev))
 		return;
-	i2s_format =3D (dev->input->amux =3D=3D TV) ? 0x00 : 0x01;
-
-	/* enable I2S audio output for the mpeg encoder */
-	saa_writeb(SAA7134_I2S_OUTPUT_SELECT,  0x80);
-	saa_writeb(SAA7134_I2S_OUTPUT_FORMAT,  i2s_format);
-	saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,   0x0F);
-	saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x01);
+
+	if (dev->pci->device =3D=3D PCI_DEVICE_ID_PHILIPS_SAA7130)
+		return;
+
+	/* configure GPIO for out */
+	saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x0E000000, 0x00000000);
+
+	switch (dev->pci->device) {
+	    case PCI_DEVICE_ID_PHILIPS_SAA7133:
+	    case PCI_DEVICE_ID_PHILIPS_SAA7135:
+                /* Set I2S format (SONY) =C2=A0*/
+		saa_writeb(SAA7133_I2S_AUDIO_CONTROL, 0x00);
+		/* Start I2S */
+		saa_writeb(SAA7134_I2S_AUDIO_OUTPUT, 0x11);
+		break;
+
+	    case PCI_DEVICE_ID_PHILIPS_SAA7134:
+		i2s_format =3D (dev->input->amux =3D=3D TV) ? 0x00 : 0x01;
+
+		/* enable I2S audio output for the mpeg encoder */
+		saa_writeb(SAA7134_I2S_OUTPUT_SELECT, 0x80);
+		saa_writeb(SAA7134_I2S_OUTPUT_FORMAT, i2s_format);
+		saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,  0x0F);
+		saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,  0x01);
+
+	    default:
+		break;
+	}
 }
=20
 int saa7134_tvaudio_rx2mode(u32 rx)
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Wed May 14 23:14:04=
 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Wed May 28 02:50:48=
 2008 +1000
@@ -2475,7 +2475,6 @@ int saa7134_videoport_init(struct saa713
 		video_reg &=3D ~VP_T_CODE_P_INVERTED;
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL1, video_reg);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL2, video_out[vo][2]);
-	saa_writeb(SAA7134_VIDEO_PORT_CTRL3, video_out[vo][3]);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL4, video_out[vo][4]);
 	video_reg =3D video_out[vo][5];
 	if (vid_port_opts & SET_CLOCK_NOT_DELAYED)
@@ -2491,6 +2490,9 @@ int saa7134_videoport_init(struct saa713
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL6, video_reg);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL7, video_out[vo][7]);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL8, video_out[vo][8]);
+
+	/* Start videoport */
+	saa_writeb(SAA7134_VIDEO_PORT_CTRL3, video_out[vo][3]);
=20
 	return 0;
 }
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Wed May 14 23:14:04 2008 =
+0000
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed May 28 03:21:45 2008 =
+1000
@@ -271,7 +271,8 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
 #define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
 #define SAA7134_BOARD_BEHOLD_H6      142
-
+#define SAA7134_BOARD_BEHOLD_M63      143
+#define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
=20
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8
@@ -708,6 +709,8 @@ void saa7134_ts_unregister(struct saa713
=20
 int saa7134_ts_init_hw(struct saa7134_dev *dev);
=20
+void saa7134_ts_start(struct saa7134_dev *dev);
+void saa7134_ts_stop(struct saa7134_dev *dev);
 /* ----------------------------------------------------------- */
 /* saa7134-vbi.c                                               */
=20

--MP_/Bvq792+YEf2oADXWGfroQ6J
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/Bvq792+YEf2oADXWGfroQ6J--
