Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab1GEMIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2011 08:08:13 -0400
Message-ID: <4E12FEA3.6010500@redhat.com>
Date: Tue, 05 Jul 2011 09:08:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l:
 add macro for 1080p59_54 preset
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com> <1309351877-32444-2-git-send-email-t.stanislaws@samsung.com> <4E11E5AE.30304@redhat.com> <201107050926.38639.hverkuil@xs4all.nl>
In-Reply-To: <201107050926.38639.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-07-2011 04:26, Hans Verkuil escreveu:
> On Monday, July 04, 2011 18:09:18 Mauro Carvalho Chehab wrote:
>> Em 29-06-2011 09:51, Tomasz Stanislawski escreveu:
>>> The 1080p59_94 is supported by latest Samsung SoC.
>>>
>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>>> ---
>>>  drivers/media/video/v4l2-common.c |    1 +
>>>  include/linux/videodev2.h         |    1 +
>>>  2 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
>>> index 06b9f9f..003e648 100644
>>> --- a/drivers/media/video/v4l2-common.c
>>> +++ b/drivers/media/video/v4l2-common.c
>>> @@ -582,6 +582,7 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
>>>  		{ 1920, 1080, "1080p@30" },	/* V4L2_DV_1080P30 */
>>>  		{ 1920, 1080, "1080p@50" },	/* V4L2_DV_1080P50 */
>>>  		{ 1920, 1080, "1080p@60" },	/* V4L2_DV_1080P60 */
>>> +		{ 1920, 1080, "1080p@59.94" },	/* V4L2_DV_1080P59_94 */
>>>  	};
>>>  
>>>  	if (info == NULL || preset >= ARRAY_SIZE(dv_presets))
>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>> index 8a4c309..7c77c4e 100644
>>> --- a/include/linux/videodev2.h
>>> +++ b/include/linux/videodev2.h
>>> @@ -872,6 +872,7 @@ struct v4l2_dv_enum_preset {
>>>  #define		V4L2_DV_1080P30		16 /* SMPTE 296M */
>>>  #define		V4L2_DV_1080P50		17 /* BT.1120 */
>>>  #define		V4L2_DV_1080P60		18 /* BT.1120 */
>>> +#define		V4L2_DV_1080P59_94	19
>>>  
>>>  /*
>>>   *	D V 	B T	T I M I N G S
>>
>> This patch deserves further discussions, as the specs that define the presets
>> are not so clear with respect to 60Hz and 60/1.001 Hz.
>>
>> Let me summarize the issue.
>>
>>
>>
>> 1) PRESET STANDARDS
>>    ====== =========
>>
>> There are 3 specs involved with DV presets: ITU-R BT 709 and BT 1120 and CEA 861.
>>
>> At ITU-R BT.709, both 60Hz and 60/1.001 Hz are equally called as "60 Hz". BT.1120
>> follows the same logic, as it uses BT.709 as a reference for video timings.
>>
>> The CEA-861-E spec says at item 4, that:
>>
>> 	A video timing with a vertical frequency that is an integer multiple of 6.00 Hz (i.e. 24.00, 30.00, 60.00,
>> 	120.00 or 240.00 Hz) is considered to be the same as a video timing with the equivalent detailed timing
>> 	information but where the vertical frequency is adjusted by a factor of 1000/1001 (i.e., 24/1.001, 30/1.001,
>> 	60/1.001, 120/1.001 or 240/1.001). That is, they are considered two versions of the same video timing but
>> 	with slightly different pixel clock frequencies. Therefore, a DTV that declares it is capable of displaying a
>> 	video timing with a vertical frequency that is either an integer multiple of 6 Hz or an integer multiple of 6
>> 	Hz adjusted by a factor of 1000/1001 shall be capable of displaying both versions of the video timing.
>>
>> At the same item, the table 2 describes several video parameters for each preset, associating the
>> Video Identification Codes (VIC) for each preset.
> 
> No, *multiple VICs* are associated with each preset. VIC != preset.

There are two VIC's for several presets, as it is also used at the spec to determine the aspect ratio, but, basically,
for one given VIC, there's just one timings preset at the table 2.

> Also, the VICs do not differentiate between 60 and 59.94 Hz.

Yes, but V4L2 DV timings also don't differentiate.

>> Table 4 associates each VIC with the supported formats. For example, VIC 16 means a resolution of
>> 1920x1080 at 59.94Hz/60Hz. The spec does explicitly allow that all vertical frequencies that are
>> multiple of 6 Hz to accept both 59.94 Hz and 60 Hz, as said at note 3 of table 2:
>>
>> 	3. A video timing with a vertical frequency that is an integer multiple of 6.00 Hz (i.e. 24.00, 30.00, 60.00, 120.00 or
>> 	240.00 Hz) is considered to be the same as a video timing with the equivalent detailed timing information but where
>> 	the vertical frequency is adjusted by a factor of 1000/1001 (i.e., 24/1.001, 30/1.001, 60/1.001, 120/1.001 or
>> 	240/1.001). That is, they are considered two versions of the same video timing but with slightly different pixel clock
>> 	frequencies. The vertical frequencies of the 240p, 480p, and 480i video formats are typically adjusted by a factor of
>> 	exactly 1000/1001 for NTSC video compatibility, while the 576p, 576i, and the HDTV video formats are not. The
>> 	VESA DMT standard [65] specifies a ± 0.5% pixel clock frequency tolerance. Therefore, the nominally 25.175 MHz
>> 	pixel clock frequency value given for video identification code 1 may be adjusted to 25.2 MHz to obtain an exact 60
>> 	Hz vertical frequency.
>>
>> In other words, the preset for 1920x1080p@60Hz can be used for both 60Hz and 59.94 Hz,
>> according with the above note, being 59.94 Hz the typical value (e. g. the value that
>> should be used on most places).
>>
>> However, there are some "60 Hz" vertical resolutions that have VIC's with 
>> different framerates (like 59.94Hz, 60.054Hz, etc). Those seem to not be
>> covered by the "multiple of 6.00 Hz" rule.
> 
> No. A preset identifies one specific modeline (to use the terminology from the
> GPU world). It defines the front/back porches, sync lengths, active area and
> pixelclock frequency. Any ambiguities as to the timings of a preset should be
> resolved by the documentation (which clearly needs a bit more work).

As I pointed before, it is not just documentation. For all the 6.00 Hz multiple standard,
CEA defines that, using the same DV timings, it is possible to choose to shift the clock
by 1000/1001 to support the "59.94Hz". So, this applies to several VIC's for 60Hz,
120 Hz and 240Hz.

While it is possible to duplicate the DV timing line for all affected VICs,
We'll end by having a very messy API, as there will be two 60 Hz standards, one
with the shift and the other without, for the same CEA VIC, plus the CEA
standards that are defined for other vertical resolutions like 60.054 Hz, 
59.826 Hz, 119.88 Hz, 239.76 Hz and even 59.940 Hz.

Part of the problem is the u32 "preset" var, at v4l2_dv_enum_preset. It
requires a namespace to identify the presets, but this can become very
confusing with time. How would you distinguish from a CEA-861 60.00 Hz standard
with a Vertical frequency shift of 1000/1001 and a CEA-861 59.94 Hz? The current
namespace doesn't allow that, and creating a namespace to accommodate would be
weird and would easily be very confusing.

> In general,
> though, all the currently defined presets refer to CEA-861. The standards
> mentioned in videodev2.h all refer to the same things, but CEA-861 is the standard
> where it all comes together.
> 
> In practice there are four different standards that the preset API can use:
> 
> CEA-861 for all things HDTV (HDMI)
> VESA DMT timings for DVI-D (PC) type timings (VGA, XVGA, etc.)
> VESA GTF timings (officially deprecated, but still quite common algorithm to
> 	calculate timings)
> VESA CVT timings (the newer algorithm to calculate timings)
> 
> GTF and CVT pose there own problems and Cisco will be making a proposal for
> how to handle this some time this year.
> 
> VESA DMT timings as easy to add since they are well-defined. We plan on doing
> that.

Well, try to accomodate all those timings using the current namespace for
preset. I bet you'll end by having lots of duplicated names for distinct
timings.

The API needs to be fixed, and it is better sooner than later.

>> 2. V4L2 API
>>    ==== ===
>>
>> The V4L2 specs define a DV timing as having those fields:
>>
>> __u32	width	Width of the active video in pixels
>> __u32	height	Height of the active video in lines
>> __u32	interlaced	Progressive (0) or interlaced (1)
>> __u32	polarities	This is a bit mask that defines polarities of sync signals. 
>> __u64	pixelclock	Pixel clock in Hz. Ex. 74.25MHz->74250000
>> __u32	hfrontporch	Horizontal front porch in pixels
>> __u32	hsync	Horizontal sync length in pixels
>> __u32	hbackporch	Horizontal back porch in pixels
>> __u32	vfrontporch	Vertical front porch in lines
>> __u32	vsync	Vertical sync length in lines
>> __u32	vbackporch	Vertical back porch in lines
>> __u32	il_vfrontporch	Vertical front porch in lines for bottom field of interlaced field formats
>> __u32	il_vsync	Vertical sync length in lines for bottom field of interlaced field formats
>> __u32	il_vbackporch	Vertical back porch in lines for bottom field of interlaced field formats
>>
>> [1] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-dv-timings.html
>>
>> So, it basically allows adjusting the timings for each of the VIC's, but it seems that there
>> is one limitation at the current API:
>>
>> vblank is an integer value, for both frames 0 and 1. So, it doesn't allow to adjust vblanks
>> like 22.5. This prevents specifying presets like VICs 10/11.
> 
> vblanks are never halflines. One field is one line longer than the other. As note 1 in table 2
> says: "fractional values indicate that the number of blanking lines varies". It's why we have
> those il_ fields.

OK.

>>
>> The presets ioctl's [2] provide the following fields:
>>
>> __u32	index	Number of the DV preset, set by the application.
>> __u32	preset	This field identifies one of the DV preset values listed in Table A.15, “struct DV Presets”.
>> __u8	name[24]	Name of the preset, a NUL-terminated ASCII string, for example: "720P-60", "1080I-60". This information is intended for the user.
>> __u32	width	Width of the active video in pixels for the DV preset.
>> __u32	height	Height of the active video in lines for the DV preset.
>>
>> [2] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-enum-dv-presets.html#v4l2-dv-presets-vals
>>
>> Where "preset" can mean:
>>
>> V4L2_DV_INVALID		0	Invalid preset value.
>> V4L2_DV_480P59_94	1	720x480 progressive video at 59.94 fps as per BT.1362.
>> V4L2_DV_576P50		2	720x576 progressive video at 50 fps as per BT.1362.
>> V4L2_DV_720P24		3	1280x720 progressive video at 24 fps as per SMPTE 296M.
>> V4L2_DV_720P25		4	1280x720 progressive video at 25 fps as per SMPTE 296M.
>> V4L2_DV_720P30		5	1280x720 progressive video at 30 fps as per SMPTE 296M.
>> V4L2_DV_720P50		6	1280x720 progressive video at 50 fps as per SMPTE 296M.
>> V4L2_DV_720P59_94	7	1280x720 progressive video at 59.94 fps as per SMPTE 274M.
>> V4L2_DV_720P60		8	1280x720 progressive video at 60 fps as per SMPTE 274M/296M.
>> V4L2_DV_1080I29_97	9	1920x1080 interlaced video at 29.97 fps as per BT.1120/SMPTE 274M.
>> V4L2_DV_1080I30		10	1920x1080 interlaced video at 30 fps as per BT.1120/SMPTE 274M.
>> V4L2_DV_1080I25		11	1920x1080 interlaced video at 25 fps as per BT.1120.
>> V4L2_DV_1080I50		12	1920x1080 interlaced video at 50 fps as per SMPTE 296M.
>> V4L2_DV_1080I60		13	1920x1080 interlaced video at 60 fps as per SMPTE 296M.
>> V4L2_DV_1080P24		14	1920x1080 progressive video at 24 fps as per SMPTE 296M.
>> V4L2_DV_1080P25		15	1920x1080 progressive video at 25 fps as per SMPTE 296M.
>> V4L2_DV_1080P30		16	1920x1080 progressive video at 30 fps as per SMPTE 296M.
>> V4L2_DV_1080P50		17	1920x1080 progressive video at 50 fps as per BT.1120.
>> V4L2_DV_1080P60		18	1920x1080 progressive video at 60 fps as per BT.1120.
> 
> All these standards need to be replaced with CEA-861.

Sorry, but I couldn't understand your proposal here.

>>
>>
>> 3. ISSUES AT V4L2 API
>>    ====== == ==== ===
>>
>> There are some troubles at the way we currently define the presets:
>>
>> 3.1) The preset macros have the name of the active video lines, but this is also present at
>>      the height field;
> 
> ??? While a human can see that V4L2_DV_1080P60 refers to 1080 lines, a computer
> can't. The macro is a just a number, so you need to communicate the width and
> height explicitly.

Yes, but the namespace is confusing, and developers might code it as:

if (preset >= V4L2_DV_1080I29_97  || preset <= V4L2_DV_1080P60)
	width = 1080;

(or doing the same inside a switch, although I've seen several userspace applications
 implementing things like above).

The above would be valid, and the end result is that a duplicated information is provided.

I failed to see what information is provided by the "presets" name. If this were removed
from the ioctl, and fps would be added instead, the API would be clearer. The only
adjustment would be to use "index" as the preset selection key. Anyway, it is too late
for such change. We need to live with that.

> 
>> 3.2) The preset macros don't have the name of the active video columns;
> 
> For the current set of macros the industry convention is used. 1080P50 always
> refers to 1920x1080. Anything else should be made explicit.
>  
>> 3.3) If someone would want to add a preset for some CEA-861-E VICs, namespace conflicts will
>>      happen. For example, a preset for 1440x576@50Hz would have the same name as a preset
>>      for 2880x576p at 50 Hz. Both would be called as V4L2_DV_576P50.
> 
> Obviously that would have to be called V4L2_DV_2880X576P50 (or something similar).

So, the namespace will become messy, with will make developers very confused about what they
should use.  As you've mentioned, there are currently 4 standards with timings that will
needed to be supported. So, at the end of the day, we'll have:

V4L2_DV_576P50
V4L2_DV_576P50_foo
V4L2_DV_576P50_bar
V4L2_DV_576P50_delta
V4L2_DV_2880X576P50
V4L2_DV_2880X576P50_foo
V4L2_DV_2880X576P50_bar
V4L2_DV_2880X576P50_delta
...

where foo, bar, and delta would be some othe DV-timings based naming. It will become a nightmare
for developers to discover, from the above list, what are the timings from VESA DMT and what
are from CEA-861.

The solution is to associate its name to the standards naming, like:

	V4L2_DV_CEA_861_VIC_35_36

For the timings associated with VICs 35 and 36.

> 
>> 3.4) It doesn't mind what DV timing is used, CEA-861-E and BT.709 allows to use the 60Hz
>>      timings as either 60Hz or 59.94 Hz. That applies to all VIC format timings at table 2
>>      for 60 Hz, 120 Hz and 240 Hz.
> 
> No, the pixelclock is part of the preset timings. So V4L2_DV_1080P60 and V4L2_DV_1080P59_94
> are different presets with different timings. Just as they would be different modelines
> for your graphics card. I really don't see the problem here.

Sorry, but the current way that this documented is not clear enough. Also, there's nothing
at VIDIOC_ENUM_DV_PRESETS that allows checking the fps, except for the preset name, which
is confusing enough.

>> 3.5) There are lots of format at CEA-861-E without a V4L2 preset.
> 
> True. Frankly I have yet to encounter any of the weird ones (i.e. other than
> 640x480, 480p/i, 576p/i, 720p/i and 1080p/i with their various framerates).
> 
>>
>> 4. PROPOSED SOLUTION
>>    ======== ========
>>
>> In order to fix the issue, we need change the API without breaking the current apps that
>> use the timings ioctls. Also, the vertical rate clock for 60Hz formats needs to allow
>> a fractional adjustment of either 1 or 1000/1001, in order to support the specs.
>>
>> 4.1) Preset renaming
>>      ---------------
>>
>> To avoid having duplicated namespace conflicts, the better seems to rename the existing
>> presets to contain both width and height at their macro definitions, like:
>>
>> #define V4L2_DV_1920_1080P60	18	1920x1080 progressive video at 60 fps as per BT.1120
>>
>> (for the sake of simplicity, I just took one value from the table. The same fix is needed
>>  to be applied for the other macro definitions)
>>
>> To avoid breaking userspace, the old names need to be associated with the new ones, with:
>>
>> #define V4L2_DV_1080P60		V4L2_DV_1920_1080P60
> 
> I've no problem with that. 1080P60 is still a useful shorthand.

As I said before, it will be better to change it to explicitly associate with the specs
that defined that video timing, with whatever ID code there. So, for CEA-861, it would
be, in this case:

#define V4L2_DV_CEA_861_VIC_16	18

and the legacy compat macro:
	#define V4L2_DV_1080P60		V4L2_DV_CEA_861_VIC_16

>>
>> This fixes issue 3.2 and 3.3. Unfortunately, fixing 3.1 is not possible anymore, so,
>> we have to keep the same information duplicated on two places (at the macro name and
>> at the width/height).
> 
> As I mentioned above, for a program the macro name is useless.
> 
>> The question that remains unsolved is what an userspace application would handle a driver
>> that might eventually provide inconsistent data at width/height and at the macro names?
> 
> That's a driver bug.
> 
>> 4.2) Framerate selection for 60Hz preset
>>      -----------------------------------
>>
>> As the spec allows using any format that it is multiple of 6.00 Hz multiplied by either
>> 1 or 1000/1001, the selection betweem them should be done via VIDIOC_G_PARM/VIDIOC_S_PARM.
>> So, V4L2 spec should say, at the "Digital Video (DV) Timings" section:
>>
>> 	Devices that implement DV timings shall implement VIDIOC_G_PARM/VIDIOC_S_PARM,
>> 	in order to allow controlling the vertical frame rate for the presets whose
>> 	vertical rate is multiple of 6.00 Hz, in order to allow setting the timing
>> 	between 60 Hz and 59.94 Hz. The default value, at device init, shall be 59.94 Hz.
> 
> NACK.
> 
> The pixel clock is part of the video timings and hence defined by the preset.
> 
> VIDIOC_S_PARM is used when the desired framerate differs from the actual framerate
> and the driver can do frame repeating or frameskipping.

NO. VIDIOC_S_PARM is used on all places where the user desires to specify a framerate. All
webcams use it to select the desired framerate.

> At least that's what the V4L2 spec says. 

I'll prepare a patch fixing it. This is one of the parts of the API that got outdated with
time.

> In practice it is used to set the framerate for sensors. I'm not sure
> if there is any driver that actually uses it for frameskipping. 

There are some video capture drivers that implement it, so I think that some use it for
frameskipping.

> To my knowledge it is not used at all for video output.

In any case, selecting a DV timing preset with an specific fps is currently confusing, and
requires that the userspace application to have a switch(v4l2_dv_enum_preset.preset) in order
to associate a preset macro name with a fps. This is a very bad idea.

I see only two practical solutions for that. The first one is to use S_PARAM. The other one 
is to stop providing the frequency inside the macro name, and add a field for that at the 
v4l2_dv_enum_preset struct:

struct v4l2_dv_enum_preset {
	__u32		index;
	__u32		preset;
	__u8		name[32]; /* Name of the preset timing */
	__u32		width;
	__u32		height;
	v4l2_fract	fps;
	__u32		reserved[2];
};

