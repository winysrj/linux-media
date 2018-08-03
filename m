Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:34517 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbeHCNDF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 09:03:05 -0400
Date: Fri, 3 Aug 2018 13:07:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvcvideo: add a D4M camera description
In-Reply-To: <5991411.ejCQOIbS9u@avalon>
Message-ID: <alpine.DEB.2.20.1807311236290.2248@axis700.grange>
References: <alpine.DEB.2.20.1712231208440.21222@axis700.grange> <5991411.ejCQOIbS9u@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review. A general note: I think you're requesting a rather 
detailed information about many parameters. That isn't a problem by 
itself, however, it is difficult to obtain some of that information. I'll 
address whatever comments I can in an updated version, just answering some 
questions here. I directed youor questions, that I couldn't answer myself 
to respective people, but I have no idea if and when I get replies. So, 
it's up to you whether to wait for that additional information or to take 
at least what we have now.

On Sun, 29 Jul 2018, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> On Saturday, 23 December 2017 13:11:00 EEST Guennadi Liakhovetski wrote:
> > From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > 
> > D4M is a mobile model from the D4XX family of Intel RealSense cameras.
> > This patch adds a descriptor for it, which enables reading per-frame
> > metadata from it.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> >  Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst | 202 +++++++++++++++++++
> >  drivers/media/usb/uvc/uvc_driver.c                |  11 ++
> >  include/uapi/linux/videodev2.h                    |   1 +
> >  3 files changed, 214 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> > 
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> > b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst new file mode 100644
> > index 0000000..950780d
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> > @@ -0,0 +1,202 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _v4l2-meta-fmt-d4xx:
> > +
> > +*******************************
> > +V4L2_META_FMT_D4XX ('D4XX')
> > +*******************************
> > +
> > +D4XX Metadata
> 
> How about "Intel D4xx UVC Cameras Metadata" ?
> 
> > +
> > +
> > +Description
> > +===========
> > +
> > +D4XX (D435 and other) cameras include per-frame metadata in their UVC
> > payload
> 
> Should this be "Intel D4XX" ?
> 
> > +headers, following the Microsoft(R) UVC extension proposal [1_]. That
> > means,
> > +that the private D4XX metadata, following the standard UVC header, is
> > organised
> > +in blocks. D4XX cameras implement several standard block types, proposed by
> > +Microsoft, and several proprietary ones. Supported standard metadata types
> > +include MetadataId_CaptureStats (ID 3), MetadataId_CameraExtrinsics (ID 4),
> > and
> > +MetadataId_CameraIntrinsics (ID 5). For their description see [1_].
> 
> Does "including" mean that the list isn't exhaustive and that other standard 
> types could be returned too ? If so, would it be possible to get an exhaustive 
> list ? And if the list is exhaustive, could you word this paragraph to make 
> that clear ?
> 
> > This
> > +document describes proprietary metadata types, used by DS4XX cameras.
> 
> Is it D4XX or DS4XX ?
> 
> > +V4L2_META_FMT_D4XX buffers follow the metadata buffer layout of
> > +V4L2_META_FMT_UVC with the only difference, that it also includes
> > proprietary
> > +payload header data. D4XX cameras use bulk transfers and only send one
> > payload
> > +per frame, therefore their headers cannot be larger than 255 bytes.
> > +
> > +Below are proprietary Microsoft style metadata types, used by D4XX cameras,
> > +where all fields are in little endian order:
> > +
> > +.. flat-table:: D4XX metadata
> > +    :widths: 1 4
> > +    :header-rows:  1
> > +    :stub-columns: 0
> > +
> > +    * - Field
> > +      - Description
> > +    * - :cspan:`1` *Depth Control*
> > +    * - __u32 ID
> > +      - 0x80000000
> > +    * - __u32 Size
> > +      - Size in bytes (currently 56)
> > +    * - __u32 Version
> > +      - Version of the struct
> 
> What is this field used for ?

For future changes to this (and all other) struct(s). If in the future a 
new field is added to this struct, the version will be incremented to 
inform the user.

> > +    * - __u32 Flags
> > +      - A bitmask of flags: see [2_] below
> > +    * - __u32 Gain
> > +      - Manual gain value
> 
> What is the gain unit ?

It's in internal units. I guess librealsense has formulas to convert them 
to ISO or something else standard. It's the same units as the 
V4L2_CID_GAIN control.

> > +    * - __u32 Exposure
> > +      - Manual exposure time in microseconds
> 
> When auto-exposure is enabled, does this reflect the actual exposure time used 
> to capture the image ? If so I'd name the field just "exposure time", and 
> expand the document to explain this. Maybe something like
> 
> "Exposure time (in microseconds) that was used to capture the frame."
> 
> It would also be useful to explain what happens when auto-exposure is 
> disabled.
> 
> This comment applies to the gain as well.
> 
> > +    * - __u32 Laser power
> > +      - Power of the laser LED 0-360, used for depth measurement
> > +    * - __u32 AE mode
> > +      - 0: manual; 1: automatic exposure
> > +    * - __u32 Exposure priority
> > +      - Exposure priority value: 0 - constant frameerate
> 
> s/frameerate/frame rate/
> 
> No other value than 0 is valid ?

