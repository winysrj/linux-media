Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DFEC282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 11:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02EEA21905
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 11:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfBML71 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 06:59:27 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56384 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727568AbfBML71 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 06:59:27 -0500
Received: from [IPv6:2001:420:44c1:2579:4ccb:9a9e:f164:d84f] ([IPv6:2001:420:44c1:2579:4ccb:9a9e:f164:d84f])
        by smtp-cloud9.xs4all.net with ESMTPA
        id ttCBgRQFtI8AWttCFgv7XG; Wed, 13 Feb 2019 12:59:24 +0100
Subject: Re: [PATCHv2 4/6] videodev2.h: add V4L2_CTRL_FLAG_REQUIRES_REQUESTS
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
References: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
 <20190211101357.48754-5-hverkuil-cisco@xs4all.nl>
 <e334fb92-31a2-28c0-02e4-a9ccac49ba03@xs4all.nl>
 <7877d69965ca7ee4caa3a26e17137c535776e61e.camel@bootlin.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <bc24e761-8b64-1cfe-f517-614a0e3c46ce@xs4all.nl>
Date:   Wed, 13 Feb 2019 12:59:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <7877d69965ca7ee4caa3a26e17137c535776e61e.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCQY6H12KnBH87UZF42IZZtASsxwYn8c6hEruvBXufIBo1LNwTJfwRXW0oUd2bnkreXtEJFjnpuEhbhNhOpcHoadBRs43Rr/Nn7dyJYV+HytAt3cVK02
 qkpSCfFf6lT/rtavc10YFfi9Lk7L+2STi2H+9eSme9gErFSydDf8NlEvbdvJjEUw2zKm2kzo45UM5vv1jgfQXM+aBiYRa3PkLAnTB/Cc7YQqLhfztGIyxtiK
 I6+gUFJ8SX2h682HsM/MWfZqrFte6YOLrtqzQBJEGUcPCovoNy7U4YK/NnEjxfHfgiAIrVwOknm23vIRN2mIHC00sSPNj+LB0bd1k5fk3mpM1iyhAX0Z8E08
 GeV32Fl24JuEZOtji8sYM9kku08F6UfLIENcbyAZd2d0aOWU8Dc=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/13/19 11:38 AM, Paul Kocialkowski wrote:
> Hi,
> 
> On Mon, 2019-02-11 at 14:04 +0100, Hans Verkuil wrote:
>> On 2/11/19 11:13 AM, Hans Verkuil wrote:
>>> Indicate if a control can only be set through a request, as opposed
>>> to being set directly. This is necessary for stateless codecs where
>>> it makes no sense to set the state controls directly.
>>
>> Kwiboo on irc pointed out that this clashes with this line the in Initialization
>> section of the stateless decoder API:
>>
>> "Call VIDIOC_S_EXT_CTRLS() to set all the controls (parsed headers, etc.) required
>>  by the OUTPUT format to enumerate the CAPTURE formats."
>>
>> So for now ignore patches 4-6: I need to think about this some more.
>>
>> My worry here is what happens when userspace is adding these controls to a
>> request and at the same time sets them directly. That may cause weird side-effects.
> 
> This seems to be a very legitimate concern, as nothing guarantees that
> the controls setup by v4l2_ctrl_request_setup won't be overridden
> before the driver uses them.
> 
> One solution could be to mark the controls as "in use" when the request
> has new data for them, clear that in v4l2_ctrl_request_complete and
> return EBUSY when trying to set the control in between the two calls.
> 
> This way, we ensure that any control set via a request will retain the
> value passed with the request, which is independent from the control
> itself (so we don't need special handling for stateless codec
> controls). It also allows setting the control outside of a request for
> enumerating formats.
> 
> What do you think?

That's a good idea. I'll see if I can make that work.

Regards,

	Hans

> 
> Cheers,
> 
> Paul
> 
>> Regards,
>>
>> 	Hans
>>
>>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>> ---
>>>  .../media/uapi/v4l/vidioc-queryctrl.rst       |  4 ++++
>>>  .../media/videodev2.h.rst.exceptions          |  1 +
>>>  include/uapi/linux/videodev2.h                | 23 ++++++++++---------
>>>  3 files changed, 17 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
>>> index f824162d0ea9..b08c69cedb92 100644
>>> --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
>>> +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
>>> @@ -539,6 +539,10 @@ See also the examples in :ref:`control`.
>>>  	``V4L2_CTRL_FLAG_GRABBED`` flag when buffers are allocated or
>>>  	streaming is in progress since most drivers do not support changing
>>>  	the format in that case.
>>> +    * - ``V4L2_CTRL_FLAG_REQUIRES_REQUESTS``
>>> +      - 0x0800
>>> +      - This control cannot be set directly, but only through a request
>>> +        (i.e. by setting ``which`` to ``V4L2_CTRL_WHICH_REQUEST_VAL``).
>>>  
>>>  
>>>  Return Value
>>> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
>>> index 64d348e67df9..0caa72014dba 100644
>>> --- a/Documentation/media/videodev2.h.rst.exceptions
>>> +++ b/Documentation/media/videodev2.h.rst.exceptions
>>> @@ -351,6 +351,7 @@ replace define V4L2_CTRL_FLAG_VOLATILE control-flags
>>>  replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
>>>  replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
>>>  replace define V4L2_CTRL_FLAG_MODIFY_LAYOUT control-flags
>>> +replace define V4L2_CTRL_FLAG_REQUIRES_REQUESTS control-flags
>>>  
>>>  replace define V4L2_CTRL_FLAG_NEXT_CTRL control
>>>  replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 7f035d44666e..a78bfdc1df97 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -1736,17 +1736,18 @@ struct v4l2_querymenu {
>>>  } __attribute__ ((packed));
>>>  
>>>  /*  Control flags  */
>>> -#define V4L2_CTRL_FLAG_DISABLED		0x0001
>>> -#define V4L2_CTRL_FLAG_GRABBED		0x0002
>>> -#define V4L2_CTRL_FLAG_READ_ONLY	0x0004
>>> -#define V4L2_CTRL_FLAG_UPDATE		0x0008
>>> -#define V4L2_CTRL_FLAG_INACTIVE		0x0010
>>> -#define V4L2_CTRL_FLAG_SLIDER		0x0020
>>> -#define V4L2_CTRL_FLAG_WRITE_ONLY	0x0040
>>> -#define V4L2_CTRL_FLAG_VOLATILE		0x0080
>>> -#define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
>>> -#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
>>> -#define V4L2_CTRL_FLAG_MODIFY_LAYOUT	0x0400
>>> +#define V4L2_CTRL_FLAG_DISABLED			0x0001
>>> +#define V4L2_CTRL_FLAG_GRABBED			0x0002
>>> +#define V4L2_CTRL_FLAG_READ_ONLY		0x0004
>>> +#define V4L2_CTRL_FLAG_UPDATE			0x0008
>>> +#define V4L2_CTRL_FLAG_INACTIVE			0x0010
>>> +#define V4L2_CTRL_FLAG_SLIDER			0x0020
>>> +#define V4L2_CTRL_FLAG_WRITE_ONLY		0x0040
>>> +#define V4L2_CTRL_FLAG_VOLATILE			0x0080
>>> +#define V4L2_CTRL_FLAG_HAS_PAYLOAD		0x0100
>>> +#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE		0x0200
>>> +#define V4L2_CTRL_FLAG_MODIFY_LAYOUT		0x0400
>>> +#define V4L2_CTRL_FLAG_REQUIRES_REQUESTS	0x0800
>>>  
>>>  /*  Query flags, to be ORed with the control ID */
>>>  #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
>>>

