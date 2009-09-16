Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2426 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952AbZIPVt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 17:49:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: RFC: V4L - Support for video timings at the input/output interface
Date: Wed, 16 Sep 2009 23:49:24 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com> <200909150853.19902.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40155157076@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155157076@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909162349.24772.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 16 September 2009 23:04:42 Karicheri, Muralidharan wrote:
> Hans,
> 
> I was busy with some of the merge work and also some other issues.
> So this delayed response...
> 
> >
> >Thanks for your work on this!
> 
> You are most welcome !

<snip>

> >> pixelclock - expressed in HZ. So for 74.25MHz, use 74250000.
> >> width - number of pixels in horizontal direction
> >> height - number of lines in vertical direction
> >> polarities - Bit mask for following polarities to begin with
> >>
> >> #define V4L2_DV_VSYNC_POS_POL    0x1
> >> #define V4L2_DV_VSYNC_NEG_POL    0x2
> >> #define V4L2_DV_HSYNC_POS_POL    0x3
> >> #define V4L2_DV_HSYNC_NEG_POL    0x4
> >
> >Why have separate pos and neg bits? Also, bitmask defines should define the
> >actual mask, not the bit numbers.
> 
> Oops! That was your original comment. Need to change these to masks.
> as 
> 
> #define V4L2_DV_VSYNC_POS_POL    0x00000001
> #define V4L2_DV_VSYNC_NEG_POL    0x00000002
> #define V4L2_DV_HSYNC_POS_POL    0x00000004
> #define V4L2_DV_HSYNC_NEG_POL    0x00000008

Sorry, but why the NEG_POL masks? This is sufficient:

#define V4L2_DV_VSYNC_POS_POL    0x00000001
#define V4L2_DV_HSYNC_POS_POL    0x00000002

If you don't set the bit then the polarity is negative (0 bitvalue, so negative).

> >7. How to use S_DV_TIMINGS to setup a sensor.
> >   Sensors can be setup either using the full DV_TIMINGS functionality (e.g.
> >   pixelclock, porches, sync width, etc.) or with a subset only: width,
> >height,
> >   frame period. The latter can already be setup with S_PARM (but do we
> >want
> >   that? S_PARM is very, very ugly). I am thinking of creating a new
> >DV_TIMINGS
> >   type for this with just width, height and frame period.
> >   But this leads to another complication: how to tell the user which
> >timings
> >   type to use? Easiest way is to use the capabilities field:
> >CAP_BT_TIMINGS,
> >   CAP_FRAME_TIMINGS. Of course, this limits the number of possible timings
> >   we can define. The alternative is to add yet another field that contains
> >   the actual timings type. But I think this is overkill.
> 
> How about adding two capability flag - CAP_FIXED_FRAME_RATE and CAP_VARIABLE_FRAME_RATE? and change preset type to
> 
> struct v4l2_dv_preset {
>     __u32 preset;
> 	v4l2_fract fps;
>     __u32 reserved[4];
> };
> 
> Where preset can be just referring a resolution and scan type.
> 
> #define       V4L2_DV_720X480P     0x00000001
> #define       V4L2_DV_640X480P     0x00000002
> #define       V4L2_DV_720X576P     0x00000003
> 
> and so forth. So for a camera that supports pre-defined presets can
> set the CAP_FIXED_FRAME_RATE capability. So Auto exposure may not
> be available. If Auto exposure is available, the driver can indicate
> CAP_VARIABLE_FRAME_RATE. If a driver supports both, then both flags
> can be set and based on the value of fps can decide which mode to
> operate on (0/0 - for variable mode, 30/1 - to do 30fps rate).

Setting up a sensor is rather messy at the moment. You have the
ENUM_FRAMESIZES and ENUM_FRAMEINTERVALS ioctls that basically give you the
'presets' of a sensor. For exposure we have camera controls. Yet we also
have S_PARM to set the framerate. And to set the resolution we abuse S_FMT.

I don't think we should use preset for anything else besides just uniquely
identifying a particular video timing. It is a good idea though to add the
width, height and fps to struct v4l2_dv_enum_presets. That way apps can
actually know what the preset resolution and fps is.

To be honest I don't have any brilliant ideas at the moment on how to solve
setting sensor timings. At the LPC we have both the UVC maintainer (Laurent
Pinchart) and the libv4l and gspca developer Hans de Goede present, so we
should be able to come up with a good solution to this. My knowledge of
sensors is limited, so I will need help with this.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
