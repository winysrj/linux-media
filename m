Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34396 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031970AbeEXK1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 06:27:23 -0400
Subject: Re: [PATCHv13 12/28] v4l2-ctrls: add core request support
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-13-hverkuil@xs4all.nl>
 <20180507150600.66d794c6@vento.lan>
 <630745ed-dcac-61f6-9683-2236fc6c2c2a@xs4all.nl>
 <20180508074957.2c8e5464@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0702530d-0479-2345-f091-c778947e79d1@xs4all.nl>
Date: Thu, 24 May 2018 12:27:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180508074957.2c8e5464@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/18 12:49, Mauro Carvalho Chehab wrote:
> Em Tue, 8 May 2018 10:07:22 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>>>> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
>>>> index 76352eb59f14..a0f7c38d1a90 100644
>>>> --- a/include/media/v4l2-ctrls.h
>>>> +++ b/include/media/v4l2-ctrls.h
>>>> @@ -250,6 +250,10 @@ struct v4l2_ctrl {
>>>>   *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
>>>>   * @from_other_dev: If true, then @ctrl was defined in another
>>>>   *		device than the &struct v4l2_ctrl_handler.
>>>> + * @done:	If true, then this control reference is part of a
>>>> + *		control cluster that was already set while applying
>>>> + *		the controls in this media request object.  
>>>
>>> Hmm... I would rename it for request_done or something similar, as it
>>> seems that this applies only for requests.  
>>
>> No, the variable name is correct (it serves the same purpose as the 'done'
>> field in struct v4l2_ctrl), but the description should be improved.
>>
>> I also want to take another look at this: I wonder if it isn't possible to
>> use the v4l2_ctrl 'done' field for this instead of having to add a new field
>> here.

Unfortunately, that isn't possible.

> 
> If it can use v4l2_ctrl done, it would indeed be better. Otherwise, as
> this new "done" is used only by requests, I really think that it shold
> be renamed, to let it clearer that this is the "done" that should be used
> when requests are used.

I've renamed 'done' to req_done and improved (I hope) the comment.

Regards,

	Hans

> 
> Thanks,
> Mauro
> 
