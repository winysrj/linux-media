Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:40958 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751644AbeFWIRD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 04:17:03 -0400
Subject: Re: [PATCH v2 1/2] media: add helpers for memory-to-memory media
 controller
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com
References: <20180621203828.18173-1-ezequiel@collabora.com>
 <20180621203828.18173-2-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b098060d-b06f-78bc-4503-2571fddbd46c@xs4all.nl>
Date: Sat, 23 Jun 2018 10:16:57 +0200
MIME-Version: 1.0
In-Reply-To: <20180621203828.18173-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/21/2018 10:38 PM, Ezequiel Garcia wrote:
> A memory-to-memory pipeline device consists in three
> entities: two DMA engine and one video processing entities.
> The DMA engine entities are linked to a V4L interface.
> 
> This commit add a new v4l2_m2m_{un}register_media_controller
> API to register this topology.
> 
> For instance, a typical mem2mem device topology would
> look like this:
> 
> Device topology
> - entity 1: source (1 pad, 1 link)
>             type Node subtype V4L flags 0
> 	pad0: Source
> 		-> "proc":1 [ENABLED,IMMUTABLE]
> 
> - entity 3: proc (2 pads, 2 links)
>             type Node subtype Unknown flags 0
> 	pad0: Source
> 		-> "sink":0 [ENABLED,IMMUTABLE]
> 	pad1: Sink
> 		<- "source":0 [ENABLED,IMMUTABLE]
> 
> - entity 6: sink (1 pad, 1 link)
>             type Node subtype V4L flags 0
> 	pad0: Sink
> 		<- "proc":0 [ENABLED,IMMUTABLE]
> 
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c     |  13 +-
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 174 +++++++++++++++++++++++++
>  include/media/v4l2-mem2mem.h           |  19 +++
>  include/uapi/linux/media.h             |   3 +
>  4 files changed, 204 insertions(+), 5 deletions(-)
> 

<snip>

> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index c7e9a5cba24e..5f58c7ac04c0 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -132,6 +132,9 @@ struct media_device_info {
>  #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
>  #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
>  #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
> +#define MEDIA_ENT_F_PROC_VIDEO_DECODER		(MEDIA_ENT_F_BASE + 0x4007)
> +#define MEDIA_ENT_F_PROC_VIDEO_ENCODER		(MEDIA_ENT_F_BASE + 0x4008)
> +#define MEDIA_ENT_F_PROC_VIDEO_DEINTERLACER	(MEDIA_ENT_F_BASE + 0x4009)
>  
>  /*
>   * Switch and bridge entity functions
> 

This last chunk is unrelated to this patch series.

May I suggest that you post this as a separate patch, together with an update to
the documentation (media-types.rst), that sits on top of:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=media-missing2

That branch reformats the tables in media-types.rst, making it easier to add new
entries. In addition it already has one patch adding a new function ("media.h: add
MEDIA_ENT_F_DTV_ENCODER"). I'm happy to add your patch to this series and to
include it in the eventual pull request. The patches in this branch were also
posted to the mailinglist:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg132942.html

Otherwise this patch looks great (after swapping the source/sink pad order).

Regards,

	Hans
