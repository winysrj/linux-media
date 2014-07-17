Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36238 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbaGQL3v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 07:29:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] tvp5150: Use i2c_smbus_(read|write)_byte_data
Date: Thu, 17 Jul 2014 13:29:58 +0200
Message-ID: <3203757.dfSHCQkonN@avalon>
In-Reply-To: <1401132688-5632-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401132688-5632-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Ping ?

On Monday 26 May 2014 21:31:28 Laurent Pinchart wrote:
> Replace the custom I2C read/write implementation with SMBUS functions to
> simplify the driver.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/tvp5150.c | 31 +++++++++++--------------------
>  1 file changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 937e48b..193e7d6 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -56,38 +56,29 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl
> *ctrl) static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
> {
>  	struct i2c_client *c = v4l2_get_subdevdata(sd);
> -	unsigned char buffer[1];
>  	int rc;
> -	struct i2c_msg msg[] = {
> -		{ .addr = c->addr, .flags = 0,
> -		  .buf = &addr, .len = 1 },
> -		{ .addr = c->addr, .flags = I2C_M_RD,
> -		  .buf = buffer, .len = 1 }
> -	};
> -
> -	rc = i2c_transfer(c->adapter, msg, 2);
> -	if (rc < 0 || rc != 2) {
> -		v4l2_err(sd, "i2c i/o error: rc == %d (should be 2)\n", rc);
> -		return rc < 0 ? rc : -EIO;
> +
> +	rc = i2c_smbus_read_byte_data(c, addr);
> +	if (rc < 0) {
> +		v4l2_err(sd, "i2c i/o error: rc == %d\n", rc);
> +		return rc;
>  	}
> 
> -	v4l2_dbg(2, debug, sd, "tvp5150: read 0x%02x = 0x%02x\n", addr,
> buffer[0]); +	v4l2_dbg(2, debug, sd, "tvp5150: read 0x%02x = 0x%02x\n",
> addr, rc);
> 
> -	return (buffer[0]);
> +	return rc;
>  }
> 
>  static inline void tvp5150_write(struct v4l2_subdev *sd, unsigned char
> addr, unsigned char value)
>  {
>  	struct i2c_client *c = v4l2_get_subdevdata(sd);
> -	unsigned char buffer[2];
>  	int rc;
> 
> -	buffer[0] = addr;
> -	buffer[1] = value;
> -	v4l2_dbg(2, debug, sd, "tvp5150: writing 0x%02x 0x%02x\n", buffer[0],
> buffer[1]); -	if (2 != (rc = i2c_master_send(c, buffer, 2)))
> -		v4l2_dbg(0, debug, sd, "i2c i/o error: rc == %d (should be 2)\n", 
rc);
> +	v4l2_dbg(2, debug, sd, "tvp5150: writing 0x%02x 0x%02x\n", addr, value);
> +	rc = i2c_smbus_write_byte_data(c, addr, value);
> +	if (rc < 0)
> +		v4l2_dbg(0, debug, sd, "i2c i/o error: rc == %d\n", rc);
>  }
> 
>  static void dump_reg_range(struct v4l2_subdev *sd, char *s, u8 init,

-- 
Regards,

Laurent Pinchart

