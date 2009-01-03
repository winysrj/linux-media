Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from asmtp1.iomartmail.com ([62.128.201.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lawrence@softsystem.co.uk>) id 1LJ4ZE-00022x-Ma
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 12:21:23 +0100
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Darron Broad <darron@kewl.org>
Date: Sat, 3 Jan 2009 12:20:35 +0100
References: <200812181804.34557.lawrence@softsystem.co.uk>
	<200812191127.35952.lawrence@softsystem.co.uk>
	<7882.1229683311@kewl.org>
In-Reply-To: <7882.1229683311@kewl.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Do0XJh5DrleouzG"
Message-Id: <200901031220.36005.lawrence@softsystem.co.uk>
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

--Boundary-00=_Do0XJh5DrleouzG
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


On Friday 19 December 2008 11:41:51 Darron Broad wrote:
> In message <200812191127.35952.lawrence@softsystem.co.uk>, Lawrence Rust
> wrote:
>
> Hiya.
>
> >On Thursday 18 December 2008 20:17:41 Darron Broad wrote:
> >> hi
> >>
> >> >I have a Hauppauge Nova-S-plus PCI card and it works great with
> >> > satellite reception.  However, I would also like to use it with an
> >> > external DVB-T box that outputs composite video and line audio but
> >> > when I select the composite video input I can see a picture but get no
> >> > sound.
> >> >
> >> >I'm using kernel version 2.6.24 so I dug around those sources and I see
> >> > in cx88-cards.c that there's no provision for line audio in.  However,
> >> > the latest v4l top of tree sources have added support for I2S audio
> >> > input and 'audioroute's.
> >> >
> >> >So I modded my 2.6.24 sources to support the external ADC and enable
> >> > I2S audio input using the struct cx88_board cx88_boards.extadc flag,
> >> > similar to the changes made in the current top of tree.  This now
> >> > means that I can watch DVB-T :-)  I don't believe the changes affect
> >> > any other cards.
> >> >
> >> >I would like to see support added for the Nova-S-Plus audio line input
> >> > in the kernel tree asap.  What's the best way of achieving this?  I
> >> > can supply a diff for 2.6.24 or the current top of tree.
> >>
> >> I would be interested to see what changes you made to achieve this
> >> and am able to test. Please share your patch for testing.
> >>
> >> Thanks
> >> darron
> >
> >Diffs for linux kernel 2.6.24 and the current v4l tip attached.
> >
> >The change for the current top of tree is minimal - just a few lines in
> > the static configuration data of cx88-cards.c.
> >
> >The changes for 2.6.24 parallel the changes made for audioroutes in the
> >current tip.
> >
> >Note the changes to cx88_alsa.c to remove the tuner volume control if
> > there's no TV tuner and to re-group the switches more logically.  I was
> > thinking of adding some code to adjust the WM8775 gain - what do you
> > think?
> >
> >HTH.
>
> Thanks for that Lawrence. I will test this soon.
>
> With regard to the gain control on the WM8775, perhaps you can
> look at this:
>
> http://hg.kewl.org/v4l-dvb-test/shortlog
>
> You can find some patches here:
> http://hg.kewl.org/v4l-dvb-test/rev/c1d603af3bef
> http://hg.kewl.org/v4l-dvb-test/rev/302d51bf2baf
> http://hg.kewl.org/v4l-dvb-test/rev/8b24b8211fc9
>
> Which sound like they would do what you desire?
>
> I should rebuild these patches soon to for better testing purposes
> but in the meantime please test if you are interested.
>
> Cheers
>
> darron

Darron,

I've been running those patches for the last week now with no problems.  I did 
find that L-R balance wasn't working properly but it's a simple fix.

I also patched cx88-alsa.c so that I could use an ALSA GUI (kmix) to set the 
input level.  There's very little difference in this file between 2.6.24 and 
top of tree so the patch should be OK for most versions.

Patches for 2.6.24 attached.  The patch to wm8775.c is pretty similar to your 
original but with these small changes:

- The wm98875 is initialised in I2S mode, not left justified, for proper 
operation with the cx88.

- The ALC setup code is left in but conditionally compiled out rather than 
removed - in case someone should prefer ALC.

