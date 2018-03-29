Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56826 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752628AbeC2NDC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 09:03:02 -0400
Subject: Re: [PATCH] media: v4l2-compat-ioctl32: don't oops on overlay
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        stable@vger.kernel.org
References: <ac21b8f306793001a86c31cf0aebb1efac748ba9.1522259957.git.mchehab@s-opensource.com>
 <2e9cca00-5c6d-6a22-0273-98f908a304d6@xs4all.nl>
 <20180329100042.209b313c@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6ebbb28d-f498-fdeb-85b2-854f471bf4f8@xs4all.nl>
Date: Thu, 29 Mar 2018 15:02:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180329100042.209b313c@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/03/18 15:00, Mauro Carvalho Chehab wrote:
> Em Thu, 29 Mar 2018 10:40:23 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Mauro,
>>
>> On 28/03/18 19:59, Mauro Carvalho Chehab wrote:
>>> At put_v4l2_window32(), it tries to access kp->clips. However,
>>> kp points to an userspace pointer. So, it should be obtained
>>> via get_user(), otherwise it can OOPS:
>>>   
>>
>> <snip>
>>
>>>
>>> cc: stable@vger.kernel.org
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>> index 5198c9eeb348..4312935f1dfc 100644
>>> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>> @@ -101,7 +101,7 @@ static int get_v4l2_window32(struct v4l2_window __user *kp,
>>>  static int put_v4l2_window32(struct v4l2_window __user *kp,
>>>  			     struct v4l2_window32 __user *up)
>>>  {
>>> -	struct v4l2_clip __user *kclips = kp->clips;
>>> +	struct v4l2_clip __user *kclips;
>>>  	struct v4l2_clip32 __user *uclips;
>>>  	compat_caddr_t p;
>>>  	u32 clipcount;
>>> @@ -116,6 +116,8 @@ static int put_v4l2_window32(struct v4l2_window __user *kp,
>>>  	if (!clipcount)
>>>  		return 0;
>>>  
>>> +	if (get_user(kclips, &kp->clips))
>>> +		return -EFAULT;
>>>  	if (get_user(p, &up->clips))
>>>  		return -EFAULT;
>>>  	uclips = compat_ptr(p);
>>>   
>>
>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> I have no idea why I didn't find this when I tested this with v4l2-compliance,
>> but the code was certainly wrong.
> 
> I built 4.16-rc4 with KASAN enabled. Perhaps, it won't OOPS without
> it. Yet, I doubt it would work without this fix.

I definitely did not have KASAN enabled when I tested this.

Regards,

	Hans

> 
>>
>> Thank you for debugging this!
> 
> Anytime.
> 
> Thanks,
> Mauro
> 
