Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0FFPTc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 11:19:32 -0400
Message-ID: <4C0BBC66.7040309@redhat.com>
Date: Sun, 06 Jun 2010 12:19:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Bee Hock Goh <beehock@gmail.com>
Subject: Re: tm6000 audio buffer
References: <AANLkTind4rEphKcFnoBBa-GV9iQsOumX7M0mRVE1SYyq@mail.gmail.com>
In-Reply-To: <AANLkTind4rEphKcFnoBBa-GV9iQsOumX7M0mRVE1SYyq@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luis,

Em 04-06-2010 16:39, Luis Henrique Fagundes escreveu:
> Hi,
> 
> I'm sending a patch that hypothetically would allocate a memory buffer
> for the audio and copy the data from urb to buffer. It doesn't work,
> so I'm not putting a [PATCH] in subject and send it just for feedback.
> Am I going on the right way of implementing this? The patch was made
> against the mercurial version at http://linuxtv.org/hg/v4l-dvb.
> 
> I can see the audio packets at tm6000-video.c. Mauro said that the urb
> audio packets had just 4 bytes of relevant data, 2 for each channel,
> but the audio buffer has 128Kb and I see too few packets. Anyway, the
> tm6000_audio_isocirq function receives the size of the packet and now
> is copying everything to the buffer, I guess next step will be to find
> what is relevant in this stream and make sure I have all packets here.
> 
> I haven't applied all the recent patches from Stefan yet.

I found some time to fix several bugs at the alsa driver, and to properly
add a function to copy the audio data into the buffers. It seems to be
working, but I found the same problem as you: the number of packages is
incredibly small. So, or the audio is not properly programmed on the
device or the routine that decodes the URB packages are wrong. Yet, if you
wait for enough time (several minutes), with for example:
	$ arecord -D hw:1,0 -r 48000 -c 2 -f S16_LE -M

You'll see some random data at stdout. So, the alsa code seems to be ok.

As I'm preparing to travel to V4L mini-summit, I doubt I would have any
time to touch on the code during the next weeks, but maybe one of you
may find some time to fix.

I suggest to use some USB traffic analyzer to see what is happening, 
comparing the results on Linux and with the original driver, using the 
same source (for example, you may use one test signal with some audio 
buzz inside).

As reference for you, I'm enclosing a patch that adds some additional debug
code at copy_streams(), plus a trial I did, in order to play with some bits
related to audio, but it didn't help.

All the patches are at "staging/tm6000" branch, on my tree.

Cheers,
Mauro.


diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index d31b525..aa38577 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -84,6 +84,8 @@ static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 	val |= 0x20;
 	tm6000_set_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
 
+	tm6000_set_audio_bitrate(core, 48000);
+
 	tm6000_set_reg(core, TM6010_REQ08_R01_A_INIT, 0x80);
 
 	return 0;
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 46b9ec5..1fea5a0 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -602,8 +602,17 @@ int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 {
 	int val;
 
+	if (dev->dev_type == TM6010) {
+		val = tm6000_get_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0);
+		if (val < 0)
+			return val;
+		val = (val & 0xf0) | 0x1;
+		val = tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, val);
+		if (val < 0)
+			return val;
+	}
+
 	val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, 0x0);
-	printk("Original value=%d\n", val);
 	if (val < 0)
 		return val;
 
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 34e8ef5..cc4298e 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -303,6 +304,15 @@ static int copy_streams(u8 *data, unsigned long len,
 				break;
 			case TM6000_URB_MSG_AUDIO:
 				tm6000_call_fillbuf(dev, TM6000_AUDIO, ptr, cpysize);
+if (cpysize < pktsize) {
+printk("Audio[%d] = %02x %02x %02x %02x\n",
+cpysize,
+ptr[cpysize],
+ptr[cpysize+1],
+ptr[cpysize+2],
+ptr[cpysize+3]);
+}
+
 				break;
 			case TM6000_URB_MSG_VBI:
 				/* Need some code to copy vbi buffer */

