Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34672 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2H0JbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 05:31:20 -0400
Received: by vcbfk26 with SMTP id fk26so4154734vcb.19
        for <linux-media@vger.kernel.org>; Mon, 27 Aug 2012 02:31:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346068683-31610-1-git-send-email-arun.kk@samsung.com>
References: <1346068683-31610-1-git-send-email-arun.kk@samsung.com>
Date: Mon, 27 Aug 2012 15:01:19 +0530
Message-ID: <CAK9yfHwit2G3LpDZKx5yZ+zFGBkw3R3Jz+6YHDL-S7aCdnH_xw@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Update MFC v4l2 driver to support MFC6.x
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	janghyuck.kim@samsung.com, jaeryul.oh@samsung.com,
	ch.naveen@samsung.com, m.szyprowski@samsung.com,
	k.debski@samsung.com, kmpark@infradead.org, joshi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

The media tree has been re-organized recently.
It would be useful to re-base your patches against the latest media
tree (or linux-next).
MFC driver is now located at "drivers/media/platform/s5p-mfc/"

On 27 August 2012 17:27, Arun Kumar K <arun.kk@samsung.com> wrote:
> The patchset adds support for MFCv6 firmware in s5p-mfc driver.
> The first two patches will update the existing MFCv5 driver framework
> for making it suitable for supporting co-existence with a newer
> hardware version. The last two patches add support for MFCv6 firmware.
> This patchset have to be applied on patches [1] and [2] posted
> earlier which adds the required v4l2 controls.
>
> Changelog:
> - Modified ops mechanism for macro based function call
> - Addressed all other review comments on Patch v4
>
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48972.html
> [2] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48973.html
>
> Arun Kumar K (1):
>   [media] s5p-mfc: Update MFCv5 driver for callback based architecture
>
> Jeongtae Park (3):
>   [media] s5p-mfc: Add MFC variant data to device context
>   [media] s5p-mfc: MFCv6 register definitions
>   [media] s5p-mfc: Update MFC v4l2 driver to support MFC6.x
>
>  drivers/media/video/Kconfig                  |    4 +-
>  drivers/media/video/s5p-mfc/Makefile         |    7 +-
>  drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  440 ++++++
>  drivers/media/video/s5p-mfc/regs-mfc.h       |   49 +
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |  229 ++--
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |   98 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   13 +
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c |  164 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h |   20 +
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  155 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h |   20 +
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  174 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  188 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  226 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  208 ++--
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   11 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1407 ++-----------------
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  178 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c | 1759 +++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h |   85 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1945 ++++++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |   50 +
>  drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    3 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 -
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   90 --
>  28 files changed, 5700 insertions(+), 1873 deletions(-)
>  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
>  delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
>  delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With warm regards,
Sachin
