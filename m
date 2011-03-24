Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48174 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1CXLFA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 07:05:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Robert Fekete <robert.fekete@linaro.org>
Subject: Re: Future desktop on dumb frame buffers?
Date: Thu, 24 Mar 2011 12:05:02 +0100
Cc: Alex Deucher <alexdeucher@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	dri-devel@lists.freedesktop.org,
	timofonic timofonic <timofonic@gmail.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	wayland-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org
References: <AANLkTimJWpebAskcjA+qQUDWXjiH6aHta4fri9z6OxRN@mail.gmail.com> <AANLkTimqkA7GGdT52Ys0b+346Pxr3A=PtDpY0nJ+ycVO@mail.gmail.com> <AANLkTi=fWKt=v5O9A7XivDiFaJyki6H90k1=Jfcmw2dN@mail.gmail.com>
In-Reply-To: <AANLkTi=fWKt=v5O9A7XivDiFaJyki6H90k1=Jfcmw2dN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103241205.02640.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 23 March 2011 15:09:54 Robert Fekete wrote:
> On 21 March 2011 21:08, Alex Deucher <alexdeucher@gmail.com> wrote:
> > On Mon, Mar 21, 2011 at 3:50 PM, Geert Uytterhoeven wrote:
> >> On Mon, Mar 21, 2011 at 20:25, Jesse Barnes wrote:
> >>> On Mon, 21 Mar 2011 19:19:43 +0000 timofonic timofonic wrote:
> >>>> So if KMS is so cool and provides many advantages over fbdev and
> >>>> such... Why isn't more widely used intead of still relying on fbdev?
> >>>> Why still using fbdev emulation (that is partial and somewhat broken,
> >>>> it seems) instead using KMS directly?
> >>> 
> >>> Used by what?  All three major GPU device classes have KMS support
> >>> (Intel, ATI, and nVidia).  If you want it for a particular device, you
> >>> can always port it over.
> >> 
> >> The three major GPU device classes on PC...
> > 
> > Sadly it gets worse.  A lot of the SoC vendors are adding an fbdev
> > emulation layer on top of v4l rather than using fbdev directly or
> > using KMS and v4l has grown it's own edid, hdmi, and cec handling.

We're also evaluating the possibility of providing a generic fbdev emulation 
layer on top of V4L2 without requiring any device-specific fbdev code. fbdev 
isn't maintained and hasn't really evolved for quite some time now.

> I agree, it is sad that as a SoC vendor there are different
> kernel/user API's(v4l2/fbdev/drm) to choose from when implementing say
> a Display controller driver. One must also remember that there are big
> differences between a desktop/PC multimedia/graphics system and the
> ones present on an embedded SoC. It is two very different cultures and
> HW designs now trying to merge into one Linux Kernel. Of course there
> will be some overlaps but I believe it can be sorted out as soon as we
> understand each others different possibilities/limitations. Doing
> duplicate work like HDMI will not benefit any party.
> 
> Just to list some of the differences.
> 
> - Developments within V4L2 has mainly been driven by embedded devices
> while DRM is a result of desktop Graphics cards. And for some extent
> also solving different problems.
> - Embedded devices usually have several different hw IP's managing
> displays, hdmi, camera/ISP, video codecs(h264 accellerators), DSP's,
> 2D blitters, Open GL ES hw, all of which have a separate device/driver
> in the kernel, while on a desktop nowadays all this functionality
> usually resides on ONE graphics card, hence one DRM device for all.
> - DRM is closely developed in conjunction with desktop/Xorg, while X11
> on an embedded device is not very 2011...wayland on the other hand is
> 
> :-), but do wayland really need the full potential of DRM/DRI or just
> 
> parts of it.
> - Copying buffers is really bad for embedded devices due to lower
> memory bandwidth and power consumption while on a Desktop memory
> bandwidth is from an other galaxy (copying still bad but accepted it
> seems), AND embedded devices of today records and plays/displays 1080p
> content as well.
> - Not all embedded devices have MMU's for each IP requiring physical
> contiguous memory, while on a desktop MMU's have been present for
> ages.
> - Embedded devices are usually ARM based SoCs while x86 dominates the
> Desktop/Laptop market, and functionality provided is soon the very
> same.
> - yada yada....The list can grow very long....There are also
> similarities of course.
> 
> The outcome is that SoC vendors likes the embedded friendliness of
> v4l2 and fbdev while "we" also glance at the DRM part due to its
> de-facto standard on desktop environments. But from an embedded point
> of view DRM lacks the support for interconnecting multiple
> devices/drivers mentioned above, GEM/TTM is valid within a DRM device,
> the execution/context management is not needed,, no overlays(or
> similar), the coupling to DRI/X11 not wanted. SoCs like KMS/GEM but
> the rest of DRM will likely not be heavily used on SoCs unless running
> X11 as well. Most likely this worked on as well within the DRI
> community. I can see good features all over the place(sometimes
> duplicated) but not find one single guideline/API that solves all the
> embedded SoC problems (which involves use-cases optimized for no-copy
> cross media/drivers).
> 
> Last but not least...
> 
> On Linaro there is already discussions ongoing to solve one of the
> biggest issues from a SoC point of view and that is a "System Wide
> Memory manager" which manages buffer sharing and resolves no-copy use
> cases between devices/drivers. Read more on the following thread:
> http://lists.linaro.org/pipermail/linaro-dev/2011-March/003053.html.

-- 
Regards,

Laurent Pinchart
