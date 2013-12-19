Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:41514 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab3LSL57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:59 -0500
Received: by mail-ob0-f179.google.com with SMTP id wm4so1035111obc.24
        for <linux-media@vger.kernel.org>; Thu, 19 Dec 2013 03:57:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B2D3EA.8010307@samsung.com>
References: <1380623614-26265-1-git-send-email-ricardo.ribalda@gmail.com>
 <5268F714.3090004@samsung.com> <CAPybu_2p4AYxze-QMOZhMq+EYCEXN1KazZdQckWKub9kpAESfg@mail.gmail.com>
 <5282411E.9060309@samsung.com> <CAPybu_3G335UteUzyYUg4JfLBYQb7Pj4FYZmNjL9oDHk=vbuzA@mail.gmail.com>
 <52B2D3EA.8010307@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 19 Dec 2013 12:57:38 +0100
Message-ID: <CAPybu_3K6KPVk2xB6KoJ1LzdWJnFx5bc3gxBG=nLUvFYMusBEA@mail.gmail.com>
Subject: Re: [RFC v3] [RFC] v4l2: Support for multiple selections
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Tomasz

Thanks for your comments.

On Thu, Dec 19, 2013 at 12:09 PM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> Hi Ricardo,
> Please refer to the comments below.
>
> On 12/10/2013 09:37 AM, Ricardo Ribalda Delgado wrote:
>> Hello Tomasz
>>
>> Now is my time to say sorry for the delay, but i have been in holidays
>> and then I had a pile of work waiting on my desk :).
>>
>
> No problem.
>
>>
>>
>> On Tue, Nov 12, 2013 at 3:54 PM, Tomasz Stanislawski
>> <t.stanislaws@samsung.com> wrote:
>>> Hi Ricardo,
>>> Sorry for a late reply. I've been 'offline' for the last two weeks.
>>> Please refer to the comments below.
>
> [snip]
>
>>> As I said. Changes of rectangle n may trigger changes in rectangle n+1 and so on.
>>> So activation of rectangle B (setting height to non-zero value) will enable
>>> rectangle C with some default size. Moreover disabling rectangle B (setting height to 0)
>>> may disable rectangle C automatically. I do not follow what is the problem here?
>>>
>>
>> Lets say you want a configuration composed by 3 rectangles ABC and
>> there are no pair of rectangles with a legal configuration. You cannot
>> do step by step configuration.
>>
>> Also lets say that your sensor requires that the total size of the
>> image is 700 lines on 3 rectanges and 500 on 4. You cannot do this
>> configuration step by step.
>>
>>
>
> Please, give more details. I do not think that situation is that problematic.
> Is it even a practical limitation of hardware?

We have an fpga camera that uses X cycles to read a sensor. That X is
FIXED. Lets say it is 1000 lines time

The sensor is read linearly from a programmable address A. for a lines

You can program also address B for b lines

Jumping from the area A to the area B needs j lines time.

a+b+j must be equal to 1000.

On the multiselect, the user sets A and B, the constrains are verified
and the system is set.

On your proposal

Area A is set, but because the size is <1000, the driver changes the
size to 1000, probably also changing the initial line a.

Area B is set, the driver needs to resize the area A too, but the
initial line a (what the user wants) has been replaced by a driver
chossen a


This is a very simple example with 2 areas, extrapolate it to 8 areas.


>
>>> Hmm. I think that the real problem is much different.
>>> Not how to set up rectangles atomically but rather
>>> how do anything non-trivial atomically in V4L2.
>>>
>>> It would be very nice to have crop/compose and format configured at the same time.
>>> However, current version of V4L2 API does not support that.
>>>
>>> Setting multiple crop rectangles may help a bit for only this little case.
>>> But how would like to set multicrop rectangles and multicompose rectangle atomically.
>>> How to define which crop rectangle refers to which to which compose rectangle.
>>
>> The number of retangles in crop are the same number of rectables in the compose.
>>
>> Crop[0] corresponds to compose[0], crop[1]to compose[1] and so on....
>>
>
> I mean something different.
> While using multirectangle selection, one still must use two
> VIDIOC_S_SELECTION calls. One to set crop rectangles,
> second one to set compose rectangles.
> So you cannot set crop and compose atomically, anyway.

