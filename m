Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34058 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbbDXGb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 02:31:57 -0400
Received: by wicmx19 with SMTP id mx19so27644925wic.1
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 23:31:56 -0700 (PDT)
Message-ID: <5539E35B.2080603@gmail.com>
Date: Fri, 24 Apr 2015 08:31:55 +0200
From: =?windows-1252?Q?Tycho_L=FCrsen?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/12] dvbsky: use si2168 config option ts_clock_gapped
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi> <1429823471-21835-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,
in saa716x_budget.c I've also got (for TBS6285)

     si2168_config.i2c_adapter = &i2cadapter;
     si2168_config.fe = &adapter->fe;
     si2168_config.ts_mode = SI2168_TS_SERIAL;
     memset(&info, 0, sizeof(struct i2c_board_info));

Should I just add it like this?

     si2168_config.ts_mode = SI2168_TS_SERIAL;
     si2168_config.ts_clock_gapped = true;
     memset(&info, 0, sizeof(struct i2c_board_info));

Kind regards,
Tycho.

Op 23-04-15 om 23:11 schreef Olli Salonen:
> Change the dvbsky driver to support gapped clock instead of the current
> hack.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/usb/dvb-usb-v2/dvbsky.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> index cdf59bc..0f73b1d 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> @@ -615,7 +615,8 @@ static int dvbsky_t330_attach(struct dvb_usb_adapter *adap)
>   	memset(&si2168_config, 0, sizeof(si2168_config));
>   	si2168_config.i2c_adapter = &i2c_adapter;
>   	si2168_config.fe = &adap->fe[0];
> -	si2168_config.ts_mode = SI2168_TS_PARALLEL | 0x40;
> +	si2168_config.ts_mode = SI2168_TS_PARALLEL;
> +	si2168_config.ts_clock_gapped = true;
>   	memset(&info, 0, sizeof(struct i2c_board_info));
>   	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
>   	info.addr = 0x64;

