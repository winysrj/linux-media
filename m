Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64234 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1BZP0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 10:26:34 -0500
Received: by wwb22 with SMTP id 22so1494403wwb.1
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 07:26:33 -0800 (PST)
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Edward Hervey <bilboed@gmail.com>
To: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Clark, Rob" <rob@ti.com>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
Date: Sat, 26 Feb 2011 16:26:26 +0100
In-Reply-To: <201102261447.04378.hverkuil@xs4all.nl>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	 <201102241427.10988.laurent.pinchart@ideasonboard.com>
	 <AANLkTikZ1Z=h4ZDmZ2sUizP328auoW=6CgTdf8vuqVDd@mail.gmail.com>
	 <201102261447.04378.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1298733988.2449.4.camel@deumeu>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-02-26 at 14:47 +0100, Hans Verkuil wrote:
> On Saturday, February 26, 2011 14:38:50 Felipe Contreras wrote:
> > On Thu, Feb 24, 2011 at 3:27 PM, Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:
> > >> > Perhaps GStreamer experts would like to comment on the future plans ahead
> > >> > for zero copying/IPC and low power HW use cases? Could Gstreamer adapt
> > >> > some ideas from OMX IL making OMX IL obsolete?
> > >>
> > >> perhaps OMX should adapt some of the ideas from GStreamer ;-)
> > >
> > > I'd very much like to see GStreamer (or something else, maybe lower level, but
> > > community-maintainted) replace OMX.
> > 
> > Yes, it would be great to have something that wraps all the hardware
> > acceleration and could have support for software codecs too, all in a
> > standard interface. It would also be great if this interface would be
> > used in the upper layers like GStreamer, VLC, etc. Kind of what OMX
> > was supposed to be, but open [1].
> > 
> > Oh wait, I'm describing FFmpeg :) (supports vl42, VA-API, VDPAU,
> > DirectX, and soon OMAP3 DSP)
> > 
> > Cheers.
> > 
> > [1] http://freedesktop.org/wiki/GstOpenMAX?action=AttachFile&do=get&target=gst-openmax.png
> > 
> > 
> 
> Are there any gstreamer/linaro/etc core developers attending the ELC in San Francisco
> in April? I think it might be useful to get together before, during or after the
> conference and see if we can turn this discussion in something more concrete.
> 
> It seems to me that there is an overall agreement of what should be done, but
> that we are far from anything concrete.
> 

  I will be there and this was definitely a topic I intended to talk
about.
  See you there.

     Edward

> Regards,
> 
> 	Hans
> 


