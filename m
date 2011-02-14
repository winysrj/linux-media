Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:8680 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1BNMwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:52:50 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 0/6] Misc V4L2 patches for the OMAP3 ISP driver
Date: Mon, 14 Feb 2011 13:53:18 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141353.18106.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series is:

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

On Monday, February 14, 2011 13:21:24 Laurent Pinchart wrote:
> Hi everybody,
> 
> Here are six miscellaneous patches to the V4L2 core that are required by the
> OMAP3 ISP driver. They mostly add new format codes, as well as a new subdev
> sensor operation.
> 
> The "v4l: Add subdev sensor g_skip_frames operation" patch has been 
discussed
> on the linux-media mailing list and acked.
> 
> The patches are based on top of 2.6.38-rc4.
> 
> Laurent Pinchart (6):
>   v4l: subdev: Generic ioctl support
>   v4l: Add subdev sensor g_skip_frames operation
>   v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
>   v4l: Add remaining RAW10 patterns w DPCM pixel code variants
>   v4l: Add missing 12 bits bayer media bus formats
>   v4l: Add 12 bits bayer pixel formats
> 
>  Documentation/DocBook/v4l/subdev-formats.xml |   51 
++++++++++++++++++++++++++
>  Documentation/video4linux/v4l2-framework.txt |    5 +++
>  drivers/media/video/v4l2-subdev.c            |    2 +-
>  include/linux/v4l2-mediabus.h                |   18 ++++++++-
>  include/linux/videodev2.h                    |    4 ++
>  include/media/v4l2-subdev.h                  |    4 ++
>  6 files changed, 81 insertions(+), 3 deletions(-)
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
