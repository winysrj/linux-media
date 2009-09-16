Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082AbZIPVEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 17:04:41 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 16 Sep 2009 16:04:42 -0500
Subject: RE: RFC: V4L - Support for video timings at the input/output
 interface
Message-ID: <A69FA2915331DC488A831521EAE36FE40155157076@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
 <200909150853.19902.hverkuil@xs4all.nl>
In-Reply-To: <200909150853.19902.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I was busy with some of the merge work and also some other issues.
So this delayed response...

>
>Thanks for your work on this!

You are most welcome !

>> Where preset is one of the following values:-
>>
>> #define	  V4L2_DV_CUSTOM        0x00000000
>> #define       V4L2_DV_480I59_94     0x00000001
>> #define       V4L2_DV_480I60        0x00000002
>> #define       V4L2_DV_480P23_976    0x00000003
>> #define       V4L2_DV_480P24        0x00000004
>> #define       V4L2_DV_480P29_97     0x00000005
>> #define       V4L2_DV_480P30        0x00000006
>> #define       V4L2_DV_576I50        0x00000007
>> #define       V4L2_DV_576P25        0x00000008
>> #define       V4L2_DV_576P50        0x00000009
>> #define       V4L2_DV_720P23_976    0x0000000A
>> #define       V4L2_DV_720P24        0x0000000B
>> #define       V4L2_DV_720P25        0x0000000C
>> #define       V4L2_DV_720P29_97     0x0000000C
I need to correct this and below for value.
>> #define       V4L2_DV_720P30        0x0000000D
>> #define       V4L2_DV_720P50        0x0000000E
>> #define       V4L2_DV_720P59_94     0x0000000F
>> #define       V4L2_DV_720P60        0x00000010
>> #define       V4L2_DV_1080I50       0x00000011
>> #define       V4L2_DV_1080I59_94    0x00000012
>> #define       V4L2_DV_1080I60       0x00000013
>> #define       V4L2_DV_1080P23_976   0x00000014
>> #define       V4L2_DV_1080P24       0x00000015
>> #define       V4L2_DV_1080P25       0x00000016
>> #define       V4L2_DV_1080P29_97    0x00000017
>> #define       V4L2_DV_1080P30       0x00000018
>> #define       V4L2_DV_1080P60       0x00000019
>>
>>
>> where capabilities are:-
>>
>> #define V4L2_SUPPORTS_PRESETS        0x00000001
>> #define V4L2_SUPPORTS_CUSTOM_TIMINGS 0x00000002
>
>Rather than use 'SUPPORTS' we should rename it as 'IO_CAP'. That's more in
>line with the existing naming conventions.
>
>I also suggest adding V4L2_IO_CAP_STD if the regular S_STD is supported.
>This will require going through the code and adding it, although we can
>probably also set these caps in v4l2-ioctl automatically.


Ok.

>
>>
>> For setting custom timing at the device, following structure is used
>which defines the complete set of timing values required at the input and
>output interface:-
>>
>> /* timing data values specified by various standards such as BT.1120,
>BT.656 etc. */
>>
>> /* bt.656/bt.1120 timing data */
>> struct v4l2_bt_timings {
>>     __u32 interlaced;
>>     __u64 pixelclock;
>>     __u32 width, height;
>>     __u32 polarities;
>>     __u32 hfrontporch, hsync, htotal;
>>     __u32 vfrontporch, vsync, vtotal;
>>     /* timings for bottom frame for interlaced formats */
>>     __u32 il_vtotal;
>>     __u32 reserved[16];
>> };
>>
>>
>> interlaced - Interlaced or progressive. use following values:-
>>
>> #define V4L2_DV_INTERLACED     0
>> #define V4L2_DV_PROGRESSIVE    1
>>
>> pixelclock - expressed in HZ. So for 74.25MHz, use 74250000.
>> width - number of pixels in horizontal direction
>> height - number of lines in vertical direction
>> polarities - Bit mask for following polarities to begin with
>>
>> #define V4L2_DV_VSYNC_POS_POL    0x1
>> #define V4L2_DV_VSYNC_NEG_POL    0x2
>> #define V4L2_DV_HSYNC_POS_POL    0x3
>> #define V4L2_DV_HSYNC_NEG_POL    0x4
>
>Why have separate pos and neg bits? Also, bitmask defines should define the
>actual mask, not the bit numbers.

Oops! That was your original comment. Need to change these to masks.
as 

