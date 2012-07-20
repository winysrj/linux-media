Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3057 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab2GTJGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 05:06:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Soby Mathew <soby.linuxtv@gmail.com>
Subject: Re: Supporting 3D formats in V4L2
Date: Fri, 20 Jul 2012 11:05:45 +0200
Cc: linux-media@vger.kernel.org
References: <CAGzWAsg3hsGV5CPsCzxcKO4djG4iRZauEQvju=G=Zp4Rpqpz2g@mail.gmail.com> <201207191606.21244.hverkuil@xs4all.nl> <CAGzWAsjxOHkccZstHfiqNKhLNCNMRoCsswP8vNOEDeE-FSHVug@mail.gmail.com>
In-Reply-To: <CAGzWAsjxOHkccZstHfiqNKhLNCNMRoCsswP8vNOEDeE-FSHVug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207201105.45303.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri July 20 2012 07:23:32 Soby Mathew wrote:
> Hi Hans,
> 
>      I think your solution is appropriate. I agree to your suggestions.
> 
> Regarding the 'active space' issue for 3D formats, I was studying the
> currently the v4l2_bt_timings structure.
> 
> The Vtotal is calculated for 2D timings as :
> tot_height = height + vfrontporch + vsync + vbackporch +
>                       il_vfrontporch + il_vsync + il_vbackporch
> 
> 
> In case of 3D, the Vtotal would be dependent on the 3D format.

No, as I understand it active_space is just part of the active video. So the
timings struct is fine, it's just that the height parameter for e.g. 720p in
frame pack format is 2*720 + vfrontporch + vsync + vbackporch. That's the height
of the frame that will have to be DMAed from/to the receiver/transmitter.

I think the only thing that needs to be done is that the appropriate timings are
added to linux/v4l2-dv-timings.h.

Regards,

	Hans

> 
> For FRAME PACK progressive
> tot_height = height + active_space + vfrontporch + vsync + vbackporch
> 
> FRAME PACK interlace
> tot_height = height + active_space1 + active_space2 + vfrontporch +
> vsync + vbackporch
> 
> FIELD_ALTERNATIVE
> tot_height = height + active_space1 + active_space2 + vfrontporch1 +
> vfrontporch2+ vsync1 + vsync2 + vbackporch1 + vbackporch2
> 
> All the other 3D formats would fall into one of the categories above.
> 
>  Either v4l2_bt_timings structure has to be expanded to accommodate
> for 3D timings, or a new structure can be defined for the same.
> 
> 
> Best Regards
> Soby Mathew
> 
> 
> On Thu, Jul 19, 2012 at 7:36 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Thu 19 July 2012 15:41:07 Hans Verkuil wrote:
> >> Hi Soby!
> >>
> >> On Thu 19 July 2012 14:18:13 Soby Mathew wrote:
> >> > Hi everyone,
> >> >     Currently there is limitation in v4l2 for specifying the 3D
> >> > formats . In HDMI 1.4 standard, the following 3D formats are
> >> > specified:
> >>
> >> I think that this is ideal for adding to enum v4l2_field.
> >> I've made some proposals below:
> >>
> >> >
> >> >       1. FRAME_PACK,
> >>
> >> V4L2_FIELD_3D_FRAME_PACK      (progressive)
> >> V4L2_FIELD_3D_FRAME_PACK_TB   (interlaced, odd == top comes first)
> >
> > BTW, I'm not really sure at the moment how to handle the 'active space'.
> > I guess the application will have to use the DV_TIMINGS ioctls to discover
> > the vertical blanking size and use that to interpret the captured data.
> >
> > We would also have to add new 3D timings to linux/v4l2-dv-timings.h.
> >
> > Regards,
> >
> >         Hans
> >
> >>
> >> >       2. FIELD_ALTERNATIVE,
> >>
> >> V4L2_FIELD_3D_FIELD_ALTERNATIVE
> >>
> >> >       3. LINE_ALTERNATIVE,
> >>
> >> V4L2_FIELD_3D_LINE_ALTERNATIVE
> >>
> >> >       4. SIDE BY SIDE FULL,
> >>
> >> V4L2_FIELD_3D_SBS_FULL
> >>
> >> >       5. SIDE BY SIDE HALF,
> >>
> >> V4L2_FIELD_3D_SBS_HALF
> >>
> >> >       6. LEFT + DEPTH,
> >>
> >> V4L2_FIELD_3D_L_DEPTH
> >>
> >> >       7. LEFT + DEPTH + GRAPHICS + GRAPHICS-DEPTH,
> >>
> >> V4L2_FIELD_3D_L_DEPTH_GFX_DEPTH
> >>
> >> >       8. TOP AND BOTTOM
> >>
> >> V4L2_FIELD_3D_TAB
> >>
> >> You would also need defines that describe which field is received for the field
> >> alternative mode (it's put in struct v4l2_buffer):
> >>
> >> V4L2_FIELD_3D_LEFT_TOP
> >> V4L2_FIELD_3D_LEFT_BOTTOM
> >> V4L2_FIELD_3D_RIGHT_TOP
> >> V4L2_FIELD_3D_RIGHT_BOTTOM
> >>
> >> >
> >> >
> >> > In addition for some of the formats like Side-by-side-half there are
> >> > some additional metadata (like type of horizontal sub-sampling)
> >>
> >> A control seems to be the most appropriate method of exposing the
> >> horizontal subsampling.
> >>
> >> > and
> >> > parallax information which may be required for programming the display
> >> > processing pipeline properly.
> >>
> >> This would be a new ioctl, but I think this should only be implemented if
> >> someone can actually test it with real hardware. The same is true for the
> >> more exotic 3D formats above.
> >>
> >> It seems SBS is by far the most common format.
> >>
> >> >
> >> > I am not very sure on how to expose this to the userspace. This is an
> >> > inherent property of video signal  , hence it would be appropriate to
> >> > have an additional field in v4l_format to specify 3D format. Currently
> >> > this is a requirement for HDMI 1.4 Rx / Tx but in the future it would
> >> > be applicable to broadcast sources also.
> >> >
> >> > In our implementation we have temporarily defined a Private Control to
> >> > expose this .
> >> >
> >> > Please let me know of your suggestions .
> >>
> >> I hope this helps!
> >>
> >> Regards,
> >>
> >>       Hans
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
