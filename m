Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57693 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaCDQBi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 11:01:38 -0500
Received: by mail-qc0-f171.google.com with SMTP id x13so4333719qcv.16
        for <linux-media@vger.kernel.org>; Tue, 04 Mar 2014 08:01:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
Date: Tue, 4 Mar 2014 11:01:37 -0500
Message-ID: <CAGoCfixx0dG0yziT2tAu8kaofgVsaK7R-C8EdOKU_HZSRv6EuA@mail.gmail.com>
Subject: Re: [PATCH 00/79] Add support for ATSC PCTV 80e USB stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 3, 2014 at 5:05 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> This patch series finally merge a long waited driver, for Micronas/Trident
> DRX-J ATSC frontends.
>
> It is based on a previous work from Devin, who made the original port
> of the Trident driver and got license to ship the firmware.
>
> Latter, it got some attention from Patrick that tried to upstream it.
>
> However, this driver had very serious issues, and didn't fit into Linux
> Kernel code quality standards.
>
> So, I made some patches, back in 2012, in order to try helping to get
> this driver merged, but, as I didn't have the device, and Patrick never
> sent a final tested version, the patches got hibernated for a long time.
>
> Finally, this year, I got one hardware for me, and one for Shuah, as
> she offered her help to fix suspend/resume issues at the subsystem.
>
> This series is a result of this work: the driver got major cleanups,
> and several relevant bug fixes. The most serious one is that the
> device was not fully initializing the struct that was enabling the
> MPEG output. Worse than that, the routine that was setting the MPEG
> output was also rewriting the default values for a dirty set.
>
> The type of output was also wrong: on this board, PCTV 80e is wired
> for serial MPEG transfer, but the driver was initialized to parallel.
>
> All those bugs got fixed, and, at least on my tests with a PCTV
> 80e model 01134, the device is now properly working.
>
> Not sure if all patches will arrive the ML, as there are some very big
> ones here that could be biger than VGER's max limit for posts.
>
> Anyway, all patches can be found at:
>         http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j-v3
>
> Have fun!
> Mauro
>
> Devin Heitmueller (2):
>   [media] drx-j: add a driver for Trident drx-j frontend
>   [media] drx-j: put under 3-clause BSD license
>
> Mauro Carvalho Chehab (74):
>   [media] drx-j: CodingStyle fixes
>   [media] drx-j: Fix compilation and un-comment it
>   [media] drx-j: Fix CodingStyle
>   [media] drx-j: get rid of the typedefs on bsp_i2c.h
>   [media] drx-j: remove the "const" annotate on HICommand()
>   [media] drx-j: get rid of the integer typedefs
>   [media] drx-j: get rid of the other typedefs at bsp_types.h
>   [media] drx-j: get rid of the bsp*.h headers
>   [media] drx-j: get rid of most of the typedefs
>   [media] drx-j: fix whitespacing on pointer parmameters
>   [media] drx-j: Use checkpatch --fix to solve several issues
>   [media] drx-j: Don't use CamelCase
>   [media] drx-j: do more CodingStyle fixes
>   [media] drx-j: remove the unused tuner_i2c_write_read() function
>   [media] drx-j: Remove a bunch of unused but assigned vars
>   [media] drx-j: Some minor CodingStyle fixes at headers
>   [media] drx-j: make a few functions static
>   [media] drx-j: Get rid of drx39xyj/bsp_tuner.h
>   [media] drx-j: get rid of typedefs in drx_driver.h
>   [media] drx-j: Get rid of typedefs on drxh.h
>   [media] drx-j: a few more CodingStyle fixups
>   [media] drx-j: Don't use buffer if an error occurs
>   [media] drx-j: replace the ugly CHK_ERROR() macro
>   [media] drx-j: don't use parenthesis on return
>   [media] drx-j: Simplify logic expressions
>   [media] drx-j: More CamelCase fixups
>   [media] drx-j: Remove typedefs in drxj.c
>   [media] drx-j: CodingStyle fixups on drxj.c
>   [media] drx-j: Use the Linux error codes
>   [media] drx-j: Replace printk's by pr_foo()
>   [media] drx-j: get rid of some ugly macros
>   [media] drx-j: remove typedefs at drx_driver.c
>   [media] drx-j: remove drxj_options.h
>   [media] drx-j: make checkpatch.pl happy
>   [media] drx-j: remove the useless microcode_size
>   [media] drx-j: Fix release and error path on drx39xxj.c
>   [media] drx-j: Be sure that all allocated data are properly initialized
>   [media] drx-j: dynamically load the firmware
>   [media] drx-j: Split firmware size check from the main routine
>   [media] em28xx: add support for PCTV 80e remote controller
>   [media] drx-j: remove unused code from drx_driver.c
>   [media] drx-j: get rid of its own be??_to_cpu() implementation
>   [media] drx-j: reset the DVB scan configuration at powerup
>   [media] drx-j: Allow standard selection
>   [media] drx-j: Some cleanups at drx_driver.c source
>   [media] drx-j: prepend function names with drx_ at drx_driver.c
>   [media] drx-j: get rid of drx_driver.c
>   [media] drx-j: Avoid any regressions by preserving old behavior
>   [media] drx-j: Remove duplicated firmware upload code
>   [media] drx-j: get rid of drx_ctrl
>   [media] drx-j: get rid of the remaining drx generic functions
>   [media] drx-j: move drx39xxj into drxj.c
>   [media] drx-j: get rid of drxj_ctrl()
>   [media] drx-j: comment or remove unused code
>   [media] drx-j: remove some ugly bindings from drx39xxj_dummy.c
>   [media] drx-j: get rid of tuner dummy get/set frequency
>   [media] drx-j: be sure to use tuner's IF
>   [media] drx-j: avoid calling power_down_foo twice
>   [media] drx-j: call ctrl_set_standard even if a standard is powered
>   [media] drx-j: use the proper timeout code on scu_command
>   [media] drx-j: remove some unused data
>   [media] drx-j: Fix qam/256 mode
>   [media] drx-j: Get rid of I2C protocol version
>   [media] drx-j: get rid of function prototypes at drx_dap_fasi.c
>   [media] drx-j: get rid of drx_dap_fasi.c
>   [media] drx-j: get rid of struct drx_dap_fasi_funct_g
>   [media] drx-j: get rid of function wrappers
>   [media] drx-j: Allow userspace control of LNA
>   [media] drx-j: Use single master mode
>   [media] drx-j: be sure to send the powerup command at device open
>   [media] drx-j: be sure to do a full software reset
>   [media] drx-j: disable OOB
>   [media] drx-j: Properly initialize mpeg struct before using it
>   [media] drx-j: set it to serial mode by default
>
> Shuah Khan (3):
>   [media] drx-j: fix pr_dbg undefined compile errors when DJH_DEBUG is defined
>   [media] drx-j: remove return that prevents DJH_DEBUG code to run
>   [media] drx-j: fix boot failure due to null pointer dereference
>
>  Documentation/video4linux/CARDLIST.em28xx          |     1 +
>  drivers/media/dvb-frontends/Kconfig                |     2 +
>  drivers/media/dvb-frontends/Makefile               |     1 +
>  drivers/media/dvb-frontends/drx39xyj/Kconfig       |     7 +
>  drivers/media/dvb-frontends/drx39xyj/Makefile      |     6 +
>  drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h     |   139 +
>  drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |    39 +
>  .../media/dvb-frontends/drx39xyj/drx_dap_fasi.h    |   256 +
>  drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |  2367 +++
>  .../dvb-frontends/drx39xyj/drx_driver_version.h    |    72 +
>  drivers/media/dvb-frontends/drx39xyj/drxj.c        | 20867 +++++++++++++++++++
>  drivers/media/dvb-frontends/drx39xyj/drxj.h        |   680 +
>  drivers/media/dvb-frontends/drx39xyj/drxj_map.h    | 15055 +++++++++++++
>  drivers/media/usb/em28xx/Kconfig                   |     1 +
>  drivers/media/usb/em28xx/em28xx-cards.c            |    21 +
>  drivers/media/usb/em28xx/em28xx-dvb.c              |    27 +
>  drivers/media/usb/em28xx/em28xx.h                  |     1 +
>  17 files changed, 39542 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/Kconfig
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/Makefile
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/drx_driver.h
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/drxj.c
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/drxj.h
>  create mode 100644 drivers/media/dvb-frontends/drx39xyj/drxj_map.h
>
> --
> 1.8.5.3
>

Acked-by:  Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
