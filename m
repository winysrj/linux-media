Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44101 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab2GWTto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 15:49:44 -0400
Received: by bkwj10 with SMTP id j10so5668882bkw.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 12:49:43 -0700 (PDT)
Message-ID: <500DAAD4.6040008@googlemail.com>
Date: Mon, 23 Jul 2012 21:49:40 +0200
From: Thomas Mair <thomas.mair86@googlemail.com>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org, thomas.mair86@gmail.com
Subject: Re: [PATCH] rtl2832.c: minor cleanup
References: <201207151956.47423.hfvogt@gmx.net>
In-Reply-To: <201207151956.47423.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.07.2012 19:56, Hans-Frieder Vogt wrote:
> The current formulation of the bw_params loop uses the counter j as an index for the first dimension of the
> bw_params array which is later incremented by the variable i.
> It is evaluated correctly only, because j is initialized to 0 at the beginning of the loop.
> I think that explicitly using the index 0 better reflects the intent of the expression.
You are right. It makes the code more readeable.

> 
> Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>
> 
>  rtl2832.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/media/dvb/frontends/rtl2832.c	2012-07-06 05:45:16.000000000 +0200
> +++ b/drivers/media/dvb/frontends/rtl2832.c	2012-07-15 19:05:28.428017449 +0200
> @@ -589,7 +589,7 @@ static int rtl2832_set_frontend(struct d
>  		return -EINVAL;
>  	}
>  
> -	for (j = 0; j < sizeof(bw_params[j]); j++) {
> +	for (j = 0; j < sizeof(bw_params[0]); j++) {
>  		ret = rtl2832_wr_regs(priv, 0x1c+j, 1, &bw_params[i][j], 1);
>  		if (ret)
>  			goto err;
> 
> Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
> 

