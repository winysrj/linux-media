Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37051 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdLGKLH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 05:11:07 -0500
Received: by mail-wm0-f66.google.com with SMTP id f140so11810890wmd.2
        for <linux-media@vger.kernel.org>; Thu, 07 Dec 2017 02:11:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171205145239.17908-1-benjamin.gaignard@st.com>
References: <20171205145239.17908-1-benjamin.gaignard@st.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Thu, 7 Dec 2017 11:10:25 +0100
Message-ID: <CAOFm3uHx=9pjG9iODY=yiRTg3atPzhYjfyWBDhVnYOwtcybL8A@mail.gmail.com>
Subject: Re: [PATCH] media: platform: sti: Adopt SPDX identifier
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: fabien.dessenne@st.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        patrice.chotard@st.com, hugues.fruchet@st.com,
        jean-christophe.trotin@st.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 5, 2017 at 3:52 PM, Benjamin Gaignard
<benjamin.gaignard@linaro.org> wrote:
> Add SPDX identifiers to files under sti directory
>
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  drivers/media/platform/sti/bdisp/bdisp-debug.c           |  2 +-
>  drivers/media/platform/sti/bdisp/bdisp-filter.h          |  2 +-
>  drivers/media/platform/sti/bdisp/bdisp-hw.c              |  2 +-
>  drivers/media/platform/sti/bdisp/bdisp-reg.h             |  2 +-
>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c            |  2 +-
>  drivers/media/platform/sti/bdisp/bdisp.h                 |  2 +-
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c  |  5 +----
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h  |  5 +----
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c    |  5 +----
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.h    |  5 +----
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.c |  9 +--------
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.h |  9 +--------
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c     | 11 +----------
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.h     |  5 +----
>  drivers/media/platform/sti/cec/stih-cec.c                |  5 +----
>  drivers/media/platform/sti/delta/delta-cfg.h             |  2 +-
>  drivers/media/platform/sti/delta/delta-debug.c           |  2 +-
>  drivers/media/platform/sti/delta/delta-debug.h           |  2 +-
>  drivers/media/platform/sti/delta/delta-ipc.c             |  2 +-
>  drivers/media/platform/sti/delta/delta-ipc.h             |  2 +-
>  drivers/media/platform/sti/delta/delta-mem.c             |  2 +-
>  drivers/media/platform/sti/delta/delta-mem.h             |  2 +-
>  drivers/media/platform/sti/delta/delta-mjpeg-dec.c       |  2 +-
>  drivers/media/platform/sti/delta/delta-mjpeg-fw.h        |  2 +-
>  drivers/media/platform/sti/delta/delta-mjpeg-hdr.c       |  2 +-
>  drivers/media/platform/sti/delta/delta-mjpeg.h           |  2 +-
>  drivers/media/platform/sti/delta/delta-v4l2.c            |  2 +-
>  drivers/media/platform/sti/delta/delta.h                 |  2 +-
>  drivers/media/platform/sti/hva/hva-debugfs.c             |  2 +-
>  drivers/media/platform/sti/hva/hva-h264.c                |  2 +-
>  drivers/media/platform/sti/hva/hva-hw.c                  |  2 +-
>  drivers/media/platform/sti/hva/hva-hw.h                  |  2 +-
>  drivers/media/platform/sti/hva/hva-mem.c                 |  2 +-
>  drivers/media/platform/sti/hva/hva-mem.h                 |  2 +-
>  drivers/media/platform/sti/hva/hva-v4l2.c                |  2 +-
>  drivers/media/platform/sti/hva/hva.h                     |  2 +-
>  36 files changed, 36 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c b/drivers/media/platform/sti/bdisp/bdisp-debug.c
> index 2cc289e4dea1..c6a4e2de5c0c 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
> @@ -1,7 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2014
>   * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/debugfs.h>
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-filter.h b/drivers/media/platform/sti/bdisp/bdisp-filter.h
> index 53e52fb4127f..d25adb57e3d0 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-filter.h
> +++ b/drivers/media/platform/sti/bdisp/bdisp-filter.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2014
>   * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #define BDISP_HF_NB             64
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
> index b7892f3efd98..e7836b307d21 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
> @@ -1,7 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2014
>   * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/delay.h>
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-reg.h b/drivers/media/platform/sti/bdisp/bdisp-reg.h
> index e7e1a425f65a..b07ecc903707 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-reg.h
> +++ b/drivers/media/platform/sti/bdisp/bdisp-reg.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2014
>   * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  struct bdisp_node {
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> index 7e9ed9c7b3e1..bf4ca16db440 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> @@ -1,7 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2014
>   * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/errno.h>
> diff --git a/drivers/media/platform/sti/bdisp/bdisp.h b/drivers/media/platform/sti/bdisp/bdisp.h
> index b3fbf9902595..e309cde379ca 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp.h
> +++ b/drivers/media/platform/sti/bdisp/bdisp.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2014
>   * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/clk.h>
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c
> index 2dfbe8ab5214..c64909e5ab64 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * c8sectpfe-common.c - C8SECTPFE STi DVB driver
>   *
> @@ -5,10 +6,6 @@
>   *
>   *   Author: Peter Griffin <peter.griffin@linaro.org>
>   *
> - *      This program is free software; you can redistribute it and/or
> - *      modify it under the terms of the GNU General Public License as
> - *      published by the Free Software Foundation; either version 2 of
> - *      the License, or (at your option) any later version.
>   */
>  #include <linux/completion.h>
>  #include <linux/delay.h>
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h
> index da21c0ac0fc1..694f63832d3f 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * c8sectpfe-common.h - C8SECTPFE STi DVB driver
>   *
> @@ -5,10 +6,6 @@
>   *
>   *   Author: Peter Griffin <peter.griffin@linaro.org>
>   *
> - *      This program is free software; you can redistribute it and/or
> - *      modify it under the terms of the GNU General Public License as
> - *      published by the Free Software Foundation; either version 2 of
> - *      the License, or (at your option) any later version.
>   */
>  #ifndef _C8SECTPFE_COMMON_H_
>  #define _C8SECTPFE_COMMON_H_
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> index a0acee7671b1..d9a73d5c97fa 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * c8sectpfe-core.c - C8SECTPFE STi DVB driver
>   *
> @@ -6,10 +7,6 @@
>   *   Author:Peter Bennett <peter.bennett@st.com>
>   *         Peter Griffin <peter.griffin@linaro.org>
>   *
> - *     This program is free software; you can redistribute it and/or
> - *     modify it under the terms of the GNU General Public License as
> - *     published by the Free Software Foundation; either version 2 of
> - *     the License, or (at your option) any later version.
>   */
>  #include <linux/atomic.h>
>  #include <linux/clk.h>
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.h b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.h
> index 39e7a221a941..3dbb3a287cc0 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.h
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * c8sectpfe-core.h - C8SECTPFE STi DVB driver
>   *
> @@ -6,10 +7,6 @@
>   *   Author:Peter Bennett <peter.bennett@st.com>
>   *         Peter Griffin <peter.griffin@linaro.org>
>   *
> - *     This program is free software; you can redistribute it and/or
> - *     modify it under the terms of the GNU General Public License as
> - *     published by the Free Software Foundation; either version 2 of
> - *     the License, or (at your option) any later version.
>   */
>  #ifndef _C8SECTPFE_CORE_H_
>  #define _C8SECTPFE_CORE_H_
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.c
> index e9ba13db49cd..8f0ddcbeed9d 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.c
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * c8sectpfe-debugfs.c - C8SECTPFE STi DVB driver
>   *
> @@ -5,14 +6,6 @@
>   *
>   * Author: Peter Griffin <peter.griffin@linaro.org>
>   *
> - * This program is free software: you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2  of
> - * the License as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
>   */
>  #include <linux/debugfs.h>
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.h b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.h
> index 8af1ac1378c8..b8c30bcc8df9 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.h
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /**
>   * c8sectpfe-debugfs.h - C8SECTPFE STi DVB driver debugfs header
>   *
> @@ -5,14 +6,6 @@
>   *
>   * Authors: Peter Griffin <peter.griffin@linaro.org>
>   *
> - * This program is free software: you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2  of
> - * the License as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
>   */
>
>  #ifndef __C8SECTPFE_DEBUG_H
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
> index 2c0015b1264d..075d4695ee4d 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   *  c8sectpfe-dvb.c - C8SECTPFE STi DVB driver
>   *
> @@ -5,16 +6,6 @@
>   *
>   *  Author Peter Griffin <peter.griffin@linaro.org>
>   *
> - *  This program is free software; you can redistribute it and/or modify
> - *  it under the terms of the GNU General Public License as published by
> - *  the Free Software Foundation; either version 2 of the License, or
> - *  (at your option) any later version.
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *
> - *  GNU General Public License for more details.
>   */
>  #include <linux/completion.h>
>  #include <linux/delay.h>
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.h b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.h
> index bd366dbc82b3..3d87a9ae8702 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.h
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * c8sectpfe-common.h - C8SECTPFE STi DVB driver
>   *
> @@ -5,10 +6,6 @@
>   *
>   *   Author: Peter Griffin <peter.griffin@linaro.org>
>   *
> - *      This program is free software; you can redistribute it and/or
> - *      modify it under the terms of the GNU General Public License as
> - *      published by the Free Software Foundation; either version 2 of
> - *      the License, or (at your option) any later version.
>   */
>  #ifndef _C8SECTPFE_DVB_H_
>  #define _C8SECTPFE_DVB_H_
> diff --git a/drivers/media/platform/sti/cec/stih-cec.c b/drivers/media/platform/sti/cec/stih-cec.c
> index 70160df36de9..d34099f75990 100644
> --- a/drivers/media/platform/sti/cec/stih-cec.c
> +++ b/drivers/media/platform/sti/cec/stih-cec.c
> @@ -1,11 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * STIH4xx CEC driver
>   * Copyright (C) STMicroelectronics SA 2016
>   *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #include <linux/clk.h>
>  #include <linux/interrupt.h>
> diff --git a/drivers/media/platform/sti/delta/delta-cfg.h b/drivers/media/platform/sti/delta/delta-cfg.h
> index c6388f575800..f47c6e6ff083 100644
> --- a/drivers/media/platform/sti/delta/delta-cfg.h
> +++ b/drivers/media/platform/sti/delta/delta-cfg.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef DELTA_CFG_H
> diff --git a/drivers/media/platform/sti/delta/delta-debug.c b/drivers/media/platform/sti/delta/delta-debug.c
> index a7ebf2cc7783..4b2eb6b63aa2 100644
> --- a/drivers/media/platform/sti/delta/delta-debug.c
> +++ b/drivers/media/platform/sti/delta/delta-debug.c
> @@ -1,9 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Hugues Fruchet <hugues.fruchet@st.com>
>   *          Fabrice Lecoultre <fabrice.lecoultre@st.com>
>   *          for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include "delta.h"
> diff --git a/drivers/media/platform/sti/delta/delta-debug.h b/drivers/media/platform/sti/delta/delta-debug.h
> index 955c1587ac2d..fa90252623e1 100644
> --- a/drivers/media/platform/sti/delta/delta-debug.h
> +++ b/drivers/media/platform/sti/delta/delta-debug.h
> @@ -1,9 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Hugues Fruchet <hugues.fruchet@st.com>
>   *          Fabrice Lecoultre <fabrice.lecoultre@st.com>
>   *          for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef DELTA_DEBUG_H
> diff --git a/drivers/media/platform/sti/delta/delta-ipc.c b/drivers/media/platform/sti/delta/delta-ipc.c
> index 41e4a4c259b3..a4603d573c34 100644
> --- a/drivers/media/platform/sti/delta/delta-ipc.c
> +++ b/drivers/media/platform/sti/delta/delta-ipc.c
> @@ -1,7 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/rpmsg.h>
> diff --git a/drivers/media/platform/sti/delta/delta-ipc.h b/drivers/media/platform/sti/delta/delta-ipc.h
> index cef2019c72d4..9fba6b5d169a 100644
> --- a/drivers/media/platform/sti/delta/delta-ipc.h
> +++ b/drivers/media/platform/sti/delta/delta-ipc.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef DELTA_IPC_H
> diff --git a/drivers/media/platform/sti/delta/delta-mem.c b/drivers/media/platform/sti/delta/delta-mem.c
> index d7b53d31caa6..aeccd50583da 100644
> --- a/drivers/media/platform/sti/delta/delta-mem.c
> +++ b/drivers/media/platform/sti/delta/delta-mem.c
> @@ -1,7 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include "delta.h"
> diff --git a/drivers/media/platform/sti/delta/delta-mem.h b/drivers/media/platform/sti/delta/delta-mem.h
> index f8ca109e1241..ff7d02f00b28 100644
> --- a/drivers/media/platform/sti/delta/delta-mem.h
> +++ b/drivers/media/platform/sti/delta/delta-mem.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef DELTA_MEM_H
> diff --git a/drivers/media/platform/sti/delta/delta-mjpeg-dec.c b/drivers/media/platform/sti/delta/delta-mjpeg-dec.c
> index 84ea43c0eb46..0533d4a083d2 100644
> --- a/drivers/media/platform/sti/delta/delta-mjpeg-dec.c
> +++ b/drivers/media/platform/sti/delta/delta-mjpeg-dec.c
> @@ -1,7 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2013
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/slab.h>
> diff --git a/drivers/media/platform/sti/delta/delta-mjpeg-fw.h b/drivers/media/platform/sti/delta/delta-mjpeg-fw.h
> index de803d0c2fe8..5a9404f4d055 100644
> --- a/drivers/media/platform/sti/delta/delta-mjpeg-fw.h
> +++ b/drivers/media/platform/sti/delta/delta-mjpeg-fw.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef DELTA_MJPEG_FW_H
> diff --git a/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c b/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
> index a8fd8fa0ecb5..90e5b2f72c82 100644
> --- a/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
> +++ b/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
> @@ -1,7 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2013
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include "delta.h"
> diff --git a/drivers/media/platform/sti/delta/delta-mjpeg.h b/drivers/media/platform/sti/delta/delta-mjpeg.h
> index 18e6b37217ee..43f7a88b6e59 100644
> --- a/drivers/media/platform/sti/delta/delta-mjpeg.h
> +++ b/drivers/media/platform/sti/delta/delta-mjpeg.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2013
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef DELTA_MJPEG_H
> diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
> index b2dc3d223a9c..232d508c5b66 100644
> --- a/drivers/media/platform/sti/delta/delta-v4l2.c
> +++ b/drivers/media/platform/sti/delta/delta-v4l2.c
> @@ -1,9 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Hugues Fruchet <hugues.fruchet@st.com>
>   *          Jean-Christophe Trotin <jean-christophe.trotin@st.com>
>   *          for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/clk.h>
> diff --git a/drivers/media/platform/sti/delta/delta.h b/drivers/media/platform/sti/delta/delta.h
> index 60c073246a01..2ba99922c05b 100644
> --- a/drivers/media/platform/sti/delta/delta.h
> +++ b/drivers/media/platform/sti/delta/delta.h
> @@ -1,7 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef DELTA_H
> diff --git a/drivers/media/platform/sti/hva/hva-debugfs.c b/drivers/media/platform/sti/hva/hva-debugfs.c
> index 83a6258a155b..9f7e8ac875d1 100644
> --- a/drivers/media/platform/sti/hva/hva-debugfs.c
> +++ b/drivers/media/platform/sti/hva/hva-debugfs.c
> @@ -1,8 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/debugfs.h>
> diff --git a/drivers/media/platform/sti/hva/hva-h264.c b/drivers/media/platform/sti/hva/hva-h264.c
> index a7e5eed17ada..6b0b321db8cc 100644
> --- a/drivers/media/platform/sti/hva/hva-h264.c
> +++ b/drivers/media/platform/sti/hva/hva-h264.c
> @@ -1,8 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include "hva.h"
> diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
> index ec25bdcfa3d1..7917fd2c4bd4 100644
> --- a/drivers/media/platform/sti/hva/hva-hw.c
> +++ b/drivers/media/platform/sti/hva/hva-hw.c
> @@ -1,8 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/clk.h>
> diff --git a/drivers/media/platform/sti/hva/hva-hw.h b/drivers/media/platform/sti/hva/hva-hw.h
> index b46017dcfae9..b298990264d5 100644
> --- a/drivers/media/platform/sti/hva/hva-hw.h
> +++ b/drivers/media/platform/sti/hva/hva-hw.h
> @@ -1,8 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef HVA_HW_H
> diff --git a/drivers/media/platform/sti/hva/hva-mem.c b/drivers/media/platform/sti/hva/hva-mem.c
> index 821c78ed208c..caf50cd4bb77 100644
> --- a/drivers/media/platform/sti/hva/hva-mem.c
> +++ b/drivers/media/platform/sti/hva/hva-mem.c
> @@ -1,8 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include "hva.h"
> diff --git a/drivers/media/platform/sti/hva/hva-mem.h b/drivers/media/platform/sti/hva/hva-mem.h
> index a95c728a45e6..fec549dff2b3 100644
> --- a/drivers/media/platform/sti/hva/hva-mem.h
> +++ b/drivers/media/platform/sti/hva/hva-mem.h
> @@ -1,8 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef HVA_MEM_H
> diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
> index 1c4fc33cbcb5..2ab0b5cc5c22 100644
> --- a/drivers/media/platform/sti/hva/hva-v4l2.c
> +++ b/drivers/media/platform/sti/hva/hva-v4l2.c
> @@ -1,8 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #include <linux/module.h>
> diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
> index 0d749b257a21..8882d901d119 100644
> --- a/drivers/media/platform/sti/hva/hva.h
> +++ b/drivers/media/platform/sti/hva/hva.h
> @@ -1,8 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) STMicroelectronics SA 2015
>   * Authors: Yannick Fertre <yannick.fertre@st.com>
>   *          Hugues Fruchet <hugues.fruchet@st.com>
> - * License terms:  GNU General Public License (GPL), version 2
>   */
>
>  #ifndef HVA_H
> --
> 2.15.0
>

Thank you for using the simpler SPDX license ids!

Acked-by: Philippe Ombredanne <pombredanne@nexb.com>

-- 
Cordially
Philippe Ombredanne
