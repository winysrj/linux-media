Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61535 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753234AbdA3Nf7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 08:35:59 -0500
Date: Mon, 30 Jan 2017 15:35:13 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mihail.atanassov@arm.com,
        liviu.dudau@arm.com
Subject: Re: DRM Atomic property for color-space conversion
Message-ID: <20170130133513.GO31595@intel.com>
References: <20170127172324.GB12018@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170127172324.GB12018@e106950-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 27, 2017 at 05:23:24PM +0000, Brian Starkey wrote:
> Hi,
> 
> We're looking to enable the per-plane color management hardware in
> Mali-DP with atomic properties, which has sparked some conversation
> around how to handle YCbCr formats.
> 
> As it stands today, it's assumed that a driver will implicitly "do the
> right thing" to display a YCbCr buffer.
> 
> YCbCr data often uses different gamma curves and signal ranges (e.g.
> BT.609, BT.701, BT.2020, studio range, full-range), so its desirable
> to be able to explicitly control the YCbCr to RGB conversion process
> from userspace.
> 
> We're proposing adding a "CSC" (color-space conversion) property to
> control this - primarily per-plane for framebuffer->pipeline CSC, but
> perhaps one per CRTC too for devices which have an RGB pipeline and
> want to output in YUV to the display:
> 
> Name: "CSC"
> Type: ENUM | ATOMIC;
> Enum values (representative):
> "default":
> 	Same behaviour as now. "Some kind" of YCbCr->RGB conversion
> 	for YCbCr buffers, bypass for RGB buffers
> "disable":
> 	Explicitly disable all colorspace conversion (i.e. use an
> 	identity matrix).
> "YCbCr to RGB: BT.709":
> 	Only valid for YCbCr formats. CSC in accordance with BT.709
> 	using [16..235] for (8-bit) luma values, and [16..240] for
> 	8-bit chroma values. For 10-bit formats, the range limits are
> 	multiplied by 4.
> "YCbCr to RGB: BT.709 full-swing":
> 	Only valid for YCbCr formats. CSC in accordance with BT.709,
> 	but using the full range of each channel.
> "YCbCr to RGB: Use CTM":*
> 	Only valid for YCbCr formats. Use the matrix applied via the
> 	plane's CTM property
> "RGB to RGB: Use CTM":*
> 	Only valid for RGB formats. Use the matrix applied via the
> 	plane's CTM property
> "Use CTM":*
> 	Valid for any format. Use the matrix applied via the plane's
> 	CTM property
> ... any other values for BT.601, BT.2020, RGB to YCbCr etc. etc. as
> they are required.

Having some RGB2RGB and YCBCR2RGB things in the same property seems
weird. I would just go with something very simple like:

YCBCR_TO_RGB_CSC:
* BT.601
* BT.709
* custom matrix

And trying to use the same thing for the crtc stuff is probably not
going to end well. Like Daniel said we already have the
'Broadcast RGB' property muddying the waters there, and that stuff
also ties in with what colorspace we signal to the sink via
infoframes/whatever the DP thing was called. So my gut feeling is
that trying to use the same property everywhere will just end up
messy.

-- 
Ville Syrjälä
Intel OTC
