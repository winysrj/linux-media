Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33296 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZKITNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 14:13:15 -0500
Received: by gxk26 with SMTP id 26so2366357gxk.1
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 11:13:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <303c92ca0911091106s72910abdmb0df8c3fa7a4cf1b@mail.gmail.com>
References: <303c92ca0911091106s72910abdmb0df8c3fa7a4cf1b@mail.gmail.com>
Date: Mon, 9 Nov 2009 20:13:20 +0100
Message-ID: <303c92ca0911091113j5f181335w45518676330c5f32@mail.gmail.com>
Subject: Terratec Cinergy Hybrid T USB XS FM and 2.6.31 : no more support ?
From: Florent nouvellon <flonouvellon@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Terratec Cinergy Hybrid T USB XS FM is fully supported by em28xx-new
project, but em28xx-new project is no more supported and not compatible with
kernel 2.6.31.
Is this hardware still supported ?


ID is 0ccd:0072 and hardware was mapped in em28xx-new like this :

   [EM2883_BOARD_TERRATEC_HYBRID_
XS_FM] = {
       .name         = "Terratec Hybrid XS FM (em2883)",
       .em_type      = EM2883,
       .vchannels    = 3,
       .norm         = V4L2_STD_PAL_BG,
       .has_radio    = 1,
       .has_inttuner = 1,
#if 0
       .powersaving  = 1,
#endif
       .tuner_type   = TUNER_XCEIVE_XC5000,
       .decoder      = EM28XX_CX25843,
       .ir_keytab    = ir_codes_em_terratec2,
       .ir_getkey    = em2880_get_key_terratec,
       .dev_modes    = EM28XX_VIDEO | EM28XX_VBI | EM28XX_DVBT |
EM28XX_AUDIO | EM28XX_RADIO,
       .input          = {{
           .type     = EM28XX_VMUX_TELEVISION,
           .vmux     = CX25843_TELEVISION,
           .amux     = 0,
       }, {
           .type     = EM28XX_VMUX_COMPOSITE1,
           .vmux     = CX25843_COMPOSITE1,
           .amux     = 4,
       }, {
           .type     = EM28XX_VMUX_SVIDEO,
           .vmux     = CX25843_SVIDEO,
           .amux     = 5,
       } },
       .tvnorms    = EETI_XC5000_DEFAULT_ANALOG,
       .dvbnorms    = EETI_XC5000_DEFAULT_DVBT,
       .fmnorms    = EETI_XC5000_DEFAULT_FM,
   },
