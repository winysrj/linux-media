Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36792 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754397AbcKCKp1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 06:45:27 -0400
Received: by mail-wm0-f54.google.com with SMTP id p190so324103157wmp.1
        for <linux-media@vger.kernel.org>; Thu, 03 Nov 2016 03:45:27 -0700 (PDT)
Subject: Re: [PATCH v2 3/8] media: vidc: decoder: add video decoder files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
 <1473248229-5540-4-git-send-email-stanimir.varbanov@linaro.org>
 <40feffa4-68a3-d4e9-12ee-e3e5b5f08349@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <20aa8a6d-d1a6-c4e4-761d-71460629ff7f@linaro.org>
Date: Thu, 3 Nov 2016 12:45:20 +0200
MIME-Version: 1.0
In-Reply-To: <40feffa4-68a3-d4e9-12ee-e3e5b5f08349@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/19/2016 01:04 PM, Hans Verkuil wrote:
> On 09/07/2016 01:37 PM, Stanimir Varbanov wrote:
>> This consists of video decoder implementation plus decoder
>> controls.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/vidc/vdec.c       | 1091 +++++++++++++++++++++++++
>>  drivers/media/platform/qcom/vidc/vdec.h       |   29 +
>>  drivers/media/platform/qcom/vidc/vdec_ctrls.c |  200 +++++
>>  drivers/media/platform/qcom/vidc/vdec_ctrls.h |   21 +
>>  4 files changed, 1341 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/vidc/vdec.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/vdec.h
>>  create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.h
>>

<cut>

>> +
>> +static int
>> +vdec_g_selection(struct file *file, void *priv, struct v4l2_selection *s)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +
>> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +		return -EINVAL;
>> +
>> +	switch (s->target) {
>> +	case V4L2_SEL_TGT_CROP_DEFAULT:
>> +	case V4L2_SEL_TGT_CROP_BOUNDS:
>> +	case V4L2_SEL_TGT_CROP:
>> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>> +	case V4L2_SEL_TGT_COMPOSE:
> 
> This is almost certainly wrong.
> 
> For capture I would expect that you can do compose, but not crop.
> 
> This would likely explain that v4l2-compliance thinks that the driver can
> scale:
> 
>                 test Scaling: OK
> 

Maybe I need some help to implement correctly g_selection.

Lets say that the resolution of the compressed stream is 1280x720, and
that resolution is set with s_fmt(OUTPUT queue), then I calculate the
output resolution which I will return by g_fmt(CAPTURE queue) and it
will be 1280x736 (hardware wants height to be multiple of 32 lines). So
the result will be 16 lines of vertical padding which should be exposed
to client (think of gstreamer v4l2videodec element) via g_crop
(g_selection) as 1280x720 because this is the actual image.

So from what I understood while read Selection API, I need to support
only composing on CAPTURE queue, no scaling and no cropping.

OUTPUT buffer type, data source
TGT_CROP_BOUNDS = TGT_CROP_DEFAULT = TGT_CROP = 1280x720
TGT_COMPOSE_BOUNDS = TGT_COMPOSE_DEFAULT = TGT_COMPOSE = 1280x720

CAPTURE buffer type, data sink
TGT_CROP_BOUNDS = TGT_CROP_DEFAULT = TGT_CROP = EINVAL
TGT_COMPOSE_BOUNDS = 1280x736
TGT_COMPOSE_DEFAULT = TGT_COMPOSE = 1280x720

With this logic in g_selection the output of v4l2-compliance test
application is:
	test Cropping: OK
	test Composing: OK
	test Scaling: OK (Not Supported)

So why v4l2-compliance still thinks that the driver supports Cropping?

>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	s->r.top = 0;
>> +	s->r.left = 0;
>> +	s->r.width = inst->out_width;
>> +	s->r.height = inst->out_height;
>> +
>> +	return 0;
>> +}

<cut>

-- 
regards,
Stan