#define V4L2_DV_VSYNC_POS_POL    0x00000001
#define V4L2_DV_VSYNC_NEG_POL    0x00000002
#define V4L2_DV_HSYNC_POS_POL    0x00000004
#define V4L2_DV_HSYNC_NEG_POL    0x00000008


Here is your comment earlier...
==========================================================================
> pixelclock - expressed in HZ. So for 74.25MHz, use 74250000.

> width - number of pixels in horizontal direction

> height - number of lines in vertical direction

> polarities - Bit mask for following polarities to begin with

>

> #define V4L2_DV_VSYNC_POL    0x1

> #define V4L2_DV_HSYNC_POL    0x2

I suggest a name like V4L2_DV_VSYNC_POS_POL 0x1 to signify that this sets positive polarity.
=========================================================================

>> Open issues
>> -----------
>>
>> 1.How to handle an HDMI transmitter? It can be put in two different
>modes: DVI compatible
>> or HDMI compatible. Some of the choices are
>> 	a) enumerate them as two different outputs when enumerating.
>>         b) adding a status bit on the input.
>>         c) change it using a control
>
>The same is also true for a receiver, BTW. They usually can detect whether
>the
>input is in HDMI or DVI mode.
>
>> 2. Detecting whether there is an analog or digital signal on an DVI-I
>input:
>> 	a) add new status field value for v4l2_input ?
>> 	   #define  V4L2_IN_ST_DVI_ANALOG_DETECTED    0x10000000
>> 	   #define  V4L2_IN_ST_DVI_DITIGITAL_DETECTED 0x20000000
>
>Typo: DIGITAL.
Ok.
>
>I don't think this has to be DVI specific. Just 'ST_DETECTED_ANALOG' and
>ST_DETECTED_DIGITAL' should be sufficient and it is more general as well.
>
Ok
>> 3. Detecting an EDID.
>> 	a) adding a status field in v4l2_output and two new ioctls that can
>>          set the EDID for an input or retrieve it for an output. It
>should
>>          also be added as an input/output capability.
>>
>> 4. ATSC bits in v4l2_std_id: how are they used? Are they used at all for
>>    that matter?
>>
>>
>> 6. HDMI requires additional investigation. HDMI defines a whole bunch of
>>    infoframe fields. Most of these can probably be exported as controls??
>Is
>>    HDMI audio handled by alsa?
>
>I want to add another two:
>
>7. How to use S_DV_TIMINGS to setup a sensor.
>   Sensors can be setup either using the full DV_TIMINGS functionality (e.g.
>   pixelclock, porches, sync width, etc.) or with a subset only: width,
>height,
>   frame period. The latter can already be setup with S_PARM (but do we
>want
>   that? S_PARM is very, very ugly). I am thinking of creating a new
>DV_TIMINGS
>   type for this with just width, height and frame period.
>   But this leads to another complication: how to tell the user which
>timings
>   type to use? Easiest way is to use the capabilities field:
>CAP_BT_TIMINGS,
>   CAP_FRAME_TIMINGS. Of course, this limits the number of possible timings
>   we can define. The alternative is to add yet another field that contains
>   the actual timings type. But I think this is overkill.

How about adding two capability flag - CAP_FIXED_FRAME_RATE and CAP_VARIABLE_FRAME_RATE? and change preset type to

struct v4l2_dv_preset {
    __u32 preset;
	v4l2_fract fps;
    __u32 reserved[4];
};

Where preset can be just referring a resolution and scan type.

#define       V4L2_DV_720X480P     0x00000001
#define       V4L2_DV_640X480P     0x00000002
#define       V4L2_DV_720X576P     0x00000003

and so forth. So for a camera that supports pre-defined presets can
set the CAP_FIXED_FRAME_RATE capability. So Auto exposure may not
be available. If Auto exposure is available, the driver can indicate
CAP_VARIABLE_FRAME_RATE. If a driver supports both, then both flags
can be set and based on the value of fps can decide which mode to
operate on (0/0 - for variable mode, 30/1 - to do 30fps rate).
>
>8. Querying non-standard timings.
>   Currently not in this proposal. This is a complex topic and at this
>moment
>   I can't oversee all the possibilities. I know from personal experience
>   that this is a very difficult topic and I am not sure whether it can be
>   done reliably through a QUERY_DV_TIMINGS type ioctl. It may need
>additional
>   support in the form of receiver-specific ioctls.
>   I propose to postpone this until someone actually needs it.
>
Ok. I will add this.

>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

