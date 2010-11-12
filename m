Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0KLRWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 12:22:13 -0500
MIME-Version: 1.0
In-Reply-To: <C832F8F5D375BD43BFA11E82E0FE9FE0081BDCB183@EXDCVYMBSTM005.EQ1STM.local>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
	<AANLkTinCDFuPpx+OKYRuHbdnL5FBgCTPpUf2xYNJQC0u@mail.gmail.com>
	<F45880696056844FA6A73F415B568C69536047701B@EXDCVYMBSTM006.EQ1STM.local>
	<AANLkTi=aasEoC5ja=gHpzNjyA1h00wuJd-tWVkRaaHNd@mail.gmail.com>
	<C832F8F5D375BD43BFA11E82E0FE9FE0081BDCB183@EXDCVYMBSTM005.EQ1STM.local>
Date: Fri, 12 Nov 2010 12:22:11 -0500
Message-ID: <AANLkTi=z4g9XKyzhRP+3TQ2s_uKL_OZHL5YyFV7EGiSu@mail.gmail.com>
Subject: Re: [PATCH 00/10] MCDE: Add frame buffer device driver
From: Alex Deucher <alexdeucher@gmail.com>
To: Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>
Cc: Jimmy RUBIN <jimmy.rubin@stericsson.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Dan JOHANSSON <dan.johansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Nov 12, 2010 at 11:46 AM, Marcus LORENTZON
<marcus.xm.lorentzon@stericsson.com> wrote:
> Hi Alex,
> Do you have any idea of how we should use KMS without being a "real" drm 3D device? Do you mean that we should use the KMS ioctls on for display driver? Or do you mean that we should expose a /dev/drmX device only capable of KMS and no GEM?
>

In this case I was only speaking of using the kms icotls and fbdev
emulation for modesetting as your device seems to have a fairly
complex display engine.  As for 2D/3D/video accel, that's up to you.
Each drm driver does it differently depending on how they handle
command buffers.  Intel and AMD have different sets of ioctls for
submitting 2D/3D/video commands from userspace acceleration drivers
and a different set of ioctls for memory management.

> What if we were to add a drm driver for 3D later on. Is it possible to have a separate drm device for display and one for 3D, but still share "GEM" like buffers between these devices? It look like GEM handles are device relative. This is a vital use case for us. And we really don't like to entangle our MCDE display driver, memory manager and 3D driver without a good reason. Today they are maintained as independent drivers without code dependencies. Would this still be possible using drm? Or does drm require memory manager, 3D and display to be one driver? I can see the drm=graphics card on desktop machines. But embedded UMA systems doesn't really have this dependency. You can switch memory mamanger, 3D driver, display manager in menuconfig independently of the other drivers. Not that it's used like that on one particular HW, but for different HW you can use different parts. In drm it looks like all these pieces belong together.
>

No one has done anything like that, but I don't think it would be an
issue, you'd just need some sort of way to get buffers in your display
driver or your 3D driver, so I'd assume they would depend on your
memory manager.  Right now the userspace 2D/3D accel drivers all talk
to the drm independently depending on what they need to do.  Whatever
your userspace stack looks like could do something similar, call into
one set of ioctls for memory, another set for modesetting, and another
for accel.  As long as the kernel memory manager is common, you should
be able to pass buffer handles between all of them.  If you wanted
separate memory managers for each, things get a bit trickier, but
that's up to you.

> Do you think the driver should live in the "gpu/drm" folder, even though it's not a gpu driver?
>

gpu is kind of a broad term.  It encompasses, 3D, display, video, etc.
 I don't think it really matters.

> Do you know of any other driver that use DRM/KMS API but not being a PC-style graphics card that we could look at for inspiration?

Jordan Crouse submitted some patches for Qualcomm snapdragon a while
back although it was mostly a shim for a userspace accel driver.  He
did implement platform support in the drm however:
http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=dcdb167402cbdca1d021bdfa5f63995ee0a79317

>
> And GEM, is that the only way of exposing graphics buffers to user space in drm? Or is it possible (is it ok) to expose another similar API? You mentioned that there are TTM and GEM, do both expose user space APIs for things like sharing buffers between processes, security, cache management, defragmentation? Or are these type of features defined by DRM and not TTM/GEM?
>

GEM is not a requirement, it just happens that all the current drm
drivers use variants of it for their external memory management
interface.  However, they are free to implement the memory manager
however they like.

Alex

