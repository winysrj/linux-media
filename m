Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65524 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0ITGG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 02:06:58 -0400
Received: by eyb6 with SMTP id 6so1469828eyb.19
        for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 23:06:56 -0700 (PDT)
Date: Mon, 20 Sep 2010 16:07:15 -0400
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
Subject: [PATCH v2] tm6000+audio
Message-ID: <20100920160715.7594ee2e@glory.local>
In-Reply-To: <4C767302.7070506@redhat.com>
References: <20100622180521.614eb85d@glory.loctelecom.ru>
 <4C20D91F.500@redhat.com>
 <4C212A90.7070707@arcor.de>
 <4C213257.6060101@redhat.com>
 <4C222561.4040605@arcor.de>
 <4C224753.2090109@redhat.com>
 <4C225A5C.7050103@arcor.de>
 <20100716161623.2f3314df@glory.loctelecom.ru>
 <4C4C4DCA.1050505@redhat.com>
 <20100728113158.0f1495c0@glory.loctelecom.ru>
 <4C4FD659.9050309@arcor.de>
 <20100729140936.5bddd275@glory.loctelecom.ru>
 <4C51ADB5.7010906@redhat.com>
 <20100731122428.4ee569b4@glory.loctelecom.ru>
 <4C53A837.3070700@redhat.com>
 <20100825043746.225a352a@glory.local>
 <4C7543DA.1070307@redhat.com>
 <AANLkTimr3=1QHzX3BzUVyo6uqLdCKt8SS9sDtHfZtHGZ@mail.gmail.com>
 <4C767302.7070506@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/HjZDTZDiaeveb.JZhwzEgLt"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/HjZDTZDiaeveb.JZhwzEgLt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi 

I rework my last patch for audio and now audio works well. This patch can be submited to GIT tree
Quality of audio now is good for SECAM-DK. For other standard I set some value from datasheet need some tests.

1. Fix pcm buffer overflow
2. Rework pcm buffer fill method
3. Swap bytes in audio stream
4. Change some registers value for TM6010
5. Change pcm buffer size

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 087137d..a99101f 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -160,15 +160,15 @@ static struct snd_pcm_hardware snd_tm6000_digital_hw = {
 		SNDRV_PCM_INFO_MMAP_VALID,
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
 
-	.rates =		SNDRV_PCM_RATE_48000,
+	.rates =		SNDRV_PCM_RATE_CONTINUOUS,
 	.rate_min =		48000,
 	.rate_max =		48000,
 	.channels_min = 2,
 	.channels_max = 2,
-	.period_bytes_min = 62720,
-	.period_bytes_max = 62720,
+	.period_bytes_min = 64,
+	.period_bytes_max = 12544,
 	.periods_min = 1,
-	.periods_max = 1024,
+	.periods_max = 98,
 	.buffer_bytes_max = 62720 * 8,
 };
 
@@ -211,38 +211,64 @@ static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
 	struct snd_pcm_runtime *runtime;
 	int period_elapsed = 0;
 	unsigned int stride, buf_pos;
+	int length;
 
-	if (!size || !substream)
+	if (!size || !substream) {
+		dprintk(1, "substream was NULL\n");
 		return -EINVAL;
+	}
 
 	runtime = substream->runtime;
-	if (!runtime || !runtime->dma_area)
+	if (!runtime || !runtime->dma_area) {
+		dprintk(1, "runtime was NULL\n");
 		return -EINVAL;
+	}
 
 	buf_pos = chip->buf_pos;
 	stride = runtime->frame_bits >> 3;
 
+	if (stride == 0) {
+		dprintk(1, "stride is zero\n");
+		return -EINVAL;
+	}
+
+	length = size / stride;
+	if (length == 0) {
+		dprintk(1, "%s: length was zero\n", __func__);
+		return -EINVAL;
+	}
+
 	dprintk(1, "Copying %d bytes at %p[%d] - buf size=%d x %d\n", size,
 		runtime->dma_area, buf_pos,
 		(unsigned int)runtime->buffer_size, stride);
 
