Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35128 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbcGPQ0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 12:26:38 -0400
Received: by mail-qk0-f195.google.com with SMTP id q62so8759405qkf.2
        for <linux-media@vger.kernel.org>; Sat, 16 Jul 2016 09:26:37 -0700 (PDT)
Received: from mail-qk0-f171.google.com (mail-qk0-f171.google.com. [209.85.220.171])
        by smtp.gmail.com with ESMTPSA id 23sm2469594qki.1.2016.07.16.09.26.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Jul 2016 09:26:36 -0700 (PDT)
Received: by mail-qk0-f171.google.com with SMTP id o67so126352298qke.1
        for <linux-media@vger.kernel.org>; Sat, 16 Jul 2016 09:26:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1451935971-31402-1-git-send-email-p.zabel@pengutronix.de>
References: <1451935971-31402-1-git-send-email-p.zabel@pengutronix.de>
From: Olli Salonen <olli.salonen@iki.fi>
Date: Sat, 16 Jul 2016 18:26:35 +0200
Message-ID: <CAAZRmGz5vS8vMBEQeMo6BS0XijoCj655jha5vCsiy2P8TcgSoQ@mail.gmail.com>
Subject: Re: [PATCH] [media] dw2102: Add support for Terratec Cinergy S2 USB BOX
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Benjamin Larsson <benjamin@southpole.se>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Christian Zippel <namerp@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

It seems Philipp added the support for this device in dw2102 driver
and Benjamin did that for the dvbsky driver a bit earlier.

# grep -i 0ccdp0105 /lib/modules/$(uname -r)/modules.alias
alias usb:v0CCDp0105d*dc*dsc*dp*ic*isc*ip*in* dvb_usb_dvbsky
alias usb:v0CCDp0105d*dc*dsc*dp*ic*isc*ip*in* dvb_usb_dw2102

Any suggestions on how to resolve this conflict?

Cheers,
-olli

On 4 January 2016 at 20:32, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> The Terratec Cinergy S2 USB BOX uses a Montage M88TS2022 tuner
> and a M88DS3103 demodulator, same as Technotrend TT-connect S2-4600.
> This patch adds the missing USB Product ID to make it work.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/usb/dvb-usb/dw2102.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> index 14ef25d..9d18801 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -1688,6 +1688,7 @@ enum dw2102_table_entry {
>         TECHNOTREND_S2_4600,
>         TEVII_S482_1,
>         TEVII_S482_2,
> +       TERRATEC_CINERGY_S2_BOX,
>  };
>
>  static struct usb_device_id dw2102_table[] = {
> @@ -1715,6 +1716,7 @@ static struct usb_device_id dw2102_table[] = {
>                 USB_PID_TECHNOTREND_CONNECT_S2_4600)},
>         [TEVII_S482_1] = {USB_DEVICE(0x9022, 0xd483)},
>         [TEVII_S482_2] = {USB_DEVICE(0x9022, 0xd484)},
> +       [TERRATEC_CINERGY_S2_BOX] = {USB_DEVICE(USB_VID_TERRATEC, 0x0105)},
>         { }
>  };
>
> @@ -2232,7 +2234,7 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
>                 } },
>                 }
>         },
> -       .num_device_descs = 3,
> +       .num_device_descs = 4,
>         .devices = {
>                 { "TechnoTrend TT-connect S2-4600",
>                         { &dw2102_table[TECHNOTREND_S2_4600], NULL },
> @@ -2246,6 +2248,10 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
>                         { &dw2102_table[TEVII_S482_2], NULL },
>                         { NULL },
>                 },
> +               { "Terratec Cinergy S2 USB BOX",
> +                       { &dw2102_table[TERRATEC_CINERGY_S2_BOX], NULL },
> +                       { NULL },
> +               },
>         }
>  };
>
> --
> 2.6.2
>
