Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:41679 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750913AbeA2KDB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 05:03:01 -0500
Subject: Re: [PATCH 11/12] v4l2-compat-ioctl32.c: don't copy back the result
 for certain errors
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-12-hverkuil@xs4all.nl>
 <20180129095608.d3opjq5zkp72u43e@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <460b8543-8f5b-e5e6-9f4b-578b38695d60@xs4all.nl>
Date: Mon, 29 Jan 2018 11:02:56 +0100
MIME-Version: 1.0
In-Reply-To: <20180129095608.d3opjq5zkp72u43e@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/29/2018 10:56 AM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Fri, Jan 26, 2018 at 01:43:26PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Some ioctls need to copy back the result even if the ioctl returned
>> an error. However, don't do this for the error codes -ENOTTY, -EFAULT
>> and -ENOIOCTLCMD. It makes no sense in those cases.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Shouldn't such a change be made to video_usercopy() as well? Doesn't need
> to be in this set though.

Good point. I'll add that for v2. This is not actually a bug as such, but
it's just weird to copy back results if the ioctl wasn't implemented at all.

I realize that I need to drop the -EFAULT check: if you call VIDIOC_G_EXT_CTRLS
with an incorrect userspace buffer for the payload, then the control framework
will set error_idx to the index of the control with the wrong buffer. So you do
need to copy back the data in case of -EFAULT.

I can also drop -ENOIOCTLCMD since video_usercopy() converts that to -ENOTTY.

Regards,

	Hans

> 
>> ---
>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> index 790473b45a21..2aa9b43daf60 100644
>> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> @@ -966,6 +966,9 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>>  		set_fs(old_fs);
>>  	}
>>  
>> +	if (err == -ENOTTY || err == -EFAULT || err == -ENOIOCTLCMD)
>> +		return err;
>> +
>>  	/* Special case: even after an error we need to put the
>>  	   results back for these ioctls since the error_idx will
>>  	   contain information on which control failed. */
> 
