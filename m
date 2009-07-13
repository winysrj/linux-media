Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:39404 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844AbZGMSV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 14:21:27 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n6DILM2p020512
	for <linux-media@vger.kernel.org>; Mon, 13 Jul 2009 13:21:27 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id n6DILL6U012565
	for <linux-media@vger.kernel.org>; Mon, 13 Jul 2009 13:21:22 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n6DILL9q001510
	for <linux-media@vger.kernel.org>; Mon, 13 Jul 2009 13:21:21 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 13 Jul 2009 13:21:20 -0500
Subject: Control IOCTLs handling
Message-ID: <A69FA2915331DC488A831521EAE36FE40144E4B70A@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I need to implement some controls for my driver and would like to understand the control ioctl framework available today. I am not very sure how the control ioctls are to be implemented and it is not well defined in the specification. I have provided below my understanding of the below set of controls. I would like to hear what you think about the same. 

I see following controls defined for adjusting brightness, contrast etc.

V4L2_CID_BRIGHTNESS	integer	Picture brightness, or more precisely, the black level.
V4L2_CID_CONTRAST	integer	Picture contrast or luma gain.
V4L2_CID_SATURATION	integer	Picture color saturation or chroma gain.
V4L2_CID_HUE	integer	Hue or color balance.

I think these controls refer to the YUV color space. Y (luma) and UV (chroma) signals will be modified by above controls.

V4L2_CID_DO_WHITE_BALANCE	button	This is an action control. When set (the value is ignored), the device will do a white balance and then hold the current setting. Contrast this with the boolean V4L2_CID_AUTO_WHITE_BALANCE, which, when activated, keeps adjusting the white balance.
V4L2_CID_RED_BALANCE	integer	Red chroma balance.
V4L2_CID_BLUE_BALANCE	integer	Blue chroma balance.

My understanding is these controls are applied to RGB color space. V4L2_CID_AUTO_WHITE_BALANCE is applicable where hardware is capable of adjusting the wb automatically. But V4L2_CID_DO_WHITE_BALANCE is used in conjunction with V4L2_CID_RED_BALANCE & V4L2_CID_BLUE_BALANCE. i.e application set these values and they take effect when V4L2_CID_DO_WHITE_BALANCE is issued. So driver hold onto the current values until another set of above commands are issued.

But one question I have is (if the above is correct), why there is no V4L2_CID_GREEN_BALANCE ??

I don't see any control IDs available for Bayer RGB color space.

In our video hardware, there is a set of Gain values that can be applied to the Bayer RGB data. We can apply them individually to R, Gr, Gb or B color components. So I think we need to have 4 more controls defined for doing white balancing in the Bayer RGB color space that is applicable for sensors (like MT9T031) and image tuning hardware like the VPFE CCDC & IPIPE.

Define following new controls for these in Bayer RGB color space White Balance (WB) controls??

V4L2_CID_BAYER_RED_BALANCE	integer	Bayer Red balance.
V4L2_CID_BAYER_BLUE_BALANCE	integer	Bayer Blue balance.
V4L2_CID_BAYER_GREEN_R_BALANCE	integer	Bayer Gr balance.
V4L2_CID_BAYER_GREEN_B_BALANCE	integer	Bayer Gb balance.

There is also an offset value defined per color which is like adjusting the black level in the video image data. It is subtracted from the image byte.
What you call this ? Should we define a new control, V4l2_CID_BAYER_OFFSET ??	

In my experience, all these values (except offset) have a sign bit which means the nominal value is zero and it can be changed with positive or negative values.

Then for image tuning hardware like, IPIPE (Image Pipe) of Texas Instruments, there are additional controls that are applicable. They are mostly applicable for devices that captures Bayer RGB data from sensors. Some of these are given below...

Defect Pixel correction - Correct dead pixels in the captured image data.
Color Space conversion - Convert between Bayer RGB pattern and others
Data Formatter - Allow reading of different arrangement of R, Gr, Gb, B color filters in the sensor.
Black Clamp - Adjust blackness in the image data either automatically using black area pixels or using manual controls
RGB to RGB gain control - After converting from Bayer RGB to RGB data, these 
				  are applied

RGB to YUV gain control - Applied after YUV conversion
Noise filters - Noise filters to remove noise from the image data

VPFE hardware can do above processing on the image sensor data and how do we implement them. Do we implement them through following extended control IOCTLs ?

#define VIDIOC_G_EXT_CTRLS	_IOWR('V', 71, struct v4l2_ext_controls)
#define VIDIOC_S_EXT_CTRLS	_IOWR('V', 72, struct v4l2_ext_controls)
#define VIDIOC_TRY_EXT_CTRLS	_IOWR('V', 73, struct v4l2_ext_controls)

Currently they are implemented using proprietary ioctls. But if other hardware supports similar features, then it is worth standardizing these control IDs. But configuring them may still require proprietary structures. Does extended control structure will allow this?

Following are the structures available for extended controls:-

struct v4l2_ext_control {
	__u32 id;
	__u32 reserved2[2];
	union {
		__s32 value;
		__s64 value64;
		void *reserved;
	};
} __attribute__ ((packed));

struct v4l2_ext_controls {
	__u32 ctrl_class;
	__u32 count;
	__u32 error_idx;
	__u32 reserved[2];
	struct v4l2_ext_control *controls;
};


If I have to use v4l2_ext_control to configure the above modules in the hardware, I might have to use reserved field to pass the control parameter structure ptr to the driver. In that case it is better to rename the reserved field as to accept a ptr to configuration structure as :-

	void *config

Finally, what is the criteria used for defining control classes? Currently we have USER, MPEG and CAMERA control classes. Do I need to define a new control class for the Bayer RGB color space WB and other controls mentioned here.


Please let me know what your thoughts are....


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

