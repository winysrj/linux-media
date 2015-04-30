Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbD3OI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 18/22] saa7134: change the debug macros for saa7134-tvaudio
Date: Thu, 30 Apr 2015 11:08:38 -0300
Message-Id: <3195225b8395f896d4b896b294fab9d421d0908a.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

use just one macro instead of 2, naming it as audio_dbg() and
using pr_fmt().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index e8aeea4cf422..360f447bd74d 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -49,13 +49,8 @@ static int audio_clock_tweak;
 module_param(audio_clock_tweak, int, 0644);
 MODULE_PARM_DESC(audio_clock_tweak, "Audio clock tick fine tuning for cards with audio crystal that's slightly off (range [-1024 .. 1024])");
 
-#define dprintk(fmt, arg...)	if (audio_debug) \
-	printk(KERN_DEBUG "%s/audio: " fmt, dev->name , ## arg)
-#define d2printk(fmt, arg...)	if (audio_debug > 1) \
-	printk(KERN_DEBUG "%s/audio: " fmt, dev->name, ## arg)
-
-#define print_regb(reg) printk("%s:   reg 0x%03x [%-16s]: 0x%02x\n", \
-		dev->name,(SAA7134_##reg),(#reg),saa_readb((SAA7134_##reg)))
+#define audio_dbg(level, fmt, arg...)    if (audio_debug >= level) \
+       printk(KERN_DEBUG pr_fmt("audio: " fmt), ## arg)
 
 /* msecs */
 #define SCAN_INITIAL_DELAY     1000
@@ -206,13 +201,14 @@ static void mute_input_7134(struct saa7134_dev *dev)
 
 	if (dev->hw_mute  == mute &&
 		dev->hw_input == in && !dev->insuspend) {
-		dprintk("mute/input: nothing to do [mute=%d,input=%s]\n",
-			mute,in->name);
+		audio_dbg(1, "mute/input: nothing to do [mute=%d,input=%s]\n",
+			  mute, in->name);
 		return;
 	}
 
-	dprintk("ctl_mute=%d automute=%d input=%s  =>  mute=%d input=%s\n",
-		dev->ctl_mute,dev->automute,dev->input->name,mute,in->name);
+	audio_dbg(1, "ctl_mute=%d automute=%d input=%s  =>  mute=%d input=%s\n",
+		  dev->ctl_mute, dev->automute,
+		  dev->input->name, mute, in->name);
 	dev->hw_mute  = mute;
 	dev->hw_input = in;
 
@@ -265,8 +261,8 @@ static void tvaudio_setmode(struct saa7134_dev *dev,
 		tweak = audio_clock_tweak;
 
 	if (note)
-		dprintk("tvaudio_setmode: %s %s [%d.%03d/%d.%03d MHz] acpf=%d%+d\n",
-			note,audio->name,
+		audio_dbg(1, "tvaudio_setmode: %s %s [%d.%03d/%d.%03d MHz] acpf=%d%+d\n",
+			note, audio->name,
 			audio->carr1 / 1000, audio->carr1 % 1000,
 			audio->carr2 / 1000, audio->carr2 % 1000,
 			acpf, tweak);
@@ -334,14 +330,14 @@ static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
 
 	if (!(dev->tvnorm->id & scan->std)) {
 		value = 0;
-		dprintk("skipping %d.%03d MHz [%4s]\n",
-			scan->carr / 1000, scan->carr % 1000, scan->name);
+		audio_dbg(1, "skipping %d.%03d MHz [%4s]\n",
+			  scan->carr / 1000, scan->carr % 1000, scan->name);
 		return 0;
 	}
 
 	if (audio_debug > 1) {
 		int i;
-		dprintk("debug %d:",scan->carr);
+		audio_dbg(1, "debug %d:", scan->carr);
 		for (i = -150; i <= 150; i += 30) {
 			tvaudio_setcarrier(dev,scan->carr+i,scan->carr+i);
 			saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
@@ -349,11 +345,11 @@ static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
 				return -1;
 			value = saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
 			if (0 == i)
-				printk("  #  %6d  # ",value >> 16);
+				pr_cont("  #  %6d  # ",value >> 16);
 			else
-				printk(" %6d",value >> 16);
+				pr_cont(" %6d",value >> 16);
 		}
-		printk("\n");
+		pr_cont("\n");
 	}
 
 	tvaudio_setcarrier(dev,scan->carr-90,scan->carr-90);
@@ -371,9 +367,9 @@ static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
 	left >>= 16;
 	right >>= 16;
 	value = left > right ? left - right : right - left;
-	dprintk("scanning %d.%03d MHz [%4s] =>  dc is %5d [%d/%d]\n",
-		scan->carr / 1000, scan->carr % 1000,
-		scan->name, value, left, right);
+	audio_dbg(1, "scanning %d.%03d MHz [%4s] =>  dc is %5d [%d/%d]\n",
+		  scan->carr / 1000, scan->carr % 1000,
+		  scan->name, value, left, right);
 	return value;
 }
 
@@ -389,7 +385,7 @@ static int tvaudio_getstereo(struct saa7134_dev *dev, struct saa7134_tvaudio *au
 	case TVAUDIO_FM_K_STEREO:
 	case TVAUDIO_FM_BG_STEREO:
 		idp = (saa_readb(SAA7134_IDENT_SIF) & 0xe0) >> 5;
-		dprintk("getstereo: fm/stereo: idp=0x%x\n",idp);
+		audio_dbg(1, "getstereo: fm/stereo: idp=0x%x\n", idp);
 		if (0x03 == (idp & 0x03))
 			retval = V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 		else if (0x05 == (idp & 0x05))
@@ -403,10 +399,10 @@ static int tvaudio_getstereo(struct saa7134_dev *dev, struct saa7134_tvaudio *au
 	case TVAUDIO_NICAM_FM:
 	case TVAUDIO_NICAM_AM:
 		nicam = saa_readb(SAA7134_AUDIO_STATUS);
-		dprintk("getstereo: nicam=0x%x\n",nicam);
+		audio_dbg(1, "getstereo: nicam=0x%x\n", nicam);
 		if (nicam & 0x1) {
 			nicam_status = saa_readb(SAA7134_NICAM_STATUS);
-			dprintk("getstereo: nicam_status=0x%x\n", nicam_status);
+			audio_dbg(1, "getstereo: nicam_status=0x%x\n", nicam_status);
 
 			switch (nicam_status & 0x03) {
 			    case 0x01:
@@ -424,7 +420,7 @@ static int tvaudio_getstereo(struct saa7134_dev *dev, struct saa7134_tvaudio *au
 		break;
 	}
 	if (retval != -1)
-		dprintk("found audio subchannels:%s%s%s%s\n",
+		audio_dbg(1, "found audio subchannels:%s%s%s%s\n",
 			(retval & V4L2_TUNER_SUB_MONO)   ? " mono"   : "",
 			(retval & V4L2_TUNER_SUB_STEREO) ? " stereo" : "",
 			(retval & V4L2_TUNER_SUB_LANG1)  ? " lang1"  : "",
@@ -459,8 +455,8 @@ static int tvaudio_setstereo(struct saa7134_dev *dev, struct saa7134_tvaudio *au
 	case TVAUDIO_FM_BG_STEREO:
 	case TVAUDIO_NICAM_AM:
 	case TVAUDIO_NICAM_FM:
-		dprintk("setstereo [fm] => %s\n",
-			name[ mode % ARRAY_SIZE(name) ]);
+		audio_dbg(1, "setstereo [fm] => %s\n",
+			  name[mode % ARRAY_SIZE(name)]);
 		reg = fm[ mode % ARRAY_SIZE(fm) ];
 		saa_writeb(SAA7134_FM_DEMATRIX, reg);
 		break;
@@ -489,7 +485,8 @@ static int tvaudio_thread(void *data)
 		try_to_freeze();
 
 		dev->thread.scan1 = dev->thread.scan2;
-		dprintk("tvaudio thread scan start [%d]\n",dev->thread.scan1);
+		audio_dbg(1, "tvaudio thread scan start [%d]\n",
+			  dev->thread.scan1);
 		dev->tvaudio  = NULL;
 
 		saa_writeb(SAA7134_MONITOR_SELECT,   0xa0);
@@ -519,7 +516,7 @@ static int tvaudio_thread(void *data)
 
 		if (1 == nscan) {
 			/* only one candidate -- skip scan ;) */
-			dprintk("only one main carrier candidate - skipping scan\n");
+			audio_dbg(1, "only one main carrier candidate - skipping scan\n");
 			max1 = 12345;
 			carrier = default_carrier;
 		} else {
@@ -544,26 +541,24 @@ static int tvaudio_thread(void *data)
 
 		if (0 != carrier && max1 > 2000 && max1 > max2*3) {
 			/* found good carrier */
-			dprintk("found %s main sound carrier @ %d.%03d MHz [%d/%d]\n",
-				dev->tvnorm->name, carrier/1000, carrier%1000,
-				max1, max2);
+			audio_dbg(1, "found %s main sound carrier @ %d.%03d MHz [%d/%d]\n",
+				  dev->tvnorm->name, carrier/1000, carrier%1000,
+				  max1, max2);
 			dev->last_carrier = carrier;
 			dev->automute = 0;
 
 		} else if (0 != dev->last_carrier) {
 			/* no carrier -- try last detected one as fallback */
 			carrier = dev->last_carrier;
-			dprintk("audio carrier scan failed, "
-				"using %d.%03d MHz [last detected]\n",
-				carrier/1000, carrier%1000);
+			audio_dbg(1, "audio carrier scan failed, using %d.%03d MHz [last detected]\n",
+				  carrier/1000, carrier%1000);
 			dev->automute = 1;
 
 		} else {
 			/* no carrier + no fallback -- use default */
 			carrier = default_carrier;
-			dprintk("audio carrier scan failed, "
-				"using %d.%03d MHz [default]\n",
-				carrier/1000, carrier%1000);
+			audio_dbg(1, "audio carrier scan failed, using %d.%03d MHz [default]\n",
+				  carrier/1000, carrier%1000);
 			dev->automute = 1;
 		}
 		tvaudio_setcarrier(dev,carrier,carrier);
@@ -661,7 +656,7 @@ static inline int saa_dsp_reset_error_bit(struct saa7134_dev *dev)
 {
 	int state = saa_readb(SAA7135_DSP_RWSTATE);
 	if (unlikely(state & SAA7135_DSP_RWSTATE_ERR)) {
-		d2printk("%s: resetting error bit\n", dev->name);
+		audio_dbg(2, "%s: resetting error bit\n", dev->name);
 		saa_writeb(SAA7135_DSP_RWCLEAR, SAA7135_DSP_RWCLEAR_RERR);
 	}
 	return 0;
@@ -699,7 +694,7 @@ int saa_dsp_writel(struct saa7134_dev *dev, int reg, u32 value)
 {
 	int err;
 
-	d2printk("dsp write reg 0x%x = 0x%06x\n",reg<<2,value);
+	audio_dbg(2, "dsp write reg 0x%x = 0x%06x\n", reg << 2, value);
 	err = saa_dsp_wait_bit(dev,SAA7135_DSP_RWSTATE_WRR);
 	if (err < 0)
 		return err;
@@ -786,14 +781,16 @@ static int tvaudio_thread_ddep(void *data)
 		try_to_freeze();
 
 		dev->thread.scan1 = dev->thread.scan2;
-		dprintk("tvaudio thread scan start [%d]\n",dev->thread.scan1);
+		audio_dbg(1, "tvaudio thread scan start [%d]\n",
+			  dev->thread.scan1);
 
 		if (audio_ddep >= 0x04 && audio_ddep <= 0x0e) {
 			/* insmod option override */
 			norms = (audio_ddep << 2) | 0x01;
-			dprintk("ddep override: %s\n",stdres[audio_ddep]);
+			audio_dbg(1, "ddep override: %s\n",
+				  stdres[audio_ddep]);
 		} else if (&card(dev).radio == dev->input) {
-			dprintk("FM Radio\n");
+			audio_dbg(1, "FM Radio\n");
 			if (dev->tuner_type == TUNER_PHILIPS_TDA8290) {
 				norms = (0x11 << 2) | 0x01;
 				/* set IF frequency to 5.5 MHz */
@@ -816,12 +813,12 @@ static int tvaudio_thread_ddep(void *data)
 				norms |= 0x10;
 			if (0 == norms)
 				norms = 0x7c; /* all */
-			dprintk("scanning:%s%s%s%s%s\n",
-				(norms & 0x04) ? " B/G"  : "",
-				(norms & 0x08) ? " D/K"  : "",
-				(norms & 0x10) ? " L/L'" : "",
-				(norms & 0x20) ? " I"    : "",
-				(norms & 0x40) ? " M"    : "");
+			audio_dbg(1, "scanning:%s%s%s%s%s\n",
+				  (norms & 0x04) ? " B/G"  : "",
+				  (norms & 0x08) ? " D/K"  : "",
+				  (norms & 0x10) ? " L/L'" : "",
+				  (norms & 0x20) ? " I"    : "",
+				  (norms & 0x40) ? " M"    : "");
 		}
 
 		/* kick automatic standard detection */
@@ -836,29 +833,28 @@ static int tvaudio_thread_ddep(void *data)
 			goto restart;
 		value = saa_readl(0x528 >> 2) & 0xffffff;
 
-		dprintk("tvaudio thread status: 0x%x [%s%s%s]\n",
-			value, stdres[value & 0x1f],
-			(value & 0x000020) ? ",stereo" : "",
-			(value & 0x000040) ? ",dual"   : "");
-		dprintk("detailed status: "
-			"%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s\n",
-			(value & 0x000080) ? " A2/EIAJ pilot tone "     : "",
-			(value & 0x000100) ? " A2/EIAJ dual "           : "",
-			(value & 0x000200) ? " A2/EIAJ stereo "         : "",
-			(value & 0x000400) ? " A2/EIAJ noise mute "     : "",
+		audio_dbg(1, "tvaudio thread status: 0x%x [%s%s%s]\n",
+			  value, stdres[value & 0x1f],
+			  (value & 0x000020) ? ",stereo" : "",
+			  (value & 0x000040) ? ",dual"   : "");
+		audio_dbg(1, "detailed status: %s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s\n",
+			  (value & 0x000080) ? " A2/EIAJ pilot tone "     : "",
+			  (value & 0x000100) ? " A2/EIAJ dual "           : "",
+			  (value & 0x000200) ? " A2/EIAJ stereo "         : "",
+			  (value & 0x000400) ? " A2/EIAJ noise mute "     : "",
 
-			(value & 0x000800) ? " BTSC/FM radio pilot "    : "",
-			(value & 0x001000) ? " SAP carrier "            : "",
-			(value & 0x002000) ? " BTSC stereo noise mute " : "",
-			(value & 0x004000) ? " SAP noise mute "         : "",
-			(value & 0x008000) ? " VDSP "                   : "",
+			  (value & 0x000800) ? " BTSC/FM radio pilot "    : "",
+			  (value & 0x001000) ? " SAP carrier "            : "",
+			  (value & 0x002000) ? " BTSC stereo noise mute " : "",
+			  (value & 0x004000) ? " SAP noise mute "         : "",
+			  (value & 0x008000) ? " VDSP "                   : "",
 
-			(value & 0x010000) ? " NICST "                  : "",
-			(value & 0x020000) ? " NICDU "                  : "",
-			(value & 0x040000) ? " NICAM muted "            : "",
-			(value & 0x080000) ? " NICAM reserve sound "    : "",
+			  (value & 0x010000) ? " NICST "                  : "",
+			  (value & 0x020000) ? " NICDU "                  : "",
+			  (value & 0x040000) ? " NICAM muted "            : "",
+			  (value & 0x080000) ? " NICAM reserve sound "    : "",
 
-			(value & 0x100000) ? " init done "              : "");
+			  (value & 0x100000) ? " init done "              : "");
 	}
 
  done:
@@ -1061,7 +1057,7 @@ int saa7134_tvaudio_fini(struct saa7134_dev *dev)
 int saa7134_tvaudio_do_scan(struct saa7134_dev *dev)
 {
 	if (dev->input->amux != TV) {
-		dprintk("sound IF not in use, skipping scan\n");
+		audio_dbg(1, "sound IF not in use, skipping scan\n");
 		dev->automute = 0;
 		saa7134_tvaudio_setmute(dev);
 	} else if (dev->thread.thread) {
-- 
2.1.0

