Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40183 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZIYWKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2009 18:10:24 -0400
Received: by fxm18 with SMTP id 18so2545822fxm.17
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2009 15:10:26 -0700 (PDT)
Date: Sat, 26 Sep 2009 00:10:15 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
Message-ID: <20090925221015.GA21295@zverina>
References: <20090913193118.GA12659@zverina>
 <20090921204418.GA19119@zverina>
 <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
 <20090921221505.GA5187@zverina>
 <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
 <20090922091235.GA10335@zverina>
 <829197380909221647p33236306ked2137a35707646d@mail.gmail.com>
 <20090925172209.GA10054@zverina>
 <829197380909251041i637a0790g10cc4b82a791f695@mail.gmail.com>
 <20090925182213.GA6941@zverina>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090925182213.GA6941@zverina>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 25.09.09 20:22, Uros Vampl wrote:
> On 25.09.09 13:41, Devin Heitmueller wrote:
> > >> Interesting.  Have you tried the A/V inputs (as opposed to the tuner)?
> > >>  That might help us identify whether it's an issue with the xc3028
> > >> tuner chip extracting the audio carrier or whether it's something
> > >> about the way we are programming the emp202.
> > >
> > >
> > > Hello,
> > >
> > > That was a great idea. Tested with a Playstation2 and audio is ok. It's
> > > just TV input that has a problem. So I guess that means the issue is
> > > with the tuner chip. That's progress. Where do I go from here?
> > 
> > Ok, that's good to hear.  What video standard specifically are you
> > using?  I suspect the core issue is that the application is not
> > properly specifying the video standard, which results in the xc3028
> > improperly decoding the audio (the xc3028 needs to know exactly what
> > standard is being used).
> 
> I'm from Slovenia, which is a PAL-B country. Tvtime can be set to either 
> PAL-BG, PAL-DK or PAL-I, makes no difference. MPlayer has a whole bunch 
> of options (PAL, PAL-BG, etc...), but again none of them make a 
> difference.
> 
> When the app is started, this appears in dmesg:
> 
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
> (0), id 00000000000000ff:
> xc2028 4-0061: Loading firmware for type=(0), id 0000000100000007.
> xc2028 4-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id 0000000f00000007.


Alright, success!!!

Since it seems everything for this tuner is set up the same as for the 
Hauppauge WinTV HVR 900, I figured let's set things up *exactly* the 
same. So, like it's there for the Hauppauge, I added .mts_firmware = 1 
to the definition of the hybrid XS em2882. And well, working TV audio!!


dmesg output this time:

xc2028 4-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
MTS (4), id 00000000000000ff:
xc2028 4-0061: Loading firmware for type=MTS (4), id 0000000100000007.


So now with the attached patch, everything (analog, digital, remote) 
works!

Regards,
Uroš

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hybrid_xs_em2882.diff"

diff -r 29e4ba1a09bc linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Sep 19 09:45:22 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Sep 26 00:06:37 2009 +0200
@@ -1441,11 +1441,12 @@
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
+		.mts_firmware = 1,
 		.decoder      = EM28XX_TVP5150,
-#if 0 /* FIXME: add an entry at em28xx-dvb */
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
-#endif
+		.ir_codes     = &ir_codes_terratec_cinergy_xs_table,
+		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -2119,6 +2120,7 @@
 	switch (dev->model) {
 	case EM2880_BOARD_EMPIRE_DUAL_TV:
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
+	case EM2882_BOARD_TERRATEC_HYBRID_XS:
 		ctl->demod = XC3028_FE_ZARLINK456;
 		break;
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
diff -r 29e4ba1a09bc linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Sat Sep 19 09:45:22 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Sat Sep 26 00:06:37 2009 +0200
@@ -494,6 +494,7 @@
 		}
 		break;
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
+	case EM2882_BOARD_TERRATEC_HYBRID_XS:
 	case EM2880_BOARD_EMPIRE_DUAL_TV:
 		dvb->frontend = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_xc3028_no_i2c_gate,

--UugvWAfsgieZRqgk--
