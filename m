Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:57702 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbbALPij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 10:38:39 -0500
Message-ID: <54B3EA71.9020005@xs4all.nl>
Date: Mon, 12 Jan 2015 16:38:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [RFC PATCH] [media] coda: Use S_PARM to set nominal framerate
 for h.264 encoder
References: <1419264000-11761-1-git-send-email-p.zabel@pengutronix.de>	 <54B3E24B.5030403@xs4all.nl> <1421076959.3081.63.camel@pengutronix.de>
In-Reply-To: <1421076959.3081.63.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2015 04:35 PM, Philipp Zabel wrote:
> Hi Hans,
> 
> thank you for the comments!
> 
> Am Montag, den 12.01.2015, 16:03 +0100 schrieb Hans Verkuil:
>> On 12/22/2014 05:00 PM, Philipp Zabel wrote:
>>> The encoder needs to know the nominal framerate for the constant bitrate
>>> control mechanism to work. Currently the only way to set the framerate is
>>> by using VIDIOC_S_PARM on the output queue.
>>>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> ---
>>>  drivers/media/platform/coda/coda-common.c | 29 +++++++++++++++++++++++++++++
>>>  1 file changed, 29 insertions(+)
>>>
>>> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
>>> index 39330a7..63eb510 100644
>>> --- a/drivers/media/platform/coda/coda-common.c
>>> +++ b/drivers/media/platform/coda/coda-common.c
>>> @@ -803,6 +803,32 @@ static int coda_decoder_cmd(struct file *file, void *fh,
>>>  	return 0;
>>>  }
>>>  
>>> +static int coda_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>>> +{
>>> +	struct coda_ctx *ctx = fh_to_ctx(fh);
>>> +
>>
>> If a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT, then return -EINVAL.
> 
> If the decoder can retrieve the framerate from the stream, wouldn't it
> make sense to allow G_PARM for a->type == V4L2_BUF_TYPE_VIDEO_CAPTURE ?

Certainly. But that wasn't in the patch :-)

Regards,

	Hans

> 
>>  Ditto for s_parm.
> 
> Will do.
> 
>>> +	a->parm.output.timeperframe.denominator = 1;
>>> +	a->parm.output.timeperframe.numerator = ctx->params.framerate;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int coda_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>>> +{
>>> +	struct coda_ctx *ctx = fh_to_ctx(fh);
>>> +
>>> +	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
>>> +	    a->parm.output.timeperframe.numerator != 0) {
>>> +		ctx->params.framerate = a->parm.output.timeperframe.denominator
>>> +				      / a->parm.output.timeperframe.numerator;
>>
>> Hmm, what happens if the denominator is 1 and the numerator is 2?
>> You probably want to clamp ctx->params.framerate to the range of allowed framerates.
>> And at least ensure a framerate > 0.
>>
>> Also check with v4l2_compliance! You'd have caught at least the missing a->type check.
> 
> Oh dear, I need to improve my v4l-utils update habits. I'll fix this
> patch and resend it.
> 
> regards
> Philipp
> 

