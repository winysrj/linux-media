Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37877 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab2CNRmC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 13:42:02 -0400
Received: by ghrr11 with SMTP id r11so2071053ghr.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 10:42:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com>
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com>
Date: Wed, 14 Mar 2012 14:42:01 -0300
Message-ID: <CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com>
Subject: Re: eMPIA EM2710 Webcam (em28xx) and LIRC
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

On Wed, Mar 14, 2012 at 8:28 AM, Rui Salvaterra <rsalvaterra@gmail.com> wrote:
> Hi, everyone.
>
> I apologise in advance for the noise if this is the wrong place to ask
> such questions. I have a couple of eMPIA EM2710 (Silvercrest) USB
> webcams which work quite well, except for the fact that most of LIRC

Exactly what module do you refer to? Could you just send a snippet
of dmesg when module is loaded?

> is unnecessarily loaded when the em28xx module loads. I suppose it
> shouldn't be necessary, since these are webcams and don't have any

Looking at source code, I noticed two things:
1. You have a module param named "disable-ir", perhaps you could
try to use this (do you know how?).
2. EM2710 board is defined like this:

                .name          = "EM2710/EM2750/EM2751 webcam grabber",
                .xclk          = EM28XX_XCLK_FREQUENCY_20MHZ,
                .tuner_type    = TUNER_ABSENT,
                .is_webcam     = 1,
                .input         = { {
                        .type     = EM28XX_VMUX_COMPOSITE1,
                        .vmux     = 0,
                        .amux     = EM28XX_AMUX_VIDEO,
                        .gpio     = silvercrest_reg_seq,
                } },

As opposed to:

                .name         = "Terratec Cinergy 250 USB",
                .tuner_type   = TUNER_LG_PAL_NEW_TAPC,
                .has_ir_i2c   = 1,
                .tda9887_conf = TDA9887_PRESENT,
                .decoder      = EM28XX_SAA711X,
                .input        = { {
                        .type     = EM28XX_VMUX_TELEVISION,
                        .vmux     = SAA7115_COMPOSITE2,
                        .amux     = EM28XX_AMUX_LINE_IN,
                }, {
                        .type     = EM28XX_VMUX_COMPOSITE1,
                        .vmux     = SAA7115_COMPOSITE0,
                        .amux     = EM28XX_AMUX_LINE_IN,
                }, {
                        .type     = EM28XX_VMUX_SVIDEO,
                        .vmux     = SAA7115_SVIDEO3,
                        .amux     = EM28XX_AMUX_LINE_IN,
                } },
        },

Noticed the lack of "has_ir_i2c" definition in the EM2710.

So I don't know how that module is being loaded. Probably I'm missing something.

Hope it helps,
Ezequiel.
