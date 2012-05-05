Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab2EEOfH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 10:35:07 -0400
Message-ID: <4FA53A95.9040205@redhat.com>
Date: Sat, 05 May 2012 16:35:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 2/7] zc3xx: convert to the control framework.
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <f5a41eed0541dfa132750639ff0df9c22b9f157c.1335625085.git.hans.verkuil@cisco.com>
In-Reply-To: <f5a41eed0541dfa132750639ff0df9c22b9f157c.1335625085.git.hans.verkuil@cisco.com>
Content-Type: multipart/mixed;
 boundary="------------010701000507090403000304"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010701000507090403000304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Reviewing and testing this one was, erm, interesting. See comments
inline.

On 04/28/2012 05:09 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   drivers/media/video/gspca/zc3xx.c |  451 +++++++++++++++----------------------
>   1 file changed, 182 insertions(+), 269 deletions(-)
>
> diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
> index 7d9a4f1..e7b7599 100644
> --- a/drivers/media/video/gspca/zc3xx.c
> +++ b/drivers/media/video/gspca/zc3xx.c

<snip various chunks, no comments on these>

> +static int sd_setautogain(struct gspca_dev *gspca_dev, s32 val)
> +{
> +	if (!gspca_dev->streaming)
> +		return 0;
> +	setautogain(gspca_dev, val);
> +
> +	return gspca_dev->usb_err;
> +}
> +

zcxx_s_ctrl can just as well call setautogain directly as it
does for the others. It should gspca_dev->streaming for all
controls anyways (more on that below).

> +static int sd_setquality(struct gspca_dev *gspca_dev, s32 val)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +	int i;
> +
> +	for (i = 0; i<  ARRAY_SIZE(jpeg_qual) - 1; i++) {
> +		if (val<= jpeg_qual[i])
> +			break;
> +	}
> +	sd->reg08 = i;
> +	if (!gspca_dev->streaming)
> +		return 0;
> +	jpeg_set_qual(sd->jpeg_hdr, val);
> +	return gspca_dev->usb_err;
> +}
> +

This for 99% duplicates the special handling you already
have for this in zcxx_s_ctrl, which is also the only caller.

More over this gets its wrong as under certain conditions
it will end up with a different value of i then the code in
zcxx_s_ctrl, and zcxx_s_ctrl bases the value it returns
to the caller as the "achieved" value on its own calculation
of i.

So I thought lets refactor this a bit to get rid of this
duplication and that turned out to be a long journey rather
then a quick patch :) While testing my changes I found that
there are various (pre-existing) problems with how zc3xx
handles JPEG quality so I've fixed those first.

The result is a 6 patch patchset (attached), which besides
many fixes to the JPEG quality handling, also includes
a new version of this patch removing the duplication.

> +static int sd_set_jcomp(struct gspca_dev *gspca_dev,
> +			struct v4l2_jpegcompression *jcomp)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +
> +	if (sd->jpegqual) {
> +		v4l2_ctrl_s_ctrl(sd->jpegqual, jcomp->quality);
> +		jcomp->quality = v4l2_ctrl_g_ctrl(sd->jpegqual);
> +		return gspca_dev->usb_err;
> +	}
> +	jcomp->quality = jpeg_qual[sd->reg08];
> +	return 0;
> +}
> +
> +static int sd_get_jcomp(struct gspca_dev *gspca_dev,
> +			struct v4l2_jpegcompression *jcomp)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +
> +	memset(jcomp, 0, sizeof *jcomp);
> +	jcomp->quality = jpeg_qual[sd->reg08];
> +	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
> +			| V4L2_JPEG_MARKER_DQT;
> +	return 0;
> +}
> +

No need to move these upwards in the source file, leaving them
where they are makes it easier to see what is actually changed.

> +static int zcxx_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUTOGAIN:
> +		if (ctrl->val&&  sd->exposure&&  sd->gspca_dev.streaming)
> +			sd->exposure->val = getexposure(&sd->gspca_dev);
> +		break;
> +	}
> +	return 0;
> +}

The call to getexposure needs to be surrounded by locking / unlocking
usb_lock, and gspca_de->usb_err should be checked after the call.

In general all calls to the actual hardware need to be made with
the usb_lock hold, so that they cannot race with for example
hardware accesses done from sd_start. This is important since
although the usb-core will ensure that we never can do more then
one control request at a time sometimes several control requests
need to be done in order without interference (for example for
accessing the i2c bus between the bridge and the sensor).

> +
> +static int zcxx_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
> +	int ret;
> +	int i;
> +
> +	switch (ctrl->id) {
> +	/* gamma/brightness/contrast cluster */
> +	case V4L2_CID_GAMMA:
> +		setcontrast(&sd->gspca_dev, sd->gamma->val,
> +				sd->brightness->val, sd->contrast->val);
> +		return 0;
> +	/* autogain/exposure cluster */
> +	case V4L2_CID_AUTOGAIN:
> +		ret = sd_setautogain(&sd->gspca_dev, ctrl->val);
> +		if (!ret&&  !ctrl->val&&  sd->exposure)
> +			setexposure(&sd->gspca_dev, sd->exposure->val);
> +		return ret;
> +	case V4L2_CID_POWER_LINE_FREQUENCY:
> +		setlightfreq(&sd->gspca_dev, ctrl->val);
> +		return 0;
> +	case V4L2_CID_SHARPNESS:
> +		setsharpness(&sd->gspca_dev, ctrl->val);
> +		return 0;
> +	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
> +		for (i = 0; i<  ARRAY_SIZE(jpeg_qual) - 1; i++) {
> +			if (ctrl->val<= jpeg_qual[i])
> +				break;
> +		}
> +		if (i>  0&&  i == sd->reg08&&  ctrl->val<  jpeg_qual[sd->reg08])
> +			i--;
> +		ctrl->val = jpeg_qual[i];
> +		return sd_setquality(&sd->gspca_dev, ctrl->val);
> +	}
> +	return -EINVAL;
> +}
> +

Like zcxx_g_volatile_ctrl this function to should take the usb_lock
before calling setfoo. Also after acquiring the lock it should check
if the device is streaming and if it is not streaming it should not
call any setfoo functions, as those will be done on sd_start then.

Note that setfoo may work when calling them on this bridge while not
streaming, but there are no guarantees the same holds for other
bridges.

In general the control paradigm in gspca is to not send any control
values to the camera until streaming starts.

Last this function to should check gspca_dev->usb_err (which works
a bit like hdl->error accumulating io errors made by setfoo calls).

So the order for any s_ctrl in gspca should normally be:

1) take usb_lock
2) clear gspca_dev->usb_err
3) check gspca_dev->streaming if not streaming
    normally goto unlock and return success immediately
    But there may be special cases where the passed in
    value should first be rounded to the nearest supported
    value (ie the jpeg quality in zc3xx.c)
4) call setfoo functions
5) store gspca_dev->usb_err in a local "ret" variable
6) unlock
7) return ret


