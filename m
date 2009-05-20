Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33266 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755507AbZETMHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 08:07:19 -0400
Date: Wed, 20 May 2009 14:07:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 02/10 v2] ARM: convert pcm037 to the new platform-device
 soc-camera interface
In-Reply-To: <20090520112358.GQ9288@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0905201356170.4423@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
 <Pine.LNX.4.64.0905151824040.4658@axis700.grange> <20090520073844.GP9288@pengutronix.de>
 <Pine.LNX.4.64.0905201059000.4423@axis700.grange> <20090520112358.GQ9288@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 May 2009, Sascha Hauer wrote:

> On Wed, May 20, 2009 at 11:01:46AM +0200, Guennadi Liakhovetski wrote:
> > On Wed, 20 May 2009, Sascha Hauer wrote:
> > 
> > > On Fri, May 15, 2009 at 07:19:10PM +0200, Guennadi Liakhovetski wrote:
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > ---
> > > > 
> > > > This is actually a completion to the other single patches I've sent 
> > > > earlier for various boards. As I said, pcm037 doesn't have all its 
> > > > outstanding patches in next yet, so, you'll need to collect them from 
> > > > trees / lists, or get them when I upload them.
> > > 
> > > As I haven't got camera support for pcm037 in my tree yet, you can
> > > combine this with the patch which adds camera support.
> > 
> > Hm, so, I will have to redo that:-(
> > 
> > > How are we going to sync this with the according changes to soc-camera?
> > 
> > As I already replied to Russell, there's just one requirement for _this_ 
> > patch - it has to go in after this one:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=2bda41a0e9d42cf977a99e8df4fd6e331bb4f50d
> 
> Ok, then Russell can pull my tree containing the camera patch for pcm037
> and he will take care of the correct order, right?

It would be correct, yes, if your tree was completely on one side of the 
above patch. But if you apply patches as you have them in your tree, i.e., 
first add camera support, then convert to platform driver, then Russell 
would have to first pull the first part of your tree, then v4l, then the 
econd part of your tree... which, I think, wouldn't be fair to require 
from him:-) so, you either would have to send him two pull requests with a 
request to pull v4l inbetween, or merge the two patches.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
