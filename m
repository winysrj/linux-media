Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:31503 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbZI0KSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2009 06:18:01 -0400
Received: by fg-out-1718.google.com with SMTP id 22so521027fge.1
        for <linux-media@vger.kernel.org>; Sun, 27 Sep 2009 03:18:04 -0700 (PDT)
Date: Sun, 27 Sep 2009 12:17:50 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
Message-ID: <20090927101750.GA29816@zverina>
References: <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
 <20090922091235.GA10335@zverina>
 <829197380909221647p33236306ked2137a35707646d@mail.gmail.com>
 <20090925172209.GA10054@zverina>
 <829197380909251041i637a0790g10cc4b82a791f695@mail.gmail.com>
 <20090925182213.GA6941@zverina>
 <20090925221015.GA21295@zverina>
 <829197380909261359l22588d31v6fcc2cef40b12acd@mail.gmail.com>
 <20090927002339.GA23032@zverina>
 <829197380909261833uc08f661vff2695e2986b672d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <829197380909261833uc08f661vff2695e2986b672d@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.09.09 21:33, Devin Heitmueller wrote:
> On Sat, Sep 26, 2009 at 8:23 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> > On 26.09.09 16:59, Devin Heitmueller wrote:
> >> On Fri, Sep 25, 2009 at 6:10 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> >> > Alright, success!!!
> >> >
> >> > Since it seems everything for this tuner is set up the same as for the
> >> > Hauppauge WinTV HVR 900, I figured let's set things up *exactly* the
> >> > same. So, like it's there for the Hauppauge, I added .mts_firmware = 1
> >> > to the definition of the hybrid XS em2882. And well, working TV audio!!
> >> >
> >> >
> >> > dmesg output this time:
> >> >
> >> > xc2028 4-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
> >> > MTS (4), id 00000000000000ff:
> >> > xc2028 4-0061: Loading firmware for type=MTS (4), id 0000000100000007.
> >> >
> >> >
> >> > So now with the attached patch, everything (analog, digital, remote)
> >> > works!
> >> >
> >> > Regards,
> >> > Uroš
> >> >
> >>
> >> Hello Uros,
> >>
> >> Please test out the following tree, which has all the relevant fixes
> >> (enabling dvb, your audio fix, proper gpio setting, etc).
> >>
> >> http://kernellabs.com/hg/~dheitmueller/misc-fixes2/
> >>
> >> If you have any trouble, please let me know.  Otherwise I would like
> >> to issue a PULL request for this tree.
> >
> >
> > Hi,
> >
> > Your tree does not work, no audio. I quickly found the problem though:
> > gpio is set to default_analog, but it needs to be set to
> > hauppauge_wintv_hvr_900_analog. So I guess treating the EM2880 and
> > EM2882 as the same will not work, because they require different gpio
> > settings.
> >
> > Regards,
> > Uroš
> 
> Hmm..  Interesting.  That does make me wonder whether the GPIOs are
> setup for audio properly on the em2880 version of the profile, or
> whether the user in question just never tested it.  I'll have to go
> back and check the USB trace.
> 
> Nonetheless, I'll just check in your version of the patch, and scrap
> my version entirely for now.  Could you please add your SOB to the
> patch?
> 
> Thanks,
> 
> Devin

Ok, here we go...


Make analog audio, dvb and the remote work on a Terratec Cinergy Hybrid 
XS (em2882).

Signed-off-by: Uroš Vampl <mobile.leecher@gmail.com>


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
