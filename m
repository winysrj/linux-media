Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:41295 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752597Ab1LSXUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 18:20:51 -0500
Message-ID: <4EEFC6D0.4070907@gmx.de>
Date: Mon, 19 Dec 2011 23:20:48 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v5 0/3] fbdev: Add FOURCC-based format configuration API
References: <1323781348-9884-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1323781348-9884-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/13/2011 01:02 PM, Laurent Pinchart wrote:
> Hi everybody,
> fbdev: Add FOURCC-based format configuration API
> Here's the fifth version of the fbdev FOURCC-based format configuration API.

Applied this series.


Thanks and congratulations,

Florian Tobias Schandinat

> 
> Compared to the fourth version,
> 
> - fb_set_var() now checks that the red, green, blue and transp fields are all
> set to 0 when using the FOURCC-based API and return an error if they are not
> 
> - the NV24 and NV42 format documentation doesn't include emacs formatting
> directives anymore.
> 
> As usual the fbdev-test tool supporting this new API is available in the
> fbdev-test yuv branch at
> http://git.ideasonboard.org/?p=fbdev-test.git;a=shortlog;h=refs/heads/yuv.
> 
> Laurent Pinchart (3):
>   fbdev: Add FOURCC-based format configuration API
>   v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
>   fbdev: sh_mobile_lcdc: Support FOURCC-based format API
> 
>  Documentation/DocBook/media/v4l/pixfmt-nv24.xml |  121 ++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml      |    1 +
>  Documentation/fb/api.txt                        |  306 +++++++++++++++++++
>  arch/arm/mach-shmobile/board-ag5evm.c           |    2 +-
>  arch/arm/mach-shmobile/board-ap4evb.c           |    4 +-
>  arch/arm/mach-shmobile/board-mackerel.c         |    4 +-
>  arch/sh/boards/mach-ap325rxa/setup.c            |    2 +-
>  arch/sh/boards/mach-ecovec24/setup.c            |    2 +-
>  arch/sh/boards/mach-kfr2r09/setup.c             |    2 +-
>  arch/sh/boards/mach-migor/setup.c               |    4 +-
>  arch/sh/boards/mach-se/7724/setup.c             |    2 +-
>  drivers/video/fbmem.c                           |   14 +
>  drivers/video/sh_mobile_lcdcfb.c                |  360 +++++++++++++++--------
>  include/linux/fb.h                              |   14 +-
>  include/linux/videodev2.h                       |    2 +
>  include/video/sh_mobile_lcdc.h                  |    4 +-
>  16 files changed, 707 insertions(+), 137 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml
>  create mode 100644 Documentation/fb/api.txt
> 

