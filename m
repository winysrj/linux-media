Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15665 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbbCRWOE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 18:14:04 -0400
Message-ID: <5509F87D.9060603@linux.intel.com>
Date: Thu, 19 Mar 2015 00:13:17 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v7] media: i2c: add support for omnivision's ov2659 sensor
References: <1426628910-11927-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1426628910-11927-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Lad Prabhakar wrote:
...
> +static int ov2659_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct ov2659 *ov2659 =
> +			container_of(ctrl->handler, struct ov2659, ctrls);
> +	struct v4l2_mbus_framefmt *fmt = &ov2659->format;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_PIXEL_RATE:
> +		if (fmt->code != MEDIA_BUS_FMT_SBGGR8_1X8)
> +			ov2659->link_frequency->val =
> +					ov2659->pdata->link_frequency / 2;
> +		else
> +			ov2659->link_frequency->val =
> +					ov2659->pdata->link_frequency;

You should simply use v4l2_ctrl_s_ctrl_int64() in ..._set_fmt() as this 
isn't really a proper volatile control, but its value depends on the format.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

