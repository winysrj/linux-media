Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58157 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbbKQRma (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 12:42:30 -0500
Date: Tue, 17 Nov 2015 15:42:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.5] Fixes and new ti-vpe/cal driver
Message-ID: <20151117154225.36ab4aea@recife.lan>
In-Reply-To: <56499B7C.5090603@xs4all.nl>
References: <56499B7C.5090603@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Nov 2015 10:01:48 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Please note that this patch series assumes that my previous pull request was
> merged first:
> 
> https://patchwork.linuxtv.org/patch/31872/
> 
> This is for the v4l2-pci-skeleton patch. The other three are independent of
> the previous pull request.
> 
> Regards,
> 
> 	Hans
> 
> 
> The following changes since commit 54adb10d0947478b3364640a131fff1f1ab190fa:
> 
>   v4l2-dv-timings: add new arg to v4l2_match_dv_timings (2015-11-13 14:15:55 +0100)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.5b
> 
> for you to fetch changes up to 2cb88733214e31c04d1a87a1ef51cc6f26a44e09:
> 
>   media: v4l: ti-vpe: Document CAL driver (2015-11-16 09:50:13 +0100)
> 
> ----------------------------------------------------------------
> Benoit Parrot (2):
>       media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
>       media: v4l: ti-vpe: Document CAL driver

I prefer if you could put new drivers on separate pull requests.
Reviewing new drivers take more time ;)

By putting them on a separate series, I can fast track the patch
series with more trivial patches. Otherwise, I may need to delay
the entire patch series review, specially when I'm more focused on
applying misc patches and trivial bug fixes or don't have enough
time to do a driver's review.

> 
> Hans Verkuil (1):
>       v4l2-pci-skeleton.c: forgot to update v4l2_match_dv_timings call

This patch depends on the patch that needs to be fixed from your
previous pull request series.

> 
> Julia Lawall (1):
>       i2c: constify v4l2_ctrl_ops structures

This one is trivial. Applied.

Thanks,
Mauro

> 
>  Documentation/devicetree/bindings/media/ti-cal.txt |   70 +++
>  Documentation/video4linux/v4l2-pci-skeleton.c      |    2 +-
>  drivers/media/i2c/mt9m032.c                        |    2 +-
>  drivers/media/i2c/mt9p031.c                        |    2 +-
>  drivers/media/i2c/mt9t001.c                        |    2 +-
>  drivers/media/i2c/mt9v011.c                        |    2 +-
>  drivers/media/i2c/mt9v032.c                        |    2 +-
>  drivers/media/i2c/ov2659.c                         |    2 +-
>  drivers/media/platform/Kconfig                     |   12 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/ti-vpe/Makefile             |    4 +
>  drivers/media/platform/ti-vpe/cal.c                | 2164 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/platform/ti-vpe/cal_regs.h           |  779 +++++++++++++++++++++++++++++++++
>  13 files changed, 3038 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt
>  create mode 100644 drivers/media/platform/ti-vpe/cal.c
>  create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
