Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:42941 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1BNMvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:51:10 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v7 00/11] Sub-device pad-level operations
Date: Mon, 14 Feb 2011 13:51:26 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686084-9715-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686084-9715-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141351.26130.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series is:

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

On Monday, February 14, 2011 13:21:13 Laurent Pinchart wrote:
> Hi everybody,
> 
> Here's the seventh version of the sub-device pad-level operations patches.
> The patches are just rebased on top of 2.6.38-rc4.
> 
> Antti Koskipaa (1):
>   v4l: v4l2_subdev userspace crop API
> 
> Laurent Pinchart (9):
>   v4l: Move the media/v4l2-mediabus.h header to include/linux
>   v4l: Replace enums with fixed-sized fields in public structure
>   v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
>   v4l: Group media bus pixel codes by types and sort them
>     alphabetically
>   v4l: subdev: Add new file operations
>   v4l: v4l2_subdev pad-level operations
>   v4l: v4l2_subdev userspace format API - documentation binary files
>   v4l: v4l2_subdev userspace format API
>   v4l: v4l2_subdev userspace frame interval API
> 
> Stanimir Varbanov (1):
>   v4l: Create v4l2 subdev file handle structure
> 
>  Documentation/DocBook/Makefile                     |    5 +-
>  Documentation/DocBook/media-entities.tmpl          |   26 +
>  Documentation/DocBook/v4l/bayer.pdf                |  Bin 0 -> 12116 bytes
>  Documentation/DocBook/v4l/bayer.png                |  Bin 0 -> 9725 bytes
>  Documentation/DocBook/v4l/dev-subdev.xml           |  313 +++
>  Documentation/DocBook/v4l/pipeline.pdf             |  Bin 0 -> 20276 bytes
>  Documentation/DocBook/v4l/pipeline.png             |  Bin 0 -> 12130 bytes
>  Documentation/DocBook/v4l/subdev-formats.xml       | 2416 
++++++++++++++++++++
>  Documentation/DocBook/v4l/v4l2.xml                 |    7 +
>  Documentation/DocBook/v4l/vidioc-streamon.xml      |    9 +
>  .../v4l/vidioc-subdev-enum-frame-interval.xml      |  152 ++
>  .../DocBook/v4l/vidioc-subdev-enum-frame-size.xml  |  154 ++
>  .../DocBook/v4l/vidioc-subdev-enum-mbus-code.xml   |  119 +
>  Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml |  155 ++
>  Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml  |  180 ++
>  .../DocBook/v4l/vidioc-subdev-g-frame-interval.xml |  141 ++
>  drivers/media/Kconfig                              |    9 +
>  drivers/media/video/mt9m001.c                      |    2 +-
>  drivers/media/video/mt9v022.c                      |    4 +-
>  drivers/media/video/ov6650.c                       |   10 +-
>  drivers/media/video/sh_mobile_csi2.c               |    6 +-
>  drivers/media/video/soc_mediabus.c                 |    2 +-
>  drivers/media/video/v4l2-subdev.c                  |  192 ++-
>  include/linux/Kbuild                               |    2 +
>  include/linux/v4l2-mediabus.h                      |   94 +
>  include/linux/v4l2-subdev.h                        |  141 ++
>  include/media/soc_mediabus.h                       |    3 +-
>  include/media/v4l2-mediabus.h                      |   61 +-
>  include/media/v4l2-subdev.h                        |   61 +
>  29 files changed, 4159 insertions(+), 105 deletions(-)
>  create mode 100644 Documentation/DocBook/v4l/bayer.pdf
>  create mode 100644 Documentation/DocBook/v4l/bayer.png
>  create mode 100644 Documentation/DocBook/v4l/dev-subdev.xml
>  create mode 100644 Documentation/DocBook/v4l/pipeline.pdf
>  create mode 100644 Documentation/DocBook/v4l/pipeline.png
>  create mode 100644 Documentation/DocBook/v4l/subdev-formats.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-
interval.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-
size.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-
code.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-frame-
interval.xml
>  create mode 100644 include/linux/v4l2-mediabus.h
>  create mode 100644 include/linux/v4l2-subdev.h
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
> 
