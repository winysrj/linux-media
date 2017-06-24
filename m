Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36235
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751568AbdFXTMp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 15:12:45 -0400
Date: Sat, 24 Jun 2017 16:12:37 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
Subject: Re: [PATCH 6/7] [staging] cxd2099/cxd2099.c: Removed useless
 printing in cxd2099 driver
Message-ID: <20170624161237.6b16c5da@vento.lan>
In-Reply-To: <1494190313-18557-7-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
        <1494190313-18557-7-git-send-email-jasmin@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  7 May 2017 22:51:52 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> From: Jasmin Jessich <jasmin@anw.at>

Please provide a description. Wouldn't be better to use, instead, dev_debug()
instead of just removing those?

> 
> Signed-off-by: Jasmin Jessich <jasmin@anw.at>
> ---
>  drivers/staging/media/cxd2099/cxd2099.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
> index ac01433..64de129 100644
> --- a/drivers/staging/media/cxd2099/cxd2099.c
> +++ b/drivers/staging/media/cxd2099/cxd2099.c
> @@ -231,7 +231,6 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
>  		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
>  	if (status)
>  		return status;
> -	dev_info(&ci->i2c->dev, "write_block %d\n", n);
>  
>  	ci->lastaddress = adr;
>  	buf[0] = 1;
> @@ -240,7 +239,6 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
>  
>  		if (ci->cfg.max_i2c && (len + 1 > ci->cfg.max_i2c))
>  			len = ci->cfg.max_i2c - 1;
> -		dev_info(&ci->i2c->dev, "write %d\n", len);
>  		memcpy(buf + 1, data, len);
>  		status = i2c_write(ci->i2c, ci->cfg.adr, buf, len + 1);
>  		if (status)
> @@ -570,14 +568,11 @@ static int campoll(struct cxd *ci)
>  		return 0;
>  	write_reg(ci, 0x05, istat);
>  
> -	if (istat&0x40) {
> +	if (istat&0x40)
>  		ci->dr = 1;
> -		dev_info(&ci->i2c->dev, "DR\n");
> -	}
> -	if (istat&0x20) {
> +
> +	if (istat&0x20)
>  		ci->write_busy = 0;
> -		dev_info(&ci->i2c->dev, "WC\n");
> -	}
>  
>  	if (istat&2) {
>  		u8 slotstat;
> @@ -631,7 +626,6 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
>  	campoll(ci);
>  	mutex_unlock(&ci->lock);
>  
> -	dev_info(&ci->i2c->dev, "read_data\n");
>  	if (!ci->dr)
>  		return 0;
>  
> @@ -660,7 +654,6 @@ static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
>  	if (ci->write_busy)
>  		return -EAGAIN;
>  	mutex_lock(&ci->lock);
> -	dev_info(&ci->i2c->dev, "write_data %d\n", ecount);
>  	write_reg(ci, 0x0d, ecount>>8);
>  	write_reg(ci, 0x0e, ecount&0xff);
>  	write_block(ci, 0x11, ebuf, ecount);



Thanks,
Mauro