So far - no

> 
> > +    * - __u32 AE ROI left
> > +      - Left border of the AE Region of Interest
> > +    * - __u32 AE ROI right
> > +      - Right border of the AE Region of Interest
> > +    * - __u32 AE ROI top
> > +      - Top border of the AE Region of Interest
> > +    * - __u32 AE ROI bottom
> > +      - Bottom border of the AE Region of Interest
> 
> What are the units and range for those fields ?

Pixels, between 0 and max width or height.

> > +    * - __u32 Preset
> > +      - Preset selector value
> 
> Could you elaborate a bit on what the preset selector value is ?

Some cameras can have certain fixed configurations. In those cases it is 
possible to select one of them, using an XU control, which then will be 
reflected here.

> > +    * - __u32 Laser mode
> > +      - 0: off, 1: on
> > +    * - :cspan:`1` *Capture Timing*
> > +    * - __u32 ID
> > +      - 0x80000001
> > +    * - __u32 Size
> > +      - Size in bytes (currently 40)
> > +    * - __u32 Version
> > +      - Version of the struct
> > +    * - __u32 Flags
> > +      - A bitmask of flags: see [3_] below
> > +    * - __u32 Frame counter
> > +      - Monotonically increasing counter
> 
> That's interesting. Does it increase by exactly one for every frame ? I think 
> it would be useful to document that.
> 
> > +    * - __u32 Optical time
> > +      - Time in microseconds from the beginning of a frame till its middle
> 
> That's interesting too. Just for my information, is that exactly half the time 
> between the beginning of a frame and its end, or can exposure vary through the 
> frame ?
> 
> > +    * - __u32 Readout time
> > +      - Time, used to read out a frame in microseconds
> > +    * - __u32 Exposure time
> > +      - Frame exposure time in microseconds
> 
> Is that the same as the above manual exposure time ? Or does the first one 
> apply to the depth image only ? It would be useful to document that.
> 
> > +    * - __u32 Frame interval
> > +      - In microseconds = 1000000 / framerate
> > +    * - __u32 Pipe latency
> > +      - Time in microseconds from start of frame to data in USB buffer
> > +    * - :cspan:`1` *Configuration*
> > +    * - __u32 ID
> > +      - 0x80000002
> > +    * - __u32 Size
> > +      - Size in bytes (currently 40)
> > +    * - __u32 Version
> > +      - Version of the struct
> > +    * - __u32 Flags
> > +      - A bitmask of flags: see [4_] below
> > +    * - __u8 Hardware type
> > +      - Camera hardware version [5_]
> > +    * - __u8 SKU ID
> > +      - Camera hardware configuration [6_]
> > +    * - __u32 Cookie
> > +      - Internal synchronisation
> 
> Internal synchronisation with what ? :-)
> 
> > +    * - __u16 Format
> > +      - Image format code [7_]
> > +    * - __u16 Width
> > +      - Width in pixels
> > +    * - __u16 Height
> > +      - Height in pixels
> > +    * - __u16 Framerate
> > +      - Requested framerate
> 
> What's the unit of this value ?

Is anything other than frames per second used in V4L?

> > +    * - __u16 Trigger
> > +      - Byte 0: bit 0:  depth and RGB are synchronised, bit 1: external
> > trigger
> > +
> > +.. _1:
> > +
> > +[1]
> > https://docs.microsoft.com/en-us/windows-hardware/drivers/stream/uvc-extens
> > ions-1-5
> 
> Should we at some point replicate that documentation in the V4L2 spec ? 
> Without copying it of course, as that would be a copyright violation.

Well, we don't replicate the UVC itself or any other standards, do we? Of 
course, that document doesn't have the same status as an official 
vendor-neutral standard, but still, we don't replicate data sheets either. 
Besides, I think there are cameras that use this, and windows supports 
this, so, don't think it will disappear overnight...

> > +.. _2:
> > +
> > +[2] Depth Control flags specify, which fields are valid: ::
> 
> s/specify,/specify/ or s/ specify,/, specify/
> 
> Same comment for the other locations below.
> 
> > +
> > +  0x00000001 Gain
> > +  0x00000002 Manual exposure
> > +  0x00000004 Laser power
> > +  0x00000008 AE mode
> > +  0x00000010 Exposure priority
> > +  0x00000020 AE ROI
> > +  0x00000040 Preset
> 
> What happens to the corresponding field when a bit isn't set, will it be zero 
> ?

