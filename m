Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:46092 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751313AbdBMJ6P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 04:58:15 -0500
Subject: Re: [PATCH v2 4/4] media-ctl: add colorimetry support
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1486978408-28580-1-git-send-email-p.zabel@pengutronix.de>
 <1486978408-28580-4-git-send-email-p.zabel@pengutronix.de>
 <1958d6aa-b5ba-9e8f-aa34-d08a54843c47@xs4all.nl>
 <20170213094823.GG16975@valkosipuli.retiisi.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <46715967-9ac2-1cc8-1b3c-55122545a115@xs4all.nl>
Date: Mon, 13 Feb 2017 10:58:10 +0100
MIME-Version: 1.0
In-Reply-To: <20170213094823.GG16975@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2017 10:48 AM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Feb 13, 2017 at 10:40:41AM +0100, Hans Verkuil wrote:
> ...
>>> @@ -839,6 +951,157 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string)
>>>  	return (enum v4l2_field)-1;
>>>  }
>>>  
>>> +static struct {
>>> +	const char *name;
>>> +	enum v4l2_colorspace colorspace;
>>> +} colorspaces[] = {
>>> +	{ "default", V4L2_COLORSPACE_DEFAULT },
>>> +	{ "smpte170m", V4L2_COLORSPACE_SMPTE170M },
>>> +	{ "smpte240m", V4L2_COLORSPACE_SMPTE240M },
>>> +	{ "rec709", V4L2_COLORSPACE_REC709 },
>>> +	{ "bt878", V4L2_COLORSPACE_BT878 },
>>
>> Drop this, it's no longer used in the kernel.
> 
> What about older kernels? Were there drivers that reported it?
> 

Possibly in a very distant past. But certainly not in anything supporting subdevs.

I looked into this when I worked on colorspaces and from what I could gather it
was based on a misunderstanding what a colorspace really is and it was just a
bogus 'colorspace'.

Regards,

	Hans
