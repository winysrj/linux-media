Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1IXMGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 08:06:06 -0400
Message-ID: <4E7DC7A6.7030000@infradead.org>
Date: Sat, 24 Sep 2011 09:05:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Lennart Poettering <lpoetter@redhat.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org> <4E2C5A35.9030404@list.ru> <4E2C6638.2040707@infrade ad.org> <4E760BCA.6080900@list.ru>
In-Reply-To: <4E760BCA.6080900@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-09-2011 12:18, Stas Sergeev escreveu:
> Hi Mauro, I've finally found the time (and an energy)
> to go look into the automute breakage.
> With the attached automute fix I no longer have
> any problems with pulseaudio.
> I also attached the patch that introduces an "std"
> option to limit the scan list, resulting in a faster scan.
> It is completely unrelated to the automute one, it is
> here just in case.
> What do you think?
> 
 
> Content-Type: text/plain; charset="utf-8"
> MIME-Version: 1.0
> Content-Transfer-Encoding: 7bit
> Subject: [1/2,saa7134] do not change mute state for capturing audio
> Date: Sun, 18 Sep 2011 14:18:34 -0000
> From: Stas Sergeev <stsp@list.ru>
> X-Patchwork-Id: 7940
> Message-Id: <4E760BCA.6080900-patch1@list.ru>
> To: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: linux-media@vger.kernel.org, "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
> 	Lennart Poettering <lpoetter@redhat.com>,
> 	ALSA devel <alsa-devel@alsa-project.org>
> 
> Hi Mauro, I've finally found the time (and an energy)
> to go look into the automute breakage.
> With the attached automute fix I no longer have
> any problems with pulseaudio.
> I also attached the patch that introduces an "std"
> option to limit the scan list, resulting in a faster scan.
> It is completely unrelated to the automute one, it is
> here just in case.
> What do you think?
> 
> 
> >From ccdfa126e98b5484f4a08de591ac8d89f775251c Mon Sep 17 00:00:00 2001
> From: Stas Sergeev <stsp@users.sourceforge.net>
> Date: Sun, 18 Sep 2011 19:06:21 +0400
> Subject: [PATCH 1/2] saa7134: fix automute
> 
> ---
>  drivers/media/video/saa7134/saa7134-tvaudio.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
> index 57e646b..62a6287 100644
> --- a/drivers/media/video/saa7134/saa7134-tvaudio.c
> +++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
> @@ -332,7 +332,7 @@ static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
>  {
>  	__s32 left,right,value;
>  
> -	if (audio_debug > 1) {
> +	if (audio_debug > 1 && (dev->tvnorm->id & scan->std)) {
>  		int i;
>  		dprintk("debug %d:",scan->carr);
>  		for (i = -150; i <= 150; i += 30) {


Better to post it as a separate patch, and to simplify the code with:

diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
index 57e646b..a61ed1e 100644
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -332,6 +332,12 @@ static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
 {
 	__s32 left,right,value;
 
+	if (!dev->tvnorm->id & scan->std)) {
+		dprintk("skipping %d.%03d MHz [%4s]\n",
+			scan->carr / 1000, scan->carr % 1000, scan->name);
+		return 0;
+	}
+
 	if (audio_debug > 1) {
 		int i;
 		dprintk("debug %d:",scan->carr);
@@ -348,30 +354,25 @@ static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
 		}
 		printk("\n");
 	}
-	if (dev->tvnorm->id & scan->std) {
-		tvaudio_setcarrier(dev,scan->carr-90,scan->carr-90);
-		saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
-		if (tvaudio_sleep(dev,SCAN_SAMPLE_DELAY))
-			return -1;
-		left = saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
-
-		tvaudio_setcarrier(dev,scan->carr+90,scan->carr+90);
-		saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
-		if (tvaudio_sleep(dev,SCAN_SAMPLE_DELAY))
-			return -1;
-		right = saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
-
-		left >>= 16;
-		right >>= 16;
-		value = left > right ? left - right : right - left;
-		dprintk("scanning %d.%03d MHz [%4s] =>  dc is %5d [%d/%d]\n",
-			scan->carr / 1000, scan->carr % 1000,
-			scan->name, value, left, right);
-	} else {
-		value = 0;
-		dprintk("skipping %d.%03d MHz [%4s]\n",
-			scan->carr / 1000, scan->carr % 1000, scan->name);
-	}
+	tvaudio_setcarrier(dev,scan->carr-90,scan->carr-90);
+	saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
+	if (tvaudio_sleep(dev,SCAN_SAMPLE_DELAY))
+		return -1;
+	left = saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
+
+	tvaudio_setcarrier(dev,scan->carr+90,scan->carr+90);
+	saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
+	if (tvaudio_sleep(dev,SCAN_SAMPLE_DELAY))
+		return -1;
+	right = saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
+
+	left >>= 16;
+	right >>= 16;
+	value = left > right ? left - right : right - left;
+	dprintk("scanning %d.%03d MHz [%4s] =>  dc is %5d [%d/%d]\n",
+		scan->carr / 1000, scan->carr % 1000,
+		scan->name, value, left, right);
+
 	return value;
 }
 

> @@ -546,6 +546,7 @@ static int tvaudio_thread(void *data)
>  				dev->tvnorm->name, carrier/1000, carrier%1000,
>  				max1, max2);
>  			dev->last_carrier = carrier;
> +			dev->automute = !(dev->thread.scan1 > 1);

Why?

If the carrier is good, this should be enough:

			dev->automute = 0;

>  
>  		} else if (0 != dev->last_carrier) {
>  			/* no carrier -- try last detected one as fallback */
> @@ -553,6 +554,7 @@ static int tvaudio_thread(void *data)
>  			dprintk("audio carrier scan failed, "
>  				"using %d.%03d MHz [last detected]\n",
>  				carrier/1000, carrier%1000);
> +			dev->automute = 1;
>  
>  		} else {
>  			/* no carrier + no fallback -- use default */
> @@ -560,9 +562,9 @@ static int tvaudio_thread(void *data)
>  			dprintk("audio carrier scan failed, "
>  				"using %d.%03d MHz [default]\n",
>  				carrier/1000, carrier%1000);
> +			dev->automute = 1;
>  		}
>  		tvaudio_setcarrier(dev,carrier,carrier);
> -		dev->automute = 0;
>  		saa_andorb(SAA7134_STEREO_DAC_OUTPUT_SELECT, 0x30, 0x00);
>  		saa7134_tvaudio_setmute(dev);
>  		/* find the exact tv audio norm */
> @@ -1020,6 +1022,7 @@ int saa7134_tvaudio_init2(struct saa7134_dev *dev)
>  	}
>  
>  	dev->thread.thread = NULL;
> +	dev->thread.scan1 = dev->thread.scan2 = 0;
>  	if (my_thread) {
>  		saa7134_tvaudio_init(dev);
>  		/* start tvaudio thread */

The rest looked sane on my eyes, but I didn't double-checked it by running
on my cards. Had you test calling it with just a single standard, and with
a multiple standards mask?

Thanks,
Mauro
