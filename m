Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43014 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1H2ICF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 04:02:05 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQO00BG2JNEYH@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Aug 2011 09:02:02 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LQO000VOJNEAN@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Aug 2011 09:02:02 +0100 (BST)
Date: Mon, 29 Aug 2011 10:01:58 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 4/5] [media] v4l: fix copying ioctl results on failure
In-reply-to: <201108261709.02567.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Message-id: <4E5B4776.3030709@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7BIT
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com>
 <1314363967-6448-5-git-send-email-t.stanislaws@samsung.com>
 <201108261709.02567.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/2011 05:09 PM, Laurent Pinchart wrote:
Hi Laurent,
> Hi Tomasz,
>
> On Friday 26 August 2011 15:06:06 Tomasz Stanislawski wrote:
>> This patch fix the handling of data passed to V4L2 ioctls.  The content of
>> the structures is not copied if the ioctl fails.  It blocks ability to
>> obtain any information about occurred error other then errno code. This
>> patch fix this issue.
> Does the V4L2 spec say anything on this topic ? We might have applications
> that rely on the ioctl argument structure not being touched when a failure
> occurs.
Ups.. I missed something. It looks that modifying ioctl content is 
illegal if ioctl fails. The spec says:
"When an ioctl that takes an output or read/write parameter fails, the 
parameter remains unmodified." (v4l2 ioctl section)
However, there is probably a bug already present in V4L2 framework.
There are some ioctls that takes a pointer to an array as a field in the 
argument struct.
The examples are all VIDIOC_*_EXT_CTRLS and VIDIOC_{QUERY/DQ/Q}_BUF family.
The content of such an auxiliary arays is copied even if ioctl fails. 
Please take a look to video_usercopy function in v4l2-ioctl.c. Therefore 
I think that the spec is already violated. What is your opinion about 
this problem?

Now back to selection case.
This patch was added as proposition of fix to VIDIOC_S_SELECTION, to 
return the best-hit rectangle if constraints could not be satisfied. The 
ioctl return -ERANGE in this case. Using those return values the 
application gets some feedback
on loosing constraints.

I could remove rectangle returning from the spec and s5p-tv code for now.

Regards,
Tomasz Stanislawski

>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   drivers/media/video/v4l2-ioctl.c |    2 --
>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-ioctl.c
>> b/drivers/media/video/v4l2-ioctl.c index 543405b..9f54114 100644
>> --- a/drivers/media/video/v4l2-ioctl.c
>> +++ b/drivers/media/video/v4l2-ioctl.c
>> @@ -2490,8 +2490,6 @@ video_usercopy(struct file *file, unsigned int cmd,
>> unsigned long arg, err = -EFAULT;
>>   		goto out_array_args;
>>   	}
>> -	if (err<  0)
>> -		goto out;
>>
>>   out_array_args:
>>   	/*  Copy results into user buffer  */

