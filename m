Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48782 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab0KJOme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 09:42:34 -0500
MIME-Version: 1.0
In-Reply-To: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
Date: Wed, 10 Nov 2010 09:42:33 -0500
Message-ID: <AANLkTinCDFuPpx+OKYRuHbdnL5FBgCTPpUf2xYNJQC0u@mail.gmail.com>
Subject: Re: [PATCH 00/10] MCDE: Add frame buffer device driver
From: Alex Deucher <alexdeucher@gmail.com>
To: Jimmy Rubin <jimmy.rubin@stericsson.com>
Cc: linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	Linus Walleij <linus.walleij@stericsson.com>,
	Dan Johansson <dan.johansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 10, 2010 at 7:04 AM, Jimmy Rubin <jimmy.rubin@stericsson.com> wrote:
> These set of patches contains a display sub system framework (DSS) which is used to
> implement the frame buffer device interface and a display device
> framework that is used to add support for different type of displays
> such as LCD, HDMI and so on.

For complex display hardware, you may want to consider using the drm
kms infrastructure rather than the kernel fb interface.  It provides
an API for complex display hardware (multiple encoders, display
controllers, etc.) and also provides a legacy kernel fb interface for
compatibility.  See:
Documentation/DocBook/drm.tmpl
drivers/gpu/drm/
in the kernel tree.

Alex

>
> The current implementation supports DSI command mode displays.
>
> Below is a short summary of the files in this patchset:
>
> mcde_fb.c
> Implements the frame buffer device driver.
>
> mcde_dss.c
> Contains the implementation of the display sub system framework (DSS).
> This API is used by the frame buffer device driver.
>
> mcde_display.c
> Contains default implementations of the functions in the display driver
> API. A display driver may override the necessary functions to function
> properly. A simple display driver is implemented in display-generic_dsi.c.
>
> display-generic_dsi.c
> Sample driver for a DSI command mode display.
>
> mcde_bus.c
> Implementation of the display bus. A display device is probed when both
> the display driver and display configuration have been registered with
> the display bus.
>
> mcde_hw.c
> Hardware abstraction layer of MCDE. All code that communicates directly
> with the hardware resides in this file.
>
> board-mop500-mcde.c
> The configuration of the display and the frame buffer device is handled
> in this file
>
> NOTE: These set of patches replaces the patches already sent out for review.
>
> RFC:[PATCH 1/2] Video: Add support for MCDE frame buffer driver
> RFC:[PATCH 2/2] Ux500: Add support for MCDE frame buffer driver
>
> The old patchset was to large to be handled by the mailing lists.
>
> Jimmy Rubin (10):
>  MCDE: Add hardware abstraction layer
>  MCDE: Add configuration registers
>  MCDE: Add pixel processing registers
>  MCDE: Add formatter registers
>  MCDE: Add dsi link registers
>  MCDE: Add generic display
>  MCDE: Add display subsystem framework
>  MCDE: Add frame buffer device driver
>  MCDE: Add build files and bus
>  ux500: MCDE: Add platform specific data
>
>  arch/arm/mach-ux500/Kconfig                    |    8 +
>  arch/arm/mach-ux500/Makefile                   |    1 +
>  arch/arm/mach-ux500/board-mop500-mcde.c        |  209 ++
>  arch/arm/mach-ux500/board-mop500-regulators.c  |   28 +
>  arch/arm/mach-ux500/board-mop500.c             |    3 +
>  arch/arm/mach-ux500/devices-db8500.c           |   68 +
>  arch/arm/mach-ux500/include/mach/db8500-regs.h |    7 +
>  arch/arm/mach-ux500/include/mach/devices.h     |    1 +
>  arch/arm/mach-ux500/include/mach/prcmu-regs.h  |    1 +
>  arch/arm/mach-ux500/include/mach/prcmu.h       |    3 +
>  arch/arm/mach-ux500/prcmu.c                    |  129 ++
>  drivers/video/Kconfig                          |    2 +
>  drivers/video/Makefile                         |    1 +
>  drivers/video/mcde/Kconfig                     |   39 +
>  drivers/video/mcde/Makefile                    |   12 +
>  drivers/video/mcde/display-generic_dsi.c       |  152 ++
>  drivers/video/mcde/dsi_link_config.h           | 1486 ++++++++++++++
>  drivers/video/mcde/mcde_bus.c                  |  259 +++
>  drivers/video/mcde/mcde_config.h               | 2156 ++++++++++++++++++++
>  drivers/video/mcde/mcde_display.c              |  427 ++++
>  drivers/video/mcde/mcde_dss.c                  |  353 ++++
>  drivers/video/mcde/mcde_fb.c                   |  697 +++++++
>  drivers/video/mcde/mcde_formatter.h            |  782 ++++++++
>  drivers/video/mcde/mcde_hw.c                   | 2528 ++++++++++++++++++++++++
>  drivers/video/mcde/mcde_mod.c                  |   67 +
>  drivers/video/mcde/mcde_pixelprocess.h         | 1137 +++++++++++
>  include/video/mcde/mcde.h                      |  387 ++++
>  include/video/mcde/mcde_display-generic_dsi.h  |   34 +
>  include/video/mcde/mcde_display.h              |  139 ++
>  include/video/mcde/mcde_dss.h                  |   78 +
>  include/video/mcde/mcde_fb.h                   |   54 +
>  31 files changed, 11248 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-ux500/board-mop500-mcde.c
>  create mode 100644 drivers/video/mcde/Kconfig
>  create mode 100644 drivers/video/mcde/Makefile
>  create mode 100644 drivers/video/mcde/display-generic_dsi.c
>  create mode 100644 drivers/video/mcde/dsi_link_config.h
>  create mode 100644 drivers/video/mcde/mcde_bus.c
>  create mode 100644 drivers/video/mcde/mcde_config.h
>  create mode 100644 drivers/video/mcde/mcde_display.c
>  create mode 100644 drivers/video/mcde/mcde_dss.c
>  create mode 100644 drivers/video/mcde/mcde_fb.c
>  create mode 100644 drivers/video/mcde/mcde_formatter.h
>  create mode 100644 drivers/video/mcde/mcde_hw.c
>  create mode 100644 drivers/video/mcde/mcde_mod.c
>  create mode 100644 drivers/video/mcde/mcde_pixelprocess.h
>  create mode 100644 include/video/mcde/mcde.h
>  create mode 100644 include/video/mcde/mcde_display-generic_dsi.h
>  create mode 100644 include/video/mcde/mcde_display.h
>  create mode 100644 include/video/mcde/mcde_dss.h
>  create mode 100644 include/video/mcde/mcde_fb.h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
