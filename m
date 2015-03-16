Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42287 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525AbbCPVPB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:15:01 -0400
Message-ID: <550747D1.6080006@iki.fi>
Date: Mon, 16 Mar 2015 23:14:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/10] r820t: add DVBC profile in sysfreq_sel
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> This will make the Astrometa DVB-T/T2/C usb stick be able to pick up
> muxes around 290-314 MHz.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Looks correct. I added initially DVB-C support for that driver, but I 
forget to add this. After looking the driver I realized there was 2 
places to add standard specific configurations - and I added only one place.
I will apply that to my tree.

regards
Antti


> ---
>   drivers/media/tuners/r820t.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
> index 8e040cf..639c220 100644
> --- a/drivers/media/tuners/r820t.c
> +++ b/drivers/media/tuners/r820t.c
> @@ -775,6 +775,19 @@ static int r820t_sysfreq_sel(struct r820t_priv *priv, u32 freq,
>   		div_buf_cur = 0x30;	/* 11, 150u */
>   		filter_cur = 0x40;	/* 10, low */
>   		break;
> +	case SYS_DVBC_ANNEX_A:
> +		mixer_top = 0x24;       /* mixer top:13 , top-1, low-discharge */
> +		lna_top = 0xe5;
> +		lna_vth_l = 0x62;
> +		mixer_vth_l = 0x75;
> +		air_cable1_in = 0x60;
> +		cable2_in = 0x00;
> +		pre_dect = 0x40;
> +		lna_discharge = 14;
> +		cp_cur = 0x38;          /* 111, auto */
> +		div_buf_cur = 0x30;     /* 11, 150u */
> +		filter_cur = 0x40;      /* 10, low */
> +		break;
>   	default: /* DVB-T 8M */
>   		mixer_top = 0x24;	/* mixer top:13 , top-1, low-discharge */
>   		lna_top = 0xe5;		/* detect bw 3, lna top:4, predet top:2 */
>

-- 
http://palosaari.fi/
