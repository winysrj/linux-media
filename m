Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5AAsPX1016276
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 06:54:25 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5AAsDhh030757
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 06:54:13 -0400
Received: by fk-out-0910.google.com with SMTP id e30so1520796fke.3
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 03:54:12 -0700 (PDT)
Date: Tue, 10 Jun 2008 20:56:20 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080610205620.1ee7eebb@glory.loctelecom.ru>
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
Content-Type: multipart/mixed; boundary="MP_/sSAW3NKqUQf+VxxD.rrbf/1"
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] New for I2S on for MPEG of saa7134_empress
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

--MP_/sSAW3NKqUQf+VxxD.rrbf/1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi All

Rework saa7134_enable_i2s function. Remove vendor specific data.
Configure I2S output port specific for model of SAA7133/5-SAA7134.=20
I think it is more good.
Renamed definition of I2S audio output control register. It`s SAA7133/5 reg=
ister
Start video port after configuring procedure.

diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-reg.h
--- a/linux/drivers/media/video/saa7134/saa7134-reg.h	Mon Jun 09 11:59:05 2=
008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-reg.h	Mon Jun 09 15:16:05 2=
008 +1000
@@ -353,7 +353,6 @@
=20
 /* I2S output */
 #define SAA7134_I2S_AUDIO_OUTPUT                0x1c0
-#define SAA7134_I2S_AUDIO_CONTROL               0x591
=20
 /* test modes */
 #define SAA7134_SPECIAL_MODE                    0x1d0
@@ -369,6 +368,7 @@
 #define SAA7135_DSP_RWCLEAR			0x586
 #define SAA7135_DSP_RWCLEAR_RERR		    1
=20
+#define SAA7133_I2S_AUDIO_CONTROL               0x591
 /* ------------------------------------------------------------------ */
 /*
  * Local variables:
diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Mon Jun 09 11:59:=
05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Tue Jun 10 20:33:=
00 2008 +1000
@@ -929,23 +929,32 @@ void saa7134_enable_i2s(struct saa7134_d
 	if (!card_is_empress(dev))
 		return;
=20
-	switch (dev->board) {
-	case SAA7134_BOARD_BEHOLD_M6:
-	    /* configure GPIO for out audio */
-	    saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x0E000000, 0x00000000);
-	    /* Set I2S format  */
-	    saa_writeb(SAA7134_I2S_AUDIO_CONTROL,  0x00);
+	if (dev->pci->device =3D=3D PCI_DEVICE_ID_PHILIPS_SAA7130)
+		return;
+
+	/* configure GPIO for out */
+	saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x0E000000, 0x00000000);
+
+	switch (dev->pci->device) {
+	case PCI_DEVICE_ID_PHILIPS_SAA7133:
+	case PCI_DEVICE_ID_PHILIPS_SAA7135:
+	    /* Set I2S format (SONY) =C2=A0*/
+	    saa_writeb(SAA7133_I2S_AUDIO_CONTROL, 0x00);
 	    /* Start I2S */
-	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x11);
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT, 0x11);
 	    break;
+
+	case PCI_DEVICE_ID_PHILIPS_SAA7134:
+	    i2s_format =3D (dev->input->amux =3D=3D TV) ? 0x00 : 0x01;
+
+	    /* enable I2S audio output for the mpeg encoder */
+	    saa_writeb(SAA7134_I2S_OUTPUT_SELECT, 0x80);
+	    saa_writeb(SAA7134_I2S_OUTPUT_FORMAT, i2s_format);
+	    saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,  0x0F);
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,  0x01);
+
 	default:
-	    i2s_format =3D (dev->input->amux =3D=3D TV) ? 0x00 : 0x01;
-
-	    /* enable I2S audio output for the mpeg encoder */
-	    saa_writeb(SAA7134_I2S_OUTPUT_SELECT,  0x80);
-	    saa_writeb(SAA7134_I2S_OUTPUT_FORMAT,  i2s_format);
-	    saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,   0x0F);
-	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x01);
+	    break;
 	}
 }
=20
diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Mon Jun 09 11:59:05=
 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Jun 10 19:49:58=
 2008 +1000
@@ -2469,13 +2469,14 @@ int saa7134_videoport_init(struct saa713
 	int vo =3D saa7134_boards[dev->board].video_out;
 	int video_reg;
 	unsigned int vid_port_opts =3D saa7134_boards[dev->board].vid_port_opts;
+
+	/* Configure videoport */
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL0, video_out[vo][0]);
 	video_reg =3D video_out[vo][1];
 	if (vid_port_opts & SET_T_CODE_POLARITY_NON_INVERTED)
 		video_reg &=3D ~VP_T_CODE_P_INVERTED;
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL1, video_reg);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL2, video_out[vo][2]);
-	saa_writeb(SAA7134_VIDEO_PORT_CTRL3, video_out[vo][3]);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL4, video_out[vo][4]);
 	video_reg =3D video_out[vo][5];
 	if (vid_port_opts & SET_CLOCK_NOT_DELAYED)
@@ -2491,6 +2492,9 @@ int saa7134_videoport_init(struct saa713
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL6, video_reg);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL7, video_out[vo][7]);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL8, video_out[vo][8]);
+
+	/* Start videoport */
+	saa_writeb(SAA7134_VIDEO_PORT_CTRL3, video_out[vo][3]);
=20
 	return 0;
 }

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/sSAW3NKqUQf+VxxD.rrbf/1
Content-Type: text/x-patch; name=beholder_ts_02.diff
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=beholder_ts_02.diff

diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-reg.h
--- a/linux/drivers/media/video/saa7134/saa7134-reg.h	Mon Jun 09 11:59:05 2=
008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-reg.h	Mon Jun 09 15:16:05 2=
008 +1000
@@ -353,7 +353,6 @@
=20
 /* I2S output */
 #define SAA7134_I2S_AUDIO_OUTPUT                0x1c0
-#define SAA7134_I2S_AUDIO_CONTROL               0x591
=20
 /* test modes */
 #define SAA7134_SPECIAL_MODE                    0x1d0
@@ -369,6 +368,7 @@
 #define SAA7135_DSP_RWCLEAR			0x586
 #define SAA7135_DSP_RWCLEAR_RERR		    1
=20
+#define SAA7133_I2S_AUDIO_CONTROL               0x591
 /* ------------------------------------------------------------------ */
 /*
  * Local variables:
diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Mon Jun 09 11:59:=
05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-tvaudio.c	Tue Jun 10 20:33:=
00 2008 +1000
@@ -929,23 +929,32 @@ void saa7134_enable_i2s(struct saa7134_d
 	if (!card_is_empress(dev))
 		return;
=20
-	switch (dev->board) {
-	case SAA7134_BOARD_BEHOLD_M6:
-	    /* configure GPIO for out audio */
-	    saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x0E000000, 0x00000000);
-	    /* Set I2S format  */
-	    saa_writeb(SAA7134_I2S_AUDIO_CONTROL,  0x00);
+	if (dev->pci->device =3D=3D PCI_DEVICE_ID_PHILIPS_SAA7130)
+		return;
+
+	/* configure GPIO for out */
+	saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x0E000000, 0x00000000);
+
+	switch (dev->pci->device) {
+	case PCI_DEVICE_ID_PHILIPS_SAA7133:
+	case PCI_DEVICE_ID_PHILIPS_SAA7135:
+	    /* Set I2S format (SONY) =C2=A0*/
+	    saa_writeb(SAA7133_I2S_AUDIO_CONTROL, 0x00);
 	    /* Start I2S */
-	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x11);
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT, 0x11);
 	    break;
+
+	case PCI_DEVICE_ID_PHILIPS_SAA7134:
+	    i2s_format =3D (dev->input->amux =3D=3D TV) ? 0x00 : 0x01;
+
+	    /* enable I2S audio output for the mpeg encoder */
+	    saa_writeb(SAA7134_I2S_OUTPUT_SELECT, 0x80);
+	    saa_writeb(SAA7134_I2S_OUTPUT_FORMAT, i2s_format);
+	    saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,  0x0F);
+	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,  0x01);
+
 	default:
-	    i2s_format =3D (dev->input->amux =3D=3D TV) ? 0x00 : 0x01;
-
-	    /* enable I2S audio output for the mpeg encoder */
-	    saa_writeb(SAA7134_I2S_OUTPUT_SELECT,  0x80);
-	    saa_writeb(SAA7134_I2S_OUTPUT_FORMAT,  i2s_format);
-	    saa_writeb(SAA7134_I2S_OUTPUT_LEVEL,   0x0F);
-	    saa_writeb(SAA7134_I2S_AUDIO_OUTPUT,   0x01);
+	    break;
 	}
 }
=20
diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Mon Jun 09 11:59:05=
 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Jun 10 19:49:58=
 2008 +1000
@@ -2469,13 +2469,14 @@ int saa7134_videoport_init(struct saa713
 	int vo =3D saa7134_boards[dev->board].video_out;
 	int video_reg;
 	unsigned int vid_port_opts =3D saa7134_boards[dev->board].vid_port_opts;
+
+	/* Configure videoport */
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL0, video_out[vo][0]);
 	video_reg =3D video_out[vo][1];
 	if (vid_port_opts & SET_T_CODE_POLARITY_NON_INVERTED)
 		video_reg &=3D ~VP_T_CODE_P_INVERTED;
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL1, video_reg);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL2, video_out[vo][2]);
-	saa_writeb(SAA7134_VIDEO_PORT_CTRL3, video_out[vo][3]);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL4, video_out[vo][4]);
 	video_reg =3D video_out[vo][5];
 	if (vid_port_opts & SET_CLOCK_NOT_DELAYED)
@@ -2491,6 +2492,9 @@ int saa7134_videoport_init(struct saa713
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL6, video_reg);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL7, video_out[vo][7]);
 	saa_writeb(SAA7134_VIDEO_PORT_CTRL8, video_out[vo][8]);
+
+	/* Start videoport */
+	saa_writeb(SAA7134_VIDEO_PORT_CTRL3, video_out[vo][3]);
=20
 	return 0;
 }

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/sSAW3NKqUQf+VxxD.rrbf/1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/sSAW3NKqUQf+VxxD.rrbf/1--
