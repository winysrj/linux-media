Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44690 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbaLCMij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 07:38:39 -0500
Message-ID: <547F040D.10109@xs4all.nl>
Date: Wed, 03 Dec 2014 13:37:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl> <547EF0A9.2070004@samsung.com> <547EF165.9030409@cisco.com> <547EF8E7.8040106@samsung.com>
In-Reply-To: <547EF8E7.8040106@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/14 12:49, Sylwester Nawrocki wrote:
> On 03/12/14 12:17, Hans Verkuil wrote:
>> Hi Sylwester,
>>
>> On 12/03/14 12:14, Sylwester Nawrocki wrote:
>>>> Hi Hans,
>>>>
>>>> On 02/12/14 13:21, Hans Verkuil wrote:
>>>>>> -static int s5k6aa_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>>>>>> -			   struct v4l2_subdev_crop *crop)
>>>>>> +static int s5k6aa_set_selection(struct v4l2_subdev *sd,
>>>>>> +				struct v4l2_subdev_fh *fh,
>>>>>> +				struct v4l2_subdev_selection *sel)
>>>>>>  {
>>>>>>  	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>>>>>  	struct v4l2_mbus_framefmt *mf;
>>>>>>  	unsigned int max_x, max_y;
>>>>>>  	struct v4l2_rect *crop_r;
>>>>>>  
>>>>>> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>
>>>> Isn't checking sel->pad redundant here ? There is already the pad index
>>>> validation in check_selection() in v4l2-subdev.c and this driver has only
>>>> one pad.
>>
>> If it is called from a bridge driver, then it hasn't gone through
>> check_selection().
>>
>> That said, if it is called from a bridge driver, then one might expect
>> correct usage of pad.
> 
> Indeed, there is still a possibility to have wrong pad index passed
> to those functions.  I won't object to this patch being merged as is,
> even though functional changes could be minimized by not adding a
> check which wasn't originally there. :)
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 

I've dropped the sel->pad check.

Regards,

	Hans
