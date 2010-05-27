Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755408Ab0E0KCh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 06:02:37 -0400
Date: Thu, 27 May 2010 12:02:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pawel Osciak <p.osciak@samsung.com>
cc: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	"'Zhong, Jeff'" <hzhong@quicinc.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	"'Zhang, Xiaolin'" <xiaolin.zhang@intel.com>,
	'Sergio Rodriguez' <saaguirre@ti.com>,
	'Vaibhav Hiremath' <hvaibhav@ti.com>,
	'Hans de Goede' <hdegoede@redhat.com>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Kamil Debski' <k.debski@samsung.com>,
	linux-fbdev@vger.kernel.org
Subject: RE: Tentative agenda for Helsinki mini-summit
In-Reply-To: <005201cafd82$557b24f0$00716ed0$%osciak@samsung.com>
Message-ID: <Pine.LNX.4.64.1005271158550.2293@axis700.grange>
References: <201005231236.49048.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1005231929091.3571@axis700.grange>
 <005201cafd82$557b24f0$00716ed0$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 May 2010, Pawel Osciak wrote:

> Hi,
> 
> >Guennadi Liakhovetski wrote:
> >
> >No idea whether this is a worthy and suitable topic for this meeting, but:
> >
> >V4L(2) video output vs. framebuffer.
> >
> >How about a v4l2-output - fbdev translation layer? You write a v4l2-output
> >driver and get a framebuffer device free of charge... TBH, I haven't given
> >this too much of a thought, but so far I don't see anything that would
> >make this impossible in principle. The video buffer management is quite
> >different between the two systems, but maybe we can teach video-output
> >drivers to work with just one buffer too? Anyway, feel free to tell me why
> >this is an absolutely impossible / impractical idea;)
> 
> We also use v4l2-outputs for our display interfaces and for that we have
> v4l2-subdevices in a framebuffer driver. Although we have had no need for
> such a translation layer per se up to now, the idea seems interesting.

Interesting, but sorry, don't quite understand "we use v4l2-outputs" and 
"in a framebuffer driver" - so, is it a framebuffer (/dev/fbX) or a v4l2 
output device driver or both? Which driver is this? Is it already in the 
mainline?

> I would definitely be interested in a general discussion about framebuffer
> driver - v4l2 output device interoperability though and can share our
> experience in this field.

Yes, please, do, it would be very much appreciated!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
