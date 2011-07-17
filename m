Return-path: <linux-media-owner@vger.kernel.org>
Received: from linux-sh.org ([111.68.239.195]:50939 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1GQNQa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 09:16:30 -0400
Date: Sun, 17 Jul 2011 22:16:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] V4L: sh_mobile_csi2: switch away from using the soc-camera bus notifier
Message-ID: <20110717131625.GA14100@linux-sh.org>
References: <Pine.LNX.4.64.1107160135500.27399@axis700.grange> <Pine.LNX.4.64.1107160203380.27399@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107160203380.27399@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 16, 2011 at 02:13:54AM +0200, Guennadi Liakhovetski wrote:
> This moves us one more step closer to eliminating the soc-camera bus
> and devices on it. Besides, as a side effect, CSI-2 runtime PM on
> sh-mobile secomes finer grained now: we only have to power on the
> interface, when the device nodes are open.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  arch/arm/mach-shmobile/board-ap4evb.c      |   12 +--
>  drivers/media/video/sh_mobile_ceu_camera.c |  117 ++++++++++++++++++------
>  drivers/media/video/sh_mobile_csi2.c       |  135 +++++++++++++++-------------
>  include/media/sh_mobile_ceu.h              |   10 ++-
>  include/media/sh_mobile_csi2.h             |    8 +-
>  5 files changed, 180 insertions(+), 102 deletions(-)

Acked-by: Paul Mundt <lethal@linux-sh.org>
