Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:55939 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab0DOUV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 16:21:56 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2982736fgg.1
        for <linux-media@vger.kernel.org>; Thu, 15 Apr 2010 13:21:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BC19294.4010200@tvdr.de>
References: <4BC19294.4010200@tvdr.de>
Date: Fri, 16 Apr 2010 00:21:54 +0400
Message-ID: <s2n1a297b361004151321rb51b5225q79842aac2964371b@mail.gmail.com>
Subject: Re: [PATCH] Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable
	DVB devices
From: Manu Abraham <abraham.manu@gmail.com>
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Klaus,

On Sun, Apr 11, 2010 at 1:12 PM, Klaus Schmidinger
<Klaus.Schmidinger@tvdr.de> wrote:
> The enum fe_caps provides flags that allow an application to detect
> whether a device is capable of handling various modulation types etc.
> A flag for detecting PSK_8, however, is missing.
> This patch adds the flag FE_CAN_PSK_8 to frontend.h and implements
> it for the gp8psk-fe.c and cx24116.c driver (apparently the only ones
> with PSK_8). Only the gp8psk-fe.c has been explicitly tested, though.


The FE_CAN_PSK_8 is a misnomer. In fact what you are looking for is
FE_CAN_TURBO_FEC
FE_CAN_8PSK will be matched by any DVB-S2 capable frontend, so that
name is very likely to cause a very large confusion.

Another thing I am not entirely sure though ... The cx24116 requires a
separate firmware and maybe some necessary code changes (?) for Turbo
FEC to be supported, so I wonder whether applying the flag to the
cx24116 driver would be any relevant....

With regards to the Genpix driver, i guess the flag would be necessary.

> Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
> Tested-by: Derek Kelly <user.vdr@gmail.com>

Other than for the naming of the Flag (which i suggest strongly to
update the patch) and the application to the cx24116 driver, it looks
appropriate;

Acked-by: Manu Abraham <manu@linuxtv.org>




>
>
> --- linux/include/linux/dvb/frontend.h.001      2010-04-05 16:13:08.000000000 +0200
> +++ linux/include/linux/dvb/frontend.h  2010-04-10 12:08:47.000000000 +0200
> @@ -62,6 +62,7 @@
>        FE_CAN_8VSB                     = 0x200000,
>        FE_CAN_16VSB                    = 0x400000,
>        FE_HAS_EXTENDED_CAPS            = 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
> +       FE_CAN_PSK_8                    = 0x8000000,  /* frontend supports "8psk modulation" */
>        FE_CAN_2G_MODULATION            = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
>        FE_NEEDS_BENDING                = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
>        FE_CAN_RECOVER                  = 0x40000000, /* frontend can recover from a cable unplug automatically */
> --- linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c.001     2010-04-05 16:13:08.000000000 +0200
> +++ linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c 2010-04-10 12:18:37.000000000 +0200
> @@ -349,7 +349,7 @@
>                         * FE_CAN_QAM_16 is for compatibility
>                         * (Myth incorrectly detects Turbo-QPSK as plain QAM-16)
>                         */
> -                       FE_CAN_QPSK | FE_CAN_QAM_16
> +                       FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_PSK_8
>        },
>
>        .release = gp8psk_fe_release,
> --- linux/drivers/media/dvb/frontends/cx24116.c.001     2010-04-05 16:13:08.000000000 +0200
> +++ linux/drivers/media/dvb/frontends/cx24116.c 2010-04-10 13:40:32.000000000 +0200
> @@ -1496,7 +1496,7 @@
>                        FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
>                        FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
>                        FE_CAN_2G_MODULATION |
> -                       FE_CAN_QPSK | FE_CAN_RECOVER
> +                       FE_CAN_QPSK | FE_CAN_RECOVER | FE_CAN_PSK_8
>        },
>
>        .release = cx24116_release,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