So, for example, a driver that supports only CEA-861 VIC 16 will report 2 presets:

struct v4l2_dv_enum_preset dv[] = {
	{ 0, V4L2_DV_CEA_861_VIC_16__60HZ,    "CEA-861 1920x1080p 60Hz", 1920, 1080, {60, 1} },
	{ 1, V4L2_DV_CEA_861_VIC_16__59_94HZ, "CEA-861 1920x1080p 59.94Hz", 1920, 1080, {60000, 1001} },
};

Yet, we should be sure that this will also cover all current VESA standards.

>> 4.3) Add the missing CEA-861-E presets
>>      ---------------------------------
>>
>> As those formats are part of the spec that is implemented by this V4L2 API, the better
>> would be to implement all the missing formats at the V4L2 spec. As a generic rule, we
>> don't add support at the Kernel without having a driver using it, but, in this specific
>> case, we want to be able to be compatible with the specs, so, it seems a good idea to
>> implement the remaining ones, or, at least reserve its namespace at the DocBook. This
>> solves issue 3.5.
> 
> I'm not so sure. There are lots of weird resolutions in CEA-861 that I have never
> seen in use. A better approach IMHO is that whenever we add a resolution to the
> preset table, then we do that for all variants of that resolution.

This works for me.

>> 5) S5P-TV SUPPORT FOR 59.94 HZ
>>    ===========================
>>
>> It is not clear, from this patch, if you're really wanting to implement support for VIC
>> 16 format @59.94 Hz, or something else. From CEA-861-E, it seems to be the case, as
>> this is the only 1920x1080p format for 60 Hz. If this is the case, according with my
>> proposal, the driver should be using the 60Hz format, instead, and implement S_PARM 
>> to allow selecting between 60Hz and 59.94Hz.
> 
> NACK. You need two presets: V4L2_DV_1080P60 and 1080P59_94. Just as is already there
> for 720P60 and 720P59_94. I really don't see the problem.

NACK adding it as "V4L2_DV_1080P59_94". 

Let's fix the namespace and provide a way to specify/enumberate the fps first, and then
change the patch to follow whatever decided.

Thanks,
Mauro