It will be invalid, so, I wouldn't rely on it being any specific value 
like 0 or anything else.

> > +.. _3:
> > +
> > +[3] Capture Timing flags specify, which fields are valid: ::
> > +
> > +  0x00000001 Frame counter
> > +  0x00000002 Optical time
> > +  0x00000004 Readout time
> > +  0x00000008 Exposure time
> > +  0x00000010 Frame interval
> > +  0x00000020 Pipe latency
> > +
> > +.. _4:
> > +
> > +[4] Configuration flags specify, which fields are valid: ::
> > +
> > +  0x00000001 Hardware type
> > +  0x00000002 SKU ID
> > +  0x00000004 Cookie
> > +  0x00000008 Format
> > +  0x00000010 Width
> > +  0x00000020 Height
> > +  0x00000040 Framerate
> > +  0x00000080 Trigger
> > +  0x00000100 Cal count
> > +
> > +.. _5:
> > +
> > +[5] Camera model: ::
> > +
> > +  0 DS5
> > +  1 IVCAM2
> > +
> > +.. _6:
> > +
> > +[6] 8-bit camera hardware configuration bitfield: ::
> > +
> > +  [1:0] depthCamera
> > +	00: no depth
> > +	01: standard depth
> > +	10: wide depth
> > +	11: reserved
> > +  [2]   depthIsActive - has a laser projector
> > +  [3]   RGB presence
> > +  [4]   IMU presence
> 
> What does IMU mean ?

https://en.wikipedia.org/wiki/Inertial_measurement_unit - it's a common 
abbreviation.

> 
> > +  [5]   projectorType
> > +	0: HPTG
> > +	1: Princeton
> 
> What does this mean ?
> 
> > +  [6]   0: a projector, 1: an LED
> 
> This would also benefit from a bit more explanation.
> 
> > +  [7]   reserved
> > +
> > +.. _7:
> > +
> > +[7] Image format codes per camera interface:
> > +
> > +Depth: ::
> > +
> > +  1 Z16
> > +  2 Z
> > +
> > +Left sensor: ::
> > +
> > +  1 Y8
> > +  2 UYVY
> > +  3 R8L8
> > +  4 Calibration
> > +  5 W10
> > +
> > +Fish Eye sensor: ::
> > +
> > +  1 RAW8
> 
> There's a single field in the above structures that references this. When 
> should it be interpreted as depth, left sensor or fish eye sensor format ?

you get a metadata node per video streaming interface. So, whatever you're 
streaming on that video node, the respective metadata is available on the 
respective metadatanode.

> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index 36061f3..30dbbbf 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -2346,6 +2346,8 @@ static int uvc_clock_param_set(const char *val, struct
> > kernel_param *kp) };
> > 
> >  #define UVC_QUIRK_INFO(q) (kernel_ulong_t)&(struct uvc_device_info){.quirks
> > = q}
> > +#define UVC_QUIRK_META(m) (kernel_ulong_t)&(struct uvc_device_info) \
> > +	{.meta_format = m}
> 
> I'd name this macro UVC_INFO_META as it doesn't define a quirk. Should we also 
> rename UVC_QUIRK_INFO to UVC_INFO_QUIRK ?
> 
> >  /*
> >   * The Logitech cameras listed below have their interface class set to
> > @@ -2810,6 +2812,15 @@ static int uvc_clock_param_set(const char *val,
> > struct kernel_param *kp)
> >  	  .bInterfaceSubClass	= 1,
> >  	  .bInterfaceProtocol	= 0,
> >  	  .driver_info		= (kernel_ulong_t)&uvc_quirk_force_y8 },
> > +	/* Intel RealSense D4M */
> > +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> > +				| USB_DEVICE_ID_MATCH_INT_INFO,
> > +	  .idVendor		= 0x8086,
> > +	  .idProduct		= 0x0b03,
> > +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> > +	  .bInterfaceSubClass	= 1,
> > +	  .bInterfaceProtocol	= 0,
> > +	  .driver_info		= UVC_QUIRK_META(V4L2_META_FMT_D4XX) },
> >  	/* Generic USB Video Class */
> >  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
> >  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 0d07b2d..7d3fbc6 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -688,6 +688,7 @@ struct v4l2_pix_format {
> >  #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car
> > VSP1 1-D Histogram */
> >  #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car
> > VSP1 2-D Histogram */
> >  #define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC
> > Payload Header metadata */
> > +#define V4L2_META_FMT_D4XX        v4l2_fourcc('D', '4', 'X', 'X') /* D4XX
> > Payload Header metadata */
> > 
> >  /* priv field value to indicates that subsequent fields are valid. */
> >  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe

Thanks
Guennadi

> -- 
> Regards,
> 
> Laurent Pinchart
