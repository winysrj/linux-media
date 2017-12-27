Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39234 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751187AbdL0SXx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Dec 2017 13:23:53 -0500
Date: Wed, 27 Dec 2017 20:23:49 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] uvcvideo: add a D4M camera description
Message-ID: <20171227182349.qeik22bnuwbsahtv@valkosipuli.retiisi.org.uk>
References: <alpine.DEB.2.20.1712231208440.21222@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1712231208440.21222@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch!

On Sat, Dec 23, 2017 at 12:11:00PM +0100, Guennadi Liakhovetski wrote:
> From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> 
> D4M is a mobile model from the D4XX family of Intel RealSense cameras.
> This patch adds a descriptor for it, which enables reading per-frame
> metadata from it.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
>  Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst | 202 ++++++++++++++++++++++
>  drivers/media/usb/uvc/uvc_driver.c                |  11 ++
>  include/uapi/linux/videodev2.h                    |   1 +
>  3 files changed, 214 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> new file mode 100644
> index 0000000..950780d
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> @@ -0,0 +1,202 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _v4l2-meta-fmt-d4xx:
> +
> +*******************************
> +V4L2_META_FMT_D4XX ('D4XX')
> +*******************************
> +
> +D4XX Metadata
> +
> +
> +Description
> +===========
> +
> +D4XX (D435 and other) cameras include per-frame metadata in their UVC payload

If this is D435 and some others, I'd simply call this D435. Say, if you get
another device in D4xx series that implements a different format, how do
you call that? Up to you.

Is there a specific list of devices that use this format? The driver patch
only appears to introduce one USB ID.

