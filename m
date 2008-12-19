Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from asmtp1.iomartmail.com ([62.128.201.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lawrence@softsystem.co.uk>) id 1LDcbJ-0007XR-Tu
	for linux-dvb@linuxtv.org; Fri, 19 Dec 2008 11:28:59 +0100
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Darron Broad <darron@kewl.org>
Date: Fri, 19 Dec 2008 11:27:35 +0100
References: <200812181804.34557.lawrence@softsystem.co.uk>
	<3103.1229627861@kewl.org>
In-Reply-To: <3103.1229627861@kewl.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Xc3SJbbjAeBS2DY"
Message-Id: <200812191127.35952.lawrence@softsystem.co.uk>
Cc: Linux-dvb list <linux-dvb@linuxtv.org>
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

--Boundary-00=_Xc3SJbbjAeBS2DY
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 18 December 2008 20:17:41 Darron Broad wrote:
> hi
>
> >I have a Hauppauge Nova-S-plus PCI card and it works great with satellite
> >reception.  However, I would also like to use it with an external DVB-T
> > box that outputs composite video and line audio but when I select the
> > composite video input I can see a picture but get no sound.
> >
> >I'm using kernel version 2.6.24 so I dug around those sources and I see in
> >cx88-cards.c that there's no provision for line audio in.  However, the
> >latest v4l top of tree sources have added support for I2S audio input
> >and 'audioroute's.
> >
> >So I modded my 2.6.24 sources to support the external ADC and enable I2S
> > audio input using the struct cx88_board cx88_boards.extadc flag, similar
> > to the changes made in the current top of tree.  This now means that I
> > can watch DVB-T :-)  I don't believe the changes affect any other cards.
> >
> >I would like to see support added for the Nova-S-Plus audio line input in
> > the kernel tree asap.  What's the best way of achieving this?  I can
> > supply a diff for 2.6.24 or the current top of tree.
>
> I would be interested to see what changes you made to achieve this
> and am able to test. Please share your patch for testing.
>
> Thanks
> darron

Diffs for linux kernel 2.6.24 and the current v4l tip attached.

The change for the current top of tree is minimal - just a few lines in the 
static configuration data of cx88-cards.c.

The changes for 2.6.24 parallel the changes made for audioroutes in the 
current tip.

Note the changes to cx88_alsa.c to remove the tuner volume control if there's 
no TV tuner and to re-group the switches more logically.  I was thinking of 
adding some code to adjust the WM8775 gain - what do you think?

HTH.

-- Lawrence Rust

--Boundary-00=_Xc3SJbbjAeBS2DY
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="cx88-2.6.24.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx88-2.6.24.diff"

diff -U 3 -H -w -d -r -N -- cx88.orig/cx88-alsa.c cx88/cx88-alsa.c
--- cx88.orig/cx88-alsa.c	2008-02-11 06:51:11.000000000 +0100
+++ cx88/cx88-alsa.c	2008-12-19 10:48:25.000000000 +0100
@@ -594,10 +594,10 @@
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
@@ -612,7 +612,7 @@
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.name = "Playback Volume",
+	.name = "Tuner Volume",
 	.info = snd_cx88_volume_info,
 	.get = snd_cx88_volume_get,
 	.put = snd_cx88_volume_put,
@@ -643,7 +643,7 @@
 	vol = cx_read(AUD_VOL_CTL);
 	if (value->value.integer.value[0] != !(vol & bit)) {
 		vol ^= bit;
-		cx_write(AUD_VOL_CTL, vol);
+		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -652,7 +652,7 @@
 
 static struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Playback Switch",
+    .name = "Audio Out Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -661,7 +661,7 @@
 
 static struct snd_kcontrol_new snd_cx88_source_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Capture Switch",
+    .name = "Tuner Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -816,13 +816,15 @@
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
 
diff -U 3 -H -w -d -r -N -- cx88.orig/cx88-cards.c cx88/cx88-cards.c
--- cx88.orig/cx88-cards.c	2008-12-15 09:48:12.000000000 +0100
+++ cx88/cx88-cards.c	2008-12-19 10:43:37.000000000 +0100
@@ -941,19 +941,23 @@
 	},
 	[CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1] = {
 		.name		= "Hauppauge Nova-S-Plus DVB-S",
-		.tuner_type	= TUNER_ABSENT,
+		.tuner_type	= UNSET, /* BUG: Needed by cx88_i2c_ini for WM8775 */
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+		.audio_chip     = AUDIO_CHIP_WM8775,
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
+			.extadc = 1,
 		},{
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
+			.extadc = 1,
 		},{
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
+			.extadc = 1,
 		}},
 		.mpeg           = CX88_MPEG_DVB,
 	},
