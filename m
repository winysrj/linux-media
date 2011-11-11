Return-path: <linux-media-owner@vger.kernel.org>
Received: from nk11p99mm-asmtpout004.mac.com ([17.158.233.225]:48180 "EHLO
	nk11p99mm-asmtpout004.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974Ab1KKPEi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 10:04:38 -0500
MIME-version: 1.0
Content-type: text/plain; charset=euc-kr
Received: from [10.254.67.115] (unknown [211.234.200.137])
 by nk11p03mm-asmtp994.mac.com
 (Oracle Communications Messaging Exchange Server 7u4-22.01 64bit (built Apr 21
 2011)) with ESMTPSA id <0LUI000XR1QCED10@nk11p03mm-asmtp994.mac.com> for
 linux-media@vger.kernel.org; Fri, 11 Nov 2011 06:03:56 -0800 (PST)
References: <20111108215514.GJ22159@valkosipuli.localdomain>
In-reply-to: <20111108215514.GJ22159@valkosipuli.localdomain>
Content-transfer-encoding: 8BIT
Message-id: <1C4819B7-7230-43CB-B2BD-3B076FDA91AB@me.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"t.stanislaws@samsung.com" <t.stanislaws@samsung.com>,
	"sylvester.nawrocki@gmail.com" <sylvester.nawrocki@gmail.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"dacohen@gmail.com" <dacohen@gmail.com>,
	"andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>
From: HeungJun Kim <riverful.kim@me.com>
Subject: Re: [RFC] SUBDEV_S/G_SELECTION IOCTLs
Date: Fri, 11 Nov 2011 23:03:48 +0900
To: Sakari Ailus <sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

It looks nice trial for setting the image and stream size.

I'm curious just one thing. Does it help to use the way setting size "easily"?

The most media drivers has its own negotiation way, and at every time using such media drivers, the application developers should learn the way to be negotiated. They generally wants the size which they want, not to be negotiated. 

But, this new API looks to fix the sizes, to be able to make negotiation codes easy, "not to negotiate".

So, in such meaning, how about your thoughts? Does it help the user to handle the size more easily?

Regards,
Heungjun Kim

2011. 11. 9. 오전 6:55 Sakari Ailus <sakari.ailus@iki.fi> 작성:

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
> 
> The proposed order of the subdev configuration is as follows. Individual
> steps may be omitted since any of the steps will reset the rectangles /
> sizes for any following step.
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
> Definitions
> ===========
> 
> /**
> * struct v4l2_subdev_selection - selection info
> *
> * @which: either V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY
> * @pad: pad number, as reported by the media API
> * @target: selection target, used to choose one of possible rectangles
> * @flags: constraints flags
> * @r: coordinates of selection window
> * @reserved: for future use, rounds structure size to 64 bytes, set to zero
> *
> * Hardware may use multiple helper window to process a video stream.
> * The structure is used to exchange this selection areas between
> * an application and a driver.
> */
> struct v4l2_subdev_selection {
>    __u32 which;
>    __u32 pad;
>    __u32 target;
>    __u32 flags;
>    struct v4l2_rect r;
>    __u32 reserved[8];
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
>    The initial state of the pipeline is:
> 
>    preview:0    preview:1
> compose (0,0)/788x592    (0,0)/788x592
> crop    (7,4)/788x592    (1,0)/786x592
> fmt    800x600/SGRBG10    786x592/YUYV
> 
>    This is due to hardware imposed cropping performed in the sink pad
>    as well as on the source pad.
> 
>    To crop 100 pixels on all sides:
> 
>    SUBDEV_S_SELECTION(preview:0, CROP_ACTIVE, (99,100)/602x400);
> 
>    The hardware mandated crop on the sink pad is thus one pixel on left
>    and right sides of the image. (This would also be shown in the
>    CROP_BOUNDS target.)
> 
>    preview:0    preview:1
> compose (0,0)/602x400    (0,0)/602x400
> crop    (99,100)/602x400 (1,0)/600x400
> fmt    800x600/SGRBG10    600x400/YUYV
> 
> 
> A sensor
> --------
> 
> The intent is to obtain a VGA image from a 8 MP sensor which provides
> following pipeline:
> 
> pixel_array:0 [crop] ---> 0:binner:1 ---> [crop] 0:scaler:1 [crop]
> 
> Binner is an entity which can perform scaling, but only in factor of 1/n,
> where n is a positive integer. No cropping is needed. The intent is to get a
> 640x480 image from such sensor. (This doesn't involve any other
> configuration as the image size related one.)
> 
>    The initial state of the pipeline
> 
>    pixel_array:0    binner:0    binner:1    scaler:0    scaler:1
> compose (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/3600x2464
> crop    (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/3600x2464
> fmt    3600x2464    3600x2464    3600x2464    3600x2464    3600x2464
> 
>    This will configure the binning on the binner subdev sink pad:
> 
>    SUBDEV_S_SELECTION(binner:0, COMPOSE_ACTIVE, (0,0)/1800x1232);
> 
>    pixel_array:0    binner:0    binner:1    scaler:0    scaler:1
> compose (0,0)/3600x2464    (0,0)/1800x1232    (0,0)/1800x1232    (0,0)/3600x2464    (0,0)/3600x2464
> crop    (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/1800x1232    (0,0)/3600x2464    (0,0)/3600x2464
> fmt    3600x2464    3600x2464    1800x1232    3600x2464    3600x2464
> 
>    The same format must be set on the scaler pad 0 as well. This will
>    reset the size inside the scaler to a sane default, which is no
>    scaling:
> 
>    SUBDEV_S_FMT(scaler:0, 1800x1232);
> 
>    pixel_array:0    binner:0    binner:1    scaler:0    scaler:1
> compose (0,0)/3600x2464    (0,0)/1800x1232    (0,0)/1800x1232    (0,0)/1800x1232    (0,0)/1800x1232
> crop    (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/1800x1232    (0,0)/1800x1232    (0,0)/1800x1232
> fmt    3600x2464    3600x2464    1800x1232    1800x1232    1800x1232
> 
>    To perform further scaling on the scaler, the COMPOSE target is used
>    on the scaler subdev's SOURCE pad:
> 
>    SUBDEV_S_SELECTION(scaler:0, COMPOSE_ACTIVE, (0,0)/640x480);
> 
>    pixel_array:0    binner:0    binner:1    scaler:0    scaler:1
> compose (0,0)/3600x2464    (0,0)/1800x1232    (0,0)/1800x1232    (0,0)/640x480    (0,0)/640x480
> crop    (0,0)/3600x2464    (0,0)/3600x2464    (0,0)/1800x1232    (0,0)/1800x1232    (0,0)/640x480
> fmt    3600x2464    3600x2464    1800x1232    1800x1232    640x480
> 
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
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi    jabber/XMPP/Gmail: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
