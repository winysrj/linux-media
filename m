Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37207 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0E0Ghn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 02:37:43 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Zhong, Jeff" <hzhong@quicinc.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 27 May 2010 12:07:11 +0530
Subject: RE: Tentative agenda for Helsinki mini-summit
Message-ID: <19F8576C6E063C45BE387C64729E7394044E616EFA@dbde02.ent.ti.com>
References: <201005231236.49048.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1005231929091.3571@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1005231929091.3571@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> Sent: Sunday, May 23, 2010 11:33 PM
> To: Hans Verkuil
> Cc: Linux Media Mailing List; Zhong, Jeff; Laurent Pinchart; Pawel Osciak;
> Zhang, Xiaolin; Aguirre, Sergio; Hiremath, Vaibhav; Hans de Goede; Mauro
> Carvalho Chehab
> Subject: Re: Tentative agenda for Helsinki mini-summit
> 
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
> > 8) soc-camera status. Particularly with regards to the remaining soc-
> camera
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
> number of problems. It is unmaintained. 
[Hiremath, Vaibhav] Unfortunately yes it is true.

> The infrastructure is not being
> further developed, every specific hardware driver is being supported by
> the respective architecture community. But as video output hardware
> evolves, more complex displays and buses appear and have to be supported,
> the subsystem shows its aging. For example, there is currently no way to
> write reusable across multiple platforms display drivers.
> 
[Hiremath, Vaibhav] Up to certain extent yes you are correct.

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
[Hiremath, Vaibhav] I think this is really complex question which requires healthy discussion over list.


> How about a v4l2-output - fbdev translation layer? You write a v4l2-output
> driver and get a framebuffer device free of charge... 
[Hiremath, Vaibhav] It would be nice if you put some more details/thoughts here for better understanding of what exactly you are thinking/proposing.

> TBH, I haven't given
> this too much of a thought, but so far I don't see anything that would
> make this impossible in principle. The video buffer management is quite
> different between the two systems, but maybe we can teach video-output
> drivers to work with just one buffer too? 
[Hiremath, Vaibhav] I believe V4L2 buf won't limit you to do this. Atleast in case of OMAP v4L2 display driver we are sticking to last buffer if application fails to queue one. So for me this is single buffer keeps on displaying unless application queue next buffer. 


> Anyway, feel free to tell me why
> this is an absolutely impossible / impractical idea;)
> 
[Hiremath, Vaibhav] If I understanding correctly you are trying to propose something like,

Without changing Fbdev interface to user space application, create translation layers which will allow driver developer to write driver under V4L2 framework providing /dev/fbx but using V4L2 API/framework.

Thanks,
Vaibhav

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
