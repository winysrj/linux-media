Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:58152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1FGH3x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 03:29:53 -0400
Date: Tue, 7 Jun 2011 09:29:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-media@vger.kernel.org, Kassey Lee <ygli@marvell.com>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH 1/7] marvell-cam: Move cafe-ccic into its own directory
In-Reply-To: <1307400003-94758-2-git-send-email-corbet@lwn.net>
Message-ID: <Pine.LNX.4.64.1106070908100.31635@axis700.grange>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
 <1307400003-94758-2-git-send-email-corbet@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 6 Jun 2011, Jonathan Corbet wrote:

> This driver will soon become a family of drivers, so let's give it its own
> place to live.  This move requires putting ov7670.h into include/media, but
> there are no code changes.

Please, use the "-M" option for "git format-patch" or "git send-email", 
whichever you use. This would make this patch much smaller and better 
suitable for review. For now we'll assume really nothing has changed 
here;) This might, however, eventually be the correct format for patch 
submission, but it's certainly not very well suitable for review.

Thanks
Guennadi

> 
> Cc: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/Kconfig                       |   11 +-
>  drivers/media/video/Makefile                      |    2 +-
>  drivers/media/video/cafe_ccic-regs.h              |  166 --
>  drivers/media/video/cafe_ccic.c                   | 2267 ---------------------
>  drivers/media/video/marvell-ccic/Kconfig          |    9 +
>  drivers/media/video/marvell-ccic/Makefile         |    1 +
>  drivers/media/video/marvell-ccic/cafe_ccic-regs.h |  166 ++
>  drivers/media/video/marvell-ccic/cafe_ccic.c      | 2267 +++++++++++++++++++++
>  drivers/media/video/ov7670.c                      |    3 +-
>  drivers/media/video/ov7670.h                      |   20 -
>  include/media/ov7670.h                            |   20 +
>  11 files changed, 2467 insertions(+), 2465 deletions(-)
>  delete mode 100644 drivers/media/video/cafe_ccic-regs.h
>  delete mode 100644 drivers/media/video/cafe_ccic.c
>  create mode 100644 drivers/media/video/marvell-ccic/Kconfig
>  create mode 100644 drivers/media/video/marvell-ccic/Makefile
>  create mode 100644 drivers/media/video/marvell-ccic/cafe_ccic-regs.h
>  create mode 100644 drivers/media/video/marvell-ccic/cafe_ccic.c
>  delete mode 100644 drivers/media/video/ov7670.h
>  create mode 100644 include/media/ov7670.h

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
