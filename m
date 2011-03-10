Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38086 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1CJCsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 21:48:53 -0500
Received: by wya21 with SMTP id 21so1080488wya.19
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2011 18:48:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299673133-26464-1-git-send-email-johan.xx.mossberg@stericsson.com>
References: <1299673133-26464-1-git-send-email-johan.xx.mossberg@stericsson.com>
Date: Thu, 10 Mar 2011 11:48:51 +0900
Message-ID: <AANLkTi=Q6YRbRs1HHNEESxfCsu7_BeDXwfriDFLLrb85@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] hwmem: Hardware memory driver
From: Kyungmin Park <kmpark@infradead.org>
To: johan.xx.mossberg@stericsson.com
Cc: linux-mm@kvack.org, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org, gstreamer-devel@lists.freedesktop.org,
	m.nazarewicz@samsung.com, Michal Nazarewicz <mina86@mina86.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?B?6rCV66+86rec?= <mk7.kang@samsung.com>,
	=?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

CCed updated Michal email address,

One note, As Michal moved to google, Marek is works on CMA. We are
also studying the hwmem and GEM.

Thank you,
Kyungmin Park

On Wed, Mar 9, 2011 at 9:18 PM,  <johan.xx.mossberg@stericsson.com> wrote:
> Hello everyone,
>
> The following patchset implements a "hardware memory driver". The
> main purpose of hwmem is:
>
> * To allocate buffers suitable for use with hardware. Currently
> this means contiguous buffers.
> * To synchronize the caches for the allocated buffers. This is
> achieved by keeping track of when the CPU uses a buffer and when
> other hardware uses the buffer, when we switch from CPU to other
> hardware or vice versa the caches are synchronized.
> * To handle sharing of allocated buffers between processes i.e.
> import, export.
>
> Hwmem is available both through a user space API and through a
> kernel API.
>
> Here at ST-Ericsson we use hwmem for graphics buffers. Graphics
> buffers need to be contiguous due to our hardware, are passed
> between processes (usually application and window manager)and are
> part of usecases where performance is top priority so we can't
> afford to synchronize the caches unecessarily.
>
> Additions in v2:
> * Bugfixes
> * Added the possibility to map hwmem buffers in the kernel through
> hwmem_kmap/kunmap
> * Moved mach specific stuff to mach.
>
> Best regards
> Johan Mossberg
> Consultant at ST-Ericsson
>
> Johan Mossberg (3):
>  hwmem: Add hwmem (part 1)
>  hwmem: Add hwmem (part 2)
>  hwmem: Add hwmem to ux500
>
>  arch/arm/mach-ux500/Makefile               |    2 +-
>  arch/arm/mach-ux500/board-mop500.c         |    1 +
>  arch/arm/mach-ux500/dcache.c               |  266 +++++++++
>  arch/arm/mach-ux500/devices.c              |   31 ++
>  arch/arm/mach-ux500/include/mach/dcache.h  |   26 +
>  arch/arm/mach-ux500/include/mach/devices.h |    1 +
>  drivers/misc/Kconfig                       |    1 +
>  drivers/misc/Makefile                      |    1 +
>  drivers/misc/hwmem/Kconfig                 |    7 +
>  drivers/misc/hwmem/Makefile                |    3 +
>  drivers/misc/hwmem/cache_handler.c         |  510 ++++++++++++++++++
>  drivers/misc/hwmem/cache_handler.h         |   61 +++
>  drivers/misc/hwmem/hwmem-ioctl.c           |  455 ++++++++++++++++
>  drivers/misc/hwmem/hwmem-main.c            |  799 ++++++++++++++++++++++++++++
>  include/linux/hwmem.h                      |  536 +++++++++++++++++++
>  15 files changed, 2699 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-ux500/dcache.c
>  create mode 100644 arch/arm/mach-ux500/include/mach/dcache.h
>  create mode 100644 drivers/misc/hwmem/Kconfig
>  create mode 100644 drivers/misc/hwmem/Makefile
>  create mode 100644 drivers/misc/hwmem/cache_handler.c
>  create mode 100644 drivers/misc/hwmem/cache_handler.h
>  create mode 100644 drivers/misc/hwmem/hwmem-ioctl.c
>  create mode 100644 drivers/misc/hwmem/hwmem-main.c
>  create mode 100644 include/linux/hwmem.h
>
> --
> 1.7.4.1
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
