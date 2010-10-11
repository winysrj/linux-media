Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:41831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab0JKVD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 17:03:57 -0400
Message-ID: <4CB37BB6.4050307@infradead.org>
Date: Mon, 11 Oct 2010 18:03:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PULL] http://kernellabs.com/hg/~stoth/saa7164-v4l
References: <AANLkTima57h2Zz23y885AnyzWJOOUNWZxzt4o4gRjaUX@mail.gmail.com>
In-Reply-To: <AANLkTima57h2Zz23y885AnyzWJOOUNWZxzt4o4gRjaUX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi stoth,

Em 31-07-2010 17:42, Steven Toth escreveu:
> Mauro,
> 
> Analog Encoder and VBI support in the SAA7164 tree, for the HVR2200
> and HVR2250 cards.
> 
> Please pull from http://www.kernellabs.com/hg/~stoth/saa7164-v4l
> 

As requested on irc, I've pulled from your tree again, and fixed a few things
on your patch series (a warning and _lots_ of checkpatch issues).

There are still some compilation breakages in the middle of your patch series.
So, I'll fold some patches, in order to avoid the issues.

There are still a few checkpatch issues (I removed all 80-columns warning noise).
Could you please double check them?

To make life easier for you, I've created a temp git tree at:
	http://git.linuxtv.org/mchehab/stoth.git

The checkpatch.pl errors/warnings are enclosed bellow.

Thanks,
Mauro

---

WARNING: braces {} are not necessary for single statement blocks
#47: FILE: drivers/media/video/saa7164/saa7164-api.c:43:
+	if (ret != SAA_OK) {
+		printk(KERN_ERR "%s() error, ret = 0x%x\n", __func__, ret);
+	}

WARNING: braces {} are not necessary for single statement blocks
#70: FILE: drivers/media/video/saa7164/saa7164-api.c:66:
+		if (ret != SAA_OK) {
+			printk(KERN_ERR "%s() error, ret = 0x%x\n", __func__, ret);
+		}

WARNING: braces {} are not necessary for single statement blocks
#93: FILE: drivers/media/video/saa7164/saa7164-api.c:89:
+	if (ret != SAA_OK) {
+		printk(KERN_ERR "%s() error, ret = 0x%x\n", __func__, ret);
+	}

WARNING: braces {} are not necessary for single statement blocks
#103: FILE: drivers/media/video/saa7164/saa7164-api.c:99:
+	if (ret != SAA_OK) {
+		printk(KERN_ERR "%s() error, ret = 0x%x\n", __func__, ret);
+	}

ERROR: do not use C99 // comments
#654: FILE: drivers/media/video/saa7164/saa7164-api.c:650:
+	//saa7164_dumphex16(dev, buf, 16);

