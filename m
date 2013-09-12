Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52285 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3ILRKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 13:10:16 -0400
Received: by mail-ob0-f174.google.com with SMTP id uz6so83855obc.19
        for <linux-media@vger.kernel.org>; Thu, 12 Sep 2013 10:10:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <523069C8.2010606@xs4all.nl>
References: <CAPybu_3cOLztceJoNwyZQGuC8maNYKuunbxJRHt7X6nQHmCyhw@mail.gmail.com>
 <1378888254-5236-1-git-send-email-ricardo.ribalda@gmail.com>
 <52303233.6060504@xs4all.nl> <CAPybu_18+43UTxyxTRJ8DNqfxTOs+o3yv=32AaO7LHh9926QDg@mail.gmail.com>
 <52304AC6.5020107@xs4all.nl> <CAPybu_1cN1P2kPkAv20bM8pvPgMdYwwNQhyOEJJHNZ=r3xeokQ@mail.gmail.com>
 <523069C8.2010606@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 12 Sep 2013 19:09:56 +0200
Message-ID: <CAPybu_1BVqO9S+L_JO8+iBQxUzRJ_DhON-=TN4e5exdht-YL4A@mail.gmail.com>
Subject: Re: [PATCH] RFC: Support for multiple selections
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Wed, Sep 11, 2013 at 3:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Ricardo,
>
> On 09/11/2013 02:13 PM, Ricardo Ribalda Delgado wrote:
>> Hello Hans
>>
>> On Wed, Sep 11, 2013 at 12:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> Hi Ricardo,
>>>
>>> On 09/11/2013 11:34 AM, Ricardo Ribalda Delgado wrote:
>>>> Hi Hans
>>>>
>>>> Thanks for your feedback
>>>>
>>>> On Wed, Sep 11, 2013 at 11:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>> Hi Ricardo,
>>>>>
>>>>> On 09/11/2013 10:30 AM, Ricardo Ribalda Delgado wrote:
>>>>>> A new id field is added to the struct selection. On devices that
>>>>>> supports multiple sections this id indicate which of the selection to
>>>>>> modify.
>>>>>>
>>>>>> A new control V4L2_CID_SELECTION_BITMASK selects which of the selections
>>>>>> are used, if the control is set to zero the default rectangles are used.
>>>>>>
>>>>>> This is needed in cases where the user has to change multiple selections
>>>>>> at the same time to get a valid combination.
>>>>>>
>>>>>> On devices where the control V4L2_CID_SELECTION_BITMASK does not exist,
>>>>>> the id field is ignored
>>>>>
>>>>> This feels like a hack to me. A big problem I have with using a control here
>>>>> is that with a control you can't specify for which selection target it is.
>>>>>
>>>>
>>>> I am not sure that I understand what you mean here.
>>>>
>>>> If you set the control to 0x1 you are using selection 0, if you set
>>>> the control to 0x5, you are using selection 0 and 2.
>>>
>>> If you look here:
>>>
>>> http://hverkuil.home.xs4all.nl/spec/media.html#v4l2-selection-targets
>>>
>>> you see that a selection has a 'target': i.e. does the selection define a crop
>>> rectangle, a compose rectange, a default crop rectangle, etc.
>>>
>>> You are extending the API to support multiple rectangles per target and using
>>> a control to select which rectangles are active (if I understand correctly).
>>> But that control does not (and cannot) specify for which target the rectangles
>>> should be activated.
>>
>> I want to have N crop rectangles and N compose rectangles. Every crop
>> rectangle has associated one compose rectangle.
>>
>> This will fit multiple purposes ie:
>>
>> - swap two areas of an image,
>> - multiple readout zones
>> - different decimation per area....
>>
>>
>>>
>>>>
>>>>
>>>>> If you want to set multiple rectangles, why not just pass them directly? E.g.:
>>>>>
>>>>> struct v4l2_selection {
>>>>>         __u32                   type;
>>>>>         __u32                   target;
>>>>>         __u32                   flags;
>>>>>         union {
>>>>>                 struct v4l2_rect        r;
>>>>>                 struct v4l2_rect        *pr;
>>>>>         };
>>>>>         __u32                   rectangles;
>>>>>         __u32                   reserved[8];
>>>>> };
>>>>>
>>>>> If rectangles > 1, then pr is used.
>>>>>
>>>>
>>>> The structure is passed in a ioctl and I dont think that it is a good
>>>> idea that you let the kernel get/set a memory address not encapsulated
>>>> in it. I can see that it could lead to security breaches if there is a
>>>> mistake on the handling.
>>>
>>> It's used in lots of places. It's OK, provided you check the memory carefully.
>>> See e.g. how VIDIOC_G/S_EXT_CTRLS is handled. Usually the memory checks are done
>>> in the v4l2 core and the driver doesn't need to take care of it.
>>>
>>
>> I agree IFF the v4l2 core does the checks. One question raises me: how
>> does the user knows how big is the structure he has to allocate for
>> g_selection? Do we have to make a new ioctl g_n_selections?
>
> I would suggest using the same method that is used by the extended control API for
> string controls: if rectangles is too small, then the driver sets the field to the
> total number of rectangles and returns -ENOSPC. The application can then reallocate
> the memory. I expect that applications that want to do this will actually know how
> many rectangles to allocate.
>

