Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47082 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754070AbeDZINJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 04:13:09 -0400
Date: Thu, 26 Apr 2018 11:13:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/13] media: imx274: add SELECTION support for
 cropping
Message-ID: <20180426081306.t3tn72ewh65symy6@valkosipuli.retiisi.org.uk>
References: <1524558258-530-1-git-send-email-luca@lucaceresoli.net>
 <1524558258-530-14-git-send-email-luca@lucaceresoli.net>
 <20180424095918.tgzi2bqrmxeg6nwa@valkosipuli.retiisi.org.uk>
 <2146003c-92ba-904d-6d03-2cce89679487@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2146003c-92ba-904d-6d03-2cce89679487@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

On Tue, Apr 24, 2018 at 04:30:38PM +0200, Luca Ceresoli wrote:
> Hi Sakari,
> 
> On 24/04/2018 11:59, Sakari Ailus wrote:
> > Hi Luca,
> > 
> > Thank you for the patchset.
> > 
> > Some comments below... what I propose is that I apply the rest of the
> > patches and then the comments to this one could be addressed separately.
> > Would that work for you?
> 
> Yes, but I suggest you only apply patches 1-6. I noticed a warning in
> patch 9, and patches 7-8 are not very useful without it. Will fix it in v3.

Ack. I'll apply 1--6 then.

