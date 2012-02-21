Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2416 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2BUJor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 04:44:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] tea575x: fix HW seek
Date: Tue, 21 Feb 2012 10:44:14 +0100
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
References: <201202181745.49819.linux@rainbow-software.org>
In-Reply-To: <201202181745.49819.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202211044.14925.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday, February 18, 2012 17:45:45 Ondrej Zary wrote:
> Fix HW seek in TEA575x to work properly:
>  - a delay must be present after search start and before first register read
>    or the seek does weird things
>  - when the search stops, the new frequency is not available immediately, we
>    must wait until it appears in the register (fortunately, we can clear the
>    frequency bits when starting the search as it starts at the frequency
>    currently set, not from the value written)
>  - sometimes, seek remains on the current frequency (or moves only a little),
>    so repeat it until it moves by at least 50 kHz
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- a/sound/i2c/other/tea575x-tuner.c
> +++ b/sound/i2c/other/tea575x-tuner.c
> @@ -89,7 +89,7 @@ static void snd_tea575x_write(struct snd_tea575x *tea, unsigned int val)
>  		tea->ops->set_pins(tea, 0);
>  }
>  
> -static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
> +static u32 snd_tea575x_read(struct snd_tea575x *tea)
>  {
>  	u16 l, rdata;
>  	u32 data = 0;
> @@ -120,6 +120,27 @@ static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
>  	return data;
>  }
>  
> +static void snd_tea575x_get_freq(struct snd_tea575x *tea)
> +{
> +	u32 freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
> +
> +	if (freq == 0) {
> +		tea->freq = 0;

Wouldn't it be better to return -EBUSY in this case? VIDIOC_G_FREQUENCY
should not return frequencies outside the valid frequency range. In this case
returning -EBUSY seems to make more sense to me.

I'm proposing adding this patch:

diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 474bb81..02da22f 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -120,14 +120,12 @@ static u32 snd_tea575x_read(struct snd_tea575x *tea)
 	return data;
 }
 
-static void snd_tea575x_get_freq(struct snd_tea575x *tea)
+static int snd_tea575x_get_freq(struct snd_tea575x *tea)
 {
 	u32 freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
 
-	if (freq == 0) {
-		tea->freq = 0;
-		return;
-	}
+	if (freq == 0)
+		return -EBUSY;
 
 	/* freq *= 12.5 */
 	freq *= 125;
@@ -139,6 +137,7 @@ static void snd_tea575x_get_freq(struct snd_tea575x *tea)
 		freq -= TEA575X_FMIF;
 
 	tea->freq = clamp(freq * 16, FREQ_LO, FREQ_HI); /* from kHz */
+	return 0;
 }
 
 static void snd_tea575x_set_freq(struct snd_tea575x *tea)
@@ -220,14 +219,15 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 					struct v4l2_frequency *f)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
+	int ret = 0;
 
 	if (f->tuner != 0)
 		return -EINVAL;
 	f->type = V4L2_TUNER_RADIO;
 	if (!tea->cannot_read_data)
-		snd_tea575x_get_freq(tea);
+		ret = snd_tea575x_get_freq(tea);
 	f->frequency = tea->freq;
-	return 0;
+	return ret;
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
@@ -250,11 +250,14 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
 	struct snd_tea575x *tea = video_drvdata(file);
 	int i, old_freq;
 	unsigned long timeout;
+	int ret;
 
 	if (tea->cannot_read_data)
 		return -ENOTTY;
 
-	snd_tea575x_get_freq(tea);
+	ret = snd_tea575x_get_freq(tea);
+	if (ret)
+		return ret;
 	old_freq = tea->freq;
 	/* clear the frequency, HW will fill it in */
 	tea->val &= ~TEA575X_BIT_FREQ_MASK;
@@ -278,8 +281,8 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
 			/* Found a frequency, wait until it can be read */
 			for (i = 0; i < 100; i++) {
 				msleep(10);
-				snd_tea575x_get_freq(tea);
-				if (tea->freq != 0) /* available */
+				ret = snd_tea575x_get_freq(tea);
+				if (ret == 0) /* available */
 					break;
 			}
 			/* if we moved by less than 50 kHz, continue seeking */

If you are OK with this, then I'll put everything together and make a final
pull request.

Regards,

	Hans