> +static const struct v4l2_ctrl_ops zcxx_ctrl_ops = {
> +	.g_volatile_ctrl = zcxx_g_volatile_ctrl,
> +	.s_ctrl = zcxx_s_ctrl,
> +};
> +
>   /* this function is called at probe and resume time */
>   static int sd_init(struct gspca_dev *gspca_dev)
>   {
>   	struct sd *sd = (struct sd *) gspca_dev;
> +	struct v4l2_ctrl_handler *hdl =&sd->ctrl_handler;
>   	struct cam *cam;
>   	int sensor;
>   	static const u8 gamma[SENSOR_MAX] = {
> @@ -6688,7 +6673,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
>   		case 0x2030:
>   			PDEBUG(D_PROBE, "Find Sensor PO2030");
>   			sd->sensor = SENSOR_PO2030;
> -			sd->ctrls[SHARPNESS].def = 0;	/* from win traces */
>   			break;
>   		case 0x7620:
>   			PDEBUG(D_PROBE, "Find Sensor OV7620");
> @@ -6730,30 +6714,40 @@ static int sd_init(struct gspca_dev *gspca_dev)
>   		break;
>   	}
>
> -	sd->ctrls[GAMMA].def = gamma[sd->sensor];
> -	sd->reg08 = reg08_tb[sd->sensor];
> -	sd->ctrls[QUALITY].def = jpeg_qual[sd->reg08];
> -	sd->ctrls[QUALITY].min = jpeg_qual[0];
> -	sd->ctrls[QUALITY].max = jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1];
> -
> -	switch (sd->sensor) {
> -	case SENSOR_HV7131R:
> -		gspca_dev->ctrl_dis = (1<<  QUALITY);
> -		break;
> -	case SENSOR_OV7630C:
> -		gspca_dev->ctrl_dis = (1<<  LIGHTFREQ) | (1<<  EXPOSURE);
> -		break;
> -	case SENSOR_PAS202B:
> -		gspca_dev->ctrl_dis = (1<<  QUALITY) | (1<<  EXPOSURE);
> -		break;
> -	default:
> -		gspca_dev->ctrl_dis = (1<<  EXPOSURE);
> -		break;
> +	gspca_dev->vdev.ctrl_handler = hdl;
> +	v4l2_ctrl_handler_init(hdl, 8);
> +	sd->brightness = v4l2_ctrl_new_std(hdl,&zcxx_ctrl_ops,
> +			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
> +	sd->contrast = v4l2_ctrl_new_std(hdl,&zcxx_ctrl_ops,
> +			V4L2_CID_CONTRAST, 0, 255, 1, 128);
> +	sd->gamma = v4l2_ctrl_new_std(hdl,&zcxx_ctrl_ops,
> +			V4L2_CID_GAMMA, 1, 6, 1, gamma[sd->sensor]);
> +	if (sd->sensor == SENSOR_HV7131R)
> +		sd->exposure = v4l2_ctrl_new_std(hdl,&zcxx_ctrl_ops,
> +			V4L2_CID_EXPOSURE, 0x30d, 0x493e, 1, 0x927);
> +	sd->autogain = v4l2_ctrl_new_std(hdl,&zcxx_ctrl_ops,
> +			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
> +	if (sd->sensor != SENSOR_OV7630C&&  sd->sensor != SENSOR_PAS202B)
> +		sd->plfreq = v4l2_ctrl_new_std_menu(hdl,&zcxx_ctrl_ops,
> +			V4L2_CID_POWER_LINE_FREQUENCY,
> +			V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 0,
> +			V4L2_CID_POWER_LINE_FREQUENCY_DISABLED);

This is wrong the PAS202B should have a powerlinefreq control.

> +	sd->sharpness = v4l2_ctrl_new_std(hdl,&zcxx_ctrl_ops,
> +			V4L2_CID_SHARPNESS, 0, 3, 1,
> +			sd->sensor == SENSOR_PO2030 ? 0 : 2);
> +	if (sd->sensor != SENSOR_HV7131R&&  sd->sensor != SENSOR_PAS202B)
> +		sd->jpegqual = v4l2_ctrl_new_std(hdl,&zcxx_ctrl_ops,
> +			V4L2_CID_JPEG_COMPRESSION_QUALITY,
> +			jpeg_qual[0], jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1], 1,
> +			jpeg_qual[sd->reg08]);
> +	if (hdl->error) {
> +		pr_err("Could not initialize controls\n");
> +		return hdl->error;
>   	}
> -#if AUTOGAIN_DEF
> -	if (sd->ctrls[AUTOGAIN].val)
> -		gspca_dev->ctrl_inac = (1<<  EXPOSURE);
> -#endif
> +	v4l2_ctrl_cluster(3,&sd->gamma);
> +	if (sd->sensor == SENSOR_HV7131R)
> +		v4l2_ctrl_auto_cluster(2,&sd->autogain, 0, true);
> +	sd->reg08 = reg08_tb[sd->sensor];
>
>   	/* switch off the led */
>   	reg_w(gspca_dev, 0x01, 0x0000);
> @@ -6864,7 +6858,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   		reg_w(gspca_dev, 0x03, 0x0008);
>   		break;
>   	}
> -	setsharpness(gspca_dev);
> +	setsharpness(gspca_dev, v4l2_ctrl_g_ctrl(sd->sharpness));
>
>   	/* set the gamma tables when not set */
>   	switch (sd->sensor) {
> @@ -6873,7 +6867,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	case SENSOR_OV7630C:
>   		break;
>   	default:
> -		setcontrast(gspca_dev);
> +		setcontrast(&sd->gspca_dev, v4l2_ctrl_g_ctrl(sd->gamma),
> +				v4l2_ctrl_g_ctrl(sd->brightness),
> +				v4l2_ctrl_g_ctrl(sd->contrast));
>   		break;
>   	}
>   	setmatrix(gspca_dev);			/* one more time? */
> @@ -6886,7 +6882,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	}
>   	setquality(gspca_dev);
>   	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08]);
> -	setlightfreq(gspca_dev);
> +	setlightfreq(gspca_dev, v4l2_ctrl_g_ctrl(sd->plfreq));

sd->plfreq can be null, so this needs an if (sd->plfreq)

>
>   	switch (sd->sensor) {
>   	case SENSOR_ADCM2700:

<snip>

Moving on to the next patch in the series now, hopefully that one will
go quicker :)

Regards,

Hans


--------------010701000507090403000304
Content-Type: text/x-patch;
 name="0001-gspca_zc3xx-Fix-setting-of-jpeg-quality-while-stream.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-gspca_zc3xx-Fix-setting-of-jpeg-quality-while-stream.pa";
 filename*1="tch"

>From 78fd672b2b87177ceff710ca26d9ae15420e66e7 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 5 May 2012 12:31:48 +0200
Subject: [PATCH 1/6] gspca_zc3xx: Fix setting of jpeg quality while streaming

When the user changes the JPEG quality while the camera is streaming, the
driver should not only change the JPEG headers send to userspace, but also
actually tell the camera to use a different quantization table.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/zc3xx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 7d9a4f1..c7c9d11 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -5923,6 +5923,8 @@ static void setquality(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	s8 reg07;
 
+	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08]);
+
 	reg07 = 0;
 	switch (sd->sensor) {
 	case SENSOR_OV7620:
@@ -6885,7 +6887,6 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		break;
 	}
 	setquality(gspca_dev);
-	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08]);
 	setlightfreq(gspca_dev);
 
 	switch (sd->sensor) {
@@ -7041,7 +7042,7 @@ static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
 	sd->reg08 = i;
 	sd->ctrls[QUALITY].val = jpeg_qual[i];
 	if (gspca_dev->streaming)
-		jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);
+		setquality(gspca_dev);
 	return gspca_dev->usb_err;
 }
 
-- 
1.7.10


--------------010701000507090403000304
Content-Type: text/x-patch;
 name="0002-gspca_zc3xx-Fix-JPEG-quality-setting-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-gspca_zc3xx-Fix-JPEG-quality-setting-code.patch"

>From 38f3eb79db0350a05ac29473f0ce4db6efaa8960 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 5 May 2012 11:53:36 +0200
Subject: [PATCH 2/6] gspca_zc3xx: Fix JPEG quality setting code

The current code is using bits 0-1 of register 8 of the zc3xx controller
to set the JPEG quality, but the correct bits are bits 1-2. Bit 0 selects
between truncation or rounding in the quantization phase of the compression,
since rounding generally gives better results it should thus always be 1.

This patch also corrects the quality percentages which belong to the 4
different settings.

Lst this patch removes the different reg 8 defaults depending on the sensor
type. Some of them where going for a default quality setting of 50%, which
generally is not necessary in any way and results in poor image quality.
75% is a good default to use for all scenarios.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/zc3xx.c |   64 +++++++++++++------------------------
 1 file changed, 22 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index c7c9d11..f770676 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -32,7 +32,7 @@ MODULE_LICENSE("GPL");
 
 static int force_sensor = -1;
 
-#define REG08_DEF 3		/* default JPEG compression (70%) */
+#define REG08_DEF 3		/* default JPEG compression (75%) */
 #include "zc3xx-reg.h"
 
 /* controls */
@@ -193,10 +193,10 @@ static const struct ctrl sd_ctrls[NCTRLS] = {
 		.id	 = V4L2_CID_JPEG_COMPRESSION_QUALITY,
 		.type    = V4L2_CTRL_TYPE_INTEGER,
 		.name    = "Compression Quality",
-		.minimum = 40,
-		.maximum = 70,
+		.minimum = 50,
+		.maximum = 94,
 		.step    = 1,
-		.default_value = 70	/* updated in sd_init() */
+		.default_value = 75,
 	    },
 	    .set = sd_setquality
 	},
@@ -241,8 +241,8 @@ static const struct v4l2_pix_format sif_mode[] = {
 		.priv = 0},
 };
 
-/* bridge reg08 -> JPEG quality conversion table */
-static u8 jpeg_qual[] = {40, 50, 60, 70, /*80*/};
+/* bridge reg08 bits 1-2 -> JPEG quality conversion table */
+static u8 jpeg_qual[] = {50, 75, 87, 94};
 
 /* usb exchanges */
 struct usb_action {
@@ -5923,7 +5923,7 @@ static void setquality(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	s8 reg07;
 
-	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08]);
+	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08 >> 1]);
 
 	reg07 = 0;
 	switch (sd->sensor) {
@@ -6079,11 +6079,12 @@ static void transfer_update(struct work_struct *work)
 	struct sd *sd = container_of(work, struct sd, work);
 	struct gspca_dev *gspca_dev = &sd->gspca_dev;
 	int change, good;
-	u8 reg07, reg11;
+	u8 reg07, qual, reg11;
 
 	/* synchronize with the main driver and initialize the registers */
 	mutex_lock(&gspca_dev->usb_lock);
 	reg07 = 0;					/* max */
+	qual = sd->reg08 >> 1;
 	reg_w(gspca_dev, reg07, 0x0007);
 	reg_w(gspca_dev, sd->reg08, ZC3XX_R008_CLOCKSETTING);
 	mutex_unlock(&gspca_dev->usb_lock);
@@ -6108,9 +6109,9 @@ static void transfer_update(struct work_struct *work)
 			case 0:				/* max */
 				reg07 = sd->sensor == SENSOR_HV7131R
 						? 0x30 : 0x32;
-				if (sd->reg08 != 0) {
+				if (qual != 0) {
 					change = 3;
-					sd->reg08--;
+					qual--;
 				}
 				break;
 			case 0x32:
@@ -6143,10 +6144,10 @@ static void transfer_update(struct work_struct *work)
 					}
 				}
 			} else {			/* reg07 max */
-				if (sd->reg08 < sizeof jpeg_qual - 1) {
+				if (qual < sizeof jpeg_qual - 1) {
 					good++;
 					if (good > 10) {
-						sd->reg08++;
+						qual++;
 						change = 2;
 					}
 				}
@@ -6161,15 +6162,16 @@ static void transfer_update(struct work_struct *work)
 					goto err;
 			}
 			if (change & 2) {
+				sd->reg08 = (qual << 1) | 1;
 				reg_w(gspca_dev, sd->reg08,
 						ZC3XX_R008_CLOCKSETTING);
 				if (gspca_dev->usb_err < 0
 				 || !gspca_dev->present
 				 || !gspca_dev->streaming)
 					goto err;
-				sd->ctrls[QUALITY].val = jpeg_qual[sd->reg08];
+				sd->ctrls[QUALITY].val = jpeg_qual[qual];
 				jpeg_set_qual(sd->jpeg_hdr,
-						jpeg_qual[sd->reg08]);
+						jpeg_qual[qual]);
 			}
 		}
 		mutex_unlock(&gspca_dev->usb_lock);
@@ -6561,27 +6563,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		[SENSOR_PO2030] =	1,
 		[SENSOR_TAS5130C] =	1,
 	};
-	static const u8 reg08_tb[SENSOR_MAX] = {
-		[SENSOR_ADCM2700] =	1,
-		[SENSOR_CS2102] =	3,
-		[SENSOR_CS2102K] =	3,
-		[SENSOR_GC0303] =	2,
-		[SENSOR_GC0305] =	3,
-		[SENSOR_HDCS2020] =	1,
-		[SENSOR_HV7131B] =	3,
-		[SENSOR_HV7131R] =	3,
-		[SENSOR_ICM105A] =	3,
-		[SENSOR_MC501CB] =	3,
-		[SENSOR_MT9V111_1] =	3,
-		[SENSOR_MT9V111_3] =	3,
-		[SENSOR_OV7620] =	1,
-		[SENSOR_OV7630C] =	3,
-		[SENSOR_PAS106] =	3,
-		[SENSOR_PAS202B] =	3,
-		[SENSOR_PB0330] =	3,
-		[SENSOR_PO2030] =	2,
-		[SENSOR_TAS5130C] =	3,
-	};
 
 	sensor = zcxx_probeSensor(gspca_dev);
 	if (sensor >= 0)
@@ -6733,8 +6714,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	}
 
 	sd->ctrls[GAMMA].def = gamma[sd->sensor];
