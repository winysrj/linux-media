Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34064 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbbCSJkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 05:40:25 -0400
MIME-Version: 1.0
In-Reply-To: <5509F87D.9060603@linux.intel.com>
References: <1426628910-11927-1-git-send-email-prabhakar.csengg@gmail.com> <5509F87D.9060603@linux.intel.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 19 Mar 2015 09:39:53 +0000
Message-ID: <CA+V-a8uaLhRrSn7KA1N5LCfPAx0KKpP4HFyk69SOmJmaSt3ewQ@mail.gmail.com>
Subject: Re: [PATCH v7] media: i2c: add support for omnivision's ov2659 sensor
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On Wed, Mar 18, 2015 at 10:13 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Prabhakar,
>
> Lad Prabhakar wrote:
> ...
>>
>> +static int ov2659_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +       struct ov2659 *ov2659 =
>> +                       container_of(ctrl->handler, struct ov2659, ctrls);
>> +       struct v4l2_mbus_framefmt *fmt = &ov2659->format;
>> +
>> +       switch (ctrl->id) {
>> +       case V4L2_CID_PIXEL_RATE:
>> +               if (fmt->code != MEDIA_BUS_FMT_SBGGR8_1X8)
>> +                       ov2659->link_frequency->val =
>> +                                       ov2659->pdata->link_frequency / 2;
>> +               else
>> +                       ov2659->link_frequency->val =
>> +                                       ov2659->pdata->link_frequency;
>
>
> You should simply use v4l2_ctrl_s_ctrl_int64() in ..._set_fmt() as this
> isn't really a proper volatile control, but its value depends on the format.
>
Yea makes sense, will respin the patch with this change.

Cheers,
--Prabhakar Lad
