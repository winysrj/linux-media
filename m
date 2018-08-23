Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51592 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727153AbeHWNOS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 09:14:18 -0400
Subject: Re: [RFC] Request API questions
To: Tomasz Figa <tfiga@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, nicolas@ndufresne.ca
References: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
 <20180816081522.76f71891@coco.lan>
 <CAAFQd5C9y2oZJ7HpRqCVqNhsMgUbnoxcafumX1fU9oXMnjiuww@mail.gmail.com>
 <3b59475f-b06e-4d9a-868c-04f608677cca@xs4all.nl>
 <CAAFQd5DsGgdUrfhcvBHyzbAHpKuFV_oTiBxVQKPYpWu1GtFz-w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <28da08a6-f1f4-47ca-e4d3-94bbd38303e8@xs4all.nl>
Date: Thu, 23 Aug 2018 11:45:18 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DsGgdUrfhcvBHyzbAHpKuFV_oTiBxVQKPYpWu1GtFz-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/20/18 09:17, Tomasz Figa wrote:
> Hi Hans,
> 
> On Fri, Aug 17, 2018 at 7:09 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 17/08/18 12:02, Tomasz Figa wrote:
>>> On Thu, Aug 16, 2018 at 8:15 PM Mauro Carvalho Chehab
>>> <mchehab+samsung@kernel.org> wrote:
>>>>
>>>> Em Thu, 16 Aug 2018 12:25:25 +0200
>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>>
> [snip]
>>>>> 3) Calling VIDIOC_G_EXT_CTRLS for a request that has not been queued yet will
>>>>>    return either the value of the control you set earlier in the request, or
>>>>>    the current HW control value if it was never set in the request.
>>>>>
>>>>>    I believe it makes sense to return what was set in the request previously
>>>>>    (if you set it, you should be able to get it), but it is an idea to return
>>>>>    ENOENT when calling this for controls that are NOT in the request.
>>>>>
>>>>>    I'm inclined to implement that. Opinions?
>>>>
>>>> Return the request "cached" value, IMO, doesn't make sense. If the
>>>> application needs such cache, it can implement itself.
>>>
>>> Can we think about any specific use cases for a user space that first
>>> sets a control value to a request and then needs to ask the kernel to
>>> get the value back? After all, it was the user space which set the
>>> value, so I'm not sure if there is any need for the kernel to be an
>>> intermediary here.
>>>
>>>>
>>>> Return an error code if the request has not yet completed makes
>>>> sense. Not sure what would be the best error code here... if the
>>>> request is queued already (but not processed), EBUSY seems to be the
>>>> better choice, but, if it was not queued yet, I'm not sure. I guess
>>>> ENOENT would work.
>>>
>>> IMHO, as far as we assign unique error codes for different conditions
>>> and document them well, we should be okay with any not absurdly
>>> mismatched code. After all, most of those codes are defined for file
>>> system operations and don't really map directly to anything else.
>>>
>>> FYI, VIDIOC_G_(EXT_)CTRL returns EINVAL if an unsupported control is
>>> queried, so if we decided to keep the "cache" functionality after all,
>>> perhaps we should stay consistent with it?
>>> Reference: https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-ext-ctrls.html#return-value
>>>
>>> My suggestion would be:
>>>  - EINVAL: the control was not in the request, (if we keep the cache
>>> functionality)
>>>  - EPERM: the value is not ready, (we selected this code for Decoder
>>> Interface to mean that CAPTURE format is not ready, which is similar;
>>> perhaps that could be consistent?)
>>>
>>> Note that EINVAL would only apply to writable controls, while EPERM
>>> only to volatile controls, since the latter can only change due to
>>> request completion (non-volatile controls can only change as an effect
>>> of user space action).
>>>
>>
>> I'm inclined to just always return EPERM when calling G_EXT_CTRLS for
>> a request. We can always relax this in the future.
>>
>> So when a request is not yet queued G_EXT_CTRLS returns EPERM, when
>> queued but not completed it returns EBUSY and once completed it will
>> work as it does today.
> 
> Not sure I'm following. What do we differentiate between with EPERM
> and EBUSY? In both cases the value is not available yet and for codecs
> we decided to have that signaled by EPERM.

EBUSY is only returned when you attempt to set a control that temporarily
cannot be written (usually because you are streaming and changing the
control value would break something).

Getting a control from a request that is not completed is in this proposal
just not permitted (at least for now, this might be relaxed in the future).

Thinking some more about this I believe that the correct error code to
return here is EACCES. This is currently returned if you try to get a
write-only control. Controls in a request are basically write-only
controls until the request completes, so this makes sense to me.


> On top of that, I still think we should be able to tell the case of
> querying for a control that can never show up in the request, even
> after it completes, specifically for any non-volatile control. That
> could be done by returning a different code and -EINVAL would match
> the control API behavior without requests.

Why can't you get non-volatile controls? I fail to see why volatile
or non-volatile makes any difference. It is perfectly fine to get
a non-volatile control from a completed request. I.e. if you set a
control like GAIN in a request, then you want to read back the
gain value used when the request was applied. There is no guarantee
that the driver didn't change the requested gain when it actually
applied it.

Regards,

	Hans

> 
> The general logic would be like the pseudo code below:
> 
> G_EXT_CTRLS()
> {
>     if ( control is not volatile )
>         return -EINVAL;
> 
>     if ( request is not complete )
>         return -EPERM;
> 
>     return control from the request;
> }
> 
> Best regards,
> Tomasz
> 