-	if (buf_pos + size >= runtime->buffer_size * stride) {
-		unsigned int cnt = runtime->buffer_size * stride - buf_pos;
-		memcpy(runtime->dma_area + buf_pos, buf, cnt);
-		memcpy(runtime->dma_area, buf + cnt, size - cnt);
+	if (buf_pos + length >= runtime->buffer_size) {
+		unsigned int cnt = runtime->buffer_size - buf_pos;
+		memcpy(runtime->dma_area + buf_pos * stride, buf, cnt * stride);
+		memcpy(runtime->dma_area, buf + cnt * stride,
+			length * stride - cnt * stride);
 	} else
-		memcpy(runtime->dma_area + buf_pos, buf, size);
+		memcpy(runtime->dma_area + buf_pos * stride, buf,
+			length * stride);
 
-	chip->buf_pos += size;
-	if (chip->buf_pos >= runtime->buffer_size * stride)
-		chip->buf_pos -= runtime->buffer_size * stride;
+#ifndef NO_PCM_LOCK
+       snd_pcm_stream_lock(substream);
+#endif
 
-	chip->period_pos += size;
+	chip->buf_pos += length;
+	if (chip->buf_pos >= runtime->buffer_size)
+		chip->buf_pos -= runtime->buffer_size;
+
+	chip->period_pos += length;
 	if (chip->period_pos >= runtime->period_size) {
 		chip->period_pos -= runtime->period_size;
 		period_elapsed = 1;
 	}
 
+#ifndef NO_PCM_LOCK
+       snd_pcm_stream_unlock(substream);
+#endif
+
 	if (period_elapsed)
 		snd_pcm_period_elapsed(substream);
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index cded411..57cb69e 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -256,7 +256,6 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
 		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
 		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0xa0);
