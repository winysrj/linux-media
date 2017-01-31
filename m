Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:36990 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbdAaMnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 07:43:12 -0500
Date: Tue, 31 Jan 2017 12:33:29 +0000
From: Brian Starkey <brian.starkey@arm.com>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mihail.atanassov@arm.com,
        liviu.dudau@arm.com
Subject: Re: DRM Atomic property for color-space conversion
Message-ID: <20170131123329.GB24500@e106950-lin.cambridge.arm.com>
References: <20170127172324.GB12018@e106950-lin.cambridge.arm.com>
 <20170130133513.GO31595@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170130133513.GO31595@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Jan 30, 2017 at 03:35:13PM +0200, Ville Syrjälä wrote:
>On Fri, Jan 27, 2017 at 05:23:24PM +0000, Brian Starkey wrote:
>> Hi,
>>
>> We're looking to enable the per-plane color management hardware in
>> Mali-DP with atomic properties, which has sparked some conversation
>> around how to handle YCbCr formats.
>>
>> As it stands today, it's assumed that a driver will implicitly "do the
>> right thing" to display a YCbCr buffer.
>>
>> YCbCr data often uses different gamma curves and signal ranges (e.g.
>> BT.609, BT.701, BT.2020, studio range, full-range), so its desirable
>> to be able to explicitly control the YCbCr to RGB conversion process
>> from userspace.
>>
>> We're proposing adding a "CSC" (color-space conversion) property to
>> control this - primarily per-plane for framebuffer->pipeline CSC, but
>> perhaps one per CRTC too for devices which have an RGB pipeline and
>> want to output in YUV to the display:
>>
>> Name: "CSC"
>> Type: ENUM | ATOMIC;
>> Enum values (representative):
>> "default":
>> 	Same behaviour as now. "Some kind" of YCbCr->RGB conversion
>> 	for YCbCr buffers, bypass for RGB buffers
>> "disable":
>> 	Explicitly disable all colorspace conversion (i.e. use an
>> 	identity matrix).
>> "YCbCr to RGB: BT.709":
>> 	Only valid for YCbCr formats. CSC in accordance with BT.709
>> 	using [16..235] for (8-bit) luma values, and [16..240] for
>> 	8-bit chroma values. For 10-bit formats, the range limits are
>> 	multiplied by 4.
>> "YCbCr to RGB: BT.709 full-swing":
>> 	Only valid for YCbCr formats. CSC in accordance with BT.709,
>> 	but using the full range of each channel.
>> "YCbCr to RGB: Use CTM":*
>> 	Only valid for YCbCr formats. Use the matrix applied via the
>> 	plane's CTM property
>> "RGB to RGB: Use CTM":*
>> 	Only valid for RGB formats. Use the matrix applied via the
>> 	plane's CTM property
>> "Use CTM":*
>> 	Valid for any format. Use the matrix applied via the plane's
>> 	CTM property
>> ... any other values for BT.601, BT.2020, RGB to YCbCr etc. etc. as
>> they are required.
>
>Having some RGB2RGB and YCBCR2RGB things in the same property seems
>weird. I would just go with something very simple like:
>
>YCBCR_TO_RGB_CSC:
>* BT.601
>* BT.709
>* custom matrix
>

I think we've agreed in #dri-devel that this CSC property
can't/shouldn't be mapped on-to the existing (hardware implementing
the) CTM property - even in the case of per-plane color management -
because CSC needs to be done before DEGAMMA.

So, I'm in favour of going with what you suggested in the first place:

A new YCBCR_TO_RGB_CSC property, enum type, with a list of fixed
conversions. I'd drop the custom matrix for now, as we'd need to add
another property to attach the custom matrix blob too.

I still think we need a way to specify whether the source data range
is broadcast/full-range, so perhaps the enum list should be expanded
to all combinations of BT.601/BT.709 + broadcast/full-range.

(I'm not sure what the canonical naming for broadcast/full-range is,
we call them narrow and wide)

>And trying to use the same thing for the crtc stuff is probably not
>going to end well. Like Daniel said we already have the
>'Broadcast RGB' property muddying the waters there, and that stuff
>also ties in with what colorspace we signal to the sink via
>infoframes/whatever the DP thing was called. So my gut feeling is
>that trying to use the same property everywhere will just end up
>messy.

Yeah, agreed. If/when someone wants to add CSC on the output of a CRTC
(after GAMMA), we can add a new property.

That makes me wonder about calling this one SOURCE_YCBCR_TO_RGB_CSC to
be explicit that it describes the source data. Then we can later add
SINK_RGB_TO_YCBCR_CSC, and it will be reasonably obvious that its
value describes the output data rather than the input data.

I want to avoid confusion caused by ending up with two
{CS}_TO_{CS}_CSC properties, where one is describing the data to the
left of it, and the other describing the data to the right of it, with
no real way of telling which way around it is.

Cheers,
Brian

>
>-- 
>Ville Syrjälä
>Intel OTC
