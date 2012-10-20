Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55023 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2JTNKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 09:10:18 -0400
MIME-Version: 1.0
In-Reply-To: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Sat, 20 Oct 2012 22:10:17 +0900
Message-ID: <CAAQKjZOZ9+NSQbNkG3qyWh+oLAE1e44DQ_bQCEr4Wvg2WLiGtA@mail.gmail.com>
Subject: Re: [RFC 0/5] Generic panel framework
From: Inki Dae <inki.dae@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent. sorry for being late.

2012/8/17 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi everybody,
>
> While working on DT bindings for the Renesas Mobile SoC display controller
> (a.k.a. LCDC) I quickly realized that display panel implementation based on
> board code callbacks would need to be replaced by a driver-based panel
> framework.
>
> Several driver-based panel support solution already exist in the kernel.
>
> - The LCD device class is implemented in drivers/video/backlight/lcd.c and
>   exposes a kernel API in include/linux/lcd.h. That API is tied to the FBDEV
>   API for historical reason, uses board code callback for reset and power
>   management, and doesn't include support for standard features available in
>   today's "smart panels".
>
> - OMAP2+ based systems use custom panel drivers available in
>   drivers/video/omap2/displays. Those drivers are based on OMAP DSS (display
>   controller) specific APIs.
>
> - Similarly, Exynos based systems use custom panel drivers available in
>   drivers/video/exynos. Only a single driver (s6e8ax0) is currently available.
>   That driver is based on Exynos display controller specific APIs and on the
>   LCD device class API.
>
> I've brought up the issue with Tomi Valkeinen (OMAP DSS maintainer) and Marcus
> Lorentzon (working on panel support for ST/Linaro), and we agreed that a
> generic panel framework for display devices is needed. These patches implement
> a first proof of concept.
>
> One of the main reasons for creating a new panel framework instead of adding
> missing features to the LCD framework is to avoid being tied to the FBDEV
> framework. Panels will be used by DRM drivers as well, and their API should
> thus be subsystem-agnostic. Note that the panel framework used the
> fb_videomode structure in its API, this will be replaced by a common video
> mode structure shared across subsystems (there's only so many hours per day).
>
> Panels, as used in these patches, are defined as physical devices combining a
> matrix of pixels and a controller capable of driving that matrix.
>
> Panel physical devices are registered as children of the control bus the panel
> controller is connected to (depending on the panel type, we can find platform
> devices for dummy panels with no control bus, or I2C, SPI, DBI, DSI, ...
> devices). The generic panel framework matches registered panel devices with
> panel drivers and call the panel drivers probe method, as done by other device
> classes in the kernel. The driver probe() method is responsible for
> instantiating a struct panel instance and registering it with the generic
> panel framework.
>
> Display drivers are panel consumers. They register a panel notifier with the
> framework, which then calls the notifier when a matching panel is registered.
> The reason for this asynchronous mode of operation, compared to how drivers
> acquire regulator or clock resources, is that the panel can use resources
> provided by the display driver. For instance a panel can be a child of the DBI
> or DSI bus controlled by the display device, or use a clock provided by that
> device. We can't defer the display device probe until the panel is registered
> and also defer the panel device probe until the display is registered. As
> most display drivers need to handle output devices hotplug (HDMI monitors for
> instance), handling panel through a notification system seemed to be the
> easiest solution.
>
> Note that this brings a different issue after registration, as display and
> panel drivers would take a reference to each other. Those circular references
> would make driver unloading impossible. I haven't found a good solution for
> that problem yet (hence the RFC state of those patches), and I would
> appreciate your input here. This might also be a hint that the framework
> design is wrong to start with. I guess I can't get everything right on the
> first try ;-)
>
> Getting hold of the panel is the most complex part. Once done, display drivers
> can call abstract operations provided by panel drivers to control the panel
> operation. These patches implement three of those operations (enable, start
> transfer and get modes). More operations will be needed, and those three
> operations will likely get modified during review. Most of the panels on
> devices I own are dumb panels with no control bus, and are thus not the best
> candidates to design a framework that needs to take complex panels' needs into
> account.
>
> In addition to the generic panel core, I've implemented MIPI DBI (Display Bus
> Interface, a parallel bus for panels that supports read/write transfers of
> commands and data) bus support, as well as three panel drivers (dummy panels
> with no control bus, and Renesas R61505- and R61517-based panels, both using
> DBI as their control bus). Only the dummy panel driver has been tested as I
> lack hardware for the two other drivers.
>
> I will appreciate all reviews, comments, criticisms, ideas, remarks, ... If
> you can find a clever way to solve the cyclic references issue described above
> I'll buy you a beer at the next conference we will both attend. If you think
> the proposed solution is too complex, or too simple, I'm all ears. I
> personally already feel that we might need something even more generic to
> support other kinds of external devices connected to display controllers, such
> as external DSI to HDMI converters for instance. Some kind of video entity
> exposing abstract operations like the panels do would make sense, in which
> case panels would "inherit" from that video entity.
>
> Speaking of conferences, I will attend the KS/LPC in San Diego in a bit more
> than a week, and would be happy to discuss this topic face to face there.
>
> Laurent Pinchart (5):
>   video: Add generic display panel core
>   video: panel: Add dummy panel support
>   video: panel: Add MIPI DBI bus support
>   video: panel: Add R61505 panel support
>   video: panel: Add R61517 panel support

how about using 'buses' directory instead of 'panel' and adding
'panel' under that like below?
video/buess: display bus frameworks such as MIPI-DBI/DSI and eDP are placed.
video/buess/panel: panel drivers based on display bus-based drivers are placed.

I think MIPI-DBI(Display Bus Interface)/DSI(Display Serial Interface)
and eDP are the bus interfaces for display controllers such as
DISC(OMAP SoC) and FIMC(Exynos SoC).

Thanks,
Inki Dae

>
>  drivers/video/Kconfig              |    1 +
>  drivers/video/Makefile             |    1 +
>  drivers/video/panel/Kconfig        |   37 +++
>  drivers/video/panel/Makefile       |    5 +
>  drivers/video/panel/panel-dbi.c    |  217 +++++++++++++++
>  drivers/video/panel/panel-dummy.c  |  103 +++++++
>  drivers/video/panel/panel-r61505.c |  520 ++++++++++++++++++++++++++++++++++++
>  drivers/video/panel/panel-r61517.c |  408 ++++++++++++++++++++++++++++
>  drivers/video/panel/panel.c        |  269 +++++++++++++++++++
>  include/video/panel-dbi.h          |   92 +++++++
>  include/video/panel-dummy.h        |   25 ++
>  include/video/panel-r61505.h       |   27 ++
>  include/video/panel-r61517.h       |   28 ++
>  include/video/panel.h              |  111 ++++++++
>  14 files changed, 1844 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/panel/Kconfig
>  create mode 100644 drivers/video/panel/Makefile
>  create mode 100644 drivers/video/panel/panel-dbi.c
>  create mode 100644 drivers/video/panel/panel-dummy.c
>  create mode 100644 drivers/video/panel/panel-r61505.c
>  create mode 100644 drivers/video/panel/panel-r61517.c
>  create mode 100644 drivers/video/panel/panel.c
>  create mode 100644 include/video/panel-dbi.h
>  create mode 100644 include/video/panel-dummy.h
>  create mode 100644 include/video/panel-r61505.h
>  create mode 100644 include/video/panel-r61517.h
>  create mode 100644 include/video/panel.h
>
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