No, but I can set all the crop rectangles at once.

The driver then finds out a compatible configuration of  composing.

The user replaces that configuration (if needed) with a new compose.

Exactly the same as today with one rectangle..

>
> Hans proposed some extension to support atomic setup
> of both properties. However I think that it is a little overengineered.
>
> I still does not solve problems with flipping and rotations, which may
> have a huge impact on mulitrect cropping/composing limitations.

Flip and rotation is affected to whole sensor not to the specific rectangles.

>
>>>
>>> What to do if one would like to change only 3rd crop rectangle?
>>
>> You send the whole configuration. The same as today when the user only
>> wants to change the pixel format. He still have to send the size.
>>
>>>
>>> Introduce rectangle id into v4l2_ext_rect?
>>> Call VIDIOC_G_SELECTION to get all rectangles, change one and apply VIDIOC_S_SELECTION?
>>> Is it really scalable?
>>
>>  Why it is not scalable?It is much more scalable than 8 ioctls to set
>> 8 rectangles.
>>
>>
>
> One has to copy_from_user/copy_to_user an arbitrary amount of data.
> One cannot say "I would like to change rectangle number 5".
> Using single S_SELECTION for 1 rectangle is only one ioctl need to be called.

If the user have saved the output of the previous s_selection he can
change a specific rectangle with one s_selection call

On the other hand he can even change all the rectangles with one
s_selection, on your example the user has to make N s_selection calls.

>
> When using multirect selections a kernel must copy
> all data to user (completely needlessly) during G_SELECTION.
> next, the kernel must load all rectangles back to kernel space
> (only one rectangle is actually needed to be copied).
>
> It is quite probable that copying 8 rectangle will NOT cause any
> performance issues. But copying 256 rectangles in both directions
> might cause an observable slowdown.

256 small ioctls are at least one order of mangniture slower that 1
ioctl with 256 times more memory send.

Also bare in mind that the most probable case takes 2 or 3 rectangles, not 256.


>
>>>
>>> Multirectangle targets may seam to be a solution but I think it is not.
>>>
>>> I think that atomic transactions are what is really needed in V4L2.
>>> Other ideas like try-context from subdev API may also help.
>>>
>>> It will be nice to have something like
>>>
>>> VIDIOC_BEGIN
>>>   VIDIOC_S_SELECTION (target = CROP)
>>>   VIDIOC_S_SELECTION (target = COMPOSE)
>>>   VIDIOC_S_FMT
>>>   VIDIOC_S_CTRL
>>> VIDIOC_COMMIT
>>>
>>> and call a bunch of VIDIOC_G_* to see what really was applied.
>>>
>>
>> This will trigger other isues. What we do if 2 programs starts two
>> transactions at the same time. We will keep a transaction array with
>> ALL the configurations? And what happens if there are 100?
>>
>>
>
> There are multiple ways to solve the problem.
> One options would be making VIDIOC_BEGIN a blocking operation
> so only one thread can access the critical section.

So, an app opens /dev/video0 , calls vidioc_begin, and no other user can use it.

>
> Other way would be creation of temporary configuration for
> each file handle and applying it after VIDIOC_COMMIT.
> The VIDIOC_COMMIT would he handled in a driver under a mutex.

So a driver has to anyway save a multirectangle structure in his
memory. The app will have to implement common algorithtms like
rectangle collide, rectangle reorder, max line counting....

IMHO: Even with transaction a multirectangle set is a good idea.

