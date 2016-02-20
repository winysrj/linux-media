Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33409 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1948978AbcBTIyq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 03:54:46 -0500
Date: Sat, 20 Feb 2016 06:54:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: grigore calugar <zradu1100@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: SAA7134 card stop working
Message-ID: <20160220065440.79b76d92@recife.lan>
In-Reply-To: <CA+S3egC3v7GeOtaKt6iNa=TvnLnL=iC472xYFFX-Lm6WYccHrg@mail.gmail.com>
References: <CA+S3egC3v7GeOtaKt6iNa=TvnLnL=iC472xYFFX-Lm6WYccHrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Feb 2016 02:57:55 +0200
grigore calugar <zradu1100@gmail.com> escreveu:

> After this series of patches
> http://www.spinics.net/lists/linux-media/msg97115.html
> my tv card V-Stream Studio TV Terminator has no signal in tvtime until
> exchange audio standard from tvtime menu.
> 
> tvtime start with blue screen "no signal"
> When exchange audio standard from PAL-BG to PAL-DK , PAL-I and back to
> PAL-BG, the image appears on screen.
> It seems that the tuner is uninitialized until I change audio norm.

None of the changes should have changed the tuner initialization.

There are changes there, however, that could have changed the initialization
for different inputs. What input are you using?

Could you please send the output of the command:

	$ lsmod

to me?


Also, could you please test the enclosed patch?



diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index ffa39543eb65..f451e38e5759 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -479,7 +479,10 @@ void saa7134_set_tvnorm_hw(struct saa7134_dev *dev)
 {
 	saa7134_set_decoder(dev);
 
-	saa_call_all(dev, video, s_std, dev->tvnorm->id);
+	if (card_in(dev, n).type == SAA7134_INPUT_TV ||
+	    card_in(dev, n).type == SAA7134_INPUT_TV_MONO)
+		saa_call_all(dev, video, s_std, dev->tvnorm->id);
+
 	/* Set the correct norm for the saa6752hs. This function
 	   does nothing if there is no saa6752hs. */
 	saa_call_empress(dev, video, s_std, dev->tvnorm->id);

-- 
Thanks,
Mauro
