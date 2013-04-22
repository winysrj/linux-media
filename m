Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab3DVL5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 07:57:43 -0400
Message-ID: <517525B3.2010806@redhat.com>
Date: Mon, 22 Apr 2013 08:57:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv3 07/10] [media] tuner-core: add SDR support for g_tuner
References: <1366570839-662-1-git-send-email-mchehab@redhat.com> <1366570839-662-8-git-send-email-mchehab@redhat.com> <201304220918.27748.hverkuil@xs4all.nl>
In-Reply-To: <201304220918.27748.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-04-2013 04:18, Hans Verkuil escreveu:
> On Sun April 21 2013 21:00:36 Mauro Carvalho Chehab wrote:
>> Properly initialize the fields for VIDIOC_G_TUNER, if the
>> device is in SDR mode.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>   drivers/media/v4l2-core/tuner-core.c | 29 +++++++++++++++++++++++++----
>>   1 file changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
>> index b97ec63..e54b5ae 100644
>> --- a/drivers/media/v4l2-core/tuner-core.c
>> +++ b/drivers/media/v4l2-core/tuner-core.c
>> @@ -1190,7 +1190,31 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>>   	}
>>
>>   	/* radio mode */
>> -	if (vt->type == t->mode) {
>> +	vt->capability |= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
>> +
>> +	if (V4L2_TUNER_IS_SDR(vt->type)) {
>> +		vt->rangelow  = tv_range[0] * 16000;
>> +		vt->rangehigh = tv_range[1] * 16000;
>
> Why use tv_range for SDR? It's a bit odd for something called SD 'Radio'.

Because it is the widest known range, and it covers already the FM
range. A latter patch will improve the range, by adding a tuner
callback to query about what's the real supported range, with will
be typically broader than the TV one.

Regards,
Mauro
