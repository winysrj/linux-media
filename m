Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:49179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1E3GVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 02:21:17 -0400
Date: Mon, 30 May 2011 08:21:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Chris Rodley <carlighting@yahoo.co.nz>
cc: javier.martin@vista-silicon.com, koen@beagleboard.org,
	beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with
 power managament.
In-Reply-To: <290776.52536.qm@web112005.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.64.1105300819320.29224@axis700.grange>
References: <290776.52536.qm@web112005.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 29 May 2011, Chris Rodley wrote:

> On 29/05/11 03:04, Guennadi Liakhovetski wrote:
> > On Sat, 28 May 2011, Guennadi Liakhovetski wrote:
> >
> >> Hi Javier
> >>
> >> On Thu, 26 May 2011, javier Martin wrote:
> >>
> >>> I use a patched version of yavta and Mplayer to see video
> >>> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/)
> >>
> >> Are you really using those versions and patches, as described in 
> >> BBxM-MT9P031.txt? I don't think those versions still work with 2.6.39, 
> >> they don't even compile for me. Whereas if I take current HEAD, it builds 
> >> and media-ctl seems to run error-free, but yavta produces no output.
> >
> > Ok, sorry for the noise. It works with current media-ctl with no patches, 
> > so, we better don't try to confuse our users / testers:)
> >
> > Thanks
> > Guennadi
> 
> Hi,
> 
> Still no luck getting the v3 patch working.
> I did go back and re-test the first v1 patch that Javier released.
> This works fine with the same version of media-ctl and yavta.
> So it isn't either of those programs that is causing the problem.

It is. For 2.6.39 + v3 of Javier's patches you need a current media-ctl 
version unpatched. Interestingly, the new yavta version didn't work for 
me, but maybe I've done something wrong. The old (patched) version did 
work though.

> Must be something else.
> 
> Will wait and see how Koen goes.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
