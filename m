Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:55355 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZEABHT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 21:07:19 -0400
Received: by gxk10 with SMTP id 10so4431668gxk.13
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 18:07:18 -0700 (PDT)
Message-Id: <B2D200D8-22B0-418C-B577-C036C1469521@gmail.com>
From: Britney Fransen <britney.fransen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: [PATCH] Add QAM64 support for hvr-950q (au8522)
Date: Thu, 30 Apr 2009 20:07:15 -0500
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have updated the patch from http://www.linuxtv.org/pipermail/linux-dvb/2008-December/030786.html 
  to add QAM64 support to the HVR-950Q.  It is working well for me.   
What needs to happen to get this included in v4l-dvb?

Thanks,
Britney

--- linux/drivers/media/dvb/frontends/au8522_dig.c.orig	2009-04-30  
14:27:14.417542844 -0500
+++ linux/drivers/media/dvb/frontends/au8522_dig.c	2009-04-30  
16:57:37.439472504 -0500
@@ -367,11 +367,90 @@ static struct {
  	{ 0x8231, 0x13 },
  };

-/* QAM Modulation table */
+/* QAM64 Modulation table */
  static struct {
  	u16 reg;
  	u16 data;
-} QAM_mod_tab[] = {
+} QAM64_mod_tab[] = {
+        { 0x80a3, 0x09 },
+        { 0x80a4, 0x00 },
+        { 0x8081, 0xc4 },
+        { 0x80a5, 0x40 },
+        { 0x80aa, 0x77 },
+        { 0x80ad, 0x77 },
+        { 0x80a6, 0x67 },
+        { 0x8262, 0x20 },
+        { 0x821c, 0x30 },
+        { 0x80b8, 0x3e },
+        { 0x80b9, 0xf0 },
+        { 0x80ba, 0x01 },
+        { 0x80bb, 0x18 },
+        { 0x80bc, 0x50 },
+        { 0x80bd, 0x00 },
+        { 0x80be, 0xea },
+        { 0x80bf, 0xef },
+        { 0x80c0, 0xfc },
+        { 0x80c1, 0xbd },
+        { 0x80c2, 0x1f },
+        { 0x80c3, 0xfc },
+        { 0x80c4, 0xdd },
+        { 0x80c5, 0xaf },
+        { 0x80c6, 0x00 },
+        { 0x80c7, 0x38 },
+        { 0x80c8, 0x30 },
+        { 0x80c9, 0x05 },
+        { 0x80ca, 0x4a },
+        { 0x80cb, 0xd0 },
+        { 0x80cc, 0x01 },
+        { 0x80cd, 0xd9 },
+        { 0x80ce, 0x6f },
+        { 0x80cf, 0xf9 },
+        { 0x80d0, 0x70 },
+        { 0x80d1, 0xdf },
+        { 0x80d2, 0xf7 },
+        { 0x80d3, 0xc2 },
+        { 0x80d4, 0xdf },
+        { 0x80d5, 0x02 },
+        { 0x80d6, 0x9a },
+        { 0x80d7, 0xd0 },
+        { 0x8250, 0x0d },
+        { 0x8251, 0xcd },
+        { 0x8252, 0xe0 },
+        { 0x8253, 0x05 },
+        { 0x8254, 0xa7 },
+        { 0x8255, 0xff },
+        { 0x8256, 0xed },
+        { 0x8257, 0x5b },
+        { 0x8258, 0xae },
+        { 0x8259, 0xe6 },
+        { 0x825a, 0x3d },
+        { 0x825b, 0x0f },
+        { 0x825c, 0x0d },
+        { 0x825d, 0xea },
+        { 0x825e, 0xf2 },
+        { 0x825f, 0x51 },
+        { 0x8260, 0xf5 },
+        { 0x8261, 0x06 },
+        { 0x821a, 0x00 },
+        { 0x8546, 0x40 },
+        { 0x8210, 0xc7 },
+        { 0x8211, 0xaa },
+        { 0x8212, 0xab },
+        { 0x8213, 0x02 },
+        { 0x8502, 0x00 },
+        { 0x8121, 0x04 },
+        { 0x8122, 0x04 },
+        { 0x852e, 0x10 },
+        { 0x80a4, 0xca },
+        { 0x80a7, 0x40 },
+        { 0x8526, 0x01 },
+};
+
+/* QAM256 Modulation table */
+static struct {
+       u16 reg;
+       u16 data;
+} QAM256_mod_tab[] = {
  	{ 0x80a3, 0x09 },
  	{ 0x80a4, 0x00 },
  	{ 0x8081, 0xc4 },
@@ -464,12 +543,19 @@ static int au8522_enable_modulation(stru
  		au8522_set_if(fe, state->config->vsb_if);
  		break;
  	case QAM_64:
+                dprintk("%s() QAM 64\n", __func__);
+                for (i = 0; i < ARRAY_SIZE(QAM64_mod_tab); i++)
+                        au8522_writereg(state,
+                                QAM64_mod_tab[i].reg,
+                                QAM64_mod_tab[i].data);
+                au8522_set_if(fe, state->config->qam_if);
+                break;
  	case QAM_256:
-		dprintk("%s() QAM 64/256\n", __func__);
-		for (i = 0; i < ARRAY_SIZE(QAM_mod_tab); i++)
+                dprintk("%s() QAM 256\n", __func__);
+                for (i = 0; i < ARRAY_SIZE(QAM256_mod_tab); i++)
  			au8522_writereg(state,
-				QAM_mod_tab[i].reg,
-				QAM_mod_tab[i].data);
+				QAM256_mod_tab[i].reg,
+				QAM256_mod_tab[i].data);
  		au8522_set_if(fe, state->config->qam_if);
  		break;
  	default:

