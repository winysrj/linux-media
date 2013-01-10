Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:48413 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932570Ab3AJHxv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 02:53:51 -0500
From: Libin Yang <lbyang@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Albert Wang <twang13@marvell.com>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 9 Jan 2013 23:53:42 -0800
Subject: RE: [PATCH V3 06/15] [media] marvell-ccic: add new formats support
 for marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230B0B3D36@SC-VEXCH4.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-7-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1301011734070.31619@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1301011734070.31619@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Below is the update for widthy, widthuv and imgsz_w setting.

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, January 02, 2013 12:56 AM
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 06/15] [media] marvell-ccic: add new formats support for
>marvell-ccic driver
>
>On Sat, 15 Dec 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the new formats support for marvell-ccic.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c |  175 ++++++++++++++++++-----
>>  drivers/media/platform/marvell-ccic/mcam-core.h |    6 +
>>  2 files changed, 149 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c
>b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index 3cc1d0c..a679917 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
>
>[snip]
>
>> @@ -658,49 +708,85 @@ static inline void mcam_sg_restart(struct mcam_camera *cam)
>>   */
>>  static void mcam_ctlr_image(struct mcam_camera *cam)
>>  {
>> -	int imgsz;
>>  	struct v4l2_pix_format *fmt = &cam->pix_format;
>> +	u32 widthy = 0, widthuv = 0, imgsz_h, imgsz_w;
>> +
>> +	cam_dbg(cam, "camera: bytesperline = %d; height = %d\n",
>> +		fmt->bytesperline, fmt->sizeimage / fmt->bytesperline);
>> +	imgsz_h = (fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK;
>> +	imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
>> +
>> +	switch (fmt->pixelformat) {
>> +	case V4L2_PIX_FMT_YUYV:
>> +	case V4L2_PIX_FMT_UYVY:
>> +		widthy = fmt->width * 2;
>> +		widthuv = 0;
>> +		break;
>> +	case V4L2_PIX_FMT_JPEG:
>> +		imgsz_h = (fmt->sizeimage / fmt->bytesperline) << IMGSZ_V_SHIFT;
>> +		widthy = fmt->bytesperline;
>> +		widthuv = 0;
>> +		break;
>> +	case V4L2_PIX_FMT_YUV422P:
>> +	case V4L2_PIX_FMT_YUV420:
>> +	case V4L2_PIX_FMT_YVU420:
>> +		imgsz_w = (fmt->bytesperline * 4 / 3) & IMGSZ_H_MASK;
>> +		widthy = fmt->width;
>> +		widthuv = fmt->width / 2;
>
>I might be wrong, but the above doesn't look right to me. Firstly, YUV422P
>is a 4:2:2 format, whereas YUV420 and YVU420 are 4:2:0 formats, so, I
>would expect calculations for them to differ. Besides, bytesperline * 4 /
>3 doesn't look right for any of them. If this is what I think - total
>number of bytes per line, i.e., sizeimage / height, than shouldn't YAU422P
>have
>+		imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
>and the other two
>+		imgsz_w = (fmt->bytesperline * 3 / 2) & IMGSZ_H_MASK;
>? But maybe I'm wrong, please, double-check and confirm.
>

First of all, the setting bytesperline in this file is wrong. It should be
like the setting in the mcam-core-soc.c in the later patch. It's my fault
missing modifying the bytesperline when adding the new formats.
Besides the bytesperline in mcam-core-soc.c is a little wrong.
I will update it in the new version of patch.

For imgsz_w setting, this is for the CCIC input data format, which is from
sensor, while 'switch (fmt->pixelformat)' is CCIC output data format.
It seems a little confusing using fmt->pixelformat here. Using
mcam_formats->mbus_code seems more reasonable. Anyway, 
each fmt->pixelformat must have one mcam_formats->mbus_code
correspondingly. 

Although, our spec says it supports YUV420 input. Our HW team told me
we only use YUV422 and the length is width * 2. So it seems some 
mbus_code is wrong set here.
It seems in this case such format will be never used as we can see
ov7670 does not support yuv420.

Regards,
Libin
