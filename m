Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:48742 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbKXCl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 21:41:58 -0500
Date: Tue, 24 Nov 2015 11:41:52 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/4] VSP1: Add support for lookup tables
Message-ID: <20151124024151.GC21853@verge.net.au>
References: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 16, 2015 at 06:46:41AM +0200, Laurent Pinchart wrote:
> Hello,
> 
> The VSP1 includes two lookup table modules, a 1D LUT and a 3D cubic lookup
> table (CLU). This patch series fixes the LUT implementation and adds support
> for the CLU.
> 
> The patches are based on top of
> 
> 	git://linuxtv.org/media_tree.git master
> 
> and have been tested on a Koelsch board.
> 
> Laurent Pinchart (4):
>   v4l: vsp1: Fix LUT format setting
>   v4l: vsp1: Add Cubic Look Up Table (CLU) support
>   ARM: Renesas: r8a7790: Enable CLU support in VSPS
>   ARM: Renesas: r8a7791: Enable CLU support in VSPS

I marked the "ARM: Renesas:" patches as deferred pending the binding
being accepted.

I know we are moving towards "Renesas:" but could you stick to "shmobile"
for now?
