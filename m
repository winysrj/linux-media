Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2886 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2GWMoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:44:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Soby Mathew <soby.linuxtv@gmail.com>
Subject: Re: Supporting 3D formats in V4L2
Date: Mon, 23 Jul 2012 14:44:11 +0200
Cc: linux-media@vger.kernel.org
References: <CAGzWAsg3hsGV5CPsCzxcKO4djG4iRZauEQvju=G=Zp4Rpqpz2g@mail.gmail.com> <201207201105.45303.hverkuil@xs4all.nl> <CAGzWAsg2fhmxDshtruGm90YAiVbHis7hEuE_BZRFBV_PPa-h7g@mail.gmail.com>
In-Reply-To: <CAGzWAsg2fhmxDshtruGm90YAiVbHis7hEuE_BZRFBV_PPa-h7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231444.11469.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon July 23 2012 14:35:14 Soby Mathew wrote:
> Hi Hans,
>  Thanks for the reply and I was going through the HDMI1.4 spec again.
> The 'active space' is part of the Vactive and Vactive is sum of active
> video and active space.
> 
> > No, as I understand it active_space is just part of the active video. So the
> > timings struct is fine, it's just that the height parameter for e.g. 720p in
> > frame pack format is 2*720 + vfrontporch + vsync + vbackporch. That's the height
> > of the frame that will have to be DMAed from/to the receiver/transmitter.
> 
> In this case (assuming frame packed) the total height should be 2*720
> + 30 +  vfrontporch + vsync + vbackporch.
> 
> Sorry, but if I am understanding you correct, in case of 3D frame
> packed format, the height field can be 'active video + active space'.

Right.

> So the application need to treat the buffers appropriately according
> to the 3D format detected. Would this be a good solution?

Right. So the application will need to obtain the timings somehow (either from
v4l2-dv-timings.h, or from VIDIOC_G/QUERY_DV_TIMINGS) so it knows how to
interpret the captured data and how large the buffer size has to be in the first
place.

I think it will all work out, but you would have to actually implement it to be
sure I haven't forgotten anything.

Frankly, I'd say that the frame_packed format is something you want to avoid :-)
It's pretty weird.

Regards,

	Hans

> 
> 
> > I think the only thing that needs to be done is that the appropriate timings are
> > added to linux/v4l2-dv-timings.h.
> 
> Yes , the standard 3 D timings need to be added to this file which can
> be taken up.
> 
> > Regards,
> >
> >         Hans
> >
> 
> 
> Best Regards
> Soby Mathew
> 