> /BR
> /Marcus
>
>> -----Original Message-----
>> From: Alex Deucher [mailto:alexdeucher@gmail.com]
>> Sent: den 12 november 2010 16:53
>> To: Jimmy RUBIN
>> Cc: linux-fbdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>> linux-media@vger.kernel.org; Linus WALLEIJ; Dan JOHANSSON; Marcus
>> LORENTZON
>> Subject: Re: [PATCH 00/10] MCDE: Add frame buffer device driver
>>
>> On Fri, Nov 12, 2010 at 8:18 AM, Jimmy RUBIN
>> <jimmy.rubin@stericsson.com> wrote:
>> > Hi Alex,
>> >
>> > Good point, we are looking at this for possible future improvements
>> but for the moment we feel like
>> > the structure of drm does not add any simplifications for our driver.
>> We have the display manager (MCDE DSS = KMS) and the memory manager
>> (HWMEM = GEM) that could be migrated to drm framework. But we do not
>> have drm drivers for 3D hw and this also makes drm a less obvious
>> choice at the moment.
>> >
>>
>> You don't have to use the drm strictly for 3D hardware.  historically
>> that's why it was written, but with kms, it also provides an interface
>> for complex display systems.  fbdev doesn't really deal properly with
>> multiple display controllers or connectors that are dynamically
>> re-routeable at runtime.  I've seen a lot of gross hacks to fbdev to
>> support this kind of stuff in the past, so it'd be nice to use the
>> interface we now have for it if you need that functionality.
>> Additionally, you can use the shared memory manager to both the
>> display side and v4l side.  While the current drm drivers use GEM
>> externally, there's no requirement that a kms driver has to use GEM.
>> radeon and nouveau use ttm internally for example.  Something to
>> consider.  I just want to make sure people are aware of the interface
>> and what it's capable of.
>>
>> Alex
>>
>> > Jimmy
>> >
>> > -----Original Message-----
>> > From: Alex Deucher [mailto:alexdeucher@gmail.com]
>> > Sent: den 10 november 2010 15:43
>> > To: Jimmy RUBIN
>> > Cc: linux-fbdev@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; linux-media@vger.kernel.org; Linus WALLEIJ;
>> Dan JOHANSSON
>> > Subject: Re: [PATCH 00/10] MCDE: Add frame buffer device driver
>> >
>> > On Wed, Nov 10, 2010 at 7:04 AM, Jimmy Rubin
>> <jimmy.rubin@stericsson.com> wrote:
>> >> These set of patches contains a display sub system framework (DSS)
>> which is used to
>> >> implement the frame buffer device interface and a display device
>> >> framework that is used to add support for different type of displays
>> >> such as LCD, HDMI and so on.
>> >
>> > For complex display hardware, you may want to consider using the drm
>> > kms infrastructure rather than the kernel fb interface.  It provides
>> > an API for complex display hardware (multiple encoders, display
>> > controllers, etc.) and also provides a legacy kernel fb interface for
>> > compatibility.  See:
>> > Documentation/DocBook/drm.tmpl
>> > drivers/gpu/drm/
>> > in the kernel tree.
>> >
>> > Alex
>> >
>> >>
>> >> The current implementation supports DSI command mode displays.
>> >>
>> >> Below is a short summary of the files in this patchset:
>> >>
>> >> mcde_fb.c
>> >> Implements the frame buffer device driver.
>> >>
>> >> mcde_dss.c
>> >> Contains the implementation of the display sub system framework
>> (DSS).
>> >> This API is used by the frame buffer device driver.
>> >>
>> >> mcde_display.c
>> >> Contains default implementations of the functions in the display
>> driver
>> >> API. A display driver may override the necessary functions to
>> function
>> >> properly. A simple display driver is implemented in display-
>> generic_dsi.c.
>> >>
>> >> display-generic_dsi.c
>> >> Sample driver for a DSI command mode display.
>> >>
>> >> mcde_bus.c
>> >> Implementation of the display bus. A display device is probed when
>> both
>> >> the display driver and display configuration have been registered
>> with
>> >> the display bus.
>> >>
>> >> mcde_hw.c
>> >> Hardware abstraction layer of MCDE. All code that communicates
>> directly
>> >> with the hardware resides in this file.
>> >>
>> >> board-mop500-mcde.c
>> >> The configuration of the display and the frame buffer device is
>> handled
>> >> in this file
>> >>
>> >> NOTE: These set of patches replaces the patches already sent out for
>> review.
>> >>
>> >> RFC:[PATCH 1/2] Video: Add support for MCDE frame buffer driver
>> >> RFC:[PATCH 2/2] Ux500: Add support for MCDE frame buffer driver
>> >>
>> >> The old patchset was to large to be handled by the mailing lists.
>> >>
>> >> Jimmy Rubin (10):
>> >>  MCDE: Add hardware abstraction layer
>> >>  MCDE: Add configuration registers
>> >>  MCDE: Add pixel processing registers
>> >>  MCDE: Add formatter registers
>> >>  MCDE: Add dsi link registers
>> >>  MCDE: Add generic display
>> >>  MCDE: Add display subsystem framework
>> >>  MCDE: Add frame buffer device driver
>> >>  MCDE: Add build files and bus
>> >>  ux500: MCDE: Add platform specific data
>> >>
>> >>  arch/arm/mach-ux500/Kconfig                    |    8 +
>> >>  arch/arm/mach-ux500/Makefile                   |    1 +
>> >>  arch/arm/mach-ux500/board-mop500-mcde.c        |  209 ++
>> >>  arch/arm/mach-ux500/board-mop500-regulators.c  |   28 +
>> >>  arch/arm/mach-ux500/board-mop500.c             |    3 +
>> >>  arch/arm/mach-ux500/devices-db8500.c           |   68 +
>> >>  arch/arm/mach-ux500/include/mach/db8500-regs.h |    7 +
>> >>  arch/arm/mach-ux500/include/mach/devices.h     |    1 +
>> >>  arch/arm/mach-ux500/include/mach/prcmu-regs.h  |    1 +
>> >>  arch/arm/mach-ux500/include/mach/prcmu.h       |    3 +
>> >>  arch/arm/mach-ux500/prcmu.c                    |  129 ++
>> >>  drivers/video/Kconfig                          |    2 +
>> >>  drivers/video/Makefile                         |    1 +
>> >>  drivers/video/mcde/Kconfig                     |   39 +
>> >>  drivers/video/mcde/Makefile                    |   12 +
>> >>  drivers/video/mcde/display-generic_dsi.c       |  152 ++
>> >>  drivers/video/mcde/dsi_link_config.h           | 1486
>> ++++++++++++++
>> >>  drivers/video/mcde/mcde_bus.c                  |  259 +++
>> >>  drivers/video/mcde/mcde_config.h               | 2156
>> ++++++++++++++++++++
>> >>  drivers/video/mcde/mcde_display.c              |  427 ++++
>> >>  drivers/video/mcde/mcde_dss.c                  |  353 ++++
>> >>  drivers/video/mcde/mcde_fb.c                   |  697 +++++++
>> >>  drivers/video/mcde/mcde_formatter.h            |  782 ++++++++
>> >>  drivers/video/mcde/mcde_hw.c                   | 2528
>> ++++++++++++++++++++++++
>> >>  drivers/video/mcde/mcde_mod.c                  |   67 +
>> >>  drivers/video/mcde/mcde_pixelprocess.h         | 1137 +++++++++++
>> >>  include/video/mcde/mcde.h                      |  387 ++++
>> >>  include/video/mcde/mcde_display-generic_dsi.h  |   34 +
>> >>  include/video/mcde/mcde_display.h              |  139 ++
>> >>  include/video/mcde/mcde_dss.h                  |   78 +
>> >>  include/video/mcde/mcde_fb.h                   |   54 +
>> >>  31 files changed, 11248 insertions(+), 0 deletions(-)
>> >>  create mode 100644 arch/arm/mach-ux500/board-mop500-mcde.c
>> >>  create mode 100644 drivers/video/mcde/Kconfig
>> >>  create mode 100644 drivers/video/mcde/Makefile
>> >>  create mode 100644 drivers/video/mcde/display-generic_dsi.c
>> >>  create mode 100644 drivers/video/mcde/dsi_link_config.h
>> >>  create mode 100644 drivers/video/mcde/mcde_bus.c
>> >>  create mode 100644 drivers/video/mcde/mcde_config.h
>> >>  create mode 100644 drivers/video/mcde/mcde_display.c
>> >>  create mode 100644 drivers/video/mcde/mcde_dss.c
>> >>  create mode 100644 drivers/video/mcde/mcde_fb.c
>> >>  create mode 100644 drivers/video/mcde/mcde_formatter.h
>> >>  create mode 100644 drivers/video/mcde/mcde_hw.c
>> >>  create mode 100644 drivers/video/mcde/mcde_mod.c
>> >>  create mode 100644 drivers/video/mcde/mcde_pixelprocess.h
>> >>  create mode 100644 include/video/mcde/mcde.h
>> >>  create mode 100644 include/video/mcde/mcde_display-generic_dsi.h
>> >>  create mode 100644 include/video/mcde/mcde_display.h
>> >>  create mode 100644 include/video/mcde/mcde_dss.h
>> >>  create mode 100644 include/video/mcde/mcde_fb.h
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-
>> media" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >
>
