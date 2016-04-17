Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57606 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750970AbcDQVpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Apr 2016 17:45:22 -0400
Date: Mon, 18 Apr 2016 00:44:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] smiapp: provide g_skip_top_lines method in
 sensor ops
Message-ID: <20160417214447.GV32125@valkosipuli.retiisi.org.uk>
References: <1460794340-490-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460794340-490-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivaylo,

On Sat, Apr 16, 2016 at 11:12:20AM +0300, Ivaylo Dimitrov wrote:
> Some sensors (like the one in Nokia N900) provide metadata in the first
> couple of lines. Make that information information available to the
> pipeline.
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 12 ++++++++++++
>  drivers/media/i2c/smiapp/smiapp.h      |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index a215efe..3dfe387 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -188,6 +188,8 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
>  		embedded_end = 0;
>  	}
>  
> +	sensor->image_start = image_start;
> +
>  	dev_dbg(&client->dev, "embedded data from lines %d to %d\n",
>  		embedded_start, embedded_end);
>  	dev_dbg(&client->dev, "image data starts at line %d\n", image_start);
> @@ -2280,6 +2282,15 @@ static int smiapp_get_skip_frames(struct v4l2_subdev *subdev, u32 *frames)
>  	return 0;
>  }
>  
> +static int smiapp_get_skip_top_lines(struct v4l2_subdev *subdev, u32 *lines)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +
> +	*lines = sensor->image_start;
> +
> +	return 0;
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * sysfs attributes
>   */
> @@ -2890,6 +2901,7 @@ static const struct v4l2_subdev_pad_ops smiapp_pad_ops = {
>  
>  static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
>  	.g_skip_frames = smiapp_get_skip_frames,
> +	.g_skip_top_lines = smiapp_get_skip_top_lines,
>  };
>  
>  static const struct v4l2_subdev_ops smiapp_ops = {
> diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
> index f6af0cc..c8b4ca0 100644
> --- a/drivers/media/i2c/smiapp/smiapp.h
> +++ b/drivers/media/i2c/smiapp/smiapp.h
> @@ -217,6 +217,7 @@ struct smiapp_sensor {
>  
>  	u8 hvflip_inv_mask; /* H/VFLIP inversion due to sensor orientation */
>  	u8 frame_skip;
> +	u32 image_start;	/* Offset to first line after metadata lines */
>  
>  	int power_count;
>  

I'm afraid I think this is not exactly the best way to approach the issue.
It'd work, somehow, yes, but ---

1. A compliant sensor (at least in theory) is able to tell this information
itself. The number of metadata lines is present in the sensor frame format
descriptors.

2. The more generic problem of describing the frame layout should be solved.
Sensor metadata is just a special case of this. I've proposed frame
descriptors (see an old RFC
<URL:http://www.spinics.net/lists/linux-media/msg67295.html>), but this is
just a partial solution as well; the APIs would need to be extended to
support metadata capture (I think Laurent has been working on that).

So a proper solution will require a little bit of time still.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