>
> There is a huge space for inventions here.
>
>>>>> I have an auxiliary question. Do you have to set all rectangles
>>>>> at once? can you set up them one by one?
>>>>
>>>> Also if you tell the driver what exact configuration you will need, it
>>>> will provide you with the closest possible confuration, that cannot be
>>>
>>> s/cannot be done/may not be 'doable'
>>
>> cannot be done. The driver cannot guess which rectangles will the user
>> set in the future.
>>
>>>
>>>> done if you provide rectangle by rectangle.
>>>>
>>>>> But how to deal with multiple rectangles?
>>>>
>>>> Multiple rectangles is a desired feature, please take a look to the
>>>> presentation on the workshop.
>>>>
>>>
>>> I agree that it may be useful. I just think that multirectangle selections
>>> are needed to add support for such a feature.
>>>
>>>>>
>>>>> Anyway, first try to define something like this:
>>>>>
>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT0  V4L2_SEL_TGT_PRIVATE
>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT0_DEFAULT  (V4L2_SEL_TGT_XXX_SCANOUT0 + 1)
>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT0_BOUNDS  (V4L2_SEL_TGT_XXX_SCANOUT0 + 2)
>>>>>
>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT0  (V4L2_SEL_TGT_PRIVATE + 16)
>>>>> ...
>>>>>
>>>>> -- OR-- parametrized macros similar to one below:
>>>>>
>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT(n) (V4L2_SEL_TGT_PRIVATE + 16 * (n))
>>>>>
>>>>> The application could setup all scanout areas one-by-one.
>>>>> By default V4L2_SEL_TGT_XXX_SCANOUT0 would be equal to the whole array.
>>>>> The height of all consecutive area would be 0. This means disabling
>>>>> them effectively.
>>>>
>>>> Lets say rectangle A + B + C +D is legal, and A +B is also legal. You
>>>> are in ABCD and you want to go to AB. How can you do it?
>>>
>>> Just set C to have height 0. It will disable D automatically.
>>
>> And what if I have ABCDE and I want to go to ABE?
>>
>> As I said before the causistic of the sensors is inmense. Why limit ourselves?
>>
>
> Please provide some example with detailed description.

We gave 3 rectangles

A: 0-10
B: 20-30
C: 40-50

we want a setup with

A: 0-10
C: 40-50

If I remove B with your proposal also C is removed, so I have to
create it again.

Also take a look to the very first example, there are sensors that
require that the total amount of lines to be X


>
>>>
>>> BTW. How are you going to emulate S_CROP by selection API
>>> if you must use at least two rectangles (A + B) ?
>>
>>
>> Simple, you dont.
>>
>
> Sorry but I do not follow.
> Driver must setup a configuration that is the most similar to user's request.
> It is not allowed to return EINVAL. The selections are allowed to
> return -ERANGE if rectangle is not consistent with constraints.
> However, using constraints is optional, so applications that uses
> constraints expects that ioctl might fail.
>
> If HW supports crop the it should allow user to set crop.
> Support for one rectangle can be emulated using 2 rectangles.
> So I see no reason to give up support for single rectangle crop.
>

And what if the rectangless cannot be contiguous?

I think that if the HW requires more than 1 rectangle S/G_CROP must
not be implemented in the driver.


>>>
>>> I suggest to use SCANOUT target in your first implementation.
>>> Notice that as long you use something different from CROP and COMPOSE,
>>> you may define interactions and dependencies any way you want, like
>>> - if change of scanout area can affect composing area
>>> - interaction with format and frame size
>>> - check if scanout area can overlap, multi crops should be allowed to overlap
>>>
>>> See if it will be sufficient.
>>> See what kind of problems you encouter.
>>
>> On the process of the RFC I have used in our system all the
>> implementations. So far the only that has worked 100% is the solution
>> where the user present all the rectangles at once to the driver.
>>
>
> What were the problems with "the other" implementations?
> Maybe they could be fixed/improved to support
> the multirect feature without those huge API extensions.
> Please provide more practical details.
> I mean detailed HW limitations, and application needs.

It is mainly the first example. The driver can take more educated
guesses of what the user needs if it the user gives as much
information as possible. There were some setups what could not be
achieved by setting the rectangles one by one

