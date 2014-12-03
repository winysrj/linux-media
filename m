Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39356 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaLCLPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 06:15:05 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NG000IDL7DU9H10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Dec 2014 11:17:54 +0000 (GMT)
Message-id: <547EF0A9.2070004@samsung.com>
Date: Wed, 03 Dec 2014 12:14:49 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 02/12/14 13:21, Hans Verkuil wrote:
> -static int s5k6aa_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> -			   struct v4l2_subdev_crop *crop)
> +static int s5k6aa_set_selection(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_selection *sel)
>  {
>  	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>  	struct v4l2_mbus_framefmt *mf;
>  	unsigned int max_x, max_y;
>  	struct v4l2_rect *crop_r;
>  
> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +

Isn't checking sel->pad redundant here ? There is already the pad index
validation in check_selection() in v4l2-subdev.c and this driver has only
one pad.

--
Regards,
Sylwester
