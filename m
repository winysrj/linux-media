Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2146 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3CZIvM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 04:51:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Wei Yongjun <weiyj.lk@gmail.com>
Subject: Re: [PATCH -next v2] [media] go7007: fix invalid use of sizeof in go7007_usb_i2c_master_xfer()
Date: Tue, 26 Mar 2013 09:50:52 +0100
Cc: hans.verkuil@cisco.com, mchehab@redhat.com,
	gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <CAPgLHd8xRn-7ExMXY9KA8GKvh3DmZ6jN0WBZ8BGb1WmGW2ghBA@mail.gmail.com>
In-Reply-To: <CAPgLHd8xRn-7ExMXY9KA8GKvh3DmZ6jN0WBZ8BGb1WmGW2ghBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303260950.52996.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue March 26 2013 09:45:11 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> sizeof() when applied to a pointer typed expression gives the
> size of the pointer, not that of the pointed data.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/staging/media/go7007/go7007-usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
> index 0823506..d455c0b 100644
> --- a/drivers/staging/media/go7007/go7007-usb.c
> +++ b/drivers/staging/media/go7007/go7007-usb.c
> @@ -1035,7 +1035,7 @@ static int go7007_usb_i2c_master_xfer(struct i2c_adapter *adapter,
>  						buf, buf_len, 0) < 0)
>  			goto i2c_done;
>  		if (msgs[i].flags & I2C_M_RD) {
> -			memset(buf, 0, sizeof(buf));
> +			memset(buf, 0, msgs[i].len + 1);
>  			if (go7007_usb_vendor_request(go, 0x25, 0, 0, buf,
>  						msgs[i].len + 1, 1) < 0)
>  				goto i2c_done;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