-		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x05);
 		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
 		tm6000_set_reg(dev, TM6010_REQ08_R07_A_LEFT_VOL, 0x00);
 		tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, 0x00);
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index 6bf4a73..f6aa753 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -96,6 +96,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x21}, /* FIXME */
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
@@ -154,6 +155,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x21}, /* FIXME */
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
@@ -212,6 +214,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x76}, /* FIXME */
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
@@ -269,6 +272,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
 
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x79},
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
@@ -327,6 +331,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x22}, /* FIXME */
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index ce0a089..da26340 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -304,6 +304,14 @@ static int copy_streams(u8 *data, unsigned long len,
 					memcpy (&voutp[pos], ptr, cpysize);
 				break;
 			case TM6000_URB_MSG_AUDIO:
+				/* Need some code to copy audio buffer */
+				if (dev->fourcc == V4L2_PIX_FMT_YUYV) {
+					/* Swap word bytes */
+					int i;
+
+					for (i = 0; i < cpysize; i += 2)
+						swab16s((u16 *)(ptr + i));
+				}
 				tm6000_call_fillbuf(dev, TM6000_AUDIO, ptr, cpysize);
 				break;
 			case TM6000_URB_MSG_VBI:

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.


--MP_/HjZDTZDiaeveb.JZhwzEgLt
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_audio.patch

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 087137d..a99101f 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -160,15 +160,15 @@ static struct snd_pcm_hardware snd_tm6000_digital_hw = {
 		SNDRV_PCM_INFO_MMAP_VALID,
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
 
-	.rates =		SNDRV_PCM_RATE_48000,
+	.rates =		SNDRV_PCM_RATE_CONTINUOUS,
 	.rate_min =		48000,
 	.rate_max =		48000,
 	.channels_min = 2,
 	.channels_max = 2,
-	.period_bytes_min = 62720,
-	.period_bytes_max = 62720,
+	.period_bytes_min = 64,
+	.period_bytes_max = 12544,
 	.periods_min = 1,
-	.periods_max = 1024,
+	.periods_max = 98,
 	.buffer_bytes_max = 62720 * 8,
 };
 
@@ -211,38 +211,64 @@ static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
 	struct snd_pcm_runtime *runtime;
 	int period_elapsed = 0;
 	unsigned int stride, buf_pos;
+	int length;
 
-	if (!size || !substream)
+	if (!size || !substream) {
+		dprintk(1, "substream was NULL\n");
 		return -EINVAL;
+	}
 
 	runtime = substream->runtime;
-	if (!runtime || !runtime->dma_area)
+	if (!runtime || !runtime->dma_area) {
+		dprintk(1, "runtime was NULL\n");
 		return -EINVAL;
+	}
 
 	buf_pos = chip->buf_pos;
 	stride = runtime->frame_bits >> 3;
 
+	if (stride == 0) {
+		dprintk(1, "stride is zero\n");
+		return -EINVAL;
+	}
+
+	length = size / stride;
+	if (length == 0) {
+		dprintk(1, "%s: length was zero\n", __func__);
+		return -EINVAL;
+	}
+
 	dprintk(1, "Copying %d bytes at %p[%d] - buf size=%d x %d\n", size,
 		runtime->dma_area, buf_pos,
 		(unsigned int)runtime->buffer_size, stride);
 
-	if (buf_pos + size >= runtime->buffer_size * stride) {
-		unsigned int cnt = runtime->buffer_size * stride - buf_pos;
-		memcpy(runtime->dma_area + buf_pos, buf, cnt);
-		memcpy(runtime->dma_area, buf + cnt, size - cnt);
+	if (buf_pos + length >= runtime->buffer_size) {
+		unsigned int cnt = runtime->buffer_size - buf_pos;
+		memcpy(runtime->dma_area + buf_pos * stride, buf, cnt * stride);
+		memcpy(runtime->dma_area, buf + cnt * stride,
+			length * stride - cnt * stride);
 	} else
-		memcpy(runtime->dma_area + buf_pos, buf, size);
+		memcpy(runtime->dma_area + buf_pos * stride, buf,
+			length * stride);
 
-	chip->buf_pos += size;
-	if (chip->buf_pos >= runtime->buffer_size * stride)
-		chip->buf_pos -= runtime->buffer_size * stride;
+#ifndef NO_PCM_LOCK
+       snd_pcm_stream_lock(substream);
+#endif
 
-	chip->period_pos += size;
+	chip->buf_pos += length;
+	if (chip->buf_pos >= runtime->buffer_size)
+		chip->buf_pos -= runtime->buffer_size;
+
+	chip->period_pos += length;
 	if (chip->period_pos >= runtime->period_size) {
 		chip->period_pos -= runtime->period_size;
 		period_elapsed = 1;
 	}
 
+#ifndef NO_PCM_LOCK
+       snd_pcm_stream_unlock(substream);
+#endif
+
 	if (period_elapsed)
 		snd_pcm_period_elapsed(substream);
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index cded411..57cb69e 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -256,7 +256,6 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
 		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
 		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0xa0);
-		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x05);
 		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
 		tm6000_set_reg(dev, TM6010_REQ08_R07_A_LEFT_VOL, 0x00);
 		tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, 0x00);
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index 6bf4a73..f6aa753 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -96,6 +96,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x21}, /* FIXME */
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
@@ -154,6 +155,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x21}, /* FIXME */
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
@@ -212,6 +214,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x76}, /* FIXME */
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
@@ -269,6 +272,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
 
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x79},
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
@@ -327,6 +331,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
+			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x22}, /* FIXME */
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index ce0a089..da26340 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -304,6 +304,14 @@ static int copy_streams(u8 *data, unsigned long len,
 					memcpy (&voutp[pos], ptr, cpysize);
 				break;
 			case TM6000_URB_MSG_AUDIO:
+				/* Need some code to copy audio buffer */
+				if (dev->fourcc == V4L2_PIX_FMT_YUYV) {
+					/* Swap word bytes */
+					int i;
+
+					for (i = 0; i < cpysize; i += 2)
+						swab16s((u16 *)(ptr + i));
+				}
 				tm6000_call_fillbuf(dev, TM6000_AUDIO, ptr, cpysize);
 				break;
 			case TM6000_URB_MSG_VBI:

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/HjZDTZDiaeveb.JZhwzEgLt--
