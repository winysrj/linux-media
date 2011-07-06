Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:10569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab1GFOKu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2011 10:10:50 -0400
Message-ID: <4E146CDF.3030203@redhat.com>
Date: Wed, 06 Jul 2011 11:10:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l:
 add macro for 1080p59_54 preset
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>    <201107050926.38639.hverkuil@xs4all.nl> <4E12FEA3.6010500@redhat.com>    <201107051520.17361.hverkuil@xs4all.nl> <4E14415A.9010001@redhat.com>    <416b47156837d78280f98bfd96e36dc7.squirrel@webmail.xs4all.nl>    <4E144B93.7060105@redhat.com>    <761c3894fa161d5e702cccf80443c7dd.squirrel@webmail.xs4all.nl>    <4E1455AC.1090704@redhat.com> <47a439e504df2ac07b30fd9d77f8fbdb.squirrel@webmail.xs4all.nl>
In-Reply-To: <47a439e504df2ac07b30fd9d77f8fbdb.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Em 06-07-2011 09:56, Hans Verkuil escreveu:
>> Em 06-07-2011 09:14, Hans Verkuil escreveu:
>>>> Em 06-07-2011 08:31, Hans Verkuil escreveu:
>>>>>> Em 05-07-2011 10:20, Hans Verkuil escreveu:
>>>>>>
>>>>>>>> I failed to see what information is provided by the "presets" name.
>>>>>>>> If
>>>>>>>> this were removed
>>>>>>>> from the ioctl, and fps would be added instead, the API would be
>>>>>>>> clearer. The only
>>>>>>>> adjustment would be to use "index" as the preset selection key.
>>>>>>>> Anyway,
>>>>>>>> it is too late
>>>>>>>> for such change. We need to live with that.
>>>>>>>
>>>>>>> Adding the fps solves nothing. Because that still does not give you
>>>>>>> specific timings.
>>>>>>> You can have 1920x1080P60 that has quite different timings from the
>>>>>>> CEA-861 standard
>>>>>>> and that may not be supported by a TV.
>>>>>>>
>>>>>>> If you are working with HDMI, then you may want to filter all
>>>>>>> supported
>>>>>>> presets to
>>>>>>> those of the CEA standard.
>>>>>>>
>>>>>>> That's one thing that is missing at the moment: that presets
>>>>>>> belonging
>>>>>>> to a certain
>>>>>>> standard get their own range. Since we only do CEA861 right now it
>>>>>>> hasn't been an
>>>>>>> issue, but it will.
>>>>>>
>>>>>> I prepared a long email about that, but then I realized that we're
>>>>>> investing our time into
>>>>>> something broken, at the light of all DV timing standards. So, I've
>>>>>> dropped it and
>>>>>> started from scratch.
>>>>>>
>>>>>> From what I've got, there are some hardware that can only do a
>>>>>> limited
>>>>>> set
>>>>>> of DV timings.
>>>>>> If this were not the case, we could simply just use the
>>>>>> VIDIOC_S_DV_TIMINGS/VIDIOC_G_DV_TIMINGS,
>>>>>> and put the CEA 861 and VESA timings into some userspace library.
>>>>>>
>>>>>> In other words, the PRESET API is meant to solve the case where
>>>>>> hardware
>>>>>> only support
>>>>>> a limited set of frequencies, that may or may not be inside the CEA
>>>>>> standard.
>>>>>>
>>>>>> Let's assume we never added the current API, and discuss how it would
>>>>>> properly fulfill
>>>>>> the user needs. An API that would likely work is:
>>>>>>
>>>>>> struct v4l2_dv_enum_preset2 {
>>>>>> 	__u32	  index;
>>>>>> 	__u8	  name[32]; /* Name of the preset timing */
>>>>>>
>>>>>> 	struct v4l2_fract fps;
>>>>>>
>>>>>> #define DV_PRESET_IS_PROGRESSIVE	1<<31
>>>>>> #define DV_PRESET_SPEC(flag)		(flag && 0xff)
>>>>>> #define DV_PRESET_IS_CEA861		1
>>>>>> #define DV_PRESET_IS_DMT		2
>>>>>> #define DV_PRESET_IS_CVF		3
>>>>>> #define DV_PRESET_IS_GTF		4
>>>>>> #define DV_PRESET_IS_VENDOR_SPECIFIC	5
>>>>>>
>>>>>> 	__u32	flags;		/* Interlaced/progressive, DV specs, etc */
>>>>>>
>>>>>> 	__u32	width;		/* width in pixels */
>>>>>> 	__u32	height;		/* height in lines */
>>>>>> 	__u32	polarities;	/* Positive or negative polarity */
>>>>>> 	__u64	pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
>>>>>> 	__u32	hfrontporch;	/* Horizpontal front porch in pixels */
>>>>>> 	__u32	hsync;		/* Horizontal Sync length in pixels */
>>>>>> 	__u32	hbackporch;	/* Horizontal back porch in pixels */
>>>>>> 	__u32	vfrontporch;	/* Vertical front porch in pixels */
>>>>>> 	__u32	vsync;		/* Vertical Sync length in lines */
>>>>>> 	__u32	vbackporch;	/* Vertical back porch in lines */
>>>>>> 	__u32	il_vfrontporch;	/* Vertical front porch for bottom field of
>>>>>> 				 * interlaced field formats
>>>>>> 				 */
>>>>>> 	__u32	il_vsync;	/* Vertical sync length for bottom field of
>>>>>> 				 * interlaced field formats
>>>>>> 				 */
>>>>>> 	__u32	il_vbackporch;	/* Vertical back porch for bottom field of
>>>>>> 				 * interlaced field formats
>>>>>> 				 */
>>>>>> 	__u32	  reserved[4];
>>>>>> };
>>>>>>
>>>>>> #define	VIDIOC_ENUM_DV_PRESETS2	_IOWR('V', 83, struct
>>>>>> v4l2_dv_enum_preset2)
>>>>>> #define	VIDIOC_S_DV_PRESET2	_IOWR('V', 84, u32 index)
>>>>>> #define	VIDIOC_G_DV_PRESET2	_IOWR('V', 85, u32 index)
>>>>>>
>>>>>> Such preset API seems to work for all cases. Userspace can use any DV
>>>>>> timing
>>>>>> information to select the desired format, and don't need to have a
>>>>>> switch
>>>>>> for
>>>>>> a preset macro to try to guess what the format actually means. Also,
>>>>>> there's no
>>>>>> need to touch at the API spec every time a new DV timeline is needed.
>>>>>>
>>>>>> Also, it should be noticed that, since the size of the data on the
>>>>>> above
>>>>>> definitions
>>>>>> are different than the old ones, _IO macros will provide a different
>>>>>> magic
>>>>>> number,
>>>>>> so, adding these won't break the existing API.
>>>>>>
>>>>>> So, I think we should work on this proposal, and mark the existing
>>>>>> one
>>>>>> as
>>>>>> deprecated.
>>>>>
>>>>> This proposal makes it very hard for applications to directly select a
>>>>> format like 720p50 because the indices can change at any time.
>>>>
>>>> Why? All the application needs to do is to call
>>>> VIDIOC_ENUM_DV_PRESETS2,
>>>> check what line it wants,
>>>
>>> It's not so easy as you think to find the right timings: you have to
>>> check
>>> many parameters to be certain you have the right one and not some subtle
>>> variation.
>>
>> Or you can do a strcmp(v4l2_dv_enum_preset2.name,"my preset").
> 
> Yuck. Then you also need to define the names so you know what name to
> match on. Since once you allow this you can never modify the names again.

