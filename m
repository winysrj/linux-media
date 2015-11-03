Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55117 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754494AbbKCWmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2015 17:42:37 -0500
Date: Wed, 4 Nov 2015 00:42:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 07/19] media: Use the new media_entity_graph_walk_start()
Message-ID: <20151103224233.GL17128@valkosipuli.retiisi.org.uk>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
 <1445900510-1398-8-git-send-email-sakari.ailus@iki.fi>
 <20151028094343.009cbcf9@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151028094343.009cbcf9@concha.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Oct 28, 2015 at 09:43:43AM +0900, Mauro Carvalho Chehab wrote:
> Em Tue, 27 Oct 2015 01:01:38 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Please add some documentation at the body for all patches.
> 
> Btw, IMHO, it would be best to fold this patch and the following ones
> that are related to media_entity_graph_walk_init() altogether, as it
> makes easier to review if all places were covered.

I think patches such as the 8th are easier to review as they are.

For the coverage,

$ git grep -l -E '^	*media_entity_graph_walk_start' 
Documentation/media-framework.txt
drivers/media/media-entity.c
drivers/media/platform/exynos4-is/media-dev.c
drivers/media/platform/omap3isp/isp.c
drivers/media/platform/omap3isp/ispvideo.c
drivers/media/platform/vsp1/vsp1_video.c
drivers/media/platform/xilinx/xilinx-dma.c
drivers/staging/media/davinci_vpfe/vpfe_video.c
drivers/staging/media/omap4iss/iss.c
drivers/staging/media/omap4iss/iss_video.c

Which suggests that I'm probably missing a few patches, indeed. I'll take
that into account in the next submission.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
