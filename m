Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:57510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2KJN4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Nov 2012 08:56:13 -0500
Date: Sat, 10 Nov 2012 14:56:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Carmignani Dario <carmignani.dario@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: mt9t031-VPFE integration issues...
In-Reply-To: <509E4FE2.3020901@gmail.com>
Message-ID: <Pine.LNX.4.64.1211101434490.13812@axis700.grange>
References: <Pine.LNX.4.64.0910030105570.6075@axis700.grange>
 <509E3B5C.6020300@gmail.com> <Pine.LNX.4.64.1211101334070.13812@axis700.grange>
 <509E4FE2.3020901@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 10 Nov 2012, Carmignani Dario wrote:

> Hi,
> 
> thanks for the answer.
> 
> Sorry, but I actually have not so clear how I can use soc-camera sensor driver
> with, for example, vpfe for dm365.
> 
> Can you please give me some hints?

Sorry, I'm not working with those systems. I don't even have access to 
non-soc-camera systems with soc-camera-based sensors. Basically you'll 
have to take a mainline camera-enabled dm365-based board (if there are 
any) as an example and use struct soc_camera_link as platform data for the 
ov772x driver. I think, Laurent (cc'ed) has a git-tree online somewhere 
with an example, using soc-camera originated sensor drivers with a 
non-soc-camera system. Try to find his mail about this on the list.

Thanks
Guennadi

> Thanks very much
> 
> Dario
> 
> > ------------------------------------------------------------------------
> > 
> > 	Guennadi Liakhovetski <mailto:g.liakhovetski@gmx.de>
> > 10 novembre 2012 13:44
> > 
> > 
> > > Hi,
> > > 
> > > I've just wrote you a while ago.
> > > 
> > > I'm working on a different sensor, but that is based on soc-camera
> > > framework
> > > as well: ov772x.
> > > 
> > > I've tried to remove in the ov772x driver the most part of the dependecy
> > > from
> > > soc-camera. But I guess that I've remove also the bus negotiation, without
> > > substituting it with something else.
> > > 
> > > Have you tried to do something similar on MT9t031 sensor?
> > 
> > In principle it's not too difficult to use soc-camera sensor drivers with
> > non-soc-camera hosts, it should be possible already now without any sensor
> > driver (most drivers, including ov772x; mt9t031 would be a bit more
> > difficult because of its power management, but if you don't need it, it
> > can be disabled) modifications. However, currencly such driver re-use is
> > not very elegant or natural. Work is in progress to improve it. So, you
> > can either try now or wait until those improvements are in place, don't
> > hold your breath though.
> > 
> > Thanks
> > Guennadi
> > 
> > > Thanks in advance
> > > 
> > > 
> > > Regards,
> > > 
> > > Dario
> > > 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> > ------------------------------------------------------------------------
> > 
> > 	Carmignani Dario <mailto:carmignani.dario@gmail.com>
> > 10 novembre 2012 12:32
> > 
> > 
> > Hi,
> > 
> > I've just wrote you a while ago.
> > 
> > I'm working on a different sensor, but that is based on soc-camera framework
> > as well: ov772x.
> > 
> > I've tried to remove in the ov772x driver the most part of the dependecy
> > from soc-camera. But I guess that I've remove also the bus negotiation,
> > without substituting it with something else.
> > 
> > Have you tried to do something similar on MT9t031 sensor?
> > 
> > Thanks in advance
> > 
> > 
> > Regards,
> > 
> > Dario
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
