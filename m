Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:56226 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751849AbdB0JN1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 04:13:27 -0500
Subject: Re: [PATCH] soc-camera: fix rectangle adjustment in cropping
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.1702262150090.17018@axis700.grange>
 <1908551.GjAGnFoZ8e@avalon>
 <Pine.LNX.4.64.1702270945390.21990@axis700.grange>
 <6082161.NEqkolhdEc@avalon>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <319e8cdd-4cd0-079f-649c-cc2f9f10d466@xs4all.nl>
Date: Mon, 27 Feb 2017 10:13:20 +0100
MIME-Version: 1.0
In-Reply-To: <6082161.NEqkolhdEc@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/2017 10:02 AM, Laurent Pinchart wrote:
> Hi Guennadi,
> 
> On Monday 27 Feb 2017 09:54:19 Guennadi Liakhovetski wrote:
>> On Mon, 27 Feb 2017, Laurent Pinchart wrote:
>>> On Sunday 26 Feb 2017 21:58:16 Guennadi Liakhovetski wrote:
>>>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>>>>
>>>> update_subrect() adjusts the sub-rectangle to be inside a base area.
>>>> It checks width and height to not exceed those of the area, then it
>>>> checks the low border (left or top) to lie within the area, then the
>>>> high border (right or bottom) to lie there too. This latter check has
>>>> a bug, which is fixed by this patch.
>>>>
>>>> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>>>> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
>>>> [g.liakhovetski@gmx.de: dropped supposedly wrong hunks]
>>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>>> ---
>>>>
>>>> This is a part of the https://patchwork.linuxtv.org/patch/26441/
>>>> submitted almost 2.5 years ago. Back then I commented to the patch but
>>>> never got a reply or an update. I preserved original authorship and Sob
>>>> tags, although this version only uses a small portion of the original
>>>> patch. This version is of course completely untested, any testing (at
>>>> least regression) would be highly appreciated! This code is only used by
>>>> the SH CEU driver and only in cropping / zooming scenarios.
>>>>
>>>>  drivers/media/platform/soc_camera/soc_scale_crop.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c
>>>> b/drivers/media/platform/soc_camera/soc_scale_crop.c index
>>>> f77252d..4bfc1bf
>>>> 100644
>>>> --- a/drivers/media/platform/soc_camera/soc_scale_crop.c
>>>> +++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
>>>> @@ -70,14 +70,14 @@ static void update_subrect(struct v4l2_rect *rect,
>>>> struct v4l2_rect *subrect)
>>>>  	if (rect->height < subrect->height)
>>>>  		subrect->height = rect->height;
>>>>
>>>> -	if (rect->left > subrect->left)
>>>> +	if (rect->left < subrect->left)
>>>
>>> This looks wrong to me. If the purpose of the function is indeed to adjust
>>> subrect to stay within rect, the condition doesn't need to be changed.
>>>
>>>>  		subrect->left = rect->left;
>>>>  	else if (rect->left + rect->width >
>>>>  		 subrect->left + subrect->width)
>>>
>>> This condition, however, is wrong.
>>
>> Arrrrgh, of course, I meant to change this one! Thanks for catching.
>>
>>>>  		subrect->left = rect->left + rect->width -
>>>>  			subrect->width;
>>>
>>> More than that, adjusting the width first and then the left coordinate can
>>> result in an incorrect width.
>>
>> The width is adjusted in the beginning only to stay within the area, you
>> cannot go beyond it anyway. So, that has to be done anyway. And then the
>> origin is adjusted.
>>
>>> It looks to me like you should drop the width
>>> check at the beginning of this function, and turn the "else if" here into
>>> an "if" with the right condition. Or, even better in my opinion, use the
>>> min/max/clamp macros.
>>
>> Well, that depends on what result we want to achieve, what parameter we
>> prioritise. This approach prioritises width and height, and then adjusts
>> edges to accommodate as much of them as possible. A different approach
>> would be to prioritise the origin (top and left) and adjust width and
>> height to stay within the area. Do we have a preference for this?
> 
> Don't you need both ? "Inside the area" is a pretty well-defined concept :-)

Generally the top-left is adjusted first, and then the width/height if it still
can't be made to fit. I.e. the priority is to keep the width/height unchanged
if possible.

Regards,

	Hans

> 
> 	subrect->left = max(subrect->left, rect->left);
> 	subrect->top = max(subrect->top, rect->top);
> 	subrect->width = min(subrect->left + subrect->width,
> 			     rect->left + rect->width) - subrect->left;
> 	subrect->height = min(subrect->top + subrect->height,
> 			      rect->top + rect->height) - subrect->top;
> 
> (Completely untested)
> 
>>> Same comments for the vertical checks.
>>>
>>>> -	if (rect->top > subrect->top)
>>>> +	if (rect->top < subrect->top)
>>>>  		subrect->top = rect->top;
>>>>  	else if (rect->top + rect->height >
>>>>  		 subrect->top + subrect->height)
> 
