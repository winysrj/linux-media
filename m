Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3762 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3IKKt5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 06:49:57 -0400
Message-ID: <52304AC6.5020107@xs4all.nl>
Date: Wed, 11 Sep 2013 12:49:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] RFC: Support for multiple selections
References: <CAPybu_3cOLztceJoNwyZQGuC8maNYKuunbxJRHt7X6nQHmCyhw@mail.gmail.com> <1378888254-5236-1-git-send-email-ricardo.ribalda@gmail.com> <52303233.6060504@xs4all.nl> <CAPybu_18+43UTxyxTRJ8DNqfxTOs+o3yv=32AaO7LHh9926QDg@mail.gmail.com>
In-Reply-To: <CAPybu_18+43UTxyxTRJ8DNqfxTOs+o3yv=32AaO7LHh9926QDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 09/11/2013 11:34 AM, Ricardo Ribalda Delgado wrote:
> Hi Hans
> 
> Thanks for your feedback
> 
> On Wed, Sep 11, 2013 at 11:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Ricardo,
>>
>> On 09/11/2013 10:30 AM, Ricardo Ribalda Delgado wrote:
>>> A new id field is added to the struct selection. On devices that
>>> supports multiple sections this id indicate which of the selection to
>>> modify.
>>>
>>> A new control V4L2_CID_SELECTION_BITMASK selects which of the selections
>>> are used, if the control is set to zero the default rectangles are used.
>>>
>>> This is needed in cases where the user has to change multiple selections
>>> at the same time to get a valid combination.
>>>
>>> On devices where the control V4L2_CID_SELECTION_BITMASK does not exist,
>>> the id field is ignored
>>
>> This feels like a hack to me. A big problem I have with using a control here
>> is that with a control you can't specify for which selection target it is.
>>
> 
> I am not sure that I understand what you mean here.
> 
> If you set the control to 0x1 you are using selection 0, if you set
> the control to 0x5, you are using selection 0 and 2.

If you look here:

http://hverkuil.home.xs4all.nl/spec/media.html#v4l2-selection-targets

you see that a selection has a 'target': i.e. does the selection define a crop
rectangle, a compose rectange, a default crop rectangle, etc.

You are extending the API to support multiple rectangles per target and using
a control to select which rectangles are active (if I understand correctly).
But that control does not (and cannot) specify for which target the rectangles
should be activated.

> 
> 
>> If you want to set multiple rectangles, why not just pass them directly? E.g.:
>>
>> struct v4l2_selection {
>>         __u32                   type;
>>         __u32                   target;
>>         __u32                   flags;
>>         union {
>>                 struct v4l2_rect        r;
>>                 struct v4l2_rect        *pr;
>>         };
>>         __u32                   rectangles;
>>         __u32                   reserved[8];
>> };
>>
>> If rectangles > 1, then pr is used.
>>
> 
> The structure is passed in a ioctl and I dont think that it is a good
> idea that you let the kernel get/set a memory address not encapsulated
> in it. I can see that it could lead to security breaches if there is a
> mistake on the handling.

It's used in lots of places. It's OK, provided you check the memory carefully.
See e.g. how VIDIOC_G/S_EXT_CTRLS is handled. Usually the memory checks are done
in the v4l2 core and the driver doesn't need to take care of it.

>> It's a bit more work to add this to the core code (VIDIOC_SUBDEV_G/S_SELECTION
>> should probably be changed at the same time and you have to fix existing drivers
>> to check/set the new rectangles field), but it scales much better.
> 
> Also, we would be broking the ABI. Rectangles is not a mandatory
> field, and has a value != 0.

The spec clearly states that:

"The flags and reserved fields of struct v4l2_selection are ignored and they must
 be filled with zeros."

Any app not doing that is not obeying the API and hence it is an application bug.

It's standard practice inside the V4L2 API to handle reserved fields in that way,
as it provides a mechanism to extend the API safely in the future.

> 
> What we could do is leave the V4L2_CID_SELECTION_BITMASK  out of the
> api, but keep the id field on the structure, so the user can define a
> private control to do whatever he needs with the id field, wekeep the
> ABI compatibility and no big changes are needed.

I really don't like that. It artificially limits the number of rectangles to 32
and makes the API just cumbersome to use.

The changes aren't difficult, just a bit tedious, and the end result does exactly
what you want and, I think, is also very useful for things like face detection or
object detection in general where a list of rectangles (or points, which is just a
1x1 rectangle) has to be returned in an atomic manner.

One thing that I am not certain about is whether v4l2_rect should be used when
specifying multiple rectangles. I can imagine that rectangles have an additional
type field (e.g. for face detection you might have rectangles for the left eye,
right eye and mouth).

Regards,

	Hans
