Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39268 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757243AbZE0L2I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 07:28:08 -0400
Date: Wed, 27 May 2009 13:28:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Image filter controls
In-Reply-To: <5e9665e10905270406v5357d9d1xfacb67be9c9ec2d6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0905271312420.5154@axis700.grange>
References: <Pine.LNX.4.64.0905271207060.5154@axis700.grange>
 <5e9665e10905270406v5357d9d1xfacb67be9c9ec2d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 May 2009, Dongsoo, Nathaniel Kim wrote:

> Hi Guennadi,
> 
> In my opinion (in totally user aspect) those CIDs you mentioned do not
> fit in the purpose. Only low-pass filtering control could be
> considered as a colorfx, even though low-pass filtering is not a color
> effect it could be possible to sense the meaning of effect on it. How
> about making a new CID for band-stop filtering control and
> V4L2_COLORFX_BORDER_DENOISING for low-pass filter?

Maybe, let's see what others say. Although, the low-pass filter doesn't 
seem to be directly related to colour-transformation to me.

> BTW, would you give more information about "fluorescent light
> band-stop filter" in detail? Because if you mean flicker control
> caused by power line frequency, 50Hz...60Hz thing, I think we already
> have one for that. As far as I know, V4L2_CID_POWER_LINE_FREQUENCY is
> for that flickering control.

No, here's an excerpt from a datasheet (not for the camera I'm 
implementing this, but it's the same parameter, I think):

COMJ[2] - Band filter enable. After adjust frame rate to match indoor 
light frequency, this bit enable a different exposure algorithm to cut 
light band induced by fluorescent light.

Not sure though how they reduce the fluorescent light by adjusting the 
exposure algorithm.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
