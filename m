Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35667 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933402AbcKNK13 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 05:27:29 -0500
Received: by mail-wm0-f50.google.com with SMTP id a197so89160558wmd.0
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2016 02:27:28 -0800 (PST)
Subject: Re: [PATCH v3 5/9] media: venus: venc: add video encoder files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-6-git-send-email-stanimir.varbanov@linaro.org>
 <5e918c07-c3fb-262a-5c9e-11014cdb0eb0@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <9e4549e5-4e24-8aaa-bf8a-549f7906c207@linaro.org>
Date: Mon, 14 Nov 2016 12:27:25 +0200
MIME-Version: 1.0
In-Reply-To: <5e918c07-c3fb-262a-5c9e-11014cdb0eb0@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments!

On 11/11/2016 01:43 PM, Hans Verkuil wrote:
> The comments I made before about start_streaming and the use of struct venus_ctrl
> apply here as well and I won't repeat them.
> 
> On 11/07/2016 06:33 PM, Stanimir Varbanov wrote:
>> This adds encoder part of the driver plus encoder controls.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/venc.c       | 1212 ++++++++++++++++++++++++
>>  drivers/media/platform/qcom/venus/venc.h       |   32 +
>>  drivers/media/platform/qcom/venus/venc_ctrls.c |  396 ++++++++
>>  3 files changed, 1640 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/venus/venc.c
>>  create mode 100644 drivers/media/platform/qcom/venus/venc.h
>>  create mode 100644 drivers/media/platform/qcom/venus/venc_ctrls.c
>>
>> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
>> new file mode 100644
>> index 000000000000..35572eaffb9e
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/venus/venc.c
> 
> <snip>
> 
>> +static int
>> +venc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
>> +{
>> +	struct venus_inst *inst = to_inst(file);
>> +
>> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>> +		return -EINVAL;
>> +
>> +	switch (s->target) {
>> +	case V4L2_SEL_TGT_CROP:
>> +		if (s->r.width != inst->out_width ||
>> +		    s->r.height != inst->out_height ||
>> +		    s->r.top != 0 || s->r.left != 0)
>> +			return -EINVAL;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> Why implement s_selection if I can't change the selection?

without s_selection the v4l2-compliance test starts failing with:

fail: v4l2-test-formats.cpp(1319): doioctl(node, VIDIOC_S_SELECTION,
&sel_crop) != EINVAL

fail: v4l2-test-formats.cpp(1407): testBasicCrop(node,
V4L2_BUF_TYPE_VIDEO_OUTPUT)

> 
>> +
>> +static int
>> +venc_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
>> +{
>> +	struct vb2_queue *queue = to_vb2q(file, b->type);
>> +
>> +	if (!queue)
>> +		return -EINVAL;
>> +
>> +	return vb2_reqbufs(queue, b);
>> +}
> 
> Use the m2m helpers if at all possible.

I've answered already to that in 4/9.

-- 
regards,
Stan