-	sd->reg08 = reg08_tb[sd->sensor];
-	sd->ctrls[QUALITY].def = jpeg_qual[sd->reg08];
+	sd->ctrls[QUALITY].def = jpeg_qual[sd->reg08 >> 1];
 	sd->ctrls[QUALITY].min = jpeg_qual[0];
 	sd->ctrls[QUALITY].max = jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1];
 
@@ -7029,17 +7009,17 @@ static int sd_querymenu(struct gspca_dev *gspca_dev,
 static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int i;
+	int i, qual = sd->reg08 >> 1;
 
-	for (i = 0; i < ARRAY_SIZE(jpeg_qual) - 1; i++) {
+	for (i = 0; i < ARRAY_SIZE(jpeg_qual); i++) {
 		if (val <= jpeg_qual[i])
 			break;
 	}
 	if (i > 0
-	 && i == sd->reg08
-	 && val < jpeg_qual[sd->reg08])
+	 && i == qual
+	 && val < jpeg_qual[i])
 		i--;
-	sd->reg08 = i;
+	sd->reg08 = (i << 1) | 1;
 	sd->ctrls[QUALITY].val = jpeg_qual[i];
 	if (gspca_dev->streaming)
 		setquality(gspca_dev);
-- 
1.7.10


--------------010701000507090403000304
Content-Type: text/x-patch;
 name="0003-gscpa_zc3xx-Always-automatically-adjust-BRC-as-neede.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-gscpa_zc3xx-Always-automatically-adjust-BRC-as-neede.pa";
 filename*1="tch"

>From 00aef65c5f72326442f4aaf0a8ad49e67e1dc10e Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 5 May 2012 14:26:33 +0200
Subject: [PATCH 3/6] gscpa_zc3xx: Always automatically adjust BRC as needed

Always automatically adjust the Bit Rate Control setting as needed, independent
of the sensor type. BRC is needed to not run out of bandwidth with higher
quality settings independent of the sensor.

Also only automatically adjust BRC, and don't adjust the JPEG quality control
automatically, as that is not needed and leads to ugly flashes when it is
changed. Note that before this patch-set the quality was never changed
either due to the bugs in the quality handling fixed in previous patches in
this set.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/zc3xx.c |  159 +++++++++++++------------------------
 1 file changed, 53 insertions(+), 106 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index f770676..18ef68d 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -5921,22 +5921,8 @@ static void setexposure(struct gspca_dev *gspca_dev)
 static void setquality(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	s8 reg07;
-
 	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08 >> 1]);
-
-	reg07 = 0;
-	switch (sd->sensor) {
-	case SENSOR_OV7620:
-		reg07 = 0x30;
-		break;
-	case SENSOR_HV7131R:
-	case SENSOR_PAS202B:
-		return;			/* done by work queue */
-	}
 	reg_w(gspca_dev, sd->reg08, ZC3XX_R008_CLOCKSETTING);
-	if (reg07 != 0)
-		reg_w(gspca_dev, reg07, 0x0007);
 }
 
 /* Matches the sensor's internal frame rate to the lighting frequency.
@@ -6070,109 +6056,62 @@ static void setautogain(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, autoval, 0x0180);
 }
 
-/* update the transfer parameters */
-/* This function is executed from a work queue. */
-/* The exact use of the bridge registers 07 and 08 is not known.
- * The following algorithm has been adapted from ms-win traces */
+/*
+ * Update the transfer parameters.
+ * This function is executed from a work queue.
+ */
 static void transfer_update(struct work_struct *work)
 {
 	struct sd *sd = container_of(work, struct sd, work);
 	struct gspca_dev *gspca_dev = &sd->gspca_dev;
 	int change, good;
-	u8 reg07, qual, reg11;
+	u8 reg07, reg11;
 
-	/* synchronize with the main driver and initialize the registers */
-	mutex_lock(&gspca_dev->usb_lock);
-	reg07 = 0;					/* max */
-	qual = sd->reg08 >> 1;
-	reg_w(gspca_dev, reg07, 0x0007);
-	reg_w(gspca_dev, sd->reg08, ZC3XX_R008_CLOCKSETTING);
-	mutex_unlock(&gspca_dev->usb_lock);
+	/* reg07 gets set to 0 by sd_start before starting us */
+	reg07 = 0;
 
 	good = 0;
 	for (;;) {
 		msleep(100);
 
-		/* get the transfer status */
-		/* the bit 0 of the bridge register 11 indicates overflow */
 		mutex_lock(&gspca_dev->usb_lock);
 		if (!gspca_dev->present || !gspca_dev->streaming)
 			goto err;
+
+		/* Bit 0 of register 11 indicates FIFO overflow */
+		gspca_dev->usb_err = 0;
 		reg11 = reg_r(gspca_dev, 0x0011);
-		if (gspca_dev->usb_err < 0
-		 || !gspca_dev->present || !gspca_dev->streaming)
+		if (gspca_dev->usb_err)
 			goto err;
 
 		change = reg11 & 0x01;
 		if (change) {				/* overflow */
-			switch (reg07) {
-			case 0:				/* max */
-				reg07 = sd->sensor == SENSOR_HV7131R
-						? 0x30 : 0x32;
-				if (qual != 0) {
-					change = 3;
-					qual--;
-				}
-				break;
-			case 0x32:
-				reg07 -= 4;
-				break;
-			default:
-				reg07 -= 2;
-				break;
-			case 2:
-				change = 0;		/* already min */
-				break;
-			}
 			good = 0;
+
+			if (reg07 == 0) /* Bit Rate Control not enabled? */
+				reg07 = 0x32; /* Allow 98 bytes / unit */
+			else if (reg07 > 2)
+				reg07 -= 2; /* Decrease allowed bytes / unit */
+			else
+				change = 0;
 		} else {				/* no overflow */
-			if (reg07 != 0) {		/* if not max */
-				good++;
-				if (good >= 10) {
-					good = 0;
+			good++;
+			if (good >= 10) {
+				good = 0;
+				if (reg07) { /* BRC enabled? */
 					change = 1;
-					reg07 += 2;
-					switch (reg07) {
-					case 0x30:
-						if (sd->sensor == SENSOR_PAS202B)
-							reg07 += 2;
-						break;
-					case 0x32:
-					case 0x34:
+					if (reg07 < 0x32)
+						reg07 += 2;
+					else
 						reg07 = 0;
-						break;
-					}
-				}
-			} else {			/* reg07 max */
-				if (qual < sizeof jpeg_qual - 1) {
-					good++;
-					if (good > 10) {
-						qual++;
-						change = 2;
-					}
 				}
 			}
 		}
 		if (change) {
-			if (change & 1) {
-				reg_w(gspca_dev, reg07, 0x0007);
-				if (gspca_dev->usb_err < 0
-				 || !gspca_dev->present
-				 || !gspca_dev->streaming)
-					goto err;
-			}
-			if (change & 2) {
-				sd->reg08 = (qual << 1) | 1;
-				reg_w(gspca_dev, sd->reg08,
-						ZC3XX_R008_CLOCKSETTING);
-				if (gspca_dev->usb_err < 0
-				 || !gspca_dev->present
-				 || !gspca_dev->streaming)
-					goto err;
-				sd->ctrls[QUALITY].val = jpeg_qual[qual];
-				jpeg_set_qual(sd->jpeg_hdr,
-						jpeg_qual[qual]);
-			}
+			gspca_dev->usb_err = 0;
+			reg_w(gspca_dev, reg07, 0x0007);
+			if (gspca_dev->usb_err)
+				goto err;
 		}
 		mutex_unlock(&gspca_dev->usb_lock);
 	}
@@ -6720,14 +6659,10 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	switch (sd->sensor) {
 	case SENSOR_HV7131R:
-		gspca_dev->ctrl_dis = (1 << QUALITY);
 		break;
 	case SENSOR_OV7630C:
 		gspca_dev->ctrl_dis = (1 << LIGHTFREQ) | (1 << EXPOSURE);
 		break;
-	case SENSOR_PAS202B:
-		gspca_dev->ctrl_dis = (1 << QUALITY) | (1 << EXPOSURE);
-		break;
 	default:
 		gspca_dev->ctrl_dis = (1 << EXPOSURE);
 		break;
@@ -6742,6 +6677,13 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	return gspca_dev->usb_err;
 }
 
+static int sd_pre_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	gspca_dev->cam.needs_full_bandwidth = (sd->reg08 >= 4) ? 1 : 0;
+	return 0;
+}
+
 static int sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -6867,6 +6809,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		break;
 	}
 	setquality(gspca_dev);
+	/* Start with BRC disabled, transfer_update will enable it if needed */
+	reg_w(gspca_dev, 0x00, 0x0007);
 	setlightfreq(gspca_dev);
 
 	switch (sd->sensor) {
@@ -6904,19 +6848,14 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	setautogain(gspca_dev);
 
-	/* start the transfer update thread if needed */
-	if (gspca_dev->usb_err >= 0) {
-		switch (sd->sensor) {
-		case SENSOR_HV7131R:
-		case SENSOR_PAS202B:
-			sd->work_thread =
-				create_singlethread_workqueue(KBUILD_MODNAME);
-			queue_work(sd->work_thread, &sd->work);
-			break;
-		}
-	}
+	if (gspca_dev->usb_err < 0)
+		return gspca_dev->usb_err;
 
-	return gspca_dev->usb_err;
+	/* Start the transfer parameters update thread */
+	sd->work_thread = create_singlethread_workqueue(KBUILD_MODNAME);
+	queue_work(sd->work_thread, &sd->work);
+
+	return 0;
 }
 
 /* called on streamoff with alt 0 and on disconnect */
@@ -7019,8 +6958,15 @@ static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
 	 && i == qual
 	 && val < jpeg_qual[i])
 		i--;
