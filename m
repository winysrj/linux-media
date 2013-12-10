Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43949 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3LJIha (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 03:37:30 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so5209615oag.30
        for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 00:37:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5282411E.9060309@samsung.com>
References: <1380623614-26265-1-git-send-email-ricardo.ribalda@gmail.com>
 <5268F714.3090004@samsung.com> <CAPybu_2p4AYxze-QMOZhMq+EYCEXN1KazZdQckWKub9kpAESfg@mail.gmail.com>
 <5282411E.9060309@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 10 Dec 2013 09:37:10 +0100
Message-ID: <CAPybu_3G335UteUzyYUg4JfLBYQb7Pj4FYZmNjL9oDHk=vbuzA@mail.gmail.com>
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

Now is my time to say sorry for the delay, but i have been in holidays
and then I had a pile of work waiting on my desk :).



On Tue, Nov 12, 2013 at 3:54 PM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> Hi Ricardo,
> Sorry for a late reply. I've been 'offline' for the last two weeks.
> Please refer to the comments below.
>
> On 10/28/2013 11:46 PM, Ricardo Ribalda Delgado wrote:
>> Hello Tomasz
>>
>> Sorry for the late reply, but I have been offline the last week due to
>> the conference.
>>
>>
>> On Thu, Oct 24, 2013 at 12:31 PM, Tomasz Stanislawski
>> <t.stanislaws@samsung.com> wrote:
>>> Hi Ricardo,
>>> I am the designer of selection API. I hope I can help you a little.
>>> I think that there are two issues mixed in 'Mulitple selections' topic.
>>>
>>> Firstly, you described that you program a piece of hardware that is
>>> capable of selecting 8 areas for scanning. Now you
>>> are looking for userspace API to support such a feature.
>>> The feature of posting multiple rectangle was proposed in this RFC.
>>>
>>> Secondly, You introduced struct v4l2_ext_rect which is a future-proof
>>> version of v4l2_rect.
>>>
>>>
>>> I think that both issues should be solved in two separate patchsets.
>>>
>>> Ad 1.
>>> The selection of multiple scanning areas is a very driver-specific
>>> feature, isn't it? I think that you do not need to introduce any abstract
>>> interface. What would be other applications of the proposed interface?
>>
>> It is not driver specific. There are many sensors out there that
>> supports multiple window of interest, but today we are ignoring them
>> just because we dont have an api.
>>
>> The main application would be industrial imaging, where less data to
>> read means more fps and therefore the system can run faster.
>>
>> From my field I can tell you that it is a hard requirement for
>> computer vision. And it is a feature that we cannot model through v4l2
>> controls.
>>
>>
>
> OK. So there is no need to implement this feature as a driver-specific API.
> It can go automatically to generic API.
>
>>> Do you know other drivers that may need it? Sakari mentioned introduction
>>> of private targets for selections. I like this idea. Just define:
>>>
>>> #define V4L2_SEL_TGT_PRIVATE     0x80000000
>>>
>>> All targets that are >= V4L2_SEL_TGT_PRIVATE are driver-specific.
>>> Generic applications must not use them. Non-generic application
>>> must check out the driver of video node before using selections
>>> from private set. If some target becomes more useful and accepted
>>> by more then one driver then it can be moved to generic API.
>>> The good thing about private target is that enums from different
>>> drivers can collide so the target space is not going to be trashed.
>>>
>>
>> If you read the previous RFCs you will see that the approach you are
>> mentioning has been rejected.
>>
>> The main issue is that you cannot set atomically all the rectangles.
>> Lets say that the configuration formed by rectangle A, B and C is
>> legal, but the configuration A and B is not allowed by the sensor. How
>> could you set the rectangles one by one?
>>
>
> As I said. Changes of rectangle n may trigger changes in rectangle n+1 and so on.
> So activation of rectangle B (setting height to non-zero value) will enable
> rectangle C with some default size. Moreover disabling rectangle B (setting height to 0)
> may disable rectangle C automatically. I do not follow what is the problem here?
>

Lets say you want a configuration composed by 3 rectangles ABC and
there are no pair of rectangles with a legal configuration. You cannot
do step by step configuration.

Also lets say that your sensor requires that the total size of the
image is 700 lines on 3 rectanges and 500 on 4. You cannot do this
configuration step by step.


> Hmm. I think that the real problem is much different.
> Not how to set up rectangles atomically but rather
> how do anything non-trivial atomically in V4L2.
>
> It would be very nice to have crop/compose and format configured at the same time.
> However, current version of V4L2 API does not support that.
>
> Setting multiple crop rectangles may help a bit for only this little case.
> But how would like to set multicrop rectangles and multicompose rectangle atomically.
> How to define which crop rectangle refers to which to which compose rectangle.

The number of retangles in crop are the same number of rectables in the compose.

Crop[0] corresponds to compose[0], crop[1]to compose[1] and so on....

>
> What to do if one would like to change only 3rd crop rectangle?

You send the whole configuration. The same as today when the user only
wants to change the pixel format. He still have to send the size.

>
> Introduce rectangle id into v4l2_ext_rect?
> Call VIDIOC_G_SELECTION to get all rectangles, change one and apply VIDIOC_S_SELECTION?
> Is it really scalable?

 Why it is not scalable?It is much more scalable than 8 ioctls to set
8 rectangles.


>
> Multirectangle targets may seam to be a solution but I think it is not.
>
> I think that atomic transactions are what is really needed in V4L2.
> Other ideas like try-context from subdev API may also help.
>
> It will be nice to have something like
>
> VIDIOC_BEGIN
>   VIDIOC_S_SELECTION (target = CROP)
>   VIDIOC_S_SELECTION (target = COMPOSE)
>   VIDIOC_S_FMT
>   VIDIOC_S_CTRL
> VIDIOC_COMMIT
>
> and call a bunch of VIDIOC_G_* to see what really was applied.
>

This will trigger other isues. What we do if 2 programs starts two
transactions at the same time. We will keep a transaction array with
ALL the configurations? And what happens if there are 100?


>>> I have an auxiliary question. Do you have to set all rectangles
>>> at once? can you set up them one by one?
>>
>> Also if you tell the driver what exact configuration you will need, it
>> will provide you with the closest possible confuration, that cannot be
>
> s/cannot be done/may not be 'doable'

cannot be done. The driver cannot guess which rectangles will the user
set in the future.

>
>> done if you provide rectangle by rectangle.
>>
>>> But how to deal with multiple rectangles?
>>
>> Multiple rectangles is a desired feature, please take a look to the
>> presentation on the workshop.
>>
>
> I agree that it may be useful. I just think that multirectangle selections
> are needed to add support for such a feature.
>
>>>
>>> Anyway, first try to define something like this:
>>>
>>> #define V4L2_SEL_TGT_XXX_SCANOUT0  V4L2_SEL_TGT_PRIVATE
>>> #define V4L2_SEL_TGT_XXX_SCANOUT0_DEFAULT  (V4L2_SEL_TGT_XXX_SCANOUT0 + 1)
>>> #define V4L2_SEL_TGT_XXX_SCANOUT0_BOUNDS  (V4L2_SEL_TGT_XXX_SCANOUT0 + 2)
>>>
>>> #define V4L2_SEL_TGT_XXX_SCANOUT0  (V4L2_SEL_TGT_PRIVATE + 16)
>>> ...
>>>
>>> -- OR-- parametrized macros similar to one below:
>>>
>>> #define V4L2_SEL_TGT_XXX_SCANOUT(n) (V4L2_SEL_TGT_PRIVATE + 16 * (n))
>>>
>>> The application could setup all scanout areas one-by-one.
>>> By default V4L2_SEL_TGT_XXX_SCANOUT0 would be equal to the whole array.
>>> The height of all consecutive area would be 0. This means disabling
>>> them effectively.
>>
>> Lets say rectangle A + B + C +D is legal, and A +B is also legal. You
>> are in ABCD and you want to go to AB. How can you do it?
>
> Just set C to have height 0. It will disable D automatically.

And what if I have ABCDE and I want to go to ABE?

As I said before the causistic of the sensors is inmense. Why limit ourselves?

>
> BTW. How are you going to emulate S_CROP by selection API
> if you must use at least two rectangles (A + B) ?


Simple, you dont.

>
> I suggest to use SCANOUT target in your first implementation.
> Notice that as long you use something different from CROP and COMPOSE,
> you may define interactions and dependencies any way you want, like
> - if change of scanout area can affect composing area
> - interaction with format and frame size
> - check if scanout area can overlap, multi crops should be allowed to overlap
>
> See if it will be sufficient.
> See what kind of problems you encouter.

On the process of the RFC I have used in our system all the
implementations. So far the only that has worked 100% is the solution
where the user present all the rectangles at once to the driver.

>
>>
>> If yo dissable C or D, the configuration is ilegal and therefor the
>> driver will return -EINVAL. So once you are in ABCD you cannot go
>> back...
>>
>
> The driver must not return EINVAL as long as it is possible to
> adjust values passed by user to some valid configuration.
> If configuration is fixed then VIDIOC_S_SELECTION works
> effectively as VIDIOC_G_SELECTION.
>
>
>>
>>>
>>> The change of V4L2_SEL_TGT_XXX_SCANOUT0 would influence all consequtive
>>> rectangle by shifting them down or resetting them to height 0.
>>> Notice that as long as targets are driver specific you are free do define
>>> interaction between the targets.
>>>
>>> I hope that proposed solution is satisfactory.
>>
>> As stated before, please follow the previous comments on the rfc,
>> specially the ones from Hans.
>>
>>>
>>> BTW. I think that the HW trick you described is not cropping.
>>> By cropping you select which part of sensor area is going
>>> to be processed into compose rectangle in a buffer.
>>
>> You are selecting part of the sensor, therefore you are cropping the image.
>>
>
> Yes, it is the same as long as you use only one rectangle.
>
> If using more then 1 the situation may become more complex.
> Currently a pair of composing and crop rectangles are used to setup scaling.
>
> You have to introduce a new definition of scaling factor if multirect crops are introduced.

The number of rectangles must be the same on the croping and on the
composing. The scaling factor is defined by the relation between
compose[x]/crop[x]


>
> Moreover what happens if flipping or rotation is applied?

Flipping is applied to the whole sensor.

> Currently only the content of the rectangle is rotated/flipped.
> If you use multi rectangle then content of each rectangle must be
> rotated/flipped separatelly. Are you sure that your hardware can do this?

In our hardware there is a mapping core that can map any pixel in any
location. So yes :)


>
> What about layout of composing rectangle inside output buffer?
> Should it reflect the layout of crop rectangle or all of them should be
> independent.
>
> Of course you can always say that everything is driver dependent :).
>
> Anyway, adding multirectangle selections for crop/compose is openning Pandora's Box.

I dont see why. When we defined the API we didn't consider the case of
multiples WOI, now we fix this.

>
>>>
>>> So technicaly you still insert the whole sensor area into the buffer.
>>
>> Only the lines/columns are read into the buffer.
>>
>
> Yes, but where into a buffer?
> Does you HW support setting destination for every crop rectangle?

The dma supports up to 256 destinations.

>
>>> Only part of the buffer is actually updated. So there is no cropping
>>> (cropping area is equal to the whole array).
>>>
>>> Notice, that every 'cropping' area goes to different part of a buffer.
>>> So you would need also muliple targets for composing (!!!) and very long
>>> chapter in V4L2 doc describing interactions between muliple-rectangle
>>> crops and compositions. Good luck !!! :).
>>
>> It is not that difficult to describe.
>>
>> You need the same ammount of rectangles in cropping and in compossing.
>> Rectangle X in cropping will be mapped to rectangle X in compose.
>>
>>
>>> Currently it is a hell to understand and define interaction between
>>> single crop, and compose and unfamous VIDIOC_S_FMT and m2m madness.
>>
>> On m2m devices we are only lacking a s_fmt on the first buffer, as we
>> have discussed on the workshop. I think we only lack a good reference
>> model in vivi.
>>
>>
>
> I was not present on the workshop. Could you provide more details?
>
>>>
>>> I strongly recommend to use private selections.
>>> It will be much simpler to define, implement, and modify if needed.
>>
>> I think the private selections will lead to specific applications for
>> specific drivers and we cannot support all the configurations with
>> them. Also there is no way for an app to enumerate that capability.
>
> call VIDIOC_G_SELECTION to check if a given SCANOUT is supported?
> EINVAL means that it is not supported.

And then we will have X zillions of SCANOUTS, that is really the Pandora box :)


>
>>
>>>
>>> BTW2. I think that the mulitple scanout areas can be modelled using
>>> media device API. Sakari may know how to do this.
>>
>> The areas are not read from the sensor. Therefore they can only be
>> proccessed on the sensor subdevice.
>>
>>>
>>>
>>> Ad 2. Extended rectangles.
>>> It is a good idea because v4l2_rect lacks any place for extensions.
>>> But before adding it to V4L2 API, I would like to know the examples
>>> of actual applications. Please, point drivers that actually need it.
>>
>> I have no need for it, but now that we are extending the selection API
>> it would be the perfect moment to add them.
>
> The perfect moment for adding something is when it is needed.

If we add the extended rectangles. Why using a structure that we
cannot extend in the future?

>
> The bad idea is preventing something from being added too early.
>
> Regards,
> Tomasz Stanislawski
>
>>
>> They could describe properties of the sensor, like tracking ids.
>>
>>>
>>> Other thing worth mentioning is reservation of few bits from
>>> v4l2_selection::flags to describe the type of data used for
>>> rectangle, v4l2_rect or v4l2_ext_rect. This way one can avoid
>>> introducting v4l2_selection::rectangles field.
>>>
>>> I hope you find this comments useful.
>>
>>
>> Regards
>>
>>>
>>> Regards,
>>> Tomasz Stanislawski
>>>
>>>
>>
>>
>>
>

Regards

-- 
Ricardo Ribalda
