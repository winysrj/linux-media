Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62105 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2JELh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 07:37:56 -0400
Date: Fri, 5 Oct 2012 13:37:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Rob Herring <robherring2@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Philipp Zabel <pza@pengutronix.de>
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
In-Reply-To: <201210051331.18586.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1210051335390.13761@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <506CA5F7.3060807@gmail.com> <Pine.LNX.4.64.1210051119420.13761@axis700.grange>
 <201210051331.18586.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Oct 2012, Hans Verkuil wrote:

> On Fri October 5 2012 11:43:27 Guennadi Liakhovetski wrote:
> > On Wed, 3 Oct 2012, Rob Herring wrote:
> > 
> > > On 10/02/2012 09:33 AM, Guennadi Liakhovetski wrote:
> > > > Hi Rob
> > > > 
> > > > On Tue, 2 Oct 2012, Rob Herring wrote:
> > > > 
> > > >> On 09/27/2012 09:07 AM, Guennadi Liakhovetski wrote:

[snip]

> > > >>> +Optional link properties:
> > > >>> +- remote: phandle to the other endpoint link DT node.
> > > >>
> > > >> This name is a little vague. Perhaps "endpoint" would be better.
> > > > 
> > > > "endpoint" can also refer to something local like in USB case. Maybe 
> > > > rather the description of the "remote" property should be improved?
> > > 
> > > remote-endpoint?
> > 
> > Sorry, I really don't want to pull in yet another term here. We've got 
> > ports and links already, now you're proposing to also use "endpoind." 
> > Until now everyone was happy with "remote," any more opinions on this?
> 
> Actually, when I was reviewing the patch series today I got confused as
> well by 'remote'. What about 'remote-link'?

Yes, I was thinking about this one too, it looks a bit clumsy, but it does 
make it clearer, what is meant.

> And v4l2_of_get_remote() can be renamed to v4l2_of_get_remote_link() which
> I think is a lot clearer.
> 
> The text can be improved as well since this:
> 
> - remote: phandle to the other endpoint link DT node.
> 
> is a bit vague. How about:
> 
> - remote-link: phandle to the remote end of this link.

Looks good to me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