- wm8775_set_audio doesn't set the LRBOTH bit in R21. This fixes the problem 
with balance.

-- Lawrence Rust

--Boundary-00=_Do0XJh5DrleouzG
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="novaS-audio-2.6.24.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="novaS-audio-2.6.24.diff"

diff -U 3 -H -w -d -r -N -- video.orig/cx88/cx88-alsa.c video/cx88/cx88-alsa.c
--- video.orig/cx88/cx88-alsa.c	2008-02-11 06:51:11.000000000 +0100
+++ video/cx88/cx88-alsa.c	2008-12-31 16:41:15.000000000 +0100
@@ -583,6 +583,30 @@
 	int changed = 0;
 	u32 old;
 
+    /* If a WM8775 is used for audio input utilise the audio controls */
+    if ( core->board.audio_chip && core->board.audio_chip == AUDIO_CHIP_WM8775) {
+        struct v4l2_control client_ctl;
+
+        if ( value->value.integer.value[0] >= value->value.integer.value[1]) {
+            v = value->value.integer.value[0] << 10;
+            b = value->value.integer.value[0] ?
+              (0x8000 * value->value.integer.value[1]) / value->value.integer.value[0] :
+              0x8000;
+        } else {
+            v = value->value.integer.value[1] << 10;
+            b = value->value.integer.value[1] ?
+              0xffff - (0x8000 * value->value.integer.value[0]) / value->value.integer.value[1] :
+              0x8000;
+        }
+        client_ctl.value = v;
+        client_ctl.id = V4L2_CID_AUDIO_VOLUME;
+        cx88_call_i2c_clients(core, VIDIOC_S_CTRL, &client_ctl);
+
+        client_ctl.value = b;
+        client_ctl.id = V4L2_CID_AUDIO_BALANCE;
+        cx88_call_i2c_clients(core, VIDIOC_S_CTRL, &client_ctl);
+    }
+
 	b = value->value.integer.value[1] - value->value.integer.value[0];
 	if (b < 0) {
 	    v = 0x3f - value->value.integer.value[0];
@@ -594,10 +618,10 @@
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
@@ -612,7 +636,7 @@
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.name = "Playback Volume",
+	.name = "Tuner Volume",
 	.info = snd_cx88_volume_info,
 	.get = snd_cx88_volume_get,
 	.put = snd_cx88_volume_put,
@@ -643,7 +667,15 @@
 	vol = cx_read(AUD_VOL_CTL);
 	if (value->value.integer.value[0] != !(vol & bit)) {
 		vol ^= bit;
-		cx_write(AUD_VOL_CTL, vol);
+		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
+
+        /* If a WM8775 is used for audio input utilise the audio controls */
+        if ( (1<<6) == bit && core->board.audio_chip && core->board.audio_chip == AUDIO_CHIP_WM8775) {
+            struct v4l2_control client_ctl;
+            client_ctl.value = 0 == value->value.integer.value[0];
+            client_ctl.id = V4L2_CID_AUDIO_MUTE;
+            cx88_call_i2c_clients(core, VIDIOC_S_CTRL, &client_ctl);
+        }
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -652,7 +684,7 @@
 
 static struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Playback Switch",
+    .name = "Audio Out Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -661,7 +693,7 @@
 
 static struct snd_kcontrol_new snd_cx88_source_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Capture Switch",
+    .name = "Tuner Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -819,10 +851,10 @@
 	err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_volume, chip));
 	if (err < 0)
 		goto error;
-	err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_dac_switch, chip));
+    err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_source_switch, chip));
 	if (err < 0)
 		goto error;
-	err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_source_switch, chip));
+    err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_dac_switch, chip));
 	if (err < 0)
 		goto error;
 
diff -U 3 -H -w -d -r -N -- video.orig/wm8775.c video/wm8775.c
--- video.orig/wm8775.c	2008-02-11 06:51:11.000000000 +0100
+++ video/wm8775.c	2009-01-01 13:35:30.000000000 +0100
@@ -55,6 +55,8 @@
 struct wm8775_state {
 	u8 input;		/* Last selected input (0-0xf) */
 	u8 muted;
+    u16 volume;
+    u16 balance;
 };
 
 static int wm8775_write(struct i2c_client *client, int reg, u16 val)
