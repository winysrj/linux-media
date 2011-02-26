Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4174 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1BZNrN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 08:47:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
Date: Sat, 26 Feb 2011 14:47:04 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Clark, Rob" <rob@ti.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	gstreamer-devel@lists.freedesktop.org,
	"ST-Ericsson LT Mailing List" <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com> <201102241427.10988.laurent.pinchart@ideasonboard.com> <AANLkTikZ1Z=h4ZDmZ2sUizP328auoW=6CgTdf8vuqVDd@mail.gmail.com>
In-Reply-To: <AANLkTikZ1Z=h4ZDmZ2sUizP328auoW=6CgTdf8vuqVDd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102261447.04378.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, February 26, 2011 14:38:50 Felipe Contreras wrote:
> On Thu, Feb 24, 2011 at 3:27 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> >> > Perhaps GStreamer experts would like to comment on the future plans ahead
> >> > for zero copying/IPC and low power HW use cases? Could Gstreamer adapt
> >> > some ideas from OMX IL making OMX IL obsolete?
> >>
> >> perhaps OMX should adapt some of the ideas from GStreamer ;-)
> >
> > I'd very much like to see GStreamer (or something else, maybe lower level, but
> > community-maintainted) replace OMX.
> 
> Yes, it would be great to have something that wraps all the hardware
> acceleration and could have support for software codecs too, all in a
> standard interface. It would also be great if this interface would be
> used in the upper layers like GStreamer, VLC, etc. Kind of what OMX
> was supposed to be, but open [1].
> 
> Oh wait, I'm describing FFmpeg :) (supports vl42, VA-API, VDPAU,
> DirectX, and soon OMAP3 DSP)
> 
> Cheers.
> 
> [1] http://freedesktop.org/wiki/GstOpenMAX?action=AttachFile&do=get&target=gst-openmax.png
> 
> 

Are there any gstreamer/linaro/etc core developers attending the ELC in San Francisco
in April? I think it might be useful to get together before, during or after the
conference and see if we can turn this discussion in something more concrete.

It seems to me that there is an overall agreement of what should be done, but
that we are far from anything concrete.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
