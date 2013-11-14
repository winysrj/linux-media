Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3666 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3KNKT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Nov 2013 05:19:56 -0500
Message-ID: <5284A375.6000107@xs4all.nl>
Date: Thu, 14 Nov 2013 11:18:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC v3] [RFC] v4l2: Support for multiple selections
References: <1380623614-26265-1-git-send-email-ricardo.ribalda@gmail.com> <5268F714.3090004@samsung.com> <CAPybu_2p4AYxze-QMOZhMq+EYCEXN1KazZdQckWKub9kpAESfg@mail.gmail.com> <5282411E.9060309@samsung.com>
In-Reply-To: <5282411E.9060309@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 11/12/13 15:54, Tomasz Stanislawski wrote:
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

The problem would be in a situation like this:

......
.AA.B.
......   -->   AAB
.C.DD.         CDD
......

A-D are the rectangles you want to select. They are cropped as shown on the
left and composed as shown on the right.

>From what Ricardo told me the resulting composed image typically must be
a proper rectangle without padding anywhere.

Trying to add rectangles one at a time breaks down when adding C because
the composition result is no longer a 'proper' rectangle. I don't see how
you can set something like that up one rectangle at a time.

It makes much more sense to set everything up at once.

BTW, what probably wasn't clear from Ricardo's explanation is that for every
crop rectangle you must have a corresponding compose rectangle so that you
know where to DMA it to.

Your next question will be that it is a real problem that you can't set
crop and compose simultaneously, and you are right about that. Read on for
that... :-)

> Hmm. I think that the real problem is much different.
> Not how to set up rectangles atomically but rather
> how do anything non-trivial atomically in V4L2.
> 
> It would be very nice to have crop/compose and format configured at the same time.
> However, current version of V4L2 API does not support that.
> 
> Setting multiple crop rectangles may help a bit for only this little case.
> But how would like to set multicrop rectangles and multicompose rectangle atomically.

Why can't we extend the selection API a bit? How about this:

#define V4L2_SEL_TGT_CROP_COMPOSE    0x0200

struct v4l2_selection {
        __u32                   type;
        __u32                   target;
        __u32                   flags;
	union {
	        struct v4l2_rect        r;
		struct v4l2_ext_rect    *pr;
	};
        __u32                   flags2;
	union {
	        struct v4l2_rect        r2;
		struct v4l2_ext_rect    *pr2;
	};
	__u32			rectangles;
        __u32                   reserved[3];
};

If the target is CROP_COMPOSE then flags & r define the crop rectangle, and
flags2 & r2 define the compose rectangle. That way you can set them both
atomically.

I would propose that the interaction with S_FMT is as follows: if S_FMT
defines a rectangle < then the current compose rectangle, then the
composition (and optionally crop) rectangle is reset. If it is >=, then
all is fine.

If a new compose rectangle doesn't fit in the S_FMT rectangle then it should
adapt the S_FMT rectangle to make it fit (as long as HW constraints are
obeyed of course).

This sequence will obey the rules of V4L2 as well: the last operation takes
precedence over older operations. So setting S_FMT allow the driver to
change cropping/composing to get as close to the desired format as possible.

> How to define which crop rectangle refers to which to which compose rectangle.

By setting the crop and compose selections at the same time and of the same
size you can map each crop selection to a compose selection. It's all atomic
as well.

> 
> What to do if one would like to change only 3rd crop rectangle?
> 
> Introduce rectangle id into v4l2_ext_rect?
> Call VIDIOC_G_SELECTION to get all rectangles, change one and apply VIDIOC_S_SELECTION?
> Is it really scalable?

Why not?

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

I don't think S_FMT is needed here: it's something you set up at the
beginning and don't touch afterwards.

Wouldn't VIDIOC_S_SELECTION (target = CROP_COMPOSE) go a long way to
solving these atomicity problems?

Another nice feature that can be added to the selection API is to
add a field to refer to a frame sequence number or a v4l2_buffer
index (the latter is probably better): this would make it easy to
apply an atomic crop/compose change to easily implement things like
digital zoom or moving windows around. We could do something similar
for controls.

This would also solve the problem of assigning a per-buffer (or per-frame)
configuration, something that libcamera2/3 needs.

> 
> and call a bunch of VIDIOC_G_* to see what really was applied.
> 
>>> I have an auxiliary question. Do you have to set all rectangles
>>> at once? can you set up them one by one?
>>
>> Also if you tell the driver what exact configuration you will need, it
>> will provide you with the closest possible confuration, that cannot be
> 
> s/cannot be done/may not be 'doable'
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

I don't follow, isn't that what this proposal adds?

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

It's the other direction that's the problem: how to go from A + B to
A + B + C + D if ABC is illegal.

> BTW. How are you going to emulate S_CROP by selection API
> if you must use at least two rectangles (A + B) ?

S_CROP will always just set one rectangle A. So if you had multiple
rectangles in your selection then after S_CROP you'll have only one.

I'm assuming that the hw will always support a single crop rectangle.
If not (extraordinarily unlikely), then S_CROP should just return an
error.

> I suggest to use SCANOUT target in your first implementation.
> Notice that as long you use something different from CROP and COMPOSE,
> you may define interactions and dependencies any way you want, like
> - if change of scanout area can affect composing area
> - interaction with format and frame size
> - check if scanout area can overlap, multi crops should be allowed to overlap

I see no reason for this. A CROP_COMPOSE target does all you need.

Note that to set up N rectangles where N differs from the current
rectangle count you do need to use CROP_COMPOSE. You can't setup CROP
and COMPOSE rectangles independently since having N crop rectangles
and M compose rectangles makes no sense. If you don't change the
number of rectangles, then you can still use CROP and COMPOSE as is.

> 
> See if it will be sufficient.
> See what kind of problems you encouter.
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
> 
> Moreover what happens if flipping or rotation is applied?
> Currently only the content of the rectangle is rotated/flipped.
> If you use multi rectangle then content of each rectangle must be
> rotated/flipped separatelly. Are you sure that your hardware can do this?
> 
> What about layout of composing rectangle inside output buffer?
> Should it reflect the layout of crop rectangle or all of them should be
> independent.
> 
> Of course you can always say that everything is driver dependent :).
> 
> Anyway, adding multirectangle selections for crop/compose is openning Pandora's Box.

I disagree. But it requires (and I hadn't realized that before) that you pass
all the crop and compose rectangles atomically.

> 
>>>
>>> So technicaly you still insert the whole sensor area into the buffer.
>>
>> Only the lines/columns are read into the buffer.
>>
> 
> Yes, but where into a buffer?
> Does you HW support setting destination for every crop rectangle?

>From what Ricardo told us during the meeting I got the impression that
it is basically just skipping the lines and columns that are not wanted.

So ...AAA..BB..C... just ends up as AAABBC
   .D....EEEEE.....                 DEEEEE

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

We need to add support for multiple rectangles, so we added a pointer.

> The bad idea is preventing something from being added too early.

But if we make it a pointer to v4l2_rect, then we can *never* add
additional information to each rectangle. Whenever we add new APIs
or features we try to allow for future extensions (with mixed
success...), so now is the time to do so for v4l2_rect.

Something like this:

struct v4l2_sel_rect {
	struct v4l2_rect r;
	__u32 reserved[4];
};

would be fine by me as well. It's an additional indirection, but it
also makes it easier to go from a v4l2_rect to a v4l2_sel_rect.

Regards,

	Hans

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

