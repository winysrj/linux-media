Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34141 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2GZXB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 19:01:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] mt9v032: Export horizontal and vertical blanking as V4L2 controls
Date: Fri, 27 Jul 2012 01:02:04 +0200
Message-ID: <4375414.cY8huNNgj1@avalon>
In-Reply-To: <20120726205401.GA26136@valkosipuli.retiisi.org.uk>
References: <1343068502-7431-4-git-send-email-laurent.pinchart@ideasonboard.com> <1343085042-19695-1-git-send-email-laurent.pinchart@ideasonboard.com> <20120726205401.GA26136@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 26 July 2012 23:54:01 Sakari Ailus wrote:
> On Tue, Jul 24, 2012 at 01:10:42AM +0200, Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/mt9v032.c |   36 +++++++++++++++++++++++++++++++++---
> >  1 files changed, 33 insertions(+), 3 deletions(-)
> > 
> > Changes since v1:
> > 
> > - Make sure the total horizontal time will not go below 660 when setting
> >   the horizontal blanking control
> > 
> > - Restrict the vertical blanking value to 3000 as documented in the
> >   datasheet. Increasing the exposure time actually extends vertical
> >   blanking, as long as the user doesn't forget to turn auto-exposure
> >   off...
> 
> Does binning either horizontally or vertically affect the blanking limits?
> If the process is analogue then the answer is typically "yes".

The datasheet doesn't specify whether binning and blanking can influence each 
other.

> It's not directly related to this patch, but the effect of the driver just
> exposing one sub-device really shows better now. Besides lacking the way to
> specify binning as in the V4L2 subdev API (compose selection target), the
> user also can't use the crop bounds selection target to get the size of the
> pixel array.
> 
> We could either accept this for the time being and fix it later on of fix it
> now.
> 
> I prefer fixing it right now but admit that this patch isn't breaking
> anything, it rather is missing quite relevant functionality to control the
> sensor in a generic way.

I'd rather apply this patch first, as it doesn't break anything :-) Fixing the 
problem will require discussions, and that will take time.

Binning/skipping is a pretty common feature in sensors. Exposing two sub-
devices like the SMIA++ driver does is one way to fix the problem, but do we 
really want to do that for the vast majority of sensors ?

-- 
Regards,

Laurent Pinchart

