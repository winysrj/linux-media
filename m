Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bld-mail11.adl2.internode.on.net ([203.16.214.75]
	helo=mail.internode.on.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robin.perkins@internode.on.net>) id 1LD92S-00052T-6u
	for linux-dvb@linuxtv.org; Thu, 18 Dec 2008 03:55:02 +0100
Received: from [10.1.1.104] (unverified [124.171.179.144])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38903543-1927428
	for <linux-dvb@linuxtv.org>; Thu, 18 Dec 2008 13:24:38 +1030 (CDT)
Message-Id: <A4711CA1-6F97-4D35-8A67-2BF391D3D1ED@internode.on.net>
From: Robin Perkins <robin.perkins@internode.on.net>
To: LinuxTV-DVB <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Thu, 18 Dec 2008 12:54:20 +1000
Subject: [linux-dvb] Junior Dev Help: Compro VideoMate T220 driver questions.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0223216075=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0223216075==
Content-Type: multipart/alternative; boundary=Apple-Mail-24-6074093


--Apple-Mail-24-6074093
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Hello All,

I'm trying to write a driver for my Compro Videomate DVB-T220 card  
(It's a saa7134 based card). I have made a wiki page: http://www.linuxtv.org/wiki/index.php/Compro_VideoMate_DVB-T220 
  that contains the state of my card from the start. I have created a  
patch: IncompletePatchVideoMateT220.rtf that produces this output:  
dmesgOutput.rtf. Basically all the chipsets are identified, I just  
can't work out the right way to get them to work together. So I have a  
number of questions about my patch.

Firstly, in the card configuration file, how do you determine the  
right vmux values to use for your inputs. At the moment I have just  
been attempting to purely guess.

Second, my saa7134-dvb.c init and config functions are guesswork based  
on looking at what other similar cards do in here. Is there any  
insight as to what I need in here ?

Finally, from the RegSpy dump on the wiki I can see changes to a few  
SAA7134 registers. Do I need to worry about integrating these into the  
driver somehow ?

Thanks,

Rob

  
--Apple-Mail-24-6074093
Content-Type: multipart/mixed;
	boundary=Apple-Mail-25-6074094


--Apple-Mail-25-6074094
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; ">Hello =
All,&nbsp;<div><br></div><div>I'm trying to write a driver for my Compro =
Videomate DVB-T220 card (It's a saa7134 based card). I have made a wiki =
page:&nbsp;<a =
href=3D"http://www.linuxtv.org/wiki/index.php/Compro_VideoMate_DVB-T220">h=
ttp://www.linuxtv.org/wiki/index.php/Compro_VideoMate_DVB-T220</a>&nbsp;th=
at contains the state of my card from the start. I have created a patch: =
IncompletePatchVideoMateT220.rtf that produces this output: =
dmesgOutput.rtf. Basically all the chipsets are identified, I just can't =
work out the right way to get them to work together. So I have a number =
of questions about my patch.</div><div><br></div><div>Firstly, in the =
card configuration file, how do you determine the right vmux values to =
use for your inputs. At the moment I have just been attempting to purely =
guess.</div><div><br></div><div>Second, my saa7134-dvb.c init and config =
functions are guesswork based on looking at what other similar cards do =
in here. Is there any insight as to what I need in here =
?&nbsp;</div><div><br></div><div>Finally, from the RegSpy dump on the =
wiki I can see changes to a few SAA7134 registers. Do I need to worry =
about&nbsp;integrating&nbsp;these into the driver somehow =
?</div><div><br></div><div>Thanks,</div><div><br></div><div>Rob</div><div>=
<br></div><div></div></body></html>=

--Apple-Mail-25-6074094
Content-Disposition: attachment;
	filename=IncompletePatchVideoMateT220.rtf
Content-Type: text/rtf;
	x-unix-mode=0644;
	name="IncompletePatchVideoMateT220.rtf"
Content-Transfer-Encoding: 7bit

{\rtf1\ansi\ansicpg1252\cocoartf949\cocoasubrtf350
{\fonttbl\f0\fnil\fcharset0 LucidaGrande;}
{\colortbl;\red255\green255\blue255;}
\paperw11900\paperh16840\margl1440\margr1440\vieww9000\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\ql\qnatural

\f0\fs24 \cf0 diff -r b63737bf9eef linux/drivers/media/video/saa7134/saa7134-cards.c\
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Nov 24 10:51:20 2008 -0200\
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Dec 18 12:15:13 2008 +1000\
 -4645,6 +4645,30 @@\
 			.gpio   = 0x0200000,\
 		\},\
 	\},\
+	[SAA7134_BOARD_VIDEOMATE_DVBT_220] = \{\
+		/* Robin Perkins <robin.perkins@internode.on.net> */\
+		.name		= "Compro VideoMate DVB-T220",\
+		.audio_clock	= 0xfdcfe000,\
+		.tuner_type	= TUNER_ABSENT, /* TUNER_QT1010 */\
+		.radio_type	= UNSET,\
+		.tuner_addr	= ADDR_UNSET,\
+		.radio_addr	= ADDR_UNSET,\
+		.mpeg           = SAA7134_MPEG_DVB,\
+		.inputs = \{\{\
+			.name   = name_tv,\
+			.vmux   = 1,			//??\
+			.amux   = TV,\
+			.tv     = 1,\
+		\},\{\
+			.name   = name_comp,\
+			.vmux   = 3,			//??\
+			.amux   = LINE2,\
+		\},\{\
+			.name   = name_svideo,\
+			.vmux   = 8,			//??\
+			.amux   = LINE2,\
+		\} \},\
+	\},\
 \};\
 \
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);\
 -5946,6 +5970,7 @@\
 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:\
 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:\
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:\
+	case SAA7134_BOARD_VIDEOMATE_DVBT_220:\
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:\
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:\
 	case SAA7134_BOARD_VIDEOMATE_T750:\
 -6382,7 +6407,7 @@\
 	\}\
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:\
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:\
-		/* The T200 and the T200A share the same pci id.  Consequently,\
+		/* The T220, T200 and the T200A share the same pci id.  Consequently,\
 		 * we are going to query eeprom to try to find out which one we\
 		 * are actually looking at. */\
 \
 -6397,6 +6422,12 @@\
 			dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;\
 			printk(KERN_INFO "%s: Reconfigured board as %s\\n",\
 				dev->name, saa7134_boards[dev->board].name);\
