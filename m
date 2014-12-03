Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41471 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaLCLuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 06:50:14 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NG000H9J90GZZ20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Dec 2014 11:53:04 +0000 (GMT)
Message-id: <547EF8E7.8040106@samsung.com>
Date: Wed, 03 Dec 2014 12:49:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
 <547EF0A9.2070004@samsung.com> <547EF165.9030409@cisco.com>
In-reply-to: <547EF165.9030409@cisco.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/14 12:17, Hans Verkuil wrote:
> Hi Sylwester,
> 
> On 12/03/14 12:14, Sylwester Nawrocki wrote:
>> > Hi Hans,
>> > 
>> > On 02/12/14 13:21, Hans Verkuil wrote:
>>> >> -static int s5k6aa_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>>> >> -			   struct v4l2_subdev_crop *crop)
>>> >> +static int s5k6aa_set_selection(struct v4l2_subdev *sd,
>>> >> +				struct v4l2_subdev_fh *fh,
>>> >> +				struct v4l2_subdev_selection *sel)
>>> >>  {
>>> >>  	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>> >>  	struct v4l2_mbus_framefmt *mf;
>>> >>  	unsigned int max_x, max_y;
>>> >>  	struct v4l2_rect *crop_r;
>>> >>  
>>> >> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
>>> >> +		return -EINVAL;
>>> >> +
>> > 
>> > Isn't checking sel->pad redundant here ? There is already the pad index
>> > validation in check_selection() in v4l2-subdev.c and this driver has only
>> > one pad.
>
> If it is called from a bridge driver, then it hasn't gone through
> check_selection().
> 
> That said, if it is called from a bridge driver, then one might expect
> correct usage of pad.

Indeed, there is still a possibility to have wrong pad index passed
to those functions.  I won't object to this patch being merged as is,
even though functional changes could be minimized by not adding a
check which wasn't originally there. :)

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Regards,
Sylwester
