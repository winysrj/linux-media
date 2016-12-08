Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45412 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbcLHOJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 09:09:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH 3/5] media: Rename graph and pipeline structs and functions
Date: Thu, 08 Dec 2016 16:09:14 +0200
Message-ID: <1775652.IsROeFlImz@avalon>
In-Reply-To: <1480082146-25991-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com> <1480082146-25991-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 25 Nov 2016 15:55:44 Sakari Ailus wrote:
> The media_entity_pipeline_start() and media_entity_pipeline_stop()
> functions are renamed as media_pipeline_start() and media_pipeline_stop(),
> respectively. The reason is two-fold: the pipeline struct is, rightly,
> already called media_pipeline (rather than media_entity_pipeline) and what
> this really is about is a pipeline. A pipeline consists of entities ---
> and, well, other objects embedded in these entities.
> 
> As the pipeline object will be in the future moved from entities to pads
> in order to support multiple pipelines through a single entity, do the
> renaming now.
> 
> Similarly, functions operating on struct media_entity_graph as well as the
> struct itself are renamed by dropping the "entity_" part from the prefix
> of the function family and the data structure. The graph traversal which
> is what the functions are about is not specifically about entities only
> and will operate on pads for the same reason as the media pipeline.
> 
> The patch has been generated using the following command:
> 
> git grep -l media_entity |xargs perl -i -pe '
> 	s/media_entity_pipeline/media_pipeline/g;
> 	s/media_entity_graph/media_graph/g'
> 
> And a few manual edits related to line start alignment and line wrapping.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/media/kapi/mc-core.rst               | 18 ++---
>  drivers/media/media-device.c                       |  8 +--
>  drivers/media/media-entity.c                       | 77 ++++++++++---------
>  drivers/media/platform/exynos4-is/fimc-capture.c   |  8 +--
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |  8 +--
>  drivers/media/platform/exynos4-is/fimc-lite.c      |  8 +--
>  drivers/media/platform/exynos4-is/media-dev.c      | 16 ++---
>  drivers/media/platform/exynos4-is/media-dev.h      |  2 +-
>  drivers/media/platform/omap3isp/ispvideo.c         | 16 ++---
>  drivers/media/platform/s3c-camif/camif-capture.c   |  6 +-
>  drivers/media/platform/vsp1/vsp1_drm.c             |  4 +-
>  drivers/media/platform/vsp1/vsp1_video.c           | 16 ++---
>  drivers/media/platform/xilinx/xilinx-dma.c         | 16 ++---
>  drivers/media/usb/au0828/au0828-core.c             |  4 +-
>  drivers/media/v4l2-core/v4l2-mc.c                  | 18 ++---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    | 25 ++++---
>  drivers/staging/media/davinci_vpfe/vpfe_video.h    |  2 +-
>  drivers/staging/media/omap4iss/iss_video.c         | 32 ++++-----
>  include/media/media-device.h                       |  2 +-
>  include/media/media-entity.h                       | 65 +++++++++---------
>  20 files changed, 174 insertions(+), 177 deletions(-)

-- 
Regards,

Laurent Pinchart