>
>>>
>>>>
>>>> If yo dissable C or D, the configuration is ilegal and therefor the
>>>> driver will return -EINVAL. So once you are in ABCD you cannot go
>>>> back...
>>>>
>>>
>>> The driver must not return EINVAL as long as it is possible to
>>> adjust values passed by user to some valid configuration.
>>> If configuration is fixed then VIDIOC_S_SELECTION works
>>> effectively as VIDIOC_G_SELECTION.
>>>
>>>
>>>>
>>>>>
>>>>> The change of V4L2_SEL_TGT_XXX_SCANOUT0 would influence all consequtive
>>>>> rectangle by shifting them down or resetting them to height 0.
>>>>> Notice that as long as targets are driver specific you are free do define
>>>>> interaction between the targets.
>>>>>
>>>>> I hope that proposed solution is satisfactory.
>>>>
>>>> As stated before, please follow the previous comments on the rfc,
>>>> specially the ones from Hans.
>>>>
>>>>>
>>>>> BTW. I think that the HW trick you described is not cropping.
>>>>> By cropping you select which part of sensor area is going
>>>>> to be processed into compose rectangle in a buffer.
>>>>
>>>> You are selecting part of the sensor, therefore you are cropping the image.
>>>>
>>>
>>> Yes, it is the same as long as you use only one rectangle.
>>>
>>> If using more then 1 the situation may become more complex.
>>> Currently a pair of composing and crop rectangles are used to setup scaling.
>>>
>>> You have to introduce a new definition of scaling factor if multirect crops are introduced.
>>
>> The number of rectangles must be the same on the croping and on the
>> composing. The scaling factor is defined by the relation between
>> compose[x]/crop[x]
>>
>>
>
> What happens if scaling factor must be the same for all rectangles due to HW limitations?
> How to choose the proper scaling factor is crop and compose rectangles
> are passed in separate ioctls?

How do we solve that today? Why it is different?

>
>>>
>>> Moreover what happens if flipping or rotation is applied?
>>
>> Flipping is applied to the whole sensor.
>>
>>> Currently only the content of the rectangle is rotated/flipped.
>>> If you use multi rectangle then content of each rectangle must be
>>> rotated/flipped separatelly. Are you sure that your hardware can do this?
>>
>> In our hardware there is a mapping core that can map any pixel in any
>> location. So yes :)
>>
>>
>
> So your HW is so sophisticated that using single rectangle selections
> (with small tweaks) might be good enough to configure your hardware.
> Please provide more details.

We have a working window A. Every pixel (x,y) can be remapped to any
pixel in the range (0,y-A) (MAX_X,y+A).

So we still need multirectangles.

Also, the core if after the sensor, and the best benefit is gained if
the data is NOT read from the sensor.


>
>>>
>>> What about layout of composing rectangle inside output buffer?
>>> Should it reflect the layout of crop rectangle or all of them should be
>>> independent.
>>>
>>> Of course you can always say that everything is driver dependent :).
>>>
>>> Anyway, adding multirectangle selections for crop/compose is openning Pandora's Box.
>>
>> I dont see why. When we defined the API we didn't consider the case of
>> multiples WOI, now we fix this.
>>
>
> Adding multiple instances of crop rectangle is not an issue in selection API.
> This API was designed to allow new targets (or ids per target) to be added.
>
> The real problem is passing all rectangles at one time.
> Using mutlirect selection may help a bit in your special case
> at a cost of API obfuscation.
> It still will not solve problems with interactions between
> format/crop/compose/flipping/rotation.
>
> Again. I think that transactions are the solution to many of those problems.
> I would be much more generic solutions than all hypothetical extensions
> to selections.
>
>>>
>>>>>
>>>>> So technicaly you still insert the whole sensor area into the buffer.
>>>>
>>>> Only the lines/columns are read into the buffer.
>>>>
>>>
>>> Yes, but where into a buffer?
>>> Does you HW support setting destination for every crop rectangle?
>>
>> The dma supports up to 256 destinations.
>>
>
> Nice. So may encounter performance issues while trying to change
> one rectangle using S_SELECTION :).

Less that trying to change all the rectangles at once :P

>
>>>
>>>>> Only part of the buffer is actually updated. So there is no cropping
>>>>> (cropping area is equal to the whole array).
>>>>>
>>>>> Notice, that every 'cropping' area goes to different part of a buffer.
>>>>> So you would need also muliple targets for composing (!!!) and very long
>>>>> chapter in V4L2 doc describing interactions between muliple-rectangle
>>>>> crops and compositions. Good luck !!! :).
>>>>
>>>> It is not that difficult to describe.
>>>>
>>>> You need the same ammount of rectangles in cropping and in compossing.
>>>> Rectangle X in cropping will be mapped to rectangle X in compose.
>>>>
>>>>
>>>>> Currently it is a hell to understand and define interaction between
>>>>> single crop, and compose and unfamous VIDIOC_S_FMT and m2m madness.
>>>>
>>>> On m2m devices we are only lacking a s_fmt on the first buffer, as we
>>>> have discussed on the workshop. I think we only lack a good reference
>>>> model in vivi.
>>>>
>>>>
>>>
>>> I was not present on the workshop. Could you provide more details?
>>>
>>>>>
>>>>> I strongly recommend to use private selections.
>>>>> It will be much simpler to define, implement, and modify if needed.
>>>>
>>>> I think the private selections will lead to specific applications for
>>>> specific drivers and we cannot support all the configurations with
>>>> them. Also there is no way for an app to enumerate that capability.
>>>
>>> call VIDIOC_G_SELECTION to check if a given SCANOUT is supported?
>>> EINVAL means that it is not supported.
>>
>> And then we will have X zillions of SCANOUTS, that is really the Pandora box :)
>>
>>
>
> Not exactly. I preferred to introduce a bunch of SCANOUT targets to
> avoid wasting reserved fields in struct v4l2_selection. There is
> a plenty of unused bits in v4l2_selection::target. However, it is still
> ok to introduce v4l2_selection::index field. The API is still pretty nice.
>
> I preferred to use new target called SCANOUTs to avoid mixing
> this multirectangle feature is crop/compose interactions.
> This fear might be considered was little premature (or even paranoid).
>
> I just wanted to open this "Pandora's Box" in same safer
> and less demanding environment.
> First trying to implement everything using some
> non-conflicting hw-specific target called SCANOUT.
> If it'd worked than one would make it an alias to CROP in
> a newer version of the kernel.
> Making it a part of main API will force you to support
> its functionality (even erroneous) in all future versions of kernel
> with no possibility to change it.
>
>>>
>>>>
>>>>>
>>>>> BTW2. I think that the mulitple scanout areas can be modelled using
>>>>> media device API. Sakari may know how to do this.
>>>>
>>>> The areas are not read from the sensor. Therefore they can only be
>>>> proccessed on the sensor subdevice.
>>>>
>>>>>
>>>>>
>>>>> Ad 2. Extended rectangles.
>>>>> It is a good idea because v4l2_rect lacks any place for extensions.
>>>>> But before adding it to V4L2 API, I would like to know the examples
>>>>> of actual applications. Please, point drivers that actually need it.
>>>>
>>>> I have no need for it, but now that we are extending the selection API
>>>> it would be the perfect moment to add them.
>>>
>>> The perfect moment for adding something is when it is needed.
>>
>> If we add the extended rectangles. Why using a structure that we
>> cannot extend in the future?
>>
>
> Basically, because it is good enough.
> Introducting extended rectangles breaks symmetry between
> singlerect and multirect selections.
> v4l2_rect is used in other structures like v4l2_clip, v4l2_crop, v4l2_window, etc.
> Why not enhancing them with this new extended rectangle?
> Moreover, it violates "Rule of Least Surprise" from "Unix Philosophy".
> Why setting number of rectangles changes the structure type.
>
> Please, first find a real application that really cannot be implemented
> without introducing extended rectangle before extending the API.
>
> The extended rectangles are an orthogonal feature to multirect selections
> and can be added later.
>
> Regards,
>
> Tomasz Stanislawski
>


I am ok with not adding the ext_rect, but I really think we need the
multirect, even with transactions.

The multiple rectangle via id uses the same amount of reserved fields
but requires more ioctl calls.

The multiple rectangle will be more deterministic that setting one
rectangle at a time, because the driver has to take decisions for
every rectangle set.

With multiple rectangle we can create a bunch of function helpers that
can be used by the device driver, instead of reinventing the wheel
every-time.

Multirectangle is just the equivalent of multi control set/get.

Regards!


-- 
Ricardo Ribalda
