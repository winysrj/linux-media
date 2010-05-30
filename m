Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1263 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0E3IDn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 04:03:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: Tentative agenda for Helsinki mini-summit
Date: Sun, 30 May 2010 10:05:35 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Zhong, Jeff" <hzhong@quicinc.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	Sergio Rodriguez <saaguirre@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201005231236.49048.hverkuil@xs4all.nl> <Pine.LNX.4.64.1005231929091.3571@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1005231929091.3571@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005301005.35240.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 23 May 2010 20:02:59 Guennadi Liakhovetski wrote:
> On Sun, 23 May 2010, Hans Verkuil wrote:
> 
> > Hi all,
> > 
> > This is a tentative agenda for the Helsinki mini-summit on June 14-16.
> > 
> > Please reply to this thread if you have comments or want to add topics.
> 
> [snip]
> 
> > 8) soc-camera status. Particularly with regards to the remaining soc-camera
> >    dependencies in sensor drivers. Guennadi Liakhovetski.
> 
> Don't think a formal presentation is needed, but I can tell a couple of 
> words to clarify the current status a bit.
> 
> > Comments? Topics I missed?
> 
> No idea whether this is a worthy and suitable topic for this meeting, but:
> 
> V4L(2) video output vs. framebuffer.
> 
> Problem: Currently the standard way to provide graphical output on various 
> (embedded) displays like LCDs is to use a framebuffer driver. The 
> interface is well supported and widely adopted in the user-space, many 
> applications, including the X-server, various libraries like directfb, 
> gstreamer, mplayer, etc. In the kernel space, however, the subsystem has a 
> number of problems. It is unmaintained. The infrastructure is not being 
> further developed, every specific hardware driver is being supported by 
> the respective architecture community. But as video output hardware 
> evolves, more complex displays and buses appear and have to be supported, 
> the subsystem shows its aging. For example, there is currently no way to 
> write reusable across multiple platforms display drivers.
> 
> OTOH V4L2 has a standard vodeo output driver support, it is not very 
> widely used, in the userspace I know only of gstreamer, that somehow 
> supports video-output v4l2 devices in latest versions. But, being a part 
> of the v4l2 subsystem, these drivers already now can take a full advantage 
> of all v4l2 APIs, including the v4l2-subdev API for the driver reuse.
> 
> So, how can we help graphics driver developers on the one hand by 
> providing them with a capable driver framework (v4l2) and on the other 
> hand by simplifying the task of interfacing to the user-space?
> 
> How about a v4l2-output - fbdev translation layer? You write a v4l2-output 
> driver and get a framebuffer device free of charge... TBH, I haven't given 
> this too much of a thought, but so far I don't see anything that would 
> make this impossible in principle. The video buffer management is quite 
> different between the two systems, but maybe we can teach video-output 
> drivers to work with just one buffer too? Anyway, feel free to tell me why 
> this is an absolutely impossible / impractical idea;)

I've added this to the agenda. I think this probably doesn't need a presentation
but will be more an open discussion.

I also think this is a very interesting topic to discuss more in-depth on
Tuesday.

Sakari, does Nokia have any framebuffer experts that might be interested in
discussing this as well on Tuesday?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
