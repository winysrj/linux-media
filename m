Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4658 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZHLHEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 03:04:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: DM6467 VPIF adding support for HD resolution capture and display standards
Date: Wed, 12 Aug 2009 09:04:09 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>, "Yin, Paul" <zhenyin@ti.com>
References: <A69FA2915331DC488A831521EAE36FE401452885B1@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401452885B1@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908120904.09140.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 12 August 2009 00:17:38 Karicheri, Muralidharan wrote:
> Hi Hans,
> 
> We need to add support for HD resolutions capture and display in our DM6467 vpif drivers. The vpif display driver is already part of V4L-DVB linux-next
> repository and capture driver is being reviewed. The next phase of our developments involve adding following HD resolutions for capture and display
> drivers:-
> 
> 720p@60, 720P@50, 1080i@30, 1080i@25.
> 
> We will also need to add EDTV resolutions such as 480p@30 & 576p25.
> 
> As you can see these standards are not currently available in videodev2.h. In the media controller RFC that you have proposed, this issue is being addressed. I am referring it at 
> 
> http://www.archivum.info/video4linux-list@redhat.com/2008-07/00371/RFC:_Add_support_to_query_and_change_connections_inside_a_media_device
> 
> 
> Here is the description from the RFC....
> 
> <Snip>
> In practice I would propose extending the v4l2_std_id with the common HDTV
> formats, that will take care for most use cases. In addition a new ioctl has
> to be introduced: VIDIOC_S_TIMINGS. This allows you to either specify a
> v4l2_std_id or a full set of timings (front porch, back porch, sync width,
> etc.). It should be extendable so that we can add additional timing formats
> in the future.
> 
> The digital format of the data from the media processor to the encoders can
> be set by calling S_STD or S_TIMINGS on the media processor device.
> .......
> 
> Looks like we could extend the S_STD with new HD standards mentioned above.
> Please let us know you latest thoughts on this so that we can send patches
> to enhance the standards. As you might know, this is very critical for our developments.

Hmm, that RFC is rather outdated in this respect. My latest thoughts about this
is that we should not touch G/S_STD and v4l2_std_id at all. These deal with
broadcast TV standards, and those standards have been frozen.

These new resolutions deal with digital video only (there is no audio component
as is the case with v4l2_std_id).

The HDTV standards are merely a subset of what can be supported: e.g. the dm6467
also supports all the VESA and SDTV standards and also custom timings (that's
what I use at work).

Just the combined number of standards for HDTV/SDTV/VESA is huge, so using
bitmasks to define the standard is never going to work.

My proposal would be something like this:

enum dv_preset {
	V4L2_DV_CUSTOM,
	V4L2_DV_720P24,
	V4L2_DV_720P25,
	V4L2_DV_720P30,
	V4L2_DV_720P50,
	V4L2_DV_720P60,
	/* etc */
};

/* bt.656/bt.1120 timing data */
struct bt_timings {
	__u32 interlaced;
	__u32 pixelclock;
	__u32 width, height;
	__u32 polarities;
	__u32 hfrontporch, hsync, htotal;
	__u32 vfrontporch, vsync, vtotal;
	/* timings for bottom frame for interlaced formats */
	__u32 il_hfrontporch, il_hsync, il_htotal;
	__u32 il_vfrontporch, il_vsync, il_vtotal;
	__u32 reserved[4];
};

enum dv_timings_type {
	V4L2_DV_BT_656_1120,
};

struct dv_timings {
	enum dv_timings_type type;
	union {
		struct bt_timings bt;
		__u32 reserved[32];
	};
};

and ioctls:

VIDIOC_S/G_DV_PRESET, VIDIOC_ENUM_DV_PRESETS and VIDIOC_S/G_DV_TIMINGS.

I don't think we need to have ioctls to determine what custom timings
are possible: if you are going to use that, then we can safely assume that
you know what you are doing.

There are some details to hammer out: what does G_DV_TIMINGS return if e.g.
the 720P60 preset is active? Does it return the timings for 720P60 or the last
set custom timings?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
