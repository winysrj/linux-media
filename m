Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61971 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934386Ab1KJPXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 10:23:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LUG00IIUAQX3G80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Nov 2011 15:23:22 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LUG0077QAQXOH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Nov 2011 15:23:21 +0000 (GMT)
Date: Thu, 10 Nov 2011 16:23:19 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC] SUBDEV_S/G_SELECTION IOCTLs
In-reply-to: <20111108215514.GJ22159@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com
Message-id: <4EBBEC67.4080208@samsung.com>
References: <20111108215514.GJ22159@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 11/08/2011 10:55 PM, Sakari Ailus wrote:
> Hi all,
>
> This RFC discusses the SUBDEV_S_SELECTION/SUBDEV_G_SELECTION API which is
> intended to amend and replace the existing SUBDEV_[SG]_CROP API. These
> IOCTLs have previously been discussed in the Cambridge V4L2 brainstorming
> meeting [0] and their intent is to provide more configurability for subdevs,
> including cropping on the source pads and composing for a display.
>
> The S_SELECTION patches for V4L2 nodes are available here [1] and the
> existing documentation for the V4L2 subdev pad format configuration can be
> found in [2].
>
> SUBDEV_[SG]_SELECTION is intended to fully replace SUBDEV_[SG]_CROP in
> drivers as the latter can be implemented in SUBDEV_[SG]_SELECTION using
> active CROP target on sink pads. That can be done in v4l2-ioctl.c so drivers
> only will need to implement SUBDEV_[SG]_SELECTION.
>
>
> Questions, comments and thoughts are welcome, especially regarding new use
> cases.
>
>
> Order of configuration
> ======================

Sorry, what is exactly the SOURCE pad and SINK pad? The spec says "Data 
flows from a source pad to a sink pad.". Does in refer to a subdev or to 
a link? Look at the image below:

data ---- link0 --> (pad0) [subdev] (pad1) ----> link1

 From subdev's point of view, pad0 is data source, pad1 is the sink. 
 From link0's point of view, pad0 is a data sink. Which interpretation 
is correct?

>
> The proposed order of the subdev configuration is as follows. Individual
> steps may be omitted since any of the steps will reset the rectangles /
> sizes for any following step.

I assume that SOURCE and SINK are defined from the link's point of view. 
Otherwise it would mean that configuration goes in order opposite to 
data flow order.

I do not think that resetting is a good idea. It is better to state in 
spec that change of a given target guarantee that targets/formats 
earlier in pipeline are not modified. Part below pipeline may change or 
not. The application should check if the configuration of lower parts of 
pipeline is suitable. For example

Change of COMPOSE target on SINK pad must not modify
- format on the SINK pad
- CROP on the SINK pad

All other parameters may change. Of course the configuration of lower 
part must be consistent with higher part of the pipeline.

>
> 1. SUBDEV_S_FMT on the SINK pad. The user will issue SUBDEV_S_FMT to set the
> subdev sink pad image size and media bus format code and other parameters in
> v4l2_mbus_framefmt as necessary.
>
> 2. SUBDEV_S_SELECTION with CROP target on the SINK pad. The crop rectangle
> is set related to the image size given in step 1).
>
> 3. SUBDEV_S_SELECTION with COMPOSE target on the SINK pad. The size of the
> compose rectangle, if it differs from the size of the rectangle given in 2),
> signifies user's wish to perform scaling.
>
> 4. SUBDEV_S_SELECTION with CROP target on the SOURCE pad. Configure cropping
> performed by the subdev after scaling.
>
> 5. SUBDEV_S_SELECTION with COMPOSE target on the SOURCE pad. This configures
> composition on the display if relevant for the subdevice. (In this case the
> COMPOSE bounds will yield to the size of the display.)
>
> 6. SUBDEV_S_FMT on the SOURCE pad. The size of the image is defined by
> setting CROP on the SOURCE pad, so SUBDEV_S_FMT only has an effect of
> changing other parameters than size.
>
> As defined in [2], when performing any of the configuration phases above,
> the formats and selections are reset to defaults from each phase onwards.
> For example, SUBDEV_S_SELECTION with CROP target on the SINK pad will
> --- beyond its obvious function of setting CROP selection target on the SINK
> pad --- reset the COMPOSE selection target on SINK pad, as well as the CROP
> selection target and format on the SOURCE pad.
>
>

I think that formal definitions of CROP,COMPOSE for pads are needed.
As I remember from Cambridge brainstorming we agreed that SINK.COMPOSE 
and SOURCE.CROP are expressed in subdev's internal coordinate system.
The SINK.CROP is expressed in link0's coordinate system and 
SOURCE.COMPOSE is expressed in link1's coordinate system.

