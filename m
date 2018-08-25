Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51540 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeHYIqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Aug 2018 04:46:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvcvideo: add a D4M camera description
Date: Sat, 25 Aug 2018 08:08:57 +0300
Message-ID: <3055434.pg5Tdbnipv@avalon>
In-Reply-To: <alpine.DEB.2.20.1807311236290.2248@axis700.grange>
References: <alpine.DEB.2.20.1712231208440.21222@axis700.grange> <5991411.ejCQOIbS9u@avalon> <alpine.DEB.2.20.1807311236290.2248@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday, 3 August 2018 14:07:12 EEST Guennadi Liakhovetski wrote:
> Hi Laurent,
> 
> Thanks for the review. A general note: I think you're requesting a rather
> detailed information about many parameters. That isn't a problem by
> itself, however, it is difficult to obtain some of that information. I'll
> address whatever comments I can in an updated version, just answering some
> questions here. I directed youor questions, that I couldn't answer myself
> to respective people, but I have no idea if and when I get replies. So,
> it's up to you whether to wait for that additional information or to take
> at least what we have now.

I've replied to v2, and apart from a few minor points, I think we can apply 
the current version. There are a few small questions I would still like to 
have answers to, but if it takes to long to obtain that, let's not miss v4.20.

> On Sun, 29 Jul 2018, Laurent Pinchart wrote:
> > On Saturday, 23 December 2017 13:11:00 EEST Guennadi Liakhovetski wrote:
> >> From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> 
> >> D4M is a mobile model from the D4XX family of Intel RealSense cameras.
> >> This patch adds a descriptor for it, which enables reading per-frame
> >> metadata from it.
> >> 
> >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> ---
> >> 
> >>  Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst | 202 ++++++++++++++++
> >>  drivers/media/usb/uvc/uvc_driver.c                |  11 ++
> >>  include/uapi/linux/videodev2.h                    |   1 +
> >>  3 files changed, 214 insertions(+)
> >>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> >> 
> >> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> >> b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst new file mode 100644
> >> index 0000000..950780d
> >> --- /dev/null
> >> +++ b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst

[snip]

> >> +    * - :cspan:`1` *Configuration*
> >> +    * - __u32 ID
> >> +      - 0x80000002
> >> +    * - __u32 Size
> >> +      - Size in bytes (currently 40)
> >> +    * - __u32 Version
> >> +      - Version of the struct
> >> +    * - __u32 Flags
> >> +      - A bitmask of flags: see [4_] below
> >> +    * - __u8 Hardware type
> >> +      - Camera hardware version [5_]
> >> +    * - __u8 SKU ID
> >> +      - Camera hardware configuration [6_]
> >> +    * - __u32 Cookie
> >> +      - Internal synchronisation
> > 
> > Internal synchronisation with what ? :-)

This is still something I'd like to understand (and I understand it may still 
take time to receive an answer from the right person).

> >> +    * - __u16 Format
> >> +      - Image format code [7_]
> >> +    * - __u16 Width
> >> +      - Width in pixels
> >> +    * - __u16 Height
> >> +      - Height in pixels
> >> +    * - __u16 Framerate
> >> +      - Requested framerate
> > 
> > What's the unit of this value ?
> 
> Is anything other than frames per second used in V4L?

V4L2 expresses the frame rate as a fraction, hence my question, to know 
whether this field contained the number of frames per second as an integer, or 
used a different representation (such as a fixed point decimal value for 
instance).

> >> +    * - __u16 Trigger
> >> +      - Byte 0: bit 0:  depth and RGB are synchronised, bit 1: external
> >> trigger
> >> +
> >> +.. _1:
> >> +
> >> +[1]
> >> https://docs.microsoft.com/en-us/windows-hardware/drivers/stream/uvc-ext
> >> ensions-1-5
> > 
> > Should we at some point replicate that documentation in the V4L2 spec ?
> > Without copying it of course, as that would be a copyright violation.
> 
> Well, we don't replicate the UVC itself or any other standards, do we? Of
> course, that document doesn't have the same status as an official
> vendor-neutral standard, but still, we don't replicate data sheets either.
> Besides, I think there are cameras that use this, and windows supports
> this, so, don't think it will disappear overnight...

Probably not overnight, you're right. I'm a bit worried about the link 
becoming invalid though. In any case that's not a blocker, but I might at some 
point decide to replicate the documentation.

[snip]

-- 
Regards,

Laurent Pinchart
