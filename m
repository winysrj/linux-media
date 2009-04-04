Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:54835 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbZDDXcb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 19:32:31 -0400
Date: Sat, 4 Apr 2009 18:32:25 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH] pvrusb2: Drop client_register/unregister stubs
In-Reply-To: <20090404231333.5e136f83@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904041831570.32720@cnc.isely.net>
References: <20090404231333.5e136f83@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-by: Mike Isely <isely@pobox.com>

On Sat, 4 Apr 2009, Jean Delvare wrote:

> The client_register and client_unregister methods are optional so
> there is no point in defining stub ones. Especially when these methods
> are likely to be removed soon.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |   12 ------------
>  1 file changed, 12 deletions(-)
> 
> --- v4l-dvb.orig/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-04-04 13:58:40.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-04-04 22:12:21.000000000 +0200
> @@ -595,16 +595,6 @@ static u32 pvr2_i2c_functionality(struct
>  	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_I2C;
>  }
>  
> -static int pvr2_i2c_attach_inform(struct i2c_client *client)
> -{
> -	return 0;
> -}
> -
> -static int pvr2_i2c_detach_inform(struct i2c_client *client)
> -{
> -	return 0;
> -}
> -
>  static struct i2c_algorithm pvr2_i2c_algo_template = {
>  	.master_xfer   = pvr2_i2c_xfer,
>  	.functionality = pvr2_i2c_functionality,
> @@ -617,8 +607,6 @@ static struct i2c_adapter pvr2_i2c_adap_
>  	.owner         = THIS_MODULE,
>  	.class	       = 0,
>  	.id            = I2C_HW_B_BT848,
> -	.client_register = pvr2_i2c_attach_inform,
> -	.client_unregister = pvr2_i2c_detach_inform,
>  };
>  
>  
> 
> 

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
