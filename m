Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35091 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab0E0GoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 02:44:14 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 27 May 2010 12:14:05 +0530
Subject: RE: Idea of a v4l -> fb interface driver
Message-ID: <19F8576C6E063C45BE387C64729E7394044E616F05@dbde02.ent.ti.com>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Guennadi Liakhovetski
> Sent: Wednesday, May 26, 2010 7:40 PM
> To: linux-fbdev@vger.kernel.org
> Subject: Idea of a v4l -> fb interface driver
> 
> This message has been earlier sent to the V4L mailing list
> 
> Linux Media Mailing List <linux-media@vger.kernel.org>
I replied to Linux-Media list, but saw this thread again. So pasting my response here and adding linux-media to CC.


> 
> When replying, please add it to CC. This is a discussion proposal for the
> V4L mini summit, that is going to take place in June in Helsinki, Finland.
> Any opinions very welcome.
> 
> 		V4L(2) video output vs. framebuffer.
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
[Hiremath, Vaibhav] Up to certain extent yes you are correct.

> OTOH V4L2 has a standard video output driver support, it is not very
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
> driver and get a framebuffer device free of charge... TBH, I haven't given
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

Also as mentioned by Jaya, it would be great if you put benefits we are targeting would be helpful.

Thanks,
Vaibhav

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
