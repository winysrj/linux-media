Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:46799 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab1KJW3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 17:29:40 -0500
Date: Fri, 11 Nov 2011 00:29:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com
Subject: Re: [RFC] SUBDEV_S/G_SELECTION IOCTLs
Message-ID: <20111110222933.GS22159@valkosipuli.localdomain>
References: <20111108215514.GJ22159@valkosipuli.localdomain>
 <4EBBEC67.4080208@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBBEC67.4080208@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for your comments!

On Thu, Nov 10, 2011 at 04:23:19PM +0100, Tomasz Stanislawski wrote:
> Hi Sakari,
> 
> 
> On 11/08/2011 10:55 PM, Sakari Ailus wrote:
> >Hi all,
> >
> >This RFC discusses the SUBDEV_S_SELECTION/SUBDEV_G_SELECTION API which is
> >intended to amend and replace the existing SUBDEV_[SG]_CROP API. These
> >IOCTLs have previously been discussed in the Cambridge V4L2 brainstorming
> >meeting [0] and their intent is to provide more configurability for subdevs,
> >including cropping on the source pads and composing for a display.
> >
> >The S_SELECTION patches for V4L2 nodes are available here [1] and the
> >existing documentation for the V4L2 subdev pad format configuration can be
> >found in [2].
> >
> >SUBDEV_[SG]_SELECTION is intended to fully replace SUBDEV_[SG]_CROP in
> >drivers as the latter can be implemented in SUBDEV_[SG]_SELECTION using
> >active CROP target on sink pads. That can be done in v4l2-ioctl.c so drivers
> >only will need to implement SUBDEV_[SG]_SELECTION.
> >
> >
> >Questions, comments and thoughts are welcome, especially regarding new use
> >cases.
> >
> >
> >Order of configuration
> >======================
> 
> Sorry, what is exactly the SOURCE pad and SINK pad? The spec says
> "Data flows from a source pad to a sink pad.". Does in refer to a
> subdev or to a link? Look at the image below:
> 
> data ---- link0 --> (pad0) [subdev] (pad1) ----> link1
> 
> From subdev's point of view, pad0 is data source, pad1 is the sink.
> From link0's point of view, pad0 is a data sink. Which
> interpretation is correct?

It should say "link" in the spec. That needs to be clarified in the spec...

> >The proposed order of the subdev configuration is as follows. Individual
> >steps may be omitted since any of the steps will reset the rectangles /
> >sizes for any following step.
> 
> I assume that SOURCE and SINK are defined from the link's point of
> view. Otherwise it would mean that configuration goes in order
> opposite to data flow order.
> 
> I do not think that resetting is a good idea. It is better to state
> in spec that change of a given target guarantee that targets/formats
> earlier in pipeline are not modified. Part below pipeline may change
> or not. The application should check if the configuration of lower
> parts of pipeline is suitable. For example

I don't think the above text in the RFC would be a change on how it works at
the moment. Inside a subdev the following stages of configuration (as in the
flow of data) are indeed reset.

Much of the hardware actually needs this unless they're scalers.

> Change of COMPOSE target on SINK pad must not modify
> - format on the SINK pad
> - CROP on the SINK pad
> 
> All other parameters may change. Of course the configuration of
> lower part must be consistent with higher part of the pipeline.

The above two would not be changed since they are before the compose window
in the sink pad.

If the user wishes the following stages also not to be modified, (s)he can
specify it using a flag. We could call it V4L2_SUBDEV_SEL_FLAG_LOCALCHANGE.
Better names are always welcome. :)

See also open question 1.

