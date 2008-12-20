Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from asmtp2.iomartmail.com ([62.128.201.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lawrence@softsystem.co.uk>) id 1LDzZ4-0002KW-OM
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 12:00:12 +0100
Received: from asmtp2.iomartmail.com (localhost.localdomain [127.0.0.1])
	by asmtp2.iomartmail.com (8.12.11.20060308/8.12.8) with ESMTP id
	mBKAxaGO003441
	for <linux-dvb@linuxtv.org>; Sat, 20 Dec 2008 10:59:36 GMT
Received: from collins.softsystem.co.uk (230.229.98-84.rev.gaoland.net
	[84.98.229.230]) (authenticated bits=0)
	by asmtp2.iomartmail.com (8.12.11.20060308/8.12.11) with ESMTP id
	mBKAxaDC003435
	for <linux-dvb@linuxtv.org>; Sat, 20 Dec 2008 10:59:36 GMT
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: linux-dvb@linuxtv.org
Date: Sat, 20 Dec 2008 11:59:27 +0100
References: <200812181804.34557.lawrence@softsystem.co.uk>
	<200812191216.38259.lawrence@softsystem.co.uk>
	<494CADBA.5010809@free.fr>
In-Reply-To: <494CADBA.5010809@free.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PANTJCElmstBd9w"
Message-Id: <200812201159.27722.lawrence@softsystem.co.uk>
Subject: Re: [linux-dvb] Nova-S-Plus audio line input
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_PANTJCElmstBd9w
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 20 December 2008 09:32:58 Roland HAMON wrote:
> Hi
>
> I have the same pci card, it does not work under kernel 2.6.27 ..
> Do you think I should consider downgrading to 2.624 or something could
> be done to get the card supported under recent kernels ?
>

The attached diff should work with kernel 2.6.27.  The v4l drivers in this 
version are similar to top of tree but are missing I2S support in 
cx88-tvaudio.

The patch to cx88_alsa is optional.  It just removes the non-functional tuner 
volume controls in preparation for the changes that I'm working on for the 
wm8775 audio front end.

NB I'm unable to test this patch since I'm still running kernel 2.6.24 but I 
tested that it does compile with the original 2.6.27 unpatched kernel 
sources.  I would like to upgrade to Kubuntu 8.10 (with kernel 2.6.27) but it 
comes with KDE 4, which I cannot abide, shame.  Thinking of going back to 
plain Ubuntu for 8.10 and on but I'll miss many KDE apps - what a quandary.

-- Lawrence Rust

--Boundary-00=_PANTJCElmstBd9w
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="cx88-2.6.27.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx88-2.6.27.diff"

diff -U 3 -H -w -d -r -N -- cx88-orig/cx88-alsa.c cx88/cx88-alsa.c
--- cx88-orig/cx88-alsa.c	2008-10-10 00:13:53.000000000 +0200
+++ cx88/cx88-alsa.c	2008-12-20 10:53:25.000000000 +0100
@@ -598,10 +598,10 @@
 	spin_lock_irq(&chip->reg_lock);
 	old = cx_read(AUD_VOL_CTL);
 	if (v != (old & 0x3f)) {
-	    cx_write(AUD_VOL_CTL, (old & ~0x3f) | v);
+	    cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, (old & ~0x3f) | v);
 	    changed = 1;
 	}
-	if (cx_read(AUD_BAL_CTL) != b) {
+	if ((cx_read(AUD_BAL_CTL) & 0x7f) != b) {
 	    cx_write(AUD_BAL_CTL, b);
 	    changed = 1;
 	}
@@ -616,7 +616,7 @@
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.name = "Playback Volume",
+	.name = "Tuner Volume",
 	.info = snd_cx88_volume_info,
 	.get = snd_cx88_volume_get,
 	.put = snd_cx88_volume_put,
@@ -647,7 +647,7 @@
 	vol = cx_read(AUD_VOL_CTL);
 	if (value->value.integer.value[0] != !(vol & bit)) {
 		vol ^= bit;
-		cx_write(AUD_VOL_CTL, vol);
+		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -656,7 +656,7 @@
 
 static struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Playback Switch",
+    .name = "Audio Out Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -665,7 +665,7 @@
 
 static struct snd_kcontrol_new snd_cx88_source_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Capture Switch",
+    .name = "Tuner Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -818,13 +818,15 @@
 	if (err < 0)
 		goto error;
 
+    if ( TUNER_ABSENT != chip->core->board.tuner_type || CX88_RADIO == chip->core->board.radio.type ) {
 	err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_volume, chip));
 	if (err < 0)
 		goto error;
-	err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_dac_switch, chip));
+        err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_source_switch, chip));
 	if (err < 0)
 		goto error;