+
+	/* With high quality settings we need max bandwidth */
+	if (i >= 2 && gspca_dev->streaming &&
+	    !gspca_dev->cam.needs_full_bandwidth)
+		return -EBUSY;
+
 	sd->reg08 = (i << 1) | 1;
 	sd->ctrls[QUALITY].val = jpeg_qual[i];
+
 	if (gspca_dev->streaming)
 		setquality(gspca_dev);
 	return gspca_dev->usb_err;
@@ -7070,6 +7016,7 @@ static const struct sd_desc sd_desc = {
 	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = sd_config,
 	.init = sd_init,
+	.isoc_init = sd_pre_start,
 	.start = sd_start,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
-- 
1.7.10


--------------010701000507090403000304
Content-Type: text/x-patch;
 name="0004-gscpa_zc3xx-Disable-the-highest-quality-setting-as-i.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-gscpa_zc3xx-Disable-the-highest-quality-setting-as-i.pa";
 filename*1="tch"

>From 1c55e5072b567646b0e90773720ecb8030d90c99 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 5 May 2012 14:33:23 +0200
Subject: [PATCH 4/6] gscpa_zc3xx: Disable the highest quality setting as it
 is not usable

Even with BRC the highest quality setting is not usable, BRC strips so
much data from each MCU that the quality becomes worse then using a lower
quality setting to begin with.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/zc3xx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 18ef68d..a8282b8 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -194,7 +194,7 @@ static const struct ctrl sd_ctrls[NCTRLS] = {
 		.type    = V4L2_CTRL_TYPE_INTEGER,
 		.name    = "Compression Quality",
 		.minimum = 50,
-		.maximum = 94,
+		.maximum = 87,
 		.step    = 1,
 		.default_value = 75,
 	    },
@@ -241,8 +241,11 @@ static const struct v4l2_pix_format sif_mode[] = {
 		.priv = 0},
 };
 
-/* bridge reg08 bits 1-2 -> JPEG quality conversion table */
-static u8 jpeg_qual[] = {50, 75, 87, 94};
+/*
+ * Bridge reg08 bits 1-2 -> JPEG quality conversion table. Note the highest
+ * quality setting is not usable as USB 1 does not have enough bandwidth.
+ */
+static u8 jpeg_qual[] = {50, 75, 87, /* 94 */};
 
 /* usb exchanges */
 struct usb_action {
-- 
1.7.10


--------------010701000507090403000304
Content-Type: text/x-patch;
 name="0005-gspca_zc3xx-Use-get_jcomp-to-set-the-return-values-f.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-gspca_zc3xx-Use-get_jcomp-to-set-the-return-values-f.pa";
 filename*1="tch"

>From c2a220d6cdd33615cd8dbff21c2e877a4b03c28e Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 5 May 2012 14:54:17 +0200
Subject: [PATCH 5/6] gspca_zc3xx: Use get_jcomp to set the return values from
 set_jcomp

This way not only quality gets set to the achieved value, but the
other fields of the v4l2_jpegcompression struct also get properly set.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/zc3xx.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index a8282b8..5e00a7f 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -6975,16 +6975,6 @@ static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
 	return gspca_dev->usb_err;
 }
 