diff -U 3 -H -w -d -r -N -- cx88.orig/cx88-tvaudio.c cx88/cx88-tvaudio.c
--- cx88.orig/cx88-tvaudio.c	2008-02-11 06:51:11.000000000 +0100
+++ cx88/cx88-tvaudio.c	2008-12-19 10:43:37.000000000 +0100
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
diff -U 3 -H -w -d -r -N -- cx88.orig/cx88-video.c cx88/cx88-video.c
--- cx88.orig/cx88-video.c	2008-02-11 06:51:11.000000000 +0100
+++ cx88/cx88-video.c	2008-12-19 10:53:54.000000000 +0100
@@ -392,11 +392,17 @@
 		break;
 	}
 
-	if (core->board.mpeg & CX88_MPEG_BLACKBIRD) {
-		/* sets sound input from external adc */
-		if (INPUT(input).extadc)
-			cx_set(AUD_CTL, EN_I2SIN_ENABLE);
-		else
+	/* cx2388's C-ADC is connected to the tuner only.
+		When used with S-Video, that ADC is busy dealing with
+		chroma, so an external must be used for baseband audio.
+		So check if there is an external ADC for audio */
+	if ( INPUT(input).extadc && INPUT(input).type != CX88_VMUX_TELEVISION) {
+		/* "I2S ADC mode" */
+		core->tvaudio = WW_I2SADC;
+		cx88_set_tvaudio(core);
+	} else {
+		/* Normal mode */
+		cx_write(AUD_I2SCNTL, 0x0);
 			cx_clear(AUD_CTL, EN_I2SIN_ENABLE);
 	}
 	return 0;
@@ -767,9 +773,16 @@
 		cx_write(MO_GP0_IO, core->board.radio.gpio0);
 		cx_write(MO_GP1_IO, core->board.radio.gpio1);
 		cx_write(MO_GP2_IO, core->board.radio.gpio2);
+		if (core->board.radio.extadc) {
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
 
diff -U 3 -H -w -d -r -N -- cx88.orig/cx88.h cx88/cx88.h
--- cx88.orig/cx88.h	2008-02-11 06:51:11.000000000 +0100
+++ cx88/cx88.h	2008-12-15 18:06:27.000000000 +0100
@@ -604,6 +604,7 @@
 #define WW_EIAJ		 7
 #define WW_I2SPT	 8
 #define WW_FM		 9
+#define WW_I2SADC	 10
 
 void cx88_set_tvaudio(struct cx88_core *core);
 void cx88_newstation(struct cx88_core *core);

--Boundary-00=_Xc3SJbbjAeBS2DY
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="cx88-tip.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx88-tip.diff"

--- cx88-cards.c	2008-12-14 12:28:07.000000000 +0100
+++ cx88-cards-new.c	2008-12-19 10:34:20.000000000 +0100
@@ -960,19 +960,23 @@
 	},
 	[CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1] = {
 		.name		= "Hauppauge Nova-S-Plus DVB-S",
-		.tuner_type	= TUNER_ABSENT,
+		.tuner_type	= UNSET, /* BUG: Needed by cx88_i2c_ini for WM8775 */
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+        .audio_chip = V4L2_IDENT_WM8775,
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
+            .audioroute = 1,
 		},{
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
+            .audioroute = 1,
 		},{
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
+            .audioroute = 1,
 		}},
 		.mpeg           = CX88_MPEG_DVB,
 	},

--Boundary-00=_Xc3SJbbjAeBS2DY
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_Xc3SJbbjAeBS2DY--
