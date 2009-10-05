Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44779 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751021AbZJEPV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 11:21:26 -0400
Date: Mon, 5 Oct 2009 17:20:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] SH: add support for the RJ54N1CB0C camera for the
 kfr2r09 platform
In-Reply-To: <20091005022500.GD3185@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0910051719040.4337@axis700.grange>
References: <Pine.LNX.4.64.0910031319320.5857@axis700.grange>
 <Pine.LNX.4.64.0910031320170.5857@axis700.grange> <20091005022500.GD3185@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 5 Oct 2009, Paul Mundt wrote:

> On Sat, Oct 03, 2009 at 01:21:30PM +0200, Guennadi Liakhovetski wrote:
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  arch/sh/boards/mach-kfr2r09/setup.c |  139 +++++++++++++++++++++++++++++++++++
> >  1 files changed, 139 insertions(+), 0 deletions(-)
> > 
> This seems to depend on the RJ54N1CB0C driver, so I'll queue this up
> after that has been merged in the v4l tree. If it's available on a topic
> branch upstream that isn't going to be rebased, then I can pull that in,
> but this is not so critical either way.

It actually shouldn't depend on the driver patch. The driver has no 
headers, so... I haven't verified, but it should work either way. OTOH, 
waiting for the driver patch is certainly a safe bet:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