-static int sd_set_jcomp(struct gspca_dev *gspca_dev,
-			struct v4l2_jpegcompression *jcomp)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sd_setquality(gspca_dev, jcomp->quality);
-	jcomp->quality = sd->ctrls[QUALITY].val;
-	return gspca_dev->usb_err;
-}
-
 static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 			struct v4l2_jpegcompression *jcomp)
 {
@@ -6997,6 +6987,14 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
+static int sd_set_jcomp(struct gspca_dev *gspca_dev,
+			struct v4l2_jpegcompression *jcomp)
+{
+	sd_setquality(gspca_dev, jcomp->quality);
+	sd_get_jcomp(gspca_dev, jcomp);
+	return gspca_dev->usb_err;
+}
+
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
-- 
1.7.10


--------------010701000507090403000304
Content-Type: text/x-patch;
 name="0006-gspca_zc3xx-convert-to-the-control-framework.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0006-gspca_zc3xx-convert-to-the-control-framework.patch"

>From 6da72b85edbbcf8882d06ac1d4b9d0d991ab0142 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hans.verkuil@cisco.com>
Date: Sat, 28 Apr 2012 17:09:51 +0200
Subject: [PATCH 6/6] gspca_zc3xx: convert to the control framework

+ various bug-fixes to the conversion by Hans de Goede

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/zc3xx.c |  427 +++++++++++++++----------------------
 1 file changed, 167 insertions(+), 260 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 5e00a7f..633bb4c 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -22,6 +22,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/input.h>
+#include <media/v4l2-ctrls.h>
 #include "gspca.h"
 #include "jpeg.h"
 
@@ -35,26 +36,23 @@ static int force_sensor = -1;
 #define REG08_DEF 3		/* default JPEG compression (75%) */
 #include "zc3xx-reg.h"
 
-/* controls */
-enum e_ctrl {
-	BRIGHTNESS,
-	CONTRAST,
-	EXPOSURE,
-	GAMMA,
-	AUTOGAIN,
-	LIGHTFREQ,
-	SHARPNESS,
-	QUALITY,
-	NCTRLS		/* number of controls */
-};
-
-#define AUTOGAIN_DEF 1
-
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 
-	struct gspca_ctrl ctrls[NCTRLS];
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct { /* gamma/brightness/contrast control cluster */
+		struct v4l2_ctrl *gamma;
+		struct v4l2_ctrl *brightness;
+		struct v4l2_ctrl *contrast;
+	};
+	struct { /* autogain/exposure control cluster */
+		struct v4l2_ctrl *autogain;
+		struct v4l2_ctrl *exposure;
+	};
+	struct v4l2_ctrl *plfreq;
+	struct v4l2_ctrl *sharpness;
+	struct v4l2_ctrl *jpegqual;
 
 	struct work_struct work;
 	struct workqueue_struct *work_thread;
@@ -94,114 +92,6 @@ enum sensors {
 	SENSOR_MAX
 };
 
-/* V4L2 controls supported by the driver */
-static void setcontrast(struct gspca_dev *gspca_dev);
-static void setexposure(struct gspca_dev *gspca_dev);
-static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
-static void setlightfreq(struct gspca_dev *gspca_dev);
-static void setsharpness(struct gspca_dev *gspca_dev);
-static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val);
-
-static const struct ctrl sd_ctrls[NCTRLS] = {
-[BRIGHTNESS] = {
-	    {
-		.id      = V4L2_CID_BRIGHTNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Brightness",
-		.minimum = 0,
-		.maximum = 255,
-		.step    = 1,
-		.default_value = 128,
-	    },
-	    .set_control = setcontrast
-	},
-[CONTRAST] = {
-	    {
-		.id      = V4L2_CID_CONTRAST,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Contrast",
-		.minimum = 0,
-		.maximum = 255,
-		.step    = 1,
-		.default_value = 128,
-	    },
-	    .set_control = setcontrast
-	},
-[EXPOSURE] = {
-	    {
-		.id      = V4L2_CID_EXPOSURE,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Exposure",
-		.minimum = 0x30d,
-		.maximum	= 0x493e,
-		.step		= 1,
-		.default_value  = 0x927
-	    },
-	    .set_control = setexposure
-	},
-[GAMMA] = {
-	    {
-		.id      = V4L2_CID_GAMMA,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Gamma",
-		.minimum = 1,
-		.maximum = 6,
-		.step    = 1,
-		.default_value = 4,
-	    },
-	    .set_control = setcontrast
-	},
-[AUTOGAIN] = {
-	    {
-		.id      = V4L2_CID_AUTOGAIN,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Auto Gain",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = AUTOGAIN_DEF,
-		.flags   = V4L2_CTRL_FLAG_UPDATE
-	    },
-	    .set = sd_setautogain
-	},
-[LIGHTFREQ] = {
-	    {
-		.id	 = V4L2_CID_POWER_LINE_FREQUENCY,
-		.type    = V4L2_CTRL_TYPE_MENU,
-		.name    = "Light frequency filter",
-		.minimum = 0,
-		.maximum = 2,	/* 0: 0, 1: 50Hz, 2:60Hz */
-		.step    = 1,
-		.default_value = 0,
-	    },
-	    .set_control = setlightfreq
-	},
-[SHARPNESS] = {
-	    {
-		.id	 = V4L2_CID_SHARPNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Sharpness",
-		.minimum = 0,
-		.maximum = 3,
-		.step    = 1,
-		.default_value = 2,
-	    },
-	    .set_control = setsharpness
-	},
-[QUALITY] = {
-	    {
-		.id	 = V4L2_CID_JPEG_COMPRESSION_QUALITY,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Compression Quality",
-		.minimum = 50,
-		.maximum = 87,
-		.step    = 1,
-		.default_value = 75,
-	    },
-	    .set = sd_setquality
-	},
-};
-
 static const struct v4l2_pix_format vga_mode[] = {
 	{320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
 		.bytesperline = 320,
@@ -5821,10 +5711,8 @@ static void setmatrix(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, matrix[i], 0x010a + i);
 }
 
-static void setsharpness(struct gspca_dev *gspca_dev)
+static void setsharpness(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	int sharpness;
 	static const u8 sharpness_tb[][2] = {
 		{0x02, 0x03},
 		{0x04, 0x07},
@@ -5832,19 +5720,18 @@ static void setsharpness(struct gspca_dev *gspca_dev)
 		{0x10, 0x1e}
 	};
 
-	sharpness = sd->ctrls[SHARPNESS].val;
-	reg_w(gspca_dev, sharpness_tb[sharpness][0], 0x01c6);
+	reg_w(gspca_dev, sharpness_tb[val][0], 0x01c6);
 	reg_r(gspca_dev, 0x01c8);
 	reg_r(gspca_dev, 0x01c9);
 	reg_r(gspca_dev, 0x01ca);
-	reg_w(gspca_dev, sharpness_tb[sharpness][1], 0x01cb);
+	reg_w(gspca_dev, sharpness_tb[val][1], 0x01cb);
 }
 
-static void setcontrast(struct gspca_dev *gspca_dev)
+static void setcontrast(struct gspca_dev *gspca_dev,
+		s32 gamma, s32 brightness, s32 contrast)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
 	const u8 *Tgamma;
-	int g, i, brightness, contrast, adj, gp1, gp2;
+	int g, i, adj, gp1, gp2;
 	u8 gr[16];
 	static const u8 delta_b[16] =		/* delta for brightness */
 		{0x50, 0x38, 0x2d, 0x28, 0x24, 0x21, 0x1e, 0x1d,
@@ -5867,10 +5754,10 @@ static void setcontrast(struct gspca_dev *gspca_dev)
 		 0xe0, 0xeb, 0xf4, 0xff, 0xff, 0xff, 0xff, 0xff},
 	};
 
-	Tgamma = gamma_tb[sd->ctrls[GAMMA].val - 1];
+	Tgamma = gamma_tb[gamma - 1];
 
