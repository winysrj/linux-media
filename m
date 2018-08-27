Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:33455 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbeH0Mrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 08:47:48 -0400
Date: Mon, 27 Aug 2018 11:01:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] uvcvideo: add a D4M camera description
In-Reply-To: <1540109.86EXVmqvYh@avalon>
Message-ID: <alpine.DEB.2.20.1808270844530.4506@axis700.grange>
References: <alpine.DEB.2.20.1712231208440.21222@axis700.grange> <5991411.ejCQOIbS9u@avalon> <alpine.DEB.2.20.1808031335310.13762@axis700.grange> <1540109.86EXVmqvYh@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Sat, 25 Aug 2018, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> Overall this looks good to me, I only have small comments. Please see below, 
> with a summary at the end.
> 
> On Friday, 3 August 2018 14:37:08 EEST Guennadi Liakhovetski wrote:
> > D4M is a mobile model from the D4XX family of Intel RealSense cameras.
> > This patch adds a descriptor for it, which enables reading per-frame
> > metadata from it.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> >  Documentation/media/uapi/v4l/meta-formats.rst     |   1 +
> >  Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst | 204 +++++++++++++++++++
> >  drivers/media/usb/uvc/uvc_driver.c                |  11 ++
> >  include/uapi/linux/videodev2.h                    |   1 +
> >  4 files changed, 217 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> 
> [snip]
> 
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> > b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst new file mode 100644
> > index 0000000..57ecfd9
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> > @@ -0,0 +1,204 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _v4l2-meta-fmt-d4xx:
> > +
> > +*******************************
> > +V4L2_META_FMT_D4XX ('D4XX')
> > +*******************************
> > +
> > +Intel D4xx UVC Cameras Metadata
> > +
> > +
> > +Description
> > +===========
> > +
> > +Intel D4xx (D435 and other) cameras include per-frame metadata in their UVC
> > +payload headers, following the Microsoft(R) UVC extension proposal [1_].
> > That +means, that the private D4XX metadata, following the standard UVC
> > header, is +organised in blocks. D4XX cameras implement several standard
> > block types, +proposed by Microsoft, and several proprietary ones.
> > Supported standard metadata +types are MetadataId_CaptureStats (ID 3),
> > MetadataId_CameraExtrinsics (ID 4), +and MetadataId_CameraIntrinsics (ID
> > 5). For their description see [1_]. This +document describes proprietary
> > metadata types, used by D4xx cameras.
> > +
> > +V4L2_META_FMT_D4XX buffers follow the metadata buffer layout of
> > +V4L2_META_FMT_UVC with the only difference, that it also includes
> > proprietary +payload header data. D4xx cameras use bulk transfers and only
> > send one payload +per frame, therefore their headers cannot be larger than
> > 255 bytes.
> > +
> > +Below are proprietary Microsoft style metadata types, used by D4xx cameras,
> > +where all fields are in little endian order:
> > +
> > +.. flat-table:: D4xx metadata
> > +    :widths: 1 4
> > +    :header-rows:  1
> > +    :stub-columns: 0
> > +
> > +    * - Field
> > +      - Description
> > +    * - :cspan:`1` *Depth Control*
> 
> Does this mean that all fields in this structure apply to the depth image only 
> ? If so, do you mind if I mention that explicitly ?

I don't think that's the case. E.g. only this struct has laser parameters 
and the laser can be used without the depth node being active. In fact I 
just tried streaming from the other node and reading metadata from its 
metadata node - it also included ID 0x80000000 with flags set to 0xff, 
i.e. all fields valid.

> > +    * - __u32 ID
> > +      - 0x80000000
> > +    * - __u32 Size
> > +      - Size in bytes (currently 56)
> > +    * - __u32 Version
> > +      - Version of the struct
> 
> I would elaborate a bit here, how about the following ?
> 
> "Version of this structure. The documentation herein corresponds to version 
> xxx. The version number will be incremented when new fields are added."
> 
> If you can provide me with the current version number I can update this when 
> applying the patch (I would get it myself, but I'm about to board a plane and 
> haven't taken the camera with me :-/).

Sure, sounds good, the "depth control" is version 2, the rest is version 
1.

> > +    * - __u32 Flags
> > +      - A bitmask of flags: see [2_] below
> > +    * - __u32 Gain
> > +      - Gain value in internal units, same as the V4L2_CID_GAIN control,
> > used to
> > +        capture the frame
> > +    * - __u32 Exposure
> > +      - Exposure time (in microseconds) used to capture the frame
> > +    * - __u32 Laser power
> > +      - Power of the laser LED 0-360, used for depth measurement
> > +    * - __u32 AE mode
> > +      - 0: manual; 1: automatic exposure
> > +    * - __u32 Exposure priority
> > +      - Exposure priority value: 0 - constant frame rate
> > +    * - __u32 AE ROI left
> > +      - Left border of the AE Region of Interest (all ROI values are in
> > pixels
> > +        and lie between 0 and maximum width or height respectively)
> > +    * - __u32 AE ROI right
> > +      - Right border of the AE Region of Interest
> > +    * - __u32 AE ROI top
> > +      - Top border of the AE Region of Interest
> > +    * - __u32 AE ROI bottom
> > +      - Bottom border of the AE Region of Interest
> > +    * - __u32 Preset
> > +      - Preset selector value, default: 0, unless changed by the user
> 
> I won't block this patch for this, but could we get the documentation of the 
> corresponding XU control ? Even better, if Intel could publish documentation 
> of the full XUs, that would be great :-)