@@ -76,6 +78,57 @@
 	return -1;
 }
 
+static void wm8775_set_audio(struct i2c_client *client)
+{
+    struct wm8775_state *state = i2c_get_clientdata(client);
+    u8 vol_l, vol_r;
+
+    /* normalize ( 65535 to 0 -> 255 to 0 (+24dB to -103dB) ) */
+    vol_l = ((min(65536 - state->balance, 32768) * state->volume) / 32768) >> 8;
+    vol_r = ((min(state->balance, (u16)32768) * state->volume) / 32768) >> 8;
+
+    /* Mute */
+    wm8775_write(client, R21, 0x0c0);
+
+    wm8775_write(client, R14, vol_l);
+    wm8775_write(client, R15, vol_r);
+
+    /* Un-mute */
+    if (!state->muted)
+      wm8775_write(client, R21, state->input);
+}
+
+static struct v4l2_queryctrl wm8775_qctrl[] = {
+       {
+               .id            = V4L2_CID_AUDIO_VOLUME,
+               .name          = "Volume",
+               .minimum       = 0,
+               .maximum       = 65535,
+               .step          = 65535/100,
+               .default_value = 0xCF00, /* 0 dB */
+               .flags         = 0,
+               .type          = V4L2_CTRL_TYPE_INTEGER,
+       }, {
+               .id            = V4L2_CID_AUDIO_MUTE,
+               .name          = "Mute",
+               .minimum       = 0,
+               .maximum       = 1,
+               .step          = 1,
+               .default_value = 1,
+               .flags         = 0,
+               .type          = V4L2_CTRL_TYPE_BOOLEAN,
+       }, {
+               .id            = V4L2_CID_AUDIO_BALANCE,
+               .name          = "Balance",
+               .minimum       = 0,
+               .maximum       = 65535,
+               .step          = 65535/100,
+               .default_value = 32768,
+               .flags         = 0,
+               .type          = V4L2_CTRL_TYPE_INTEGER,
+       }
+};
+
 static int wm8775_command(struct i2c_client *client, unsigned int cmd,
 			  void *arg)
 {
@@ -100,37 +153,65 @@
 			return -EINVAL;
 		}
 		state->input = route->input;
-		if (state->muted)
-			break;
-		wm8775_write(client, R21, 0x0c0);
-		wm8775_write(client, R14, 0x1d4);
-		wm8775_write(client, R15, 0x1d4);
-		wm8775_write(client, R21, 0x100 + state->input);
+        wm8775_set_audio(client);
 		break;
 
 	case VIDIOC_G_CTRL:
-		if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-			return -EINVAL;
+        switch (ctrl->id) {
+        case V4L2_CID_AUDIO_MUTE:
 		ctrl->value = state->muted;
 		break;
 
-	case VIDIOC_S_CTRL:
-		if (ctrl->id != V4L2_CID_AUDIO_MUTE)
+        case V4L2_CID_AUDIO_VOLUME:
+            ctrl->value = state->volume;
+            break;
+
+        case V4L2_CID_AUDIO_BALANCE:
+            ctrl->value = state->balance;
+            break;
+
+        default:
 			return -EINVAL;
+        }
+		break;
+
+	case VIDIOC_S_CTRL:
+        switch (ctrl->id) {
+        case V4L2_CID_AUDIO_MUTE:
 		state->muted = ctrl->value;
-		wm8775_write(client, R21, 0x0c0);
-		wm8775_write(client, R14, 0x1d4);
-		wm8775_write(client, R15, 0x1d4);
-		if (!state->muted)
-			wm8775_write(client, R21, 0x100 + state->input);
 		break;
 
-	case VIDIOC_G_CHIP_IDENT:
-		return v4l2_chip_ident_i2c_client(client, arg, V4L2_IDENT_WM8775, 0);
+        case V4L2_CID_AUDIO_VOLUME:
+            state->volume = ctrl->value;
+            break;
+
+        case V4L2_CID_AUDIO_BALANCE:
+            state->balance = ctrl->value;
+            break;
+
+        default:
+            return -EINVAL;
+        }
+        wm8775_set_audio(client);
+        break;
+
+    case VIDIOC_QUERYCTRL:
+        {
+        struct v4l2_queryctrl *qc = arg;
+        int i;
+
+        for (i = 0; i < ARRAY_SIZE(wm8775_qctrl); i++)
+                if (qc->id && qc->id == wm8775_qctrl[i].id) {
+                        memcpy(qc, &wm8775_qctrl[i], sizeof(*qc));
+                        return 0;
+                }
+        return -EINVAL;
+        }
 
 	case VIDIOC_LOG_STATUS:
