Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1KHNgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Nov 2011 08:36:21 -0500
Message-ID: <4EB9304C.5020305@redhat.com>
Date: Tue, 08 Nov 2011 11:36:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: linux-media@vger.kernel.org,
	Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 00/13] Remaining coding style clean up of AS102 driver
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-11-2011 18:31, Sylwester Nawrocki escreveu:
> Hello,
> 
> the following patch set is a further cleanup of the AS102 DVB-T receiver 
> driver. I'm not sure if there are more issues to address before moving 
> the driver to drivers/media/dvb/, but checkpatch.pl seems now to be fairly
> happy about the driver's state:
> 
> 8<------
> $ scripts/checkpatch.pl -f drivers/staging/media/as102/*.[ch]
> WARNING: line over 80 characters
> #137: FILE: staging/media/as102/as102_drv.c:137:
> +		dprintk(debug, "ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
> 
> total: 0 errors, 1 warnings, 319 lines checked
> 
> drivers/staging/media/as102/as102_drv.c has style problems, please review.
> 
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
> total: 0 errors, 0 warnings, 106 lines checked
> 
> drivers/staging/media/as102/as102_drv.h has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 599 lines checked
> 
> drivers/staging/media/as102/as102_fe.c has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 241 lines checked
> 
> drivers/staging/media/as102/as102_fw.c has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 38 lines checked
> 
> drivers/staging/media/as102/as102_fw.h has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 476 lines checked
> 
> drivers/staging/media/as102/as102_usb_drv.c has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 58 lines checked
> 
> drivers/staging/media/as102/as102_usb_drv.h has no obvious style problems and is ready for submission.
> WARNING: line over 80 characters
> #349: FILE: staging/media/as102/as10x_cmd.c:349:
> +		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
> 
> WARNING: line over 80 characters
> #351: FILE: staging/media/as102/as10x_cmd.c:351:
> +		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
> 
> total: 0 errors, 2 warnings, 453 lines checked
> 
> drivers/staging/media/as102/as10x_cmd.c has style problems, please review.
> 
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
> total: 0 errors, 0 warnings, 215 lines checked
> 
> drivers/staging/media/as102/as10x_cmd_cfg.c has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 529 lines checked
> 
> drivers/staging/media/as102/as10x_cmd.h has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 223 lines checked
> 
> drivers/staging/media/as102/as10x_cmd_stream.c has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 54 lines checked
> 
> drivers/staging/media/as102/as10x_handle.h has no obvious style problems and is ready for submission.
> total: 0 errors, 0 warnings, 194 lines checked
> 
> drivers/staging/media/as102/as10x_types.h has no obvious style problems and is ready for submission.
> ---->8
> 
> Thanks to Piotr Chmura for initially reviewing the series.
> 
> The patches can be pulled from:
> git://gitorious.org/linux-media/media_tree.git staging_media_as102_cleanup
> 
> The driver has been tested with PCTV picoStick (74e) DVB-T tuner. 

I got a few warnings here, after applying the patch series:

drivers/staging/media/as102/as102_drv.c: In function ‘as102_dvb_register’:
drivers/staging/media/as102/as102_drv.c:223:3: warning: passing argument 1 of ‘dev_err’ from incompatible pointer type [enabled by default]
include/linux/device.h:812:12: note: expected ‘const struct device *’ but argument is of type ‘char *’
drivers/staging/media/as102/as102_drv.c:223:3: warning: too many arguments for format [-Wformat-extra-args]

please check.

> 
> The only issue I observed is at first run MeTV displays 
> "Failed to lock channel" error instead of playing the last selected 
> channel immediately.
> 
> I'm rather not planning to be doing much more work on this driver.
> 
> --
> Thanks,
> Sylwester
> 
> 
> Piotr Chmura (1):
>   staging: as102: Remove comment tags for editors configuration
> 
> Sylwester Nawrocki (12):
>   staging: as102: Remove unnecessary typedefs
>   staging: as102: Remove leftovers of the SPI bus driver
>   staging: as102: Make the driver select CONFIG_FW_LOADER
>   staging: as102: Replace pragma(pack) with attribute __packed
>   staging: as102: Fix the dvb device registration error path
>   staging: as102: Whitespace and indentation cleanup
>   staging: as102: Replace printk(KERN_<LEVEL> witk pr_<level>
>   staging: as102: Remove linkage specifiers for C++
>   staging: as102: Use linux/uaccess.h instead of asm/uaccess.h
>   staging: as102: Move variable declarations to the header
>   staging: as102: Define device name string pointers constant
>   staging: as102: Eliminate as10x_handle_t alias
> 
>  drivers/staging/media/as102/Kconfig            |    1 +
>  drivers/staging/media/as102/Makefile           |    2 +-
>  drivers/staging/media/as102/as102_drv.c        |  126 ++---
>  drivers/staging/media/as102/as102_drv.h        |   59 +--
>  drivers/staging/media/as102/as102_fe.c         |    4 -
>  drivers/staging/media/as102/as102_fw.c         |   44 +-
>  drivers/staging/media/as102/as102_fw.h         |   10 +-
>  drivers/staging/media/as102/as102_usb_drv.c    |   34 +-
>  drivers/staging/media/as102/as102_usb_drv.h    |    1 -
>  drivers/staging/media/as102/as10x_cmd.c        |  139 ++--
>  drivers/staging/media/as102/as10x_cmd.h        |  895 ++++++++++++------------
>  drivers/staging/media/as102/as10x_cmd_cfg.c    |   66 +-
>  drivers/staging/media/as102/as10x_cmd_stream.c |   56 +-
>  drivers/staging/media/as102/as10x_handle.h     |   26 +-
>  drivers/staging/media/as102/as10x_types.h      |  250 ++++----
>  15 files changed, 804 insertions(+), 909 deletions(-)
> 

