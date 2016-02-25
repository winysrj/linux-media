Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39812 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbcBYWFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2016 17:05:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philippe De Muyter <phdm@macq.eu>
Cc: linux-media@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: i.mx6 camera interface (CSI) and mainline kernel
Date: Fri, 26 Feb 2016 00:05:30 +0200
Message-ID: <4956050.OLrYA1VK2G@avalon>
In-Reply-To: <20160223141258.GA5097@frolo.macqel>
References: <20160223114943.GA10944@frolo.macqel> <20160223141258.GA5097@frolo.macqel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Philippe,

CC'ing Philipp and Steve.

Philipp, Steve, are you still interested in getting a driver for the i.MX6 
camera interface upstreamed ?

On Tuesday 23 February 2016 15:12:58 Philippe De Muyter wrote:
> Update.
> 
> On Tue, Feb 23, 2016 at 12:49:43PM +0100, Philippe De Muyter wrote:
> > Hello,
> > 
> > We use a custom imx6 based board with a canera sensor on it.
> > I have written the driver for the camera sensor, based on
> > the freescale so-called "3.10" and even "3.14" linux versions.
> > 
> > The camera works perfectly, but we would like to switch to
> > a mainline kernel for all the usual reasons (including being
> > able to contribute our fixes).
> > 
> > >From an old mail thread (*), I have found two git repositories
> > 
> > that used to contain not-yet-approved versions of mainline
> > imx6 ipu-v3 drivers :
> > 
> > git://git.pengutronix.de/git/pza/linux.git test/nitrogen6x-ipu-media
> > https://github.com:slongerbeam/mediatree.git, mx6-camera-staging
> > 
> > I have tried to compile them with the imx_v6_v7_defconfig, but both
> > fail directly at compile time. because of later changes in the
> > v4l2_subdev infrastructure, not ported to the those branches.
> 
> What I wrote is true for Steve Longerbeam's branch, but for Philipp Zabel's
> branch the problem (so far) was only that CONFIG_MEDIA_CONTROLLER
> is not defined in imx_v6_v7_defconfig, but is required for a succesfull
> compilation of Philipp's tree.
> 
> > Can someone point me to compilable versions (either not rebased
> > versions of those branches, or updated versions of those branches,
> > or yet another place to look at). ?
> > 
> > Thanks in advance
> > 
> > Philippe
> > 
> > (*)
> > http://linux-media.vger.kernel.narkive.com/cZQ8NrZ2/i-mx6-status-for-ipu-> > vpu-gpu

-- 
Regards,

Laurent Pinchart

