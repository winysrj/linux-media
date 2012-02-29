Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:48966 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab2B2Ilo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Feb 2012 03:41:44 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id q1T8OTtm032236
	for <linux-media@vger.kernel.org>; Wed, 29 Feb 2012 09:24:29 +0100
Received: from [192.168.100.10] (hawk.tvdr.de [192.168.100.10])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id q1T8O0El018951
	for <linux-media@vger.kernel.org>; Wed, 29 Feb 2012 09:24:00 +0100
Message-ID: <4F4DE0A0.5060706@tvdr.de>
Date: Wed, 29 Feb 2012 09:24:00 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] [PATCH 2/2] stb0899: fixed reading of IF_AGC_GAIN
 register
References: <4F4D1FAC.5050703@gmx.de>
In-Reply-To: <4F4D1FAC.5050703@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> When reading IF_AGC_GAIN register a wrong value for the base address
> register was used (STB0899_DEMOD instead of STB0899_S2DEMOD). That
> lead to a wrong signal strength value on DVB-S2 transponders.
>
> Signed-off-by: Andreas Regel <andreas.regel@gmx.de>
> ---
>  drivers/media/dvb/frontends/stb0899_drv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
> index 4a58afc..a2e9eba 100644
> --- a/drivers/media/dvb/frontends/stb0899_drv.c
> +++ b/drivers/media/dvb/frontends/stb0899_drv.c
> @@ -983,7 +983,7 @@ static int stb0899_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
>          break;
>      case SYS_DVBS2:
>          if (internal->lock) {
> -            reg = STB0899_READ_S2REG(STB0899_DEMOD, IF_AGC_GAIN);
> +            reg = STB0899_READ_S2REG(STB0899_S2DEMOD, IF_AGC_GAIN);
>              val = STB0899_GETFIELD(IF_AGC_GAIN, reg);
>               *strength = stb0899_table_lookup(stb0899_dvbs2rf_tab, ARRAY_SIZE(stb0899_dvbs2rf_tab) - 1, val);

Acked-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
