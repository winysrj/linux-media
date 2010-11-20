Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51892 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0KTRak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 12:30:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Cohen <david.cohen@nokia.com>
Subject: Re: [omap3isp RFC][PATCH 0/4] Improve inter subdev interaction
Date: Sat, 20 Nov 2010 18:30:45 +0100
Cc: ext Sergio Aguirre <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1290209031-12817-1-git-send-email-saaguirre@ti.com> <20101120114426.GG13186@esdhcp04381.research.nokia.com>
In-Reply-To: <20101120114426.GG13186@esdhcp04381.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011201830.45770.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi David,

On Saturday 20 November 2010 12:44:27 David Cohen wrote:
> On Sat, Nov 20, 2010 at 12:23:47AM +0100, ext Sergio Aguirre wrote:
> > Hi,
> > 
> > These are some patches to make these operations more generic:
> > - Clock control is being controlled in a very crude manner by
> > 
> >   subdevices, it should be centralized in isp.c.
> > 
> > - LSC prefetch wait check is reading a main ISP register, so move
> > 
> >   it to isp.c
> > 
> > - Abstract SBL busy check: we don't want a submodule thinkering
> > 
> >   with main ISP registers. That should be done in the main isp.c
> > 
> > Also, remove main ISP register dump from CSI2 specific dump. We
> > should be using isp_print_status if we'll like to know main ISP
> > regdump.
> > 
> > Comments are welcome. More cleanups for better subdevice isolation
> > are on the way.
> 
> Your patches are fine for me. I sent you some comments, but they are
> opitional and it's up to you to decide what to do. :)
> You can copy linux-omap@ as well in future patches.

I will try to submit the next version of the omap3isp driver for upstream 
review, either at the end of the weekend or on Monday. I will cross-post the 
driver to linux-media, linux-omap and LKML. Let's be ready to defend the media 
controller and the omap3isp driver :-)

Until then let's not spam linux-omap with patches for a driver they don't know 
about.

-- 
Regards,

Laurent Pinchart
