Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:35030 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932765AbeF2JV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 05:21:57 -0400
Subject: Re: [PATCH v4 8/8] media: imx274: add SELECTION support for cropping
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
 <1528716939-17015-9-git-send-email-luca@lucaceresoli.net>
 <20180629080445.sa4rt74ptt5445y4@paasikivi.fi.intel.com>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <56d9376d-f257-8f37-fbc3-a9f8e564d4e8@lucaceresoli.net>
Date: Fri, 29 Jun 2018 11:21:55 +0200
MIME-Version: 1.0
In-Reply-To: <20180629080445.sa4rt74ptt5445y4@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thanks for the review.

On 29/06/2018 10:04, Sakari Ailus wrote:
> On Mon, Jun 11, 2018 at 01:35:39PM +0200, Luca Ceresoli wrote:
>> Currently this driver does not support cropping. The supported modes
>> are the following, all capturing the entire area:
>>
>>  - 3840x2160, 1:1 binning (native sensor resolution)
>>  - 1920x1080, 2:1 binning
>>  - 1280x720,  3:1 binning
>>
>> The VIDIOC_SUBDEV_S_FMT ioctl chooses among these 3 configurations the
>> one that matches the requested format.
>>
>> Add cropping support via VIDIOC_SUBDEV_S_SELECTION: with target
>> V4L2_SEL_TGT_CROP to choose the captured area, with
>> V4L2_SEL_TGT_COMPOSE to choose the output resolution.
>>
>> To maintain backward compatibility we also allow setting the compose
>> format via VIDIOC_SUBDEV_S_FMT. To obtain this, compose rect and
>> output format are computed in the common helper function
>> __imx274_change_compose(), which sets both to the same width/height
>> values.
>>
>> Cropping also calls __imx274_change_compose() whenever cropping rect
>> size changes in order to reset the compose rect (and output format
>> size) for 1:1 binning.
>>
>> Also change the names in enum imx274_mode from being resolution-based
>> to being binning-based (e.g. from IMX274_MODE_1920X1080 to
>> IMX274_MODE_BINNING_2_1). Without cropping, the two naming are
>> equivalent. With cropping, the resolution could be different,
>> e.g. using 2:1 binning mode to crop 1200x960 and output a 600x480
>> format. Using binning in the names avoids any misunderstanding.  For
>> the same reason, replace the 'size' field in struct imx274_frmfmt with
>> 'bin_ratio'.
>>
>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>>
>> ---
>> Changed v3 -> v4:
>>  - Set the binning via the SELECTION API (COMPOSE rect), but still
>>    allow using VIDIOC_SUBDEV_S_FMT for backward compatibility.
>>  - rename imx274_set_trimming -> imx274_apply_trimming for clarity
>>
>> Changed v2 -> v3:
>>  - Remove hard-coded HMAX reg setting from all modes, not only the
>>    first one. HMAX is always computed and set in s_stream now.
>>  - Reword commit log message.
>>
>> Changed v1 -> v2:
>>  - add "media: " prefix to commit message
>> ---
>>  drivers/media/i2c/imx274.c | 416 +++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 326 insertions(+), 90 deletions(-)
>>
>> diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
>> index 2c13961e9764..8bfc20a46b3d 100644
>> --- a/drivers/media/i2c/imx274.c
>> +++ b/drivers/media/i2c/imx274.c
>> @@ -5,6 +5,7 @@
>>   *
>>   * Leon Luo <leonl@leopardimaging.com>
>>   * Edwin Zou <edwinz@leopardimaging.com>
>> + * Luca Ceresoli <luca@lucaceresoli.net>
>>   *
>>   * This program is free software; you can redistribute it and/or modify it
>>   * under the terms and conditions of the GNU General Public License,
>> @@ -19,6 +20,7 @@
>>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>   */
>>  
>> +#include <linux/kernel.h>
> 
> Alphabetical order, please.

Ok.

