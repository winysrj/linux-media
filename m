Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab2IXPgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 11:36:10 -0400
Received: by pbbrr4 with SMTP id rr4so7354650pbb.19
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 08:36:10 -0700 (PDT)
From: "John Weber" <rjohnweber@gmail.com>
To: "'P Jackson'" <pej02@yahoo.co.uk>
Cc: "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>
References: <1348335758.70304.YahooMailNeo@web28902.mail.ir2.yahoo.com> <Pine.LNX.4.64.1209230001390.26787@axis700.grange> <6813233.sAgYNN8Ius@avalon>
In-Reply-To: <6813233.sAgYNN8Ius@avalon>
Subject: RE: mt9t031 driver support on OMAP3 system
Date: Mon, 24 Sep 2012 10:36:06 -0500
Message-ID: <007801cd9a6a$51d002d0$f5700870$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pete,

The next issue to solve is auto-exposure/white balance (AEWB).  For this,
Laurent has put together a nice example application in a project called
omap3-isp-live [1].  This project builds two programs, 'live' and
'snapshot'.  For my purposes, I want to have live streaming video. 'live'
makes use of a local display and was not able to get this running using an
HDMI display (on Beagleboard-xM).  I modified the program to write the
buffer data to stdout in the same way as yavta does, and use netcat to pipe
the live data over a network socket to mplayer.  This provides the video
live using a network stream. This application wants allocate display buffers
that are larger than coded into the kernel, so I had to modify the kernel to
increase the buffer size.

I'm still working on this and things are in a bit of disarray.  I don't have
suitable patches just yet, otherwise I would share them.  

[1] http://git.ideasonboard.org/omap3-isp-live.git

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Monday, September 24, 2012 7:24 AM
> To: Guennadi Liakhovetski
> Cc: P Jackson; linux-media@vger.kernel.org
> Subject: Re: mt9t031 driver support on OMAP3 system
> 
> Hi Pete,
> 
> On Sunday 23 September 2012 00:04:20 Guennadi Liakhovetski wrote:
> > On Sat, 22 Sep 2012, P Jackson wrote:
> > > I'm trying to incorporate an MT9T031-based sensor into a commercial
> > > small form-factor OMAP3 DM3730-based system which is supplied with
> > > sources for a 2.6.37 kernel and is somewhat out-dated.The
> > > application I'm working on requires a single image to be acquired
> > > from the sensor every once in a while which is then processed
> > > off-line by another algorithm on the OMAP3
> > >
> > > I'd appreciate any advice from the list as to what the most suitable
> > > up to-date compatible kernel I should use would be and what other
> > > work I need to do in order to get things sorted.
> >
> > I would certainly advise to use a current kernel (e.g., 3.5). As for
> > "how," I know, that Laurent has worked on a similar tasks, you can
> > find his posts in mailing list archives, or maybe he'll be able to
> > advise you more specifically.
> 
> You can have a look at
> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> sensors-board to see how I've modified the ov772x driver to make it
> usable with the OMAP3 ISP. The patches are not upstreamable as such, I
> still need to work on them. I've explained the issues in detail on the
> mailing list.
> 
> --
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

