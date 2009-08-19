Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1626 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZHSS3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 14:29:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: DM6467 VPIF adding support for HD resolution capture and display standards
Date: Wed, 19 Aug 2009 20:29:52 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>, "Yin, Paul" <zhenyin@ti.com>
References: <A69FA2915331DC488A831521EAE36FE401452885B1@dlee06.ent.ti.com> <200908140824.36016.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE401548C24B2@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401548C24B2@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908192029.52944.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 19 August 2009 19:44:24 Karicheri, Muralidharan wrote:
> Hans,
> 
> You have done a great job in putting up a quick proposal. I was just trying to understand the intentions/rational behind your proposal to be on the same page. Thanks for the education. I think this will help others as well.

You're welcome :-)

It's not complete though. Other things to consider are:

1) How to detect what format is received on e.g. an HDMI or DVI-A/D receiver?

I think we need a VIDIOC_QUERY_DV_PRESET. Either this returns the actual
preset, or it returns V4L2_DV_CUSTOM and you have to call
VIDIOC_QUERY_DV_TIMINGS to get the full timings, or it returns something like
V4L2_DV_NO_SIGNAL (no input signal) or V4L2_DV_UNKNOWN.

When querying the timings we have to realize that not all fields may be filled
in. E.g. when receiving an HDMI or DVI-D signal quite often you can only get
hold of the width and height of the image and some framerate information.

Timings like front porch etc. may no be possible to obtain.

2) How to specify timings when using embedded syncs? We probably have to add
a flag to toggle between embedded (SAV/EAV codes) or separate syncs (actually,
it is possible to do both at the same time). For the timings we can just set
the sync length and porch length to 0 since those are no longer relevant for
embedded syncs.

3) What is the relationship (if any) between these new ioctls and the old
G/S/QUERY/ENUM_STD and the ENUM_FRAMESIZES/FRAMEINTERVALS ioctls? To prevent
terminal confusion this should be made very clear in the v4l2 spec.

<snip>

> >> >	__u32 width, height;
> >> >	__u32 polarities;
> >> Is it a bit mask of polarities such as vsync, hsync etc?
> >
> >Yes.
> Then we would need to define POLARITIES as bit mask for user space usage.
> like
> 
> #define V4L2_DV_VSYNC_POL	0x1
> #define V4L2_DV_HSYNC_POL	0x2
> 
> and so forth?

Yes.

<snip>

> >> >	/* timings for bottom frame for interlaced formats */
> >> >	__u32 il_hfrontporch, il_hsync, il_htotal;
> >> >	__u32 il_vfrontporch, il_vsync, il_vtotal;
> >> Looking at a typical vesa timing values, I don't see them defined
> >separately for top and bottom fields. Is it for BT1120/BT656 and camera
> >capture timing?
> >
> >Front porch, sync length and htotal can be removed, but I think il_vtotal
> >can
> >be different from vtotal by one line so we should keep that one.
> >
> 
> I think it is safer to keep them and mark them as experimental?. 

No, they definitely can be removed. I wasn't thinking when I added them.
It's only the il_vtotal that we need to keep.

> 
> >>
> >> >enum dv_timings_type {
> >> >	V4L2_DV_BT_656_1120,
> >> Why combine BT656 and BT1120? They have different set of timing values.
> >Also if custom timing to be allowed, shouldn't there be a type
> >> V4L2_CUSTOM_TIMING as one of the type. So only then bt_timings values
> >will be used.
> >
> >No. BT656 and BT1120 define how bitstreams for video are formatted. There
> >is
> >very little difference between the two. I would have to do research as to
> >what
> >exactly the differences are, but based on my experience so far I think
> >there
> >is no need to separate them.
> >Also note that both use the same timing parameters, so the custom settings
> >are
> >actually following the bt656/1120 timings.
> 
> What I see from the VPIF hardware spec is that they use different values for first line of top/bottom field, first line of active video, last line of active video and so forth. That means timing parameters are different, right? 

But these parameters can all be defined in terms of the timings parameters.
The question is: are there differences in the generated signal that are not
covered by the timing parameters. One thing that springs to mind is how the
sync signal is formed. I remember reading about two or three level syncs. We
may well need to either specify the sync format or let it depend on the timings
type. Note that you can also have syncs embedded in the data stream (not to
be confused with the SAV/EAV codes). This is used for component inputs/outputs
where a sync signal is carried in the Y data signal.

However, I think we have to be careful not to attempt to do too much here.
A certain amount of intelligence can be expected from a driver.

> 
> <Snip>
> 
> >
> >>
> >> >};
> >> VPIF supports SMPTE 296 mode in which different timing values are used
> >than BT1120. So I see V4L2_DV_SMPTE_296 as well to begin with.
> >
> >Someone needs to put these standards next to one another and research what
> >the differences are and whether those differences are enough to require
> >adding a new type. Do you have access to those standards and can you go
> >through them and see what the differences are exactly and whether those
> >require adding a special type + associated timings struct?
> >
> 
> I don't have access to the specs. But VPIF hardware manual says hardware use different values for first line of top/bottom field, first line of active video, last line of active video and so forth. i.e they are different for BT656, BT1120, & SMPTE 296.

But all those values are programmable through the bt_timings parameters. So
bt_timings fits all (except for possible sync wave differences).

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
