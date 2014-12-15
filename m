Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12253 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaLOK75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 05:59:57 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NGM00IRNEQORQ50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Dec 2014 11:04:00 +0000 (GMT)
Message-id: <548EBF15.3060902@samsung.com>
Date: Mon, 15 Dec 2014 11:59:33 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH 10/10] s5k5baf: fix sparse warnings
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
 <1418471580-26510-11-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1418471580-26510-11-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/12/14 12:53, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> drivers/media/i2c/s5k5baf.c:1796:33: warning: duplicate const
> drivers/media/i2c/s5k5baf.c:379:24: warning: cast to restricted __le16
> drivers/media/i2c/s5k5baf.c:437:11: warning: incorrect type in assignment (different base types)
> drivers/media/i2c/s5k5baf.c:445:16: warning: incorrect type in return expression (different base types)
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/media/i2c/s5k5baf.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index 60a74d8..a3d7d03 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -353,7 +353,7 @@ static struct v4l2_rect s5k5baf_cis_rect = {
>   *
>   */
>  static int s5k5baf_fw_parse(struct device *dev, struct s5k5baf_fw **fw,
> -			    size_t count, const u16 *data)
> +			    size_t count, const __le16 *data)
>  {
>  	struct s5k5baf_fw *f;
>  	u16 *d, i, *end;
> @@ -421,6 +421,7 @@ static u16 s5k5baf_i2c_read(struct s5k5baf *state, u16 addr)
>  {
>  	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
>  	__be16 w, r;
> +	u16 res;
>  	struct i2c_msg msg[] = {
>  		{ .addr = c->addr, .flags = 0,
>  		  .len = 2, .buf = (u8 *)&w },
> @@ -434,15 +435,15 @@ static u16 s5k5baf_i2c_read(struct s5k5baf *state, u16 addr)
>  
>  	w = cpu_to_be16(addr);
>  	ret = i2c_transfer(c->adapter, msg, 2);
> -	r = be16_to_cpu(r);
> +	res = be16_to_cpu(r);
>  
> -	v4l2_dbg(3, debug, c, "i2c_read: 0x%04x : 0x%04x\n", addr, r);
> +	v4l2_dbg(3, debug, c, "i2c_read: 0x%04x : 0x%04x\n", addr, res);
>  
>  	if (ret != 2) {
>  		v4l2_err(c, "i2c_read: error during transfer (%d)\n", ret);
>  		state->error = ret;
>  	}
> -	return r;
> +	return res;
>  }
>  
>  static void s5k5baf_i2c_write(struct s5k5baf *state, u16 addr, u16 val)
> @@ -1037,7 +1038,7 @@ static int s5k5baf_load_setfile(struct s5k5baf *state)
>  	}
>  
>  	ret = s5k5baf_fw_parse(&c->dev, &state->fw, fw->size / 2,
> -			       (u16 *)fw->data);
> +			       (__le16 *)fw->data);
>  
>  	release_firmware(fw);
>  
> @@ -1793,7 +1794,7 @@ static const struct v4l2_subdev_ops s5k5baf_subdev_ops = {
>  
>  static int s5k5baf_configure_gpios(struct s5k5baf *state)
>  {
> -	static const char const *name[] = { "S5K5BAF_STBY", "S5K5BAF_RST" };
> +	static const char * const name[] = { "S5K5BAF_STBY", "S5K5BAF_RST" };
>  	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
>  	struct s5k5baf_gpio *g = state->gpios;
>  	int ret, i;

