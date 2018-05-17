Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46974 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbeEQJ6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 05:58:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v9 7/8] media: vsp1: Adapt entities to configure into a body
Date: Thu, 17 May 2018 12:58:46 +0300
Message-ID: <4978075.HTLm1iqz4m@avalon>
In-Reply-To: <17b49567300141edc849f55c39405d88aab3877e.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com> <17b49567300141edc849f55c39405d88aab3877e.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday, 3 May 2018 16:35:46 EEST Kieran Bingham wrote:
> Currently the entities store their configurations into a display list.
> Adapt this such that the code can be configured into a body directly,
> allowing greater flexibility and control of the content.
> 
> All users of vsp1_dl_list_write() are removed in this process, thus it
> too is removed.
> 
> A helper, vsp1_dl_list_get_body0() is provided to access the internal body0
> from the display list.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
> v9:
>  - Pass the DL through configure_partition() calls
> 
> v8:
>  - Fixed comment style and indentation
>  - Supported UIF
>  - Supported new configure_partition() functionality
> 
> v7:
>  - Rebase
>  - s/prepare/configure_stream/
>  - s/configure/configure_frame/
> ---
>  drivers/media/platform/vsp1/vsp1_brx.c    | 22 ++++++------
>  drivers/media/platform/vsp1/vsp1_clu.c    | 23 ++++++-------
>  drivers/media/platform/vsp1/vsp1_dl.c     | 12 ++-----
>  drivers/media/platform/vsp1/vsp1_dl.h     |  2 +-
>  drivers/media/platform/vsp1/vsp1_drm.c    | 12 ++++---
>  drivers/media/platform/vsp1/vsp1_entity.c | 22 ++++++------
>  drivers/media/platform/vsp1/vsp1_entity.h | 18 ++++++----
>  drivers/media/platform/vsp1/vsp1_hgo.c    | 16 ++++-----
>  drivers/media/platform/vsp1/vsp1_hgt.c    | 18 +++++-----
>  drivers/media/platform/vsp1/vsp1_hsit.c   | 10 ++---
>  drivers/media/platform/vsp1/vsp1_lif.c    | 15 ++++----
>  drivers/media/platform/vsp1/vsp1_lut.c    | 23 ++++++-------
>  drivers/media/platform/vsp1/vsp1_pipe.c   |  4 +-
>  drivers/media/platform/vsp1/vsp1_pipe.h   |  3 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 44 ++++++++++++------------
>  drivers/media/platform/vsp1/vsp1_sru.c    | 14 ++++----
>  drivers/media/platform/vsp1/vsp1_uds.c    | 25 +++++++-------
>  drivers/media/platform/vsp1/vsp1_uds.h    |  2 +-
>  drivers/media/platform/vsp1/vsp1_uif.c    | 21 +++++------
>  drivers/media/platform/vsp1/vsp1_video.c  | 16 ++++++---
>  drivers/media/platform/vsp1/vsp1_wpf.c    | 42 ++++++++++++-----------
>  21 files changed, 194 insertions(+), 170 deletions(-)

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
> b/drivers/media/platform/vsp1/vsp1_rpf.c index deb86cc235ef..8fae7c485642
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c

[snip]

> @@ -192,7 +195,6 @@ static void rpf_configure_partition(struct vsp1_entity
> *entity, const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
>  	const struct v4l2_pix_format_mplane *format = &rpf->format;
>  	struct v4l2_rect crop;
> -

No need to remove this blank line.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

There's no need to resubmit, I'll fix when applying.

>  	/*
>  	 * Source size and crop offsets.
>  	 *

[snip]

-- 
Regards,

Laurent Pinchart