+		\} else if (dev->eedata[0x41] == 0xd5) \{\
+			/* Reconfigure board as T220 */\
+			dev->board = SAA7134_BOARD_VIDEOMATE_DVBT_220;\
+			dev->tuner_type = saa7134_boards[dev->board].tuner_type;\
+			printk(KERN_INFO "%s: Reconfigured board as %s\\n", \
+				dev->name, saa7134_boards[dev->board].name);\
 		\} else \{\
 			printk(KERN_WARNING "%s: Unexpected tuner type info: %x in eeprom\\n",\
 				dev->name, dev->eedata[0x41]);\
diff -r b63737bf9eef linux/drivers/media/video/saa7134/saa7134-dvb.c\
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Nov 24 10:51:20 2008 -0200\
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Dec 18 12:15:13 2008 +1000\
 -47,6 +47,7 @@\
 #include "isl6421.h"\
 #include "isl6405.h"\
 #include "lnbp21.h"\
+#include "qt1010.h"\
 #include "tuner-simple.h"\
 \
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");\
 -216,6 +217,34 @@\
 	.demod_address   = (0x1e >> 1),\
 	.no_tuner        = 1,\
 	.demod_init      = mt352_avermedia_xc3028_init,\
+\};\
+\
+\
+static int mt352_videomate_t220_init (struct dvb_frontend* fe) \{\
+	static u8 clock_config []  = \{ CLOCK_CTL, 0x38, 0x2d \};\
+	static u8 reset []         = \{ RESET, 0x80 \};\
+	static u8 adc_ctl_1_cfg [] = \{ ADC_CTL_1, 0x40 \};\
+	static u8 agc_cfg []       = \{ AGC_TARGET, 0xe \};\
+	static u8 capt_range_cfg[] = \{ CAPT_RANGE, 0x33 \};\
+\
+	mt352_write(fe, clock_config,   sizeof(clock_config));\
+	udelay(200);\
+	mt352_write(fe, reset,          sizeof(reset));\
+	mt352_write(fe, adc_ctl_1_cfg,  sizeof(adc_ctl_1_cfg));\
+	mt352_write(fe, agc_cfg,        sizeof(agc_cfg));\
+	mt352_write(fe, capt_range_cfg, sizeof(capt_range_cfg));\
+	return 0;\
+\};\
+\
+static struct mt352_config mt352_videomate_t220_config = \{\
+	.demod_address   = 0xf,\
+	.no_tuner        = 1,\
+	.demod_init      = mt352_videomate_t220_init,\
+		\
+\};\
+\
+static struct qt1010_config qt1010_videomate_t220_config = \{\
+	.i2c_address = 0x62\
 \};\
 \
 /* ==================================================================\
 -1038,6 +1067,12 @@\
 			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;\
 		\}\
 		break;\
+	case SAA7134_BOARD_VIDEOMATE_DVBT_220:\
+		fe0->dvb.frontend = dvb_attach(mt352_attach, &mt352_videomate_t220_config, &dev->i2c_adap);\
+		if (fe0->dvb.frontend) \{\
+			dvb_attach(qt1010_attach, fe0->dvb.frontend, &dev->i2c_adap, &qt1010_videomate_t220_config);\
+		\}\
+		break;\
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:\
 		fe0->dvb.frontend = dvb_attach(tda10046_attach,\
 					       &philips_tu1216_61_config,\
diff -r b63737bf9eef linux/drivers/media/video/saa7134/saa7134-input.c\
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Nov 24 10:51:20 2008 -0200\
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Dec 18 12:15:13 2008 +1000\
 -536,6 +536,7 @@\
 		polling      = 50; // ms\
 		break;\
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:\
+	case SAA7134_BOARD_VIDEOMATE_DVBT_220:\
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:\
 		ir_codes     = ir_codes_videomate_tv_pvr;\
 		mask_keycode = 0x003F00;\
diff -r b63737bf9eef linux/drivers/media/video/saa7134/saa7134.h\
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Nov 24 10:51:20 2008 -0200\
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Thu Dec 18 12:15:13 2008 +1000\
 -276,6 +276,7 @@\
 #define SAA7134_BOARD_REAL_ANGEL_220     150\
 #define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  151\
 #define SAA7134_BOARD_ASUSTeK_TIGER         152\
+#define SAA7134_BOARD_VIDEOMATE_DVBT_220 153\
 \
 #define SAA7134_MAXBOARDS 32\
 #define SAA7134_INPUT_MAX 8}
--Apple-Mail-25-6074094
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: 7bit

<html><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space; "><div>&nbsp;</div></body></html>
--Apple-Mail-25-6074094
Content-Disposition: attachment;
	filename=dmesgOutput.rtf
Content-Type: text/rtf;
	x-unix-mode=0644;
	name="dmesgOutput.rtf"
Content-Transfer-Encoding: 7bit

{\rtf1\ansi\ansicpg1252\cocoartf949\cocoasubrtf350
{\fonttbl\f0\fnil\fcharset0 LucidaGrande;}
{\colortbl;\red255\green255\blue255;}
\paperw11900\paperh16840\margl1440\margr1440\vieww9000\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\ql\qnatural

\f0\fs24 \cf0 [   12.879770] saa7130/34: v4l2 driver version 0.2.14 loaded\
[   12.904670] saa7134 0000:04:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20\
[   12.904677] saa7130[0]: found at 0000:04:03.0, rev: 1, irq: 20, latency: 84, mmio: 0xfdbfe000\
[   12.904683] saa7130[0]: subsystem: 185b:c901, board: Compro Videomate DVB-T200 [card=71,autodetected]\
[   12.904694] saa7130[0]: board init: gpio is 843f00\
[   12.904751] input: saa7134 IR (Compro Videomate DV as /devices/pci0000:00/0000:00:1e.0/0000:04:03.0/input/input7\
[   13.280159] saa7130[0]: i2c eeprom 00: 5b 18 01 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92\
[   13.280169] saa7130[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff\
[   13.280178] saa7130[0]: i2c eeprom 20: 01 40 01 03 03 ff 03 01 08 ff 00 88 ff ff ff ff\
[   13.280186] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280195] saa7130[0]: i2c eeprom 40: ff d5 00 c4 86 1e ff ff ff ff ff ff ff ff ff ff\
[   13.280203] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb\
[   13.280211] saa7130[0]: i2c eeprom 60: 30 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280220] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280228] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280236] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280245] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280253] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280261] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280270] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280278] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280286] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff\
[   13.280296] saa7130[0]: Reconfigured board as Compro VideoMate DVB-T220\
[   13.280446] saa7130[0]: registered device video0 [v4l2]\
[   13.280496] saa7130[0]: registered device vbi0\
[   13.341508] saa7134 ALSA driver for DMA sound loaded\
[   13.341541] saa7130[0]/alsa: saa7130[0] at 0xfdbfe000 irq 20 registered as card -2\
[   13.581214] dvb_init() allocating 1 frontend\
[   13.764090] Quantek QT1010 successfully identified.\
[   13.764095] DVB: registering new adapter (saa7130[0])\
[   13.764098] DVB: registering adapter 0 frontend 0 (Zarlink MT352 DVB-T)..}
--Apple-Mail-25-6074094
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: 7bit

<html><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space; "><div></div></body></html>
--Apple-Mail-25-6074094--

--Apple-Mail-24-6074093--


--===============0223216075==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0223216075==--
