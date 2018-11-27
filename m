Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:52732 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbeK0XJ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 18:09:29 -0500
Subject: Re: [RESEND PATCH 1/1] media: Use common test pattern menu entries
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: bingbu.cao@intel.com, andy.yeh@intel.com, tfiga@chromium.org
References: <20181127093451.9066-1-sakari.ailus@linux.intel.com>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <b4503c5a-8437-c70f-6022-2b500f47a998@lucaceresoli.net>
Date: Tue, 27 Nov 2018 13:11:42 +0100
MIME-Version: 1.0
In-Reply-To: <20181127093451.9066-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, Bingbu,

On 27/11/18 10:34, Sakari Ailus wrote:
> While the test pattern menu itself is not standardised, many devices
> support the same test patterns. Aligning the menu entries helps the user
> space to use the interface, and adding macros for the menu entry strings
> helps to keep them aligned.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Fixed Andy's email.
> 
>  drivers/media/i2c/imx258.c             | 10 +++++-----
>  drivers/media/i2c/imx319.c             | 10 +++++-----
>  drivers/media/i2c/imx355.c             | 10 +++++-----
>  drivers/media/i2c/ov2640.c             |  4 ++--
>  drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++-----
>  include/uapi/linux/v4l2-controls.h     |  5 +++++
>  6 files changed, 27 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> index f86ae18bc104..c795d4c4c0e4 100644
> --- a/drivers/media/i2c/imx258.c
> +++ b/drivers/media/i2c/imx258.c
> @@ -498,11 +498,11 @@ static const struct imx258_reg mode_1048_780_regs[] = {
>  };
>  
>  static const char * const imx258_test_pattern_menu[] = {
> -	"Disabled",
> -	"Solid Colour",
> -	"Eight Vertical Colour Bars",
> -	"Colour Bars With Fade to Grey",
> -	"Pseudorandom Sequence (PN9)",
> +	V4L2_TEST_PATTERN_DISABLED,
> +	V4L2_TEST_PATTERN_SOLID_COLOUR,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY,
> +	V4L2_TEST_PATTERN_PN9,
>  };
>  
>  /* Configurations for supported link frequencies */
> diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
> index 17c2e4b41221..eddaf69a67b6 100644
> --- a/drivers/media/i2c/imx319.c
> +++ b/drivers/media/i2c/imx319.c
> @@ -1647,11 +1647,11 @@ static const struct imx319_reg mode_1280x720_regs[] = {
>  };
>  
>  static const char * const imx319_test_pattern_menu[] = {
> -	"Disabled",
> -	"Solid Colour",
> -	"Eight Vertical Colour Bars",
> -	"Colour Bars With Fade to Grey",
> -	"Pseudorandom Sequence (PN9)",
> +	V4L2_TEST_PATTERN_DISABLED,
> +	V4L2_TEST_PATTERN_SOLID_COLOUR,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY,
> +	V4L2_TEST_PATTERN_PN9,
>  };
>  
>  /* supported link frequencies */
> diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
> index bed293b60e50..824d07156f9c 100644
> --- a/drivers/media/i2c/imx355.c
> +++ b/drivers/media/i2c/imx355.c
> @@ -875,11 +875,11 @@ static const struct imx355_reg mode_820x616_regs[] = {
>  };
>  
>  static const char * const imx355_test_pattern_menu[] = {
> -	"Disabled",
> -	"Solid Colour",
> -	"Eight Vertical Colour Bars",
> -	"Colour Bars With Fade to Grey",
> -	"Pseudorandom Sequence (PN9)",
> +	V4L2_TEST_PATTERN_DISABLED,
> +	V4L2_TEST_PATTERN_SOLID_COLOUR,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY,
> +	V4L2_TEST_PATTERN_PN9,
>  };
>  
>  /* supported link frequencies */
> diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> index 5d2d6735cc78..507ec7176a7d 100644
> --- a/drivers/media/i2c/ov2640.c
> +++ b/drivers/media/i2c/ov2640.c
> @@ -707,8 +707,8 @@ static int ov2640_reset(struct i2c_client *client)
>  }
>  
>  static const char * const ov2640_test_pattern_menu[] = {
> -	"Disabled",
> -	"Eight Vertical Colour Bars",
> +	V4L2_TEST_PATTERN_DISABLED,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
>  };
>  
>  /*
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 58a45c353e27..f6a92b9f178c 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -409,11 +409,11 @@ static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
>  }
>  
>  static const char * const smiapp_test_patterns[] = {
> -	"Disabled",
> -	"Solid Colour",
> -	"Eight Vertical Colour Bars",
> -	"Colour Bars With Fade to Grey",
> -	"Pseudorandom Sequence (PN9)",
> +	V4L2_TEST_PATTERN_DISABLED,
> +	V4L2_TEST_PATTERN_SOLID_COLOUR,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
> +	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY,
> +	V4L2_TEST_PATTERN_PN9,
>  };
>  
>  static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 998983a6e6b7..a74ff6f1ac88 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -1014,6 +1014,11 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
>  #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
>  #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
> +#define V4L2_TEST_PATTERN_DISABLED		"Disabled"
> +#define V4L2_TEST_PATTERN_SOLID_COLOUR		"Solid Colour"
> +#define V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS		"Eight Vertical Colour Bars"
> +#define V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY "Colour Bars With Fade to Grey"

Bingbu, can you confirm the "Colour Bars With Fade to Grey" has 8 bars?
And that they are vertical?

For the rest LGTM, I'll send a patch against IMX274 to use these defines
as soon as they are committed.

-- 
Luca
