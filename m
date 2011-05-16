Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49220 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1EPTv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 15:51:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 0/3 v6] Add v4l2 subdev driver for Samsung S5P MIPI-CSI receivers
Date: Mon, 16 May 2011 21:53:02 +0200
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, kgene.kim@samsung.com,
	sungchun.kang@samsung.com, jonghun.han@samsung.com
References: <1305547539-13194-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1305547539-13194-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105162153.03314.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

On Monday 16 May 2011 14:05:36 Sylwester Nawrocki wrote:
> Hello,
> 
> I'm resending this MIPI-CSI slave device driver patch to address review
> comments and fix a few further minor issues. My apologies for spamming a
> mailbox to those who are not interested.

For the whole patch set,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Changes since v5:
>  - slightly improved description of struct csis_state
>  - moved the pad number check from __s5pcsis_get_format directly to
> set_fmt/get_fmt pad level operation handlers
>  - replaced __init attribute of s5pcsis_probe() with __devinit and added
>    __devexit for s5pcsis_remove()
>  - fixed bug in s5pcsis_set_hsync_settle, improved set_fmt handler
> 
> [PATCH 1/3] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
> [PATCH 2/3] v4l: Move s5p-fimc driver into Video capture devices
> [PATCH 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI
> 
> Documentation/DocBook/v4l/subdev-formats.xml |   46 ++
>  drivers/media/video/Kconfig                  |   28 +-
>  drivers/media/video/Makefile                 |    1 +
>  drivers/media/video/s5p-fimc/Makefile        |    6 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c  |   10 +-
>  drivers/media/video/s5p-fimc/mipi-csis.c     |  726
> ++++++++++++++++++++++++++ drivers/media/video/s5p-fimc/mipi-csis.h     | 
>  22 +
>  include/linux/v4l2-mediabus.h                |    3 +
>  8 files changed, 827 insertions(+), 15 deletions(-)

-- 
Regards,

Laurent Pinchart
