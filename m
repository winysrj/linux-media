Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38124 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1LLOkD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 09:40:03 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW300061I2OJU@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 14:40:00 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3007WQI2OJ9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 14:40:00 +0000 (GMT)
Date: Mon, 12 Dec 2011 15:39:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v3 4/4] v4l: Update subdev drivers to handle
 framesamples parameter
In-reply-to: <201112120131.24192.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, m.szyprowski@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EE6123F.1040709@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <201112061712.30748.laurent.pinchart@ideasonboard.com>
 <1323453592-17782-1-git-send-email-s.nawrocki@samsung.com>
 <201112120131.24192.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/12/2011 01:31 AM, Laurent Pinchart wrote:
> On Friday 09 December 2011 18:59:52 Sylwester Nawrocki wrote:
>> Update the sub-device drivers having a devnode enabled so they properly
>> handle the new framesamples field of struct v4l2_mbus_framefmt.
>> These drivers don't support compressed (entropy encoded) formats so the
>> framesamples field is simply initialized to 0, altogether with the
>> reserved structure member.
>>
>> There is a few other drivers that expose a devnode (mt9p031, mt9t001,
>> mt9v032), but they already implicitly initialize the new data structure
>> field to 0, so they don't need to be touched.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Hi,
>>
>> In this version the whole reserved field in struct v4l2_mbus_framefmt
>> is also cleared, rather than setting only framesamples to 0.
>>
>> The omap3isp driver changes have been only compile tested.
>>
>> Thanks,
>> Sylwester
>> ---
>>  drivers/media/video/noon010pc30.c         |    5 ++++-
>>  drivers/media/video/omap3isp/ispccdc.c    |    2 ++
>>  drivers/media/video/omap3isp/ispccp2.c    |    2 ++
>>  drivers/media/video/omap3isp/ispcsi2.c    |    2 ++
>>  drivers/media/video/omap3isp/isppreview.c |    2 ++
>>  drivers/media/video/omap3isp/ispresizer.c |    2 ++
>>  drivers/media/video/s5k6aa.c              |    2 ++
>>  7 files changed, 16 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/noon010pc30.c
>> b/drivers/media/video/noon010pc30.c index 50838bf..5af9b60 100644
>> --- a/drivers/media/video/noon010pc30.c
>> +++ b/drivers/media/video/noon010pc30.c
>> @@ -519,13 +519,14 @@ static int noon010_get_fmt(struct v4l2_subdev *sd,
>> struct v4l2_subdev_fh *fh, mf = &fmt->format;
>>
>>  	mutex_lock(&info->lock);
>> +	memset(mf, 0, sizeof(mf));
>>  	mf->width = info->curr_win->width;
>>  	mf->height = info->curr_win->height;
>>  	mf->code = info->curr_fmt->code;
>>  	mf->colorspace = info->curr_fmt->colorspace;
>>  	mf->field = V4L2_FIELD_NONE;
>> -
>>  	mutex_unlock(&info->lock);
>> +
>>  	return 0;
>>  }
>>
>> @@ -546,12 +547,14 @@ static const struct noon010_format
>> *noon010_try_fmt(struct v4l2_subdev *sd, static int noon010_set_fmt(struct
>> v4l2_subdev *sd, struct v4l2_subdev_fh *fh, struct v4l2_subdev_format
>> *fmt)
>>  {
>> +	const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
>>  	struct noon010_info *info = to_noon010(sd);
>>  	const struct noon010_frmsize *size = NULL;
>>  	const struct noon010_format *nf;
>>  	struct v4l2_mbus_framefmt *mf;
>>  	int ret = 0;
>>
>> +	memset(&fmt->format + offset, 0, sizeof(fmt->format) - offset);
> 
> I'm not sure this is a good idea, as it will break when a new field will be 
> added to struct v4l2_mbus_framefmt.

I'm not sure it will break. Now there everything cleared after (and including)
framesamples field.

struct v4l2_mbus_framefmt {
        __u32                   width;
        __u32                   height;
        __u32                   code;
        __u32                   field;
        __u32                   colorspace;
        __u32                   framesamples;
        __u32                   reserved[6];
};

Assuming we convert reserved[0] to new_field

struct v4l2_mbus_framefmt {
        __u32                   width;
        __u32                   height;
        __u32                   code;
        __u32                   field;
        __u32                   colorspace;
        __u32                   framesamples;
        __u32                   new_field;
        __u32                   reserved[5];
};

the code:

const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
memset(&fmt->format + offset, 0, sizeof(fmt->format) - offset);

would still clear 7 u32' at the structure end, wouldn't it?

> 
> Wouldn't it be better to zero the whoel structure in the callers instead ?

-- 

Regards
Sylwester
