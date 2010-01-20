Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0ATPAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 10:00:49 -0500
Message-ID: <4B571A9B.9000607@infradead.org>
Date: Wed, 20 Jan 2010 13:00:43 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <829197381001190204l3df81904gf8586f36187f212d@mail.gmail.com> <201001201454.00601.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201001201454.00601.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Devin,

> I totally agree with you here. We obviously don't support developers who still 
> want to use a 2.4.x kernel on their computer, so a line as to be drawn at some 
> point.

Currently, the backport starts on 2.6.16. I think it is ok to keep this as the
basis version.

> This being said, I think we should not base the v4l-dvb git tree on the very 
> latest Linus' tree. Linus himself stated during the LPC 2009 that subsystems 
> should not pull from his tree at random point, but should rather use main 
> kernel versions, or at least -rc versions. I think that basing the v4l-dvb 
> tree on top of the last tag from mainline would be a better practice than 
> pulling from it everyday.

A good compromise here would be to use the latest main kernel version for fix
patches that needs to go also to -stable and -rc1 for the other fixes and 
development patches.

> This will obviously not solve the issue you mention, which is why we still 
> need to agree on a nice way to handle backports, but that will make life 
> easier for developers who want to try the v4l-dvb subsystem on top of the most 
> recent kernel.

Agreed.

Cheers,
Mauro.

