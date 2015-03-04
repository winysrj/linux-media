Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:44947 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465AbbCDPEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 10:04:04 -0500
Message-ID: <54F71ED3.2050503@cisco.com>
Date: Wed, 04 Mar 2015 16:03:47 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/8] v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
References: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl> <1425462481-8200-2-git-send-email-hverkuil@xs4all.nl> <1585455.TczyOEbrob@avalon>
In-Reply-To: <1585455.TczyOEbrob@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 03/04/15 16:02, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Wednesday 04 March 2015 10:47:54 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> If a subdevice pad op is called from a bridge driver, then there is
>> no v4l2_subdev_fh struct that can be passed to the subdevice. This
>> made it hard to use such subdevs from a bridge driver.
>>
>> This patch replaces the v4l2_subdev_fh pointer by a v4l2_subdev_pad_config
>> pointer in the pad ops. This allows bridge drivers to use the various
>> try_ pad ops by creating a v4l2_subdev_pad_config struct and passing it
>> along to the pad op.
>>
>> The v4l2_subdev_get_try_* macros had to be changed because of this, so
>> I also took the opportunity to use the full name of the
>> v4l2_subdev_get_try_* functions in the __V4L2_SUBDEV_MK_GET_TRY macro
>> arguments: if you now do 'git grep v4l2_subdev_get_try_format' you will
>> actually find the header where it is defined.
>>
>> One remark regarding the drivers/staging/media/davinci_vpfe patches: the
>> *_init_formats() functions assumed that fh could be NULL. However, that's
>> not true for this driver, it's always set. This is almost certainly a copy
>> and paste from the omap3isp driver. I've updated the code to reflect the
>> fact that fh is never NULL.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> [snip]
> 
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index 5beeb87..0c43546 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -482,6 +482,18 @@ struct v4l2_subdev_ir_ops {
>>  				struct v4l2_subdev_ir_parameters *params);
>>  };
>>
>> +/*
>> + * Used for storing subdev pad information. This structure only needs
>> + * to be passed to the pad op if the 'which' field of the main argument
>> + * is set to V4L2_SUBDEV_FORMAT_TRY. For V4L2_SUBDEV_FORMAT_ACTIVE just
>> + * pass NULL.
> 
> Nitpicking, I would say "For V4L2_SUBDEV_FORMAT_ACTIVE is it safe to pass 
> NULL.", otherwise it could be understood that callers have to pass NULL for 
> ACTIVE.

True. I'll fix that.

	Hans

> 
>> + */
>> +struct v4l2_subdev_pad_config {
>> +	struct v4l2_mbus_framefmt try_fmt;
>> +	struct v4l2_rect try_crop;
>> +	struct v4l2_rect try_compose;
>> +};
> 