> 
> I'll wait for the outcome of the discussion below before sending v3.
> Tell me if you prefer me to do it earlier.
> 
> > On Tue, Apr 24, 2018 at 10:24:18AM +0200, Luca Ceresoli wrote:
> >> Currently this driver does not support cropping. The supported modes
> >> are the following, all capturing the entire area:
> >>
> >>  - 3840x2160, 1:1 binning (native sensor resolution)
> >>  - 1920x1080, 2:1 binning
> >>  - 1280x720,  3:1 binning
> >>
> >> The set_fmt callback chooses among these 3 configurations the one that
> >> matches the requested format.
> >>
> >> Adding support to VIDIOC_SUBDEV_G_SELECTION and
> >> VIDIOC_SUBDEV_S_SELECTION involved a complete rewrite of set_fmt,
> >> which now chooses the most appropriate binning based on the ratio
> >> between the previously-set cropping size and the format size being
> >> requested.
> >>
> >> Note that the names in enum imx274_mode change from being
> >> resolution-based to being binning-based. Without cropping, the two
> >> naming are equivalent. With cropping, the resolution could be
> >> different, e.g. using 2:1 binning mode to crop 1200x960 and output a
> >> 600x480 format. Using binning in the names avoids anny
> >> misunderstanding.
> >>
> >> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> >>
> >> ---
> >> Changed v1 -> v2:
> >>  - add "media: " prefix to commit message
> >> ---
> >>  drivers/media/i2c/imx274.c | 266 ++++++++++++++++++++++++++++++++-------------
> >>  1 file changed, 192 insertions(+), 74 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
> >> index b6c54712f2aa..ceb5b3e498c6 100644
> >> --- a/drivers/media/i2c/imx274.c
> >> +++ b/drivers/media/i2c/imx274.c
> >> @@ -19,6 +19,7 @@
> >>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >>   */
> >>  
> >> +#include <linux/kernel.h>
> >>  #include <linux/clk.h>
> >>  #include <linux/delay.h>
> >>  #include <linux/gpio.h>
> >> @@ -74,7 +75,7 @@
> >>   */
> >>  #define IMX274_MIN_EXPOSURE_TIME		(4 * 260 / 72)
> >>  
> >> -#define IMX274_DEFAULT_MODE			IMX274_MODE_3840X2160
> >> +#define IMX274_DEFAULT_MODE			IMX274_MODE_BINNING_OFF
> >>  #define IMX274_MAX_WIDTH			(3840)
> >>  #define IMX274_MAX_HEIGHT			(2160)
> >>  #define IMX274_MAX_FRAME_RATE			(120)
> >> @@ -111,6 +112,20 @@
> >>  #define IMX274_SHR_REG_LSB			0x300C /* SHR */
> >>  #define IMX274_SVR_REG_MSB			0x300F /* SVR */
> >>  #define IMX274_SVR_REG_LSB			0x300E /* SVR */
> >> +#define IMX274_HTRIM_EN_REG			0x3037
> >> +#define IMX274_HTRIM_START_REG_LSB		0x3038
> >> +#define IMX274_HTRIM_START_REG_MSB		0x3039
> >> +#define IMX274_HTRIM_END_REG_LSB		0x303A
> >> +#define IMX274_HTRIM_END_REG_MSB		0x303B
> >> +#define IMX274_VWIDCUTEN_REG			0x30DD
> >> +#define IMX274_VWIDCUT_REG_LSB			0x30DE
> >> +#define IMX274_VWIDCUT_REG_MSB			0x30DF
> >> +#define IMX274_VWINPOS_REG_LSB			0x30E0
> >> +#define IMX274_VWINPOS_REG_MSB			0x30E1
> >> +#define IMX274_WRITE_VSIZE_REG_LSB		0x3130
> >> +#define IMX274_WRITE_VSIZE_REG_MSB		0x3131
> >> +#define IMX274_Y_OUT_SIZE_REG_LSB		0x3132
> >> +#define IMX274_Y_OUT_SIZE_REG_MSB		0x3133
> >>  #define IMX274_VMAX_REG_1			0x30FA /* VMAX, MSB */
> >>  #define IMX274_VMAX_REG_2			0x30F9 /* VMAX */
> >>  #define IMX274_VMAX_REG_3			0x30F8 /* VMAX, LSB */
> >> @@ -141,9 +156,9 @@ static const struct regmap_config imx274_regmap_config = {
> >>  };
> >>  
> >>  enum imx274_mode {
> >> -	IMX274_MODE_3840X2160,
> >> -	IMX274_MODE_1920X1080,
> >> -	IMX274_MODE_1280X720,
> >> +	IMX274_MODE_BINNING_OFF,
> >> +	IMX274_MODE_BINNING_2_1,
> >> +	IMX274_MODE_BINNING_3_1,
> >>  };
> >>  
> >>  /*
> >> @@ -215,31 +230,14 @@ static const struct reg_8 imx274_mode1_3840x2160_raw10[] = {
> >>  	{0x3004, 0x01},
> >>  	{0x3005, 0x01},
> >>  	{0x3006, 0x00},
> >> -	{0x3007, 0x02},
> >> +	{0x3007, 0xa2},
> >>  
> >>  	{0x3018, 0xA2}, /* output XVS, HVS */
> >>  
> >>  	{0x306B, 0x05},
> >>  	{0x30E2, 0x01},
> >> -	{0x30F6, 0x07}, /* HMAX, 263 */
> >> -	{0x30F7, 0x01}, /* HMAX */
> >> -
> >> -	{0x30dd, 0x01}, /* crop to 2160 */
> >> -	{0x30de, 0x06},
> >> -	{0x30df, 0x00},
> >> -	{0x30e0, 0x12},
> >> -	{0x30e1, 0x00},
> >> -	{0x3037, 0x01}, /* to crop to 3840 */
> >> -	{0x3038, 0x0c},
> >> -	{0x3039, 0x00},
> >> -	{0x303a, 0x0c},
> >> -	{0x303b, 0x0f},
> >>  
> >>  	{0x30EE, 0x01},
> >> -	{0x3130, 0x86},
> >> -	{0x3131, 0x08},
> >> -	{0x3132, 0x7E},
> >> -	{0x3133, 0x08},
> >>  	{0x3342, 0x0A},
> >>  	{0x3343, 0x00},
> >>  	{0x3344, 0x16},
> >> @@ -273,7 +271,7 @@ static const struct reg_8 imx274_mode3_1920x1080_raw10[] = {
> >>  	{0x3004, 0x02},
> >>  	{0x3005, 0x21},
> >>  	{0x3006, 0x00},
> >> -	{0x3007, 0x11},
> >> +	{0x3007, 0xb1},
> >>  
> >>  	{0x3018, 0xA2}, /* output XVS, HVS */
> >>  
> >> @@ -283,22 +281,7 @@ static const struct reg_8 imx274_mode3_1920x1080_raw10[] = {
> >>  	{0x30F6, 0x04}, /* HMAX, 260 */
> >>  	{0x30F7, 0x01}, /* HMAX */
> >>  
> >> -	{0x30dd, 0x01}, /* to crop to 1920x1080 */
> >> -	{0x30de, 0x05},
> >> -	{0x30df, 0x00},
> >> -	{0x30e0, 0x04},
> >> -	{0x30e1, 0x00},
> >> -	{0x3037, 0x01},
> >> -	{0x3038, 0x0c},
> >> -	{0x3039, 0x00},
> >> -	{0x303a, 0x0c},
> >> -	{0x303b, 0x0f},
> >> -
> >>  	{0x30EE, 0x01},
> >> -	{0x3130, 0x4E},
> >> -	{0x3131, 0x04},
> >> -	{0x3132, 0x46},
> >> -	{0x3133, 0x04},
> >>  	{0x3342, 0x0A},
> >>  	{0x3343, 0x00},
> >>  	{0x3344, 0x1A},
> >> @@ -331,7 +314,7 @@ static const struct reg_8 imx274_mode5_1280x720_raw10[] = {
> >>  	{0x3004, 0x03},
> >>  	{0x3005, 0x31},
> >>  	{0x3006, 0x00},
> >> -	{0x3007, 0x09},
> >> +	{0x3007, 0xa9},
> >>  
> >>  	{0x3018, 0xA2}, /* output XVS, HVS */
> >>  
> >> @@ -341,21 +324,7 @@ static const struct reg_8 imx274_mode5_1280x720_raw10[] = {
> >>  	{0x30F6, 0x04}, /* HMAX, 260 */
> >>  	{0x30F7, 0x01}, /* HMAX */
> >>  
> >> -	{0x30DD, 0x01},
> >> -	{0x30DE, 0x07},
> >> -	{0x30DF, 0x00},
> >> -	{0x40E0, 0x04},
> >> -	{0x30E1, 0x00},
> >> -	{0x3030, 0xD4},
> >> -	{0x3031, 0x02},
> >> -	{0x3032, 0xD0},
> >> -	{0x3033, 0x02},
> >> -
> >>  	{0x30EE, 0x01},
> >> -	{0x3130, 0xE2},
> >> -	{0x3131, 0x02},
> >> -	{0x3132, 0xDE},
> >> -	{0x3133, 0x02},
> >>  	{0x3342, 0x0A},
> >>  	{0x3343, 0x00},
> >>  	{0x3344, 0x1B},
> >> @@ -561,6 +530,7 @@ struct stimx274 {
> >>  	struct imx274_ctrls ctrls;
> >>  	struct v4l2_mbus_framefmt format;
> >>  	struct v4l2_fract frame_interval;
> >> +	struct v4l2_rect crop;
> >>  	struct regmap *regmap;
> >>  	struct gpio_desc *reset_gpio;
> >>  	struct mutex lock; /* mutex lock for operations */
> >> @@ -901,36 +871,30 @@ static int imx274_set_fmt(struct v4l2_subdev *sd,
> >>  {
> >>  	struct v4l2_mbus_framefmt *fmt = &format->format;
> >>  	struct stimx274 *imx274 = to_imx274(sd);
> >> -	struct i2c_client *client = imx274->client;
> >> -	int index;
> >> +	struct device *dev = &imx274->client->dev;
> >> +	unsigned int ratio; /* Binning ratio */
> >>  
> >> -	dev_dbg(&client->dev,
> >> -		"%s: width = %d height = %d code = %d\n",
> >> -		__func__, fmt->width, fmt->height, fmt->code);
> >> +	dev_dbg(dev, "%s: request of  %dx%d (%s)\n",
> >> +		__func__, fmt->width, fmt->height,
> >> +		V4L2_SUBDEV_FORMAT_ACTIVE ? "ACTIVE" : "TRY");
> >>  
> >>  	mutex_lock(&imx274->lock);
> >>  
> >> -	for (index = 0; index < ARRAY_SIZE(imx274_formats); index++) {
> >> -		if (imx274_formats[index].size.width == fmt->width &&
> >> -		    imx274_formats[index].size.height == fmt->height)
> >> +	/* Find ratio (maximize output resolution). Fallback to 1:1. */
> >> +	for (ratio = 3; ratio > 1; ratio--)
> >> +		if (fmt->width <= DIV_ROUND_UP(imx274->crop.width, ratio) &&
> >> +		    fmt->height <= DIV_ROUND_UP(imx274->crop.height, ratio))
> >>  			break;
> >> -	}
> >> -
> >> -	if (index >= ARRAY_SIZE(imx274_formats)) {
> >> -		/* default to first format */
> >> -		index = 0;
> >> -	}
> >>  
> >> -	imx274->mode = &imx274_formats[index];
> >> +	imx274->mode = &imx274_formats[ratio - 1];
> >>  
> >> -	if (fmt->width > IMX274_MAX_WIDTH)
> >> -		fmt->width = IMX274_MAX_WIDTH;
> >> -	if (fmt->height > IMX274_MAX_HEIGHT)
> >> -		fmt->height = IMX274_MAX_HEIGHT;
> >> -	fmt->width = fmt->width & (~IMX274_MASK_LSB_2_BITS);
> >> -	fmt->height = fmt->height & (~IMX274_MASK_LSB_2_BITS);
> >> +	fmt->width = imx274->crop.width / ratio;
> >> +	fmt->height = imx274->crop.height / ratio;
> >>  	fmt->field = V4L2_FIELD_NONE;
> >>  
> >> +	dev_dbg(dev, "%s: adjusted to %dx%d (%d:1 binning)\n",
> >> +		__func__, fmt->width, fmt->height, ratio);
> >> +
> >>  	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
> >>  		cfg->try_fmt = *fmt;
> >>  	else
> >> @@ -940,6 +904,152 @@ static int imx274_set_fmt(struct v4l2_subdev *sd,
> >>  	return 0;
> >>  }
> >>  
> >> +static int imx274_get_selection(struct v4l2_subdev *sd,
> >> +				struct v4l2_subdev_pad_config *cfg,
> >> +				struct v4l2_subdev_selection *sel)
> >> +{
> >> +	struct stimx274 *imx274 = to_imx274(sd);
> >> +
> >> +	if (sel->pad != 0)
> >> +		return -EINVAL;
> >> +
> >> +	switch (sel->target) {
> >> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> >> +		sel->r.left = 0;
> >> +		sel->r.top = 0;
> >> +		sel->r.width = IMX274_MAX_WIDTH;
> >> +		sel->r.height = IMX274_MAX_HEIGHT;
> >> +		return 0;
> >> +	case V4L2_SEL_TGT_CROP:
> >> +		if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> >> +			mutex_lock(&imx274->lock);
> >> +			sel->r = imx274->crop;
> >> +			mutex_unlock(&imx274->lock);
> >> +		} else {
> >> +			sel->r = cfg->try_crop;
> >> +		}
> >> +		return 0;
> >> +	default:
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int imx274_set_selection(struct v4l2_subdev *sd,
> >> +				struct v4l2_subdev_pad_config *cfg,
> >> +				struct v4l2_subdev_selection *sel)
> >> +{
> >> +	struct stimx274 *imx274 = to_imx274(sd);
> >> +	struct device *dev = &imx274->client->dev;
> >> +	struct v4l2_mbus_framefmt *tgt_fmt;
> >> +	struct v4l2_rect *tgt_crop;
> >> +	struct v4l2_rect new_crop;
> >> +
> > 
> > A lot of sensor drivers use the format IOCTLs to configure the output size
> > of the sensor and that's what it must be: the get_fmt() pad op has to
> > return the format of the image produced by the sensor. The size set by the
> > set_fmt() also must be obtainable using get_fmt().
> > 
> > What I propose is to move also the binning configuration to use selections,
> > i.e. the COMPOSE selection target. The NATIVE_SIZE target is the sensor's
> > native size, the largest that can be accessed in its pixel array.
> > 
> > The size in format related IOCTLs is thus derived from the NATIVE_SIZE,
> > CROP and COMPOSE configuration, and is no longer settable directly.
> 
> I'm OK with making any improvement, but I'm afraid I'm not understanding
> what you mean. Do you mean we should stop responding to the VIDIOC_S_FMT
> ioctl, aka v4l2_subdev_pad_ops.set_selection? Wouldn't this break
> existing applications?

Hmm. The driver supports sub-device uAPI. Which bridge (or ISP) driver are
you using the sensor with?

> 
> Also the meaning of COMPOSE in the context of a sensor subdev is unclear
> to me. For a video node (which is typically paired with a DMA) it makes
> sense: the DMA can write a sub-area of the destination memory buffer.
> But the sensor subdev is the first element of a possibly long processing
> chain, and as such it only produces a stream. The sensor does not know
> what a "memory buffer" is.
> 
> What's wrong with my understanding?

The COMPOSE target is also used for configuring scaling:

<URL:https://hverkuil.home.xs4all.nl/spec/uapi/v4l/dev-subdev.html#selections-cropping-scaling-and-composition>

And binning is effectively scaling.

> 
> > Btw. the crop here, is that taking place after binning as it would seem
> > like? Then, I presume it is digital cropping, and the CROP rectangle is
> > related to the COMPOSE rectangle (binning configuration).
> 
> Logically speaking, cropping here happens before binning, i.e. the crop
> rectangle always refers to NATIVE_SIZE. The sensor just skips lines and
> columns outside of that rectangle and optionally bins what's inside.
> 
> Examples of how it is currently implemented:
> - native 3840x2160, crop 3840x2160, fmt 3840x2160 = don't crop,  1:1 bin
> - native 3840x2160, crop 1920x1080, fmt 1920x1080 = crop to 50%, 1:1 bin
> - native 3840x2160, crop 3840x2160, fmt 1920x1080 = don't crop,  2:1 bin
> - native 3840x2160, crop 1920x1080, fmt  960x 540 = crop to 50%, 2:1 bin
> 
> Can you provide similar examples of how it would work when setting CROP
> + COMPOSE, and without setting the format?
> 
> Regards,

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
