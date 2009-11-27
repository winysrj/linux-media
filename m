Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51569 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752556AbZK0OhJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 09:37:09 -0500
Date: Fri, 27 Nov 2009 15:37:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 3/3] pxa_camera: remove init() callback
In-Reply-To: <20091127153230.d042d92e.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0911271535580.4383@axis700.grange>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
 <1258495463-26029-4-git-send-email-ospite@studenti.unina.it>
 <Pine.LNX.4.64.0911271503460.4383@axis700.grange>
 <20091127153230.d042d92e.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Nov 2009, Antonio Ospite wrote:

> On Fri, 27 Nov 2009 15:06:53 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Tue, 17 Nov 2009, Antonio Ospite wrote:
> > 
> > > pxa_camera init() callback is sometimes abused to setup MFP for PXA CIF, or
> > > even to request GPIOs to be used by the camera *sensor*. These initializations
> > > can be performed statically in machine init functions.
> > > 
> > > The current semantics for this init() callback is ambiguous anyways, it is
> > > invoked in pxa_camera_activate(), hence at device node open, but its users use
> > > it like a generic initialization to be done at module init time (configure
> > > MFP, request GPIOs for *sensor* control).
> > > 
> > > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> > 
> > Antonio, to make the merging easier and avoid imposing extra dependencies, 
> > I would postpone this to 2.6.34, and just remove uses of .init() by 
> > pxa-camera users as per your other two patches. Would this be ok with you?
> > 
> > Thanks
> > Guennadi
> >
> 
> Perfectly fine with me.
> 
> Feel also free to anticipate me and edit the commit messages to
> whatever you want in the first two patches. Now that we aren't removing
> init() immediately after these it makes even more sense to change the
> phrasing from a future referencing
> 	"init() is going to be removed"
> to a more present focused
> 	"better not to use init() at all"
> form.

I cannot edit those subject lines, because I will not be handling those 
patches, they will go via the PXA tree, that's why it is easier to wait 
with the pxa patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
