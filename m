Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:54038 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1GDMSY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 08:18:24 -0400
Message-ID: <4E11AF6D.4070502@usa.net>
Date: Mon, 04 Jul 2011 14:17:49 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ralph Metzler <rmetzler@digitaldevices.de>
Subject: Re: [PATCH 13/16] cxd2099: Update to latest version
References: <201107031831.20378@orion.escape-edv.de> <201107031900.59010@orion.escape-edv.de>
In-Reply-To: <201107031900.59010@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/07/2011 19:00, Oliver Endriss wrote:
> @@ -284,53 +313,84 @@ static int init(struct cxd *ci)
>  		CHK_ERROR(write_reg(ci, 0x08, 0x28));
>  		CHK_ERROR(write_reg(ci, 0x14, 0x20));
>  
> -		CHK_ERROR(write_reg(ci, 0x09, 0x4D)); /* Input Mode C, BYPass Serial, TIVAL = low, MSB */
> +		/* CHK_ERROR(write_reg(ci, 0x09, 0x4D));*/ /* Input Mode C, BYPass Serial, TIVAL = low, MSB */
>  		CHK_ERROR(write_reg(ci, 0x0A, 0xA7)); /* TOSTRT = 8, Mode B (gated clock), falling Edge, Serial, POL=HIGH, MSB */
>  
> -		/* Sync detector */
>  		CHK_ERROR(write_reg(ci, 0x0B, 0x33));
>  		CHK_ERROR(write_reg(ci, 0x0C, 0x33));
>  
>  		CHK_ERROR(write_regm(ci, 0x14, 0x00, 0x0F));
>  		CHK_ERROR(write_reg(ci, 0x15, ci->clk_reg_b));
>  		CHK_ERROR(write_regm(ci, 0x16, 0x00, 0x0F));
> -		CHK_ERROR(write_reg(ci, 0x17, ci->clk_reg_f));
> +		CHK_ERROR(write_reg(ci, 0x17,ci->clk_reg_f));
>  
> -		CHK_ERROR(write_reg(ci, 0x20, 0x28)); /* Integer Divider, Falling Edge, Internal Sync, */
> -		CHK_ERROR(write_reg(ci, 0x21, 0x00)); /* MCLKI = TICLK/8 */
> -		CHK_ERROR(write_reg(ci, 0x22, 0x07)); /* MCLKI = TICLK/8 */
> +		if (ci->cfg.clock_mode) {
> +			if (ci->cfg.polarity) {
> +				CHK_ERROR(write_reg(ci, 0x09, 0x6f));
> +			} else {
> +				CHK_ERROR(write_reg(ci, 0x09, 0x6d));
> +			}
> +			CHK_ERROR(write_reg(ci, 0x20, 0x68));
> +			CHK_ERROR(write_reg(ci, 0x21, 0x00));
> +			CHK_ERROR(write_reg(ci, 0x22, 0x02));

When clock_mode = 1, you set MKCLI to 9MHz. Comments in this code would
be really nice. Used by ddbrige it seems.

> +		} else {
> +			if (ci->cfg.polarity) {
> +				CHK_ERROR(write_reg(ci, 0x09, 0x4f));
> +			} else {
> +				CHK_ERROR(write_reg(ci, 0x09, 0x4d));
> +			}
>  
> +			CHK_ERROR(write_reg(ci, 0x20, 0x28));
> +			CHK_ERROR(write_reg(ci, 0x21, 0x00));
> +			CHK_ERROR(write_reg(ci, 0x22, 0x07));
> +		}

When clock_mode = 0, input ts is in serial mode C, MCLKI = TICLK / 8 ;
why not set register 0x20 to 0x8 only ? Also, no need to set 0x21 nor
0x22 which are only for serial input mode D. And only used by ngene it
seems. Is TICLK equal to the bitrate variable (62000000) ? If yes, then
MCLKI can only reach a value of ~7,8MHz, which is not the maximum speed
of CAMs. Is this on purpose ? Ngene chip limitation ?
