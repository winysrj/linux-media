Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39199 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbbDGJnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 05:43:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	sakari.ailus@iki.fi
Subject: Re: [PATCH 07/14] media: omap3isp: remove unused clkdev
Date: Tue, 07 Apr 2015 12:42:52 +0300
Message-ID: <1894989.AGoQvgsks0@avalon>
In-Reply-To: <20150405142034.GG4027@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk> <36620233.VbNiGUfDRt@avalon> <20150405142034.GG4027@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Russell,

On Sunday 05 April 2015 15:20:34 Russell King - ARM Linux wrote:
> On Sat, Apr 04, 2015 at 12:44:35AM +0300, Laurent Pinchart wrote:
> > Hi Russell,
> > 
> > Thank you for the patch;
> > 
> > On Friday 03 April 2015 18:12:58 Russell King wrote:
> > > No merged platform supplies xclks via platform data.  As we want to
> > > slightly change the clkdev interface, rather than fixing this unused
> > > code, remove it instead.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > with one caveat though : it conflicts with patches queued for v4.1 in the
> > media tree. I'll post a rebased version in a reply to your e-mail. How
> > would you like to handle the conflict ?
> 
> How bad is the conflict?

It's not too bad, it's mostly a context-related conflict. There are two 
additional lines to remove (plus the associated comment) from isp_xclk_init(), 
as your patch makes a loop now terminate with if (condition) continue;. Those 
two lines could be removed later, keeping them doesn't break anything.

-- 
Regards,

Laurent Pinchart

