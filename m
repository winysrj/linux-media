Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52865 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867AbbHNMDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 08:03:09 -0400
Message-ID: <55CDD8DD.3010304@xs4all.nl>
Date: Fri, 14 Aug 2015 14:02:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 0/7] vimc: Virtual Media Control VPU's
References: <cover.1438891530.git.helen.fornazier@gmail.com>
In-Reply-To: <cover.1438891530.git.helen.fornazier@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2015 10:26 PM, Helen Fornazier wrote:
> * This patch series add to the vimc driver video processing units ad a debayer and a scaler.
> * The test pattern generator from vivid driver was exported as a module, as it is used by
>   the vimc driver as well.
> * The debayer transforms the bayer format image received in its sink pad to a bayer format
>   by avaraging the pixels within a mean window
> * The scaler only scales up the image for now.
> * The ioctls to configure the format in the pads were implemented to allow testing the pipe
>   from the user space
> 
> 
> The patch series is based on 'vimc/review/video-pipe' branch, it goes on top of the patch
> named "[media] vimc: Virtual Media Controller core, capture and sensor" and is available at
>         https://github.com/helen-fornazier/opw-staging vimc/review/vpu
> 
> Helen Fornazier (7):
>   [media] tpg: Export the tpg code from vivid as a module

Hmm, this one is missing.

When you move files you should use 'git mv' to do that and when creating
the patch series use the -M flag with format-patch. That will make git
smart about such moves and avoids a diff where the old file is fully
deleted and the new file fully added. The diff got too large because of
that, causing this patch to be dropped.

Regards,

	Hans

>   [media] vimc: sen: Integrate the tpg on the sensor
>   [media] vimc: Add vimc_ent_sd_init/cleanup helper functions
>   [media] vimc: Add vimc_pipeline_s_stream in the core
>   [media] vimc: deb: Add debayer filter
>   [media] vimc: sca: Add scaler subdevice
>   [media] vimc: Implement set format in the nodes
> 
>  drivers/media/platform/Kconfig                  |    2 +
>  drivers/media/platform/Makefile                 |    1 +
>  drivers/media/platform/tpg/Kconfig              |    5 +
>  drivers/media/platform/tpg/Makefile             |    3 +
>  drivers/media/platform/tpg/tpg-colors.c         | 1181 ++++++++++++
>  drivers/media/platform/tpg/tpg-core.c           | 2211 +++++++++++++++++++++++
>  drivers/media/platform/vimc/Kconfig             |    1 +
>  drivers/media/platform/vimc/Makefile            |    3 +-
>  drivers/media/platform/vimc/vimc-capture.c      |   88 +-
>  drivers/media/platform/vimc/vimc-core.c         |  196 +-
>  drivers/media/platform/vimc/vimc-core.h         |   29 +
>  drivers/media/platform/vimc/vimc-debayer.c      |  503 ++++++
>  drivers/media/platform/vimc/vimc-debayer.h      |   28 +
>  drivers/media/platform/vimc/vimc-scaler.c       |  362 ++++
>  drivers/media/platform/vimc/vimc-scaler.h       |   28 +
>  drivers/media/platform/vimc/vimc-sensor.c       |  175 +-
>  drivers/media/platform/vivid/Kconfig            |    1 +
>  drivers/media/platform/vivid/Makefile           |    2 +-
>  drivers/media/platform/vivid/vivid-core.h       |    2 +-
>  drivers/media/platform/vivid/vivid-tpg-colors.c | 1182 ------------
>  drivers/media/platform/vivid/vivid-tpg-colors.h |   68 -
>  drivers/media/platform/vivid/vivid-tpg.c        | 2191 ----------------------
>  drivers/media/platform/vivid/vivid-tpg.h        |  596 ------
>  include/media/tpg-colors.h                      |   68 +
>  include/media/tpg.h                             |  595 ++++++
>  25 files changed, 5345 insertions(+), 4176 deletions(-)
>  create mode 100644 drivers/media/platform/tpg/Kconfig
>  create mode 100644 drivers/media/platform/tpg/Makefile
>  create mode 100644 drivers/media/platform/tpg/tpg-colors.c
>  create mode 100644 drivers/media/platform/tpg/tpg-core.c
>  create mode 100644 drivers/media/platform/vimc/vimc-debayer.c
>  create mode 100644 drivers/media/platform/vimc/vimc-debayer.h
>  create mode 100644 drivers/media/platform/vimc/vimc-scaler.c
>  create mode 100644 drivers/media/platform/vimc/vimc-scaler.h
>  delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.c
>  delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.h
>  delete mode 100644 drivers/media/platform/vivid/vivid-tpg.c
>  delete mode 100644 drivers/media/platform/vivid/vivid-tpg.h
>  create mode 100644 include/media/tpg-colors.h
>  create mode 100644 include/media/tpg.h
> 

