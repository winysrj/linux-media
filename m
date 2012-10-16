Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta-15.w4a.fr ([176.31.217.10]:58362 "EHLO
	zose-mta15.web4all.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752896Ab2JPVJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 17:09:39 -0400
Date: Tue, 16 Oct 2012 23:04:36 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris MacGregor <chris@cybermato.com>,
	linux-media@vger.kernel.org, Liu Ying <Ying.liu@freescale.com>,
	"Hans J. Koch" <hjk@linutronix.de>,
	Daniel Mack <daniel@zonque.org>,
	Christoph Fritz <chf.fritz@googlemail.com>
Message-ID: <135335921.6991961.1350421476631.JavaMail.root@advansee.com>
In-Reply-To: <2180583.3hl5tPmpSx@avalon>
Subject: Re: hacking MT9P031 for i.mx
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Tuesday, October 16, 2012 10:04:57 PM, Laurent Pinchart wrote:
> On Friday 12 October 2012 14:10:43 Christoph Fritz wrote:
> > On Mon, 2012-07-02 at 14:48 +0200, Laurent Pinchart wrote:
> > > On Thursday 28 June 2012 21:41:16 Chris MacGregor wrote:
> > > > > Where did you get the Aptina board code patch from ?
> > > >  
> > > >  From here: https://github.com/Aptina/BeagleBoard-xM
> > > 
> > > That's definitely outdated, the code is based on a very old OMAP3
> > > ISP
> > > driver that was more or less broken by design. Nowadays anything
> > > other
> > > than the mainline version isn't supported by the community.
> > 
> > Is there a current (kernel ~3.6) git tree which shows how to add
> > mt9p031
> > to platform code?
> 
> Yes, at
> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> sensors-board
> 
> > I'm also curious if it's possible to glue mt9p031 to a freescale
> > i.mx35
> > platform. As far as I can see,
> > drivers/media/platform/soc_camera/mx3_camera.c would need
> > v4l2_subdev
> > support?

I have not followed this thread, so I don't know exactly your issue, but FYI I
have an MT9M131 (of which the driver should hopefully be close to the MT9P031's)
working on i.MX35 with Linux 3.4.

I have local changes for that adding support for all possible formats to
mx3_camera and its IPU. I still have to upgrade to the latest Linux and to
prepare patches before posting them. I won't be able to do that before a few
weeks. However, if someone needs it, I can share my local changeset as a global
patch.

Best regards,
Benoît