> >
> >1. SUBDEV_S_FMT on the SINK pad. The user will issue SUBDEV_S_FMT to set the
> >subdev sink pad image size and media bus format code and other parameters in
> >v4l2_mbus_framefmt as necessary.
> >
> >2. SUBDEV_S_SELECTION with CROP target on the SINK pad. The crop rectangle
> >is set related to the image size given in step 1).
> >
> >3. SUBDEV_S_SELECTION with COMPOSE target on the SINK pad. The size of the
> >compose rectangle, if it differs from the size of the rectangle given in 2),
> >signifies user's wish to perform scaling.
> >
> >4. SUBDEV_S_SELECTION with CROP target on the SOURCE pad. Configure cropping
> >performed by the subdev after scaling.
> >
> >5. SUBDEV_S_SELECTION with COMPOSE target on the SOURCE pad. This configures
> >composition on the display if relevant for the subdevice. (In this case the
> >COMPOSE bounds will yield to the size of the display.)
> >
> >6. SUBDEV_S_FMT on the SOURCE pad. The size of the image is defined by
> >setting CROP on the SOURCE pad, so SUBDEV_S_FMT only has an effect of
> >changing other parameters than size.
> >
> >As defined in [2], when performing any of the configuration phases above,
> >the formats and selections are reset to defaults from each phase onwards.
> >For example, SUBDEV_S_SELECTION with CROP target on the SINK pad will
> >--- beyond its obvious function of setting CROP selection target on the SINK
> >pad --- reset the COMPOSE selection target on SINK pad, as well as the CROP
> >selection target and format on the SOURCE pad.
> >
> >
> 
> I think that formal definitions of CROP,COMPOSE for pads are needed.
> As I remember from Cambridge brainstorming we agreed that
> SINK.COMPOSE and SOURCE.CROP are expressed in subdev's internal
> coordinate system.
> The SINK.CROP is expressed in link0's coordinate system and
> SOURCE.COMPOSE is expressed in link1's coordinate system.

Links have no coordinate system. They're just either enabled or disabled,
and only the formats at the ends of the link must match.

Externally subdevs have media bus formats in pads. Other than that,
s_selection which is to be defined, would be used to define what subdevs do
internally.

