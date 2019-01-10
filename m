Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023E4C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D132620660
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfAJOLm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 09:11:42 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50100 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728181AbfAJOLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 09:11:42 -0500
Received: from [IPv6:2001:420:44c1:2579:c8e7:b878:74ba:240a] ([IPv6:2001:420:44c1:2579:c8e7:b878:74ba:240a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id hb3YgyQmTBDyIhb3bgbwap; Thu, 10 Jan 2019 15:11:40 +0100
Subject: Re: [PATCH 1/1] v4l: ioctl: Validate num_planes before using it
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
References: <20190110124319.22230-1-sakari.ailus@linux.intel.com>
 <b2dde2b4-65c7-2dc7-c66a-62a93d36be23@xs4all.nl>
 <20190110134139.zfnjzlgh2u6ab6s2@paasikivi.fi.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <da827442-80cb-2a18-fcb4-0b4c88f8a0cb@xs4all.nl>
Date:   Thu, 10 Jan 2019 15:11:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190110134139.zfnjzlgh2u6ab6s2@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFfdQRHxhW5FbV7tGaRbJ0rCBn/KXC4wEVZRe5UaU+S04upwG0ELP6TJXHHW2DOe+T7KsqgDcocI8mUU0cRcTH1kIHjt9+4Jc0aivYpW+j9izf3xfZSO
 KfS3pa5MtC3k5kip1wbIdhTXVtp7GDWz5L2aat1S7rjlTXzcpcWj0ukBCjWatLwUFHcRRlH8JXo/+yRpg6MjcV4nUXGfVgMSL9jAchGnLv6h53UCIxSEoMZP
 KuSJY3dgveWZNazZBp2rtUO8yzZN6V836/+OpCae7o32Cs3wQoIozqvnSFwUtqPvTXyNgnC+cecHWXF+a+ODZxeYYB4ggkmdYee7a7ipq4A+ESp3lUTjPAoK
 s4BOOZSQnZxMv1SEBBb7ywdSYu19pwNxbq+v426o3FhA1nwV594=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/10/19 14:41, Sakari Ailus wrote:
> On Thu, Jan 10, 2019 at 02:02:14PM +0100, Hans Verkuil wrote:
>> On 01/10/19 13:43, Sakari Ailus wrote:
>>> The for loop to reset the memory of the plane reserved fields runs over
>>> num_planes provided by the user without validating it. Ensure num_planes
>>> is no more than VIDEO_MAX_PLANES before the loop.
>>>
>>> Fixes: 4e1e0eb0e074 ("media: v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields")
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>> Hi folks,
>>>
>>> This patch goes on top of Thierry's patch "media: v4l2-ioctl: Clear only
>>> per-plane reserved fields".
>>>
>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> index 392f1228af7b5..9e68a608ac6d3 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> @@ -1551,6 +1551,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>>>  		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
>>>  			break;
>>>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>>> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
>>> +			break;
>>
>> I would check this not here but in check_fmt: all *_FMT ioctls call that function
>> first, so it makes sense to do the check there.
> 
> Even G_FMT? I'm not saying no though. There's just a slight chance of
> breaking something as it hasn't been a problem to call G_FMT with incorrect
> number of planes in the mplane format; the number would be overwritten
> anyway.

Not G_FMT since everything after the type field is zeroed.

> Apart from that, this leaves just the four locations --- putting this to a
> separate function will reduce the calls to that function to just two.

I was a bit too quick with my comment about check_fmt. Your original patch
is fine.

I'll Ack your patch.

Regards,

	Hans

> 
>>
>> v4l_print_format should also be adjusted (take the minimum of num_planes and
>> VIDEO_MAX_PLANES), since it can still be called even if check_fmt returns an
>> error if num_planes is too large.
>>
>> In fact, the change to v4l_print_format should be a separate patch since that
>> should be backported. It can leak memory in the kernel log if num_planes is
>> too large.
>>
>> Regards,
>>
>> 	Hans
>>
>>>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>>>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>>>  		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
>>> @@ -1581,6 +1583,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>>>  		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
>>>  			break;
>>>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>>> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
>>> +			break;
>>>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>>>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>>>  		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
>>> @@ -1648,6 +1652,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>>>  		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
>>>  			break;
>>>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>>> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
>>> +			break;
>>>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>>>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>>>  		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
>>> @@ -1678,6 +1684,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>>>  		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
>>>  			break;
>>>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>>> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
>>> +			break;
>>>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>>>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>>>  		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
>>>
>>
> 