-	err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_source_switch, chip));
+    }
+    err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_dac_switch, chip));
 	if (err < 0)
 		goto error;
 
diff -U 3 -H -w -d -r -N -- cx88-orig/cx88-cards.c cx88/cx88-cards.c
--- cx88-orig/cx88-cards.c	2008-10-10 00:13:53.000000000 +0200
+++ cx88/cx88-cards.c	2008-12-20 11:01:46.000000000 +0100
@@ -959,19 +959,23 @@
 	},
 	[CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1] = {
 		.name		= "Hauppauge Nova-S-Plus DVB-S",
-		.tuner_type	= TUNER_ABSENT,
+		.tuner_type	= UNSET, /* BUG: Needed by cx88_i2c_ini for WM8775 */
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+		.audio_chip     = V4L2_IDENT_WM8775,
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
+			.audioroute = 2,
 		},{
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
+			.audioroute = 2,
 		},{
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
+			.audioroute = 2,
 		}},
 		.mpeg           = CX88_MPEG_DVB,
 	},
diff -U 3 -H -w -d -r -N -- cx88-orig/cx88-tvaudio.c cx88/cx88-tvaudio.c
--- cx88-orig/cx88-tvaudio.c	2008-10-10 00:13:53.000000000 +0200
+++ cx88/cx88-tvaudio.c	2008-12-20 10:53:25.000000000 +0100
@@ -767,6 +767,14 @@
 	case WW_FM:
 		set_audio_standard_FM(core, radio_deemphasis);
 		break;
+	case WW_I2SADC:
+		set_audio_start(core, 0x01);
+		/* Slave/Philips/Autobaud */
+		cx_write(AUD_I2SINPUTCNTL, 0);
+		/* Switch to "I2S ADC mode" */
+		cx_write(AUD_I2SCNTL, 0x1);
+		set_audio_finish(core, EN_I2SIN_ENABLE);
+		break;
 	case WW_NONE:
 	default:
 		printk("%s/0: unknown tv audio mode [%d]\n",
@@ -895,6 +903,9 @@
 			break;
 		}
 		break;
+	case WW_I2SADC:
+		/* DO NOTHING */
+		break;
 	}
 
 	if (UNSET != ctl) {
diff -U 3 -H -w -d -r -N -- cx88-orig/cx88-video.c cx88/cx88-video.c
--- cx88-orig/cx88-video.c	2008-10-10 00:13:53.000000000 +0200
+++ cx88/cx88-video.c	2008-12-20 11:01:30.000000000 +0100
@@ -435,9 +435,9 @@
 
 		if (INPUT(input).type != CX88_VMUX_TELEVISION &&
 			INPUT(input).type != CX88_RADIO) {
-			/* "ADC mode" */
-			cx_write(AUD_I2SCNTL, 0x1);
-			cx_set(AUD_CTL, EN_I2SIN_ENABLE);
+			/* "I2S ADC mode" */
+			core->tvaudio = WW_I2SADC;
+			cx88_set_tvaudio(core);
 		} else {
 			/* Normal mode */
 			cx_write(AUD_I2SCNTL, 0x0);
@@ -827,9 +827,16 @@
 		cx_write(MO_GP0_IO, core->board.radio.gpio0);
 		cx_write(MO_GP1_IO, core->board.radio.gpio1);
 		cx_write(MO_GP2_IO, core->board.radio.gpio2);
+		if (core->board.radio.audioroute) {
+			/* "I2S ADC mode" */
+			core->tvaudio = WW_I2SADC;
+			cx88_set_tvaudio(core);
+		} else {
+			/* FM Mode */
 		core->tvaudio = WW_FM;
 		cx88_set_tvaudio(core);
 		cx88_set_stereo(core,V4L2_TUNER_MODE_STEREO,1);
+		}
 		cx88_call_i2c_clients(core,AUDC_SET_RADIO,NULL);
 	}
 
diff -U 3 -H -w -d -r -N -- cx88-orig/cx88.h cx88/cx88.h
--- cx88-orig/cx88.h	2008-10-10 00:13:53.000000000 +0200
+++ cx88/cx88.h	2008-12-20 10:53:25.000000000 +0100
@@ -619,6 +619,7 @@
 #define WW_EIAJ		 7
 #define WW_I2SPT	 8
 #define WW_FM		 9
+#define WW_I2SADC	 10
 
 void cx88_set_tvaudio(struct cx88_core *core);
 void cx88_newstation(struct cx88_core *core);

--Boundary-00=_PANTJCElmstBd9w
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_PANTJCElmstBd9w--
