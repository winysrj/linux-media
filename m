Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:60934 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933651AbdA0Rdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 12:33:35 -0500
Date: Fri, 27 Jan 2017 17:23:24 +0000
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ville.syrjala@linux.intel.com, mihail.atanassov@arm.com,
        liviu.dudau@arm.com
Subject: DRM Atomic property for color-space conversion
Message-ID: <20170127172324.GB12018@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

We're looking to enable the per-plane color management hardware in
Mali-DP with atomic properties, which has sparked some conversation
around how to handle YCbCr formats.

As it stands today, it's assumed that a driver will implicitly "do the
right thing" to display a YCbCr buffer.

YCbCr data often uses different gamma curves and signal ranges (e.g.
BT.609, BT.701, BT.2020, studio range, full-range), so its desirable
to be able to explicitly control the YCbCr to RGB conversion process
from userspace.

We're proposing adding a "CSC" (color-space conversion) property to
control this - primarily per-plane for framebuffer->pipeline CSC, but
perhaps one per CRTC too for devices which have an RGB pipeline and
want to output in YUV to the display:

Name: "CSC"
Type: ENUM | ATOMIC;
Enum values (representative):
"default":
	Same behaviour as now. "Some kind" of YCbCr->RGB conversion
	for YCbCr buffers, bypass for RGB buffers
"disable":
	Explicitly disable all colorspace conversion (i.e. use an
	identity matrix).
"YCbCr to RGB: BT.709":
	Only valid for YCbCr formats. CSC in accordance with BT.709
	using [16..235] for (8-bit) luma values, and [16..240] for
	8-bit chroma values. For 10-bit formats, the range limits are
	multiplied by 4.
"YCbCr to RGB: BT.709 full-swing":
	Only valid for YCbCr formats. CSC in accordance with BT.709,
	but using the full range of each channel.
"YCbCr to RGB: Use CTM":*
	Only valid for YCbCr formats. Use the matrix applied via the
	plane's CTM property
"RGB to RGB: Use CTM":*
	Only valid for RGB formats. Use the matrix applied via the
	plane's CTM property
"Use CTM":*
	Valid for any format. Use the matrix applied via the plane's
	CTM property
... any other values for BT.601, BT.2020, RGB to YCbCr etc. etc. as
they are required.

*This assumes color-management is enabled per-plane. We're currently
working on patches to add this mostly to be able to use per-plane
degamma, but it would be analogous to the CRTC color-management code
and so also be able to expose a per-plane CTM property.

Our hardware implements the color-space conversion as a 3x3 matrix, so
we can implement a helper to convert a CSC enum value to a CTM matrix
for use by any hardware which has a programmable CSC matrix. For any
other hardware, the driver simply needs to map the enum value to
whatever selector bits are available.

It's expected that the "Use CTM" value(s) are *not* the common case,
and most of the time userspace will use one of the provided "standard"
enum values. The three different flavours of "Use CTM" allow us to
support hardware whose CSC hardware can only be used on e.g. YCbCr
data.

Drivers can of course filter the enum list to expose whichever subset
the hardware can support.

Having thrashed this out a bit on IRC with Ville, I think the above
approach is flexible enough to support at least Mali-DP and i915,
without burdening userspace any more than necessary. It also provides
the "default" behaviour which is backwards compatible, and allows for
fully custom CSC matrices where that is supported.

We can obviously implement this as a Mali-DP driver private property,
but it would be good to come up with something to go into the core if
possible.

I'd be happy to hear any feedback,

Thanks,
Brian
