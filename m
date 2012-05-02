Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:50893 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab2EBPcZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 11:32:25 -0400
Received: by qcsd1 with SMTP id d1so621542qcs.21
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 08:32:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Wed, 2 May 2012 10:32:01 -0500
Message-ID: <CAKnK67TMqN4M3ppSemO0Wm8fpeh+FgNAaGUVbzagpqAxXCXbbw@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] v4l2: OMAP4 ISS driver + Sensor + Board support
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 2, 2012 at 10:15 AM, Sergio Aguirre <saaguirre@ti.com> wrote:
> Hi everyone,
>
> It's been a long time since last version (5 months)! :)
>
> This is the third version of the OMAP4 ISS driver,
> which uses Media Controller and videobuf2 frameworks.
>
> This patchset should apply cleanly on top of v3.4-rc5 kernel tag.
>
> This driver attempts to provide an fully open source solution to
> control the OMAP4 Imaging SubSystem (a.k.a. ISS).
>
> Starts with just CSI2-A/B interface support, and pretends to be
> ready for expansion to add support to the many ISS block modules
> as possible.
>
> Please see newly added documentation for more details:
>
> Documentation/video4linux/omap4_camera.txt
>
> Any comments/complaints are welcome. :)

Apologies, forgot to mention this:

Tested with these patchsets:
- Sakari's patches for N9 and some v4l2 changes:
http://www.spinics.net/lists/linux-media/msg45052.html
- CMA v24: http://www.spinics.net/lists/linux-media/msg46106.html

Both rebased to v3.4-rc5.

Regards,
Sergio

>
> Changes since v2:
> - Supports CSI2B now!
> - Add support for RAW8.
> - Usage of V4L2_CID_PIXEL_RATE, instead of dphy configuration in boardfile
>  (similar to omap3isp)
> - Removes save/restore support for now, as it is broken.
> - Attend several comments form Sakari Ailus (Thanks Sakari!)
> - Populate hw_revision in media_dev struct.
> - Ported several fixes pushed for omap3isp (Thanks Laurent!)
> - Use module_platform_driver.
> - Use proposed generic v4l2_subdev_link_validate.
> - Move OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX handle to omap4iss code,
>  instead of board file.
>
> Changes since v1:
> - Simplification of auxclk handlign in board files
> - Use of HWMOD declaration for assisted platform_device creation.
> - Videobuf2 migration (Removal of custom iss_queue buffer handling driver)
>
> Regards,
> Sergio
>
> Sergio Aguirre (10):
>  mfd: twl6040: Fix wrong TWL6040_GPO3 bitfield value
>  OMAP4: hwmod: Include CSI2A/B and CSIPHY1/2 memory sections
>  OMAP4: Add base addresses for ISS
>  v4l: Add support for omap4iss driver
>  v4l: Add support for ov5640 sensor
>  v4l: Add support for ov5650 sensor
>  arm: omap4430sdp: Add support for omap4iss camera
>  arm: omap4panda: Add support for omap4iss camera
>  omap2plus: Add support for omap4iss camera
>  arm: Add support for CMA for omap4iss driver
>
>  Documentation/video4linux/omap4_camera.txt    |   64 ++
>  arch/arm/configs/omap2plus_defconfig          |    2 +
>  arch/arm/mach-omap2/Kconfig                   |   32 +
>  arch/arm/mach-omap2/Makefile                  |    3 +
>  arch/arm/mach-omap2/board-4430sdp-camera.c    |  415 ++++++++
>  arch/arm/mach-omap2/board-4430sdp.c           |   20 +
>  arch/arm/mach-omap2/board-omap4panda-camera.c |  209 ++++
>  arch/arm/mach-omap2/devices.c                 |   40 +
>  arch/arm/mach-omap2/devices.h                 |    4 +
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c    |   22 +-
>  drivers/media/video/Kconfig                   |   25 +
>  drivers/media/video/Makefile                  |    3 +
>  drivers/media/video/omap4iss/Makefile         |    6 +
>  drivers/media/video/omap4iss/iss.c            | 1159 +++++++++++++++++++++
>  drivers/media/video/omap4iss/iss.h            |  121 +++
>  drivers/media/video/omap4iss/iss_csi2.c       | 1368 +++++++++++++++++++++++++
>  drivers/media/video/omap4iss/iss_csi2.h       |  155 +++
>  drivers/media/video/omap4iss/iss_csiphy.c     |  281 +++++
>  drivers/media/video/omap4iss/iss_csiphy.h     |   51 +
>  drivers/media/video/omap4iss/iss_regs.h       |  244 +++++
>  drivers/media/video/omap4iss/iss_video.c      | 1123 ++++++++++++++++++++
>  drivers/media/video/omap4iss/iss_video.h      |  201 ++++
>  drivers/media/video/ov5640.c                  |  948 +++++++++++++++++
>  drivers/media/video/ov5650.c                  |  733 +++++++++++++
>  include/linux/mfd/twl6040.h                   |    2 +-
>  include/media/omap4iss.h                      |   65 ++
>  include/media/ov5640.h                        |   10 +
>  include/media/ov5650.h                        |   10 +
>  28 files changed, 7314 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/video4linux/omap4_camera.txt
>  create mode 100644 arch/arm/mach-omap2/board-4430sdp-camera.c
>  create mode 100644 arch/arm/mach-omap2/board-omap4panda-camera.c
>  create mode 100644 drivers/media/video/omap4iss/Makefile
>  create mode 100644 drivers/media/video/omap4iss/iss.c
>  create mode 100644 drivers/media/video/omap4iss/iss.h
>  create mode 100644 drivers/media/video/omap4iss/iss_csi2.c
>  create mode 100644 drivers/media/video/omap4iss/iss_csi2.h
>  create mode 100644 drivers/media/video/omap4iss/iss_csiphy.c
>  create mode 100644 drivers/media/video/omap4iss/iss_csiphy.h
>  create mode 100644 drivers/media/video/omap4iss/iss_regs.h
>  create mode 100644 drivers/media/video/omap4iss/iss_video.c
>  create mode 100644 drivers/media/video/omap4iss/iss_video.h
>  create mode 100644 drivers/media/video/ov5640.c
>  create mode 100644 drivers/media/video/ov5650.c
>  create mode 100644 include/media/omap4iss.h
>  create mode 100644 include/media/ov5640.h
>  create mode 100644 include/media/ov5650.h
>
> --
> 1.7.5.4
>
