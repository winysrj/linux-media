Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:54336 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab0HSTJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 15:09:36 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Thu, 19 Aug 2010 14:09:30 -0500
Subject: RE: [RFC/PATCH v3 00/10] Media controller (core and V4L2)
Message-ID: <A24693684029E5489D1D202277BE89445718FC0B@dlee02.ent.ti.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Thursday, July 29, 2010 11:07 AM
> To: linux-media@vger.kernel.org
> Cc: sakari.ailus@maxwell.research.nokia.com
> Subject: [RFC/PATCH v3 00/10] Media controller (core and V4L2)
> 
> Hi everybody,
> 
> Here's the third version of the media controller patches. All comments
> received
> on the first and second versions have (hopefully) been incorporated.
> 
> The rebased V4L2 API additions and OMAP3 ISP patches will follow. Once
> again
> please consider them as sample code only.
> 
> Laurent Pinchart (8):
>   media: Media device node support
>   media: Media device
>   media: Entities, pads and links
>   media: Entities, pads and links enumeration
>   media: Links setup
>   v4l: Add a media_device pointer to the v4l2_device structure
>   v4l: Make video_device inherit from media_entity
>   v4l: Make v4l2_subdev inherit from media_entity

This patch (#0010) doesn't apply to mainline, after this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b74c0aac357e5c71ee6de98b9887fe478bc73cf4

Am I missing something here?

Regards,
Sergio

> 
> Sakari Ailus (2):
>   media: Entity graph traversal
>   media: Reference count and power handling
> 
>  Documentation/media-framework.txt            |  481 ++++++++++++++++++++
>  Documentation/video4linux/v4l2-framework.txt |   71 +++-
>  drivers/media/Makefile                       |    8 +-
>  drivers/media/media-device.c                 |  327 ++++++++++++++
>  drivers/media/media-devnode.c                |  326 ++++++++++++++
>  drivers/media/media-entity.c                 |  613
> ++++++++++++++++++++++++++
>  drivers/media/video/v4l2-dev.c               |   35 ++-
>  drivers/media/video/v4l2-device.c            |   45 ++-
>  drivers/media/video/v4l2-subdev.c            |   27 ++-
>  include/linux/media.h                        |   78 ++++
>  include/media/media-device.h                 |   70 +++
>  include/media/media-devnode.h                |   84 ++++
>  include/media/media-entity.h                 |  107 +++++
>  include/media/v4l2-dev.h                     |    6 +
>  include/media/v4l2-device.h                  |    2 +
>  include/media/v4l2-subdev.h                  |    7 +
>  16 files changed, 2265 insertions(+), 22 deletions(-)
>  create mode 100644 Documentation/media-framework.txt
>  create mode 100644 drivers/media/media-device.c
>  create mode 100644 drivers/media/media-devnode.c
>  create mode 100644 drivers/media/media-entity.c
>  create mode 100644 include/linux/media.h
>  create mode 100644 include/media/media-device.h
>  create mode 100644 include/media/media-devnode.h
>  create mode 100644 include/media/media-entity.h
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
