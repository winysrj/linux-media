Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:60361 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1EILC0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 07:02:26 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QJOEK-0005hk-Em
	for linux-media@vger.kernel.org; Mon, 09 May 2011 13:02:24 +0200
Received: from 217067201162.itsa.net.pl ([217.67.201.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 09 May 2011 13:02:24 +0200
Received: from t.stanislaws by 217067201162.itsa.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 09 May 2011 13:02:24 +0200
To: linux-media@vger.kernel.org
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/2] v4l: simulate old crop API using extended crop/compose
 API
Date: Mon, 09 May 2011 13:01:51 +0200
Message-ID: <4DC7C99F.9040900@samsung.com>
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com> <1304588396-7557-3-git-send-email-t.stanislaws@samsung.com> <004d01cc0e11$9c715e10$d5541a30$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
In-Reply-To: <004d01cc0e11$9c715e10$d5541a30$%han@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Jonghun Han wrote:
> Hi Tomasz Stanislawski,
> 
> On Thursday, May 05, 2011 6:40 PM Tomasz Stanislawski wrote:
>> This patch allows new drivers to work correctly with applications that use
>> old-style crop API.
>> The old crop ioctl is simulated by using selection ioctls.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> ---
>>  drivers/media/video/v4l2-ioctl.c |   85
> +++++++++++++++++++++++++++++++++----
>>  1 files changed, 75 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-
>> ioctl.c
>> index aeef966..d0a4073 100644
>> --- a/drivers/media/video/v4l2-ioctl.c
>> +++ b/drivers/media/video/v4l2-ioctl.c
>> @@ -1723,11 +1723,31 @@ static long __video_do_ioctl(struct file *file,
>>  	{
>>  		struct v4l2_crop *p = arg;
>>
>> -		if (!ops->vidioc_g_crop)
>> +		dbgarg(cmd, "type=%s\n", prt_names(p->type,
> v4l2_type_names));
>> +
>> +		if (ops->vidioc_g_crop) {
>> +			ret = ops->vidioc_g_crop(file, fh, p);
>> +		} else
>> +		if (ops->vidioc_g_selection) {
>> +			/* simulate capture crop using selection api */
>> +			struct v4l2_selection s = {
>> +				.type = p->type,
>> +				.target = V4L2_SEL_CROP_ACTIVE,
>> +			};
>> +
>> +			/* crop means compose for output devices */
>> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>> +				s.target = V4L2_SEL_COMPOSE_ACTIVE;
>> +
> 
> If it also supports V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> how about using Macro like V4L2_TYPE_IS_OUTPUT(type) ?
> 
> [snip]
> 
> Best regards,
> Jonghun Han
> 
> 
Hi Jonghun,
Thank you for noticing MPLANE bug. I will fix it in next version.
There is some version of V4L2 with automatic conversion of buffer type.
However, the main purpose of this RFC is discussion over extended crop API.
Patches are a less relevant part at the moment.
I hope that the final consensus over API will emerge soon.
Do you have any comment or suggestions?

Best regards,
Tomasz Stanislawski

