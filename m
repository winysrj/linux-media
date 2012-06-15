Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4502 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOGZ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 02:25:29 -0400
Message-ID: <4FDAD50D.1010903@xs4all.nl>
Date: Fri, 15 Jun 2012 08:24:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Michael Hunold <michael@mihu.de>
CC: Peter Senna Tschudin <peter.senna@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] [RESEND] saa7146: Variable set but not used
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com> <1339696716-14373-3-git-send-email-peter.senna@gmail.com> <4FDACFFB.9020500@mihu.de>
In-Reply-To: <4FDACFFB.9020500@mihu.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/06/12 08:02, Michael Hunold wrote:
> Hello Peter,
>
> on 14.06.2012 19:58 Peter Senna Tschudin said the following:
>> In function fops_open variable type was set but not used.
>
> thanks for your patch, but I think it does not work.
>
>> Tested by compilation only.
>>
>> Signed-off-by: Peter Senna Tschudin<peter.senna@gmail.com>
>> ---
>>   drivers/media/common/saa7146_fops.c |    5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
>> index 7d42c11..0cdbd74 100644
>> --- a/drivers/media/common/saa7146_fops.c
>> +++ b/drivers/media/common/saa7146_fops.c
>> @@ -198,7 +198,6 @@ static int fops_open(struct file *file)
>>   	struct saa7146_dev *dev = video_drvdata(file);
>>   	struct saa7146_fh *fh = NULL;
>>   	int result = 0;
>> -	enum v4l2_buf_type type;
>>
>>   	DEB_EE("file:%p, dev:%s\n", file, video_device_node_name(vdev));
>>
>> @@ -207,10 +206,6 @@ static int fops_open(struct file *file)
>>
>>   	DEB_D("using: %p\n", dev);
>>
>> -	type = vdev->vfl_type == VFL_TYPE_GRABBER
>> -	     ? V4L2_BUF_TYPE_VIDEO_CAPTURE
>> -	     : V4L2_BUF_TYPE_VBI_CAPTURE;
>> -
>>   	/* check if an extension is registered */
>>   	if( NULL == dev->ext ) {
>>   		DEB_S("no extension registered for this device\n");
>
> A few lines below "fh" is allocated and "fh->type" is set to "type".
> Simply removing "type" will result in a compilation error IMO, so I
> wonder if your compile-test really worked.
>
> Can you have a look again?

Are you perhaps looking at an older version of this source? 'fh->type' 
no longer exists. Anyway, this patch is correct.

Regards,

     Hans