Once you add names to the API, the above is allowed, as the name is part of
the API. So, names can't be changed, as changing them can break things.

The alternative is to remove the names from the new API.

>>>> and do a S_DV_PRESET2, just like any other place
>>>> where V4L2 defines an ENUM function.
>>>>
>>>> The enum won't change during application runtime, so, they can be
>>>> stored
>>>> if the application would need to switch to other formats latter.
>>>>
>>>>> I think
>>>>> this is a very desirable feature, particularly for apps running on
>>>>> embedded systems where the hardware is known. This was one of the
>>>>> design
>>>>> considerations at the time this API was made.
>>>>
>>>> This is a very weak argument. With just one ENUM loop, the application
>>>> can
>>>> quickly get the right format(s), and associate them with any internal
>>>> namespace.
>>>
>>> That actually isn't easy at all.
>>
>> ???
>>
>>>>> But looking at this I wonder if we shouldn't just make a
>>>>> VIDIOC_G_PRESET_TIMINGS function? You give it the preset ID and you
>>>>> get
>>>>> all the timing information back. No need to deprecate anything. I'm
>>>>> not
>>>>> even sure if with this change we need to modify struct
>>>>> v4l2_dv_enum_preset
>>>>> as I proposed in my RFC, although I think we should.
>>>>
>>>> Won't solve the issue: one new #define is needed for each video timing,
>>>> namespaces will be confusing, no support for VESA GVF/ VESA CVT timings
>>>> (or worse: we'll end by having thousands of formats at the end of the
>>>> day),
>>>> instead of just one ENUM ioctl, an extra ioctl will be required for
>>>> each
>>>> returned value, etc.
>>>
>>> Presets for GTF/CVT are useless (and I have never seen hardware that has
>>> such presets). In practice you have CEA and DMT presets and nothing
>>> else.
>>>
>>> We may need to add PRESET_PRIVATE (just like we do for controls) should
>>> we
>>> get non-CEA/DMT formats as well. There is no point in having specific
>>> preset defines for those IMHO.
>>
>> A PRESET_PRIVATE would mean just one DV timing, as the "preset" is the
>> index
>> to get data. So, this won't fix the API.
> 
> PRESET_PRIVATE, PRESET_PRIVATE+1, +2, etc. Just as is done in other places.

Yuck. This is very ugly. NACK.

>>> I see very little advantage in throwing away an API that works quite
>>> well
>>> in practice only to add a new one that isn't much better IMO. Instead we
>>> can easily improve the existing API.
>>>
>>> I *want* to be able to specify the most common CEA/DMT standards
>>> directly
>>> and unambiguously through presets.
>>
>> With my proposal, you can do it.
>>
>>> It is very easy and nice to use in
>>> practice. Once you go into the realm of GTF/CVT, then the preset API is
>>> too limited and G/S_DV_TIMINGS need to be used, but that requires much
>>> more effort on the part of the application.
>>
>> The usage of G/S_DV_TIMINGS require an extra care: in the past, old VGA
>> hardware
>> (and/or monitors) could be damaged if it is programed with some
>> parameters.
>> It used to have some viruses that damaged hardware using it. So, any
>> driver
>> implementing it will need to validate the timings, to be sure that they
>> are
>> on an acceptable range and won't damage the hardware in any way, or it
>> will
>> need to require some special capability (root access) to avoid that an
>> userspace
>> program to damage the hardware.
> 
> Drivers need to validate if necessary, of course.
> 
>> The timings on a preset table should be ok, so it is safer to implement
>> the *PRESET
>> ioctls than the *TIMINGS one.
> 
> You will need the TIMINGS ioctls if you want to handle GTF/CVT formats.
> Those are calculated so the preset API is a poor fit.

If you want full support for it, yes. But, if all it is needed are the
common resolutions/fps (1024x768p60, 1920x1080p50, ...), GTF/CVT format
presets may fit well.

Regards,
Mauro.
