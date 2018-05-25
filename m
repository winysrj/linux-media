Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030538AbeEYXKb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 19:10:31 -0400
Date: Fri, 25 May 2018 20:10:27 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180525201027.1d5c82eb@vento.lan>
In-Reply-To: <10831984.07PNLvckhh@avalon>
References: <10831984.07PNLvckhh@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 20 May 2018 15:10:50 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> The following changes since commit 8ed8bba70b4355b1ba029b151ade84475dd12991:
> 
>   media: imx274: remove non-indexed pointers from mode_table (2018-05-17 
> 06:22:08 -0400)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/pinchartl/media.git v4l2/vsp1/next
> 
> for you to fetch changes up to 429f256501652c90a4ed82f2416618f82a77d37c:
> 
>   media: vsp1: Move video configuration to a cached dlb (2018-05-20 09:46:51 
> +0300)
> 
> The branch passes the VSP and DU test suites, both on its own and when merged 
> with the drm-next branch.

This series added a new warning:

drivers/media/platform/vsp1/vsp1_dl.c:69: warning: Function parameter or member 'refcnt' not described in 'vsp1_dl_body'

To the already existing one:

drivers/media/platform/vsp1/vsp1_drm.c:336 vsp1_du_pipeline_setup_brx() error: we previously assumed 'pipe->brx' could be null (see line 244)

(there's also a Spectre warning too, but I'll looking into those
in separate).

For now, I'll apply it, but I reserve the right of not pulling any
new patchsets that would add more warnings.



> 
> ----------------------------------------------------------------
> Geert Uytterhoeven (1):
>       media: vsp1: Drop OF dependency of VIDEO_RENESAS_VSP1
> 
> Kieran Bingham (10):
>       media: vsp1: Release buffers for each video node
>       media: vsp1: Move video suspend resume handling to video object
>       media: vsp1: Reword uses of 'fragment' as 'body'
>       media: vsp1: Protect bodies against overflow
>       media: vsp1: Provide a body pool
>       media: vsp1: Convert display lists to use new body pool
>       media: vsp1: Use reference counting for bodies
>       media: vsp1: Refactor display list configure operations
>       media: vsp1: Adapt entities to configure into a body
>       media: vsp1: Move video configuration to a cached dlb
> 
>  drivers/media/platform/Kconfig            |   2 +-
>  drivers/media/platform/vsp1/vsp1_brx.c    |  32 ++--
>  drivers/media/platform/vsp1/vsp1_clu.c    | 113 ++++++-----
>  drivers/media/platform/vsp1/vsp1_clu.h    |   1 +
>  drivers/media/platform/vsp1/vsp1_dl.c     | 388 ++++++++++++++++-------------
>  drivers/media/platform/vsp1/vsp1_dl.h     |  21 ++-
>  drivers/media/platform/vsp1/vsp1_drm.c    |  18 +-
>  drivers/media/platform/vsp1/vsp1_drv.c    |   4 +-
>  drivers/media/platform/vsp1/vsp1_entity.c |  34 +++-
>  drivers/media/platform/vsp1/vsp1_entity.h |  45 +++--
>  drivers/media/platform/vsp1/vsp1_hgo.c    |  26 ++-
>  drivers/media/platform/vsp1/vsp1_hgt.c    |  28 ++-
>  drivers/media/platform/vsp1/vsp1_hsit.c   |  20 +-
>  drivers/media/platform/vsp1/vsp1_lif.c    |  25 ++-
>  drivers/media/platform/vsp1/vsp1_lut.c    |  80 +++++---
>  drivers/media/platform/vsp1/vsp1_lut.h    |   1 +
>  drivers/media/platform/vsp1/vsp1_pipe.c   |  74 +-------
>  drivers/media/platform/vsp1/vsp1_pipe.h   |  12 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 189 ++++++++++---------
>  drivers/media/platform/vsp1/vsp1_sru.c    |  24 +--
>  drivers/media/platform/vsp1/vsp1_uds.c    |  73 +++----
>  drivers/media/platform/vsp1/vsp1_uds.h    |   2 +-
>  drivers/media/platform/vsp1/vsp1_uif.c    |  35 ++--
>  drivers/media/platform/vsp1/vsp1_video.c  | 177 ++++++++++++-----
>  drivers/media/platform/vsp1/vsp1_video.h  |   3 +
>  drivers/media/platform/vsp1/vsp1_wpf.c    | 326 ++++++++++++++-------------
>  26 files changed, 967 insertions(+), 786 deletions(-)
> 



Thanks,
Mauro
