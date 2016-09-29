Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34578 "EHLO
        mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753030AbcI2AxO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 20:53:14 -0400
Received: by mail-pa0-f43.google.com with SMTP id dw4so8014281pac.1
        for <linux-media@vger.kernel.org>; Wed, 28 Sep 2016 17:53:13 -0700 (PDT)
Subject: Re: [PATCH v2 4/8] media: vidc: encoder: add video encoder files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
 <1473248229-5540-5-git-send-email-stanimir.varbanov@linaro.org>
 <18374b1c-f3b3-4eda-6c05-cf364b1bef81@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <7538007e-1337-2dcb-78b1-5900adb871a2@linaro.org>
Date: Thu, 29 Sep 2016 03:53:09 +0300
MIME-Version: 1.0
In-Reply-To: <18374b1c-f3b3-4eda-6c05-cf364b1bef81@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/19/2016 01:15 PM, Hans Verkuil wrote:
> Many of my review comments for the decoder apply to the encoder as well,
> so I won't repeat those.

Sure, will address them too.

> 
> On 09/07/2016 01:37 PM, Stanimir Varbanov wrote:
>> This adds encoder part of the driver plus encoder controls.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/vidc/venc.c       | 1252 +++++++++++++++++++++++++
>>  drivers/media/platform/qcom/vidc/venc.h       |   29 +
>>  drivers/media/platform/qcom/vidc/venc_ctrls.c |  396 ++++++++
>>  drivers/media/platform/qcom/vidc/venc_ctrls.h |   23 +
>>  4 files changed, 1700 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/vidc/venc.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/venc.h
>>  create mode 100644 drivers/media/platform/qcom/vidc/venc_ctrls.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/venc_ctrls.h
>>
>> diff --git a/drivers/media/platform/qcom/vidc/venc.c b/drivers/media/platform/qcom/vidc/venc.c
>> new file mode 100644
>> index 000000000000..3b65f851a807
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/venc.c
>> @@ -0,0 +1,1252 @@
> 
> <snip>
> 
>> +static int venc_s_selection(struct file *file, void *fh,
>> +			    struct v4l2_selection *s)
>> +{
>> +	return -EINVAL;
>> +}
> 
> Huh? Either remove this, or implement this correctly.

OK, I cannot remember why I keep it this way, might be v4l2-compliance

> 
> <snip>
> 
>> +static int venc_subscribe_event(struct v4l2_fh *fh,
>> +				const struct  v4l2_event_subscription *sub)
>> +{
>> +	switch (sub->type) {
>> +	case V4L2_EVENT_EOS:
>> +		return v4l2_event_subscribe(fh, sub, 2, NULL);
>> +	case V4L2_EVENT_SOURCE_CHANGE:
>> +		return v4l2_src_change_event_subscribe(fh, sub);
> 
> These two events aren't used in this driver AFAICT, so this can be dropped.
> 
> Since that leaves just V4L2_EVENT_CTRL this function can be replaced by
> v4l2_ctrl_subscribe_event().

sure I can remove it.

-- 
regards,
Stan
