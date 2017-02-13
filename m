Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58738 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750853AbdBMKGo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 05:06:44 -0500
Subject: Re: [PATCH v2 4/4] media-ctl: add colorimetry support
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <1486978408-28580-1-git-send-email-p.zabel@pengutronix.de>
 <1486978408-28580-4-git-send-email-p.zabel@pengutronix.de>
 <1958d6aa-b5ba-9e8f-aa34-d08a54843c47@xs4all.nl>
 <20170213094823.GG16975@valkosipuli.retiisi.org.uk>
 <1486980162.2873.33.camel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <58bdf9cf-413d-26d8-0854-51db08427675@xs4all.nl>
Date: Mon, 13 Feb 2017 11:06:39 +0100
MIME-Version: 1.0
In-Reply-To: <1486980162.2873.33.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2017 11:02 AM, Philipp Zabel wrote:
> On Mon, 2017-02-13 at 11:48 +0200, Sakari Ailus wrote:
>> Hi Hans,
>>
>> On Mon, Feb 13, 2017 at 10:40:41AM +0100, Hans Verkuil wrote:
>> ...
>>>> @@ -839,6 +951,157 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string)
>>>>  	return (enum v4l2_field)-1;
>>>>  }
>>>>  
>>>> +static struct {
>>>> +	const char *name;
>>>> +	enum v4l2_colorspace colorspace;
>>>> +} colorspaces[] = {
>>>> +	{ "default", V4L2_COLORSPACE_DEFAULT },
>>>> +	{ "smpte170m", V4L2_COLORSPACE_SMPTE170M },
>>>> +	{ "smpte240m", V4L2_COLORSPACE_SMPTE240M },
>>>> +	{ "rec709", V4L2_COLORSPACE_REC709 },
>>>> +	{ "bt878", V4L2_COLORSPACE_BT878 },
>>>
>>> Drop this, it's no longer used in the kernel.
>>
>> What about older kernels? Were there drivers that reported it?
> 
> Has there ever been a v4l2 subdevice that reported bt878 colorspace on a
> pad via VIDIOC_SUBDEV_G_FMT?

No, never. If it was ever used it would be specific to the bttv driver which
doesn't use subdev ioctls.

	Hans
