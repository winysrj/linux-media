Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:62177 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLCLTD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 06:19:03 -0500
Message-ID: <547EF165.9030409@cisco.com>
Date: Wed, 03 Dec 2014 12:17:57 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl> <547EF0A9.2070004@samsung.com>
In-Reply-To: <547EF0A9.2070004@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 12/03/14 12:14, Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 02/12/14 13:21, Hans Verkuil wrote:
>> -static int s5k6aa_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>> -			   struct v4l2_subdev_crop *crop)
>> +static int s5k6aa_set_selection(struct v4l2_subdev *sd,
>> +				struct v4l2_subdev_fh *fh,
>> +				struct v4l2_subdev_selection *sel)
>>  {
>>  	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>  	struct v4l2_mbus_framefmt *mf;
>>  	unsigned int max_x, max_y;
>>  	struct v4l2_rect *crop_r;
>>  
>> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
>> +		return -EINVAL;
>> +
> 
> Isn't checking sel->pad redundant here ? There is already the pad index
> validation in check_selection() in v4l2-subdev.c and this driver has only
> one pad.

If it is called from a bridge driver, then it hasn't gone through
check_selection().

That said, if it is called from a bridge driver, then one might expect
correct usage of pad.

Laurent, do you have an opinion on this?

Regards,

	Hans