WARNING: kfree(NULL) is safe this check is probably not required
#1381: FILE: drivers/media/video/saa7164/saa7164-buffer.c:317:
+	if (buf->data) {
+		kfree(buf->data);

WARNING: kfree(NULL) is safe this check is probably not required
#1386: FILE: drivers/media/video/saa7164/saa7164-buffer.c:322:
+	if (buf)
+		kfree(buf);

ERROR: do not use C99 // comments
#1962: FILE: drivers/media/video/saa7164/saa7164-core.c:126:
+//			saa7164_dumphex16FF(buf->port->dev, (p + i), 32);

WARNING: braces {} are not necessary for single statement blocks
#2038: FILE: drivers/media/video/saa7164/saa7164-core.c:202:
+	for (i = 0; i < 30; i++) {
+		hg->counter1[0 + i].val = i;
+	}

WARNING: braces {} are not necessary for single statement blocks
#2043: FILE: drivers/media/video/saa7164/saa7164-core.c:207:
+	for (i = 0; i < 18; i++) {
+		hg->counter1[30 + i].val = 30 + (i * 10);
+	}

WARNING: braces {} are not necessary for single statement blocks
#2048: FILE: drivers/media/video/saa7164/saa7164-core.c:212:
+	for (i = 0; i < 15; i++) {
+		hg->counter1[48 + i].val = 200 + (i * 200);
+	}

WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
#2103: FILE: drivers/media/video/saa7164/saa7164-core.c:267:
+		printk(KERN_ERR " %4d %12d %Ld\n",

ERROR: do not use C99 // comments
#2154: FILE: drivers/media/video/saa7164/saa7164-core.c:318:
+//						saa7164_dumphex16FF(dev, (p + buf->actual_size) - 32 , 64);

WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
#2239: FILE: drivers/media/video/saa7164/saa7164-core.c:403:
+		"%s() %Ldms elapsed irq->deferred %Ldms wp: %d rp: %d\n",

WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
#2315: FILE: drivers/media/video/saa7164/saa7164-core.c:479:
+		"%s() %Ldms elapsed irq->deferred %Ldms wp: %d rp: %d\n",

WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
#2402: FILE: drivers/media/video/saa7164/saa7164-core.c:567:
+	dprintk(DBGLVL_IRQ, "%s() %Ldms elapsed\n", __func__,

WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
#2427: FILE: drivers/media/video/saa7164/saa7164-core.c:592:
+	dprintk(DBGLVL_IRQ, "%s() %Ldms elapsed\n", __func__,

ERROR: else should follow close brace '}'
#2606: FILE: drivers/media/video/saa7164/saa7164-core.c:965:
+	}
+	else

WARNING: struct file_operations should normally be const
#2747: FILE: drivers/media/video/saa7164/saa7164-core.c:1172:
+static struct file_operations saa7164_proc_fops = {

WARNING: braces {} are not necessary for single statement blocks
#4427: FILE: drivers/media/video/saa7164/saa7164-encoder.c:1236:
+		if (ubuf->pos > ubuf->actual_size) {
+			printk(KERN_ERR "read() pos > actual, huh?\n");
+		}

WARNING: braces {} are not necessary for single statement blocks
#4453: FILE: drivers/media/video/saa7164/saa7164-encoder.c:1262:
+	if (!ret && !ubuf) {
+		ret = -EAGAIN;
+	}

WARNING: braces {} are not necessary for single statement blocks
#4475: FILE: drivers/media/video/saa7164/saa7164-encoder.c:1284:
+	if (!video_is_registered(port->v4l_device)) {
+		return -EIO;
+	}

ERROR: do not use C99 // comments
#5359: FILE: drivers/media/video/saa7164/saa7164-vbi.c:54:
+//	/* Configure the correct video standard */

ERROR: do not use C99 // comments
#5360: FILE: drivers/media/video/saa7164/saa7164-vbi.c:55:
+//	saa7164_api_configure_dif(port, port->encodernorm.id);

ERROR: do not use C99 // comments
#5362: FILE: drivers/media/video/saa7164/saa7164-vbi.c:57:
+//	/* Ensure the audio decoder is correct configured */

ERROR: do not use C99 // comments
#5363: FILE: drivers/media/video/saa7164/saa7164-vbi.c:58:
+//	saa7164_api_set_audio_std(port);

ERROR: do not use C99 // comments
#6228: FILE: drivers/media/video/saa7164/saa7164-vbi.c:923:
+//	saa7164_api_set_encoder(port);

ERROR: do not use C99 // comments
#6229: FILE: drivers/media/video/saa7164/saa7164-vbi.c:924:
+//	saa7164_api_get_encoder(port);

WARNING: braces {} are not necessary for single statement blocks
#6488: FILE: drivers/media/video/saa7164/saa7164-vbi.c:1183:
+		if (ubuf->pos > ubuf->actual_size) {
+			printk(KERN_ERR "read() pos > actual, huh?\n");
+		}

WARNING: braces {} are not necessary for single statement blocks
#6537: FILE: drivers/media/video/saa7164/saa7164-vbi.c:1232:
+	if (!video_is_registered(port->v4l_device)) {
+		return -EIO;
+	}

ERROR: do not use C99 // comments
#6597: FILE: drivers/media/video/saa7164/saa7164-vbi.c:1292:
+//	.vidioc_g_chip_ident	 = saa7164_g_chip_ident,

ERROR: do not use C99 // comments
#6599: FILE: drivers/media/video/saa7164/saa7164-vbi.c:1294:
+//	.vidioc_g_register	 = saa7164_g_register,

ERROR: do not use C99 // comments
#6600: FILE: drivers/media/video/saa7164/saa7164-vbi.c:1295:
+//	.vidioc_s_register	 = saa7164_s_register,

ERROR: do not use C99 // comments
#6813: FILE: drivers/media/video/saa7164/saa7164.h:186:
+//	u32 freq;

ERROR: do not use C99 // comments
#6814: FILE: drivers/media/video/saa7164/saa7164.h:187:
+//	u32 tuner_type;

ERROR: do not use C99 // comments
#6820: FILE: drivers/media/video/saa7164/saa7164.h:193:
+//	u32 freq;

ERROR: do not use C99 // comments
#6821: FILE: drivers/media/video/saa7164/saa7164.h:194:
+//	u32 tuner_type;

ERROR: do not use C99 // comments
#6862: FILE: drivers/media/video/saa7164/saa7164.h:269:
+//	u32		cxiformat;

ERROR: do not use C99 // comments
#6863: FILE: drivers/media/video/saa7164/saa7164.h:270:
+//	u32		cxoformat;

ERROR: Missing Signed-off-by: line(s)

total: 20 errors, 20 warnings, 6999 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
