Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33023 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1H2I3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 04:29:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH/RFC v2 3/3] fbdev: sh_mobile_lcdc: Support FOURCC-based format API
Date: Mon, 29 Aug 2011 10:30:00 +0200
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com> <1313746626-23845-4-git-send-email-laurent.pinchart@ideasonboard.com> <CANqRtoSozX5cPs1c2eqy=mcNi_qzVaVYb9Xmmgv8OOJRdUwWqg@mail.gmail.com>
In-Reply-To: <CANqRtoSozX5cPs1c2eqy=mcNi_qzVaVYb9Xmmgv8OOJRdUwWqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291030.02159.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Magnus,

On Monday 29 August 2011 02:39:06 Magnus Damm wrote:
> On Fri, Aug 19, 2011 at 6:37 PM, Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  arch/arm/mach-shmobile/board-ag5evm.c   |    2 +-
> >  arch/arm/mach-shmobile/board-ap4evb.c   |    4 +-
> >  arch/arm/mach-shmobile/board-mackerel.c |    4 +-
> >  drivers/video/sh_mobile_lcdcfb.c        |  342
> > ++++++++++++++++++++----------- include/video/sh_mobile_lcdc.h        
> >  |    4 +-
> >  5 files changed, 230 insertions(+), 126 deletions(-)
> 
> Hi Laurent, thanks for the patch!
> 
> Since you're changing the LCDC platform data please make sure you also
> update the 5 boards using the LCDC under arch/sh.

Sure. Sorry for forgetting about that.

-- 
Regards,

Laurent Pinchart
