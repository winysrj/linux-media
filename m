Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:24885 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DIIj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 04:39:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Michal Lazo <michal.lazo@mdragon.org>
Subject: Re: vivi kernel driver
Date: Tue, 9 Apr 2013 10:38:53 +0200
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>
References: <CAFW1BFxJ-fe8N-=LSKUfRP=-R+XUY_it3miEUKKJ6twkZa1wZA@mail.gmail.com> <201304081446.33811.hverkuil@xs4all.nl> <CAFW1BFwF1WKgp0Bxyqo1WrvY98LaKCbakK+=rjNsbEW7LgB2cw@mail.gmail.com>
In-Reply-To: <CAFW1BFwF1WKgp0Bxyqo1WrvY98LaKCbakK+=rjNsbEW7LgB2cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091038.53593.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 9 April 2013 09:58:33 Michal Lazo wrote:
> I want to make API that will provide hw video decoder on Amlogic SOC
> it is ARM cortex 9
> 
> with some proprietary video decoder
> 
> amlogic provide me with working example that generate output frames in
> amlvideo driver.
> It is v4l2 driver
> and it did memcpy to mmap userspace memory
> 
>     buffer_y_start=ioremap(cs0.addr,cs0.width*cs0.height);
>     for(i=0;i<buf->vb.height;i++) {
> 		memcpy(vbuf + pos_dst, buffer_y_start+pos_src, buf->vb.width*3);
> 		pos_dst+=buf->vb.width*3;
> 		pos_src+= cs0.width;
> 	}
> 
> I did it with one memcpy with same cpu load
> 
> https://github.com/Pivosgroup/buildroot-linux-kernel/blob/master/drivers/media/video/amlvideo/amlvideo.c#L218
> 
> top get me 50% cpu load on this driver for 25fps PAL
> 
> it is really too much
> 
> and funny is that vivi driver(amlvideo is completely base on vivi) get
> me same cpu load

Well, yes, because it is the memcpy that gives you all the load.
Of course, in a well-written driver the amlvideo buffers would be available
to userspace directly using mmap() and no memcpy would be needed.

Basically amlogic gave you a crappy driver.

Regards,

	Hans

> 
> it looks like memcpy isn't cached or something but I don't know how to
> identify problem
> Any idea how to identify this problem.
> 
> On Mon, Apr 8, 2013 at 2:46 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Mon April 8 2013 14:42:32 Michal Lazo wrote:
> >> Hi
> >> 720x576 RGB 25, 30 fps and it take
> >>
> >> 25% cpu load on raspberry pi(ARM 700Mhz linux 3.6.11) or 8% on x86(AMD
> >> 2GHz linux 3.2.0-39)
> >>
> >> it is simply too much
> >
> > No, that's what I would expect. Note that vivi was substantially improved recently
> > when it comes to the image generation. That will be in the upcoming 3.9 kernel.
> >
> > This should reduce CPU load by quite a bit if memory serves.
> >
> > Regards,
> >
> >         Hans
> >
> >>
> >>
> >>
> >>
> >> On Mon, Apr 8, 2013 at 9:42 AM, Peter Senna Tschudin
> >> <peter.senna@gmail.com> wrote:
> >> > Dear Michal,
> >> >
> >> > The CPU intensive part of the vivi driver is the image generation.
> >> > This is not an issue for real drivers.
> >> >
> >> > Regards,
> >> >
> >> > Peter
> >> >
> >> > On Sun, Apr 7, 2013 at 9:32 PM, Michal Lazo <michal.lazo@mdragon.org> wrote:
> >> >> Hi
> >> >> V4L2 driver vivi
> >> >> generate 25% cpu load on raspberry pi(linux 3.6.11) or 8% on x86(linux 3.2.0-39)
> >> >>
> >> >> player
> >> >> GST_DEBUG="*:3,v4l2src:3,v4l2:3" gst-launch-0.10 v4l2src
> >> >> device="/dev/video0" norm=255 ! video/x-raw-rgb, width=720,
> >> >> height=576, framerate=30000/1001 ! fakesink sync=false
> >> >>
> >> >> Anybody can answer me why?
> >> >> And how can I do it better ?
> >> >>
> >> >> I use vivi as base example for my driver
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >
> >> >
> >> >
> >> > --
> >> > Peter
> >>
> >>
> >>
> >>
> 
> 
> 
> 
