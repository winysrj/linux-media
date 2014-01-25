Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4076 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaAYIy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 03:54:57 -0500
Message-ID: <52E37BC9.3030004@xs4all.nl>
Date: Sat, 25 Jan 2014 09:54:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 08/21] v4l2-ctrls: create type_ops.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-9-git-send-email-hverkuil@xs4all.nl> <20140124154619.GE13820@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140124154619.GE13820@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/24/2014 04:46 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Jan 20, 2014 at 01:46:01PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Since complex controls can have non-standard types we need to be able to do
>> type-specific checks etc. In order to make that easy type operations are added.
>> There are four operations:
>>
>> - equal: check if two values are equal
>> - init: initialize a value
>> - log: log the value
>> - validate: validate a new value
>>
>> This patch uses the v4l2_ctrl_ptr union for the first time.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c | 267 ++++++++++++++++++++++-------------
>>  include/media/v4l2-ctrls.h           |  21 +++
>>  2 files changed, 190 insertions(+), 98 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 98e940f..9f97af4 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -1123,6 +1123,149 @@ static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
>>  			v4l2_event_queue_fh(sev->fh, &ev);
>>  }
>>  
>> +static bool std_equal(const struct v4l2_ctrl *ctrl,
>> +		      union v4l2_ctrl_ptr ptr1,
>> +		      union v4l2_ctrl_ptr ptr2)
>> +{
>> +	switch (ctrl->type) {
>> +	case V4L2_CTRL_TYPE_BUTTON:
>> +		return false;
>> +	case V4L2_CTRL_TYPE_STRING:
>> +		/* strings are always 0-terminated */
>> +		return !strcmp(ptr1.p_char, ptr2.p_char);
>> +	case V4L2_CTRL_TYPE_INTEGER64:
>> +		return *ptr1.p_s64 == *ptr2.p_s64;
> 
> The above two lines seem redundant to me.

Why? How else would you compare two 64-bit integers?

> 
>> +	default:
>> +		if (ctrl->is_ptr)
>> +			return !memcmp(ptr1.p, ptr2.p, ctrl->elem_size);
>> +		return *ptr1.p_s32 == *ptr2.p_s32;
>> +	}
>> +}
>> +
>> +static void std_init(const struct v4l2_ctrl *ctrl,
>> +		     union v4l2_ctrl_ptr ptr)
>> +{
>> +	switch (ctrl->type) {
>> +	case V4L2_CTRL_TYPE_STRING:
>> +		memset(ptr.p_char, ' ', ctrl->minimum);
>> +		ptr.p_char[ctrl->minimum] = '\0';
>> +		break;
>> +	case V4L2_CTRL_TYPE_INTEGER64:
>> +		*ptr.p_s64 = ctrl->default_value;
>> +		break;
>> +	case V4L2_CTRL_TYPE_INTEGER:
>> +	case V4L2_CTRL_TYPE_INTEGER_MENU:
>> +	case V4L2_CTRL_TYPE_MENU:
>> +	case V4L2_CTRL_TYPE_BITMASK:
>> +	case V4L2_CTRL_TYPE_BOOLEAN:
>> +		*ptr.p_s32 = ctrl->default_value;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +}
>> +
>> +static void std_log(const struct v4l2_ctrl *ctrl)
>> +{
>> +	union v4l2_ctrl_ptr ptr = ctrl->stores[0];
>> +
>> +	switch (ctrl->type) {
>> +	case V4L2_CTRL_TYPE_INTEGER:
>> +		pr_cont("%d", *ptr.p_s32);
>> +		break;
>> +	case V4L2_CTRL_TYPE_BOOLEAN:
>> +		pr_cont("%s", *ptr.p_s32 ? "true" : "false");
>> +		break;
>> +	case V4L2_CTRL_TYPE_MENU:
>> +		pr_cont("%s", ctrl->qmenu[*ptr.p_s32]);
>> +		break;
>> +	case V4L2_CTRL_TYPE_INTEGER_MENU:
>> +		pr_cont("%lld", ctrl->qmenu_int[*ptr.p_s32]);
>> +		break;
>> +	case V4L2_CTRL_TYPE_BITMASK:
>> +		pr_cont("0x%08x", *ptr.p_s32);
>> +		break;
>> +	case V4L2_CTRL_TYPE_INTEGER64:
>> +		pr_cont("%lld", *ptr.p_s64);
>> +		break;
>> +	case V4L2_CTRL_TYPE_STRING:
>> +		pr_cont("%s", ptr.p_char);
>> +		break;
>> +	default:
>> +		pr_cont("unknown type %d", ctrl->type);
>> +		break;
>> +	}
>> +}
>> +
>> +/* Round towards the closest legal value */
>> +#define ROUND_TO_RANGE(val, offset_type, ctrl)			\
>> +({								\
>> +	offset_type offset;					\
>> +	val += (ctrl)->step / 2;				\
>> +	val = clamp_t(typeof(val), val,				\
>> +		      (ctrl)->minimum, (ctrl)->maximum);	\
>> +	offset = (val) - (ctrl)->minimum;			\
>> +	offset = (ctrl)->step * (offset / (ctrl)->step);	\
>> +	val = (ctrl)->minimum + offset;				\
>> +	0;							\
>> +})
> 
> Could you use an inline function instead? This doesn't really need to be a
> macro, albeit I admit that it's always cool to express one's ability to
> write GCC-only macros. :-D
> 
> (I just noticed that this patch just moves the macro to a different place,
> but I think it was added by an earlier patch in the set.)
> 

I'll see what I can do, although I am not going to spend a huge amount of time
on this :-)

Regards,

	Hans
