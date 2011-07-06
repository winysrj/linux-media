Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:46406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab1GFMJs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2011 08:09:48 -0400
Message-ID: <4E145082.5080406@redhat.com>
Date: Wed, 06 Jul 2011 09:09:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l:
 add macro for 1080p59_54 preset
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com> <416b47156837d78280f98bfd96e36dc7.squirrel@webmail.xs4all.nl> <4E144B93.7060105@redhat.com> <201107061403.48526.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107061403.48526.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Em 06-07-2011 09:03, Laurent Pinchart escreveu:
> On Wednesday 06 July 2011 13:48:35 Mauro Carvalho Chehab wrote:
>> Em 06-07-2011 08:31, Hans Verkuil escreveu:
>>>> Em 05-07-2011 10:20, Hans Verkuil escreveu:
>>>>>> I failed to see what information is provided by the "presets" name. If
>>>>>> this were removed from the ioctl, and fps would be added instead, the
>>>>>> API would be clearer. The only adjustment would be to use "index" as
>>>>>> the preset selection key. Anyway, it is too late for such change. We
>>>>>> need to live with that.
>>>>>
>>>>> Adding the fps solves nothing. Because that still does not give you
>>>>> specific timings. You can have 1920x1080P60 that has quite different
>>>>> timings from the CEA-861 standard and that may not be supported by a TV.
>>>>>
>>>>> If you are working with HDMI, then you may want to filter all supported
>>>>> presets to those of the CEA standard.
>>>>>
>>>>> That's one thing that is missing at the moment: that presets belonging
>>>>> to a certain standard get their own range. Since we only do CEA861 right
>>>>> now it hasn't been an issue, but it will.
>>>>
>>>> I prepared a long email about that, but then I realized that we're
>>>> investing our time intosomething broken, at the light of all DV timing
>>>> standards. So, I've dropped it and started from scratch.
>>>>
>>>> From what I've got, there are some hardware that can only do a limited
>>>> set of DV timings. If this were not the case, we could simply just use
>>>> the VIDIOC_S_DV_TIMINGS/VIDIOC_G_DV_TIMINGS, and put the CEA 861 and VESA
>>>> timings into some userspace library.
>>>>
>>>> In other words, the PRESET API is meant to solve the case where hardware
>>>> only support a limited set of frequencies, that may or may not be inside
>>>> the CEA standard.
>>>>
>>>> Let's assume we never added the current API, and discuss how it would
>>>> properly fulfill the user needs. An API that would likely work is:
>>>>
>>>> struct v4l2_dv_enum_preset2 {
>>>>
>>>> 	__u32	  index;
>>>> 	__u8	  name[32]; /* Name of the preset timing */
>>>> 	
>>>> 	struct v4l2_fract fps;
>>>>
>>>> #define DV_PRESET_IS_PROGRESSIVE	1<<31
>>>> #define DV_PRESET_SPEC(flag)		(flag && 0xff)
>>>> #define DV_PRESET_IS_CEA861		1
>>>> #define DV_PRESET_IS_DMT		2
>>>> #define DV_PRESET_IS_CVF		3
>>>> #define DV_PRESET_IS_GTF		4
>>>> #define DV_PRESET_IS_VENDOR_SPECIFIC	5
>>>>
>>>> 	__u32	flags;		/* Interlaced/progressive, DV specs, etc */
>>>> 	
>>>> 	__u32	width;		/* width in pixels */
>>>> 	__u32	height;		/* height in lines */
>>>> 	__u32	polarities;	/* Positive or negative polarity */
>>>> 	__u64	pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
>>>> 	__u32	hfrontporch;	/* Horizpontal front porch in pixels */
>>>> 	__u32	hsync;		/* Horizontal Sync length in pixels */
>>>> 	__u32	hbackporch;	/* Horizontal back porch in pixels */
>>>> 	__u32	vfrontporch;	/* Vertical front porch in pixels */
>>>> 	__u32	vsync;		/* Vertical Sync length in lines */
>>>> 	__u32	vbackporch;	/* Vertical back porch in lines */
>>>> 	__u32	il_vfrontporch;	/* Vertical front porch for bottom field of
>>>> 	
>>>> 				 * interlaced field formats
>>>> 				 */
>>>> 	
>>>> 	__u32	il_vsync;	/* Vertical sync length for bottom field of
>>>> 	
>>>> 				 * interlaced field formats
>>>> 				 */
>>>> 	
>>>> 	__u32	il_vbackporch;	/* Vertical back porch for bottom field of
>>>> 	
>>>> 				 * interlaced field formats
>>>> 				 */
>>>> 	
>>>> 	__u32	  reserved[4];
>>>>
>>>> };
>>>>
>>>> #define	VIDIOC_ENUM_DV_PRESETS2	_IOWR('V', 83, struct
>>>> v4l2_dv_enum_preset2)
>>>> #define	VIDIOC_S_DV_PRESET2	_IOWR('V', 84, u32 index)
>>>> #define	VIDIOC_G_DV_PRESET2	_IOWR('V', 85, u32 index)
>>>>
>>>> Such preset API seems to work for all cases. Userspace can use any DV
>>>> timing information to select the desired format, and don't need to have a
>>>> switch for a preset macro to try to guess what the format actually means.
>>>> Also, there's no need to touch at the API spec every time a new DV
>>>> timeline is needed.
>>>>
>>>> Also, it should be noticed that, since the size of the data on the above
>>>> definitions are different than the old ones, _IO macros will provide a
>>>> different magic number, so, adding these won't break the existing API.
>>>>
>>>> So, I think we should work on this proposal, and mark the existing one
>>>> as deprecated.
>>>
>>> This proposal makes it very hard for applications to directly select a
>>> format like 720p50 because the indices can change at any time.
>>
>> Why? All the application needs to do is to call VIDIOC_ENUM_DV_PRESETS2,
>> check what line it wants, and do a S_DV_PRESET2, just like any other place
>> where V4L2 defines an ENUM function.
> 
> Forcing applications to enumerate all presets when they already know what 
> preset they want doesn't seem like a very good solution to me.

If the app already know, it might simply do VIDIOC_S_DV_PRESET2(index). This would
work for an embedded hardware. The only care to be taken is to change the index
number if the Kernel changes, or to be sure that, on the embedded tree, that newer
DV lines will be added only after the previous one.

Anyway, a broken API cannot be justified by a weak argument that not needing to do
an ENUM will save a few nanosseconds for some embedded hardware during application
initialization time.

Mauro.

