Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34260 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbcARLVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 06:21:48 -0500
Subject: Re: [PATCH] v4l: Fix dma buf single plane compat handling
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <1449477939-5658-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1496823.l1L2kFkYyq@avalon>
 <20151209110740.GI17128@valkosipuli.retiisi.org.uk>
 <1530239.WI7pDY4BZt@avalon>
Cc: linux-media@vger.kernel.org,
	Gjorgji Rosikopulos <grosikopulos@mm-sol.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569CCAC2.5010001@xs4all.nl>
Date: Mon, 18 Jan 2016 12:21:38 +0100
MIME-Version: 1.0
In-Reply-To: <1530239.WI7pDY4BZt@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

While going through patchwork I found this patch that does the same as this
one from Tiffany:

https://patchwork.linuxtv.org/patch/32631/

I haven't seen a second version of this patch from Laurent with the requested
changes fixed, so unless Laurent says otherwise I'd like to merge Tiffany's
version.

Laurent, is that OK for you?

Regards,

	Hans

On 12/13/2015 09:40 PM, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wednesday 09 December 2015 13:07:40 Sakari Ailus wrote:
>> On Wed, Dec 09, 2015 at 01:11:12AM +0200, Laurent Pinchart wrote:
>>> On Tuesday 08 December 2015 17:29:16 Sakari Ailus wrote:
>>>> On Mon, Dec 07, 2015 at 10:45:39AM +0200, Laurent Pinchart wrote:
>>>>> From: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
>>>>>
>>>>> Buffer length is needed for single plane as well, otherwise
>>>>> is uninitialized and behaviour is undetermined.
>>>>
>>>> How about:
>>>>
>>>> The v4l2_buffer length field must be passed as well from user to kernel
>>>> and back, otherwise uninitialised values will be used.
>>>>
>>>>> Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
>>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>
>>>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>
>>>> Shouldn't this be submitted to stable as well?
>>>
>>> I'll CC stable.
>>>
>>>>> ---
>>>>>
>>>>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 7 +++++--
>>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>>>> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index
>>>>> 8fd84a67478a..b0faa1f7e3a9 100644
>>>>> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>>>> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>>>> @@ -482,8 +482,10 @@ static int get_v4l2_buffer32(struct v4l2_buffer
>>>>> *kp, struct v4l2_buffer32 __user
>>>>>  				return -EFAULT;
>>>>>  			break;
>>>>>  		
>>>>>  		case V4L2_MEMORY_DMABUF:
>>>>> -			if (get_user(kp->m.fd, &up->m.fd))
>>>>> +			if (get_user(kp->m.fd, &up->m.fd) ||
>>>>> +			    get_user(kp->length, &up->length))
>>>>>  				return -EFAULT;
>>>>> +
>>
>> Without the extra newline, please?
> 
> Sure, I'll fix that in the pull request.
> 

