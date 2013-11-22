Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60200 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab3KVOLf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 09:11:35 -0500
Message-ID: <528F660F.9050100@iki.fi>
Date: Fri, 22 Nov 2013 16:11:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] af9035: unlock on error in af9035_i2c_master_xfer()
References: <20131122075045.GA15726@elgon.mountain>
In-Reply-To: <20131122075045.GA15726@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>

Antti

On 22.11.2013 09:50, Dan Carpenter wrote:
> We introduced a couple new error paths which are missing unlocks.
>
> Fixes: 7760e148350b ('[media] af9035: Don't use dynamic static allocation')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index c8fcd78425bd..625ef2489b23 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -245,7 +245,8 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   				dev_warn(&d->udev->dev,
>   					 "%s: i2c xfer: len=%d is too big!\n",
>   					 KBUILD_MODNAME, msg[0].len);
> -				return -EOPNOTSUPP;
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
>   			}
>   			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
>   			buf[0] = msg[1].len;
> @@ -281,7 +282,8 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   				dev_warn(&d->udev->dev,
>   					 "%s: i2c xfer: len=%d is too big!\n",
>   					 KBUILD_MODNAME, msg[0].len);
> -				return -EOPNOTSUPP;
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
>   			}
>   			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
>   			buf[0] = msg[0].len;
> @@ -319,6 +321,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>   		ret = -EOPNOTSUPP;
>   	}
>
> +unlock:
>   	mutex_unlock(&d->i2c_mutex);
>
>   	if (ret < 0)
>


-- 
http://palosaari.fi/
