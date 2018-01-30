Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbeA3NBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 08:01:07 -0500
Date: Tue, 30 Jan 2018 15:01:02 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] imx258: Fix sparse warnings
Message-ID: <20180130130102.da63nz3ndrffgu5p@kekkonen.localdomain>
References: <20180122212542.26474-1-sakari.ailus@linux.intel.com>
 <8E0971CCB6EA9D41AF58191A2D3978B61D4F3064@PGSMSX111.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D4F3064@PGSMSX111.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sat, Jan 27, 2018 at 04:24:39PM +0000, Yeh, Andy wrote:
> Fix a few sparse warnings related to conversion between CPU and big endian. Also simplify the code in the process.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Andy Yeh <andy.yeh@intel.com>

Thanks for the ack. There's no need to resend the patch for that, you can
simply reply to the patch itself.

> ---
> since v2:
> 
> - Count loop downwards, not up.
> 
>  drivers/media/i2c/imx258.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c index a7e58bd23de7..213429cca8b5 100644
> --- a/drivers/media/i2c/imx258.c
> +++ b/drivers/media/i2c/imx258.c
> @@ -440,10 +440,10 @@ static int imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val)  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
>  	struct i2c_msg msgs[2];
> +	__be16 reg_addr_be = cpu_to_be16(reg);
> +	__be32 data_be = 0;
>  	u8 *data_be_p;
>  	int ret;
> -	u32 data_be = 0;
> -	u16 reg_addr_be = cpu_to_be16(reg);
>  
>  	if (len > 4)
>  		return -EINVAL;
> @@ -474,24 +474,19 @@ static int imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val)  static int imx258_write_reg(struct imx258 *imx258, u16 reg, u32 len, u32 val)  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> -	int buf_i, val_i;
> -	u8 buf[6], *val_p;
> +	u8 __buf[6], *buf = __buf;
> +	int i;
>  
>  	if (len > 4)
>  		return -EINVAL;
>  
> -	buf[0] = reg >> 8;
> -	buf[1] = reg & 0xff;
> +	*buf++ = reg >> 8;
> +	*buf++ = reg & 0xff;
>  
> -	val = cpu_to_be32(val);
> -	val_p = (u8 *)&val;
> -	buf_i = 2;
> -	val_i = 4 - len;
> +	for (i = len - 1; i >= 0; i--)
> +		*buf++ = (u8)(val >> (i << 3));
>  
> -	while (val_i < 4)
> -		buf[buf_i++] = val_p[val_i++];
> -
> -	if (i2c_master_send(client, buf, len + 2) != len + 2)
> +	if (i2c_master_send(client, __buf, len + 2) != len + 2)
>  		return -EIO;
>  
>  	return 0;
> --
> 2.11.0
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