That seems fine for me.


>>>>> It's a bit more work to add this to the core code (VIDIOC_SUBDEV_G/S_SELECTION
>>>>> should probably be changed at the same time and you have to fix existing drivers
>>>>> to check/set the new rectangles field), but it scales much better.
>>>>
>>>> Also, we would be broking the ABI. Rectangles is not a mandatory
>>>> field, and has a value != 0.
>>>
>>> The spec clearly states that:
>>>
>>> "The flags and reserved fields of struct v4l2_selection are ignored and they must
>>>  be filled with zeros."
>>>
>>> Any app not doing that is not obeying the API and hence it is an application bug.
>>>
>>> It's standard practice inside the V4L2 API to handle reserved fields in that way,
>>> as it provides a mechanism to extend the API safely in the future.
>>>
>>
>> That is what I mean, the current programs are writing a 0 on that
>> field, but now they are required to write a 1, so the API is broken.
>> Maybe we should describe:
>> if rectangles is 0, the field r is used (legacy), otherwise the pr,
>> even for 1 (multi rectangle).
>
> That's actually what I meant: if rectangles is 0, it will be interpreted as 1.
> Sorry if I wasn't clear.
>
>>
>>>>
>>>> What we could do is leave the V4L2_CID_SELECTION_BITMASK  out of the
>>>> api, but keep the id field on the structure, so the user can define a
>>>> private control to do whatever he needs with the id field, wekeep the
>>>> ABI compatibility and no big changes are needed.
>>>
>>> I really don't like that. It artificially limits the number of rectangles to 32
>>> and makes the API just cumbersome to use.
>>
>> I wasn't seeing the 32 rectangles as a limitation, but if you think
>> that it is limiting, then the solution that you provide looks good.
>
> For things like object detection 32 is quite limiting, yes.
>
>>
>>>
>>> The changes aren't difficult, just a bit tedious, and the end result does exactly
>>> what you want and, I think, is also very useful for things like face detection or
>>> object detection in general where a list of rectangles (or points, which is just a
>>> 1x1 rectangle) has to be returned in an atomic manner.
>>>
>>> One thing that I am not certain about is whether v4l2_rect should be used when
>>> specifying multiple rectangles. I can imagine that rectangles have an additional
>>> type field (e.g. for face detection you might have rectangles for the left eye,
>>> right eye and mouth).
>>
>> That is where the id field was handy :), you could say rectangle
>> id=LEFT_EYE and then have private controls for removing red component
>> from rectangles which id is *_EYE.
>>
>> My approach was:
>> You use the s/g selection api to describe rectangles (input and
>> output) and then you use bitmap controls to do things on the
>> rectangles: compose,remove red eye, track.....
>
> I'm confused, I thought this was about multiple crop rectangles? Bitmask
> controls should definitely not be used to perform actions, that's not how
> they should be used. Only a 'button' control can perform an action.
>
> Basically I have no objection if the selection API is extended to support
> rectangle lists to allow multi-crop/compose scenarios. But extending it for
> effects like red eye removal is something that needs a lot more thought as
> I am not certain whether the selection API is suitable for that.
>

I only have a real need to extend if for multicrop/compose. But I
liked your idea of using the rectangles also for tracking objects.
That is why I added the id to the structure.

That way the selection api becomes a generic control for areas of the
image. But, we could just remove the id field, and use your original
idea. Leaving that discussion for later.

I will try to prepare a patch so we can talk about something real.
what do you think?

Thanks and best regards!

> Regards,
>
>         Hans
>
>>
>>>
>>> Regards,
>>>
>>>         Hans
>>
>> So
>>
>> If the 32 rectangle limitation is a nogo for you, then I would suggest:
>>
>> struct v4l2_selection {
>>          __u32                   type;
>>          __u32                   target;
>>          __u32                   flags;
>>           union {
>>                  struct v4l2_rect        r;
>>                  struct v4l2_rect        *pr;
>>          };
>>          __u32                   rectangles; //if 0, r is used,
>> otherwise pr with rectangle components
>>          __u32                   id;//0 for compose/crop , N->driver
>> dependent (face tracking....)
>>         __u32                   reserved[7];
>> };
>>
>> But:
>>  -memory handling has to be done in the core
>>  -we have to provide the user a way to know how many rectangles are in use.
>>
>>
>> If the 32 rectangle limitiation is acceptable I still like my first proposal.
>> But:
>> 32 rectangles means 32 ioctls.
>>
>>
>> Thanks for your feedback and promptly response :)
>>



-- 
Ricardo Ribalda
