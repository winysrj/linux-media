Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36769 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3LNN6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 08:58:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Josh Wu <josh.wu@atmel.com>
Subject: Re: [GIT PULL FOR v3.14] Atmel ISI patches
Date: Sat, 14 Dec 2013 14:59:04 +0100
Message-ID: <2443796.n0B4KP2NLJ@avalon>
In-Reply-To: <Pine.LNX.4.64.1312140631130.31318@axis700.grange>
References: <1408503.CfMV1Tiy7q@avalon> <Pine.LNX.4.64.1312140631130.31318@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Saturday 14 December 2013 06:34:05 Guennadi Liakhovetski wrote:
> On Sat, 14 Dec 2013, Laurent Pinchart wrote:
> > Hi Mauro,
> > 
> > The following changes since commit 
675722b0e3917c6c917f1aa5f6d005cd3a0479f5:
> >   Merge branch 'upstream-fixes' into patchwork (2013-12-13 05:04:00 -0200)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/media.git atmel/isi
> 
> Thanks for your patches. Any specific reason you're asking Mauro to pull
> directly from you instead of letting them go via my tree as usual for
> soc-camera patches?

Just that I wasn't aware they should go through your tree. Sorry about that. 
Could you please handle the pull request then ?

> > for you to fetch changes up to 8f94dee5c528d1334fd1cb548966757ba2cf1431:
> >   v4l: atmel-isi: Should clear bits before set the hardware register
> > 
> > (2013-12-14 03:46:39 +0100)
> > 
> > ----------------------------------------------------------------
> > 
> > Josh Wu (2):
> >       v4l: atmel-isi: remove SOF wait in start_streaming()
> >       v4l: atmel-isi: Should clear bits before set the hardware register
> > 
> > Laurent Pinchart (5):
> >       v4l: atmel-isi: Use devm_* managed allocators
> >       v4l: atmel-isi: Defer clock (un)preparation to enable/disable time
> >       v4l: atmel-isi: Reset the ISI when starting the stream
> >       v4l: atmel-isi: Make the MCK clock optional
> >       v4l: atmel-isi: Fix color component ordering
> >  
> >  drivers/media/platform/soc_camera/atmel-isi.c | 179  ++++++--------------
> >  include/media/atmel-isi.h                     |   2 +
> >  2 files changed, 55 insertions(+), 126 deletions(-)

-- 
Regards,

Laurent Pinchart