-		v4l_info(client, "Input: %d%s\n", state->input,
-			    state->muted ? " (muted)" : "");
+        v4l_info(client, "Volume: %04x%s Balance: %04x Input: %d\n",
+                state->volume, state->muted ? " (muted)" : "",
+                state->balance, state->input);
 		break;
 
 	case VIDIOC_S_FREQUENCY:
@@ -138,10 +219,7 @@
 		   sound the first time I tune from static to a valid channel.
 		   It's difficult to reproduce and is almost certainly related
 		   to the zero cross detect circuit. */
-		wm8775_write(client, R21, 0x0c0);
-		wm8775_write(client, R14, 0x1d4);
-		wm8775_write(client, R15, 0x1d4);
-		wm8775_write(client, R21, 0x100 + state->input);
+        wm8775_set_audio(client);
 		break;
 
 	default:
@@ -188,26 +266,24 @@
 	}
 	state->input = 2;
 	state->muted = 0;
+    state->volume = 0xCF00;
+    state->balance = 0x8000;
 	i2c_set_clientdata(client, state);
 
 	/* initialize wm8775 */
 	wm8775_write(client, R23, 0x000);	/* RESET */
-	wm8775_write(client, R7, 0x000);	/* Disable zero cross detect timeout */
-	wm8775_write(client, R11, 0x021);	/* Left justified, 24-bit mode */
+	/*wm8775_write(client, R7,  0x000); /* Enable zero cross detect timeout */
+    wm8775_write(client, R11, 0x022); /* HPF enable, I2S mode, 24-bit */
 	wm8775_write(client, R12, 0x102);	/* Master mode, clock ratio 256fs */
 	wm8775_write(client, R13, 0x000);	/* Powered up */
-	wm8775_write(client, R14, 0x1d4);	/* ADC gain +2.5dB, enable zero cross */
-	wm8775_write(client, R15, 0x1d4);	/* ADC gain +2.5dB, enable zero cross */
-	wm8775_write(client, R16, 0x1bf);	/* ALC Stereo, ALC target level -1dB FS */
-	/* max gain +8dB */
-	wm8775_write(client, R17, 0x185);	/* Enable gain control, use zero cross */
-	/* detection, ALC hold time 42.6 ms */
-	wm8775_write(client, R18, 0x0a2);	/* ALC gain ramp up delay 34 s, */
-	/* ALC gain ramp down delay 33 ms */
+    wm8775_set_audio(client);         /* set volume/mute */
+#if 0 /* Enable ALC */
+    wm8775_write(client, R16, 0x1bb); /* ALC stereo, ALC target level -5dB FS, ALC max gain +8dB */
+    wm8775_write(client, R17, 0x185); /* Enable LC, use zero cross, ALC hold 42.7 ms */
+    wm8775_write(client, R18, 0x0a2); /* ALC decay time 34 s, ALC attack time 33 ms */
 	wm8775_write(client, R19, 0x005);	/* Enable noise gate, threshold -72dBfs */
-	wm8775_write(client, R20, 0x07a);	/* Transient window 4ms, lower PGA gain */
-	/* limit -1dB */
-	wm8775_write(client, R21, 0x102);	/* LRBOTH = 1, use input 2. */
+    wm8775_write(client, R20, 0x0fb); /* Transient window 4ms, ALC min gain -5dB */
+#endif
 	i2c_attach_client(client);
 
 	return 0;

--Boundary-00=_Do0XJh5DrleouzG
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_Do0XJh5DrleouzG--