> Definitions
> ===========
>
> /**
>   * struct v4l2_subdev_selection - selection info
>   *
>   * @which: either V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY
>   * @pad: pad number, as reported by the media API
>   * @target: selection target, used to choose one of possible rectangles
>   * @flags: constraints flags
>   * @r: coordinates of selection window
>   * @reserved: for future use, rounds structure size to 64 bytes, set to zero
>   *
>   * Hardware may use multiple helper window to process a video stream.
>   * The structure is used to exchange this selection areas between
>   * an application and a driver.
>   */
> struct v4l2_subdev_selection {
> 	__u32 which;
> 	__u32 pad;
> 	__u32 target;
> 	__u32 flags;
> 	struct v4l2_rect r;
> 	__u32 reserved[8];
> };
>
> Both SUBDEV_S_SELECTION and SUBDEV_G_SELECTION would take struct
> v4l2_subdev_selection as the IOCTL argument (RW).
>
> The same target definitions and flags apply as in [1], with possible
> exception of the PADDED targets --- see below. The flags will gain _SUBDEV
> prefix after the existing V4L2 prefix.
>
>
> Sample use cases
> ================
>
>
> OMAP 3 ISP preview
> ------------------
>
> The OMAP 3 ISP preview block provides cropping on preview sink pad, but also
> horizontal averaging. The horizontal averaging may scale the image
> horizontally by factor 1/n, where n is either 1, 2, 4 or 8.
>
> The preview block also performs pixel format conversion from raw bayer to
> YUV. Other image processing operations crops maximum of 12 columns and 8 rows
> before the format conversion. After the format conversion, further 2 columns
> are cropped.
>
> To make this easy for the user, the driver assumes that all the features
> affecting cropping are enabled at all times so the size stays constant for
> the user.
>
>
> This example only includes the preview subdev since it can be shown
> independently. In the example, the preview subdev is configured to crop the
> image by 100 pixels on all sides of the image. The horizontal averaging is
> configured by factor 1/2, which translates 100 pixels from each side of the
> original image. The preview sink pad format is 800x600 SGRBG10.
>
>
> [crop] 0:preview:1 [crop (static), compose]
>
> 	The initial state of the pipeline is:
>
> 	preview:0	preview:1
> compose (0,0)/788x592	(0,0)/788x592
> crop	(7,4)/788x592	(1,0)/786x592
> fmt	800x600/SGRBG10	786x592/YUYV
>
> 	This is due to hardware imposed cropping performed in the sink pad
> 	as well as on the source pad.
>
> 	To crop 100 pixels on all sides:
>
> 	SUBDEV_S_SELECTION(preview:0, CROP_ACTIVE, (99,100)/602x400);
>
> 	The hardware mandated crop on the sink pad is thus one pixel on left
> 	and right sides of the image. (This would also be shown in the
> 	CROP_BOUNDS target.)
>
> 	preview:0	preview:1
> compose (0,0)/602x400	(0,0)/602x400
> crop	(99,100)/602x400 (1,0)/600x400
> fmt	800x600/SGRBG10	600x400/YUYV
>
>
> A sensor
> --------
>
> The intent is to obtain a VGA image from a 8 MP sensor which provides
> following pipeline:
>
> pixel_array:0 [crop] --->  0:binner:1 --->  [crop] 0:scaler:1 [crop]
>
> Binner is an entity which can perform scaling, but only in factor of 1/n,
> where n is a positive integer. No cropping is needed. The intent is to get a
> 640x480 image from such sensor. (This doesn't involve any other
> configuration as the image size related one.)
>
> 	The initial state of the pipeline
>
> 	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> compose (0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464
> crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464
> fmt	3600x2464	3600x2464	3600x2464	3600x2464	3600x2464
>
> 	This will configure the binning on the binner subdev sink pad:
>
> 	SUBDEV_S_SELECTION(binner:0, COMPOSE_ACTIVE, (0,0)/1800x1232);
>
> 	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> compose (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/3600x2464	(0,0)/3600x2464
> crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/3600x2464	(0,0)/3600x2464
> fmt	3600x2464	3600x2464	1800x1232	3600x2464	3600x2464
>
> 	The same format must be set on the scaler pad 0 as well. This will
> 	reset the size inside the scaler to a sane default, which is no
> 	scaling:
>
> 	SUBDEV_S_FMT(scaler:0, 1800x1232);
>
> 	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> compose (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/1800x1232
> crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/1800x1232
> fmt	3600x2464	3600x2464	1800x1232	1800x1232	1800x1232

I assume that scaler can upscale image 1800x1232 on scaler:0 to 
3600x2464 on pad scaler:1. Therefore the format and compose targets on 
scaler:1 should not be changed.

>
> 	To perform further scaling on the scaler, the COMPOSE target is used
> 	on the scaler subdev's SOURCE pad:
>
> 	SUBDEV_S_SELECTION(scaler:0, COMPOSE_ACTIVE, (0,0)/640x480);
>
> 	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> compose (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/640x480	(0,0)/640x480
> crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/640x480
> fmt	3600x2464	3600x2464	1800x1232	1800x1232	640x480
>

It is possible to compose 640x480 image into 1800x1232 data stream 
produced on scaler:1. Therefore the format on scaler:1 should not be 
changed. The area outside 640x480 would left undefined or filled by some 
pattern configured using controls. This situation was the reason of 
introducing PADDED target.

Best regards,
Tomasz Stanislawski

>
> The result is a 640x480 image from the scaler's output pad. The aspect ratio
> of the resulting image is different from 4/3 since no cropping was
> performed in this example.
>
>
> Applications which do not recognise SUBDEV_S_SELECTION
> ======================================================
>
> The current spec [2] tells that the scaling factor is defined by using
> SUBDEV_S_FMT in the source pad. This method would not be supported in the
> future, possibly affecting applications which use SUBDEV_S_FMT to configure
> the scaling factor.
>
> If supporting this is seen necessary, it can be implemented by e.g.
> reverting to the old behaviour if the SOURCE crop rectangle width or height
> is different from width and height specified in SOURCE S_FMT.
>
>
> Open questions
> ==============
>
> 1. Keep subdev configuration flag. In Cambourne meeting the case of the OMAP
> 3 ISP resizer configuration dilemma was discussed, and the proposal was to
> add a flag to disable propagating the configuration inside a single subdev.
> Propagating inside a single subdev is the default. Where do we need this
> flag; is just SUBDEV_S_SELECTION enough? [0]
>
> 2. Are PADDED targets relevant for media bus formats? [3]
>
>
> References
> ==========
>
> [0] http://www.mail-archive.com/linux-media@vger.kernel.org/msg35361.html
>
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36206.html
>
> [2] http://hverkuil.home.xs4all.nl/spec/media.html#subdev
>
> [3] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36203.html
>
>

