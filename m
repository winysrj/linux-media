Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37037 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbcLEMdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 07:33:49 -0500
Received: by mail-wm0-f51.google.com with SMTP id t79so90435594wmt.0
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2016 04:33:48 -0800 (PST)
Subject: Re: [PATCH v4 5/9] media: venus: vdec: add video decoder files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1480583001-32236-1-git-send-email-stanimir.varbanov@linaro.org>
 <1480583001-32236-6-git-send-email-stanimir.varbanov@linaro.org>
 <4457b2fe-3e47-5085-0c08-7fe69b2b46b5@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <4a016b0a-f10f-99c2-4e48-6110b3fb4f48@linaro.org>
Date: Mon, 5 Dec 2016 14:25:18 +0200
MIME-Version: 1.0
In-Reply-To: <4457b2fe-3e47-5085-0c08-7fe69b2b46b5@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments!

On 12/05/2016 01:32 PM, Hans Verkuil wrote:
> I have two comments (and the same two comments apply to the video encoder patch
> as well):
> 
> On 12/01/2016 10:03 AM, Stanimir Varbanov wrote:
>> This consists of video decoder implementation plus decoder
>> controls.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/vdec.c       | 976 +++++++++++++++++++++++++
>>  drivers/media/platform/qcom/venus/vdec.h       |  32 +
>>  drivers/media/platform/qcom/venus/vdec_ctrls.c | 149 ++++
>>  3 files changed, 1157 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/venus/vdec.c
>>  create mode 100644 drivers/media/platform/qcom/venus/vdec.h
>>  create mode 100644 drivers/media/platform/qcom/venus/vdec_ctrls.c
>>
>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
>> new file mode 100644
>> index 000000000000..9f585a1e0ff1
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>> @@ -0,0 +1,976 @@
> 
> <snip>
> 
>> +static int
>> +vdec_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
>> +{
>> +	struct venus_inst *inst = to_inst(file);
>> +
>> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
>> +	    s->target != V4L2_SEL_TGT_COMPOSE)
>> +		return -EINVAL;
>> +
>> +	switch (s->target) {
>> +	case V4L2_SEL_TGT_COMPOSE:
>> +		s->r.width = inst->out_width;
>> +		s->r.height = inst->out_height;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	s->r.top = 0;
>> +	s->r.left = 0;
>> +
>> +	return 0;
>> +}
> 
> This doesn't actually set anything, so what's the point of this function?
> 
> I've fixed the corresponding test in v4l2-compliance so you can now drop this
> op and v4l2-compliance won't complain anymore.

OK I will give a try.

> 
>> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>> +{
>> +	struct venus_inst *inst = vb2_get_drv_priv(q);
>> +	struct venus_core *core = inst->core;
>> +	struct device *dev = core->dev;
>> +	u32 ptype;
>> +	int ret;
>> +
>> +	mutex_lock(&inst->lock);
>> +
>> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		inst->streamon_out = 1;
>> +	else
>> +		inst->streamon_cap = 1;
>> +
>> +	if (!(inst->streamon_out & inst->streamon_cap)) {
>> +		mutex_unlock(&inst->lock);
>> +		return 0;
>> +	}
>> +
>> +	inst->reconfig = false;
>> +	inst->sequence = 0;
>> +	inst->codec_cfg = false;
>> +
>> +	ret = pm_runtime_get_sync(dev);
>> +	if (ret < 0)
>> +		return ret;
> 
> This should be a goto so that 'helper_buffers_done(inst, VB2_BUF_STATE_QUEUED);'
> is called on error.
> 
> It's wrong anyway since you don't unlock the mutex in this return path either.

yes, this return is wrong, will correct it in next version.

-- 
regards,
Stan
