Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:56495 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZEBDRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 23:17:44 -0400
Received: by ewy24 with SMTP id 24so2719626ewy.37
        for <linux-media@vger.kernel.org>; Fri, 01 May 2009 20:17:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0904302216q4ffbdf24yb5d73956addfb8f6@mail.gmail.com>
References: <B2D200D8-22B0-418C-B577-C036C1469521@gmail.com>
	 <1241140865.3210.108.camel@palomino.walls.org>
	 <303162d70904301855xd138162s43c550637436919a@mail.gmail.com>
	 <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
	 <412bdbff0904302216q4ffbdf24yb5d73956addfb8f6@mail.gmail.com>
Date: Fri, 1 May 2009 21:17:43 -0600
Message-ID: <303162d70905012017x2f6a2ae7n4600ecb5bb26be89@mail.gmail.com>
Subject: Re: [PATCH] Add QAM64 support for hvr-950q (au8522)
From: Frank Dischner <phaedrus961@googlemail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Britney Fransen <britney.fransen@gmail.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's the updated patch with the requested changes.

Frank

Signed-off-by: Frank Dischner <phaedrus961@gmail.com>

diff -urN v4l-dvb/linux/drivers/media/dvb/frontends/au8522_dig.c
v4l-dvb.new/linux/drivers/media/dvb/frontends/au8522_dig.c
--- v4l-dvb/linux/drivers/media/dvb/frontends/au8522_dig.c	2009-05-01
20:14:47.000000000 -0600
+++ v4l-dvb.new/linux/drivers/media/dvb/frontends/au8522_dig.c	2009-05-01
20:19:25.000000000 -0600
@@ -367,11 +367,90 @@
 	{ 0x8231, 0x13 },
 };

-/* QAM Modulation table */
+/* QAM64 Modulation table */
 static struct {
 	u16 reg;
 	u16 data;
-} QAM_mod_tab[] = {
+} QAM64_mod_tab[] = {
+	{ 0x00a3, 0x09 },
+	{ 0x00a4, 0x00 },
+	{ 0x0081, 0xc4 },
+	{ 0x00a5, 0x40 },
+	{ 0x00aa, 0x77 },
+	{ 0x00ad, 0x77 },
+	{ 0x00a6, 0x67 },
+	{ 0x0262, 0x20 },
+	{ 0x021c, 0x30 },
+	{ 0x00b8, 0x3e },
+	{ 0x00b9, 0xf0 },
+	{ 0x00ba, 0x01 },
+	{ 0x00bb, 0x18 },
+	{ 0x00bc, 0x50 },
+	{ 0x00bd, 0x00 },
+	{ 0x00be, 0xea },
+	{ 0x00bf, 0xef },
+	{ 0x00c0, 0xfc },
+	{ 0x00c1, 0xbd },
+	{ 0x00c2, 0x1f },
+	{ 0x00c3, 0xfc },
+	{ 0x00c4, 0xdd },
+	{ 0x00c5, 0xaf },
+	{ 0x00c6, 0x00 },
+	{ 0x00c7, 0x38 },
+	{ 0x00c8, 0x30 },
+	{ 0x00c9, 0x05 },
+	{ 0x00ca, 0x4a },
+	{ 0x00cb, 0xd0 },
+	{ 0x00cc, 0x01 },
+	{ 0x00cd, 0xd9 },
+	{ 0x00ce, 0x6f },
+	{ 0x00cf, 0xf9 },
+	{ 0x00d0, 0x70 },
+	{ 0x00d1, 0xdf },
+	{ 0x00d2, 0xf7 },
+	{ 0x00d3, 0xc2 },
+	{ 0x00d4, 0xdf },
+	{ 0x00d5, 0x02 },
+	{ 0x00d6, 0x9a },
+	{ 0x00d7, 0xd0 },
+	{ 0x0250, 0x0d },
+	{ 0x0251, 0xcd },
+	{ 0x0252, 0xe0 },
+	{ 0x0253, 0x05 },
+	{ 0x0254, 0xa7 },
+	{ 0x0255, 0xff },
+	{ 0x0256, 0xed },
+	{ 0x0257, 0x5b },
+	{ 0x0258, 0xae },
+	{ 0x0259, 0xe6 },
+	{ 0x025a, 0x3d },
+	{ 0x025b, 0x0f },
+	{ 0x025c, 0x0d },
+	{ 0x025d, 0xea },
+	{ 0x025e, 0xf2 },
+	{ 0x025f, 0x51 },
+	{ 0x0260, 0xf5 },
+	{ 0x0261, 0x06 },
+	{ 0x021a, 0x00 },
+	{ 0x0546, 0x40 },
+	{ 0x0210, 0xc7 },
+	{ 0x0211, 0xaa },
+	{ 0x0212, 0xab },
+	{ 0x0213, 0x02 },
+	{ 0x0502, 0x00 },
+	{ 0x0121, 0x04 },
+	{ 0x0122, 0x04 },
+	{ 0x052e, 0x10 },
+	{ 0x00a4, 0xca },
+	{ 0x00a7, 0x40 },
+	{ 0x0526, 0x01 },
+};
+
+/* QAM256 Modulation table */
+static struct {
+	u16 reg;
+	u16 data;
+} QAM256_mod_tab[] = {
 	{ 0x80a3, 0x09 },
 	{ 0x80a4, 0x00 },
 	{ 0x8081, 0xc4 },
@@ -464,12 +543,19 @@
 		au8522_set_if(fe, state->config->vsb_if);
 		break;
 	case QAM_64:
+		dprintk("%s() QAM 64\n", __func__);
+		for (i = 0; i < ARRAY_SIZE(QAM64_mod_tab); i++)
+			au8522_writereg(state,
+				QAM64_mod_tab[i].reg,
+				QAM64_mod_tab[i].data);
+		au8522_set_if(fe, state->config->qam_if);
+		break;
 	case QAM_256:
-		dprintk("%s() QAM 64/256\n", __func__);
-		for (i = 0; i < ARRAY_SIZE(QAM_mod_tab); i++)
+		dprintk("%s() QAM 256\n", __func__);
+		for (i = 0; i < ARRAY_SIZE(QAM256_mod_tab); i++)
 			au8522_writereg(state,
-				QAM_mod_tab[i].reg,
-				QAM_mod_tab[i].data);
+				QAM256_mod_tab[i].reg,
+				QAM256_mod_tab[i].data);
 		au8522_set_if(fe, state->config->qam_if);
 		break;
 	default:
