Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57495 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3LSMe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 07:34:28 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY2000FT09DV870@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Dec 2013 12:34:26 +0000 (GMT)
Message-id: <52B2E7CB.2010004@samsung.com>
Date: Thu, 19 Dec 2013 13:34:19 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC v3] [RFC] v4l2: Support for multiple selections
References: <1380623614-26265-1-git-send-email-ricardo.ribalda@gmail.com>
 <5268F714.3090004@samsung.com>
 <CAPybu_2p4AYxze-QMOZhMq+EYCEXN1KazZdQckWKub9kpAESfg@mail.gmail.com>
 <5282411E.9060309@samsung.com> <5284A375.6000107@xs4all.nl>
 <5284EED2.4050400@samsung.com>
 <CAPybu_0bWQn6ynMsV-597tGa=FtR2AGULGMPM_zD9yknQkXNjQ@mail.gmail.com>
In-reply-to: <CAPybu_0bWQn6ynMsV-597tGa=FtR2AGULGMPM_zD9yknQkXNjQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 12/10/2013 10:46 AM, Ricardo Ribalda Delgado wrote:
> Hello Tomasz and Hans
> 
> On Thu, Nov 14, 2013 at 4:40 PM, Tomasz Stanislawski
> <t.stanislaws@samsung.com> wrote:
>> Hi Hans,
>>
>> On 11/14/2013 11:18 AM, Hans Verkuil wrote:
>>> Hi Tomasz,
>>>
>>> On 11/12/13 15:54, Tomasz Stanislawski wrote:
>>>> Hi Ricardo,
>>>> Sorry for a late reply. I've been 'offline' for the last two weeks.
>>>> Please refer to the comments below.
>>>>
>>
>> [snip]
>>
>>>>
>>>> As I said. Changes of rectangle n may trigger changes in rectangle n+1 and so on.
>>>> So activation of rectangle B (setting height to non-zero value) will enable
>>>> rectangle C with some default size. Moreover disabling rectangle B (setting height to 0)
>>>> may disable rectangle C automatically. I do not follow what is the problem here?
>>>
>>> The problem would be in a situation like this:
>>>
>>> ......
>>> .AA.B.
>>> ......   -->   AAB
>>> .C.DD.         CDD
>>> ......
>>>
>>> A-D are the rectangles you want to select. They are cropped as shown on the
>>> left and composed as shown on the right.
>>>
>>> >From what Ricardo told me the resulting composed image typically must be
>>> a proper rectangle without padding anywhere.
>>>
>>> Trying to add rectangles one at a time breaks down when adding C because
>>> the composition result is no longer a 'proper' rectangle. I don't see how
>>> you can set something like that up one rectangle at a time.
>>
>> I see the issue but I think that it is not a big problem.
>> Activating C forms a non-proper rectangle with A and B.
>> Therefore, driver must force enabling D to form a proper rectangle again.
>>
>> I mean that instead of enlarging C to sum of width of A and B,
>> the driver can implicitly activate D to ensure that A,B,C,D form a proper rectangle.
> 
> I think this will lead to X different drivers with X different behaviours.
> 

I sadly have to agree. All drivers behave differently.
But, is it really an issue?

As I understand a developer is responsible to assure that
future versions of driver works the same (in practical context)
when used by old applications.

The driver is allowed to interpret/adjust user calls.
This includes even ignoring them.

>>
>> The special target called V4L2_SEL_TGT_COMPOSE_PADDED was introduced
>> to inform application which part of a buffers if going to be modified
>> with some undefined value.
>>
>> I see nothing against setting a padded rectangle for C to a rectangle that
>> covers C and D or even the whole ABCD rectangle.
>> I think it could be a great application for PADDED target.
>> The application could easily detect which part of a buffer are affected.
>>
>> Even applications prepared to work with single crop devices
>> would still work after enabling multi crop mode.
>>
>> The setup of rectangles my look like this.
>>
>> ************************************************
>>
>> S_SELECTION(CROP0 = A)
>>
>> crop           compose
>> ----------------------
>> ......
>> .AA...
>> ......   -->   AA..
>> ......         ....
>> ......         ....
>>
>> G_SELECTION(COMPOSE0)
>>   AA..
>>   ....
>>   ....
>>
>>
>> G_SELECTION(COMPOSE0_PADDED)
>>   AA..
>>   ....
>>   ....
>>
>> ************************************************
>>
>> S_SELECTION(CROP1 = B)
>> ......
>> .AA.B.
>> ......   -->   AAB.
>> ......         ....
>> ......         ....
>>
>> G_SELECTION(COMPOSE0)
>>   AA..
>>   ....
>>   ....
>>
>> G_SELECTION(COMPOSE0_PADDED)
>>   AAA.
>>   ....
>>   ....
>>
>> G_SELECTION(COMPOSE1)
>>   ..B.
>>   ....
>>   ....
>>
>> G_SELECTION(COMPOSE1_PADDED)
>>   BBB.
>>   ....
>>   ....
>>
>>
>> ************************************************
>>
>> S_SELECTION(CROP2 = C) - D is activated implicitly
>> ......
>> .AA.B.
>> .C.DD.   -->   AAB.
>> ......         CDD.
>> ......         ....
>>
>> G_SELECTION(COMPOSE0_PADDED)
>>
>>   AAA.
>>   AAA.
>>   ....
>>
>> G_SELECTION(COMPOSE2)
>>   ....
>>   C...
>>   ....
>>
>>
>> G_SELECTION(COMPOSE2_PADDED)
>>   CCC.
>>   CCC.
>>   ....
>>
>> G_SELECTION(COMPOSE3)
>>   ....
>>   .DD.
>>   ....
>>
>>
>> G_SELECTION(COMPOSE3_PADDED)
>>   DDD.
>>   DDD.
>>   ....
>>
>> One may argue that all this logic is unnecessary after adding support
>> for multirect selections.
>> So, I kindly ask what should happen if someone call S_SELECTION
>> (in multirect mode) passing THREE rectangles A, B, and C (not D) ?
>>
>> The driver must adjust rectangles to some valid value. So it can
>> increase width of C or implicitly activate D or disable C.
>> I think that the best solution is activating D because
>> it allows to set size of C to the value closest to requested one.
>> Therefore logic for implicit activation of D should be implemented anyway.
> 
> You are assuming that the user will send you the rectangles in an
> order that "makes sense", but it is not always the case. On the other
> hand if you have all the rectangles, you can ALWAYS make the better
> decisition.
> 

Yes. I assume that a user will send rectangles in the right order.
It stated that changing order of V4L2 operations may result
is different configuration. So I do not see a problem that
a specific configuration can be achieved on specific hardware
only if operations are performed in specific order.

> On the other
> hand if you have all the rectangles, you can ALWAYS make the better
> decisition.

I agree completely.
To make a best decision you must have "all rectangles". It means both
cropping/composing and format which is also dependent of S_CROP (see V4L2 doc).
Moreover, having controls like rotation and flipping may be helpful.

So passing only crop rectangles is only a part of information needed to make
a best decision. Therefore, multirectangle selections are only a partial solution
to the problem of configuration. It is a workaround for the specific feature
of some hardware. Therefore, before merging multirect selections you must PROVE
that the existing solutions are not satisfactory in your case.
That you truly cannot use singlerect selections to configure
your piece of hardware (not some abstract HW).
You cannot say that it is impossible because you do not know how to do it.

I just want to avoid loosing time and obfuscating the API for a feature
that will not be even sufficient for future needs.

>>
>>>
>>> It makes much more sense to set everything up at once.
>>
>> I agree that it is better to set everything at once.
>> But I strongly believe that transactions are the proper way to achieve that.
>>
>> Not multirectangle selections.
>>
> 
> As I said before the transaction is something easier said than made.
> What happens if multiple users starts a transaction? What happen if in
> a transaction of 10 itmes, item 7 needs a readjusment by the driver?
> 

It is a very good question.
I have some ideas about transactions.
First, that there should some form of temporary configuration buffer.
This buffer could be singular. In such a case VIDIOC_BEGIN would
be a blocking ioctl.
Or every handle/thread could have its own configuration buffer.
The buffer would be processed at VIDIOC_COMMIT.
The values would be adjusted against HW limitations, current configuration
and the buffer itself.
Finally, all properties would be applied to HW.

As I said in previous email. There is a huge space for ideas.

> The selection API cannot cover a type of selection, therefore it
> should be fixed. Especially when it is something as easy as the
> propossed RFC.

No. It is by no means easy. It just pretends to be easy.
There is a very complex logic hidden behind this extension.

Just add v4l2_selection::index if you want to avoid utilizing bits
from v4l2_selection::target. Index is nice because 0 would
refer to first and usually only one crop rectangle.
Those are relatively simple to add with few lines of patch.

You can even use CROP target instead of SCANOUT.
You will responsible for fighting with nightmare of
backward compatibility and messy business logic hidden
in driver code.

I am strongly against passing all rectangles at the same time.
The simultaneous configuration should be a separate part of
V4L2 API.

> 
> 
>> It obfuscates API. It only pretends to fix a problem with applying
>> a part of configuration atomically.
>>
>>>
>>> BTW, what probably wasn't clear from Ricardo's explanation is that for every
>>> crop rectangle you must have a corresponding compose rectangle so that you
>>> know where to DMA it to.
>>>
>>> Your next question will be that it is a real problem that you can't set
>>> crop and compose simultaneously, and you are right about that. Read on for
>>> that... :-)
>>>
>>>> Hmm. I think that the real problem is much different.
>>>> Not how to set up rectangles atomically but rather
>>>> how do anything non-trivial atomically in V4L2.
>>>>
>>>> It would be very nice to have crop/compose and format configured at the same time.
>>>> However, current version of V4L2 API does not support that.
>>>>
>>>> Setting multiple crop rectangles may help a bit for only this little case.
>>>> But how would like to set multicrop rectangles and multicompose rectangle atomically.
>>>
>>> Why can't we extend the selection API a bit? How about this:
>>>
>>> #define V4L2_SEL_TGT_CROP_COMPOSE    0x0200
>>>
>>> struct v4l2_selection {
>>>         __u32                   type;
>>>         __u32                   target;
>>>         __u32                   flags;
>>>       union {
>>>               struct v4l2_rect        r;
>>>               struct v4l2_ext_rect    *pr;
>>>       };
>>>         __u32                   flags2;
>>>       union {
>>>               struct v4l2_rect        r2;
>>>               struct v4l2_ext_rect    *pr2;
>>>       };
>>>       __u32                   rectangles;
>>>         __u32                   reserved[3];
>>> };
>>>
>>> If the target is CROP_COMPOSE then flags & r define the crop rectangle, and
>>> flags2 & r2 define the compose rectangle. That way you can set them both
>>> atomically.
>>
>> I do not like this idea because:
>> - mix crop and composing generating semi-related cropcompose
> Now looking with some perspective the selection API, dont you think
> that the crop and compose are related enough to be set at the same
> time?
> 

Technically everything in V4L2 is more or less related.

I expect that in future we may see Frankenstein's monster that
sets up multirectangle crops, compose, format and some important controls
using single ioctl with a huge struct.
Probably, this would sufficient ... for some time.

I am simply tired of all those "almost solutions".
The API should be modular. It should be made of simple
parts that do one thing well.

>> - obfuscates the API even more
> Agreed, but we can find better naming.
> 
>> - wastes a lot of reserved fields
> Only 2

There are new fields named flags2 (1 word), second union (4 words),
rectangles (1 word). So 6 extra words are wasted.

> 
>> - what if someone would like to use separate 'flags' for each rectangle
>>   ... this could be a nice feature anyway :)
> Then he uses the ext_rect :P
> 

Or use only single rectangle selections.

>>
>> This remains me the proposition from early days of selection API.
>>
>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28945
>>
>> Refer to point 4 where v4l2_crop2 was mentioned.
>>
>>>
>>> I would propose that the interaction with S_FMT is as follows: if S_FMT
>>> defines a rectangle < then the current compose rectangle, then the
>>> composition (and optionally crop) rectangle is reset. If it is >=, then
>>> all is fine.
>>
>> There is a issue here. Long time ago it was stated that S_FMT
>> should result in configuration where data are processed (scaled) into
>> the 'whole picture'.
>>
>> It means that a COMPOSE rectangle should be reset after very S_FMT.
>>
>>>
>>> If a new compose rectangle doesn't fit in the S_FMT rectangle then it should
>>> adapt the S_FMT rectangle to make it fit (as long as HW constraints are
>>> obeyed of course).
>>
>> What happens if REQBUFS was called between S_FMT and S_SELECTION?
>>
>>>
>>> This sequence will obey the rules of V4L2 as well: the last operation takes
>>> precedence over older operations. So setting S_FMT allow the driver to
>>> change cropping/composing to get as close to the desired format as possible.
>>>
>>>> How to define which crop rectangle refers to which to which compose rectangle.
>>>
>>> By setting the crop and compose selections at the same time and of the same
>>> size you can map each crop selection to a compose selection. It's all atomic
>>> as well.
>>>
>>
>> I think that adding an id field to v4l2_selection might be a good alternative
>> to introduction of numbered targets like V4L2_SEL_TGT_COMPOSE0, 1, ...
>>
>> It will add support for all multirectangle features as cost of
>> sacrifice of single reserved field. Moreover id field might be
>> very useful for other selection targets like FOCUS or FACE.
>>
>> Other idea might to using some bits of 'flags' field to carry rectangle id.
>>
>>>>
>>>> What to do if one would like to change only 3rd crop rectangle?
>>>>
>>>> Introduce rectangle id into v4l2_ext_rect?
>>>> Call VIDIOC_G_SELECTION to get all rectangles, change one and apply VIDIOC_S_SELECTION?
>>>> Is it really scalable?
>>>
>>> Why not?
>>>
>>
>> Because it is not scalable.
>> An application has to use 2 syscall instead of 1.
>> Unnecessary copying has to be performed.
> 
> And setting 8 rectangles will mean 8 iocts instead of 2.

The very similar amount of data is copied in both cases.

sizeof(v4l2_selection) + N * sizeof (v4l2_ext_rect)
	OR
N * sizeof(v4l2_selection)

> 
> The user can also keep a copy of what has been set and there will only
> be 1 ioctl.
> 

Notice that user must update this copy every time S_SELECTION is called.
Moreover it must always use this array whenever calling S_SELECTION.

If one use single-rectangle selections there is no need to keep all
those bookkeeping data. Nor assure its consistency.

>>
>>>>
>>>> Multirectangle targets may seam to be a solution but I think it is not.
>>>>
>>>> I think that atomic transactions are what is really needed in V4L2.
>>>> Other ideas like try-context from subdev API may also help.
>>>>
>>>> It will be nice to have something like
>>>>
>>>> VIDIOC_BEGIN
>>>>   VIDIOC_S_SELECTION (target = CROP)
>>>>   VIDIOC_S_SELECTION (target = COMPOSE)
>>>>   VIDIOC_S_FMT
>>>>   VIDIOC_S_CTRL
>>>> VIDIOC_COMMIT
>>>
>>> I don't think S_FMT is needed here: it's something you set up at the
>>> beginning and don't touch afterwards.
>>
>> One could say the same about compose, crop, ctrls.
>> The problem are the interactions between those objects.
>> What is dependent on what. What can change what.
>> How to reach a valid state in all cases not preventing
>> some valid configurations from being unreachable.
>>
>>>
>>> Wouldn't VIDIOC_S_SELECTION (target = CROP_COMPOSE) go a long way to
>>> solving these atomicity problems?
>>>
>>> Another nice feature that can be added to the selection API is to
>>> add a field to refer to a frame sequence number or a v4l2_buffer
>>> index (the latter is probably better): this would make it easy to
>>> apply an atomic crop/compose change to easily implement things like
>>> digital zoom or moving windows around. We could do something similar
>>> for controls.
>>>
>>> This would also solve the problem of assigning a per-buffer (or per-frame)
>>> configuration, something that libcamera2/3 needs.
>>>
>>
>> Introduce transactions with frame sequence numbers.
>> I proposed this in Cambridge in 2012.
>>
>>>>
>>>> and call a bunch of VIDIOC_G_* to see what really was applied.
>>>>
>>>>>> I have an auxiliary question. Do you have to set all rectangles
>>>>>> at once? can you set up them one by one?
>>>>>
>>>>> Also if you tell the driver what exact configuration you will need, it
>>>>> will provide you with the closest possible confuration, that cannot be
>>>>
>>>> s/cannot be done/may not be 'doable'
>>>>
>>>>> done if you provide rectangle by rectangle.
>>>>>
>>>>>> But how to deal with multiple rectangles?
>>>>>
>>>>> Multiple rectangles is a desired feature, please take a look to the
>>>>> presentation on the workshop.
>>>>>
>>>>
>>>> I agree that it may be useful. I just think that multirectangle selections
>>>> are needed to add support for such a feature.
>>>
>>> I don't follow, isn't that what this proposal adds?
>>>
>>
>> s/are needed/are not needed/
>>
>> Sorry for confusion.
>>
>>>>
>>>>>>
>>>>>> Anyway, first try to define something like this:
>>>>>>
>>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT0  V4L2_SEL_TGT_PRIVATE
>>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT0_DEFAULT  (V4L2_SEL_TGT_XXX_SCANOUT0 + 1)
>>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT0_BOUNDS  (V4L2_SEL_TGT_XXX_SCANOUT0 + 2)
>>>>>>
>>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT0  (V4L2_SEL_TGT_PRIVATE + 16)
>>>>>> ...
>>>>>>
>>>>>> -- OR-- parametrized macros similar to one below:
>>>>>>
>>>>>> #define V4L2_SEL_TGT_XXX_SCANOUT(n) (V4L2_SEL_TGT_PRIVATE + 16 * (n))
>>>>>>
>>>>>> The application could setup all scanout areas one-by-one.
>>>>>> By default V4L2_SEL_TGT_XXX_SCANOUT0 would be equal to the whole array.
>>>>>> The height of all consecutive area would be 0. This means disabling
>>>>>> them effectively.
>>>>>
>>>>> Lets say rectangle A + B + C +D is legal, and A +B is also legal. You
>>>>> are in ABCD and you want to go to AB. How can you do it?
>>>>
>>>> Just set C to have height 0. It will disable D automatically.
>>>
>>> It's the other direction that's the problem: how to go from A + B to
>>> A + B + C + D if ABC is illegal.
>>>
>>>> BTW. How are you going to emulate S_CROP by selection API
>>>> if you must use at least two rectangles (A + B) ?
>>>
>>> S_CROP will always just set one rectangle A. So if you had multiple
>>> rectangles in your selection then after S_CROP you'll have only one.
>>
>> So S_CROP should change only A.
>> What happens if someone already set device to work with 4 rectangles.
>> Then calls S_CROP that modifies A in such a way that ABCD no longer forms
>> a proper rectangle.
>>
>> What should happen?
>> - ignore S_CROP, return previous settings, or
>> - modify B,C,D to form a proper rectangle, or
>> - disable B,C,D, or ?
> 
> It will be the same as setting a multicrop with 1 rectangle.
> 

It not the answer to my question.
I expect that your answer refers to "disable B,C,D" variant, doesn't it?

>>
>>>
>>> I'm assuming that the hw will always support a single crop rectangle.
>>> If not (extraordinarily unlikely), then S_CROP should just return an
>>> error.
>>
>> I agree that it is highly unlikely. I am just trying to figure out
>> what should happen when calling S_CROP or single-rectangle S_SELECTION
>> after calling multirect S_SELECTION.
> 
> The sensor is configured with 1 rectangle.
> 
>>
>>>
>>>> I suggest to use SCANOUT target in your first implementation.
>>>> Notice that as long you use something different from CROP and COMPOSE,
>>>> you may define interactions and dependencies any way you want, like
>>>> - if change of scanout area can affect composing area
>>>> - interaction with format and frame size
>>>> - check if scanout area can overlap, multi crops should be allowed to overlap
>>>
>>> I see no reason for this. A CROP_COMPOSE target does all you need.
>>
>> I think that CROP and COMPOSE is all you need.
>>
>>>
>>> Note that to set up N rectangles where N differs from the current
>>> rectangle count you do need to use CROP_COMPOSE. You can't setup CROP
>>> and COMPOSE rectangles independently since having N crop rectangles
>>> and M compose rectangles makes no sense. If you don't change the
>>> number of rectangles, then you can still use CROP and COMPOSE as is.
>>>
>>
>> I am afraid that you are trying to kill too many birds with one stone.
>> I think it is a very good moment to use bazooka.
>>
>> Transactions enhanced with frame numbers will handle a lot of issues with V4L2.
>>
>> Moreover it will allow to support some nice effects like:
>> - multiple exposures during HDR photography
>> - continuous online changes preview windows
>> - flash at a specific frame
>> - change format during video streaming to grab a high-resolution picture
>> - support multi rectangle cropping and composing :)
> 
> Even with transactions I humble believe that we should have a
> multirectangle call. :)
> 
> 

I humbly believe that single rectangle selections are sufficient.
Please, try to convince me that I am wrong.
If I was sure that this multirect feature cannot be implemented
using single-rect selections I will support this extension.
Even if this feature is not future-proof as mentioned earlier.

We may let transactions to be a part of V4L3 :).

By now, I am still not convinced.

>>
>>>>
>>
>> [snip]
>>
>>
>>>>> I have no need for it, but now that we are extending the selection API
>>>>> it would be the perfect moment to add them.
>>>>
>>>> The perfect moment for adding something is when it is needed.
>>>
>>> We need to add support for multiple rectangles, so we added a pointer.
>>>
>>>> The bad idea is preventing something from being added too early.
>>>
>>> But if we make it a pointer to v4l2_rect, then we can *never* add
>>> additional information to each rectangle. Whenever we add new APIs
>>> or features we try to allow for future extensions (with mixed
>>> success...), so now is the time to do so for v4l2_rect.
>>>
>>> Something like this:
>>>
>>> struct v4l2_sel_rect {
>>>       struct v4l2_rect r;
>>>       __u32 reserved[4];
>>> };
>>>
>>> would be fine by me as well. It's an additional indirection, but it
>>> also makes it easier to go from a v4l2_rect to a v4l2_sel_rect.
>>
>> We can always migrate to extended rectangle by modifying the structure to
>>
>> struct v4l2_selection {
>>          __u32                   type;
>>          __u32                   target;
>>          __u32                   flags;
>>          union {
>>                struct v4l2_rect        r;
>>                struct v4l2_ext_rect    rext;
>>          };
>>          __u32                   reserved[X];
>> };
>>
>> and adding V4L2_SEL_FLAG_EXT_RECT flag.
> 
> Dont you think this is a bit confusing?
> 
> 
> 

Why? It is much less confusing then union type
dependent on value of v4l2_selection::rectangles.

You can use pointer to struct v4l2_ext_rect
instead of composition. Then only 1 bit could
be used to support extended rectangles.

Regards,
Tomasz Stanislawski
