Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59809 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbbECVDC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 17:03:02 -0400
Date: Sun, 3 May 2015 23:02:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 9/9] mt9t112: initialize left and top
In-Reply-To: <1430646876-19594-10-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1505032250430.6055@axis700.grange>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
 <1430646876-19594-10-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, 3 May 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The left and top variables were uninitialized, leading to unexpected
> results.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/soc_camera/mt9t112.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
> index de10a76..02190d6 100644
> --- a/drivers/media/i2c/soc_camera/mt9t112.c
> +++ b/drivers/media/i2c/soc_camera/mt9t112.c
> @@ -952,7 +952,8 @@ static int mt9t112_set_fmt(struct v4l2_subdev *sd,
>  	struct v4l2_mbus_framefmt *mf = &format->format;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t112_priv *priv = to_mt9t112(client);
> -	unsigned int top, left;
> +	unsigned int top = priv->frame.top;
> +	unsigned int left = priv->frame.left;

I don't think this is needed. We don't care about left and top in 
mt9t112_set_fmt().

How about my comment about a duplicated call to mt9t112_set_params()? Can 
we have it fixed too?

Thanks
Guennadi

>  	int i;
>  
>  	if (format->pad)
> -- 
> 2.1.4
> 