I think it's mostly up to you, if you insist, I'll ask for the information 
and tell them, that the patch won't go in without it. If you don't, it's 
the same answer I'm afraid - I asked for details and reminded about my 
query and still got no response back. The same holds for all other 
information.

> > +    * - __u32 Laser mode
> > +      - 0: off, 1: on
> > +    * - :cspan:`1` *Capture Timing*
> 
> Similarly, what does this apply to ? The left sensor, the fish eye camera, or 
> both (or something else) ?

You have a metadata node for each of those nodes, so, you just read from 
it when capturing from the respective video streaming node and use 
whatever is there.

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
> I assume this increases by exactly one for every frame. I'll test it when I 
> get back home, and will update the documentation accordingly.

I think since it's formulated as it is, they didn't want the user to rely 
on any specific increment step. And I don't think testing a couple of 
use-cases would provide a relyable answer to this...

> > +    * - __u32 Optical time
> > +      - Time in microseconds from the beginning of a frame till its middle
> 
> I'm still puzzled by this value, as I expect it to be exactly half the 
> exposure time, which is reported separately. If that's not the case I'd like 
> to know what this represents.

Sorry, I really don't know more than what's there.

> > +    * - __u32 Readout time
> > +      - Time, used to read out a frame in microseconds
> > +    * - __u32 Exposure time
> > +      - Frame exposure time in microseconds
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
> > +    * - __u16 Format
> > +      - Image format code [7_]
> > +    * - __u16 Width
> > +      - Width in pixels
> > +    * - __u16 Height
> > +      - Height in pixels
> > +    * - __u16 Framerate
> > +      - Requested frame rate per second
> > +    * - __u16 Trigger
> > +      - Byte 0: bit 0: depth and RGB are synchronised, bit 1: external
> > trigger
> > +
> > +.. _1:
> > +
> > +[1]
> > https://docs.microsoft.com/en-us/windows-hardware/drivers/stream/uvc-extens
> > ions-1-5
> > +
> > +.. _2:
> > +
> > +[2] Depth Control flags specify which fields are valid: ::
> > +
> > +  0x00000001 Gain
> > +  0x00000002 Exposure
> > +  0x00000004 Laser power
> > +  0x00000008 AE mode
> > +  0x00000010 Exposure priority
> > +  0x00000020 AE ROI
> > +  0x00000040 Preset
> > +
> > +.. _3:
> > +
> > +[3] Capture Timing flags specify which fields are valid: ::
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
> > +[4] Configuration flags specify which fields are valid: ::
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
> Do you mind if I write this "Inertial Measurement Unit (IMU) presense" ? Or is 
> it just me who's not familiar enough with depth cameras ? :-)

IMUs aren't only present in depth cameras, in fact, they are more usually 
present outside of depth cameras. E.g. in phones, drones, robots, etc. 
Everywhere where you need orientation, acceleration, and similar stuff. 
But up to you, if you think, this isn't common enough, feel free to 
explain.

> On a side note, does the camera expose IMU data to the host over USB ?

I haven't worked with such cameras, but if there's an IMU in a USB camera, 
USB is the only way to present it to the user, and yes, I think it would 
be presented to the user and not only used internally. But again, I 
haven't worked with them personally.

> > +  [5]   projectorType
> > +	0: HPTG
> > +	1: Princeton
> > +  [6]   0: a projector, 1: an LED
> > +  [7]   reserved
> > +
> > +.. _7:
> > +
> > +[7] Image format codes per camera interface:
> 
> I was initially puzzled by this until I read your explanation. How about 
> wording it as "Image format codes per video streaming interface" to use the 
> UVC vocabulary ?

Sure, sounds good!

> 
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
> If you agree with the comments above, I'll update the patch when applying it 
> to my tree. I would however still like to get the following information
> 
> - What are the version of the three structures documented in this patch ? I 
> can check that when I get back home, but if you have the information it would 
> be faster.
> 
> - Do the fields in the Depth Control structure apply to the depth video stream 
> only ? (I assume they do)
> 
> - What do the fields in the Capture Control structure apply to ? (I assume the 
> left sensor and/or fish eye video streams)
> 
> - Does the optical time differ from half the exposure time ?

All responses above.

Thanks
Guennadi

> 
> If you think it will take time to get this information and we risk missing the 
> next kernel version, I'm OK applying the patch already, but please then submit 
> a follow-up patch (or just drop a mail in reply to this one with the 
> information and I can turn that into a patch).
> 
> [snip]
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 
