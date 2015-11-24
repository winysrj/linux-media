Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41095 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbKXXuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2015 18:50:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/4] VSP1: Add support for lookup tables
Date: Wed, 25 Nov 2015 01:50:09 +0200
Message-ID: <4999881.SYOHnPD9Ad@avalon>
In-Reply-To: <20151124024151.GC21853@verge.net.au>
References: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20151124024151.GC21853@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Tuesday 24 November 2015 11:41:52 Simon Horman wrote:
> On Mon, Nov 16, 2015 at 06:46:41AM +0200, Laurent Pinchart wrote:
> > Hello,
> > 
> > The VSP1 includes two lookup table modules, a 1D LUT and a 3D cubic lookup
> > table (CLU). This patch series fixes the LUT implementation and adds
> > support for the CLU.
> > 
> > The patches are based on top of
> > 
> > 	git://linuxtv.org/media_tree.git master
> > 
> > and have been tested on a Koelsch board.
> > 
> > Laurent Pinchart (4):
> >   v4l: vsp1: Fix LUT format setting
> >   v4l: vsp1: Add Cubic Look Up Table (CLU) support
> >   ARM: Renesas: r8a7790: Enable CLU support in VSPS
> >   ARM: Renesas: r8a7791: Enable CLU support in VSPS
> 
> I marked the "ARM: Renesas:" patches as deferred pending the binding
> being accepted.

I'll resend the patches once the dependencies will be accepted.

> I know we are moving towards "Renesas:" but could you stick to "shmobile"
> for now?

Sure.

-- 
Regards,

Laurent Pinchart