-	contrast = ((int) sd->ctrls[CONTRAST].val - 128); /* -128 / 127 */
-	brightness = ((int) sd->ctrls[BRIGHTNESS].val - 128); /* -128 / 92 */
+	contrast -= 128; /* -128 / 127 */
+	brightness -= 128; /* -128 / 92 */
 	adj = 0;
 	gp1 = gp2 = 0;
 	for (i = 0; i < 16; i++) {
@@ -5897,25 +5784,15 @@ static void setcontrast(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, gr[i], 0x0130 + i);	/* gradient */
 }
 
-static void getexposure(struct gspca_dev *gspca_dev)
+static s32 getexposure(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	if (sd->sensor != SENSOR_HV7131R)
-		return;
-	sd->ctrls[EXPOSURE].val = (i2c_read(gspca_dev, 0x25) << 9)
+	return (i2c_read(gspca_dev, 0x25) << 9)
 		| (i2c_read(gspca_dev, 0x26) << 1)
 		| (i2c_read(gspca_dev, 0x27) >> 7);
 }
 
-static void setexposure(struct gspca_dev *gspca_dev)
+static void setexposure(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	int val;
-
-	if (sd->sensor != SENSOR_HV7131R)
-		return;
-	val = sd->ctrls[EXPOSURE].val;
 	i2c_write(gspca_dev, 0x25, val >> 9, 0x00);
 	i2c_write(gspca_dev, 0x26, val >> 1, 0x00);
 	i2c_write(gspca_dev, 0x27, val << 7, 0x00);
@@ -5934,7 +5811,7 @@ static void setquality(struct gspca_dev *gspca_dev)
  *	60Hz, for American lighting
  *	0 = No Fliker (for outdoore usage)
  */
-static void setlightfreq(struct gspca_dev *gspca_dev)
+static void setlightfreq(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, mode;
@@ -6018,7 +5895,7 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
 		 tas5130c_60HZ, tas5130c_60HZScale},
 	};
 
-	i = sd->ctrls[LIGHTFREQ].val * 2;
+	i = val * 2;
 	mode = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
 	if (mode)
 		i++;			/* 320x240 */
@@ -6028,14 +5905,14 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
 	usb_exchange(gspca_dev, zc3_freq);
 	switch (sd->sensor) {
 	case SENSOR_GC0305:
-		if (mode				/* if 320x240 */
-		    && sd->ctrls[LIGHTFREQ].val == 1)	/* and 50Hz */
+		if (mode		/* if 320x240 */
+		    && val == 1)	/* and 50Hz */
 			reg_w(gspca_dev, 0x85, 0x018d);
 					/* win: 0x80, 0x018d */
 		break;
 	case SENSOR_OV7620:
-		if (!mode) {				/* if 640x480 */
-			if (sd->ctrls[LIGHTFREQ].val != 0) /* and filter */
+		if (!mode) {		/* if 640x480 */
+			if (val != 0)	/* and filter */
 				reg_w(gspca_dev, 0x40, 0x0002);
 			else
 				reg_w(gspca_dev, 0x44, 0x0002);
@@ -6047,16 +5924,9 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void setautogain(struct gspca_dev *gspca_dev)
+static void setautogain(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	u8 autoval;
-
-	if (sd->ctrls[AUTOGAIN].val)
-		autoval = 0x42;
-	else
-		autoval = 0x02;
-	reg_w(gspca_dev, autoval, 0x0180);
+	reg_w(gspca_dev, val ? 0x42 : 0x02, 0x0180);
 }
 
 /*
@@ -6449,7 +6319,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	/* define some sensors from the vendor/product */
 	sd->sensor = id->driver_info;
 
-	gspca_dev->cam.ctrls = sd->ctrls;
 	sd->reg08 = REG08_DEF;
 
 	INIT_WORK(&sd->work, transfer_update);
@@ -6457,10 +6326,97 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
+static int zcxx_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		mutex_lock(&gspca_dev->usb_lock);
+		gspca_dev->usb_err = 0;
+		if (ctrl->val && sd->exposure && gspca_dev->streaming)
+			sd->exposure->val = getexposure(gspca_dev);
+		ret = gspca_dev->usb_err;
+		mutex_unlock(&gspca_dev->usb_lock);
+		break;
+	}
+	return ret;
+}
+
+static int zcxx_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+	int i, qual, ret = 0;
+
+	mutex_lock(&gspca_dev->usb_lock);
+	gspca_dev->usb_err = 0;
+
+	if (!gspca_dev->streaming &&
+			ctrl->id != V4L2_CID_JPEG_COMPRESSION_QUALITY)
+		goto leave;
+
+	switch (ctrl->id) {
+	/* gamma/brightness/contrast cluster */
+	case V4L2_CID_GAMMA:
+		setcontrast(gspca_dev, sd->gamma->val,
+				sd->brightness->val, sd->contrast->val);
+		break;
+	/* autogain/exposure cluster */
+	case V4L2_CID_AUTOGAIN:
+		setautogain(gspca_dev, ctrl->val);
+		if (!gspca_dev->usb_err && !ctrl->val && sd->exposure)
+			setexposure(gspca_dev, sd->exposure->val);
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		setlightfreq(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_SHARPNESS:
+		setsharpness(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		qual = sd->reg08 >> 1;
+
+		for (i = 0; i < ARRAY_SIZE(jpeg_qual); i++) {
+			if (ctrl->val <= jpeg_qual[i])
+				break;
+		}
+		if (i > 0 && i == qual && ctrl->val < jpeg_qual[i])
+			i--;
+
+		/* With high quality settings we need max bandwidth */
+		if (i >= 2 && gspca_dev->streaming &&
+		    !gspca_dev->cam.needs_full_bandwidth) {
+			ret = -EBUSY;
+			goto leave;
+		}
+
+		sd->reg08 = (i << 1) | 1;
+		ctrl->val = jpeg_qual[i];
+
+		if (gspca_dev->streaming)
+			setquality(gspca_dev);
+
+		break;
+	}
+	ret = gspca_dev->usb_err;
+leave:
+	mutex_unlock(&gspca_dev->usb_lock);
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops zcxx_ctrl_ops = {
+	.g_volatile_ctrl = zcxx_g_volatile_ctrl,
+	.s_ctrl = zcxx_s_ctrl,
+};
+
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
 	struct cam *cam;
 	int sensor;
 	static const u8 gamma[SENSOR_MAX] = {
@@ -6613,7 +6569,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		case 0x2030:
 			PDEBUG(D_PROBE, "Find Sensor PO2030");
 			sd->sensor = SENSOR_PO2030;
-			sd->ctrls[SHARPNESS].def = 0;	/* from win traces */
 			break;
 		case 0x7620:
 			PDEBUG(D_PROBE, "Find Sensor OV7620");
@@ -6655,25 +6610,38 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		break;
 	}
 
-	sd->ctrls[GAMMA].def = gamma[sd->sensor];
-	sd->ctrls[QUALITY].def = jpeg_qual[sd->reg08 >> 1];
-	sd->ctrls[QUALITY].min = jpeg_qual[0];
-	sd->ctrls[QUALITY].max = jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1];
-
-	switch (sd->sensor) {
-	case SENSOR_HV7131R:
-		break;
-	case SENSOR_OV7630C:
-		gspca_dev->ctrl_dis = (1 << LIGHTFREQ) | (1 << EXPOSURE);
-		break;
-	default:
-		gspca_dev->ctrl_dis = (1 << EXPOSURE);
-		break;
+	gspca_dev->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(hdl, 8);
+	sd->brightness = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	sd->contrast = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	sd->gamma = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_GAMMA, 1, 6, 1, gamma[sd->sensor]);
+	if (sd->sensor == SENSOR_HV7131R)
+		sd->exposure = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0x30d, 0x493e, 1, 0x927);
+	sd->autogain = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	if (sd->sensor != SENSOR_OV7630C)
+		sd->plfreq = v4l2_ctrl_new_std_menu(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_POWER_LINE_FREQUENCY,
+			V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 0,
+			V4L2_CID_POWER_LINE_FREQUENCY_DISABLED);
+	sd->sharpness = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_SHARPNESS, 0, 3, 1,
+			sd->sensor == SENSOR_PO2030 ? 0 : 2);
+	sd->jpegqual = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY,
+			jpeg_qual[0], jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1], 1,
+			jpeg_qual[REG08_DEF >> 1]);
+	if (hdl->error) {
+		pr_err("Could not initialize controls\n");
+		return hdl->error;
 	}
