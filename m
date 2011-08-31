Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48155 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab1HaVak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 17:30:40 -0400
Date: Thu, 1 Sep 2011 00:30:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v2 0/8] RFC for Media Controller capture driver for
 DM365
Message-ID: <20110831213032.GT12368@valkosipuli.localdomain>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

Do you have the media device grap that would be typical for this hardware
produced by media-ctl? That can be converted to postscript using dotfile.

this would make it a little easier to understan this driver. Thanks.

On Mon, Aug 29, 2011 at 08:37:11PM +0530, Manjunath Hadli wrote:
> changes from last patch set:
> 1. Made changes based on Sakari's feedback mainly:
>         a. returned early to allow unindenting
>         b. reformatting to shift the code to left where possible
>         c. changed hex numbers to lower case
>         d. corrected the defines according to module names.
>         e. magic numbers removed.
>         f. changed non-integer returning functions to void
>         g. removed unwanted paranthses.
>         h. fixed error codes.
>         i. fixed some RESET_BIt code to what it was intended for.
> 2. reorganized the header files to move the kernel-only headers
> along with the c files and interface headers in the include folder.
> 
> Manjunath Hadli (6):
>   davinci: vpfe: add dm3xx IPIPEIF hardware support module
>   davinci: vpfe: add support for CCDC hardware for dm365
>   davinci: vpfe: add ccdc driver with media controller interface
>   davinci: vpfe: add v4l2 video driver support
>   davinci: vpfe: v4l2 capture driver with media interface
>   davinci: vpfe: build infrastructure for dm365
> 
> Nagabhushana Netagunte (2):
>   davinci: vpfe: add IPIPE hardware layer support
>   davinci: vpfe: add IPIPE support for media controller driver
> 
>  drivers/media/video/davinci/Kconfig           |   46 +-
>  drivers/media/video/davinci/Makefile          |   17 +-
>  drivers/media/video/davinci/ccdc_hw_device.h  |   10 +-
>  drivers/media/video/davinci/ccdc_types.h      |   43 +
>  drivers/media/video/davinci/dm365_ccdc.c      | 1519 ++++++++++
>  drivers/media/video/davinci/dm365_ccdc.h      |   88 +
>  drivers/media/video/davinci/dm365_ccdc_regs.h |  309 ++
>  drivers/media/video/davinci/dm365_def_para.c  |  486 +++
>  drivers/media/video/davinci/dm365_def_para.h  |   39 +
>  drivers/media/video/davinci/dm365_ipipe.c     | 3966 +++++++++++++++++++++++++
>  drivers/media/video/davinci/dm365_ipipe.h     |  300 ++
>  drivers/media/video/davinci/dm365_ipipe_hw.c  |  949 ++++++
>  drivers/media/video/davinci/dm365_ipipe_hw.h  |  539 ++++
>  drivers/media/video/davinci/dm3xx_ipipeif.c   |  317 ++
>  drivers/media/video/davinci/dm3xx_ipipeif.h   |  258 ++
>  drivers/media/video/davinci/imp_common.h      |   85 +
>  drivers/media/video/davinci/imp_hw_if.h       |  178 ++
>  drivers/media/video/davinci/vpfe_capture.c    |  793 +++++
>  drivers/media/video/davinci/vpfe_capture.h    |  104 +
>  drivers/media/video/davinci/vpfe_ccdc.c       |  813 +++++
>  drivers/media/video/davinci/vpfe_ccdc.h       |   85 +
>  drivers/media/video/davinci/vpfe_video.c      | 1712 +++++++++++
>  drivers/media/video/davinci/vpfe_video.h      |  142 +
>  include/linux/davinci_vpfe.h                  | 1223 ++++++++
>  include/linux/dm365_ccdc.h                    |  664 +++++
>  include/linux/dm3xx_ipipeif.h                 |   64 +
>  include/media/davinci/vpfe.h                  |   91 +
>  27 files changed, 14829 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/media/video/davinci/ccdc_types.h
>  create mode 100644 drivers/media/video/davinci/dm365_ccdc.c
>  create mode 100644 drivers/media/video/davinci/dm365_ccdc.h
>  create mode 100644 drivers/media/video/davinci/dm365_ccdc_regs.h
>  create mode 100644 drivers/media/video/davinci/dm365_def_para.c
>  create mode 100644 drivers/media/video/davinci/dm365_def_para.h
>  create mode 100644 drivers/media/video/davinci/dm365_ipipe.c
>  create mode 100644 drivers/media/video/davinci/dm365_ipipe.h
>  create mode 100644 drivers/media/video/davinci/dm365_ipipe_hw.c
>  create mode 100644 drivers/media/video/davinci/dm365_ipipe_hw.h
>  create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
>  create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.h
>  create mode 100644 drivers/media/video/davinci/imp_common.h
>  create mode 100644 drivers/media/video/davinci/imp_hw_if.h
>  create mode 100644 drivers/media/video/davinci/vpfe_capture.c
>  create mode 100644 drivers/media/video/davinci/vpfe_capture.h
>  create mode 100644 drivers/media/video/davinci/vpfe_ccdc.c
>  create mode 100644 drivers/media/video/davinci/vpfe_ccdc.h
>  create mode 100644 drivers/media/video/davinci/vpfe_video.c
>  create mode 100644 drivers/media/video/davinci/vpfe_video.h
>  create mode 100644 include/linux/davinci_vpfe.h
>  create mode 100644 include/linux/dm365_ccdc.h
>  create mode 100644 include/linux/dm3xx_ipipeif.h
>  create mode 100644 include/media/davinci/vpfe.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
sakari.ailus@iki.fi
