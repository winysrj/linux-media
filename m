Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:44463 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2K2I1F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 03:27:05 -0500
Date: Thu, 29 Nov 2012 09:24:19 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: g.liakhovetski@gmx.de, mchehab@redhat.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Subject: Re: [PATCH -next] [media] mt9v022: fix potential NULL pointer
 dereference in mt9v022_probe()
Message-ID: <20121129092419.06fd4a8a@wker>
In-Reply-To: <CAPgLHd_6U7mMeU5r6Axc9WmpUhO1+fv5vnWXVau19zTC_qdz=g@mail.gmail.com>
References: <CAPgLHd_6U7mMeU5r6Axc9WmpUhO1+fv5vnWXVau19zTC_qdz=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Nov 2012 21:56:15 -0500
Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference to 'icl' should be moved below the NULL test.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Anatolij Gustschin <agust@denx.de>

> ---
>  drivers/media/i2c/soc_camera/mt9v022.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
> index d40a885..7509802 100644
> --- a/drivers/media/i2c/soc_camera/mt9v022.c
> +++ b/drivers/media/i2c/soc_camera/mt9v022.c
> @@ -875,7 +875,7 @@ static int mt9v022_probe(struct i2c_client *client,
>  	struct mt9v022 *mt9v022;
>  	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> -	struct mt9v022_platform_data *pdata = icl->priv;
> +	struct mt9v022_platform_data *pdata;
>  	int ret;
>  
>  	if (!icl) {
> @@ -893,6 +893,7 @@ static int mt9v022_probe(struct i2c_client *client,
>  	if (!mt9v022)
>  		return -ENOMEM;
>  
> +	pdata = icl->priv;
>  	v4l2_i2c_subdev_init(&mt9v022->subdev, client, &mt9v022_subdev_ops);
>  	v4l2_ctrl_handler_init(&mt9v022->hdl, 6);
>  	v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