-#if AUTOGAIN_DEF
-	if (sd->ctrls[AUTOGAIN].val)
-		gspca_dev->ctrl_inac = (1 << EXPOSURE);
-#endif
+	v4l2_ctrl_cluster(3, &sd->gamma);
+	if (sd->sensor == SENSOR_HV7131R)
+		v4l2_ctrl_auto_cluster(2, &sd->autogain, 0, true);
 
 	/* switch off the led */
 	reg_w(gspca_dev, 0x01, 0x0000);
@@ -6791,7 +6759,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x03, 0x0008);
 		break;
 	}
-	setsharpness(gspca_dev);
+	setsharpness(gspca_dev, v4l2_ctrl_g_ctrl(sd->sharpness));
 
 	/* set the gamma tables when not set */
 	switch (sd->sensor) {
@@ -6800,7 +6768,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	case SENSOR_OV7630C:
 		break;
 	default:
-		setcontrast(gspca_dev);
+		setcontrast(gspca_dev, v4l2_ctrl_g_ctrl(sd->gamma),
+				v4l2_ctrl_g_ctrl(sd->brightness),
+				v4l2_ctrl_g_ctrl(sd->contrast));
 		break;
 	}
 	setmatrix(gspca_dev);			/* one more time? */
@@ -6814,7 +6784,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	setquality(gspca_dev);
 	/* Start with BRC disabled, transfer_update will enable it if needed */
 	reg_w(gspca_dev, 0x00, 0x0007);
-	setlightfreq(gspca_dev);
+	if (sd->plfreq)
+		setlightfreq(gspca_dev, v4l2_ctrl_g_ctrl(sd->plfreq));
 
 	switch (sd->sensor) {
 	case SENSOR_ADCM2700:
@@ -6825,7 +6796,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x40, 0x0117);
 		break;
 	case SENSOR_HV7131R:
-		setexposure(gspca_dev);
+		setexposure(gspca_dev, v4l2_ctrl_g_ctrl(sd->exposure));
 		reg_w(gspca_dev, 0x00, ZC3XX_R1A7_CALCGLOBALMEAN);
 		break;
 	case SENSOR_GC0305:
@@ -6849,7 +6820,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		break;
 	}
 
-	setautogain(gspca_dev);
+	setautogain(gspca_dev, v4l2_ctrl_g_ctrl(sd->autogain));
 
 	if (gspca_dev->usb_err < 0)
 		return gspca_dev->usb_err;
@@ -6910,78 +6881,13 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
 }
 
-static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sd->ctrls[AUTOGAIN].val = val;
-	if (val) {
-		gspca_dev->ctrl_inac |= (1 << EXPOSURE);
-	} else {
-		gspca_dev->ctrl_inac &= ~(1 << EXPOSURE);
-		if (gspca_dev->streaming)
-			getexposure(gspca_dev);
-	}
-	if (gspca_dev->streaming)
-		setautogain(gspca_dev);
-	return gspca_dev->usb_err;
-}
-
-static int sd_querymenu(struct gspca_dev *gspca_dev,
-			struct v4l2_querymenu *menu)
-{
-	switch (menu->id) {
-	case V4L2_CID_POWER_LINE_FREQUENCY:
-		switch (menu->index) {
-		case 0:		/* V4L2_CID_POWER_LINE_FREQUENCY_DISABLED */
-			strcpy((char *) menu->name, "NoFliker");
-			return 0;
-		case 1:		/* V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
-			strcpy((char *) menu->name, "50 Hz");
-			return 0;
-		case 2:		/* V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
-			strcpy((char *) menu->name, "60 Hz");
-			return 0;
-		}
-		break;
-	}
-	return -EINVAL;
-}
-
-static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	int i, qual = sd->reg08 >> 1;
-
-	for (i = 0; i < ARRAY_SIZE(jpeg_qual); i++) {
-		if (val <= jpeg_qual[i])
-			break;
-	}
-	if (i > 0
-	 && i == qual
-	 && val < jpeg_qual[i])
-		i--;
-
-	/* With high quality settings we need max bandwidth */
-	if (i >= 2 && gspca_dev->streaming &&
-	    !gspca_dev->cam.needs_full_bandwidth)
-		return -EBUSY;
-
-	sd->reg08 = (i << 1) | 1;
-	sd->ctrls[QUALITY].val = jpeg_qual[i];
-
-	if (gspca_dev->streaming)
-		setquality(gspca_dev);
-	return gspca_dev->usb_err;
-}
-
 static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 			struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	memset(jcomp, 0, sizeof *jcomp);
-	jcomp->quality = sd->ctrls[QUALITY].val;
+	jcomp->quality = v4l2_ctrl_g_ctrl(sd->jpegqual);
 	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
 			| V4L2_JPEG_MARKER_DQT;
 	return 0;
@@ -6990,9 +6896,13 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 static int sd_set_jcomp(struct gspca_dev *gspca_dev,
 			struct v4l2_jpegcompression *jcomp)
 {
-	sd_setquality(gspca_dev, jcomp->quality);
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
+
+	ret = v4l2_ctrl_s_ctrl(sd->jpegqual, jcomp->quality);
 	sd_get_jcomp(gspca_dev, jcomp);
-	return gspca_dev->usb_err;
+
+	return ret;
 }
 
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
@@ -7013,15 +6923,12 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 
 static const struct sd_desc sd_desc = {
 	.name = KBUILD_MODNAME,
-	.ctrls = sd_ctrls,
-	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = sd_config,
 	.init = sd_init,
 	.isoc_init = sd_pre_start,
 	.start = sd_start,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
-	.querymenu = sd_querymenu,
 	.get_jcomp = sd_get_jcomp,
 	.set_jcomp = sd_set_jcomp,
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
-- 
1.7.10


--------------010701000507090403000304--
