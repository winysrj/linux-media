Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53225 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab1DSJow (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 05:44:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Let's submit mt9p031 to mainline.
Date: Tue, 19 Apr 2011 11:45:14 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
References: <BANLkTinpwQtRgVvirgm7NdtaSceNbbVLaw@mail.gmail.com> <Pine.LNX.4.64.1104191132540.16641@axis700.grange> <BANLkTikrPQBKWdgvsFWNF8ZURTAf3Mfd3A@mail.gmail.com>
In-Reply-To: <BANLkTikrPQBKWdgvsFWNF8ZURTAf3Mfd3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191145.14671.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 19 April 2011 11:42:47 javier Martin wrote:
> > Sure, feel free to grab this
> > 
> > http://download.open-technology.de/BeagleBoard_xM-MT9P031/
> > 
> > follow instructions in the text file and update the sources. I'll be
> > happy, if you manage to mainline it yourself, since I'm currently under a
> > pretty severe time-pressure.
> 
> Thanks, I'll do my best.
> 
> >> What kernel are you using? In 2.6.38 usb works fine for me in the
> >> Beagleboard xM.
> > 
> > No, 2.6.38 is no good, it doesn't have MC / omap3isp in it.
> 
> What GIT repository + branch should I use for developing then?

2.6.39-rc, or the linuxtv.org media-tree.git repository.

-- 
Regards,

Laurent Pinchart
