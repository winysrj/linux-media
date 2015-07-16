Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38657 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbbGPPvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 11:51:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Tony Lindgren <tony@atomide.com>, mike@compulab.co.il,
	grinberg@compulab.co.il
Subject: Re: [PATCH 1/2] ARM: OMAP2+: Remove legacy OMAP3 ISP instantiation
Date: Thu, 16 Jul 2015 18:52:10 +0300
Message-ID: <2232801.mhgotKSpyF@avalon>
In-Reply-To: <55A7D192.7080301@iki.fi>
References: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com> <1437051319-9904-2-git-send-email-laurent.pinchart@ideasonboard.com> <55A7D192.7080301@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 16 July 2015 18:45:22 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > The OMAP3 ISP is now fully supported in DT, remove its instantiation
> > from C code.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  arch/arm/mach-omap2/devices.c | 53 --------------------------------------
> >  arch/arm/mach-omap2/devices.h | 19 ----------------
> >  2 files changed, 72 deletions(-)
> >  delete mode 100644 arch/arm/mach-omap2/devices.h
> 
> If you remove the definitions, arch/arm/mach-omap2/board-cm-t35.c will
> no longer compile. Could you remove the camera support there as well?
> 
> My understanding is the board might be supported in DT but I'm not sure
> about camera.
> 
> Cc Mike and Igor.

commit 11cd7b8c2773d01e4b40e38568ae62c471a2ea10
Author: Tony Lindgren <tony@atomide.com>
Date:   Mon May 4 10:48:07 2015 -0700

    ARM: OMAP2+: Remove legacy booting support for cm-t35


Merged in v4.2-rc1 :-)

-- 
Regards,

Laurent Pinchart