>> @@ -141,9 +157,9 @@ static const struct regmap_config imx274_regmap_config = {
>>  };
>>  
>>  enum imx274_mode {
> 
> Is this still an appropriate name? imx274_binning?

Yes, that would be coherent with the renaming of the individual fields.

>> -	IMX274_MODE_3840X2160,
>> -	IMX274_MODE_1920X1080,
>> -	IMX274_MODE_1280X720,
>> +	IMX274_MODE_BINNING_OFF,
>> +	IMX274_MODE_BINNING_2_1,
>> +	IMX274_MODE_BINNING_3_1,
>>  };
>>  
>>  /*
[...]
>> @@ -559,6 +526,8 @@ struct stimx274 {
>>  	struct media_pad pad;
>>  	struct i2c_client *client;
>>  	struct imx274_ctrls ctrls;
>> +	struct v4l2_rect crop;
>> +	struct v4l2_rect compose;
>>  	struct v4l2_mbus_framefmt format;

I noticed the v4l2_rect compose can be removed. In this patch I keep
compose.width (and height) always equal to format.width (height). The
compose width (height) can be read from format.width (height). And since
compose.top and .left are always zero, compose carries no useful info.
Removing .compose will get less code to keep them in sync and no risk
for bugs that get them out of sync.

Note this is an implementation detail. No changes at the API level.

>> @@ -864,6 +833,80 @@ static int imx274_s_ctrl(struct v4l2_ctrl *ctrl)
>>  }
>>  
>>  /**
>> + * Helper function to change binning and set both compose and format.
>> + *
>> + * We have two entry points to change binning: set_fmt and
>> + * set_selection(COMPOSE). Both have to compute the new output size
>> + * and set it in both the compose rect and the frame format size. We
>> + * also need to do the same things after setting cropping to restore
>> + * 1:1 binning.
>> + *
>> + * This function contains the common code for these three cases, it
>> + * has many arguments in order to accomodate the needs of all of them.
>> + *
>> + * Must be called with imx274->lock locked.
>> + *
>> + * @imx274 The device object
> 
> Colon after the name of the argument. Same below.

Ouch. Thanks.

>> + * @cfg    The pad config we are editing for TRY requests
>> + * @which  V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY from the caller
>> + * @width  Input-output parameter: set to the desired width before
>> + *         the call, contains the chosen value after returning successfully
>> + * @height Input-output parameter for height (see @width)
>> + */
>> +static int __imx274_change_compose(struct stimx274 *imx274,
>> +				   struct v4l2_subdev_pad_config *cfg,
>> +				   u32 which,
>> +				   u32 *width,
>> +				   u32 *height)
>> +{
>> +	struct device *dev = &imx274->client->dev;
>> +	const struct v4l2_rect *cur_crop;
>> +	struct v4l2_mbus_framefmt *tgt_fmt;
>> +	struct v4l2_rect *tgt_compose;
>> +	unsigned int ratio; /* Binning ratio */
>> +
>> +	dev_dbg(dev, "%s: request of  %dx%d (%s)\n",
>> +		__func__, *width, *height,
>> +		(which == V4L2_SUBDEV_FORMAT_ACTIVE) ? "ACTIVE" : "TRY");
> 
> If these's a need for such debug prints, I think they'd be better added to
> the framework than individual drivers.

Agreed, let's get rid of them.

>> +
>> +	if (which == V4L2_SUBDEV_FORMAT_TRY) {
>> +		cur_crop = &cfg->try_crop;
>> +		tgt_compose = &cfg->try_compose;
>> +		tgt_fmt = &cfg->try_fmt;
>> +	} else {
>> +		cur_crop = &imx274->crop;
>> +		tgt_compose = &imx274->compose;
>> +		tgt_fmt = &imx274->format;
>> +	}
>> +
>> +	/* Find ratio (maximize output resolution). Fallback to 1:1. */
>> +	for (ratio = 3; ratio > 1; ratio--)
>> +		if (*width <= DIV_ROUND_UP(cur_crop->width, ratio) &&
>> +		    *height <= DIV_ROUND_UP(cur_crop->height, ratio))
>> +			break;
> 
> There are flags to direct the rounding behaviour. The default is the
> nearest:
> 
> <URL:https://hverkuil.home.xs4all.nl/spec/uapi/v4l/v4l2-selection-flags.html>
> 
> The smiapp driver (as the only sensor driver) supports them.

Right, I will implement that.

>> +
>> +	*width = cur_crop->width / ratio;
>> +	*height = cur_crop->height / ratio;
>> +
>> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> +		imx274->mode = &imx274_formats[ratio - 1];
>> +
>> +	dev_dbg(dev, "%s: adjusted to %dx%d (%d:1 binning)\n",
>> +		__func__, *width, *height, ratio);
> 
> Could be here, for binning. %d -> %u --- it's unsigned.
Ok, in the nxt version this will look like:

    dev_dbg(dev, "%s: selected %u:1 binning\n", __func__, ratio);

Bye,
-- 
Luca
