Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2BQTnL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 14:43:11 -0500
Message-ID: <4F3EADAA.9090702@redhat.com>
Date: Fri, 17 Feb 2012 14:42:34 -0500
From: Adam Jackson <ajax@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC
 2012 - Notes
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <1654816.MX2JJ87BEo@avalon> <1775349.d0yvHiVdjB@avalon>
In-Reply-To: <1775349.d0yvHiVdjB@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/16/12 6:25 PM, Laurent Pinchart wrote:

> ***  Common video mode data structure and EDID parser ***
>
>    Goal: Sharing an EDID parser between DRM/KMS, FBDEV and V4L2.
>
>    The DRM EDID parser is currently the most advanced implementation and will
>    be taken as a starting point.
>
>    Different subsystems use different data structures to describe video
>    mode/timing information:
>
>    - struct drm_mode_modeinfo in DRM/KMS
>    - struct fb_videomode in FBDEV
>    - struct v4l2_bt_timings in V4L2
>
>    A new common video mode/timing data structure (struct media_video_mode_info,
>    exact name is to be defined), not tied to any specific subsystem, is
>    required to share the EDID parser. That structure won't be exported to
>    userspace.
>
>    Helper functions will be implemented in the subsystems to convert between
>    that generic structure and the various subsystem-specific structures.

I guess.  I don't really see a reason not to unify the structs too, but 
then I don't have binary blobs to pretend to be ABI-compatible with.

>    The mode list is stored in the DRM connector in the EDID parser. A new mode
>    list data structure can be added, or a callback function can be used by the
>    parser to give modes one at a time to the caller.
>
>    3D needs to be taken into account (this is similar to interlacing).

Would also be pleasant if the new mode structure had a reasonable way of 
representing borders, we copied that mistake from xserver and have been 
regretting it.

>    Action points:
>    - Laurent to work on a proposal. The DRM/KMS EDID parser will be reused.

I'm totally in favor of this.  I've long loathed fbdev having such a 
broken parser, I just never got around to fixing it since we don't use 
fbdev in any real way.

The existing drm_edid.c needs a little detangling, DDC fetch and EDID 
parse should be better split.  Shouldn't be too terrible though.

Has the embedded world seen any adoption of DisplayID?  I wrote a fair 
bit of a parser for it at one point [1] but I've yet to find a machine 
that's required it.

> ***  Split KMS and GPU Drivers ***
>
>    Goal: Split KMS and GPU drivers with in kernel API inbetween.
>
>    In most (all ?) SoCs, the GPU and the display controller are separate
>    devices. Splitting them into separate drivers would allow reusing the GPU
>    driver with different devices (e.g. using a single common PowerVR kernel
>    module with different display controller drivers). The same approach can be
>    used on the desktop for the multi-GPU case and the USB display case.
>
>    - OMAP already separates the GPU and DSS drivers, but the GPU driver is some
>    kind of DSS plugin. This isn't a long-term approach.
>    - Exynos also separates the GPU and FIMD drivers. It's hard to merge GPU
>    into  display subsystem since UMP, GPU has own memory management codes.
>
>    One of the biggest challenges would be to get GPU vendors to use this new
>    model. ARM could help here, by making the Mali kernel driver split from the
>    display controller drivers. Once one vendor jumps onboard, others could have
>    a bigger incentive to follow.

Honestly I want this for Intel already, given how identical Poulsbo's 
display block is to gen3.

> ***  HDMI CEC Support ***
>
>    Goal: Support HDMI CEC and offer a userspace API for applications.
>
>    A new kernel API is needed and must be usable by KMS, V4L2 and possibly
>    LIRC. There's ongoing effort from Cisco to implement HDMI CEC support. Given
>    their background, V4L2 is their initial target. A proposal is available at
>    http://www.mail-archive.com/linux-media@vger.kernel.org/msg29241.html with a
>    sample implementation at
>    http://git.linuxtv.org/hverkuil/cisco.git/shortlog/refs/heads/cobalt-
> mainline
>    (drivers/media/video/adv7604.c and ad9389b.c.
>
>    In order to avoid API duplication, a new CEC subsystem is probably needed.
>    CEC could be modeled as a bus, or as a network device. With the network
>    device approach, we could have both kernel and userspace protocol handlers.

I'm not a huge fan of userspace protocol for this.  Seems like it'd just 
give people more license to do their own subtly-incompatible things that 
only work between devices of the same vendor.  Interoperability is the 
_whole_ point of CEC.  (Yes I know every vendor tries to spin it as 
their own magical branded thing, but I'd appreciate it if they grew up.)

[1] - 
http://cgit.freedesktop.org/xorg/xserver/tree/hw/xfree86/modes/xf86DisplayIDModes.c

- ajax
