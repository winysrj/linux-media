Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45388 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbbHMUOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 16:14:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helen Fornazier <helen.fornazier@gmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 1/7] [media] tpg: Export the tpg code from vivid as a module
Date: Thu, 13 Aug 2015 23:15:34 +0300
Message-ID: <7236024.9XNTnTKUZn@avalon>
In-Reply-To: <c6b24212e7473fb6132ff2118a87fdb53e077457.1438891530.git.helen.fornazier@gmail.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com> <c6b24212e7473fb6132ff2118a87fdb53e077457.1438891530.git.helen.fornazier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Thank you for the patch. I just have a couple of small comments.

On Thursday 06 August 2015 17:26:08 Helen Fornazier wrote:
> The test pattern generator will be used by other drivers as the virtual
> media controller (vimc)
> 
> Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
> ---
>  drivers/media/platform/Kconfig                  |    2 +
>  drivers/media/platform/Makefile                 |    1 +
>  drivers/media/platform/tpg/Kconfig              |    5 +
>  drivers/media/platform/tpg/Makefile             |    3 +
>  drivers/media/platform/tpg/tpg-colors.c         | 1181 ++++++++++++
>  drivers/media/platform/tpg/tpg-core.c           | 2211 ++++++++++++++++++++
>  drivers/media/platform/vivid/Kconfig            |    1 +
>  drivers/media/platform/vivid/Makefile           |    2 +-
>  drivers/media/platform/vivid/vivid-core.h       |    2 +-
>  drivers/media/platform/vivid/vivid-tpg-colors.c | 1182 ------------
>  drivers/media/platform/vivid/vivid-tpg-colors.h |   68 -
>  drivers/media/platform/vivid/vivid-tpg.c        | 2191 --------------------
>  drivers/media/platform/vivid/vivid-tpg.h        |  596 ------
>  include/media/tpg-colors.h                      |   68 +
>  include/media/tpg.h                             |  595 ++++++
>  15 files changed, 4069 insertions(+), 4039 deletions(-)
>  create mode 100644 drivers/media/platform/tpg/Kconfig
>  create mode 100644 drivers/media/platform/tpg/Makefile
>  create mode 100644 drivers/media/platform/tpg/tpg-colors.c
>  create mode 100644 drivers/media/platform/tpg/tpg-core.c
>  delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.c
>  delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.h
>  delete mode 100644 drivers/media/platform/vivid/vivid-tpg.c
>  delete mode 100644 drivers/media/platform/vivid/vivid-tpg.h
>  create mode 100644 include/media/tpg-colors.h
>  create mode 100644 include/media/tpg.h

[snip]

> drivers diff --git a/drivers/media/platform/tpg/Makefile
> b/drivers/media/platform/tpg/Makefile new file mode 100644
> index 0000000..01f2212
> --- /dev/null
> +++ b/drivers/media/platform/tpg/Makefile
> @@ -0,0 +1,3 @@
> +tpg-objs := tpg-core.o tpg-colors.o
> +
> +obj-$(CONFIG_VIDEO_TPG) += tpg.o

I would call the module video-tpg, just tpg is a bit too generic.

[snip]

> diff --git a/include/media/tpg.h b/include/media/tpg.h
> new file mode 100644
> index 0000000..6dc79fb
> --- /dev/null
> +++ b/include/media/tpg.h
> @@ -0,0 +1,595 @@
> +/*
> + * tpg.h - Test Pattern Generator
> + *
> + * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights
> reserved.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _TPG_H_
> +#define _TPG_H_

For the same reason I'd use _MEDIA_TPG_H_ here, and for consistency, 
_MEDIA_TPG_COLORS_H_ for tpg-colors.h.

-- 
Regards,

Laurent Pinchart

