Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4-c.eqx.gridhost.co.uk ([95.142.156.20]:39885 "EHLO
	mail4-b.eqx.gridhost.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752953AbcAGIdY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 03:33:24 -0500
Received: from [209.85.192.43] (helo=mail-qg0-f43.google.com)
	by mail4.eqx.gridhost.co.uk with esmtpsa (UNKNOWN:AES128-GCM-SHA256:128)
	(Exim 4.72)
	(envelope-from <olli.salonen@iki.fi>)
	id 1aH5zr-0003sr-25
	for linux-media@vger.kernel.org; Thu, 07 Jan 2016 08:32:39 +0000
Received: by mail-qg0-f43.google.com with SMTP id 6so243851137qgy.1
        for <linux-media@vger.kernel.org>; Thu, 07 Jan 2016 00:32:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452097591-20184-1-git-send-email-torbjorn.jansson@mbox200.swipnet.se>
References: <1452097591-20184-1-git-send-email-torbjorn.jansson@mbox200.swipnet.se>
Date: Thu, 7 Jan 2016 09:32:38 +0100
Message-ID: <CAAZRmGxgVxxDA2PchnmXYrCmi+3Y8Zc6Pu_J2A3CZGdz0=4F_Q@mail.gmail.com>
Subject: Re: [PATCH] dvb-usb-dvbsky: add new product id for TT CT2-4650 CI
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

On 6 January 2016 at 17:26, Torbjörn Jansson
<torbjorn.jansson@mbox200.swipnet.se> wrote:
> Add a new product id to dvb-usb-dvbsky for new version of TechnoTrend CT2-4650 CI
>
> Signed-off-by: Torbjörn Jansson <torbjorn.jansson@mbox200.swipnet.se>
> ---
>  drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
>  drivers/media/usb/dvb-usb-v2/dvbsky.c | 4 ++++
>  2 files changed, 5 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 1c1c298..a3761e9 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -247,6 +247,7 @@
>  #define USB_PID_TECHNOTREND_CONNECT_CT3650             0x300d
>  #define USB_PID_TECHNOTREND_CONNECT_S2_4600             0x3011
>  #define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI                0x3012
> +#define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI_2      0x3015
>  #define USB_PID_TECHNOTREND_TVSTICK_CT2_4400           0x3014
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY       0x005a
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2     0x0081
> diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> index 1dd9625..b4620b7 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> @@ -847,6 +847,10 @@ static const struct usb_device_id dvbsky_id_table[] = {
>                 USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI,
>                 &dvbsky_t680c_props, "TechnoTrend TT-connect CT2-4650 CI",
>                 RC_MAP_TT_1500) },
> +       { DVB_USB_DEVICE(USB_VID_TECHNOTREND,
> +               USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI_2,
> +               &dvbsky_t680c_props, "TechnoTrend TT-connect CT2-4650 CI v1.1",
> +               RC_MAP_TT_1500) },
>         { DVB_USB_DEVICE(USB_VID_TERRATEC,
>                 USB_PID_TERRATEC_H7_3,
>                 &dvbsky_t680c_props, "Terratec H7 Rev.4",
> --
> 2.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