> +headers, following the Microsoft(R) UVC extension proposal [1_]. That means,
> +that the private D4XX metadata, following the standard UVC header, is organised
> +in blocks. D4XX cameras implement several standard block types, proposed by
> +Microsoft, and several proprietary ones. Supported standard metadata types
> +include MetadataId_CaptureStats (ID 3), MetadataId_CameraExtrinsics (ID 4), and
> +MetadataId_CameraIntrinsics (ID 5). For their description see [1_]. This
> +document describes proprietary metadata types, used by DS4XX cameras.
> +
> +V4L2_META_FMT_D4XX buffers follow the metadata buffer layout of
> +V4L2_META_FMT_UVC with the only difference, that it also includes proprietary
> +payload header data. D4XX cameras use bulk transfers and only send one payload
> +per frame, therefore their headers cannot be larger than 255 bytes.
> +
> +Below are proprietary Microsoft style metadata types, used by D4XX cameras,
> +where all fields are in little endian order:
> +
> +.. flat-table:: D4XX metadata
> +    :widths: 1 4
> +    :header-rows:  1
> +    :stub-columns: 0
> +
> +    * - Field
> +      - Description
> +    * - :cspan:`1` *Depth Control*
> +    * - __u32 ID
> +      - 0x80000000
> +    * - __u32 Size
> +      - Size in bytes (currently 56)
> +    * - __u32 Version
> +      - Version of the struct
> +    * - __u32 Flags
> +      - A bitmask of flags: see [2_] below
> +    * - __u32 Gain
> +      - Manual gain value
> +    * - __u32 Exposure
> +      - Manual exposure time in microseconds
> +    * - __u32 Laser power
> +      - Power of the laser LED 0-360, used for depth measurement
> +    * - __u32 AE mode
> +      - 0: manual; 1: automatic exposure
> +    * - __u32 Exposure priority
> +      - Exposure priority value: 0 - constant frameerate
> +    * - __u32 AE ROI left
> +      - Left border of the AE Region of Interest
> +    * - __u32 AE ROI right
> +      - Right border of the AE Region of Interest
> +    * - __u32 AE ROI top
> +      - Top border of the AE Region of Interest
> +    * - __u32 AE ROI bottom
> +      - Bottom border of the AE Region of Interest
> +    * - __u32 Preset
> +      - Preset selector value
> +    * - __u32 Laser mode
> +      - 0: off, 1: on
> +    * - :cspan:`1` *Capture Timing*
> +    * - __u32 ID
> +      - 0x80000001
> +    * - __u32 Size
> +      - Size in bytes (currently 40)
> +    * - __u32 Version
> +      - Version of the struct
> +    * - __u32 Flags
> +      - A bitmask of flags: see [3_] below
> +    * - __u32 Frame counter
> +      - Monotonically increasing counter
> +    * - __u32 Optical time
> +      - Time in microseconds from the beginning of a frame till its middle
> +    * - __u32 Readout time
> +      - Time, used to read out a frame in microseconds
> +    * - __u32 Exposure time
> +      - Frame exposure time in microseconds
> +    * - __u32 Frame interval
> +      - In microseconds = 1000000 / framerate
> +    * - __u32 Pipe latency
> +      - Time in microseconds from start of frame to data in USB buffer
> +    * - :cspan:`1` *Configuration*
> +    * - __u32 ID
> +      - 0x80000002
> +    * - __u32 Size
> +      - Size in bytes (currently 40)
> +    * - __u32 Version
> +      - Version of the struct
> +    * - __u32 Flags
> +      - A bitmask of flags: see [4_] below
> +    * - __u8 Hardware type
> +      - Camera hardware version [5_]
> +    * - __u8 SKU ID
> +      - Camera hardware configuration [6_]
> +    * - __u32 Cookie
> +      - Internal synchronisation
> +    * - __u16 Format
> +      - Image format code [7_]
> +    * - __u16 Width
> +      - Width in pixels
> +    * - __u16 Height
> +      - Height in pixels
> +    * - __u16 Framerate
> +      - Requested framerate
> +    * - __u16 Trigger
> +      - Byte 0: bit 0:  depth and RGB are synchronised, bit 1: external trigger
> +
> +.. _1:
> +
> +[1] https://docs.microsoft.com/en-us/windows-hardware/drivers/stream/uvc-extensions-1-5
> +
> +.. _2:
> +
> +[2] Depth Control flags specify, which fields are valid: ::
> +
> +  0x00000001 Gain
> +  0x00000002 Manual exposure
> +  0x00000004 Laser power
> +  0x00000008 AE mode
> +  0x00000010 Exposure priority
> +  0x00000020 AE ROI
> +  0x00000040 Preset
> +
> +.. _3:
> +
> +[3] Capture Timing flags specify, which fields are valid: ::
> +
> +  0x00000001 Frame counter
> +  0x00000002 Optical time
> +  0x00000004 Readout time
> +  0x00000008 Exposure time
> +  0x00000010 Frame interval
> +  0x00000020 Pipe latency
> +
> +.. _4:
> +
> +[4] Configuration flags specify, which fields are valid: ::
> +
> +  0x00000001 Hardware type
> +  0x00000002 SKU ID
> +  0x00000004 Cookie
> +  0x00000008 Format
> +  0x00000010 Width
> +  0x00000020 Height
> +  0x00000040 Framerate
> +  0x00000080 Trigger
> +  0x00000100 Cal count
> +
> +.. _5:
> +
> +[5] Camera model: ::
> +
> +  0 DS5
> +  1 IVCAM2
> +
> +.. _6:
> +
> +[6] 8-bit camera hardware configuration bitfield: ::
> +
> +  [1:0] depthCamera
> +	00: no depth
> +	01: standard depth
> +	10: wide depth
> +	11: reserved
> +  [2]   depthIsActive - has a laser projector
> +  [3]   RGB presence
> +  [4]   IMU presence
> +  [5]   projectorType
> +	0: HPTG
> +	1: Princeton
> +  [6]   0: a projector, 1: an LED
> +  [7]   reserved
> +
> +.. _7:
> +
> +[7] Image format codes per camera interface:
> +
> +Depth: ::
> +
> +  1 Z16
> +  2 Z
> +
> +Left sensor: ::
> +
> +  1 Y8
> +  2 UYVY
> +  3 R8L8
> +  4 Calibration
> +  5 W10
> +
> +Fish Eye sensor: ::
> +
> +  1 RAW8
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 36061f3..30dbbbf 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2346,6 +2346,8 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
>  };
>  
>  #define UVC_QUIRK_INFO(q) (kernel_ulong_t)&(struct uvc_device_info){.quirks = q}
> +#define UVC_QUIRK_META(m) (kernel_ulong_t)&(struct uvc_device_info) \
> +	{.meta_format = m}
>  
>  /*
>   * The Logitech cameras listed below have their interface class set to
> @@ -2810,6 +2812,15 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info		= (kernel_ulong_t)&uvc_quirk_force_y8 },
> +	/* Intel RealSense D4M */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x8086,
> +	  .idProduct		= 0x0b03,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0,
> +	  .driver_info		= UVC_QUIRK_META(V4L2_META_FMT_D4XX) },
>  	/* Generic USB Video Class */
>  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
>  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 0d07b2d..7d3fbc6 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -688,6 +688,7 @@ struct v4l2_pix_format {
>  #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 1-D Histogram */
>  #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */
>  #define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
> +#define V4L2_META_FMT_D4XX        v4l2_fourcc('D', '4', 'X', 'X') /* D4XX Payload Header metadata */
>  
>  /* priv field value to indicates that subsequent fields are valid. */
>  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
