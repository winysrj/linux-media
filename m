Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4L3G4rP026422
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 23:16:04 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4L3FqaF007564
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 23:15:52 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1061935nfc.21
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 20:15:51 -0700 (PDT)
Date: Wed, 21 May 2008 13:16:52 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080521131652.5a4850a5@glory.loctelecom.ru>
In-Reply-To: <1211331167.4235.26.camel@pc10.localdom.local>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
	<20080520152426.5540ee7f@glory.loctelecom.ru>
	<1211331167.4235.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/+RobRYDM=ojV.3B_n2eFMrF"
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] I2S on for MPEG of saa7134_empress
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--MP_/+RobRYDM=ojV.3B_n2eFMrF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Rework saa7134_enable_i2s function. Add vendor specific data.
Add definition for I2S audio output control register.

diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Wed May 21 06:45:52 2008 +1000
@@ -928,13 +928,25 @@ void saa7134_enable_i2s(struct saa7134_d
 
 	if (!card_is_empress(dev))
 		return;
-	i2s_format = (dev->input->amux == TV) ? 0x00 : 0x01;
-
-	/* enable I2S audio output for the mpeg encoder */
-	saa_writeb(SAA7134_I2S_OUTPUT_SELECT,  0x80);
-	saa_writeb(SAA7134_I2S_OUTPUT_FORMAT,  i2s_format);
-	saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,   0x0F);
-	saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x01);
+
+	switch (dev->board) {
+	case SAA7134_BOARD_BEHOLD_M6:
+	    /* configure GPIO for out audio */
+	    saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x0E000000, 0x00000000);
+	    /* Set I2S format  */
+	    saa_writeb(SAA7134_I2S_AUDIO_CONTROL,  0x00);
+	    /* Start I2S */
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x11);
+	    break;
+	default:
+	    i2s_format = (dev->input->amux == TV) ? 0x00 : 0x01;
+
+	    /* enable I2S audio output for the mpeg encoder */
+	    saa_writeb(SAA7134_I2S_OUTPUT_SELECT,  0x80);
+	    saa_writeb(SAA7134_I2S_OUTPUT_FORMAT,  i2s_format);
+	    saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,   0x0F);
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x01);
+	}
 }
 
 int saa7134_tvaudio_rx2mode(u32 rx)
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-reg.h
--- a/linux/drivers/media/video/saa7134/saa7134-reg.h	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-reg.h	Wed May 21 06:04:49 2008 +1000
@@ -353,6 +353,7 @@
 
 /* I2S output */
 #define SAA7134_I2S_AUDIO_OUTPUT                0x1c0
+#define SAA7134_I2S_AUDIO_CONTROL               0x591
 
 /* test modes */
 #define SAA7134_SPECIAL_MODE                    0x1d0

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

P.S. After this patch I have some data from /dev/video1. Mplayer mpeg_test02.dat
I can see gray screen with blinked color squares. May be audio data?

With my best regards, Dmitry.

--MP_/+RobRYDM=ojV.3B_n2eFMrF
Content-Type: text/x-patch; name=beholder_empress_02.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=beholder_empress_02.diff

diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Wed May 21 06:45:52 2008 +1000
@@ -928,13 +928,25 @@ void saa7134_enable_i2s(struct saa7134_d
 
 	if (!card_is_empress(dev))
 		return;
-	i2s_format = (dev->input->amux == TV) ? 0x00 : 0x01;
-
-	/* enable I2S audio output for the mpeg encoder */
-	saa_writeb(SAA7134_I2S_OUTPUT_SELECT,  0x80);
-	saa_writeb(SAA7134_I2S_OUTPUT_FORMAT,  i2s_format);
-	saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,   0x0F);
-	saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x01);
+
+	switch (dev->board) {
+	case SAA7134_BOARD_BEHOLD_M6:
+	    /* configure GPIO for out audio */
+	    saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x0E000000, 0x00000000);
+	    /* Set I2S format  */
+	    saa_writeb(SAA7134_I2S_AUDIO_CONTROL,  0x00);
+	    /* Start I2S */
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x11);
+	    break;
+	default:
+	    i2s_format = (dev->input->amux == TV) ? 0x00 : 0x01;
+
+	    /* enable I2S audio output for the mpeg encoder */
+	    saa_writeb(SAA7134_I2S_OUTPUT_SELECT,  0x80);
+	    saa_writeb(SAA7134_I2S_OUTPUT_FORMAT,  i2s_format);
+	    saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,   0x0F);
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x01);
+	}
 }
 
 int saa7134_tvaudio_rx2mode(u32 rx)
diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-reg.h
--- a/linux/drivers/media/video/saa7134/saa7134-reg.h	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-reg.h	Wed May 21 06:04:49 2008 +1000
@@ -353,6 +353,7 @@
 
 /* I2S output */
 #define SAA7134_I2S_AUDIO_OUTPUT                0x1c0
+#define SAA7134_I2S_AUDIO_CONTROL               0x591
 
 /* test modes */
 #define SAA7134_SPECIAL_MODE                    0x1d0

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/+RobRYDM=ojV.3B_n2eFMrF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/+RobRYDM=ojV.3B_n2eFMrF--
