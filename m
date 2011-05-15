Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41970 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1EOHpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 03:45:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL FOR 2.6.40] v4l2 subdev driver for Samsung S5P MIPI CSI receiver
Date: Sun, 15 May 2011 09:46:05 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <4DCD592E.8060302@samsung.com>
In-Reply-To: <4DCD592E.8060302@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105150946.05466.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

On Friday 13 May 2011 18:15:42 Sylwester Nawrocki wrote:
> Hi Mauro,
> 
> The following changes since commit
> f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
> 
>   [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09
> 05:47:20 +0200)
> 
> are available in the git repository at:
>   git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p-csis
> 
> Sylwester Nawrocki (3):
>       v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
>       v4l: Move s5p-fimc driver into Video capture devices
>       v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers
> 
> It's a new driver for MIPI CSI receiver available in S5PVxxx/EXYNOS4 SoCs.
> The first patch adds definition of a media bus code for JPEG format.
> 
> I've done three further driver amendments comparing to the last (v5)
> version posted on the mailing lists, i.e.:
>  - slightly improved description of struct csis_state
>  - moved the pad number check from __s5pcsis_get_format directly to
> set_fmt/get_fmt pad level operation handlers
>  - replaced __init attribute of s5pcsis_probe() with __devinit and added
>    __devexit for s5pcsis_remove()

I've reviewed the patches yesterday, I think there's still a couple of small 
issues you might want to address.

> 
> Gitweb:
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/head
> s/s5p-csis
> 
>  Documentation/DocBook/v4l/subdev-formats.xml |   46 ++
>  drivers/media/video/Kconfig                  |   28 +-
>  drivers/media/video/s5p-fimc/Makefile        |    6 +-
>  drivers/media/video/s5p-fimc/mipi-csis.c     |  725
> ++++++++++++++++++++++++++ drivers/media/video/s5p-fimc/mipi-csis.h     | 
>  22 +
>  include/linux/v4l2-mediabus.h                |    3 +
>  6 files changed, 820 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.c
>  create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.h

-- 
Regards,

Laurent Pinchart
