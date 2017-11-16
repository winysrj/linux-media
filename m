Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58132 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756376AbdKPJNa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 04:13:30 -0500
Subject: Re: [RFCv1 PATCH 0/6] v4l2-ctrls: implement requests
To: Alexandre Courbot <acourbot@chromium.org>
References: <20171113143408.19644-1-hverkuil@xs4all.nl>
 <05b8ed23-cea4-49a2-914d-3efb5ad2df30@chromium.org>
 <3d881ae9-97b1-6267-df77-39f96bdc7e09@xs4all.nl>
 <CAPBb6MWhAL7mOhgCwTE=y=VQVZQQkok2FvQapvA6e1UwDaE8sw@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4fca1c54-4aae-9957-84fd-2b8bcdf6d698@xs4all.nl>
Date: Thu, 16 Nov 2017 10:13:28 +0100
MIME-Version: 1.0
In-Reply-To: <CAPBb6MWhAL7mOhgCwTE=y=VQVZQQkok2FvQapvA6e1UwDaE8sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/11/17 09:48, Alexandre Courbot wrote:
> Hi Hans,
> 
> On Wed, Nov 15, 2017 at 7:12 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Alexandre,
>>
>> On 15/11/17 10:38, Alexandre Courbot wrote:
>>> Hi Hans!
>>>
>>> Thanks for the patchset! It looks quite good at first sight, a few comments and
>>> questions follow though.
>>>
>>> On Monday, November 13, 2017 11:34:02 PM JST, Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Hi Alexandre,
>>>>
>>>> This is a first implementation of the request API in the
>>>> control framework. It is fairly simplistic at the moment in that
>>>> it just clones all the control values (so no refcounting yet for
>>>> values as Laurent proposed, I will work on that later). But this
>>>> should not be a problem for codecs since there aren't all that many
>>>> controls involved.
>>>
>>> Regarding value refcounting, I think we can probably do without it if we parse
>>> the requests queue when looking values up. It may be more practical (having a
>>> kref for each v4l2_ctrl_ref in a request sounds overkill to me), and maybe also
>>> more predictible since we would have less chance of having dangling old values.
>>>
>>>> The API is as follows:
>>>>
>>>> struct v4l2_ctrl_handler *v4l2_ctrl_request_alloc(void);
>>>>
>>>> This allocates a struct v4l2_ctrl_handler that is empty (i.e. has
>>>> no controls) but is refcounted and is marked as representing a
>>>> request.
>>>>
>>>> int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
>>>>                             const struct v4l2_ctrl_handler *from,
>>>>                             bool (*filter)(const struct v4l2_ctrl *ctrl));
>>>>
>>>> Delete any existing controls in handler 'hdl', then clone the values
>>>> from an existing handler 'from' into 'hdl'. If 'from' == NULL, then
>>>> this just clears the handler. 'from' can either be another request
>>>> control handler or a regular control handler in which case the
>>>> current values are cloned. If 'filter' != NULL then you can
>>>> filter which controls you want to clone.
>>>
>>> One thing that seems to be missing is, what happens if you try to set a control
>>> on an empty request? IIUC this would currently fail because find_ref() would
>>> not be able to find the control. The value ref should probably be created in
>>> that case so we can create requests with a handful of controls.
>>
>> Wasn't the intention that we never have an empty request but always clone?
>> I.e. in your code the _alloc call is always followed by a _clone call.
>>
>> The reason I have a separate _alloc function is that you use that when you
>> want to create a new control handler ('new request'). If the user wants to reuse an
>> existing request, then _clone can be called directly on the existing handler.
>>
>>> Also, if you clone a handler that is not a request, I understand that all
>>> controls will be deduplicated, creating a full-state copy? That could be useful,
>>> but since this is the only way to make the current code work, I hope that the
>>> current impossibility to set a control on an empty request is a bug (or misunderstanding from my part).
>>
>> I think it is a misunderstanding. Seen from userspace you'll never have an empty
>> request.
> 
> It depends on what we want requests to be:
> 
> (1) A representation of what the complete state of the device should
> be when processing buffers, or
> 
> (2) A set of controls to be applied before processing buffers.
> 
> IIUC your patchset currently implements (1): as we clone a request (or
> the current state of the device), we create a new ref for every
> control that is not inherited. And when applying the request, we
> consider all these controls again.
> 
> There is the fact that on more complex pipelines, the number of
> controls may be big enough that we may want to limit the number we
> need to manage per request, but my main concern is that this will
> probably disallow some use-cases that we discussed in Prague.
> 
> For instance, let's say I create a request for a camera sensor by
> cloning the device's control_handler, and set a few controls like
> exposure that I want to be used for a give frame. But let's also say
> that I have another thread taking care of focus on the same device -
> this thread uses some other input to constantly adjust the focus by
> calling S_EXT_CTRLS directly (i.e. without a request). When my request
> gets processed, the focus will be reset to whatever it was when I
> cloned the request, which we want to avoid (if you remember, I
> interrupted Laurent to ask whether this is the behavior we wanted, and
> we all agreed it was).
> 
> Or maybe I am missing something in your implementation?

Such things are simply not yet implemented. This is just a first version
that should be good enough for codecs. Once we have something up and
running that can be used for some real-life testing, then I will work on
this some more.

> That does not change the fact that I keep working on codecs using the
> current model, but I think we will want to address this. The simplest
> way to do this would be to only create refs for controls that we
> explicitly change (or when cloning a request and not the
> state_handler). It would also have the added benefit of reducing the
> number of refs. :)

Memory usage is not the problem here as compared to buffers the memory used
by requests is tiny. My plan is to be smart with how p_req is set. Right now
it always points to the local copy, but this can point to wherever the
'previous' value is stored. I have several ideas, but I rather wait until
I have something I can test.

But in any case, a control handler should have refs to all the controls,
that's how it works.

Regards,

	Hans
