Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:55238 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728792AbeIXUtl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 16:49:41 -0400
Subject: Re: [PATCH 1/1] v4l: Remove support for crop default target in subdev
 drivers
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: h.grohne@intenta.de
References: <20180924144227.31237-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b7c721df-1035-40d1-f507-fe7a474e85e5@xs4all.nl>
Date: Mon, 24 Sep 2018 16:47:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180924144227.31237-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2018 04:42 PM, Sakari Ailus wrote:
> The V4L2 sub-device API does not support the crop default target. A number
> of drivers apparently still did support this, likely as it was needed by
> the SoC camera framework. Drop support for the default crop rectaingle in
> sub-device drivers, and use the bround in SoC camera instead.
> 
> Reported-by: Helmut Grohne <h.grohne@intenta.de>
> Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/ak881x.c                         | 1 -
>  drivers/media/i2c/mt9m111.c                        | 1 -
>  drivers/media/i2c/mt9t112.c                        | 6 ------
>  drivers/media/i2c/ov2640.c                         | 1 -
>  drivers/media/i2c/ov6650.c                         | 1 -
>  drivers/media/i2c/ov772x.c                         | 1 -
>  drivers/media/i2c/rj54n1cb0c.c                     | 1 -
>  drivers/media/i2c/soc_camera/mt9m001.c             | 1 -
>  drivers/media/i2c/soc_camera/mt9t112.c             | 6 ------
>  drivers/media/i2c/soc_camera/mt9v022.c             | 1 -
>  drivers/media/i2c/soc_camera/ov5642.c              | 1 -
>  drivers/media/i2c/soc_camera/ov772x.c              | 1 -
>  drivers/media/i2c/soc_camera/ov9640.c              | 1 -
>  drivers/media/i2c/soc_camera/ov9740.c              | 1 -
>  drivers/media/i2c/soc_camera/rj54n1cb0c.c          | 1 -
>  drivers/media/i2c/tvp5150.c                        | 1 -
>  drivers/media/platform/soc_camera/soc_scale_crop.c | 2 +-
>  drivers/staging/media/imx074/imx074.c              | 1 -
>  drivers/staging/media/mt9t031/mt9t031.c            | 1 -
>  19 files changed, 1 insertion(+), 29 deletions(-)
> 
> diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
> index 16682c8477d1..30f9db1351b9 100644
> --- a/drivers/media/i2c/ak881x.c
> +++ b/drivers/media/i2c/ak881x.c
> @@ -136,7 +136,6 @@ static int ak881x_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = 0;
>  		sel->r.top = 0;
>  		sel->r.width = 720;
> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> index efda1aa95ca0..1395986a07bb 100644
> --- a/drivers/media/i2c/mt9m111.c
> +++ b/drivers/media/i2c/mt9m111.c
> @@ -445,7 +445,6 @@ static int mt9m111_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = MT9M111_MIN_DARK_COLS;
>  		sel->r.top = MT9M111_MIN_DARK_ROWS;
>  		sel->r.width = MT9M111_MAX_WIDTH;
> diff --git a/drivers/media/i2c/mt9t112.c b/drivers/media/i2c/mt9t112.c
> index af8cca984215..ef353a244e33 100644
> --- a/drivers/media/i2c/mt9t112.c
> +++ b/drivers/media/i2c/mt9t112.c
> @@ -888,12 +888,6 @@ static int mt9t112_get_selection(struct v4l2_subdev *sd,
>  		sel->r.width = MAX_WIDTH;
>  		sel->r.height = MAX_HEIGHT;
>  		return 0;
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
> -		sel->r.left = 0;
> -		sel->r.top = 0;
> -		sel->r.width = VGA_WIDTH;
> -		sel->r.height = VGA_HEIGHT;
> -		return 0;
>  	case V4L2_SEL_TGT_CROP:
>  		sel->r = priv->frame;
>  		return 0;
> diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> index beb722065152..20a8853ba1e2 100644
> --- a/drivers/media/i2c/ov2640.c
> +++ b/drivers/media/i2c/ov2640.c
> @@ -1010,7 +1010,6 @@ static int ov2640_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  	case V4L2_SEL_TGT_CROP:
>  		sel->r.left = 0;
>  		sel->r.top = 0;
> diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
> index 17a34b4a819d..5d1b218bb7f0 100644
> --- a/drivers/media/i2c/ov6650.c
> +++ b/drivers/media/i2c/ov6650.c
> @@ -449,7 +449,6 @@ static int ov6650_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = DEF_HSTRT << 1;
>  		sel->r.top = DEF_VSTRT << 1;
>  		sel->r.width = W_CIF;
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 161bc7c8535d..fefff7fd7d68 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -1147,7 +1147,6 @@ static int ov772x_get_selection(struct v4l2_subdev *sd,
>  	sel->r.top = 0;
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  	case V4L2_SEL_TGT_CROP:
>  		sel->r.width = priv->win->rect.width;
>  		sel->r.height = priv->win->rect.height;
> diff --git a/drivers/media/i2c/rj54n1cb0c.c b/drivers/media/i2c/rj54n1cb0c.c
> index 6ad998ad1b16..4cc51e001874 100644
> --- a/drivers/media/i2c/rj54n1cb0c.c
> +++ b/drivers/media/i2c/rj54n1cb0c.c
> @@ -589,7 +589,6 @@ static int rj54n1_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = RJ54N1_COLUMN_SKIP;
>  		sel->r.top = RJ54N1_ROW_SKIP;
>  		sel->r.width = RJ54N1_MAX_WIDTH;
> diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
> index 1bfb0d53059e..a1a85ff838c5 100644
> --- a/drivers/media/i2c/soc_camera/mt9m001.c
> +++ b/drivers/media/i2c/soc_camera/mt9m001.c
> @@ -243,7 +243,6 @@ static int mt9m001_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = MT9M001_COLUMN_SKIP;
>  		sel->r.top = MT9M001_ROW_SKIP;
>  		sel->r.width = MT9M001_MAX_WIDTH;
> diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
> index b53c36dfa469..ea1ff270bc2d 100644
> --- a/drivers/media/i2c/soc_camera/mt9t112.c
> +++ b/drivers/media/i2c/soc_camera/mt9t112.c
> @@ -884,12 +884,6 @@ static int mt9t112_get_selection(struct v4l2_subdev *sd,
>  		sel->r.width = MAX_WIDTH;
>  		sel->r.height = MAX_HEIGHT;
>  		return 0;
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
> -		sel->r.left = 0;
> -		sel->r.top = 0;
> -		sel->r.width = VGA_WIDTH;
> -		sel->r.height = VGA_HEIGHT;
> -		return 0;
>  	case V4L2_SEL_TGT_CROP:
>  		sel->r = priv->frame;
>  		return 0;
> diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
> index 762f06919329..6d922b17ea94 100644
> --- a/drivers/media/i2c/soc_camera/mt9v022.c
> +++ b/drivers/media/i2c/soc_camera/mt9v022.c
> @@ -368,7 +368,6 @@ static int mt9v022_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = MT9V022_COLUMN_SKIP;
>  		sel->r.top = MT9V022_ROW_SKIP;
>  		sel->r.width = MT9V022_MAX_WIDTH;
> diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
> index 39f420db9c70..c6c41b03c0ef 100644
> --- a/drivers/media/i2c/soc_camera/ov5642.c
> +++ b/drivers/media/i2c/soc_camera/ov5642.c
> @@ -896,7 +896,6 @@ static int ov5642_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = 0;
>  		sel->r.top = 0;
>  		sel->r.width = OV5642_MAX_WIDTH;
> diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
> index 14377af7c888..fafd372527b2 100644
> --- a/drivers/media/i2c/soc_camera/ov772x.c
> +++ b/drivers/media/i2c/soc_camera/ov772x.c
> @@ -862,7 +862,6 @@ static int ov772x_get_selection(struct v4l2_subdev *sd,
>  	sel->r.top = 0;
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.width = OV772X_MAX_WIDTH;
>  		sel->r.height = OV772X_MAX_HEIGHT;
>  		return 0;
> diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
> index c63948989688..eb91b8240083 100644
> --- a/drivers/media/i2c/soc_camera/ov9640.c
> +++ b/drivers/media/i2c/soc_camera/ov9640.c
> @@ -554,7 +554,6 @@ static int ov9640_get_selection(struct v4l2_subdev *sd,
>  	sel->r.top = 0;
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  	case V4L2_SEL_TGT_CROP:
>  		sel->r.width = W_SXGA;
>  		sel->r.height = H_SXGA;
> diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
> index 755de2289c39..a07d3145d1b4 100644
> --- a/drivers/media/i2c/soc_camera/ov9740.c
> +++ b/drivers/media/i2c/soc_camera/ov9740.c
> @@ -730,7 +730,6 @@ static int ov9740_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  	case V4L2_SEL_TGT_CROP:
>  		sel->r.left = 0;
>  		sel->r.top = 0;
> diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
> index 02398d0bc649..f0cb49a6167b 100644
> --- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
> +++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
> @@ -591,7 +591,6 @@ static int rj54n1_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = RJ54N1_COLUMN_SKIP;
>  		sel->r.top = RJ54N1_ROW_SKIP;
>  		sel->r.width = RJ54N1_MAX_WIDTH;
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index f5b234e4599d..4f746e02de22 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -1082,7 +1082,6 @@ static int tvp5150_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = 0;
>  		sel->r.top = 0;
>  		sel->r.width = TVP5150_H_MAX;
> diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
> index 6164102e6f9f..8d25ca0490f7 100644
> --- a/drivers/media/platform/soc_camera/soc_scale_crop.c
> +++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
> @@ -52,7 +52,7 @@ int soc_camera_client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
>  		return ret;
>  	}
>  
> -	sdsel.target = V4L2_SEL_TGT_CROP_DEFAULT;
> +	sdsel.target = V4L2_SEL_TGT_CROP_BOUNDS;
>  	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &sdsel);
>  	if (!ret)
>  		*rect = sdsel.r;
> diff --git a/drivers/staging/media/imx074/imx074.c b/drivers/staging/media/imx074/imx074.c
> index 77f1e0243d6e..c5256903e59f 100644
> --- a/drivers/staging/media/imx074/imx074.c
> +++ b/drivers/staging/media/imx074/imx074.c
> @@ -223,7 +223,6 @@ static int imx074_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  	case V4L2_SEL_TGT_CROP:
>  		return 0;
>  	default:
> diff --git a/drivers/staging/media/mt9t031/mt9t031.c b/drivers/staging/media/mt9t031/mt9t031.c
> index 4802d30e47de..4ff179302b4f 100644
> --- a/drivers/staging/media/mt9t031/mt9t031.c
> +++ b/drivers/staging/media/mt9t031/mt9t031.c
> @@ -330,7 +330,6 @@ static int mt9t031_get_selection(struct v4l2_subdev *sd,
>  
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
>  		sel->r.left = MT9T031_COLUMN_SKIP;
>  		sel->r.top = MT9T031_ROW_SKIP;
>  		sel->r.width = MT9T031_MAX_WIDTH;
> 
