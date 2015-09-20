Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53529 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbbITPZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2015 11:25:44 -0400
Date: Sun, 20 Sep 2015 17:25:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH 0/4] atmel-isi: Remove platform data support
In-Reply-To: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1509201715180.30819@axis700.grange>
References: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Josh,

It's ok not to CC me immediately if it's expected, that patches will be 
further forwarded (by Josh in this case) to me. And it helps, that Josh 
has collected all Atmel ISI patches in a git tree branch - thanks! But, 
please make sure, that all patches also appear in my mailbox at least 
once, especially if they are (even trivially) modified - like in this 
case, where patches 2 and 3 have been merged into 1.

Thanks
Guennadi

On Sat, 1 Aug 2015, Laurent Pinchart wrote:

> Hello,
> 
> While reviewing patches for the atmel-isi I noticed a couple of small issues
> with the driver. Here's a patch series to fix them, the main change being the
> removal of platform data support now that all users have migrated to DT.
> 
> The patches have been compile-tested only. Josh, would you be able to test
> them on hardware ?
> 
> Laurent Pinchart (4):
>   v4l: atmel-isi: Simplify error handling during DT parsing
>   v4l: atmel-isi: Remove unused variable
>   v4l: atmel-isi: Remove support for platform data
>   v4l: atmel-isi: Remove unused platform data fields
> 
>  drivers/media/platform/soc_camera/atmel-isi.c |  40 ++------
>  drivers/media/platform/soc_camera/atmel-isi.h | 126 +++++++++++++++++++++++++
>  include/media/atmel-isi.h                     | 131 --------------------------
>  3 files changed, 136 insertions(+), 161 deletions(-)
>  create mode 100644 drivers/media/platform/soc_camera/atmel-isi.h
>  delete mode 100644 include/media/atmel-isi.h
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
