Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47140 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758885AbZFKMNG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 08:13:06 -0400
Date: Thu, 11 Jun 2009 14:13:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: [PATCH 1/4] V4L2: add a new V4L2_CID_BAND_STOP_FILTER integer
 control
In-Reply-To: <200906111403.01021.laurent.pinchart@skynet.be>
Message-ID: <Pine.LNX.4.64.0906111410590.5625@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
 <Pine.LNX.4.64.0906101558090.4817@axis700.grange> <200906111403.01021.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Jun 2009, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Thursday 11 June 2009 09:12:37 Guennadi Liakhovetski wrote:
> > Add a new V4L2_CID_BAND_STOP_FILTER integer control, which either switches
> > the band-stop filter off, or sets it to a certain strength.
> 
> I'm quoting your e-mail from 2009-05-27:
> 
> > COMJ[2] - Band filter enable. After adjust frame rate to match indoor
> > light frequency, this bit enable a different exposure algorithm to cut
> > light band induced by fluorescent light.
> 
> As Nate pointed out, that seems to some kind of anti-flicker control and not a 
> band stop filter.

Well, it _is_ a band-stop filter, at least this is how it is referred to 
in the docs. It might be serving as an anti-flicker control, don't know, 
if that's going to be the consensus, we can rename it, sure.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
