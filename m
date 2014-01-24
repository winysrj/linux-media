Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3386 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAXMpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 07:45:06 -0500
Message-ID: <52E2603A.1060407@xs4all.nl>
Date: Fri, 24 Jan 2014 13:44:42 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 09/21] v4l2-ctrls: rewrite copy routines to operate
 on union v4l2_ctrl_ptr.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-10-git-send-email-hverkuil@xs4all.nl> <20140124123118.GC13820@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140124123118.GC13820@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/24/2014 01:31 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Jan 20, 2014 at 01:46:02PM +0100, Hans Verkuil wrote:
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 9f97af4..c0507ed 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -1266,48 +1266,64 @@ static const struct v4l2_ctrl_type_ops std_type_ops = {
>>  	.validate = std_validate,
>>  };
>>  
>> -/* Helper function: copy the current control value back to the caller */
>> -static int cur_to_user(struct v4l2_ext_control *c,
>> -		       struct v4l2_ctrl *ctrl)
>> +/* Helper function: copy the given control value back to the caller */
>> +static int ptr_to_user(struct v4l2_ext_control *c,
>> +		       struct v4l2_ctrl *ctrl,
>> +		       union v4l2_ctrl_ptr ptr)
>>  {
>>  	u32 len;
>>  
>>  	if (ctrl->is_ptr && !ctrl->is_string)
>> -		return copy_to_user(c->p, ctrl->cur.p, ctrl->elem_size);
>> +		return copy_to_user(c->p, ptr.p, ctrl->elem_size);
> 
> Not a fault of this patch, but this is wrong: copy_to_user() returns the
> bytes not copied. That should probably be fixed separately before this
> patch. I can submit one.
> 

Thanks! Don't bother making a patch, I'll need to make more changes anyway so I'll
just fix this at the same time.

Regards,

	Hans
