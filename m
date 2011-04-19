Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:51714 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1DSJfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 05:35:23 -0400
Date: Tue, 19 Apr 2011 11:35:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Let's submit mt9p031 to mainline.
In-Reply-To: <BANLkTi=GE9dEUY1kiTXEq00yw2imQvm93A@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1104191132540.16641@axis700.grange>
References: <BANLkTinpwQtRgVvirgm7NdtaSceNbbVLaw@mail.gmail.com>
 <Pine.LNX.4.64.1104191118520.16641@axis700.grange>
 <BANLkTi=GE9dEUY1kiTXEq00yw2imQvm93A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 19 Apr 2011, javier Martin wrote:

> On 19 April 2011 11:19, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Tue, 19 Apr 2011, javier Martin wrote:
> >
> >> Hi,
> >> I finally received my LI-5M03 for the Beagleboard which includes mt9p031 sensor.
> >>
> >> I know Guennadi has somewhere an outdated version of a driver for it.
> >> I would like to help you out on updating the driver so that it can be
> >> submitted to mainline.
> >> Guennadi please, if you could point me out to that code I could start
> >> the job myself.
> >>
> >> Just one question: what GIT repository + branch should I choose to
> >> work on, so that we can seamlessly integrate the changes later?
> >
> > I wanted to update the code, but usb is currently broken on beagle-board,
> > so, I cannot work with it. I'm waiting for it to be fixed to continue with
> > that.
> >
> > Thanks
> > Guennadi
> 
> So you are planning to do it yourself.
> Is there anything I can do to help?

Sure, feel free to grab this

http://download.open-technology.de/BeagleBoard_xM-MT9P031/

follow instructions in the text file and update the sources. I'll be 
happy, if you manage to mainline it yourself, since I'm currently under a 
pretty severe time-pressure.

> What kernel are you using? In 2.6.38 usb works fine for me in the
> Beagleboard xM.

No, 2.6.38 is no good, it doesn't have MC / omap3isp in it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
