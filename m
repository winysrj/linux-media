Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1764 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbZGMVeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 17:34:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: Control IOCTLs handling
Date: Mon, 13 Jul 2009 23:34:14 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <A69FA2915331DC488A831521EAE36FE40144E4B70A@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40144E4B70A@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907132334.14309.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 13 July 2009 20:21:20 Karicheri, Muralidharan wrote:
> Hi,
>
> I need to implement some controls for my driver and would like to
> understand the control ioctl framework available today. I am not very
> sure how the control ioctls are to be implemented and it is not well
> defined in the specification. I have provided below my understanding of
> the below set of controls. I would like to hear what you think about the
> same.
>
> I see following controls defined for adjusting brightness, contrast etc.
>
> V4L2_CID_BRIGHTNESS	integer	Picture brightness, or more precisely, the
> black level. V4L2_CID_CONTRAST	integer	Picture contrast or luma gain.
> V4L2_CID_SATURATION	integer	Picture color saturation or chroma gain.
> V4L2_CID_HUE	integer	Hue or color balance.
>
> I think these controls refer to the YUV color space. Y (luma) and UV
> (chroma) signals will be modified by above controls.
>
> V4L2_CID_DO_WHITE_BALANCE	button	This is an action control. When set (the
> value is ignored), the device will do a white balance and then hold the
> current setting. Contrast this with the boolean
> V4L2_CID_AUTO_WHITE_BALANCE, which, when activated, keeps adjusting the
> white balance. V4L2_CID_RED_BALANCE	integer	Red chroma balance.
> V4L2_CID_BLUE_BALANCE	integer	Blue chroma balance.
>
> My understanding is these controls are applied to RGB color space.
> V4L2_CID_AUTO_WHITE_BALANCE is applicable where hardware is capable of
> adjusting the wb automatically. But V4L2_CID_DO_WHITE_BALANCE is used in
> conjunction with V4L2_CID_RED_BALANCE & V4L2_CID_BLUE_BALANCE. i.e
> application set these values and they take effect when
> V4L2_CID_DO_WHITE_BALANCE is issued. So driver hold onto the current
> values until another set of above commands are issued.
>
> But one question I have is (if the above is correct), why there is no
> V4L2_CID_GREEN_BALANCE ??
>
> I don't see any control IDs available for Bayer RGB color space.
>
> In our video hardware, there is a set of Gain values that can be applied
> to the Bayer RGB data. We can apply them individually to R, Gr, Gb or B
> color components. So I think we need to have 4 more controls defined for
> doing white balancing in the Bayer RGB color space that is applicable for
> sensors (like MT9T031) and image tuning hardware like the VPFE CCDC &
> IPIPE.
>
> Define following new controls for these in Bayer RGB color space White
> Balance (WB) controls??
>
> V4L2_CID_BAYER_RED_BALANCE	integer	Bayer Red balance.
> V4L2_CID_BAYER_BLUE_BALANCE	integer	Bayer Blue balance.
> V4L2_CID_BAYER_GREEN_R_BALANCE	integer	Bayer Gr balance.
> V4L2_CID_BAYER_GREEN_B_BALANCE	integer	Bayer Gb balance.
>
> There is also an offset value defined per color which is like adjusting
> the black level in the video image data. It is subtracted from the image
> byte. What you call this ? Should we define a new control,
> V4l2_CID_BAYER_OFFSET ??
>
> In my experience, all these values (except offset) have a sign bit which
> means the nominal value is zero and it can be changed with positive or
> negative values.

I leave this to the webcam/sensor experts, they know more about that than I 
do.

> Then for image tuning hardware like, IPIPE (Image Pipe) of Texas
> Instruments, there are additional controls that are applicable. They are
> mostly applicable for devices that captures Bayer RGB data from sensors.
> Some of these are given below...
>
> Defect Pixel correction - Correct dead pixels in the captured image data.
> Color Space conversion - Convert between Bayer RGB pattern and others
> Data Formatter - Allow reading of different arrangement of R, Gr, Gb, B
> color filters in the sensor. Black Clamp - Adjust blackness in the image
> data either automatically using black area pixels or using manual
> controls RGB to RGB gain control - After converting from Bayer RGB to RGB
> data, these are applied
>
> RGB to YUV gain control - Applied after YUV conversion
> Noise filters - Noise filters to remove noise from the image data
>
> VPFE hardware can do above processing on the image sensor data and how do
> we implement them. Do we implement them through following extended
> control IOCTLs ?
>
> #define VIDIOC_G_EXT_CTRLS	_IOWR('V', 71, struct v4l2_ext_controls)
> #define VIDIOC_S_EXT_CTRLS	_IOWR('V', 72, struct v4l2_ext_controls)
> #define VIDIOC_TRY_EXT_CTRLS	_IOWR('V', 73, struct v4l2_ext_controls)
>
> Currently they are implemented using proprietary ioctls.

Do you mean proprietary ioctls or proprietary controls? Here you talk about 
ioctls where below you suddenly refer to 'control IDs'.

> But if other 
> hardware supports similar features, then it is worth standardizing these
> control IDs. But configuring them may still require proprietary
> structures. Does extended control structure will allow this?

It's possible, but whether it is the right approach is another matter.

> Following are the structures available for extended controls:-
>
> struct v4l2_ext_control {
> 	__u32 id;
> 	__u32 reserved2[2];
> 	union {
> 		__s32 value;
> 		__s64 value64;
> 		void *reserved;
> 	};
> } __attribute__ ((packed));
>
> struct v4l2_ext_controls {
> 	__u32 ctrl_class;
> 	__u32 count;
> 	__u32 error_idx;
> 	__u32 reserved[2];
> 	struct v4l2_ext_control *controls;
> };
>
>
> If I have to use v4l2_ext_control to configure the above modules in the
> hardware, I might have to use reserved field to pass the control
> parameter structure ptr to the driver. In that case it is better to
> rename the reserved field as to accept a ptr to configuration structure
> as :-
>
> 	void *config

We definitely never want void pointers here. I'm going to work on a proper 
implementation of string controls this weekend (time permitting), and that 
should demonstrate how to implement this.

However, before we can decide whether a currently proprietary control or 
ioctls can become a part of the API we first need to know in detail how 
each control/ioctl works: what does it do, what are the input and output 
arguments, how likely it is to be a generic feature, do you know about 
other devices that do this?

Based on that information we can decide to either leave it a proprietary 
control or ioctls, or to turn it into either a new V4L2 ioctl, or one or 
more new controls.

>
> Finally, what is the criteria used for defining control classes?
> Currently we have USER, MPEG and CAMERA control classes. Do I need to
> define a new control class for the Bayer RGB color space WB and other
> controls mentioned here.

The idea of a non-USER control class is that all controls within a class 
relate to a specific device. E.g. all controls of the MPEG class control 
the MPEG encoder device. All controls in the CAMERA class control the 
mechanical features of a camera (i.e. mostly motor control).

In particular it should be possible to set multiple controls of one control 
class atomically (particularly important for e.g. camera motor control). 
Having control in one class address different i2c devices will make it very 
hard to satisfy that requirement.

In this case many of these controls would probably end up in USER. I don't 
think any of these requires atomicity and neither are they very 
specifically targeted at one type of subdevice.

Probably the best approach to take is to write it down in an RFC. Just the 
act of writing it down will often clarify things in your mind. At least, 
that is my experience.

Regarding color space conversion: I've seen proposals for that before from 
Hardik Shah. You should probably coordinate this with him first.

Regards,

	Hans

>
>
> Please let me know what your thoughts are....
>
>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> Phone : 301-515-3736
> email: m-karicheri2@ti.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
