Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:17317 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3LCPD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 10:03:59 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX800JJNKIL7O10@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 10:03:58 -0500 (EST)
Date: Tue, 03 Dec 2013 13:03:53 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] af9033: fix broken I2C
Message-id: <20131203130353.04553996.m.chehab@samsung.com>
In-reply-to: <1385584128-2632-1-git-send-email-crope@iki.fi>
References: <1385584128-2632-1-git-send-email-crope@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Nov 2013 22:28:47 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Driver did not work anymore since I2C has gone broken due
> to recent commit:
> commit 37ebaf6891ee81687bb558e8375c0712d8264ed8
> [media] dvb-frontends: Don't use dynamic static allocation
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb-frontends/af9033.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
> index 30ee590..08de532 100644
> --- a/drivers/media/dvb-frontends/af9033.c
> +++ b/drivers/media/dvb-frontends/af9033.c
> @@ -171,7 +171,7 @@ static int af9033_wr_reg_val_tab(struct af9033_state *state,
>  		const struct reg_val *tab, int tab_len)
>  {
>  	int ret, i, j;
> -	u8 buf[MAX_XFER_SIZE];
> +	u8 buf[212];

Please change, instead, the MAX_XFER_SIZE macro.

Thanks!
Mauro
>  
>  	if (tab_len > sizeof(buf)) {
>  		dev_warn(&state->i2c->dev,


-- 

Cheers,
Mauro