> >Definitions
> >===========
> >
> >/**
> >  * struct v4l2_subdev_selection - selection info
> >  *
> >  * @which: either V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY
> >  * @pad: pad number, as reported by the media API
> >  * @target: selection target, used to choose one of possible rectangles
> >  * @flags: constraints flags
> >  * @r: coordinates of selection window
> >  * @reserved: for future use, rounds structure size to 64 bytes, set to zero
> >  *
> >  * Hardware may use multiple helper window to process a video stream.
> >  * The structure is used to exchange this selection areas between
> >  * an application and a driver.
> >  */
> >struct v4l2_subdev_selection {
> >	__u32 which;
> >	__u32 pad;
> >	__u32 target;
> >	__u32 flags;
> >	struct v4l2_rect r;
> >	__u32 reserved[8];
> >};
> >
> >Both SUBDEV_S_SELECTION and SUBDEV_G_SELECTION would take struct
> >v4l2_subdev_selection as the IOCTL argument (RW).
> >
> >The same target definitions and flags apply as in [1], with possible
> >exception of the PADDED targets --- see below. The flags will gain _SUBDEV
> >prefix after the existing V4L2 prefix.
> >
> >
> >Sample use cases
> >================
> >
> >
> >OMAP 3 ISP preview
> >------------------
> >
> >The OMAP 3 ISP preview block provides cropping on preview sink pad, but also
> >horizontal averaging. The horizontal averaging may scale the image
> >horizontally by factor 1/n, where n is either 1, 2, 4 or 8.
> >
> >The preview block also performs pixel format conversion from raw bayer to
> >YUV. Other image processing operations crops maximum of 12 columns and 8 rows
> >before the format conversion. After the format conversion, further 2 columns
> >are cropped.
> >
> >To make this easy for the user, the driver assumes that all the features
> >affecting cropping are enabled at all times so the size stays constant for
> >the user.
> >
> >
> >This example only includes the preview subdev since it can be shown
> >independently. In the example, the preview subdev is configured to crop the
> >image by 100 pixels on all sides of the image. The horizontal averaging is
> >configured by factor 1/2, which translates 100 pixels from each side of the
> >original image. The preview sink pad format is 800x600 SGRBG10.
> >
> >
> >[crop] 0:preview:1 [crop (static), compose]
> >
> >	The initial state of the pipeline is:
> >
> >	preview:0	preview:1
> >compose (0,0)/788x592	(0,0)/788x592
> >crop	(7,4)/788x592	(1,0)/786x592
> >fmt	800x600/SGRBG10	786x592/YUYV
> >
> >	This is due to hardware imposed cropping performed in the sink pad
> >	as well as on the source pad.
> >
> >	To crop 100 pixels on all sides:
> >
> >	SUBDEV_S_SELECTION(preview:0, CROP_ACTIVE, (99,100)/602x400);
> >
> >	The hardware mandated crop on the sink pad is thus one pixel on left
> >	and right sides of the image. (This would also be shown in the
> >	CROP_BOUNDS target.)
> >
> >	preview:0	preview:1
> >compose (0,0)/602x400	(0,0)/602x400
> >crop	(99,100)/602x400 (1,0)/600x400
> >fmt	800x600/SGRBG10	600x400/YUYV
> >
> >
> >A sensor
> >--------
> >
> >The intent is to obtain a VGA image from a 8 MP sensor which provides
> >following pipeline:
> >
> >pixel_array:0 [crop] --->  0:binner:1 --->  [crop] 0:scaler:1 [crop]
> >
> >Binner is an entity which can perform scaling, but only in factor of 1/n,
> >where n is a positive integer. No cropping is needed. The intent is to get a
> >640x480 image from such sensor. (This doesn't involve any other
> >configuration as the image size related one.)
> >
> >	The initial state of the pipeline
> >
> >	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> >compose (0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464
> >crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464
> >fmt	3600x2464	3600x2464	3600x2464	3600x2464	3600x2464
> >
> >	This will configure the binning on the binner subdev sink pad:
> >
> >	SUBDEV_S_SELECTION(binner:0, COMPOSE_ACTIVE, (0,0)/1800x1232);
> >
> >	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> >compose (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/3600x2464	(0,0)/3600x2464
> >crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/3600x2464	(0,0)/3600x2464
> >fmt	3600x2464	3600x2464	1800x1232	3600x2464	3600x2464
> >
> >	The same format must be set on the scaler pad 0 as well. This will
> >	reset the size inside the scaler to a sane default, which is no
> >	scaling:
> >
> >	SUBDEV_S_FMT(scaler:0, 1800x1232);
> >
> >	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> >compose (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/1800x1232
> >crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/1800x1232
> >fmt	3600x2464	3600x2464	1800x1232	1800x1232	1800x1232
> 
> I assume that scaler can upscale image 1800x1232 on scaler:0 to
> 3600x2464 on pad scaler:1. Therefore the format and compose targets
> on scaler:1 should not be changed.

Open question one: do we need a flag for other than s_selection to not to
reset the following stages?

That said, we also need to define a behaviour for that: if changes must be
made e.g. to crop and compose  rectangle on both sink and source pads, then
how are they made?

> >	To perform further scaling on the scaler, the COMPOSE target is used
> >	on the scaler subdev's SOURCE pad:
> >
> >	SUBDEV_S_SELECTION(scaler:0, COMPOSE_ACTIVE, (0,0)/640x480);
> >
> >	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> >compose (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/640x480	(0,0)/640x480
> >crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/640x480
> >fmt	3600x2464	3600x2464	1800x1232	1800x1232	640x480
> >
> 
> It is possible to compose 640x480 image into 1800x1232 data stream
> produced on scaler:1. Therefore the format on scaler:1 should not be
> changed. The area outside 640x480 would left undefined or filled by
> some pattern configured using controls. This situation was the
> reason of introducing PADDED target.

Consider the same example but scaling factor larger than 1. Should there be
cropping or should the compose rectangle be changed?

Would it make sense to do as few changes as possible if the aforementioned
flag is given?

> 
> Best regards,
> Tomasz Stanislawski
> 
> >
> >The result is a 640x480 image from the scaler's output pad. The aspect ratio
> >of the resulting image is different from 4/3 since no cropping was
> >performed in this example.
> >
> >
> >Applications which do not recognise SUBDEV_S_SELECTION
> >======================================================
> >
> >The current spec [2] tells that the scaling factor is defined by using
> >SUBDEV_S_FMT in the source pad. This method would not be supported in the
> >future, possibly affecting applications which use SUBDEV_S_FMT to configure
> >the scaling factor.
> >
> >If supporting this is seen necessary, it can be implemented by e.g.
> >reverting to the old behaviour if the SOURCE crop rectangle width or height
> >is different from width and height specified in SOURCE S_FMT.
> >
> >
> >Open questions
> >==============
> >
> >1. Keep subdev configuration flag. In Cambourne meeting the case of the OMAP
> >3 ISP resizer configuration dilemma was discussed, and the proposal was to
> >add a flag to disable propagating the configuration inside a single subdev.
> >Propagating inside a single subdev is the default. Where do we need this
> >flag; is just SUBDEV_S_SELECTION enough? [0]
> >
> >2. Are PADDED targets relevant for media bus formats? [3]
> >
> >
> >References
> >==========
> >
> >[0] http://www.mail-archive.com/linux-media@vger.kernel.org/msg35361.html
> >
> >[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36206.html
> >
> >[2] http://hverkuil.home.xs4all.nl/spec/media.html#subdev
> >
> >[3] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36203.html
> >
> >
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
