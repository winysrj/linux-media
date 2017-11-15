Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:45482 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755502AbdKOKMW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 05:12:22 -0500
Subject: Re: [RFCv1 PATCH 0/6] v4l2-ctrls: implement requests
To: Alexandre Courbot <acourbot@chromium.org>
References: <20171113143408.19644-1-hverkuil@xs4all.nl>
 <05b8ed23-cea4-49a2-914d-3efb5ad2df30@chromium.org>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3d881ae9-97b1-6267-df77-39f96bdc7e09@xs4all.nl>
Date: Wed, 15 Nov 2017 11:12:19 +0100
MIME-Version: 1.0
In-Reply-To: <05b8ed23-cea4-49a2-914d-3efb5ad2df30@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

On 15/11/17 10:38, Alexandre Courbot wrote:
> Hi Hans!
> 
> Thanks for the patchset! It looks quite good at first sight, a few comments and
> questions follow though.
> 
> On Monday, November 13, 2017 11:34:02 PM JST, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Hi Alexandre,
>>
>> This is a first implementation of the request API in the
>> control framework. It is fairly simplistic at the moment in that
>> it just clones all the control values (so no refcounting yet for
>> values as Laurent proposed, I will work on that later). But this
>> should not be a problem for codecs since there aren't all that many
>> controls involved.
> 
> Regarding value refcounting, I think we can probably do without it if we parse
> the requests queue when looking values up. It may be more practical (having a
> kref for each v4l2_ctrl_ref in a request sounds overkill to me), and maybe also
> more predictible since we would have less chance of having dangling old values.
> 
>> The API is as follows:
>>
>> struct v4l2_ctrl_handler *v4l2_ctrl_request_alloc(void);
>>
>> This allocates a struct v4l2_ctrl_handler that is empty (i.e. has
>> no controls) but is refcounted and is marked as representing a
>> request.
>>
>> int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
>>                             const struct v4l2_ctrl_handler *from,
>>                             bool (*filter)(const struct v4l2_ctrl *ctrl));
>>
>> Delete any existing controls in handler 'hdl', then clone the values
>> from an existing handler 'from' into 'hdl'. If 'from' == NULL, then
>> this just clears the handler. 'from' can either be another request
>> control handler or a regular control handler in which case the
>> current values are cloned. If 'filter' != NULL then you can
>> filter which controls you want to clone.
> 
> One thing that seems to be missing is, what happens if you try to set a control
> on an empty request? IIUC this would currently fail because find_ref() would
> not be able to find the control. The value ref should probably be created in
> that case so we can create requests with a handful of controls.

Wasn't the intention that we never have an empty request but always clone?
I.e. in your code the _alloc call is always followed by a _clone call.

The reason I have a separate _alloc function is that you use that when you
want to create a new control handler ('new request'). If the user wants to reuse an
existing request, then _clone can be called directly on the existing handler.

> Also, if you clone a handler that is not a request, I understand that all
> controls will be deduplicated, creating a full-state copy? That could be useful,
> but since this is the only way to make the current code work, I hope that the
> current impossibility to set a control on an empty request is a bug (or misunderstanding from my part).

I think it is a misunderstanding. Seen from userspace you'll never have an empty
request.

> 
>>
>> void v4l2_ctrl_request_get(struct v4l2_ctrl_handler *hdl);
>>
>> Increase the refcount.
>>
>> void v4l2_ctrl_request_put(struct v4l2_ctrl_handler *hdl);
>>
>> Decrease the refcount and delete hdl if it reaches 0.
>>
>> void v4l2_ctrl_request_setup(struct v4l2_ctrl_handler *hdl);
>>
>> Apply the values from the handler (i.e. request object) to the
>> hardware.
>>
>> You will have to modify v4l_g/s/try_ext_ctrls in v4l2-ioctls.c to
>> obtain the request v4l2_ctrl_handler pointer based on the request
>> field in struct v4l2_ext_controls.
>>
>> The first patch in this series is necessary to avoid cloning
>> controls that belong to other devices (as opposed to the subdev
>> or bridge device for which you make a request). It can probably
>> be dropped for codecs, but it is needed for MC devices like
>> omap3isp.
>>
>> This series has only been compile tested! So if it crashes as
>> soon as you try to use it, then that's why :-)
>>
>> Note: I'm not sure if it makes sense to refcount the control
>> handler, you might prefer to have a refcount in a higher-level
>> request struct. If that's the case, then I can drop the _get
>> function and replace the _put function by a v4l2_ctrl_request_free()
>> function.
> 
> That's exactly what I thought when I saw the refcounting. This is probably a
> problem for later since we want to focus on codecs for now, but I think we will
> ultimately want to manage refcounting outside of v4l2_ctrl_handler. Maybe a
> higher-level request class of which the current control-framework based design
> would be an implementation. I am thinking about IPs like the VSP1 which will
> probably want to model the controls either in a different way, or at least to
> add extra data beyond the controls.
> 
> All in all I think I can use this for codecs. I am still trying to shoehorn my
> first version into the media stuff, and to nobody's surprise this is not that
> easy. :P But the fact the control framework part is already mostly taken care
> of greatly helps.

I agree with you that it is better to do the refcounting in a higher-level
request object. Just don't call _get and call _put when you want to free it.
We'll clean it up later.

Regards,

	Hans
