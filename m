Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaFPIYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 04:24:42 -0400
Message-ID: <539EA9C1.2090206@redhat.com>
Date: Mon, 16 Jun 2014 10:24:33 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: [PATCH] sn9c102: remove deprecated driver
References: <539EA12E.9050903@xs4all.nl>
In-Reply-To: <539EA12E.9050903@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/16/2014 09:47 AM, Hans Verkuil wrote:
> During the media summit meeting in Edinburgh it was decided to move this
> driver to staging as the first step to removing it altogether.
> 
> Most webcams covered by this driver are now supported by gspca. Nobody has the
> hardware or is willing to convert the remaining devices to gspca.
> 
> This driver needs a major overhaul to have it conform to the latest frameworks
> and compliancy tests.
> 
> Without hardware, however, this is next to impossible. Given the fact that
> this driver seems to be pretty much unused (it has been removed from Fedora
> several versions ago and nobody complained about that), we decided to drop
> this driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Hans de Goede <hdegoede@redhat.com>

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> Cc: Luca Risolia <luca.risolia@studio.unibo.it>
> ---
>  MAINTAINERS                                        |    9 -
>  drivers/staging/media/Kconfig                      |    2 -
>  drivers/staging/media/Makefile                     |    1 -
>  drivers/staging/media/sn9c102/Kconfig              |   17 -
>  drivers/staging/media/sn9c102/Makefile             |   15 -
>  drivers/staging/media/sn9c102/sn9c102.h            |  214 --
>  drivers/staging/media/sn9c102/sn9c102.txt          |  592 ----
>  drivers/staging/media/sn9c102/sn9c102_config.h     |   86 -
>  drivers/staging/media/sn9c102/sn9c102_core.c       | 3465 --------------------
>  drivers/staging/media/sn9c102/sn9c102_devtable.h   |  145 -
>  drivers/staging/media/sn9c102/sn9c102_hv7131d.c    |  269 --
>  drivers/staging/media/sn9c102/sn9c102_hv7131r.c    |  369 ---
>  drivers/staging/media/sn9c102/sn9c102_mi0343.c     |  352 --
>  drivers/staging/media/sn9c102/sn9c102_mi0360.c     |  453 ---
>  drivers/staging/media/sn9c102/sn9c102_mt9v111.c    |  260 --
>  drivers/staging/media/sn9c102/sn9c102_ov7630.c     |  634 ----
>  drivers/staging/media/sn9c102/sn9c102_ov7660.c     |  546 ---
>  drivers/staging/media/sn9c102/sn9c102_pas106b.c    |  308 --
>  drivers/staging/media/sn9c102/sn9c102_pas202bcb.c  |  340 --
>  drivers/staging/media/sn9c102/sn9c102_sensor.h     |  307 --
>  drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c |  154 -
>  drivers/staging/media/sn9c102/sn9c102_tas5110d.c   |  119 -
>  drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c |  165 -
>  23 files changed, 8822 deletions(-)
>  delete mode 100644 drivers/staging/media/sn9c102/Kconfig
>  delete mode 100644 drivers/staging/media/sn9c102/Makefile
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102.h
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102.txt
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_config.h
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_core.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_devtable.h
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_hv7131d.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_hv7131r.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mi0343.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mi0360.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mt9v111.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_ov7630.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_ov7660.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_pas106b.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_sensor.h
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5110d.c
>  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b7c633..d4eaa08 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9413,15 +9413,6 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/usb/smsc95xx.*
>  
> -USB SN9C1xx DRIVER
> -M:	Luca Risolia <luca.risolia@studio.unibo.it>
> -L:	linux-usb@vger.kernel.org
> -L:	linux-media@vger.kernel.org
> -T:	git git://linuxtv.org/media_tree.git
> -W:	http://www.linux-projects.org
> -S:	Maintained
> -F:	drivers/staging/media/sn9c102/
> -
>  USB SUBSYSTEM
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  L:	linux-usb@vger.kernel.org
> diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
> index a9f2e63..cd2af376 100644
> --- a/drivers/staging/media/Kconfig
> +++ b/drivers/staging/media/Kconfig
> @@ -35,8 +35,6 @@ source "drivers/staging/media/msi3101/Kconfig"
>  
>  source "drivers/staging/media/omap24xx/Kconfig"
>  
> -source "drivers/staging/media/sn9c102/Kconfig"
> -
>  source "drivers/staging/media/solo6x10/Kconfig"
>  
>  source "drivers/staging/media/omap4iss/Kconfig"
> diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
> index 8e2c5d2..2766a3e 100644
> --- a/drivers/staging/media/Makefile
> +++ b/drivers/staging/media/Makefile
> @@ -8,7 +8,6 @@ obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
>  obj-$(CONFIG_USB_MSI3101)	+= msi3101/
>  obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
>  obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
> -obj-$(CONFIG_USB_SN9C102)       += sn9c102/
>  obj-$(CONFIG_VIDEO_OMAP2)       += omap24xx/
>  obj-$(CONFIG_VIDEO_TCM825X)     += omap24xx/
>  obj-$(CONFIG_DVB_RTL2832_SDR)	+= rtl2832u_sdr/
> diff --git a/drivers/staging/media/sn9c102/Kconfig b/drivers/staging/media/sn9c102/Kconfig
> deleted file mode 100644
> index c9aba59..0000000
> --- a/drivers/staging/media/sn9c102/Kconfig
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -config USB_SN9C102
> -	tristate "USB SN9C1xx PC Camera Controller support (DEPRECATED)"
> -	depends on VIDEO_V4L2 && MEDIA_USB_SUPPORT
> -	---help---
> -	  This driver is DEPRECATED, please use the gspca sonixb and
> -	  sonixj modules instead.
> -
> -	  Say Y here if you want support for cameras based on SONiX SN9C101,
> -	  SN9C102, SN9C103, SN9C105 and SN9C120 PC Camera Controllers.
> -
> -	  See <file:drivers/staging/media/sn9c102/sn9c102.txt> for more info.
> -
> -	  If you have webcams that are only supported by this driver and not by
> -	  the gspca driver, then contact the linux-media mailinglist.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called sn9c102.
> diff --git a/drivers/staging/media/sn9c102/Makefile b/drivers/staging/media/sn9c102/Makefile
> deleted file mode 100644
> index 7ecd5a9..0000000
> --- a/drivers/staging/media/sn9c102/Makefile
> +++ /dev/null
> @@ -1,15 +0,0 @@
> -sn9c102-objs := sn9c102_core.o \
> -		sn9c102_hv7131d.o \
> -		sn9c102_hv7131r.o \
> -		sn9c102_mi0343.o \
> -		sn9c102_mi0360.o \
> -		sn9c102_mt9v111.o \
> -		sn9c102_ov7630.o \
> -		sn9c102_ov7660.o \
> -		sn9c102_pas106b.o \
> -		sn9c102_pas202bcb.o \
> -		sn9c102_tas5110c1b.o \
> -		sn9c102_tas5110d.o \
> -		sn9c102_tas5130d1b.o
> -
> -obj-$(CONFIG_USB_SN9C102)       += sn9c102.o
> diff --git a/drivers/staging/media/sn9c102/sn9c102.h b/drivers/staging/media/sn9c102/sn9c102.h
> deleted file mode 100644
> index 37ca722..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102.h
> +++ /dev/null
> @@ -1,214 +0,0 @@
> -/***************************************************************************
> - * V4L2 driver for SN9C1xx PC Camera Controllers                           *
> - *                                                                         *
> - * Copyright (C) 2004-2006 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#ifndef _SN9C102_H_
> -#define _SN9C102_H_
> -
> -#include <linux/usb.h>
> -#include <linux/videodev2.h>
> -#include <media/v4l2-common.h>
> -#include <media/v4l2-ioctl.h>
> -#include <media/v4l2-device.h>
> -#include <linux/device.h>
> -#include <linux/list.h>
> -#include <linux/spinlock.h>
> -#include <linux/time.h>
> -#include <linux/wait.h>
> -#include <linux/types.h>
> -#include <linux/param.h>
> -#include <linux/rwsem.h>
> -#include <linux/mutex.h>
> -#include <linux/string.h>
> -#include <linux/stddef.h>
> -#include <linux/kref.h>
> -
> -#include "sn9c102_config.h"
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -enum sn9c102_frame_state {
> -	F_UNUSED,
> -	F_QUEUED,
> -	F_GRABBING,
> -	F_DONE,
> -	F_ERROR,
> -};
> -
> -struct sn9c102_frame_t {
> -	void *bufmem;
> -	struct v4l2_buffer buf;
> -	enum sn9c102_frame_state state;
> -	struct list_head frame;
> -	unsigned long vma_use_count;
> -};
> -
> -enum sn9c102_dev_state {
> -	DEV_INITIALIZED = 0x01,
> -	DEV_DISCONNECTED = 0x02,
> -	DEV_MISCONFIGURED = 0x04,
> -};
> -
> -enum sn9c102_io_method {
> -	IO_NONE,
> -	IO_READ,
> -	IO_MMAP,
> -};
> -
> -enum sn9c102_stream_state {
> -	STREAM_OFF,
> -	STREAM_INTERRUPT,
> -	STREAM_ON,
> -};
> -
> -typedef char sn9c102_sof_header_t[62];
> -
> -struct sn9c102_sof_t {
> -	sn9c102_sof_header_t header;
> -	u16 bytesread;
> -};
> -
> -struct sn9c102_sysfs_attr {
> -	u16 reg, i2c_reg;
> -	sn9c102_sof_header_t frame_header;
> -};
> -
> -struct sn9c102_module_param {
> -	u8 force_munmap;
> -	u16 frame_timeout;
> -};
> -
> -static DEFINE_MUTEX(sn9c102_sysfs_lock);
> -static DECLARE_RWSEM(sn9c102_dev_lock);
> -
> -struct sn9c102_device {
> -	struct video_device *v4ldev;
> -
> -	struct v4l2_device v4l2_dev;
> -
> -	enum sn9c102_bridge bridge;
> -	struct sn9c102_sensor sensor;
> -
> -	struct usb_device *usbdev;
> -	struct urb *urb[SN9C102_URBS];
> -	void *transfer_buffer[SN9C102_URBS];
> -	u8 *control_buffer;
> -
> -	struct sn9c102_frame_t *frame_current, frame[SN9C102_MAX_FRAMES];
> -	struct list_head inqueue, outqueue;
> -	u32 frame_count, nbuffers, nreadbuffers;
> -
> -	enum sn9c102_io_method io;
> -	enum sn9c102_stream_state stream;
> -
> -	struct v4l2_jpegcompression compression;
> -
> -	struct sn9c102_sysfs_attr sysfs;
> -	struct sn9c102_sof_t sof;
> -	u16 reg[384];
> -
> -	struct sn9c102_module_param module_param;
> -
> -	struct kref kref;
> -	enum sn9c102_dev_state state;
> -	u8 users;
> -
> -	struct completion probe;
> -	struct mutex open_mutex, fileop_mutex;
> -	spinlock_t queue_lock;
> -	wait_queue_head_t wait_open, wait_frame, wait_stream;
> -};
> -
> -/*****************************************************************************/
> -
> -struct sn9c102_device*
> -sn9c102_match_id(struct sn9c102_device *cam, const struct usb_device_id *id)
> -{
> -	return usb_match_id(usb_ifnum_to_if(cam->usbdev, 0), id) ? cam : NULL;
> -}
> -
> -
> -void
> -sn9c102_attach_sensor(struct sn9c102_device *cam,
> -		      const struct sn9c102_sensor *sensor)
> -{
> -	memcpy(&cam->sensor, sensor, sizeof(struct sn9c102_sensor));
> -}
> -
> -
> -enum sn9c102_bridge
> -sn9c102_get_bridge(struct sn9c102_device *cam)
> -{
> -	return cam->bridge;
> -}
> -
> -
> -struct sn9c102_sensor *sn9c102_get_sensor(struct sn9c102_device *cam)
> -{
> -	return &cam->sensor;
> -}
> -
> -/*****************************************************************************/
> -
> -#undef DBG
> -#undef KDBG
> -#ifdef SN9C102_DEBUG
> -#	define DBG(level, fmt, args...)                                       \
> -do {                                                                          \
> -	if (debug >= (level)) {                                               \
> -		if ((level) == 1)                                             \
> -			dev_err(&cam->usbdev->dev, fmt "\n", ## args);        \
> -		else if ((level) == 2)                                        \
> -			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
> -		else if ((level) >= 3)                                        \
> -			dev_info(&cam->usbdev->dev, "[%s:%d] " fmt "\n",      \
> -				 __func__, __LINE__ , ## args);           \
> -	}                                                                     \
> -} while (0)
> -#	define V4LDBG(level, name, cmd)                                       \
> -do {                                                                          \
> -	if (debug >= (level))                                                 \
> -		v4l_printk_ioctl(name, cmd);                                  \
> -} while (0)
> -#	define KDBG(level, fmt, args...)                                      \
> -do {                                                                          \
> -	if (debug >= (level)) {                                               \
> -		if ((level) == 1 || (level) == 2)                             \
> -			pr_info("sn9c102: " fmt "\n", ## args);               \
> -		else if ((level) == 3)                                        \
> -			pr_debug("sn9c102: [%s:%d] " fmt "\n",                \
> -				 __func__, __LINE__ , ## args);           \
> -	}                                                                     \
> -} while (0)
> -#else
> -#	define DBG(level, fmt, args...) do { ; } while (0)
> -#	define V4LDBG(level, name, cmd) do { ; } while (0)
> -#	define KDBG(level, fmt, args...) do { ; } while (0)
> -#endif
> -
> -#undef PDBG
> -#define PDBG(fmt, args...)                                                    \
> -dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
> -	 __LINE__ , ## args)
> -
> -#undef PDBGG
> -#define PDBGG(fmt, args...) do { ; } while (0) /* placeholder */
> -
> -#endif /* _SN9C102_H_ */
> diff --git a/drivers/staging/media/sn9c102/sn9c102.txt b/drivers/staging/media/sn9c102/sn9c102.txt
> deleted file mode 100644
> index b4f6704..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102.txt
> +++ /dev/null
> @@ -1,592 +0,0 @@
> -
> -			 SN9C1xx PC Camera Controllers
> -				Driver for Linux
> -			 =============================
> -
> -			       - Documentation -
> -
> -
> -Index
> -=====
> -1.  Copyright
> -2.  Disclaimer
> -3.  License
> -4.  Overview and features
> -5.  Module dependencies
> -6.  Module loading
> -7.  Module parameters
> -8.  Optional device control through "sysfs"
> -9.  Supported devices
> -10. Notes for V4L2 application developers
> -11. Video frame formats
> -12. Contact information
> -13. Credits
> -
> -
> -1. Copyright
> -============
> -Copyright (C) 2004-2007 by Luca Risolia <luca.risolia@studio.unibo.it>
> -
> -
> -2. Disclaimer
> -=============
> -SONiX is a trademark of SONiX Technology Company Limited, inc.
> -This software is not sponsored or developed by SONiX.
> -
> -
> -3. License
> -==========
> -This program is free software; you can redistribute it and/or modify
> -it under the terms of the GNU General Public License as published by
> -the Free Software Foundation; either version 2 of the License, or
> -(at your option) any later version.
> -
> -This program is distributed in the hope that it will be useful,
> -but WITHOUT ANY WARRANTY; without even the implied warranty of
> -MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -GNU General Public License for more details.
> -
> -You should have received a copy of the GNU General Public License
> -along with this program; if not, write to the Free Software
> -Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> -
> -
> -4. Overview and features
> -========================
> -This driver attempts to support the video interface of the devices assembling
> -the SONiX SN9C101, SN9C102, SN9C103, SN9C105 and SN9C120 PC Camera Controllers
> -("SN9C1xx" from now on).
> -
> -The driver relies on the Video4Linux2 and USB core modules. It has been
> -designed to run properly on SMP systems as well.
> -
> -The latest version of the SN9C1xx driver can be found at the following URL:
> -http://www.linux-projects.org/
> -
> -Some of the features of the driver are:
> -
> -- full compliance with the Video4Linux2 API (see also "Notes for V4L2
> -  application developers" paragraph);
> -- available mmap or read/poll methods for video streaming through isochronous
> -  data transfers;
> -- automatic detection of image sensor;
> -- support for built-in microphone interface;
> -- support for any window resolutions and optional panning within the maximum
> -  pixel area of image sensor;
> -- image downscaling with arbitrary scaling factors from 1, 2 and 4 in both
> -  directions (see "Notes for V4L2 application developers" paragraph);
> -- two different video formats for uncompressed or compressed data in low or
> -  high compression quality (see also "Notes for V4L2 application developers"
> -  and "Video frame formats" paragraphs);
> -- full support for the capabilities of many of the possible image sensors that
> -  can be connected to the SN9C1xx bridges, including, for instance, red, green,
> -  blue and global gain adjustments and exposure (see "Supported devices"
> -  paragraph for details);
> -- use of default color settings for sunlight conditions;
> -- dynamic I/O interface for both SN9C1xx and image sensor control and
> -  monitoring (see "Optional device control through 'sysfs'" paragraph);
> -- dynamic driver control thanks to various module parameters (see "Module
> -  parameters" paragraph);
> -- up to 64 cameras can be handled at the same time; they can be connected and
> -  disconnected from the host many times without turning off the computer, if
> -  the system supports hotplugging;
> -- no known bugs.
> -
> -
> -5. Module dependencies
> -======================
> -For it to work properly, the driver needs kernel support for Video4Linux and
> -USB.
> -
> -The following options of the kernel configuration file must be enabled and
> -corresponding modules must be compiled:
> -
> -	# Multimedia devices
> -	#
> -	CONFIG_VIDEO_DEV=m
> -
> -To enable advanced debugging functionality on the device through /sysfs:
> -
> -	# Multimedia devices
> -	#
> -	CONFIG_VIDEO_ADV_DEBUG=y
> -
> -	# USB support
> -	#
> -	CONFIG_USB=m
> -
> -In addition, depending on the hardware being used, the modules below are
> -necessary:
> -
> -	# USB Host Controller Drivers
> -	#
> -	CONFIG_USB_EHCI_HCD=m
> -	CONFIG_USB_UHCI_HCD=m
> -	CONFIG_USB_OHCI_HCD=m
> -
> -The SN9C103, SN9c105 and SN9C120 controllers also provide a built-in microphone
> -interface. It is supported by the USB Audio driver thanks to the ALSA API:
> -
> -	# Sound
> -	#
> -	CONFIG_SOUND=y
> -
> -	# Advanced Linux Sound Architecture
> -	#
> -	CONFIG_SND=m
> -
> -	# USB devices
> -	#
> -	CONFIG_SND_USB_AUDIO=m
> -
> -And finally:
> -
> -	# USB Multimedia devices
> -	#
> -	CONFIG_USB_SN9C102=m
> -
> -
> -6. Module loading
> -=================
> -To use the driver, it is necessary to load the "sn9c102" module into memory
> -after every other module required: "videodev", "v4l2_common", "compat_ioctl32",
> -"usbcore" and, depending on the USB host controller you have, "ehci-hcd",
> -"uhci-hcd" or "ohci-hcd".
> -
> -Loading can be done as shown below:
> -
> -	[root@localhost home]# modprobe sn9c102
> -
> -Note that the module is called "sn9c102" for historic reasons, although it
> -does not just support the SN9C102.
> -
> -At this point all the devices supported by the driver and connected to the USB
> -ports should be recognized. You can invoke "dmesg" to analyze kernel messages
> -and verify that the loading process has gone well:
> -
> -	[user@localhost home]$ dmesg
> -
> -or, to isolate all the kernel messages generated by the driver:
> -
> -	[user@localhost home]$ dmesg | grep sn9c102
> -
> -
> -7. Module parameters
> -====================
> -Module parameters are listed below:
> --------------------------------------------------------------------------------
> -Name:           video_nr
> -Type:           short array (min = 0, max = 64)
> -Syntax:         <-1|n[,...]>
> -Description:    Specify V4L2 minor mode number:
> -		-1 = use next available
> -		 n = use minor number n
> -		You can specify up to 64 cameras this way.
> -		For example:
> -		video_nr=-1,2,-1 would assign minor number 2 to the second
> -		recognized camera and use auto for the first one and for every
> -		other camera.
> -Default:        -1
> --------------------------------------------------------------------------------
> -Name:           force_munmap
> -Type:           bool array (min = 0, max = 64)
> -Syntax:         <0|1[,...]>
> -Description:    Force the application to unmap previously mapped buffer memory
> -		before calling any VIDIOC_S_CROP or VIDIOC_S_FMT ioctl's. Not
> -		all the applications support this feature. This parameter is
> -		specific for each detected camera.
> -		0 = do not force memory unmapping
> -		1 = force memory unmapping (save memory)
> -Default:        0
> --------------------------------------------------------------------------------
> -Name:           frame_timeout
> -Type:           uint array (min = 0, max = 64)
> -Syntax:         <0|n[,...]>
> -Description:    Timeout for a video frame in seconds before returning an I/O
> -		error; 0 for infinity. This parameter is specific for each
> -		detected camera and can be changed at runtime thanks to the
> -		/sys filesystem interface.
> -Default:        2
> --------------------------------------------------------------------------------
> -Name:           debug
> -Type:           ushort
> -Syntax:         <n>
> -Description:    Debugging information level, from 0 to 3:
> -		0 = none (use carefully)
> -		1 = critical errors
> -		2 = significant information
> -		3 = more verbose messages
> -		Level 3 is useful for testing only. It also shows some more
> -		information about the hardware being detected.
> -		This parameter can be changed at runtime thanks to the /sys
> -		filesystem interface.
> -Default:        2
> --------------------------------------------------------------------------------
> -
> -
> -8. Optional device control through "sysfs" [1]
> -==========================================
> -If the kernel has been compiled with the CONFIG_VIDEO_ADV_DEBUG option enabled,
> -it is possible to read and write both the SN9C1xx and the image sensor
> -registers by using the "sysfs" filesystem interface.
> -
> -Every time a supported device is recognized, a write-only file named "green" is
> -created in the /sys/class/video4linux/videoX directory. You can set the green
> -channel's gain by writing the desired value to it. The value may range from 0
> -to 15 for the SN9C101 or SN9C102 bridges, from 0 to 127 for the SN9C103,
> -SN9C105 and SN9C120 bridges.
> -Similarly, only for the SN9C103, SN9C105 and SN9C120 controllers, blue and red
> -gain control files are available in the same directory, for which accepted
> -values may range from 0 to 127.
> -
> -There are other four entries in the directory above for each registered camera:
> -"reg", "val", "i2c_reg" and "i2c_val". The first two files control the
> -SN9C1xx bridge, while the other two control the sensor chip. "reg" and
> -"i2c_reg" hold the values of the current register index where the following
> -reading/writing operations are addressed at through "val" and "i2c_val". Their
> -use is not intended for end-users. Note that "i2c_reg" and "i2c_val" will not
> -be created if the sensor does not actually support the standard I2C protocol or
> -its registers are not 8-bit long. Also, remember that you must be logged in as
> -root before writing to them.
> -
> -As an example, suppose we were to want to read the value contained in the
> -register number 1 of the sensor register table - which is usually the product
> -identifier - of the camera registered as "/dev/video0":
> -
> -	[root@localhost #] cd /sys/class/video4linux/video0
> -	[root@localhost #] echo 1 > i2c_reg
> -	[root@localhost #] cat i2c_val
> -
> -Note that "cat" will fail if sensor registers cannot be read.
> -
> -Now let's set the green gain's register of the SN9C101 or SN9C102 chips to 2:
> -
> -	[root@localhost #] echo 0x11 > reg
> -	[root@localhost #] echo 2 > val
> -
> -Note that the SN9C1xx always returns 0 when some of its registers are read.
> -To avoid race conditions, all the I/O accesses to the above files are
> -serialized.
> -The sysfs interface also provides the "frame_header" entry, which exports the
> -frame header of the most recent requested and captured video frame. The header
> -is always 18-bytes long and is appended to every video frame by the SN9C1xx
> -controllers. As an example, this additional information can be used by the user
> -application for implementing auto-exposure features via software.
> -
> -The following table describes the frame header exported by the SN9C101 and
> -SN9C102:
> -
> -Byte #  Value or bits Description
> -------  ------------- -----------
> -0x00    0xFF          Frame synchronisation pattern
> -0x01    0xFF          Frame synchronisation pattern
> -0x02    0x00          Frame synchronisation pattern
> -0x03    0xC4          Frame synchronisation pattern
> -0x04    0xC4          Frame synchronisation pattern
> -0x05    0x96          Frame synchronisation pattern
> -0x06    [3:0]         Read channel gain control = (1+R_GAIN/8)
> -	[7:4]         Blue channel gain control = (1+B_GAIN/8)
> -0x07    [ 0 ]         Compression mode. 0=No compression, 1=Compression enabled
> -	[2:1]         Maximum scale factor for compression
> -	[ 3 ]         1 = USB fifo(2K bytes) is full
> -	[ 4 ]         1 = Digital gain is finish
> -	[ 5 ]         1 = Exposure is finish
> -	[7:6]         Frame index
> -0x08    [7:0]         Y sum inside Auto-Exposure area (low-byte)
> -0x09    [7:0]         Y sum inside Auto-Exposure area (high-byte)
> -		      where Y sum = (R/4 + 5G/16 + B/8) / 32
> -0x0A    [7:0]         Y sum outside Auto-Exposure area (low-byte)
> -0x0B    [7:0]         Y sum outside Auto-Exposure area (high-byte)
> -		      where Y sum = (R/4 + 5G/16 + B/8) / 128
> -0x0C    0xXX          Not used
> -0x0D    0xXX          Not used
> -0x0E    0xXX          Not used
> -0x0F    0xXX          Not used
> -0x10    0xXX          Not used
> -0x11    0xXX          Not used
> -
> -The following table describes the frame header exported by the SN9C103:
> -
> -Byte #  Value or bits Description
> -------  ------------- -----------
> -0x00    0xFF          Frame synchronisation pattern
> -0x01    0xFF          Frame synchronisation pattern
> -0x02    0x00          Frame synchronisation pattern
> -0x03    0xC4          Frame synchronisation pattern
> -0x04    0xC4          Frame synchronisation pattern
> -0x05    0x96          Frame synchronisation pattern
> -0x06    [6:0]         Read channel gain control = (1/2+R_GAIN/64)
> -0x07    [6:0]         Blue channel gain control = (1/2+B_GAIN/64)
> -	[7:4]
> -0x08    [ 0 ]         Compression mode. 0=No compression, 1=Compression enabled
> -	[2:1]         Maximum scale factor for compression
> -	[ 3 ]         1 = USB fifo(2K bytes) is full
> -	[ 4 ]         1 = Digital gain is finish
> -	[ 5 ]         1 = Exposure is finish
> -	[7:6]         Frame index
> -0x09    [7:0]         Y sum inside Auto-Exposure area (low-byte)
> -0x0A    [7:0]         Y sum inside Auto-Exposure area (high-byte)
> -		      where Y sum = (R/4 + 5G/16 + B/8) / 32
> -0x0B    [7:0]         Y sum outside Auto-Exposure area (low-byte)
> -0x0C    [7:0]         Y sum outside Auto-Exposure area (high-byte)
> -		      where Y sum = (R/4 + 5G/16 + B/8) / 128
> -0x0D    [1:0]         Audio frame number
> -	[ 2 ]         1 = Audio is recording
> -0x0E    [7:0]         Audio summation (low-byte)
> -0x0F    [7:0]         Audio summation (high-byte)
> -0x10    [7:0]         Audio sample count
> -0x11    [7:0]         Audio peak data in audio frame
> -
> -The AE area (sx, sy, ex, ey) in the active window can be set by programming the
> -registers 0x1c, 0x1d, 0x1e and 0x1f of the SN9C1xx controllers, where one unit
> -corresponds to 32 pixels.
> -
> -[1] The frame headers exported by the SN9C105 and SN9C120 are not described.
> -
> -
> -9. Supported devices
> -====================
> -None of the names of the companies as well as their products will be mentioned
> -here. They have never collaborated with the author, so no advertising.
> -
> -From the point of view of a driver, what unambiguously identify a device are
> -its vendor and product USB identifiers. Below is a list of known identifiers of
> -devices assembling the SN9C1xx PC camera controllers:
> -
> -Vendor ID  Product ID
> ----------  ----------
> -0x0458     0x7025
> -0x045e     0x00f5
> -0x045e     0x00f7
> -0x0471     0x0327
> -0x0471     0x0328
> -0x0c45     0x6001
> -0x0c45     0x6005
> -0x0c45     0x6007
> -0x0c45     0x6009
> -0x0c45     0x600d
> -0x0c45     0x6011
> -0x0c45     0x6019
> -0x0c45     0x6024
> -0x0c45     0x6025
> -0x0c45     0x6028
> -0x0c45     0x6029
> -0x0c45     0x602a
> -0x0c45     0x602b
> -0x0c45     0x602c
> -0x0c45     0x602d
> -0x0c45     0x602e
> -0x0c45     0x6030
> -0x0c45     0x603f
> -0x0c45     0x6080
> -0x0c45     0x6082
> -0x0c45     0x6083
> -0x0c45     0x6088
> -0x0c45     0x608a
> -0x0c45     0x608b
> -0x0c45     0x608c
> -0x0c45     0x608e
> -0x0c45     0x608f
> -0x0c45     0x60a0
> -0x0c45     0x60a2
> -0x0c45     0x60a3
> -0x0c45     0x60a8
> -0x0c45     0x60aa
> -0x0c45     0x60ab
> -0x0c45     0x60ac
> -0x0c45     0x60ae
> -0x0c45     0x60af
> -0x0c45     0x60b0
> -0x0c45     0x60b2
> -0x0c45     0x60b3
> -0x0c45     0x60b8
> -0x0c45     0x60ba
> -0x0c45     0x60bb
> -0x0c45     0x60bc
> -0x0c45     0x60be
> -0x0c45     0x60c0
> -0x0c45     0x60c2
> -0x0c45     0x60c8
> -0x0c45     0x60cc
> -0x0c45     0x60ea
> -0x0c45     0x60ec
> -0x0c45     0x60ef
> -0x0c45     0x60fa
> -0x0c45     0x60fb
> -0x0c45     0x60fc
> -0x0c45     0x60fe
> -0x0c45     0x6102
> -0x0c45     0x6108
> -0x0c45     0x610f
> -0x0c45     0x6130
> -0x0c45     0x6138
> -0x0c45     0x613a
> -0x0c45     0x613b
> -0x0c45     0x613c
> -0x0c45     0x613e
> -
> -The list above does not imply that all those devices work with this driver: up
> -until now only the ones that assemble the following pairs of SN9C1xx bridges
> -and image sensors are supported; kernel messages will always tell you whether
> -this is the case (see "Module loading" paragraph):
> -
> -Image sensor / SN9C1xx bridge      | SN9C10[12]  SN9C103  SN9C105  SN9C120
> --------------------------------------------------------------------------------
> -HV7131D    Hynix Semiconductor     | Yes         No       No       No
> -HV7131R    Hynix Semiconductor     | No          Yes      Yes      Yes
> -MI-0343    Micron Technology       | Yes         No       No       No
> -MI-0360    Micron Technology       | No          Yes      Yes      Yes
> -OV7630     OmniVision Technologies | Yes         Yes      Yes      Yes
> -OV7660     OmniVision Technologies | No          No       Yes      Yes
> -PAS106B    PixArt Imaging          | Yes         No       No       No
> -PAS202B    PixArt Imaging          | Yes         Yes      No       No
> -TAS5110C1B Taiwan Advanced Sensor  | Yes         No       No       No
> -TAS5110D   Taiwan Advanced Sensor  | Yes         No       No       No
> -TAS5130D1B Taiwan Advanced Sensor  | Yes         No       No       No
> -
> -"Yes" means that the pair is supported by the driver, while "No" means that the
> -pair does not exist or is not supported by the driver.
> -
> -Only some of the available control settings of each image sensor are supported
> -through the V4L2 interface.
> -
> -Donations of new models for further testing and support would be much
> -appreciated. Non-available hardware will not be supported by the author of this
> -driver.
> -
> -
> -10. Notes for V4L2 application developers
> -=========================================
> -This driver follows the V4L2 API specifications. In particular, it enforces two
> -rules:
> -
> -- exactly one I/O method, either "mmap" or "read", is associated with each
> -file descriptor. Once it is selected, the application must close and reopen the
> -device to switch to the other I/O method;
> -
> -- although it is not mandatory, previously mapped buffer memory should always
> -be unmapped before calling any "VIDIOC_S_CROP" or "VIDIOC_S_FMT" ioctl's.
> -The same number of buffers as before will be allocated again to match the size
> -of the new video frames, so you have to map the buffers again before any I/O
> -attempts on them.
> -
> -Consistently with the hardware limits, this driver also supports image
> -downscaling with arbitrary scaling factors from 1, 2 and 4 in both directions.
> -However, the V4L2 API specifications don't correctly define how the scaling
> -factor can be chosen arbitrarily by the "negotiation" of the "source" and
> -"target" rectangles. To work around this flaw, we have added the convention
> -that, during the negotiation, whenever the "VIDIOC_S_CROP" ioctl is issued, the
> -scaling factor is restored to 1.
> -
> -This driver supports two different video formats: the first one is the "8-bit
> -Sequential Bayer" format and can be used to obtain uncompressed video data
> -from the device through the current I/O method, while the second one provides
> -either "raw" compressed video data (without frame headers not related to the
> -compressed data) or standard JPEG (with frame headers). The compression quality
> -may vary from 0 to 1 and can be selected or queried thanks to the
> -VIDIOC_S_JPEGCOMP and VIDIOC_G_JPEGCOMP V4L2 ioctl's. For maximum flexibility,
> -both the default active video format and the default compression quality
> -depend on how the image sensor being used is initialized.
> -
> -
> -11. Video frame formats [1]
> -=======================
> -The SN9C1xx PC Camera Controllers can send images in two possible video
> -formats over the USB: either native "Sequential RGB Bayer" or compressed.
> -The compression is used to achieve high frame rates. With regard to the
> -SN9C101, SN9C102 and SN9C103, the compression is based on the Huffman encoding
> -algorithm described below, while with regard to the SN9C105 and SN9C120 the
> -compression is based on the JPEG standard.
> -The current video format may be selected or queried from the user application
> -by calling the VIDIOC_S_FMT or VIDIOC_G_FMT ioctl's, as described in the V4L2
> -API specifications.
> -
> -The name "Sequential Bayer" indicates the organization of the red, green and
> -blue pixels in one video frame. Each pixel is associated with a 8-bit long
> -value and is disposed in memory according to the pattern shown below:
> -
> -B[0]   G[1]    B[2]    G[3]    ...   B[m-2]         G[m-1]
> -G[m]   R[m+1]  G[m+2]  R[m+2]  ...   G[2m-2]        R[2m-1]
> -...
> -...                                  B[(n-1)(m-2)]  G[(n-1)(m-1)]
> -...                                  G[n(m-2)]      R[n(m-1)]
> -
> -The above matrix also represents the sequential or progressive read-out mode of
> -the (n, m) Bayer color filter array used in many CCD or CMOS image sensors.
> -
> -The Huffman compressed video frame consists of a bitstream that encodes for
> -every R, G, or B pixel the difference between the value of the pixel itself and
> -some reference pixel value. Pixels are organised in the Bayer pattern and the
> -Bayer sub-pixels are tracked individually and alternatingly. For example, in
> -the first line values for the B and G1 pixels are alternatingly encoded, while
> -in the second line values for the G2 and R pixels are alternatingly encoded.
> -
> -The pixel reference value is calculated as follows:
> -- the 4 top left pixels are encoded in raw uncompressed 8-bit format;
> -- the value in the top two rows is the value of the pixel left of the current
> -  pixel;
> -- the value in the left column is the value of the pixel above the current
> -  pixel;
> -- for all other pixels, the reference value is the average of the value of the
> -  pixel on the left and the value of the pixel above the current pixel;
> -- there is one code in the bitstream that specifies the value of a pixel
> -  directly (in 4-bit resolution);
> -- pixel values need to be clamped inside the range [0..255] for proper
> -  decoding.
> -
> -The algorithm purely describes the conversion from compressed Bayer code used
> -in the SN9C101, SN9C102 and SN9C103 chips to uncompressed Bayer. Additional
> -steps are required to convert this to a color image (i.e. a color interpolation
> -algorithm).
> -
> -The following Huffman codes have been found:
> -0: +0 (relative to reference pixel value)
> -100: +4
> -101: -4?
> -1110xxxx: set absolute value to xxxx.0000
> -1101: +11
> -1111: -11
> -11001: +20
> -110000: -20
> -110001: ??? - these codes are apparently not used
> -
> -[1] The Huffman compression algorithm has been reverse-engineered and
> -    documented by Bertrik Sikken.
> -
> -
> -12. Contact information
> -=======================
> -The author may be contacted by e-mail at <luca.risolia@studio.unibo.it>.
> -
> -GPG/PGP encrypted e-mail's are accepted. The GPG key ID of the author is
> -'FCE635A4'; the public 1024-bit key should be available at any keyserver;
> -the fingerprint is: '88E8 F32F 7244 68BA 3958  5D40 99DA 5D2A FCE6 35A4'.
> -
> -
> -13. Credits
> -===========
> -Many thanks to following persons for their contribute (listed in alphabetical
> -order):
> -
> -- David Anderson for the donation of a webcam;
> -- Luca Capello for the donation of a webcam;
> -- Philippe Coval for having helped testing the PAS202BCA image sensor;
> -- Joao Rodrigo Fuzaro, Joao Limirio, Claudio Filho and Caio Begotti for the
> -  donation of a webcam;
> -- Dennis Heitmann for the donation of a webcam;
> -- Jon Hollstrom for the donation of a webcam;
> -- Nick McGill for the donation of a webcam;
> -- Carlos Eduardo Medaglia Dyonisio, who added the support for the PAS202BCB
> -  image sensor;
> -- Stefano Mozzi, who donated 45 EU;
> -- Andrew Pearce for the donation of a webcam;
> -- John Pullan for the donation of a webcam;
> -- Bertrik Sikken, who reverse-engineered and documented the Huffman compression
> -  algorithm used in the SN9C101, SN9C102 and SN9C103 controllers and
> -  implemented the first decoder;
> -- Ronny Standke for the donation of a webcam;
> -- Mizuno Takafumi for the donation of a webcam;
> -- an "anonymous" donator (who didn't want his name to be revealed) for the
> -  donation of a webcam.
> -- an anonymous donator for the donation of four webcams and two boards with ten
> -  image sensors.
> diff --git a/drivers/staging/media/sn9c102/sn9c102_config.h b/drivers/staging/media/sn9c102/sn9c102_config.h
> deleted file mode 100644
> index 0f4e037..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_config.h
> +++ /dev/null
> @@ -1,86 +0,0 @@
> -/***************************************************************************
> - * Global parameters for the V4L2 driver for SN9C1xx PC Camera Controllers *
> - *                                                                         *
> - * Copyright (C) 2007 by Luca Risolia <luca.risolia@studio.unibo.it>       *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#ifndef _SN9C102_CONFIG_H_
> -#define _SN9C102_CONFIG_H_
> -
> -#include <linux/types.h>
> -#include <linux/jiffies.h>
> -
> -#define SN9C102_DEBUG
> -#define SN9C102_DEBUG_LEVEL       2
> -#define SN9C102_MAX_DEVICES       64
> -#define SN9C102_PRESERVE_IMGSCALE 0
> -#define SN9C102_FORCE_MUNMAP      0
> -#define SN9C102_MAX_FRAMES        32
> -#define SN9C102_URBS              2
> -#define SN9C102_ISO_PACKETS       7
> -#define SN9C102_ALTERNATE_SETTING 8
> -#define SN9C102_URB_TIMEOUT       msecs_to_jiffies(2 * SN9C102_ISO_PACKETS)
> -#define SN9C102_CTRL_TIMEOUT      300
> -#define SN9C102_FRAME_TIMEOUT     0
> -
> -/*****************************************************************************/
> -
> -static const u8 SN9C102_Y_QTABLE0[64] = {
> -	 8,   5,   5,   8,  12,  20,  25,  30,
> -	 6,   6,   7,   9,  13,  29,  30,  27,
> -	 7,   6,   8,  12,  20,  28,  34,  28,
> -	 7,   8,  11,  14,  25,  43,  40,  31,
> -	 9,  11,  18,  28,  34,  54,  51,  38,
> -	12,  17,  27,  32,  40,  52,  56,  46,
> -	24,  32,  39,  43,  51,  60,  60,  50,
> -	36,  46,  47,  49,  56,  50,  51,  49
> -};
> -
> -static const u8 SN9C102_UV_QTABLE0[64] = {
> -	 8,   9,  12,  23,  49,  49,  49,  49,
> -	 9,  10,  13,  33,  49,  49,  49,  49,
> -	12,  13,  28,  49,  49,  49,  49,  49,
> -	23,  33,  49,  49,  49,  49,  49,  49,
> -	49,  49,  49,  49,  49,  49,  49,  49,
> -	49,  49,  49,  49,  49,  49,  49,  49,
> -	49,  49,  49,  49,  49,  49,  49,  49,
> -	49,  49,  49,  49,  49,  49,  49,  49
> -};
> -
> -static const u8 SN9C102_Y_QTABLE1[64] = {
> -	16,  11,  10,  16,  24,  40,  51,  61,
> -	12,  12,  14,  19,  26,  58,  60,  55,
> -	14,  13,  16,  24,  40,  57,  69,  56,
> -	14,  17,  22,  29,  51,  87,  80,  62,
> -	18,  22,  37,  56,  68, 109, 103,  77,
> -	24,  35,  55,  64,  81, 104, 113,  92,
> -	49,  64,  78,  87, 103, 121, 120, 101,
> -	72,  92,  95,  98, 112, 100, 103,  99
> -};
> -
> -static const u8 SN9C102_UV_QTABLE1[64] = {
> -	17,  18,  24,  47,  99,  99,  99,  99,
> -	18,  21,  26,  66,  99,  99,  99,  99,
> -	24,  26,  56,  99,  99,  99,  99,  99,
> -	47,  66,  99,  99,  99,  99,  99,  99,
> -	99,  99,  99,  99,  99,  99,  99,  99,
> -	99,  99,  99,  99,  99,  99,  99,  99,
> -	99,  99,  99,  99,  99,  99,  99,  99,
> -	99,  99,  99,  99,  99,  99,  99,  99
> -};
> -
> -#endif /* _SN9C102_CONFIG_H_ */
> diff --git a/drivers/staging/media/sn9c102/sn9c102_core.c b/drivers/staging/media/sn9c102/sn9c102_core.c
> deleted file mode 100644
> index 98b3057..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_core.c
> +++ /dev/null
> @@ -1,3465 +0,0 @@
> -/***************************************************************************
> - * V4L2 driver for SN9C1xx PC Camera Controllers                           *
> - *                                                                         *
> - * Copyright (C) 2004-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include <linux/module.h>
> -#include <linux/init.h>
> -#include <linux/kernel.h>
> -#include <linux/param.h>
> -#include <linux/errno.h>
> -#include <linux/slab.h>
> -#include <linux/device.h>
> -#include <linux/fs.h>
> -#include <linux/delay.h>
> -#include <linux/compiler.h>
> -#include <linux/ioctl.h>
> -#include <linux/poll.h>
> -#include <linux/stat.h>
> -#include <linux/mm.h>
> -#include <linux/vmalloc.h>
> -#include <linux/version.h>
> -#include <linux/page-flags.h>
> -#include <asm/byteorder.h>
> -#include <asm/page.h>
> -#include <asm/uaccess.h>
> -
> -#include "sn9c102.h"
> -
> -/*****************************************************************************/
> -
> -#define SN9C102_MODULE_NAME     "V4L2 driver for SN9C1xx PC Camera Controllers"
> -#define SN9C102_MODULE_ALIAS    "sn9c1xx"
> -#define SN9C102_MODULE_AUTHOR   "(C) 2004-2007 Luca Risolia"
> -#define SN9C102_AUTHOR_EMAIL    "<luca.risolia@studio.unibo.it>"
> -#define SN9C102_MODULE_LICENSE  "GPL"
> -#define SN9C102_MODULE_VERSION  "1:1.48"
> -
> -/*****************************************************************************/
> -
> -MODULE_DEVICE_TABLE(usb, sn9c102_id_table);
> -
> -MODULE_AUTHOR(SN9C102_MODULE_AUTHOR " " SN9C102_AUTHOR_EMAIL);
> -MODULE_DESCRIPTION(SN9C102_MODULE_NAME);
> -MODULE_ALIAS(SN9C102_MODULE_ALIAS);
> -MODULE_VERSION(SN9C102_MODULE_VERSION);
> -MODULE_LICENSE(SN9C102_MODULE_LICENSE);
> -
> -static short video_nr[] = {[0 ... SN9C102_MAX_DEVICES-1] = -1};
> -module_param_array(video_nr, short, NULL, 0444);
> -MODULE_PARM_DESC(video_nr,
> -		 " <-1|n[,...]>"
> -		 "\nSpecify V4L2 minor mode number."
> -		 "\n-1 = use next available (default)"
> -		 "\n n = use minor number n (integer >= 0)"
> -		 "\nYou can specify up to "__MODULE_STRING(SN9C102_MAX_DEVICES)
> -		 " cameras this way."
> -		 "\nFor example:"
> -		 "\nvideo_nr=-1,2,-1 would assign minor number 2 to"
> -		 "\nthe second camera and use auto for the first"
> -		 "\none and for every other camera."
> -		 "\n");
> -
> -static bool force_munmap[] = {[0 ... SN9C102_MAX_DEVICES-1] =
> -			      SN9C102_FORCE_MUNMAP};
> -module_param_array(force_munmap, bool, NULL, 0444);
> -MODULE_PARM_DESC(force_munmap,
> -		 " <0|1[,...]>"
> -		 "\nForce the application to unmap previously"
> -		 "\nmapped buffer memory before calling any VIDIOC_S_CROP or"
> -		 "\nVIDIOC_S_FMT ioctl's. Not all the applications support"
> -		 "\nthis feature. This parameter is specific for each"
> -		 "\ndetected camera."
> -		 "\n0 = do not force memory unmapping"
> -		 "\n1 = force memory unmapping (save memory)"
> -		 "\nDefault value is "__MODULE_STRING(SN9C102_FORCE_MUNMAP)"."
> -		 "\n");
> -
> -static unsigned int frame_timeout[] = {[0 ... SN9C102_MAX_DEVICES-1] =
> -				       SN9C102_FRAME_TIMEOUT};
> -module_param_array(frame_timeout, uint, NULL, 0644);
> -MODULE_PARM_DESC(frame_timeout,
> -		 " <0|n[,...]>"
> -		 "\nTimeout for a video frame in seconds before"
> -		 "\nreturning an I/O error; 0 for infinity."
> -		 "\nThis parameter is specific for each detected camera."
> -		 "\nDefault value is "__MODULE_STRING(SN9C102_FRAME_TIMEOUT)"."
> -		 "\n");
> -
> -#ifdef SN9C102_DEBUG
> -static unsigned short debug = SN9C102_DEBUG_LEVEL;
> -module_param(debug, ushort, 0644);
> -MODULE_PARM_DESC(debug,
> -		 " <n>"
> -		 "\nDebugging information level, from 0 to 3:"
> -		 "\n0 = none (use carefully)"
> -		 "\n1 = critical errors"
> -		 "\n2 = significant informations"
> -		 "\n3 = more verbose messages"
> -		 "\nLevel 3 is useful for testing only."
> -		 "\nDefault value is "__MODULE_STRING(SN9C102_DEBUG_LEVEL)"."
> -		 "\n");
> -#endif
> -
> -/*
> -   Add the probe entries to this table. Be sure to add the entry in the right
> -   place, since, on failure, the next probing routine is called according to
> -   the order of the list below, from top to bottom.
> -*/
> -static int (*sn9c102_sensor_table[])(struct sn9c102_device *) = {
> -	&sn9c102_probe_hv7131d, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_hv7131r, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_mi0343, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_mi0360, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_mt9v111, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_pas106b, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_pas202bcb, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_ov7630, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_ov7660, /* strong detection based on SENSOR ids */
> -	&sn9c102_probe_tas5110c1b, /* detection based on USB pid/vid */
> -	&sn9c102_probe_tas5110d, /* detection based on USB pid/vid */
> -	&sn9c102_probe_tas5130d1b, /* detection based on USB pid/vid */
> -};
> -
> -/*****************************************************************************/
> -
> -static u32
> -sn9c102_request_buffers(struct sn9c102_device *cam, u32 count,
> -			enum sn9c102_io_method io)
> -{
> -	struct v4l2_pix_format *p = &(cam->sensor.pix_format);
> -	struct v4l2_rect *r = &(cam->sensor.cropcap.bounds);
> -	size_t imagesize = cam->module_param.force_munmap || io == IO_READ ?
> -			   (p->width * p->height * p->priv) / 8 :
> -			   (r->width * r->height * p->priv) / 8;
> -	void *buff = NULL;
> -	u32 i;
> -
> -	if (count > SN9C102_MAX_FRAMES)
> -		count = SN9C102_MAX_FRAMES;
> -
> -	if (cam->bridge == BRIDGE_SN9C105 || cam->bridge == BRIDGE_SN9C120)
> -		imagesize += 589 + 2; /* length of JPEG header + EOI marker */
> -
> -	cam->nbuffers = count;
> -	while (cam->nbuffers > 0) {
> -		buff = vmalloc_32_user(cam->nbuffers * PAGE_ALIGN(imagesize));
> -		if (buff)
> -			break;
> -		cam->nbuffers--;
> -	}
> -
> -	for (i = 0; i < cam->nbuffers; i++) {
> -		cam->frame[i].bufmem = buff + i*PAGE_ALIGN(imagesize);
> -		cam->frame[i].buf.index = i;
> -		cam->frame[i].buf.m.offset = i*PAGE_ALIGN(imagesize);
> -		cam->frame[i].buf.length = imagesize;
> -		cam->frame[i].buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -		cam->frame[i].buf.sequence = 0;
> -		cam->frame[i].buf.field = V4L2_FIELD_NONE;
> -		cam->frame[i].buf.memory = V4L2_MEMORY_MMAP;
> -		cam->frame[i].buf.flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> -	}
> -
> -	return cam->nbuffers;
> -}
> -
> -
> -static void sn9c102_release_buffers(struct sn9c102_device *cam)
> -{
> -	if (cam->nbuffers) {
> -		vfree(cam->frame[0].bufmem);
> -		cam->nbuffers = 0;
> -	}
> -	cam->frame_current = NULL;
> -}
> -
> -
> -static void sn9c102_empty_framequeues(struct sn9c102_device *cam)
> -{
> -	u32 i;
> -
> -	INIT_LIST_HEAD(&cam->inqueue);
> -	INIT_LIST_HEAD(&cam->outqueue);
> -
> -	for (i = 0; i < SN9C102_MAX_FRAMES; i++) {
> -		cam->frame[i].state = F_UNUSED;
> -		cam->frame[i].buf.bytesused = 0;
> -	}
> -}
> -
> -
> -static void sn9c102_requeue_outqueue(struct sn9c102_device *cam)
> -{
> -	struct sn9c102_frame_t *i;
> -
> -	list_for_each_entry(i, &cam->outqueue, frame) {
> -		i->state = F_QUEUED;
> -		list_add(&i->frame, &cam->inqueue);
> -	}
> -
> -	INIT_LIST_HEAD(&cam->outqueue);
> -}
> -
> -
> -static void sn9c102_queue_unusedframes(struct sn9c102_device *cam)
> -{
> -	unsigned long lock_flags;
> -	u32 i;
> -
> -	for (i = 0; i < cam->nbuffers; i++)
> -		if (cam->frame[i].state == F_UNUSED) {
> -			cam->frame[i].state = F_QUEUED;
> -			spin_lock_irqsave(&cam->queue_lock, lock_flags);
> -			list_add_tail(&cam->frame[i].frame, &cam->inqueue);
> -			spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
> -		}
> -}
> -
> -/*****************************************************************************/
> -
> -/*
> -   Write a sequence of count value/register pairs. Returns -1 after the first
> -   failed write, or 0 for no errors.
> -*/
> -int sn9c102_write_regs(struct sn9c102_device *cam, const u8 valreg[][2],
> -		       int count)
> -{
> -	struct usb_device *udev = cam->usbdev;
> -	u8 *buff = cam->control_buffer;
> -	int i, res;
> -
> -	for (i = 0; i < count; i++) {
> -		u8 index = valreg[i][1];
> -
> -		/*
> -		   index is a u8, so it must be <256 and can't be out of range.
> -		   If we put in a check anyway, gcc annoys us with a warning
> -		   hat our check is useless. People get all uppity when they
> -		   see warnings in the kernel compile.
> -		*/
> -
> -		*buff = valreg[i][0];
> -
> -		res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x08,
> -				      0x41, index, 0, buff, 1,
> -				      SN9C102_CTRL_TIMEOUT);
> -
> -		if (res < 0) {
> -			DBG(3, "Failed to write a register (value 0x%02X, "
> -			       "index 0x%02X, error %d)", *buff, index, res);
> -			return -1;
> -		}
> -
> -		cam->reg[index] = *buff;
> -	}
> -
> -	return 0;
> -}
> -
> -
> -int sn9c102_write_reg(struct sn9c102_device *cam, u8 value, u16 index)
> -{
> -	struct usb_device *udev = cam->usbdev;
> -	u8 *buff = cam->control_buffer;
> -	int res;
> -
> -	if (index >= ARRAY_SIZE(cam->reg))
> -		return -1;
> -
> -	*buff = value;
> -
> -	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x08, 0x41,
> -			      index, 0, buff, 1, SN9C102_CTRL_TIMEOUT);
> -	if (res < 0) {
> -		DBG(3, "Failed to write a register (value 0x%02X, index "
> -		       "0x%02X, error %d)", value, index, res);
> -		return -1;
> -	}
> -
> -	cam->reg[index] = value;
> -
> -	return 0;
> -}
> -
> -
> -/* NOTE: with the SN9C10[123] reading some registers always returns 0 */
> -int sn9c102_read_reg(struct sn9c102_device *cam, u16 index)
> -{
> -	struct usb_device *udev = cam->usbdev;
> -	u8 *buff = cam->control_buffer;
> -	int res;
> -
> -	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00, 0xc1,
> -			      index, 0, buff, 1, SN9C102_CTRL_TIMEOUT);
> -	if (res < 0)
> -		DBG(3, "Failed to read a register (index 0x%02X, error %d)",
> -		    index, res);
> -
> -	return (res >= 0) ? (int)(*buff) : -1;
> -}
> -
> -
> -int sn9c102_pread_reg(struct sn9c102_device *cam, u16 index)
> -{
> -	if (index >= ARRAY_SIZE(cam->reg))
> -		return -1;
> -
> -	return cam->reg[index];
> -}
> -
> -
> -static int
> -sn9c102_i2c_wait(struct sn9c102_device *cam,
> -		 const struct sn9c102_sensor *sensor)
> -{
> -	int i, r;
> -
> -	for (i = 1; i <= 5; i++) {
> -		r = sn9c102_read_reg(cam, 0x08);
> -		if (r < 0)
> -			return -EIO;
> -		if (r & 0x04)
> -			return 0;
> -		if (sensor->frequency & SN9C102_I2C_400KHZ)
> -			udelay(5*16);
> -		else
> -			udelay(16*16);
> -	}
> -	return -EBUSY;
> -}
> -
> -
> -static int
> -sn9c102_i2c_detect_read_error(struct sn9c102_device *cam,
> -			      const struct sn9c102_sensor *sensor)
> -{
> -	int r , err = 0;
> -
> -	r = sn9c102_read_reg(cam, 0x08);
> -	if (r < 0)
> -		err += r;
> -
> -	if (cam->bridge == BRIDGE_SN9C101 || cam->bridge == BRIDGE_SN9C102) {
> -		if (!(r & 0x08))
> -			err += -1;
> -	} else {
> -		if (r & 0x08)
> -			err += -1;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int
> -sn9c102_i2c_detect_write_error(struct sn9c102_device *cam,
> -			       const struct sn9c102_sensor *sensor)
> -{
> -	int r;
> -
> -	r = sn9c102_read_reg(cam, 0x08);
> -	return (r < 0 || (r >= 0 && (r & 0x08))) ? -EIO : 0;
> -}
> -
> -
> -int
> -sn9c102_i2c_try_raw_read(struct sn9c102_device *cam,
> -			 const struct sn9c102_sensor *sensor, u8 data0,
> -			 u8 data1, u8 n, u8 buffer[])
> -{
> -	struct usb_device *udev = cam->usbdev;
> -	u8 *data = cam->control_buffer;
> -	int i = 0, err = 0, res;
> -
> -	/* Write cycle */
> -	data[0] = ((sensor->interface == SN9C102_I2C_2WIRES) ? 0x80 : 0) |
> -		  ((sensor->frequency & SN9C102_I2C_400KHZ) ? 0x01 : 0) | 0x10;
> -	data[1] = data0; /* I2C slave id */
> -	data[2] = data1; /* address */
> -	data[7] = 0x10;
> -	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x08, 0x41,
> -			      0x08, 0, data, 8, SN9C102_CTRL_TIMEOUT);
> -	if (res < 0)
> -		err += res;
> -
> -	err += sn9c102_i2c_wait(cam, sensor);
> -
> -	/* Read cycle - n bytes */
> -	data[0] = ((sensor->interface == SN9C102_I2C_2WIRES) ? 0x80 : 0) |
> -		  ((sensor->frequency & SN9C102_I2C_400KHZ) ? 0x01 : 0) |
> -		  (n << 4) | 0x02;
> -	data[1] = data0;
> -	data[7] = 0x10;
> -	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x08, 0x41,
> -			      0x08, 0, data, 8, SN9C102_CTRL_TIMEOUT);
> -	if (res < 0)
> -		err += res;
> -
> -	err += sn9c102_i2c_wait(cam, sensor);
> -
> -	/* The first read byte will be placed in data[4] */
> -	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00, 0xc1,
> -			      0x0a, 0, data, 5, SN9C102_CTRL_TIMEOUT);
> -	if (res < 0)
> -		err += res;
> -
> -	err += sn9c102_i2c_detect_read_error(cam, sensor);
> -
> -	PDBGG("I2C read: address 0x%02X, first read byte: 0x%02X", data1,
> -	      data[4]);
> -
> -	if (err) {
> -		DBG(3, "I2C read failed for %s image sensor", sensor->name);
> -		return -1;
> -	}
> -
> -	if (buffer)
> -		for (i = 0; i < n && i < 5; i++)
> -			buffer[n-i-1] = data[4-i];
> -
> -	return (int)data[4];
> -}
> -
> -
> -int
> -sn9c102_i2c_try_raw_write(struct sn9c102_device *cam,
> -			  const struct sn9c102_sensor *sensor, u8 n, u8 data0,
> -			  u8 data1, u8 data2, u8 data3, u8 data4, u8 data5)
> -{
> -	struct usb_device *udev = cam->usbdev;
> -	u8 *data = cam->control_buffer;
> -	int err = 0, res;
> -
> -	/* Write cycle. It usually is address + value */
> -	data[0] = ((sensor->interface == SN9C102_I2C_2WIRES) ? 0x80 : 0) |
> -		  ((sensor->frequency & SN9C102_I2C_400KHZ) ? 0x01 : 0)
> -		  | ((n - 1) << 4);
> -	data[1] = data0;
> -	data[2] = data1;
> -	data[3] = data2;
> -	data[4] = data3;
> -	data[5] = data4;
> -	data[6] = data5;
> -	data[7] = 0x17;
> -	res = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x08, 0x41,
> -			      0x08, 0, data, 8, SN9C102_CTRL_TIMEOUT);
> -	if (res < 0)
> -		err += res;
> -
> -	err += sn9c102_i2c_wait(cam, sensor);
> -	err += sn9c102_i2c_detect_write_error(cam, sensor);
> -
> -	if (err)
> -		DBG(3, "I2C write failed for %s image sensor", sensor->name);
> -
> -	PDBGG("I2C raw write: %u bytes, data0 = 0x%02X, data1 = 0x%02X, "
> -	      "data2 = 0x%02X, data3 = 0x%02X, data4 = 0x%02X, data5 = 0x%02X",
> -	      n, data0, data1, data2, data3, data4, data5);
> -
> -	return err ? -1 : 0;
> -}
> -
> -
> -int
> -sn9c102_i2c_try_read(struct sn9c102_device *cam,
> -		     const struct sn9c102_sensor *sensor, u8 address)
> -{
> -	return sn9c102_i2c_try_raw_read(cam, sensor, sensor->i2c_slave_id,
> -					address, 1, NULL);
> -}
> -
> -
> -static int sn9c102_i2c_try_write(struct sn9c102_device *cam,
> -				 const struct sn9c102_sensor *sensor,
> -				 u8 address, u8 value)
> -{
> -	return sn9c102_i2c_try_raw_write(cam, sensor, 3,
> -					 sensor->i2c_slave_id, address,
> -					 value, 0, 0, 0);
> -}
> -
> -
> -int sn9c102_i2c_read(struct sn9c102_device *cam, u8 address)
> -{
> -	return sn9c102_i2c_try_read(cam, &cam->sensor, address);
> -}
> -
> -
> -int sn9c102_i2c_write(struct sn9c102_device *cam, u8 address, u8 value)
> -{
> -	return sn9c102_i2c_try_write(cam, &cam->sensor, address, value);
> -}
> -
> -/*****************************************************************************/
> -
> -static size_t sn9c102_sof_length(struct sn9c102_device *cam)
> -{
> -	switch (cam->bridge) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -		return 12;
> -	case BRIDGE_SN9C103:
> -		return 18;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		return 62;
> -	}
> -
> -	return 0;
> -}
> -
> -
> -static void*
> -sn9c102_find_sof_header(struct sn9c102_device *cam, void *mem, size_t len)
> -{
> -	static const char marker[6] = {0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96};
> -	const char *m = mem;
> -	size_t soflen = 0, i, j;
> -
> -	soflen = sn9c102_sof_length(cam);
> -
> -	for (i = 0; i < len; i++) {
> -		size_t b;
> -
> -		/* Read the variable part of the header */
> -		if (unlikely(cam->sof.bytesread >= sizeof(marker))) {
> -			cam->sof.header[cam->sof.bytesread] = *(m+i);
> -			if (++cam->sof.bytesread == soflen) {
> -				cam->sof.bytesread = 0;
> -				return mem + i;
> -			}
> -			continue;
> -		}
> -
> -		/* Search for the SOF marker (fixed part) in the header */
> -		for (j = 0, b = cam->sof.bytesread; j+b < sizeof(marker); j++) {
> -			if (unlikely(i+j == len))
> -				return NULL;
> -			if (*(m+i+j) == marker[cam->sof.bytesread]) {
> -				cam->sof.header[cam->sof.bytesread] = *(m+i+j);
> -				if (++cam->sof.bytesread == sizeof(marker)) {
> -					PDBGG("Bytes to analyze: %zd. SOF "
> -					      "starts at byte #%zd", len, i);
> -					i += j+1;
> -					break;
> -				}
> -			} else {
> -				cam->sof.bytesread = 0;
> -				break;
> -			}
> -		}
> -	}
> -
> -	return NULL;
> -}
> -
> -
> -static void*
> -sn9c102_find_eof_header(struct sn9c102_device *cam, void *mem, size_t len)
> -{
> -	static const u8 eof_header[4][4] = {
> -		{0x00, 0x00, 0x00, 0x00},
> -		{0x40, 0x00, 0x00, 0x00},
> -		{0x80, 0x00, 0x00, 0x00},
> -		{0xc0, 0x00, 0x00, 0x00},
> -	};
> -	size_t i, j;
> -
> -	/* The EOF header does not exist in compressed data */
> -	if (cam->sensor.pix_format.pixelformat == V4L2_PIX_FMT_SN9C10X ||
> -	    cam->sensor.pix_format.pixelformat == V4L2_PIX_FMT_JPEG)
> -		return NULL;
> -
> -	/*
> -	   The EOF header might cross the packet boundary, but this is not a
> -	   problem, since the end of a frame is determined by checking its size
> -	   in the first place.
> -	*/
> -	for (i = 0; (len >= 4) && (i <= len - 4); i++)
> -		for (j = 0; j < ARRAY_SIZE(eof_header); j++)
> -			if (!memcmp(mem + i, eof_header[j], 4))
> -				return mem + i;
> -
> -	return NULL;
> -}
> -
> -
> -static void
> -sn9c102_write_jpegheader(struct sn9c102_device *cam, struct sn9c102_frame_t *f)
> -{
> -	static const u8 jpeg_header[589] = {
> -		0xff, 0xd8, 0xff, 0xdb, 0x00, 0x84, 0x00, 0x06, 0x04, 0x05,
> -		0x06, 0x05, 0x04, 0x06, 0x06, 0x05, 0x06, 0x07, 0x07, 0x06,
> -		0x08, 0x0a, 0x10, 0x0a, 0x0a, 0x09, 0x09, 0x0a, 0x14, 0x0e,
> -		0x0f, 0x0c, 0x10, 0x17, 0x14, 0x18, 0x18, 0x17, 0x14, 0x16,
> -		0x16, 0x1a, 0x1d, 0x25, 0x1f, 0x1a, 0x1b, 0x23, 0x1c, 0x16,
> -		0x16, 0x20, 0x2c, 0x20, 0x23, 0x26, 0x27, 0x29, 0x2a, 0x29,
> -		0x19, 0x1f, 0x2d, 0x30, 0x2d, 0x28, 0x30, 0x25, 0x28, 0x29,
> -		0x28, 0x01, 0x07, 0x07, 0x07, 0x0a, 0x08, 0x0a, 0x13, 0x0a,
> -		0x0a, 0x13, 0x28, 0x1a, 0x16, 0x1a, 0x28, 0x28, 0x28, 0x28,
> -		0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> -		0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> -		0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> -		0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
> -		0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0xff, 0xc4, 0x01, 0xa2,
> -		0x00, 0x00, 0x01, 0x05, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> -		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02,
> -		0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x01,
> -		0x00, 0x03, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> -		0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03,
> -		0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x10, 0x00,
> -		0x02, 0x01, 0x03, 0x03, 0x02, 0x04, 0x03, 0x05, 0x05, 0x04,
> -		0x04, 0x00, 0x00, 0x01, 0x7d, 0x01, 0x02, 0x03, 0x00, 0x04,
> -		0x11, 0x05, 0x12, 0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61,
> -		0x07, 0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08, 0x23,
> -		0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0, 0x24, 0x33, 0x62,
> -		0x72, 0x82, 0x09, 0x0a, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x25,
> -		0x26, 0x27, 0x28, 0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38,
> -		0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a,
> -		0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x63, 0x64,
> -		0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x73, 0x74, 0x75, 0x76,
> -		0x77, 0x78, 0x79, 0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88,
> -		0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99,
> -		0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa,
> -		0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2,
> -		0xc3, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3,
> -		0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2, 0xe3,
> -		0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xf1, 0xf2, 0xf3,
> -		0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0x11, 0x00, 0x02,
> -		0x01, 0x02, 0x04, 0x04, 0x03, 0x04, 0x07, 0x05, 0x04, 0x04,
> -		0x00, 0x01, 0x02, 0x77, 0x00, 0x01, 0x02, 0x03, 0x11, 0x04,
> -		0x05, 0x21, 0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
> -		0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91, 0xa1, 0xb1,
> -		0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0, 0x15, 0x62, 0x72, 0xd1,
> -		0x0a, 0x16, 0x24, 0x34, 0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19,
> -		0x1a, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
> -		0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a,
> -		0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x63, 0x64,
> -		0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x73, 0x74, 0x75, 0x76,
> -		0x77, 0x78, 0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> -		0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
> -		0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9,
> -		0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba,
> -		0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
> -		0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe2, 0xe3,
> -		0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xf2, 0xf3, 0xf4,
> -		0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xff, 0xc0, 0x00, 0x11,
> -		0x08, 0x01, 0xe0, 0x02, 0x80, 0x03, 0x01, 0x21, 0x00, 0x02,
> -		0x11, 0x01, 0x03, 0x11, 0x01, 0xff, 0xda, 0x00, 0x0c, 0x03,
> -		0x01, 0x00, 0x02, 0x11, 0x03, 0x11, 0x00, 0x3f, 0x00
> -	};
> -	u8 *pos = f->bufmem;
> -
> -	memcpy(pos, jpeg_header, sizeof(jpeg_header));
> -	*(pos + 6) = 0x00;
> -	*(pos + 7 + 64) = 0x01;
> -	if (cam->compression.quality == 0) {
> -		memcpy(pos + 7, SN9C102_Y_QTABLE0, 64);
> -		memcpy(pos + 8 + 64, SN9C102_UV_QTABLE0, 64);
> -	} else if (cam->compression.quality == 1) {
> -		memcpy(pos + 7, SN9C102_Y_QTABLE1, 64);
> -		memcpy(pos + 8 + 64, SN9C102_UV_QTABLE1, 64);
> -	}
> -	*(pos + 564) = cam->sensor.pix_format.width & 0xFF;
> -	*(pos + 563) = (cam->sensor.pix_format.width >> 8) & 0xFF;
> -	*(pos + 562) = cam->sensor.pix_format.height & 0xFF;
> -	*(pos + 561) = (cam->sensor.pix_format.height >> 8) & 0xFF;
> -	*(pos + 567) = 0x21;
> -
> -	f->buf.bytesused += sizeof(jpeg_header);
> -}
> -
> -
> -static void sn9c102_urb_complete(struct urb *urb)
> -{
> -	struct sn9c102_device *cam = urb->context;
> -	struct sn9c102_frame_t **f;
> -	size_t imagesize, soflen;
> -	u8 i;
> -	int err = 0;
> -
> -	if (urb->status == -ENOENT)
> -		return;
> -
> -	f = &cam->frame_current;
> -
> -	if (cam->stream == STREAM_INTERRUPT) {
> -		cam->stream = STREAM_OFF;
> -		if ((*f))
> -			(*f)->state = F_QUEUED;
> -		cam->sof.bytesread = 0;
> -		DBG(3, "Stream interrupted by application");
> -		wake_up(&cam->wait_stream);
> -	}
> -
> -	if (cam->state & DEV_DISCONNECTED)
> -		return;
> -
> -	if (cam->state & DEV_MISCONFIGURED) {
> -		wake_up_interruptible(&cam->wait_frame);
> -		return;
> -	}
> -
> -	if (cam->stream == STREAM_OFF || list_empty(&cam->inqueue))
> -		goto resubmit_urb;
> -
> -	if (!(*f))
> -		(*f) = list_entry(cam->inqueue.next, struct sn9c102_frame_t,
> -				  frame);
> -
> -	imagesize = (cam->sensor.pix_format.width *
> -		     cam->sensor.pix_format.height *
> -		     cam->sensor.pix_format.priv) / 8;
> -	if (cam->sensor.pix_format.pixelformat == V4L2_PIX_FMT_JPEG)
> -		imagesize += 589; /* length of jpeg header */
> -	soflen = sn9c102_sof_length(cam);
> -
> -	for (i = 0; i < urb->number_of_packets; i++) {
> -		unsigned int img, len, status;
> -		void *pos, *sof, *eof;
> -
> -		len = urb->iso_frame_desc[i].actual_length;
> -		status = urb->iso_frame_desc[i].status;
> -		pos = urb->iso_frame_desc[i].offset + urb->transfer_buffer;
> -
> -		if (status) {
> -			DBG(3, "Error in isochronous frame");
> -			(*f)->state = F_ERROR;
> -			cam->sof.bytesread = 0;
> -			continue;
> -		}
> -
> -		PDBGG("Isochrnous frame: length %u, #%u i", len, i);
> -
> -redo:
> -		sof = sn9c102_find_sof_header(cam, pos, len);
> -		if (likely(!sof)) {
> -			eof = sn9c102_find_eof_header(cam, pos, len);
> -			if ((*f)->state == F_GRABBING) {
> -end_of_frame:
> -				img = len;
> -
> -				if (eof)
> -					img = (eof > pos) ? eof - pos - 1 : 0;
> -
> -				if ((*f)->buf.bytesused + img > imagesize) {
> -					u32 b;
> -					b = (*f)->buf.bytesused + img -
> -					    imagesize;
> -					img = imagesize - (*f)->buf.bytesused;
> -					PDBGG("Expected EOF not found: video "
> -					      "frame cut");
> -					if (eof)
> -						DBG(3, "Exceeded limit: +%u "
> -						       "bytes", (unsigned)(b));
> -				}
> -
> -				memcpy((*f)->bufmem + (*f)->buf.bytesused, pos,
> -				       img);
> -
> -				if ((*f)->buf.bytesused == 0)
> -					v4l2_get_timestamp(
> -						&(*f)->buf.timestamp);
> -
> -				(*f)->buf.bytesused += img;
> -
> -				if ((*f)->buf.bytesused == imagesize ||
> -				    ((cam->sensor.pix_format.pixelformat ==
> -				      V4L2_PIX_FMT_SN9C10X ||
> -				      cam->sensor.pix_format.pixelformat ==
> -				      V4L2_PIX_FMT_JPEG) && eof)) {
> -					u32 b;
> -
> -					b = (*f)->buf.bytesused;
> -					(*f)->state = F_DONE;
> -					(*f)->buf.sequence = ++cam->frame_count;
> -
> -					spin_lock(&cam->queue_lock);
> -					list_move_tail(&(*f)->frame,
> -						       &cam->outqueue);
> -					if (!list_empty(&cam->inqueue))
> -						(*f) = list_entry(
> -							cam->inqueue.next,
> -							struct sn9c102_frame_t,
> -							frame);
> -					else
> -						(*f) = NULL;
> -					spin_unlock(&cam->queue_lock);
> -
> -					memcpy(cam->sysfs.frame_header,
> -					       cam->sof.header, soflen);
> -
> -					DBG(3, "Video frame captured: %lu "
> -					       "bytes", (unsigned long)(b));
> -
> -					if (!(*f))
> -						goto resubmit_urb;
> -
> -				} else if (eof) {
> -					(*f)->state = F_ERROR;
> -					DBG(3, "Not expected EOF after %lu "
> -					       "bytes of image data",
> -					    (unsigned long)
> -					    ((*f)->buf.bytesused));
> -				}
> -
> -				if (sof) /* (1) */
> -					goto start_of_frame;
> -
> -			} else if (eof) {
> -				DBG(3, "EOF without SOF");
> -				continue;
> -
> -			} else {
> -				PDBGG("Ignoring pointless isochronous frame");
> -				continue;
> -			}
> -
> -		} else if ((*f)->state == F_QUEUED || (*f)->state == F_ERROR) {
> -start_of_frame:
> -			(*f)->state = F_GRABBING;
> -			(*f)->buf.bytesused = 0;
> -			len -= (sof - pos);
> -			pos = sof;
> -			if (cam->sensor.pix_format.pixelformat ==
> -			    V4L2_PIX_FMT_JPEG)
> -				sn9c102_write_jpegheader(cam, (*f));
> -			DBG(3, "SOF detected: new video frame");
> -			if (len)
> -				goto redo;
> -
> -		} else if ((*f)->state == F_GRABBING) {
> -			eof = sn9c102_find_eof_header(cam, pos, len);
> -			if (eof && eof < sof)
> -				goto end_of_frame; /* (1) */
> -			else {
> -				if (cam->sensor.pix_format.pixelformat ==
> -				    V4L2_PIX_FMT_SN9C10X ||
> -				    cam->sensor.pix_format.pixelformat ==
> -				    V4L2_PIX_FMT_JPEG) {
> -					if (sof - pos >= soflen) {
> -						eof = sof - soflen;
> -					} else { /* remove header */
> -						eof = pos;
> -						(*f)->buf.bytesused -=
> -							(soflen - (sof - pos));
> -					}
> -					goto end_of_frame;
> -				} else {
> -					DBG(3, "SOF before expected EOF after "
> -					       "%lu bytes of image data",
> -					    (unsigned long)
> -					    ((*f)->buf.bytesused));
> -					goto start_of_frame;
> -				}
> -			}
> -		}
> -	}
> -
> -resubmit_urb:
> -	urb->dev = cam->usbdev;
> -	err = usb_submit_urb(urb, GFP_ATOMIC);
> -	if (err < 0 && err != -EPERM) {
> -		cam->state |= DEV_MISCONFIGURED;
> -		DBG(1, "usb_submit_urb() failed");
> -	}
> -
> -	wake_up_interruptible(&cam->wait_frame);
> -}
> -
> -
> -static int sn9c102_start_transfer(struct sn9c102_device *cam)
> -{
> -	struct usb_device *udev = cam->usbdev;
> -	struct urb *urb;
> -	struct usb_host_interface *altsetting = usb_altnum_to_altsetting(
> -						    usb_ifnum_to_if(udev, 0),
> -						    SN9C102_ALTERNATE_SETTING);
> -	const unsigned int psz = le16_to_cpu(altsetting->
> -					     endpoint[0].desc.wMaxPacketSize);
> -	s8 i, j;
> -	int err = 0;
> -
> -	for (i = 0; i < SN9C102_URBS; i++) {
> -		cam->transfer_buffer[i] = kzalloc(SN9C102_ISO_PACKETS * psz,
> -						  GFP_KERNEL);
> -		if (!cam->transfer_buffer[i]) {
> -			err = -ENOMEM;
> -			DBG(1, "Not enough memory");
> -			goto free_buffers;
> -		}
> -	}
> -
> -	for (i = 0; i < SN9C102_URBS; i++) {
> -		urb = usb_alloc_urb(SN9C102_ISO_PACKETS, GFP_KERNEL);
> -		cam->urb[i] = urb;
> -		if (!urb) {
> -			err = -ENOMEM;
> -			DBG(1, "usb_alloc_urb() failed");
> -			goto free_urbs;
> -		}
> -		urb->dev = udev;
> -		urb->context = cam;
> -		urb->pipe = usb_rcvisocpipe(udev, 1);
> -		urb->transfer_flags = URB_ISO_ASAP;
> -		urb->number_of_packets = SN9C102_ISO_PACKETS;
> -		urb->complete = sn9c102_urb_complete;
> -		urb->transfer_buffer = cam->transfer_buffer[i];
> -		urb->transfer_buffer_length = psz * SN9C102_ISO_PACKETS;
> -		urb->interval = 1;
> -		for (j = 0; j < SN9C102_ISO_PACKETS; j++) {
> -			urb->iso_frame_desc[j].offset = psz * j;
> -			urb->iso_frame_desc[j].length = psz;
> -		}
> -	}
> -
> -	/* Enable video */
> -	if (!(cam->reg[0x01] & 0x04)) {
> -		err = sn9c102_write_reg(cam, cam->reg[0x01] | 0x04, 0x01);
> -		if (err) {
> -			err = -EIO;
> -			DBG(1, "I/O hardware error");
> -			goto free_urbs;
> -		}
> -	}
> -
> -	err = usb_set_interface(udev, 0, SN9C102_ALTERNATE_SETTING);
> -	if (err) {
> -		DBG(1, "usb_set_interface() failed");
> -		goto free_urbs;
> -	}
> -
> -	cam->frame_current = NULL;
> -	cam->sof.bytesread = 0;
> -
> -	for (i = 0; i < SN9C102_URBS; i++) {
> -		err = usb_submit_urb(cam->urb[i], GFP_KERNEL);
> -		if (err) {
> -			for (j = i-1; j >= 0; j--)
> -				usb_kill_urb(cam->urb[j]);
> -			DBG(1, "usb_submit_urb() failed, error %d", err);
> -			goto free_urbs;
> -		}
> -	}
> -
> -	return 0;
> -
> -free_urbs:
> -	for (i = 0; (i < SN9C102_URBS) && cam->urb[i]; i++)
> -		usb_free_urb(cam->urb[i]);
> -
> -free_buffers:
> -	for (i = 0; (i < SN9C102_URBS) && cam->transfer_buffer[i]; i++)
> -		kfree(cam->transfer_buffer[i]);
> -
> -	return err;
> -}
> -
> -
> -static int sn9c102_stop_transfer(struct sn9c102_device *cam)
> -{
> -	struct usb_device *udev = cam->usbdev;
> -	s8 i;
> -	int err = 0;
> -
> -	if (cam->state & DEV_DISCONNECTED)
> -		return 0;
> -
> -	for (i = SN9C102_URBS-1; i >= 0; i--) {
> -		usb_kill_urb(cam->urb[i]);
> -		usb_free_urb(cam->urb[i]);
> -		kfree(cam->transfer_buffer[i]);
> -	}
> -
> -	err = usb_set_interface(udev, 0, 0); /* 0 Mb/s */
> -	if (err)
> -		DBG(3, "usb_set_interface() failed");
> -
> -	return err;
> -}
> -
> -
> -static int sn9c102_stream_interrupt(struct sn9c102_device *cam)
> -{
> -	cam->stream = STREAM_INTERRUPT;
> -	wait_event_timeout(cam->wait_stream,
> -				     (cam->stream == STREAM_OFF) ||
> -				     (cam->state & DEV_DISCONNECTED),
> -				     SN9C102_URB_TIMEOUT);
> -	if (cam->state & DEV_DISCONNECTED)
> -		return -ENODEV;
> -	else if (cam->stream != STREAM_OFF) {
> -		cam->state |= DEV_MISCONFIGURED;
> -		DBG(1, "URB timeout reached. The camera is misconfigured. "
> -		       "To use it, close and open %s again.",
> -		    video_device_node_name(cam->v4ldev));
> -		return -EIO;
> -	}
> -
> -	return 0;
> -}
> -
> -/*****************************************************************************/
> -
> -#ifdef CONFIG_VIDEO_ADV_DEBUG
> -static u16 sn9c102_strtou16(const char *buff, size_t len, ssize_t *count)
> -{
> -	char str[7];
> -	char *endp;
> -	unsigned long val;
> -
> -	if (len < 6) {
> -		strncpy(str, buff, len);
> -		str[len] = '\0';
> -	} else {
> -		strncpy(str, buff, 6);
> -		str[6] = '\0';
> -	}
> -
> -	val = simple_strtoul(str, &endp, 0);
> -
> -	*count = 0;
> -	if (val <= 0xffff)
> -		*count = (ssize_t)(endp - str);
> -	if ((*count) && (len == *count+1) && (buff[*count] == '\n'))
> -		*count += 1;
> -
> -	return (u16)val;
> -}
> -
> -/*
> -   NOTE 1: being inside one of the following methods implies that the v4l
> -	   device exists for sure (see kobjects and reference counters)
> -   NOTE 2: buffers are PAGE_SIZE long
> -*/
> -
> -static ssize_t sn9c102_show_reg(struct device *cd,
> -				struct device_attribute *attr, char *buf)
> -{
> -	struct sn9c102_device *cam;
> -	ssize_t count;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	count = sprintf(buf, "%u\n", cam->sysfs.reg);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	return count;
> -}
> -
> -
> -static ssize_t
> -sn9c102_store_reg(struct device *cd, struct device_attribute *attr,
> -		  const char *buf, size_t len)
> -{
> -	struct sn9c102_device *cam;
> -	u16 index;
> -	ssize_t count;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	index = sn9c102_strtou16(buf, len, &count);
> -	if (index >= ARRAY_SIZE(cam->reg) || !count) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -EINVAL;
> -	}
> -
> -	cam->sysfs.reg = index;
> -
> -	DBG(2, "Moved SN9C1XX register index to 0x%02X", cam->sysfs.reg);
> -	DBG(3, "Written bytes: %zd", count);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	return count;
> -}
> -
> -
> -static ssize_t sn9c102_show_val(struct device *cd,
> -				struct device_attribute *attr, char *buf)
> -{
> -	struct sn9c102_device *cam;
> -	ssize_t count;
> -	int val;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	val = sn9c102_read_reg(cam, cam->sysfs.reg);
> -	if (val < 0) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -EIO;
> -	}
> -
> -	count = sprintf(buf, "%d\n", val);
> -
> -	DBG(3, "Read bytes: %zd, value: %d", count, val);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	return count;
> -}
> -
> -
> -static ssize_t
> -sn9c102_store_val(struct device *cd, struct device_attribute *attr,
> -		  const char *buf, size_t len)
> -{
> -	struct sn9c102_device *cam;
> -	u16 value;
> -	ssize_t count;
> -	int err;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	value = sn9c102_strtou16(buf, len, &count);
> -	if (!count) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -EINVAL;
> -	}
> -
> -	err = sn9c102_write_reg(cam, value, cam->sysfs.reg);
> -	if (err) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -EIO;
> -	}
> -
> -	DBG(2, "Written SN9C1XX reg. 0x%02X, val. 0x%02X",
> -	    cam->sysfs.reg, value);
> -	DBG(3, "Written bytes: %zd", count);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	return count;
> -}
> -
> -
> -static ssize_t sn9c102_show_i2c_reg(struct device *cd,
> -				    struct device_attribute *attr, char *buf)
> -{
> -	struct sn9c102_device *cam;
> -	ssize_t count;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	count = sprintf(buf, "%u\n", cam->sysfs.i2c_reg);
> -
> -	DBG(3, "Read bytes: %zd", count);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	return count;
> -}
> -
> -
> -static ssize_t
> -sn9c102_store_i2c_reg(struct device *cd, struct device_attribute *attr,
> -		      const char *buf, size_t len)
> -{
> -	struct sn9c102_device *cam;
> -	u16 index;
> -	ssize_t count;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	index = sn9c102_strtou16(buf, len, &count);
> -	if (!count) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -EINVAL;
> -	}
> -
> -	cam->sysfs.i2c_reg = index;
> -
> -	DBG(2, "Moved sensor register index to 0x%02X", cam->sysfs.i2c_reg);
> -	DBG(3, "Written bytes: %zd", count);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	return count;
> -}
> -
> -
> -static ssize_t sn9c102_show_i2c_val(struct device *cd,
> -				    struct device_attribute *attr, char *buf)
> -{
> -	struct sn9c102_device *cam;
> -	ssize_t count;
> -	int val;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	if (!(cam->sensor.sysfs_ops & SN9C102_I2C_READ)) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENOSYS;
> -	}
> -
> -	val = sn9c102_i2c_read(cam, cam->sysfs.i2c_reg);
> -	if (val < 0) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -EIO;
> -	}
> -
> -	count = sprintf(buf, "%d\n", val);
> -
> -	DBG(3, "Read bytes: %zd, value: %d", count, val);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	return count;
> -}
> -
> -
> -static ssize_t
> -sn9c102_store_i2c_val(struct device *cd, struct device_attribute *attr,
> -		      const char *buf, size_t len)
> -{
> -	struct sn9c102_device *cam;
> -	u16 value;
> -	ssize_t count;
> -	int err;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	if (!(cam->sensor.sysfs_ops & SN9C102_I2C_WRITE)) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENOSYS;
> -	}
> -
> -	value = sn9c102_strtou16(buf, len, &count);
> -	if (!count) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -EINVAL;
> -	}
> -
> -	err = sn9c102_i2c_write(cam, cam->sysfs.i2c_reg, value);
> -	if (err) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -EIO;
> -	}
> -
> -	DBG(2, "Written sensor reg. 0x%02X, val. 0x%02X",
> -	    cam->sysfs.i2c_reg, value);
> -	DBG(3, "Written bytes: %zd", count);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	return count;
> -}
> -
> -
> -static ssize_t
> -sn9c102_store_green(struct device *cd, struct device_attribute *attr,
> -		    const char *buf, size_t len)
> -{
> -	struct sn9c102_device *cam;
> -	enum sn9c102_bridge bridge;
> -	ssize_t res = 0;
> -	u16 value;
> -	ssize_t count;
> -
> -	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam) {
> -		mutex_unlock(&sn9c102_sysfs_lock);
> -		return -ENODEV;
> -	}
> -
> -	bridge = cam->bridge;
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -	value = sn9c102_strtou16(buf, len, &count);
> -	if (!count)
> -		return -EINVAL;
> -
> -	switch (bridge) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -		if (value > 0x0f)
> -			return -EINVAL;
> -		res = sn9c102_store_reg(cd, attr, "0x11", 4);
> -		if (res >= 0)
> -			res = sn9c102_store_val(cd, attr, buf, len);
> -		break;
> -	case BRIDGE_SN9C103:
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		if (value > 0x7f)
> -			return -EINVAL;
> -		res = sn9c102_store_reg(cd, attr, "0x07", 4);
> -		if (res >= 0)
> -			res = sn9c102_store_val(cd, attr, buf, len);
> -		break;
> -	}
> -
> -	return res;
> -}
> -
> -
> -static ssize_t
> -sn9c102_store_blue(struct device *cd, struct device_attribute *attr,
> -		   const char *buf, size_t len)
> -{
> -	ssize_t res = 0;
> -	u16 value;
> -	ssize_t count;
> -
> -	value = sn9c102_strtou16(buf, len, &count);
> -	if (!count || value > 0x7f)
> -		return -EINVAL;
> -
> -	res = sn9c102_store_reg(cd, attr, "0x06", 4);
> -	if (res >= 0)
> -		res = sn9c102_store_val(cd, attr, buf, len);
> -
> -	return res;
> -}
> -
> -
> -static ssize_t
> -sn9c102_store_red(struct device *cd, struct device_attribute *attr,
> -		  const char *buf, size_t len)
> -{
> -	ssize_t res = 0;
> -	u16 value;
> -	ssize_t count;
> -
> -	value = sn9c102_strtou16(buf, len, &count);
> -	if (!count || value > 0x7f)
> -		return -EINVAL;
> -	res = sn9c102_store_reg(cd, attr, "0x05", 4);
> -	if (res >= 0)
> -		res = sn9c102_store_val(cd, attr, buf, len);
> -
> -	return res;
> -}
> -
> -
> -static ssize_t sn9c102_show_frame_header(struct device *cd,
> -					 struct device_attribute *attr,
> -					 char *buf)
> -{
> -	struct sn9c102_device *cam;
> -	ssize_t count;
> -
> -	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
> -	if (!cam)
> -		return -ENODEV;
> -
> -	count = sizeof(cam->sysfs.frame_header);
> -	memcpy(buf, cam->sysfs.frame_header, count);
> -
> -	DBG(3, "Frame header, read bytes: %zd", count);
> -
> -	return count;
> -}
> -
> -
> -static DEVICE_ATTR(reg, S_IRUGO | S_IWUSR, sn9c102_show_reg, sn9c102_store_reg);
> -static DEVICE_ATTR(val, S_IRUGO | S_IWUSR, sn9c102_show_val, sn9c102_store_val);
> -static DEVICE_ATTR(i2c_reg, S_IRUGO | S_IWUSR,
> -		   sn9c102_show_i2c_reg, sn9c102_store_i2c_reg);
> -static DEVICE_ATTR(i2c_val, S_IRUGO | S_IWUSR,
> -		   sn9c102_show_i2c_val, sn9c102_store_i2c_val);
> -static DEVICE_ATTR(green, S_IWUSR, NULL, sn9c102_store_green);
> -static DEVICE_ATTR(blue, S_IWUSR, NULL, sn9c102_store_blue);
> -static DEVICE_ATTR(red, S_IWUSR, NULL, sn9c102_store_red);
> -static DEVICE_ATTR(frame_header, S_IRUGO, sn9c102_show_frame_header, NULL);
> -
> -
> -static int sn9c102_create_sysfs(struct sn9c102_device *cam)
> -{
> -	struct device *dev = &(cam->v4ldev->dev);
> -	int err = 0;
> -
> -	err = device_create_file(dev, &dev_attr_reg);
> -	if (err)
> -		goto err_out;
> -	err = device_create_file(dev, &dev_attr_val);
> -	if (err)
> -		goto err_reg;
> -	err = device_create_file(dev, &dev_attr_frame_header);
> -	if (err)
> -		goto err_val;
> -
> -	if (cam->sensor.sysfs_ops) {
> -		err = device_create_file(dev, &dev_attr_i2c_reg);
> -		if (err)
> -			goto err_frame_header;
> -		err = device_create_file(dev, &dev_attr_i2c_val);
> -		if (err)
> -			goto err_i2c_reg;
> -	}
> -
> -	if (cam->bridge == BRIDGE_SN9C101 || cam->bridge == BRIDGE_SN9C102) {
> -		err = device_create_file(dev, &dev_attr_green);
> -		if (err)
> -			goto err_i2c_val;
> -	} else {
> -		err = device_create_file(dev, &dev_attr_blue);
> -		if (err)
> -			goto err_i2c_val;
> -		err = device_create_file(dev, &dev_attr_red);
> -		if (err)
> -			goto err_blue;
> -	}
> -
> -	return 0;
> -
> -err_blue:
> -	device_remove_file(dev, &dev_attr_blue);
> -err_i2c_val:
> -	if (cam->sensor.sysfs_ops)
> -		device_remove_file(dev, &dev_attr_i2c_val);
> -err_i2c_reg:
> -	if (cam->sensor.sysfs_ops)
> -		device_remove_file(dev, &dev_attr_i2c_reg);
> -err_frame_header:
> -	device_remove_file(dev, &dev_attr_frame_header);
> -err_val:
> -	device_remove_file(dev, &dev_attr_val);
> -err_reg:
> -	device_remove_file(dev, &dev_attr_reg);
> -err_out:
> -	return err;
> -}
> -#endif /* CONFIG_VIDEO_ADV_DEBUG */
> -
> -/*****************************************************************************/
> -
> -static int
> -sn9c102_set_pix_format(struct sn9c102_device *cam, struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X ||
> -	    pix->pixelformat == V4L2_PIX_FMT_JPEG) {
> -		switch (cam->bridge) {
> -		case BRIDGE_SN9C101:
> -		case BRIDGE_SN9C102:
> -		case BRIDGE_SN9C103:
> -			err += sn9c102_write_reg(cam, cam->reg[0x18] | 0x80,
> -						 0x18);
> -			break;
> -		case BRIDGE_SN9C105:
> -		case BRIDGE_SN9C120:
> -			err += sn9c102_write_reg(cam, cam->reg[0x18] & 0x7f,
> -						 0x18);
> -			break;
> -		}
> -	} else {
> -		switch (cam->bridge) {
> -		case BRIDGE_SN9C101:
> -		case BRIDGE_SN9C102:
> -		case BRIDGE_SN9C103:
> -			err += sn9c102_write_reg(cam, cam->reg[0x18] & 0x7f,
> -						 0x18);
> -			break;
> -		case BRIDGE_SN9C105:
> -		case BRIDGE_SN9C120:
> -			err += sn9c102_write_reg(cam, cam->reg[0x18] | 0x80,
> -						 0x18);
> -			break;
> -		}
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int
> -sn9c102_set_compression(struct sn9c102_device *cam,
> -			struct v4l2_jpegcompression *compression)
> -{
> -	int i, err = 0;
> -
> -	switch (cam->bridge) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -	case BRIDGE_SN9C103:
> -		if (compression->quality == 0)
> -			err += sn9c102_write_reg(cam, cam->reg[0x17] | 0x01,
> -						 0x17);
> -		else if (compression->quality == 1)
> -			err += sn9c102_write_reg(cam, cam->reg[0x17] & 0xfe,
> -						 0x17);
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		if (compression->quality == 0) {
> -			for (i = 0; i <= 63; i++) {
> -				err += sn9c102_write_reg(cam,
> -							 SN9C102_Y_QTABLE1[i],
> -							 0x100 + i);
> -				err += sn9c102_write_reg(cam,
> -							 SN9C102_UV_QTABLE1[i],
> -							 0x140 + i);
> -			}
> -			err += sn9c102_write_reg(cam, cam->reg[0x18] & 0xbf,
> -						 0x18);
> -		} else if (compression->quality == 1) {
> -			for (i = 0; i <= 63; i++) {
> -				err += sn9c102_write_reg(cam,
> -							 SN9C102_Y_QTABLE1[i],
> -							 0x100 + i);
> -				err += sn9c102_write_reg(cam,
> -							 SN9C102_UV_QTABLE1[i],
> -							 0x140 + i);
> -			}
> -			err += sn9c102_write_reg(cam, cam->reg[0x18] | 0x40,
> -						 0x18);
> -		}
> -		break;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int sn9c102_set_scale(struct sn9c102_device *cam, u8 scale)
> -{
> -	u8 r = 0;
> -	int err = 0;
> -
> -	if (scale == 1)
> -		r = cam->reg[0x18] & 0xcf;
> -	else if (scale == 2) {
> -		r = cam->reg[0x18] & 0xcf;
> -		r |= 0x10;
> -	} else if (scale == 4)
> -		r = cam->reg[0x18] | 0x20;
> -
> -	err += sn9c102_write_reg(cam, r, 0x18);
> -	if (err)
> -		return -EIO;
> -
> -	PDBGG("Scaling factor: %u", scale);
> -
> -	return 0;
> -}
> -
> -
> -static int sn9c102_set_crop(struct sn9c102_device *cam, struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = &cam->sensor;
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left),
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top),
> -	   h_size = (u8)(rect->width / 16),
> -	   v_size = (u8)(rect->height / 16);
> -	int err = 0;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -	err += sn9c102_write_reg(cam, h_size, 0x15);
> -	err += sn9c102_write_reg(cam, v_size, 0x16);
> -	if (err)
> -		return -EIO;
> -
> -	PDBGG("h_start, v_start, h_size, v_size, ho_size, vo_size "
> -	      "%u %u %u %u", h_start, v_start, h_size, v_size);
> -
> -	return 0;
> -}
> -
> -
> -static int sn9c102_init(struct sn9c102_device *cam)
> -{
> -	struct sn9c102_sensor *s = &cam->sensor;
> -	struct v4l2_control ctrl;
> -	struct v4l2_queryctrl *qctrl;
> -	struct v4l2_rect *rect;
> -	u8 i = 0;
> -	int err = 0;
> -
> -	if (!(cam->state & DEV_INITIALIZED)) {
> -		mutex_init(&cam->open_mutex);
> -		init_waitqueue_head(&cam->wait_open);
> -		qctrl = s->qctrl;
> -		rect = &(s->cropcap.defrect);
> -	} else { /* use current values */
> -		qctrl = s->_qctrl;
> -		rect = &(s->_rect);
> -	}
> -
> -	err += sn9c102_set_scale(cam, rect->width / s->pix_format.width);
> -	err += sn9c102_set_crop(cam, rect);
> -	if (err)
> -		return err;
> -
> -	if (s->init) {
> -		err = s->init(cam);
> -		if (err) {
> -			DBG(3, "Sensor initialization failed");
> -			return err;
> -		}
> -	}
> -
> -	if (!(cam->state & DEV_INITIALIZED))
> -		if (cam->bridge == BRIDGE_SN9C101 ||
> -		    cam->bridge == BRIDGE_SN9C102 ||
> -		    cam->bridge == BRIDGE_SN9C103) {
> -			if (s->pix_format.pixelformat == V4L2_PIX_FMT_JPEG)
> -				s->pix_format.pixelformat = V4L2_PIX_FMT_SBGGR8;
> -			cam->compression.quality =  cam->reg[0x17] & 0x01 ?
> -						    0 : 1;
> -		} else {
> -			if (s->pix_format.pixelformat == V4L2_PIX_FMT_SN9C10X)
> -				s->pix_format.pixelformat = V4L2_PIX_FMT_JPEG;
> -			cam->compression.quality =  cam->reg[0x18] & 0x40 ?
> -						    0 : 1;
> -			err += sn9c102_set_compression(cam, &cam->compression);
> -		}
> -	else
> -		err += sn9c102_set_compression(cam, &cam->compression);
> -	err += sn9c102_set_pix_format(cam, &s->pix_format);
> -	if (s->set_pix_format)
> -		err += s->set_pix_format(cam, &s->pix_format);
> -	if (err)
> -		return err;
> -
> -	if (s->pix_format.pixelformat == V4L2_PIX_FMT_SN9C10X ||
> -	    s->pix_format.pixelformat == V4L2_PIX_FMT_JPEG)
> -		DBG(3, "Compressed video format is active, quality %d",
> -		    cam->compression.quality);
> -	else
> -		DBG(3, "Uncompressed video format is active");
> -
> -	if (s->set_crop) {
> -		err = s->set_crop(cam, rect);
> -		if (err) {
> -			DBG(3, "set_crop() failed");
> -			return err;
> -		}
> -	}
> -
> -	if (s->set_ctrl) {
> -		for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
> -			if (s->qctrl[i].id != 0 &&
> -			    !(s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)) {
> -				ctrl.id = s->qctrl[i].id;
> -				ctrl.value = qctrl[i].default_value;
> -				err = s->set_ctrl(cam, &ctrl);
> -				if (err) {
> -					DBG(3, "Set %s control failed",
> -					    s->qctrl[i].name);
> -					return err;
> -				}
> -				DBG(3, "Image sensor supports '%s' control",
> -				    s->qctrl[i].name);
> -			}
> -	}
> -
> -	if (!(cam->state & DEV_INITIALIZED)) {
> -		mutex_init(&cam->fileop_mutex);
> -		spin_lock_init(&cam->queue_lock);
> -		init_waitqueue_head(&cam->wait_frame);
> -		init_waitqueue_head(&cam->wait_stream);
> -		cam->nreadbuffers = 2;
> -		memcpy(s->_qctrl, s->qctrl, sizeof(s->qctrl));
> -		memcpy(&(s->_rect), &(s->cropcap.defrect),
> -		       sizeof(struct v4l2_rect));
> -		cam->state |= DEV_INITIALIZED;
> -	}
> -
> -	DBG(2, "Initialization succeeded");
> -	return 0;
> -}
> -
> -/*****************************************************************************/
> -
> -static void sn9c102_release_resources(struct kref *kref)
> -{
> -	struct sn9c102_device *cam;
> -
> -	mutex_lock(&sn9c102_sysfs_lock);
> -
> -	cam = container_of(kref, struct sn9c102_device, kref);
> -
> -	DBG(2, "V4L2 device %s deregistered",
> -	    video_device_node_name(cam->v4ldev));
> -	video_set_drvdata(cam->v4ldev, NULL);
> -	video_unregister_device(cam->v4ldev);
> -	v4l2_device_unregister(&cam->v4l2_dev);
> -	usb_put_dev(cam->usbdev);
> -	kfree(cam->control_buffer);
> -	kfree(cam);
> -
> -	mutex_unlock(&sn9c102_sysfs_lock);
> -
> -}
> -
> -
> -static int sn9c102_open(struct file *filp)
> -{
> -	struct sn9c102_device *cam;
> -	int err = 0;
> -
> -	/*
> -	   A read_trylock() in open() is the only safe way to prevent race
> -	   conditions with disconnect(), one close() and multiple (not
> -	   necessarily simultaneous) attempts to open(). For example, it
> -	   prevents from waiting for a second access, while the device
> -	   structure is being deallocated, after a possible disconnect() and
> -	   during a following close() holding the write lock: given that, after
> -	   this deallocation, no access will be possible anymore, using the
> -	   non-trylock version would have let open() gain the access to the
> -	   device structure improperly.
> -	   For this reason the lock must also not be per-device.
> -	*/
> -	if (!down_read_trylock(&sn9c102_dev_lock))
> -		return -ERESTARTSYS;
> -
> -	cam = video_drvdata(filp);
> -
> -	if (wait_for_completion_interruptible(&cam->probe)) {
> -		up_read(&sn9c102_dev_lock);
> -		return -ERESTARTSYS;
> -	}
> -
> -	kref_get(&cam->kref);
> -
> -	/*
> -	    Make sure to isolate all the simultaneous opens.
> -	*/
> -	if (mutex_lock_interruptible(&cam->open_mutex)) {
> -		kref_put(&cam->kref, sn9c102_release_resources);
> -		up_read(&sn9c102_dev_lock);
> -		return -ERESTARTSYS;
> -	}
> -
> -	if (cam->state & DEV_DISCONNECTED) {
> -		DBG(1, "Device not present");
> -		err = -ENODEV;
> -		goto out;
> -	}
> -
> -	if (cam->users) {
> -		DBG(2, "Device %s is already in use",
> -		    video_device_node_name(cam->v4ldev));
> -		DBG(3, "Simultaneous opens are not supported");
> -		/*
> -		   open() must follow the open flags and should block
> -		   eventually while the device is in use.
> -		*/
> -		if ((filp->f_flags & O_NONBLOCK) ||
> -		    (filp->f_flags & O_NDELAY)) {
> -			err = -EWOULDBLOCK;
> -			goto out;
> -		}
> -		DBG(2, "A blocking open() has been requested. Wait for the "
> -		       "device to be released...");
> -		up_read(&sn9c102_dev_lock);
> -		/*
> -		   We will not release the "open_mutex" lock, so that only one
> -		   process can be in the wait queue below. This way the process
> -		   will be sleeping while holding the lock, without losing its
> -		   priority after any wake_up().
> -		*/
> -		err = wait_event_interruptible_exclusive(cam->wait_open,
> -						(cam->state & DEV_DISCONNECTED)
> -							 || !cam->users);
> -		down_read(&sn9c102_dev_lock);
> -		if (err)
> -			goto out;
> -		if (cam->state & DEV_DISCONNECTED) {
> -			err = -ENODEV;
> -			goto out;
> -		}
> -	}
> -
> -	if (cam->state & DEV_MISCONFIGURED) {
> -		err = sn9c102_init(cam);
> -		if (err) {
> -			DBG(1, "Initialization failed again. "
> -			       "I will retry on next open().");
> -			goto out;
> -		}
> -		cam->state &= ~DEV_MISCONFIGURED;
> -	}
> -
> -	err = sn9c102_start_transfer(cam);
> -	if (err)
> -		goto out;
> -
> -	filp->private_data = cam;
> -	cam->users++;
> -	cam->io = IO_NONE;
> -	cam->stream = STREAM_OFF;
> -	cam->nbuffers = 0;
> -	cam->frame_count = 0;
> -	sn9c102_empty_framequeues(cam);
> -
> -	DBG(3, "Video device %s is open", video_device_node_name(cam->v4ldev));
> -
> -out:
> -	mutex_unlock(&cam->open_mutex);
> -	if (err)
> -		kref_put(&cam->kref, sn9c102_release_resources);
> -
> -	up_read(&sn9c102_dev_lock);
> -	return err;
> -}
> -
> -
> -static int sn9c102_release(struct file *filp)
> -{
> -	struct sn9c102_device *cam;
> -
> -	down_write(&sn9c102_dev_lock);
> -
> -	cam = video_drvdata(filp);
> -
> -	sn9c102_stop_transfer(cam);
> -	sn9c102_release_buffers(cam);
> -	cam->users--;
> -	wake_up_interruptible_nr(&cam->wait_open, 1);
> -
> -	DBG(3, "Video device %s closed", video_device_node_name(cam->v4ldev));
> -
> -	kref_put(&cam->kref, sn9c102_release_resources);
> -
> -	up_write(&sn9c102_dev_lock);
> -
> -	return 0;
> -}
> -
> -
> -static ssize_t
> -sn9c102_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
> -{
> -	struct sn9c102_device *cam = video_drvdata(filp);
> -	struct sn9c102_frame_t *f, *i;
> -	unsigned long lock_flags;
> -	long timeout;
> -	int err = 0;
> -
> -	if (mutex_lock_interruptible(&cam->fileop_mutex))
> -		return -ERESTARTSYS;
> -
> -	if (cam->state & DEV_DISCONNECTED) {
> -		DBG(1, "Device not present");
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -ENODEV;
> -	}
> -
> -	if (cam->state & DEV_MISCONFIGURED) {
> -		DBG(1, "The camera is misconfigured. Close and open it "
> -		       "again.");
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -EIO;
> -	}
> -
> -	if (cam->io == IO_MMAP) {
> -		DBG(3, "Close and open the device again to choose "
> -		       "the read method");
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -EBUSY;
> -	}
> -
> -	if (cam->io == IO_NONE) {
> -		if (!sn9c102_request_buffers(cam, cam->nreadbuffers, IO_READ)) {
> -			DBG(1, "read() failed, not enough memory");
> -			mutex_unlock(&cam->fileop_mutex);
> -			return -ENOMEM;
> -		}
> -		cam->io = IO_READ;
> -		cam->stream = STREAM_ON;
> -	}
> -
> -	if (list_empty(&cam->inqueue)) {
> -		if (!list_empty(&cam->outqueue))
> -			sn9c102_empty_framequeues(cam);
> -		sn9c102_queue_unusedframes(cam);
> -	}
> -
> -	if (!count) {
> -		mutex_unlock(&cam->fileop_mutex);
> -		return 0;
> -	}
> -
> -	if (list_empty(&cam->outqueue)) {
> -		if (filp->f_flags & O_NONBLOCK) {
> -			mutex_unlock(&cam->fileop_mutex);
> -			return -EAGAIN;
> -		}
> -		if (!cam->module_param.frame_timeout) {
> -			err = wait_event_interruptible
> -			      (cam->wait_frame,
> -				(!list_empty(&cam->outqueue)) ||
> -				(cam->state & DEV_DISCONNECTED) ||
> -				(cam->state & DEV_MISCONFIGURED));
> -			if (err) {
> -				mutex_unlock(&cam->fileop_mutex);
> -				return err;
> -			}
> -		} else {
> -			timeout = wait_event_interruptible_timeout
> -				  (cam->wait_frame,
> -				    (!list_empty(&cam->outqueue)) ||
> -				    (cam->state & DEV_DISCONNECTED) ||
> -				    (cam->state & DEV_MISCONFIGURED),
> -				    msecs_to_jiffies(
> -					cam->module_param.frame_timeout * 1000
> -				    )
> -				  );
> -			if (timeout < 0) {
> -				mutex_unlock(&cam->fileop_mutex);
> -				return timeout;
> -			} else if (timeout == 0 &&
> -				   !(cam->state & DEV_DISCONNECTED)) {
> -				DBG(1, "Video frame timeout elapsed");
> -				mutex_unlock(&cam->fileop_mutex);
> -				return -EIO;
> -			}
> -		}
> -		if (cam->state & DEV_DISCONNECTED) {
> -			mutex_unlock(&cam->fileop_mutex);
> -			return -ENODEV;
> -		}
> -		if (cam->state & DEV_MISCONFIGURED) {
> -			mutex_unlock(&cam->fileop_mutex);
> -			return -EIO;
> -		}
> -	}
> -
> -	f = list_entry(cam->outqueue.prev, struct sn9c102_frame_t, frame);
> -
> -	if (count > f->buf.bytesused)
> -		count = f->buf.bytesused;
> -
> -	if (copy_to_user(buf, f->bufmem, count)) {
> -		err = -EFAULT;
> -		goto exit;
> -	}
> -	*f_pos += count;
> -
> -exit:
> -	spin_lock_irqsave(&cam->queue_lock, lock_flags);
> -	list_for_each_entry(i, &cam->outqueue, frame)
> -		i->state = F_UNUSED;
> -	INIT_LIST_HEAD(&cam->outqueue);
> -	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
> -
> -	sn9c102_queue_unusedframes(cam);
> -
> -	PDBGG("Frame #%lu, bytes read: %zu",
> -	      (unsigned long)f->buf.index, count);
> -
> -	mutex_unlock(&cam->fileop_mutex);
> -
> -	return count;
> -}
> -
> -
> -static unsigned int sn9c102_poll(struct file *filp, poll_table *wait)
> -{
> -	struct sn9c102_device *cam = video_drvdata(filp);
> -	struct sn9c102_frame_t *f;
> -	unsigned long lock_flags;
> -	unsigned int mask = 0;
> -
> -	if (mutex_lock_interruptible(&cam->fileop_mutex))
> -		return POLLERR;
> -
> -	if (cam->state & DEV_DISCONNECTED) {
> -		DBG(1, "Device not present");
> -		goto error;
> -	}
> -
> -	if (cam->state & DEV_MISCONFIGURED) {
> -		DBG(1, "The camera is misconfigured. Close and open it "
> -		       "again.");
> -		goto error;
> -	}
> -
> -	if (cam->io == IO_NONE) {
> -		if (!sn9c102_request_buffers(cam, cam->nreadbuffers,
> -					     IO_READ)) {
> -			DBG(1, "poll() failed, not enough memory");
> -			goto error;
> -		}
> -		cam->io = IO_READ;
> -		cam->stream = STREAM_ON;
> -	}
> -
> -	if (cam->io == IO_READ) {
> -		spin_lock_irqsave(&cam->queue_lock, lock_flags);
> -		list_for_each_entry(f, &cam->outqueue, frame)
> -			f->state = F_UNUSED;
> -		INIT_LIST_HEAD(&cam->outqueue);
> -		spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
> -		sn9c102_queue_unusedframes(cam);
> -	}
> -
> -	poll_wait(filp, &cam->wait_frame, wait);
> -
> -	if (!list_empty(&cam->outqueue))
> -		mask |= POLLIN | POLLRDNORM;
> -
> -	mutex_unlock(&cam->fileop_mutex);
> -
> -	return mask;
> -
> -error:
> -	mutex_unlock(&cam->fileop_mutex);
> -	return POLLERR;
> -}
> -
> -
> -static void sn9c102_vm_open(struct vm_area_struct *vma)
> -{
> -	struct sn9c102_frame_t *f = vma->vm_private_data;
> -	f->vma_use_count++;
> -}
> -
> -
> -static void sn9c102_vm_close(struct vm_area_struct *vma)
> -{
> -	/* NOTE: buffers are not freed here */
> -	struct sn9c102_frame_t *f = vma->vm_private_data;
> -	f->vma_use_count--;
> -}
> -
> -
> -static const struct vm_operations_struct sn9c102_vm_ops = {
> -	.open = sn9c102_vm_open,
> -	.close = sn9c102_vm_close,
> -};
> -
> -
> -static int sn9c102_mmap(struct file *filp, struct vm_area_struct *vma)
> -{
> -	struct sn9c102_device *cam = video_drvdata(filp);
> -	unsigned long size = vma->vm_end - vma->vm_start,
> -		      start = vma->vm_start;
> -	void *pos;
> -	u32 i;
> -
> -	if (mutex_lock_interruptible(&cam->fileop_mutex))
> -		return -ERESTARTSYS;
> -
> -	if (cam->state & DEV_DISCONNECTED) {
> -		DBG(1, "Device not present");
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -ENODEV;
> -	}
> -
> -	if (cam->state & DEV_MISCONFIGURED) {
> -		DBG(1, "The camera is misconfigured. Close and open it "
> -		       "again.");
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -EIO;
> -	}
> -
> -	if (!(vma->vm_flags & (VM_WRITE | VM_READ))) {
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -EACCES;
> -	}
> -
> -	if (cam->io != IO_MMAP ||
> -	    size != PAGE_ALIGN(cam->frame[0].buf.length)) {
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -EINVAL;
> -	}
> -
> -	for (i = 0; i < cam->nbuffers; i++) {
> -		if ((cam->frame[i].buf.m.offset>>PAGE_SHIFT) == vma->vm_pgoff)
> -			break;
> -	}
> -	if (i == cam->nbuffers) {
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -EINVAL;
> -	}
> -
> -	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
> -
> -	pos = cam->frame[i].bufmem;
> -	while (size > 0) { /* size is page-aligned */
> -		if (vm_insert_page(vma, start, vmalloc_to_page(pos))) {
> -			mutex_unlock(&cam->fileop_mutex);
> -			return -EAGAIN;
> -		}
> -		start += PAGE_SIZE;
> -		pos += PAGE_SIZE;
> -		size -= PAGE_SIZE;
> -	}
> -
> -	vma->vm_ops = &sn9c102_vm_ops;
> -	vma->vm_private_data = &cam->frame[i];
> -	sn9c102_vm_open(vma);
> -
> -	mutex_unlock(&cam->fileop_mutex);
> -
> -	return 0;
> -}
> -
> -/*****************************************************************************/
> -
> -static int
> -sn9c102_vidioc_querycap(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_capability cap = {
> -		.driver = "sn9c102",
> -		.version = LINUX_VERSION_CODE,
> -		.capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
> -				V4L2_CAP_STREAMING,
> -	};
> -
> -	strlcpy(cap.card, cam->v4ldev->name, sizeof(cap.card));
> -	if (usb_make_path(cam->usbdev, cap.bus_info, sizeof(cap.bus_info)) < 0)
> -		strlcpy(cap.bus_info, dev_name(&cam->usbdev->dev),
> -			sizeof(cap.bus_info));
> -
> -	if (copy_to_user(arg, &cap, sizeof(cap)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_enuminput(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_input i;
> -
> -	if (copy_from_user(&i, arg, sizeof(i)))
> -		return -EFAULT;
> -
> -	if (i.index)
> -		return -EINVAL;
> -
> -	memset(&i, 0, sizeof(i));
> -	strcpy(i.name, "Camera");
> -	i.type = V4L2_INPUT_TYPE_CAMERA;
> -	i.capabilities = V4L2_IN_CAP_STD;
> -
> -	if (copy_to_user(arg, &i, sizeof(i)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_g_input(struct sn9c102_device *cam, void __user *arg)
> -{
> -	int index = 0;
> -
> -	if (copy_to_user(arg, &index, sizeof(index)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_s_input(struct sn9c102_device *cam, void __user *arg)
> -{
> -	int index;
> -
> -	if (copy_from_user(&index, arg, sizeof(index)))
> -		return -EFAULT;
> -
> -	if (index != 0)
> -		return -EINVAL;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_query_ctrl(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct sn9c102_sensor *s = &cam->sensor;
> -	struct v4l2_queryctrl qc;
> -	u8 i;
> -
> -	if (copy_from_user(&qc, arg, sizeof(qc)))
> -		return -EFAULT;
> -
> -	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
> -		if (qc.id && qc.id == s->qctrl[i].id) {
> -			memcpy(&qc, &(s->qctrl[i]), sizeof(qc));
> -			if (copy_to_user(arg, &qc, sizeof(qc)))
> -				return -EFAULT;
> -			return 0;
> -		}
> -
> -	return -EINVAL;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_g_ctrl(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct sn9c102_sensor *s = &cam->sensor;
> -	struct v4l2_control ctrl;
> -	int err = 0;
> -	u8 i;
> -
> -	if (!s->get_ctrl && !s->set_ctrl)
> -		return -EINVAL;
> -
> -	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
> -		return -EFAULT;
> -
> -	if (!s->get_ctrl) {
> -		for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
> -			if (ctrl.id && ctrl.id == s->qctrl[i].id) {
> -				ctrl.value = s->_qctrl[i].default_value;
> -				goto exit;
> -			}
> -		return -EINVAL;
> -	} else
> -		err = s->get_ctrl(cam, &ctrl);
> -
> -exit:
> -	if (copy_to_user(arg, &ctrl, sizeof(ctrl)))
> -		return -EFAULT;
> -
> -	PDBGG("VIDIOC_G_CTRL: id %lu, value %lu",
> -	      (unsigned long)ctrl.id, (unsigned long)ctrl.value);
> -
> -	return err;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_s_ctrl(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct sn9c102_sensor *s = &cam->sensor;
> -	struct v4l2_control ctrl;
> -	u8 i;
> -	int err = 0;
> -
> -	if (!s->set_ctrl)
> -		return -EINVAL;
> -
> -	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
> -		return -EFAULT;
> -
> -	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++) {
> -		if (ctrl.id == s->qctrl[i].id) {
> -			if (s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)
> -				return -EINVAL;
> -			if (ctrl.value < s->qctrl[i].minimum ||
> -			    ctrl.value > s->qctrl[i].maximum)
> -				return -ERANGE;
> -			ctrl.value -= ctrl.value % s->qctrl[i].step;
> -			break;
> -		}
> -	}
> -	if (i == ARRAY_SIZE(s->qctrl))
> -		return -EINVAL;
> -	err = s->set_ctrl(cam, &ctrl);
> -	if (err)
> -		return err;
> -
> -	s->_qctrl[i].default_value = ctrl.value;
> -
> -	PDBGG("VIDIOC_S_CTRL: id %lu, value %lu",
> -	      (unsigned long)ctrl.id, (unsigned long)ctrl.value);
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_cropcap(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_cropcap *cc = &(cam->sensor.cropcap);
> -
> -	cc->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	cc->pixelaspect.numerator = 1;
> -	cc->pixelaspect.denominator = 1;
> -
> -	if (copy_to_user(arg, cc, sizeof(*cc)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_g_crop(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct sn9c102_sensor *s = &cam->sensor;
> -	struct v4l2_crop crop = {
> -		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -	};
> -
> -	memcpy(&(crop.c), &(s->_rect), sizeof(struct v4l2_rect));
> -
> -	if (copy_to_user(arg, &crop, sizeof(crop)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_s_crop(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct sn9c102_sensor *s = &cam->sensor;
> -	struct v4l2_crop crop;
> -	struct v4l2_rect *rect;
> -	struct v4l2_rect *bounds = &(s->cropcap.bounds);
> -	struct v4l2_pix_format *pix_format = &(s->pix_format);
> -	u8 scale;
> -	const enum sn9c102_stream_state stream = cam->stream;
> -	const u32 nbuffers = cam->nbuffers;
> -	u32 i;
> -	int err = 0;
> -
> -	if (copy_from_user(&crop, arg, sizeof(crop)))
> -		return -EFAULT;
> -
> -	rect = &(crop.c);
> -
> -	if (crop.type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	if (cam->module_param.force_munmap)
> -		for (i = 0; i < cam->nbuffers; i++)
> -			if (cam->frame[i].vma_use_count) {
> -				DBG(3, "VIDIOC_S_CROP failed. "
> -				       "Unmap the buffers first.");
> -				return -EBUSY;
> -			}
> -
> -	/* Preserve R,G or B origin */
> -	rect->left = (s->_rect.left & 1L) ? rect->left | 1L : rect->left & ~1L;
> -	rect->top = (s->_rect.top & 1L) ? rect->top | 1L : rect->top & ~1L;
> -
> -	if (rect->width < 16)
> -		rect->width = 16;
> -	if (rect->height < 16)
> -		rect->height = 16;
> -	if (rect->width > bounds->width)
> -		rect->width = bounds->width;
> -	if (rect->height > bounds->height)
> -		rect->height = bounds->height;
> -	if (rect->left < bounds->left)
> -		rect->left = bounds->left;
> -	if (rect->top < bounds->top)
> -		rect->top = bounds->top;
> -	if (rect->left + rect->width > bounds->left + bounds->width)
> -		rect->left = bounds->left+bounds->width - rect->width;
> -	if (rect->top + rect->height > bounds->top + bounds->height)
> -		rect->top = bounds->top+bounds->height - rect->height;
> -
> -	rect->width &= ~15L;
> -	rect->height &= ~15L;
> -
> -	if (SN9C102_PRESERVE_IMGSCALE) {
> -		/* Calculate the actual scaling factor */
> -		u32 a, b;
> -		a = rect->width * rect->height;
> -		b = pix_format->width * pix_format->height;
> -		scale = b ? (u8)((a / b) < 4 ? 1 : ((a / b) < 16 ? 2 : 4)) : 1;
> -	} else
> -		scale = 1;
> -
> -	if (cam->stream == STREAM_ON) {
> -		err = sn9c102_stream_interrupt(cam);
> -		if (err)
> -			return err;
> -	}
> -
> -	if (copy_to_user(arg, &crop, sizeof(crop))) {
> -		cam->stream = stream;
> -		return -EFAULT;
> -	}
> -
> -	if (cam->module_param.force_munmap || cam->io == IO_READ)
> -		sn9c102_release_buffers(cam);
> -
> -	err = sn9c102_set_crop(cam, rect);
> -	if (s->set_crop)
> -		err += s->set_crop(cam, rect);
> -	err += sn9c102_set_scale(cam, scale);
> -
> -	if (err) { /* atomic, no rollback in ioctl() */
> -		cam->state |= DEV_MISCONFIGURED;
> -		DBG(1, "VIDIOC_S_CROP failed because of hardware problems. To "
> -		       "use the camera, close and open %s again.",
> -		    video_device_node_name(cam->v4ldev));
> -		return -EIO;
> -	}
> -
> -	s->pix_format.width = rect->width/scale;
> -	s->pix_format.height = rect->height/scale;
> -	memcpy(&(s->_rect), rect, sizeof(*rect));
> -
> -	if ((cam->module_param.force_munmap || cam->io == IO_READ) &&
> -	    nbuffers != sn9c102_request_buffers(cam, nbuffers, cam->io)) {
> -		cam->state |= DEV_MISCONFIGURED;
> -		DBG(1, "VIDIOC_S_CROP failed because of not enough memory. To "
> -		       "use the camera, close and open %s again.",
> -		    video_device_node_name(cam->v4ldev));
> -		return -ENOMEM;
> -	}
> -
> -	if (cam->io == IO_READ)
> -		sn9c102_empty_framequeues(cam);
> -	else if (cam->module_param.force_munmap)
> -		sn9c102_requeue_outqueue(cam);
> -
> -	cam->stream = stream;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_enum_framesizes(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_frmsizeenum frmsize;
> -
> -	if (copy_from_user(&frmsize, arg, sizeof(frmsize)))
> -		return -EFAULT;
> -
> -	if (frmsize.index != 0)
> -		return -EINVAL;
> -
> -	switch (cam->bridge) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -	case BRIDGE_SN9C103:
> -		if (frmsize.pixel_format != V4L2_PIX_FMT_SN9C10X &&
> -		    frmsize.pixel_format != V4L2_PIX_FMT_SBGGR8)
> -			return -EINVAL;
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		if (frmsize.pixel_format != V4L2_PIX_FMT_JPEG &&
> -		    frmsize.pixel_format != V4L2_PIX_FMT_SBGGR8)
> -			return -EINVAL;
> -		break;
> -	}
> -
> -	frmsize.type = V4L2_FRMSIZE_TYPE_STEPWISE;
> -	frmsize.stepwise.min_width = frmsize.stepwise.step_width = 16;
> -	frmsize.stepwise.min_height = frmsize.stepwise.step_height = 16;
> -	frmsize.stepwise.max_width = cam->sensor.cropcap.bounds.width;
> -	frmsize.stepwise.max_height = cam->sensor.cropcap.bounds.height;
> -	memset(&frmsize.reserved, 0, sizeof(frmsize.reserved));
> -
> -	if (copy_to_user(arg, &frmsize, sizeof(frmsize)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_enum_fmt(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_fmtdesc fmtd;
> -
> -	if (copy_from_user(&fmtd, arg, sizeof(fmtd)))
> -		return -EFAULT;
> -
> -	if (fmtd.type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	if (fmtd.index == 0) {
> -		strcpy(fmtd.description, "bayer rgb");
> -		fmtd.pixelformat = V4L2_PIX_FMT_SBGGR8;
> -	} else if (fmtd.index == 1) {
> -		switch (cam->bridge) {
> -		case BRIDGE_SN9C101:
> -		case BRIDGE_SN9C102:
> -		case BRIDGE_SN9C103:
> -			strcpy(fmtd.description, "compressed");
> -			fmtd.pixelformat = V4L2_PIX_FMT_SN9C10X;
> -			break;
> -		case BRIDGE_SN9C105:
> -		case BRIDGE_SN9C120:
> -			strcpy(fmtd.description, "JPEG");
> -			fmtd.pixelformat = V4L2_PIX_FMT_JPEG;
> -			break;
> -		}
> -		fmtd.flags = V4L2_FMT_FLAG_COMPRESSED;
> -	} else
> -		return -EINVAL;
> -
> -	fmtd.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	memset(&fmtd.reserved, 0, sizeof(fmtd.reserved));
> -
> -	if (copy_to_user(arg, &fmtd, sizeof(fmtd)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_g_fmt(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_format format;
> -	struct v4l2_pix_format *pfmt = &(cam->sensor.pix_format);
> -
> -	if (copy_from_user(&format, arg, sizeof(format)))
> -		return -EFAULT;
> -
> -	if (format.type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	pfmt->colorspace = (pfmt->pixelformat == V4L2_PIX_FMT_JPEG) ?
> -			   V4L2_COLORSPACE_JPEG : V4L2_COLORSPACE_SRGB;
> -	pfmt->bytesperline = (pfmt->pixelformat == V4L2_PIX_FMT_SN9C10X ||
> -			      pfmt->pixelformat == V4L2_PIX_FMT_JPEG)
> -			     ? 0 : (pfmt->width * pfmt->priv) / 8;
> -	pfmt->sizeimage = pfmt->height * ((pfmt->width*pfmt->priv)/8);
> -	pfmt->field = V4L2_FIELD_NONE;
> -	memcpy(&(format.fmt.pix), pfmt, sizeof(*pfmt));
> -
> -	if (copy_to_user(arg, &format, sizeof(format)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_try_s_fmt(struct sn9c102_device *cam, unsigned int cmd,
> -			 void __user *arg)
> -{
> -	struct sn9c102_sensor *s = &cam->sensor;
> -	struct v4l2_format format;
> -	struct v4l2_pix_format *pix;
> -	struct v4l2_pix_format *pfmt = &(s->pix_format);
> -	struct v4l2_rect *bounds = &(s->cropcap.bounds);
> -	struct v4l2_rect rect;
> -	u8 scale;
> -	const enum sn9c102_stream_state stream = cam->stream;
> -	const u32 nbuffers = cam->nbuffers;
> -	u32 i;
> -	int err = 0;
> -
> -	if (copy_from_user(&format, arg, sizeof(format)))
> -		return -EFAULT;
> -
> -	pix = &(format.fmt.pix);
> -
> -	if (format.type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	memcpy(&rect, &(s->_rect), sizeof(rect));
> -
> -	{ /* calculate the actual scaling factor */
> -		u32 a, b;
> -		a = rect.width * rect.height;
> -		b = pix->width * pix->height;
> -		scale = b ? (u8)((a / b) < 4 ? 1 : ((a / b) < 16 ? 2 : 4)) : 1;
> -	}
> -
> -	rect.width = scale * pix->width;
> -	rect.height = scale * pix->height;
> -
> -	if (rect.width < 16)
> -		rect.width = 16;
> -	if (rect.height < 16)
> -		rect.height = 16;
> -	if (rect.width > bounds->left + bounds->width - rect.left)
> -		rect.width = bounds->left + bounds->width - rect.left;
> -	if (rect.height > bounds->top + bounds->height - rect.top)
> -		rect.height = bounds->top + bounds->height - rect.top;
> -
> -	rect.width &= ~15L;
> -	rect.height &= ~15L;
> -
> -	{ /* adjust the scaling factor */
> -		u32 a, b;
> -		a = rect.width * rect.height;
> -		b = pix->width * pix->height;
> -		scale = b ? (u8)((a / b) < 4 ? 1 : ((a / b) < 16 ? 2 : 4)) : 1;
> -	}
> -
> -	pix->width = rect.width / scale;
> -	pix->height = rect.height / scale;
> -
> -	switch (cam->bridge) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -	case BRIDGE_SN9C103:
> -		if (pix->pixelformat != V4L2_PIX_FMT_SN9C10X &&
> -		    pix->pixelformat != V4L2_PIX_FMT_SBGGR8)
> -			pix->pixelformat = pfmt->pixelformat;
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		if (pix->pixelformat != V4L2_PIX_FMT_JPEG &&
> -		    pix->pixelformat != V4L2_PIX_FMT_SBGGR8)
> -			pix->pixelformat = pfmt->pixelformat;
> -		break;
> -	}
> -	pix->priv = pfmt->priv; /* bpp */
> -	pix->colorspace = (pix->pixelformat == V4L2_PIX_FMT_JPEG) ?
> -			  V4L2_COLORSPACE_JPEG : V4L2_COLORSPACE_SRGB;
> -	pix->bytesperline = (pix->pixelformat == V4L2_PIX_FMT_SN9C10X ||
> -			     pix->pixelformat == V4L2_PIX_FMT_JPEG)
> -			    ? 0 : (pix->width * pix->priv) / 8;
> -	pix->sizeimage = pix->height * ((pix->width * pix->priv) / 8);
> -	pix->field = V4L2_FIELD_NONE;
> -
> -	if (cmd == VIDIOC_TRY_FMT) {
> -		if (copy_to_user(arg, &format, sizeof(format)))
> -			return -EFAULT;
> -		return 0;
> -	}
> -
> -	if (cam->module_param.force_munmap)
> -		for (i = 0; i < cam->nbuffers; i++)
> -			if (cam->frame[i].vma_use_count) {
> -				DBG(3, "VIDIOC_S_FMT failed. Unmap the "
> -				       "buffers first.");
> -				return -EBUSY;
> -			}
> -
> -	if (cam->stream == STREAM_ON) {
> -		err = sn9c102_stream_interrupt(cam);
> -		if (err)
> -			return err;
> -	}
> -
> -	if (copy_to_user(arg, &format, sizeof(format))) {
> -		cam->stream = stream;
> -		return -EFAULT;
> -	}
> -
> -	if (cam->module_param.force_munmap  || cam->io == IO_READ)
> -		sn9c102_release_buffers(cam);
> -
> -	err += sn9c102_set_pix_format(cam, pix);
> -	err += sn9c102_set_crop(cam, &rect);
> -	if (s->set_pix_format)
> -		err += s->set_pix_format(cam, pix);
> -	if (s->set_crop)
> -		err += s->set_crop(cam, &rect);
> -	err += sn9c102_set_scale(cam, scale);
> -
> -	if (err) { /* atomic, no rollback in ioctl() */
> -		cam->state |= DEV_MISCONFIGURED;
> -		DBG(1, "VIDIOC_S_FMT failed because of hardware problems. To "
> -		       "use the camera, close and open %s again.",
> -		    video_device_node_name(cam->v4ldev));
> -		return -EIO;
> -	}
> -
> -	memcpy(pfmt, pix, sizeof(*pix));
> -	memcpy(&(s->_rect), &rect, sizeof(rect));
> -
> -	if ((cam->module_param.force_munmap  || cam->io == IO_READ) &&
> -	    nbuffers != sn9c102_request_buffers(cam, nbuffers, cam->io)) {
> -		cam->state |= DEV_MISCONFIGURED;
> -		DBG(1, "VIDIOC_S_FMT failed because of not enough memory. To "
> -		       "use the camera, close and open %s again.",
> -		    video_device_node_name(cam->v4ldev));
> -		return -ENOMEM;
> -	}
> -
> -	if (cam->io == IO_READ)
> -		sn9c102_empty_framequeues(cam);
> -	else if (cam->module_param.force_munmap)
> -		sn9c102_requeue_outqueue(cam);
> -
> -	cam->stream = stream;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_g_jpegcomp(struct sn9c102_device *cam, void __user *arg)
> -{
> -	if (copy_to_user(arg, &cam->compression, sizeof(cam->compression)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_s_jpegcomp(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_jpegcompression jc;
> -	const enum sn9c102_stream_state stream = cam->stream;
> -	int err = 0;
> -
> -	if (copy_from_user(&jc, arg, sizeof(jc)))
> -		return -EFAULT;
> -
> -	if (jc.quality != 0 && jc.quality != 1)
> -		return -EINVAL;
> -
> -	if (cam->stream == STREAM_ON) {
> -		err = sn9c102_stream_interrupt(cam);
> -		if (err)
> -			return err;
> -	}
> -
> -	err += sn9c102_set_compression(cam, &jc);
> -	if (err) { /* atomic, no rollback in ioctl() */
> -		cam->state |= DEV_MISCONFIGURED;
> -		DBG(1, "VIDIOC_S_JPEGCOMP failed because of hardware problems. "
> -		       "To use the camera, close and open %s again.",
> -		    video_device_node_name(cam->v4ldev));
> -		return -EIO;
> -	}
> -
> -	cam->compression.quality = jc.quality;
> -
> -	cam->stream = stream;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_reqbufs(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_requestbuffers rb;
> -	u32 i;
> -	int err;
> -
> -	if (copy_from_user(&rb, arg, sizeof(rb)))
> -		return -EFAULT;
> -
> -	if (rb.type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> -	    rb.memory != V4L2_MEMORY_MMAP)
> -		return -EINVAL;
> -
> -	if (cam->io == IO_READ) {
> -		DBG(3, "Close and open the device again to choose the mmap "
> -		       "I/O method");
> -		return -EBUSY;
> -	}
> -
> -	for (i = 0; i < cam->nbuffers; i++)
> -		if (cam->frame[i].vma_use_count) {
> -			DBG(3, "VIDIOC_REQBUFS failed. Previous buffers are "
> -			       "still mapped.");
> -			return -EBUSY;
> -		}
> -
> -	if (cam->stream == STREAM_ON) {
> -		err = sn9c102_stream_interrupt(cam);
> -		if (err)
> -			return err;
> -	}
> -
> -	sn9c102_empty_framequeues(cam);
> -
> -	sn9c102_release_buffers(cam);
> -	if (rb.count)
> -		rb.count = sn9c102_request_buffers(cam, rb.count, IO_MMAP);
> -
> -	if (copy_to_user(arg, &rb, sizeof(rb))) {
> -		sn9c102_release_buffers(cam);
> -		cam->io = IO_NONE;
> -		return -EFAULT;
> -	}
> -
> -	cam->io = rb.count ? IO_MMAP : IO_NONE;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_querybuf(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_buffer b;
> -
> -	if (copy_from_user(&b, arg, sizeof(b)))
> -		return -EFAULT;
> -
> -	if (b.type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> -	    b.index >= cam->nbuffers || cam->io != IO_MMAP)
> -		return -EINVAL;
> -
> -	b = cam->frame[b.index].buf;
> -
> -	if (cam->frame[b.index].vma_use_count)
> -		b.flags |= V4L2_BUF_FLAG_MAPPED;
> -
> -	if (cam->frame[b.index].state == F_DONE)
> -		b.flags |= V4L2_BUF_FLAG_DONE;
> -	else if (cam->frame[b.index].state != F_UNUSED)
> -		b.flags |= V4L2_BUF_FLAG_QUEUED;
> -
> -	if (copy_to_user(arg, &b, sizeof(b)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_qbuf(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_buffer b;
> -	unsigned long lock_flags;
> -
> -	if (copy_from_user(&b, arg, sizeof(b)))
> -		return -EFAULT;
> -
> -	if (b.type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> -	    b.index >= cam->nbuffers || cam->io != IO_MMAP)
> -		return -EINVAL;
> -
> -	if (cam->frame[b.index].state != F_UNUSED)
> -		return -EINVAL;
> -
> -	cam->frame[b.index].state = F_QUEUED;
> -
> -	spin_lock_irqsave(&cam->queue_lock, lock_flags);
> -	list_add_tail(&cam->frame[b.index].frame, &cam->inqueue);
> -	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
> -
> -	PDBGG("Frame #%lu queued", (unsigned long)b.index);
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_dqbuf(struct sn9c102_device *cam, struct file *filp,
> -		     void __user *arg)
> -{
> -	struct v4l2_buffer b;
> -	struct sn9c102_frame_t *f;
> -	unsigned long lock_flags;
> -	long timeout;
> -	int err = 0;
> -
> -	if (copy_from_user(&b, arg, sizeof(b)))
> -		return -EFAULT;
> -
> -	if (b.type != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP)
> -		return -EINVAL;
> -
> -	if (list_empty(&cam->outqueue)) {
> -		if (cam->stream == STREAM_OFF)
> -			return -EINVAL;
> -		if (filp->f_flags & O_NONBLOCK)
> -			return -EAGAIN;
> -		if (!cam->module_param.frame_timeout) {
> -			err = wait_event_interruptible
> -			      (cam->wait_frame,
> -				(!list_empty(&cam->outqueue)) ||
> -				(cam->state & DEV_DISCONNECTED) ||
> -				(cam->state & DEV_MISCONFIGURED));
> -			if (err)
> -				return err;
> -		} else {
> -			timeout = wait_event_interruptible_timeout
> -				  (cam->wait_frame,
> -				    (!list_empty(&cam->outqueue)) ||
> -				    (cam->state & DEV_DISCONNECTED) ||
> -				    (cam->state & DEV_MISCONFIGURED),
> -				    cam->module_param.frame_timeout *
> -				    1000 * msecs_to_jiffies(1));
> -			if (timeout < 0)
> -				return timeout;
> -			else if (timeout == 0 &&
> -				 !(cam->state & DEV_DISCONNECTED)) {
> -				DBG(1, "Video frame timeout elapsed");
> -				return -EIO;
> -			}
> -		}
> -		if (cam->state & DEV_DISCONNECTED)
> -			return -ENODEV;
> -		if (cam->state & DEV_MISCONFIGURED)
> -			return -EIO;
> -	}
> -
> -	spin_lock_irqsave(&cam->queue_lock, lock_flags);
> -	f = list_entry(cam->outqueue.next, struct sn9c102_frame_t, frame);
> -	list_del(cam->outqueue.next);
> -	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
> -
> -	f->state = F_UNUSED;
> -
> -	b = f->buf;
> -	if (f->vma_use_count)
> -		b.flags |= V4L2_BUF_FLAG_MAPPED;
> -
> -	if (copy_to_user(arg, &b, sizeof(b)))
> -		return -EFAULT;
> -
> -	PDBGG("Frame #%lu dequeued", (unsigned long)f->buf.index);
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_streamon(struct sn9c102_device *cam, void __user *arg)
> -{
> -	int type;
> -
> -	if (copy_from_user(&type, arg, sizeof(type)))
> -		return -EFAULT;
> -
> -	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP)
> -		return -EINVAL;
> -
> -	cam->stream = STREAM_ON;
> -
> -	DBG(3, "Stream on");
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_streamoff(struct sn9c102_device *cam, void __user *arg)
> -{
> -	int type, err;
> -
> -	if (copy_from_user(&type, arg, sizeof(type)))
> -		return -EFAULT;
> -
> -	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP)
> -		return -EINVAL;
> -
> -	if (cam->stream == STREAM_ON) {
> -		err = sn9c102_stream_interrupt(cam);
> -		if (err)
> -			return err;
> -	}
> -
> -	sn9c102_empty_framequeues(cam);
> -
> -	DBG(3, "Stream off");
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_g_parm(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_streamparm sp;
> -
> -	if (copy_from_user(&sp, arg, sizeof(sp)))
> -		return -EFAULT;
> -
> -	if (sp.type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	sp.parm.capture.extendedmode = 0;
> -	sp.parm.capture.readbuffers = cam->nreadbuffers;
> -
> -	if (copy_to_user(arg, &sp, sizeof(sp)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_s_parm(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_streamparm sp;
> -
> -	if (copy_from_user(&sp, arg, sizeof(sp)))
> -		return -EFAULT;
> -
> -	if (sp.type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	sp.parm.capture.extendedmode = 0;
> -
> -	if (sp.parm.capture.readbuffers == 0)
> -		sp.parm.capture.readbuffers = cam->nreadbuffers;
> -
> -	if (sp.parm.capture.readbuffers > SN9C102_MAX_FRAMES)
> -		sp.parm.capture.readbuffers = SN9C102_MAX_FRAMES;
> -
> -	if (copy_to_user(arg, &sp, sizeof(sp)))
> -		return -EFAULT;
> -
> -	cam->nreadbuffers = sp.parm.capture.readbuffers;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_enumaudio(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_audio audio;
> -
> -	if (cam->bridge == BRIDGE_SN9C101 || cam->bridge == BRIDGE_SN9C102)
> -		return -EINVAL;
> -
> -	if (copy_from_user(&audio, arg, sizeof(audio)))
> -		return -EFAULT;
> -
> -	if (audio.index != 0)
> -		return -EINVAL;
> -
> -	strcpy(audio.name, "Microphone");
> -	audio.capability = 0;
> -	audio.mode = 0;
> -
> -	if (copy_to_user(arg, &audio, sizeof(audio)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_g_audio(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_audio audio;
> -
> -	if (cam->bridge == BRIDGE_SN9C101 || cam->bridge == BRIDGE_SN9C102)
> -		return -EINVAL;
> -
> -	if (copy_from_user(&audio, arg, sizeof(audio)))
> -		return -EFAULT;
> -
> -	memset(&audio, 0, sizeof(audio));
> -	strcpy(audio.name, "Microphone");
> -
> -	if (copy_to_user(arg, &audio, sizeof(audio)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -
> -static int
> -sn9c102_vidioc_s_audio(struct sn9c102_device *cam, void __user *arg)
> -{
> -	struct v4l2_audio audio;
> -
> -	if (cam->bridge == BRIDGE_SN9C101 || cam->bridge == BRIDGE_SN9C102)
> -		return -EINVAL;
> -
> -	if (copy_from_user(&audio, arg, sizeof(audio)))
> -		return -EFAULT;
> -
> -	if (audio.index != 0)
> -		return -EINVAL;
> -
> -	return 0;
> -}
> -
> -
> -static long sn9c102_ioctl_v4l2(struct file *filp,
> -			      unsigned int cmd, void __user *arg)
> -{
> -	struct sn9c102_device *cam = video_drvdata(filp);
> -
> -	switch (cmd) {
> -
> -	case VIDIOC_QUERYCAP:
> -		return sn9c102_vidioc_querycap(cam, arg);
> -
> -	case VIDIOC_ENUMINPUT:
> -		return sn9c102_vidioc_enuminput(cam, arg);
> -
> -	case VIDIOC_G_INPUT:
> -		return sn9c102_vidioc_g_input(cam, arg);
> -
> -	case VIDIOC_S_INPUT:
> -		return sn9c102_vidioc_s_input(cam, arg);
> -
> -	case VIDIOC_QUERYCTRL:
> -		return sn9c102_vidioc_query_ctrl(cam, arg);
> -
> -	case VIDIOC_G_CTRL:
> -		return sn9c102_vidioc_g_ctrl(cam, arg);
> -
> -	case VIDIOC_S_CTRL:
> -		return sn9c102_vidioc_s_ctrl(cam, arg);
> -
> -	case VIDIOC_CROPCAP:
> -		return sn9c102_vidioc_cropcap(cam, arg);
> -
> -	case VIDIOC_G_CROP:
> -		return sn9c102_vidioc_g_crop(cam, arg);
> -
> -	case VIDIOC_S_CROP:
> -		return sn9c102_vidioc_s_crop(cam, arg);
> -
> -	case VIDIOC_ENUM_FRAMESIZES:
> -		return sn9c102_vidioc_enum_framesizes(cam, arg);
> -
> -	case VIDIOC_ENUM_FMT:
> -		return sn9c102_vidioc_enum_fmt(cam, arg);
> -
> -	case VIDIOC_G_FMT:
> -		return sn9c102_vidioc_g_fmt(cam, arg);
> -
> -	case VIDIOC_TRY_FMT:
> -	case VIDIOC_S_FMT:
> -		return sn9c102_vidioc_try_s_fmt(cam, cmd, arg);
> -
> -	case VIDIOC_G_JPEGCOMP:
> -		return sn9c102_vidioc_g_jpegcomp(cam, arg);
> -
> -	case VIDIOC_S_JPEGCOMP:
> -		return sn9c102_vidioc_s_jpegcomp(cam, arg);
> -
> -	case VIDIOC_REQBUFS:
> -		return sn9c102_vidioc_reqbufs(cam, arg);
> -
> -	case VIDIOC_QUERYBUF:
> -		return sn9c102_vidioc_querybuf(cam, arg);
> -
> -	case VIDIOC_QBUF:
> -		return sn9c102_vidioc_qbuf(cam, arg);
> -
> -	case VIDIOC_DQBUF:
> -		return sn9c102_vidioc_dqbuf(cam, filp, arg);
> -
> -	case VIDIOC_STREAMON:
> -		return sn9c102_vidioc_streamon(cam, arg);
> -
> -	case VIDIOC_STREAMOFF:
> -		return sn9c102_vidioc_streamoff(cam, arg);
> -
> -	case VIDIOC_G_PARM:
> -		return sn9c102_vidioc_g_parm(cam, arg);
> -
> -	case VIDIOC_S_PARM:
> -		return sn9c102_vidioc_s_parm(cam, arg);
> -
> -	case VIDIOC_ENUMAUDIO:
> -		return sn9c102_vidioc_enumaudio(cam, arg);
> -
> -	case VIDIOC_G_AUDIO:
> -		return sn9c102_vidioc_g_audio(cam, arg);
> -
> -	case VIDIOC_S_AUDIO:
> -		return sn9c102_vidioc_s_audio(cam, arg);
> -
> -	default:
> -		return -ENOTTY;
> -
> -	}
> -}
> -
> -
> -static long sn9c102_ioctl(struct file *filp,
> -			 unsigned int cmd, unsigned long arg)
> -{
> -	struct sn9c102_device *cam = video_drvdata(filp);
> -	int err = 0;
> -
> -	if (mutex_lock_interruptible(&cam->fileop_mutex))
> -		return -ERESTARTSYS;
> -
> -	if (cam->state & DEV_DISCONNECTED) {
> -		DBG(1, "Device not present");
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -ENODEV;
> -	}
> -
> -	if (cam->state & DEV_MISCONFIGURED) {
> -		DBG(1, "The camera is misconfigured. Close and open it "
> -		       "again.");
> -		mutex_unlock(&cam->fileop_mutex);
> -		return -EIO;
> -	}
> -
> -	V4LDBG(3, "sn9c102", cmd);
> -
> -	err = sn9c102_ioctl_v4l2(filp, cmd, (void __user *)arg);
> -
> -	mutex_unlock(&cam->fileop_mutex);
> -
> -	return err;
> -}
> -
> -/*****************************************************************************/
> -
> -static const struct v4l2_file_operations sn9c102_fops = {
> -	.owner = THIS_MODULE,
> -	.open = sn9c102_open,
> -	.release = sn9c102_release,
> -	.unlocked_ioctl = sn9c102_ioctl,
> -	.read = sn9c102_read,
> -	.poll = sn9c102_poll,
> -	.mmap = sn9c102_mmap,
> -};
> -
> -/*****************************************************************************/
> -
> -/* It exists a single interface only. We do not need to validate anything. */
> -static int
> -sn9c102_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
> -{
> -	struct usb_device *udev = interface_to_usbdev(intf);
> -	struct sn9c102_device *cam;
> -	static unsigned int dev_nr;
> -	unsigned int i;
> -	int err = 0, r;
> -
> -	cam = kzalloc(sizeof(struct sn9c102_device), GFP_KERNEL);
> -	if (!cam)
> -		return -ENOMEM;
> -
> -	cam->usbdev = udev;
> -
> -	/* register v4l2_device early so it can be used for printks */
> -	if (v4l2_device_register(&intf->dev, &cam->v4l2_dev)) {
> -		dev_err(&intf->dev, "v4l2_device_register failed\n");
> -		err = -ENOMEM;
> -		goto fail;
> -	}
> -
> -	cam->control_buffer = kzalloc(8, GFP_KERNEL);
> -	if (!cam->control_buffer) {
> -		DBG(1, "kzalloc() failed");
> -		err = -ENOMEM;
> -		goto fail;
> -	}
> -
> -	cam->v4ldev = video_device_alloc();
> -	if (!cam->v4ldev) {
> -		DBG(1, "video_device_alloc() failed");
> -		err = -ENOMEM;
> -		goto fail;
> -	}
> -
> -	r = sn9c102_read_reg(cam, 0x00);
> -	if (r < 0 || (r != 0x10 && r != 0x11 && r != 0x12)) {
> -		DBG(1, "Sorry, this is not a SN9C1xx-based camera "
> -		       "(vid:pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
> -		err = -ENODEV;
> -		goto fail;
> -	}
> -
> -	cam->bridge = id->driver_info;
> -	switch (cam->bridge) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -		DBG(2, "SN9C10[12] PC Camera Controller detected "
> -		       "(vid:pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
> -		break;
> -	case BRIDGE_SN9C103:
> -		DBG(2, "SN9C103 PC Camera Controller detected "
> -		       "(vid:pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
> -		break;
> -	case BRIDGE_SN9C105:
> -		DBG(2, "SN9C105 PC Camera Controller detected "
> -		       "(vid:pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
> -		break;
> -	case BRIDGE_SN9C120:
> -		DBG(2, "SN9C120 PC Camera Controller detected "
> -		       "(vid:pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
> -		break;
> -	}
> -
> -	for  (i = 0; i < ARRAY_SIZE(sn9c102_sensor_table); i++) {
> -		err = sn9c102_sensor_table[i](cam);
> -		if (!err)
> -			break;
> -	}
> -
> -	if (!err) {
> -		DBG(2, "%s image sensor detected", cam->sensor.name);
> -		DBG(3, "Support for %s maintained by %s",
> -		    cam->sensor.name, cam->sensor.maintainer);
> -	} else {
> -		DBG(1, "No supported image sensor detected for this bridge");
> -		err = -ENODEV;
> -		goto fail;
> -	}
> -
> -	if (!(cam->bridge & cam->sensor.supported_bridge)) {
> -		DBG(1, "Bridge not supported");
> -		err = -ENODEV;
> -		goto fail;
> -	}
> -
> -	if (sn9c102_init(cam)) {
> -		DBG(1, "Initialization failed. I will retry on open().");
> -		cam->state |= DEV_MISCONFIGURED;
> -	}
> -
> -	strcpy(cam->v4ldev->name, "SN9C1xx PC Camera");
> -	cam->v4ldev->fops = &sn9c102_fops;
> -	cam->v4ldev->release = video_device_release;
> -	cam->v4ldev->v4l2_dev = &cam->v4l2_dev;
> -
> -	init_completion(&cam->probe);
> -
> -	err = video_register_device(cam->v4ldev, VFL_TYPE_GRABBER,
> -				    video_nr[dev_nr]);
> -	if (err) {
> -		DBG(1, "V4L2 device registration failed");
> -		if (err == -ENFILE && video_nr[dev_nr] == -1)
> -			DBG(1, "Free /dev/videoX node not found");
> -		video_nr[dev_nr] = -1;
> -		dev_nr = (dev_nr < SN9C102_MAX_DEVICES-1) ? dev_nr+1 : 0;
> -		complete_all(&cam->probe);
> -		goto fail;
> -	}
> -
> -	DBG(2, "V4L2 device registered as %s",
> -	    video_device_node_name(cam->v4ldev));
> -
> -	video_set_drvdata(cam->v4ldev, cam);
> -	cam->module_param.force_munmap = force_munmap[dev_nr];
> -	cam->module_param.frame_timeout = frame_timeout[dev_nr];
> -
> -	dev_nr = (dev_nr < SN9C102_MAX_DEVICES-1) ? dev_nr+1 : 0;
> -
> -#ifdef CONFIG_VIDEO_ADV_DEBUG
> -	err = sn9c102_create_sysfs(cam);
> -	if (!err)
> -		DBG(2, "Optional device control through 'sysfs' "
> -		       "interface ready");
> -	else
> -		DBG(2, "Failed to create optional 'sysfs' interface for "
> -		       "device controlling. Error #%d", err);
> -#else
> -	DBG(2, "Optional device control through 'sysfs' interface disabled");
> -	DBG(3, "Compile the kernel with the 'CONFIG_VIDEO_ADV_DEBUG' "
> -	       "configuration option to enable it.");
> -#endif
> -
> -	usb_set_intfdata(intf, cam);
> -	kref_init(&cam->kref);
> -	usb_get_dev(cam->usbdev);
> -
> -	complete_all(&cam->probe);
> -
> -	return 0;
> -
> -fail:
> -	if (cam) {
> -		kfree(cam->control_buffer);
> -		if (cam->v4ldev)
> -			video_device_release(cam->v4ldev);
> -		v4l2_device_unregister(&cam->v4l2_dev);
> -		kfree(cam);
> -	}
> -	return err;
> -}
> -
> -
> -static void sn9c102_usb_disconnect(struct usb_interface *intf)
> -{
> -	struct sn9c102_device *cam;
> -
> -	down_write(&sn9c102_dev_lock);
> -
> -	cam = usb_get_intfdata(intf);
> -
> -	DBG(2, "Disconnecting %s...", cam->v4ldev->name);
> -
> -	if (cam->users) {
> -		DBG(2, "Device %s is open! Deregistration and memory "
> -		       "deallocation are deferred.",
> -		    video_device_node_name(cam->v4ldev));
> -		cam->state |= DEV_MISCONFIGURED;
> -		sn9c102_stop_transfer(cam);
> -		cam->state |= DEV_DISCONNECTED;
> -		wake_up_interruptible(&cam->wait_frame);
> -		wake_up(&cam->wait_stream);
> -	} else
> -		cam->state |= DEV_DISCONNECTED;
> -
> -	wake_up_interruptible_all(&cam->wait_open);
> -
> -	v4l2_device_disconnect(&cam->v4l2_dev);
> -
> -	kref_put(&cam->kref, sn9c102_release_resources);
> -
> -	up_write(&sn9c102_dev_lock);
> -}
> -
> -
> -static struct usb_driver sn9c102_usb_driver = {
> -	.name =       "sn9c102",
> -	.id_table =   sn9c102_id_table,
> -	.probe =      sn9c102_usb_probe,
> -	.disconnect = sn9c102_usb_disconnect,
> -};
> -
> -module_usb_driver(sn9c102_usb_driver);
> diff --git a/drivers/staging/media/sn9c102/sn9c102_devtable.h b/drivers/staging/media/sn9c102/sn9c102_devtable.h
> deleted file mode 100644
> index b187a8a..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_devtable.h
> +++ /dev/null
> @@ -1,145 +0,0 @@
> -/***************************************************************************
> - * Table of device identifiers of the SN9C1xx PC Camera Controllers        *
> - *                                                                         *
> - * Copyright (C) 2007 by Luca Risolia <luca.risolia@studio.unibo.it>       *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#ifndef _SN9C102_DEVTABLE_H_
> -#define _SN9C102_DEVTABLE_H_
> -
> -#include <linux/usb.h>
> -
> -struct sn9c102_device;
> -
> -/*
> -   Each SN9C1xx camera has proper PID/VID identifiers.
> -   SN9C103, SN9C105, SN9C120 support multiple interfaces, but we only have to
> -   handle the video class interface.
> -*/
> -#define SN9C102_USB_DEVICE(vend, prod, bridge)                                \
> -	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |                           \
> -		       USB_DEVICE_ID_MATCH_INT_CLASS,                         \
> -	.idVendor = (vend),                                                   \
> -	.idProduct = (prod),                                                  \
> -	.bInterfaceClass = 0xff,                                              \
> -	.driver_info = (bridge)
> -
> -static const struct usb_device_id sn9c102_id_table[] = {
> -	/* SN9C101 and SN9C102 */
> -#if !defined CONFIG_USB_GSPCA_SONIXB && !defined CONFIG_USB_GSPCA_SONIXB_MODULE
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6001, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6005, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6007, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6009, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x600d, BRIDGE_SN9C102), },
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6011, BRIDGE_SN9C102), }, OV6650 */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6019, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6024, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6025, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6028, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6029, BRIDGE_SN9C102), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x602a, BRIDGE_SN9C102), },
> -#endif
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x602b, BRIDGE_SN9C102), }, /* not in sonixb */
> -#if !defined CONFIG_USB_GSPCA_SONIXB && !defined CONFIG_USB_GSPCA_SONIXB_MODULE
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x602c, BRIDGE_SN9C102), },
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x602d, BRIDGE_SN9C102), }, HV7131R */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x602e, BRIDGE_SN9C102), },
> -#endif
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6030, BRIDGE_SN9C102), }, /* not in sonixb */
> -	/* SN9C103 */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6080, BRIDGE_SN9C103), }, non existent ? */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6082, BRIDGE_SN9C103), }, /* not in sonixb */
> -#if !defined CONFIG_USB_GSPCA_SONIXB && !defined CONFIG_USB_GSPCA_SONIXB_MODULE
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6083, BRIDGE_SN9C103), }, HY7131D/E */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6088, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x608a, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x608b, BRIDGE_SN9C103), }, non existent ? */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x608c, BRIDGE_SN9C103), },
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x608e, BRIDGE_SN9C103), }, CISVF10 */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x608f, BRIDGE_SN9C103), },
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60a0, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60a2, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60a3, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60a8, BRIDGE_SN9C103), }, PAS106 */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60aa, BRIDGE_SN9C103), }, TAS5130 */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60ab, BRIDGE_SN9C103), }, TAS5110, non existent */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60ac, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60ae, BRIDGE_SN9C103), }, non existent ? */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x60af, BRIDGE_SN9C103), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x60b0, BRIDGE_SN9C103), },
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60b2, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60b3, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60b8, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60ba, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60bb, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60bc, BRIDGE_SN9C103), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60be, BRIDGE_SN9C103), }, non existent ? */
> -#endif
> -	/* SN9C105 */
> -#if !defined CONFIG_USB_GSPCA_SONIXJ && !defined CONFIG_USB_GSPCA_SONIXJ_MODULE
> -	{ SN9C102_USB_DEVICE(0x045e, 0x00f5, BRIDGE_SN9C105), },
> -	{ SN9C102_USB_DEVICE(0x045e, 0x00f7, BRIDGE_SN9C105), },
> -	{ SN9C102_USB_DEVICE(0x0471, 0x0327, BRIDGE_SN9C105), },
> -	{ SN9C102_USB_DEVICE(0x0471, 0x0328, BRIDGE_SN9C105), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x60c0, BRIDGE_SN9C105), },
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60c2, BRIDGE_SN9C105), }, PO1030 */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60c8, BRIDGE_SN9C105), }, OM6801 */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60cc, BRIDGE_SN9C105), }, HV7131GP */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60ea, BRIDGE_SN9C105), }, non existent ? */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60ec, BRIDGE_SN9C105), }, MO4000 */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60ef, BRIDGE_SN9C105), }, ICM105C */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60fa, BRIDGE_SN9C105), }, OV7648 */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x60fb, BRIDGE_SN9C105), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x60fc, BRIDGE_SN9C105), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x60fe, BRIDGE_SN9C105), },
> -	/* SN9C120 */
> -	{ SN9C102_USB_DEVICE(0x0458, 0x7025, BRIDGE_SN9C120), },
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6102, BRIDGE_SN9C120), }, po2030 */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6108, BRIDGE_SN9C120), }, om6801 */
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x610f, BRIDGE_SN9C120), }, S5K53BEB */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x6130, BRIDGE_SN9C120), },
> -/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6138, BRIDGE_SN9C120), }, MO8000 */
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x613a, BRIDGE_SN9C120), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x613b, BRIDGE_SN9C120), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x613c, BRIDGE_SN9C120), },
> -	{ SN9C102_USB_DEVICE(0x0c45, 0x613e, BRIDGE_SN9C120), },
> -#endif
> -	{ }
> -};
> -
> -/*
> -   Probing functions: on success, you must attach the sensor to the camera
> -   by calling sn9c102_attach_sensor().
> -   To enable the I2C communication, you might need to perform a really basic
> -   initialization of the SN9C1XX chip.
> -   Functions must return 0 on success, the appropriate error otherwise.
> -*/
> -extern int sn9c102_probe_hv7131d(struct sn9c102_device *cam);
> -extern int sn9c102_probe_hv7131r(struct sn9c102_device *cam);
> -extern int sn9c102_probe_mi0343(struct sn9c102_device *cam);
> -extern int sn9c102_probe_mi0360(struct sn9c102_device *cam);
> -extern int sn9c102_probe_mt9v111(struct sn9c102_device *cam);
> -extern int sn9c102_probe_ov7630(struct sn9c102_device *cam);
> -extern int sn9c102_probe_ov7660(struct sn9c102_device *cam);
> -extern int sn9c102_probe_pas106b(struct sn9c102_device *cam);
> -extern int sn9c102_probe_pas202bcb(struct sn9c102_device *cam);
> -extern int sn9c102_probe_tas5110c1b(struct sn9c102_device *cam);
> -extern int sn9c102_probe_tas5110d(struct sn9c102_device *cam);
> -extern int sn9c102_probe_tas5130d1b(struct sn9c102_device *cam);
> -
> -#endif /* _SN9C102_DEVTABLE_H_ */
> diff --git a/drivers/staging/media/sn9c102/sn9c102_hv7131d.c b/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
> deleted file mode 100644
> index f1d94f0..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
> +++ /dev/null
> @@ -1,269 +0,0 @@
> -/***************************************************************************
> - * Plug-in for HV7131D image sensor connected to the SN9C1xx PC Camera     *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2004-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int hv7131d_init(struct sn9c102_device *cam)
> -{
> -	int err;
> -
> -	err = sn9c102_write_const_regs(cam, {0x00, 0x10}, {0x00, 0x11},
> -				       {0x00, 0x14}, {0x60, 0x17},
> -				       {0x0e, 0x18}, {0xf2, 0x19});
> -
> -	err += sn9c102_i2c_write(cam, 0x01, 0x04);
> -	err += sn9c102_i2c_write(cam, 0x02, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x28, 0x00);
> -
> -	return err;
> -}
> -
> -
> -static int hv7131d_get_ctrl(struct sn9c102_device *cam,
> -			    struct v4l2_control *ctrl)
> -{
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		{
> -			int r1 = sn9c102_i2c_read(cam, 0x26),
> -			    r2 = sn9c102_i2c_read(cam, 0x27);
> -			if (r1 < 0 || r2 < 0)
> -				return -EIO;
> -			ctrl->value = (r1 << 8) | (r2 & 0xff);
> -		}
> -		return 0;
> -	case V4L2_CID_RED_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x31);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = 0x3f - (ctrl->value & 0x3f);
> -		return 0;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x33);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = 0x3f - (ctrl->value & 0x3f);
> -		return 0;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x32);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = 0x3f - (ctrl->value & 0x3f);
> -		return 0;
> -	case SN9C102_V4L2_CID_RESET_LEVEL:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x30);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x3f;
> -		return 0;
> -	case SN9C102_V4L2_CID_PIXEL_BIAS_VOLTAGE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x34);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x07;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -
> -static int hv7131d_set_ctrl(struct sn9c102_device *cam,
> -			    const struct v4l2_control *ctrl)
> -{
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		err += sn9c102_i2c_write(cam, 0x26, ctrl->value >> 8);
> -		err += sn9c102_i2c_write(cam, 0x27, ctrl->value & 0xff);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x31, 0x3f - ctrl->value);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x33, 0x3f - ctrl->value);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x32, 0x3f - ctrl->value);
> -		break;
> -	case SN9C102_V4L2_CID_RESET_LEVEL:
> -		err += sn9c102_i2c_write(cam, 0x30, ctrl->value);
> -		break;
> -	case SN9C102_V4L2_CID_PIXEL_BIAS_VOLTAGE:
> -		err += sn9c102_i2c_write(cam, 0x34, ctrl->value);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int hv7131d_set_crop(struct sn9c102_device *cam,
> -			    const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 2,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 2;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -
> -static int hv7131d_set_pix_format(struct sn9c102_device *cam,
> -				  const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X)
> -		err += sn9c102_write_reg(cam, 0x42, 0x19);
> -	else
> -		err += sn9c102_write_reg(cam, 0xf2, 0x19);
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor hv7131d = {
> -	.name = "HV7131D",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C101 | BRIDGE_SN9C102,
> -	.sysfs_ops = SN9C102_I2C_READ | SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x11,
> -	.init = &hv7131d_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_EXPOSURE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "exposure",
> -			.minimum = 0x0250,
> -			.maximum = 0xffff,
> -			.step = 0x0001,
> -			.default_value = 0x0250,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_RED_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "red balance",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLUE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "blue balance",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x20,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GREEN_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "green balance",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x1e,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_RESET_LEVEL,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "reset level",
> -			.minimum = 0x19,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x30,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_PIXEL_BIAS_VOLTAGE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "pixel bias voltage",
> -			.minimum = 0x00,
> -			.maximum = 0x07,
> -			.step = 0x01,
> -			.default_value = 0x02,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &hv7131d_get_ctrl,
> -	.set_ctrl = &hv7131d_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &hv7131d_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &hv7131d_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_hv7131d(struct sn9c102_device *cam)
> -{
> -	int r0 = 0, r1 = 0, err;
> -
> -	err = sn9c102_write_const_regs(cam, {0x01, 0x01}, {0x00, 0x01},
> -				       {0x28, 0x17});
> -
> -	r0 = sn9c102_i2c_try_read(cam, &hv7131d, 0x00);
> -	r1 = sn9c102_i2c_try_read(cam, &hv7131d, 0x01);
> -	if (err || r0 < 0 || r1 < 0)
> -		return -EIO;
> -
> -	if ((r0 != 0x00 && r0 != 0x01) || r1 != 0x04)
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &hv7131d);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_hv7131r.c b/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
> deleted file mode 100644
> index 51b24e0..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
> +++ /dev/null
> @@ -1,369 +0,0 @@
> -/***************************************************************************
> - * Plug-in for HV7131R image sensor connected to the SN9C1xx PC Camera     *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2007 by Luca Risolia <luca.risolia@studio.unibo.it>       *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int hv7131r_init(struct sn9c102_device *cam)
> -{
> -	int err = 0;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C103:
> -		err = sn9c102_write_const_regs(cam, {0x00, 0x03}, {0x1a, 0x04},
> -					       {0x20, 0x05}, {0x20, 0x06},
> -					       {0x03, 0x10}, {0x00, 0x14},
> -					       {0x60, 0x17}, {0x0a, 0x18},
> -					       {0xf0, 0x19}, {0x1d, 0x1a},
> -					       {0x10, 0x1b}, {0x02, 0x1c},
> -					       {0x03, 0x1d}, {0x0f, 0x1e},
> -					       {0x0c, 0x1f}, {0x00, 0x20},
> -					       {0x10, 0x21}, {0x20, 0x22},
> -					       {0x30, 0x23}, {0x40, 0x24},
> -					       {0x50, 0x25}, {0x60, 0x26},
> -					       {0x70, 0x27}, {0x80, 0x28},
> -					       {0x90, 0x29}, {0xa0, 0x2a},
> -					       {0xb0, 0x2b}, {0xc0, 0x2c},
> -					       {0xd0, 0x2d}, {0xe0, 0x2e},
> -					       {0xf0, 0x2f}, {0xff, 0x30});
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		err = sn9c102_write_const_regs(cam, {0x44, 0x01}, {0x40, 0x02},
> -					       {0x00, 0x03}, {0x1a, 0x04},
> -					       {0x44, 0x05}, {0x3e, 0x06},
> -					       {0x1a, 0x07}, {0x03, 0x10},
> -					       {0x08, 0x14}, {0xa3, 0x17},
> -					       {0x4b, 0x18}, {0x00, 0x19},
> -					       {0x1d, 0x1a}, {0x10, 0x1b},
> -					       {0x02, 0x1c}, {0x03, 0x1d},
> -					       {0x0f, 0x1e}, {0x0c, 0x1f},
> -					       {0x00, 0x20}, {0x29, 0x21},
> -					       {0x40, 0x22}, {0x54, 0x23},
> -					       {0x66, 0x24}, {0x76, 0x25},
> -					       {0x85, 0x26}, {0x94, 0x27},
> -					       {0xa1, 0x28}, {0xae, 0x29},
> -					       {0xbb, 0x2a}, {0xc7, 0x2b},
> -					       {0xd3, 0x2c}, {0xde, 0x2d},
> -					       {0xea, 0x2e}, {0xf4, 0x2f},
> -					       {0xff, 0x30}, {0x00, 0x3F},
> -					       {0xC7, 0x40}, {0x01, 0x41},
> -					       {0x44, 0x42}, {0x00, 0x43},
> -					       {0x44, 0x44}, {0x00, 0x45},
> -					       {0x44, 0x46}, {0x00, 0x47},
> -					       {0xC7, 0x48}, {0x01, 0x49},
> -					       {0xC7, 0x4A}, {0x01, 0x4B},
> -					       {0xC7, 0x4C}, {0x01, 0x4D},
> -					       {0x44, 0x4E}, {0x00, 0x4F},
> -					       {0x44, 0x50}, {0x00, 0x51},
> -					       {0x44, 0x52}, {0x00, 0x53},
> -					       {0xC7, 0x54}, {0x01, 0x55},
> -					       {0xC7, 0x56}, {0x01, 0x57},
> -					       {0xC7, 0x58}, {0x01, 0x59},
> -					       {0x44, 0x5A}, {0x00, 0x5B},
> -					       {0x44, 0x5C}, {0x00, 0x5D},
> -					       {0x44, 0x5E}, {0x00, 0x5F},
> -					       {0xC7, 0x60}, {0x01, 0x61},
> -					       {0xC7, 0x62}, {0x01, 0x63},
> -					       {0xC7, 0x64}, {0x01, 0x65},
> -					       {0x44, 0x66}, {0x00, 0x67},
> -					       {0x44, 0x68}, {0x00, 0x69},
> -					       {0x44, 0x6A}, {0x00, 0x6B},
> -					       {0xC7, 0x6C}, {0x01, 0x6D},
> -					       {0xC7, 0x6E}, {0x01, 0x6F},
> -					       {0xC7, 0x70}, {0x01, 0x71},
> -					       {0x44, 0x72}, {0x00, 0x73},
> -					       {0x44, 0x74}, {0x00, 0x75},
> -					       {0x44, 0x76}, {0x00, 0x77},
> -					       {0xC7, 0x78}, {0x01, 0x79},
> -					       {0xC7, 0x7A}, {0x01, 0x7B},
> -					       {0xC7, 0x7C}, {0x01, 0x7D},
> -					       {0x44, 0x7E}, {0x00, 0x7F},
> -					       {0x14, 0x84}, {0x00, 0x85},
> -					       {0x27, 0x86}, {0x00, 0x87},
> -					       {0x07, 0x88}, {0x00, 0x89},
> -					       {0xEC, 0x8A}, {0x0f, 0x8B},
> -					       {0xD8, 0x8C}, {0x0f, 0x8D},
> -					       {0x3D, 0x8E}, {0x00, 0x8F},
> -					       {0x3D, 0x90}, {0x00, 0x91},
> -					       {0xCD, 0x92}, {0x0f, 0x93},
> -					       {0xf7, 0x94}, {0x0f, 0x95},
> -					       {0x0C, 0x96}, {0x00, 0x97},
> -					       {0x00, 0x98}, {0x66, 0x99},
> -					       {0x05, 0x9A}, {0x00, 0x9B},
> -					       {0x04, 0x9C}, {0x00, 0x9D},
> -					       {0x08, 0x9E}, {0x00, 0x9F},
> -					       {0x2D, 0xC0}, {0x2D, 0xC1},
> -					       {0x3A, 0xC2}, {0x05, 0xC3},
> -					       {0x04, 0xC4}, {0x3F, 0xC5},
> -					       {0x00, 0xC6}, {0x00, 0xC7},
> -					       {0x50, 0xC8}, {0x3C, 0xC9},
> -					       {0x28, 0xCA}, {0xD8, 0xCB},
> -					       {0x14, 0xCC}, {0xEC, 0xCD},
> -					       {0x32, 0xCE}, {0xDD, 0xCF},
> -					       {0x32, 0xD0}, {0xDD, 0xD1},
> -					       {0x6A, 0xD2}, {0x50, 0xD3},
> -					       {0x00, 0xD4}, {0x00, 0xD5},
> -					       {0x00, 0xD6});
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	err += sn9c102_i2c_write(cam, 0x20, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x21, 0xd6);
> -	err += sn9c102_i2c_write(cam, 0x25, 0x06);
> -
> -	return err;
> -}
> -
> -
> -static int hv7131r_get_ctrl(struct sn9c102_device *cam,
> -			    struct v4l2_control *ctrl)
> -{
> -	switch (ctrl->id) {
> -	case V4L2_CID_GAIN:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x30);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		return 0;
> -	case V4L2_CID_RED_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x31);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = ctrl->value & 0x3f;
> -		return 0;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x33);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = ctrl->value & 0x3f;
> -		return 0;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x32);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = ctrl->value & 0x3f;
> -		return 0;
> -	case V4L2_CID_BLACK_LEVEL:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x01);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = (ctrl->value & 0x08) ? 1 : 0;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -
> -static int hv7131r_set_ctrl(struct sn9c102_device *cam,
> -			    const struct v4l2_control *ctrl)
> -{
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_write(cam, 0x30, ctrl->value);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x31, ctrl->value);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x33, ctrl->value);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x32, ctrl->value);
> -		break;
> -	case V4L2_CID_BLACK_LEVEL:
> -		{
> -			int r = sn9c102_i2c_read(cam, 0x01);
> -
> -			if (r < 0)
> -				return -EIO;
> -			err += sn9c102_i2c_write(cam, 0x01,
> -						 (ctrl->value<<3) | (r&0xf7));
> -		}
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int hv7131r_set_crop(struct sn9c102_device *cam,
> -			    const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 1,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -
> -static int hv7131r_set_pix_format(struct sn9c102_device *cam,
> -				  const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C103:
> -		if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8) {
> -			err += sn9c102_write_reg(cam, 0xa0, 0x19);
> -			err += sn9c102_i2c_write(cam, 0x01, 0x04);
> -		} else {
> -			err += sn9c102_write_reg(cam, 0x30, 0x19);
> -			err += sn9c102_i2c_write(cam, 0x01, 0x04);
> -		}
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8) {
> -			err += sn9c102_write_reg(cam, 0xa5, 0x17);
> -			err += sn9c102_i2c_write(cam, 0x01, 0x24);
> -		} else {
> -			err += sn9c102_write_reg(cam, 0xa3, 0x17);
> -			err += sn9c102_i2c_write(cam, 0x01, 0x04);
> -		}
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor hv7131r = {
> -	.name = "HV7131R",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C103 | BRIDGE_SN9C105 | BRIDGE_SN9C120,
> -	.sysfs_ops = SN9C102_I2C_READ | SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x11,
> -	.init = &hv7131r_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = 0xff,
> -			.step = 0x01,
> -			.default_value = 0x40,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_RED_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "red balance",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x08,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLUE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "blue balance",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x1a,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GREEN_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "green balance",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x2f,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLACK_LEVEL,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "auto black level compensation",
> -			.minimum = 0x00,
> -			.maximum = 0x01,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &hv7131r_get_ctrl,
> -	.set_ctrl = &hv7131r_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &hv7131r_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &hv7131r_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_hv7131r(struct sn9c102_device *cam)
> -{
> -	int devid, err;
> -
> -	err = sn9c102_write_const_regs(cam, {0x09, 0x01}, {0x44, 0x02},
> -				       {0x34, 0x01}, {0x20, 0x17},
> -				       {0x34, 0x01}, {0x46, 0x01});
> -
> -	devid = sn9c102_i2c_try_read(cam, &hv7131r, 0x00);
> -	if (err || devid < 0)
> -		return -EIO;
> -
> -	if (devid != 0x02)
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &hv7131r);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_mi0343.c b/drivers/staging/media/sn9c102/sn9c102_mi0343.c
> deleted file mode 100644
> index b20fdb6..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_mi0343.c
> +++ /dev/null
> @@ -1,352 +0,0 @@
> -/***************************************************************************
> - * Plug-in for MI-0343 image sensor connected to the SN9C1xx PC Camera     *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2004-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int mi0343_init(struct sn9c102_device *cam)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -
> -	err = sn9c102_write_const_regs(cam, {0x00, 0x10}, {0x00, 0x11},
> -				       {0x0a, 0x14}, {0x40, 0x01},
> -				       {0x20, 0x17}, {0x07, 0x18},
> -				       {0xa0, 0x19});
> -
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x0d,
> -					 0x00, 0x01, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x0d,
> -					 0x00, 0x00, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x03,
> -					 0x01, 0xe1, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x04,
> -					 0x02, 0x81, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x05,
> -					 0x00, 0x17, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x06,
> -					 0x00, 0x11, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x62,
> -					 0x04, 0x9a, 0, 0);
> -
> -	return err;
> -}
> -
> -
> -static int mi0343_get_ctrl(struct sn9c102_device *cam,
> -			   struct v4l2_control *ctrl)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	u8 data[2];
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x09, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[0];
> -		return 0;
> -	case V4L2_CID_GAIN:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x35, 2,
> -					     data) < 0)
> -			return -EIO;
> -		break;
> -	case V4L2_CID_HFLIP:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x20, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1] & 0x20 ? 1 : 0;
> -		return 0;
> -	case V4L2_CID_VFLIP:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x20, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1] & 0x80 ? 1 : 0;
> -		return 0;
> -	case V4L2_CID_RED_BALANCE:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x2d, 2,
> -					     data) < 0)
> -			return -EIO;
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x2c, 2,
> -					     data) < 0)
> -			return -EIO;
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x2e, 2,
> -					     data) < 0)
> -			return -EIO;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_GAIN:
> -	case V4L2_CID_RED_BALANCE:
> -	case V4L2_CID_BLUE_BALANCE:
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		ctrl->value = data[1] | (data[0] << 8);
> -		if (ctrl->value >= 0x10 && ctrl->value <= 0x3f)
> -			ctrl->value -= 0x10;
> -		else if (ctrl->value >= 0x60 && ctrl->value <= 0x7f)
> -			ctrl->value -= 0x60;
> -		else if (ctrl->value >= 0xe0 && ctrl->value <= 0xff)
> -			ctrl->value -= 0xe0;
> -	}
> -
> -	return 0;
> -}
> -
> -
> -static int mi0343_set_ctrl(struct sn9c102_device *cam,
> -			   const struct v4l2_control *ctrl)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	u16 reg = 0;
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_GAIN:
> -	case V4L2_CID_RED_BALANCE:
> -	case V4L2_CID_BLUE_BALANCE:
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		if (ctrl->value <= (0x3f-0x10))
> -			reg = 0x10 + ctrl->value;
> -		else if (ctrl->value <= ((0x3f-0x10) + (0x7f-0x60)))
> -			reg = 0x60 + (ctrl->value - (0x3f-0x10));
> -		else
> -			reg = 0xe0 + (ctrl->value - (0x3f-0x10) - (0x7f-0x60));
> -		break;
> -	}
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x09, ctrl->value, 0x00,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x35, reg >> 8, reg & 0xff,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_HFLIP:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x20, ctrl->value ? 0x40:0x00,
> -						 ctrl->value ? 0x20:0x00,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_VFLIP:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x20, ctrl->value ? 0x80:0x00,
> -						 ctrl->value ? 0x80:0x00,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x2d, reg >> 8, reg & 0xff,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x2c, reg >> 8, reg & 0xff,
> -						 0, 0);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x2b, reg >> 8, reg & 0xff,
> -						 0, 0);
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x2e, reg >> 8, reg & 0xff,
> -						 0, 0);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int mi0343_set_crop(struct sn9c102_device *cam,
> -			    const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 0,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 2;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -
> -static int mi0343_set_pix_format(struct sn9c102_device *cam,
> -				 const struct v4l2_pix_format *pix)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X) {
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x0a, 0x00, 0x03, 0, 0);
> -		err += sn9c102_write_reg(cam, 0x20, 0x19);
> -	} else {
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x0a, 0x00, 0x05, 0, 0);
> -		err += sn9c102_write_reg(cam, 0xa0, 0x19);
> -	}
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor mi0343 = {
> -	.name = "MI-0343",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C101 | BRIDGE_SN9C102,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x5d,
> -	.init = &mi0343_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_EXPOSURE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "exposure",
> -			.minimum = 0x00,
> -			.maximum = 0x0f,
> -			.step = 0x01,
> -			.default_value = 0x06,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = (0x3f-0x10)+(0x7f-0x60)+(0xff-0xe0),/*0x6d*/
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_HFLIP,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "horizontal mirror",
> -			.minimum = 0,
> -			.maximum = 1,
> -			.step = 1,
> -			.default_value = 0,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_VFLIP,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "vertical mirror",
> -			.minimum = 0,
> -			.maximum = 1,
> -			.step = 1,
> -			.default_value = 0,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_RED_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "red balance",
> -			.minimum = 0x00,
> -			.maximum = (0x3f-0x10)+(0x7f-0x60)+(0xff-0xe0),
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLUE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "blue balance",
> -			.minimum = 0x00,
> -			.maximum = (0x3f-0x10)+(0x7f-0x60)+(0xff-0xe0),
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GREEN_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "green balance",
> -			.minimum = 0x00,
> -			.maximum = ((0x3f-0x10)+(0x7f-0x60)+(0xff-0xe0)),
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &mi0343_get_ctrl,
> -	.set_ctrl = &mi0343_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &mi0343_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &mi0343_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_mi0343(struct sn9c102_device *cam)
> -{
> -	u8 data[2];
> -
> -	if (sn9c102_write_const_regs(cam, {0x01, 0x01}, {0x00, 0x01},
> -				     {0x28, 0x17}))
> -		return -EIO;
> -
> -	if (sn9c102_i2c_try_raw_read(cam, &mi0343, mi0343.i2c_slave_id, 0x00,
> -				     2, data) < 0)
> -		return -EIO;
> -
> -	if (data[1] != 0x42 || data[0] != 0xe3)
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &mi0343);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_mi0360.c b/drivers/staging/media/sn9c102/sn9c102_mi0360.c
> deleted file mode 100644
> index 5f21d1b..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_mi0360.c
> +++ /dev/null
> @@ -1,453 +0,0 @@
> -/***************************************************************************
> - * Plug-in for MI-0360 image sensor connected to the SN9C1xx PC Camera     *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2007 by Luca Risolia <luca.risolia@studio.unibo.it>       *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int mi0360_init(struct sn9c102_device *cam)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C103:
> -		err = sn9c102_write_const_regs(cam, {0x00, 0x10}, {0x00, 0x11},
> -					       {0x0a, 0x14}, {0x40, 0x01},
> -					       {0x20, 0x17}, {0x07, 0x18},
> -					       {0xa0, 0x19}, {0x02, 0x1c},
> -					       {0x03, 0x1d}, {0x0f, 0x1e},
> -					       {0x0c, 0x1f}, {0x00, 0x20},
> -					       {0x10, 0x21}, {0x20, 0x22},
> -					       {0x30, 0x23}, {0x40, 0x24},
> -					       {0x50, 0x25}, {0x60, 0x26},
> -					       {0x70, 0x27}, {0x80, 0x28},
> -					       {0x90, 0x29}, {0xa0, 0x2a},
> -					       {0xb0, 0x2b}, {0xc0, 0x2c},
> -					       {0xd0, 0x2d}, {0xe0, 0x2e},
> -					       {0xf0, 0x2f}, {0xff, 0x30});
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		err = sn9c102_write_const_regs(cam, {0x44, 0x01}, {0x40, 0x02},
> -					       {0x00, 0x03}, {0x1a, 0x04},
> -					       {0x50, 0x05}, {0x20, 0x06},
> -					       {0x10, 0x07}, {0x03, 0x10},
> -					       {0x08, 0x14}, {0xa2, 0x17},
> -					       {0x47, 0x18}, {0x00, 0x19},
> -					       {0x1d, 0x1a}, {0x10, 0x1b},
> -					       {0x02, 0x1c}, {0x03, 0x1d},
> -					       {0x0f, 0x1e}, {0x0c, 0x1f},
> -					       {0x00, 0x20}, {0x29, 0x21},
> -					       {0x40, 0x22}, {0x54, 0x23},
> -					       {0x66, 0x24}, {0x76, 0x25},
> -					       {0x85, 0x26}, {0x94, 0x27},
> -					       {0xa1, 0x28}, {0xae, 0x29},
> -					       {0xbb, 0x2a}, {0xc7, 0x2b},
> -					       {0xd3, 0x2c}, {0xde, 0x2d},
> -					       {0xea, 0x2e}, {0xf4, 0x2f},
> -					       {0xff, 0x30}, {0x00, 0x3F},
> -					       {0xC7, 0x40}, {0x01, 0x41},
> -					       {0x44, 0x42}, {0x00, 0x43},
> -					       {0x44, 0x44}, {0x00, 0x45},
> -					       {0x44, 0x46}, {0x00, 0x47},
> -					       {0xC7, 0x48}, {0x01, 0x49},
> -					       {0xC7, 0x4A}, {0x01, 0x4B},
> -					       {0xC7, 0x4C}, {0x01, 0x4D},
> -					       {0x44, 0x4E}, {0x00, 0x4F},
> -					       {0x44, 0x50}, {0x00, 0x51},
> -					       {0x44, 0x52}, {0x00, 0x53},
> -					       {0xC7, 0x54}, {0x01, 0x55},
> -					       {0xC7, 0x56}, {0x01, 0x57},
> -					       {0xC7, 0x58}, {0x01, 0x59},
> -					       {0x44, 0x5A}, {0x00, 0x5B},
> -					       {0x44, 0x5C}, {0x00, 0x5D},
> -					       {0x44, 0x5E}, {0x00, 0x5F},
> -					       {0xC7, 0x60}, {0x01, 0x61},
> -					       {0xC7, 0x62}, {0x01, 0x63},
> -					       {0xC7, 0x64}, {0x01, 0x65},
> -					       {0x44, 0x66}, {0x00, 0x67},
> -					       {0x44, 0x68}, {0x00, 0x69},
> -					       {0x44, 0x6A}, {0x00, 0x6B},
> -					       {0xC7, 0x6C}, {0x01, 0x6D},
> -					       {0xC7, 0x6E}, {0x01, 0x6F},
> -					       {0xC7, 0x70}, {0x01, 0x71},
> -					       {0x44, 0x72}, {0x00, 0x73},
> -					       {0x44, 0x74}, {0x00, 0x75},
> -					       {0x44, 0x76}, {0x00, 0x77},
> -					       {0xC7, 0x78}, {0x01, 0x79},
> -					       {0xC7, 0x7A}, {0x01, 0x7B},
> -					       {0xC7, 0x7C}, {0x01, 0x7D},
> -					       {0x44, 0x7E}, {0x00, 0x7F},
> -					       {0x14, 0x84}, {0x00, 0x85},
> -					       {0x27, 0x86}, {0x00, 0x87},
> -					       {0x07, 0x88}, {0x00, 0x89},
> -					       {0xEC, 0x8A}, {0x0f, 0x8B},
> -					       {0xD8, 0x8C}, {0x0f, 0x8D},
> -					       {0x3D, 0x8E}, {0x00, 0x8F},
> -					       {0x3D, 0x90}, {0x00, 0x91},
> -					       {0xCD, 0x92}, {0x0f, 0x93},
> -					       {0xf7, 0x94}, {0x0f, 0x95},
> -					       {0x0C, 0x96}, {0x00, 0x97},
> -					       {0x00, 0x98}, {0x66, 0x99},
> -					       {0x05, 0x9A}, {0x00, 0x9B},
> -					       {0x04, 0x9C}, {0x00, 0x9D},
> -					       {0x08, 0x9E}, {0x00, 0x9F},
> -					       {0x2D, 0xC0}, {0x2D, 0xC1},
> -					       {0x3A, 0xC2}, {0x05, 0xC3},
> -					       {0x04, 0xC4}, {0x3F, 0xC5},
> -					       {0x00, 0xC6}, {0x00, 0xC7},
> -					       {0x50, 0xC8}, {0x3C, 0xC9},
> -					       {0x28, 0xCA}, {0xD8, 0xCB},
> -					       {0x14, 0xCC}, {0xEC, 0xCD},
> -					       {0x32, 0xCE}, {0xDD, 0xCF},
> -					       {0x32, 0xD0}, {0xDD, 0xD1},
> -					       {0x6A, 0xD2}, {0x50, 0xD3},
> -					       {0x00, 0xD4}, {0x00, 0xD5},
> -					       {0x00, 0xD6});
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x0d,
> -					 0x00, 0x01, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x0d,
> -					 0x00, 0x00, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x03,
> -					 0x01, 0xe1, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x04,
> -					 0x02, 0x81, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x05,
> -					 0x00, 0x17, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x06,
> -					 0x00, 0x11, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x62,
> -					 0x04, 0x9a, 0, 0);
> -
> -	return err;
> -}
> -
> -
> -static int mi0360_get_ctrl(struct sn9c102_device *cam,
> -			   struct v4l2_control *ctrl)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	u8 data[2];
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x09, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[0];
> -		return 0;
> -	case V4L2_CID_GAIN:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x35, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1];
> -		return 0;
> -	case V4L2_CID_RED_BALANCE:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x2c, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1];
> -		return 0;
> -	case V4L2_CID_BLUE_BALANCE:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x2d, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1];
> -		return 0;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x2e, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1];
> -		return 0;
> -	case V4L2_CID_HFLIP:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x20, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1] & 0x20 ? 1 : 0;
> -		return 0;
> -	case V4L2_CID_VFLIP:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x20, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1] & 0x80 ? 1 : 0;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -
> -static int mi0360_set_ctrl(struct sn9c102_device *cam,
> -			   const struct v4l2_control *ctrl)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x09, ctrl->value, 0x00,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x35, 0x03, ctrl->value,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x2c, 0x03, ctrl->value,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x2d, 0x03, ctrl->value,
> -						 0, 0);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x2b, 0x03, ctrl->value,
> -						 0, 0);
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x2e, 0x03, ctrl->value,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_HFLIP:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x20, ctrl->value ? 0x40:0x00,
> -						 ctrl->value ? 0x20:0x00,
> -						 0, 0);
> -		break;
> -	case V4L2_CID_VFLIP:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x20, ctrl->value ? 0x80:0x00,
> -						 ctrl->value ? 0x80:0x00,
> -						 0, 0);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int mi0360_set_crop(struct sn9c102_device *cam,
> -			    const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = 0, v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C103:
> -		h_start = (u8)(rect->left - s->cropcap.bounds.left) + 0;
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		h_start = (u8)(rect->left - s->cropcap.bounds.left) + 1;
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -
> -static int mi0360_set_pix_format(struct sn9c102_device *cam,
> -				 const struct v4l2_pix_format *pix)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8) {
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x0a, 0x00, 0x05, 0, 0);
> -		err += sn9c102_write_reg(cam, 0x60, 0x19);
> -		if (sn9c102_get_bridge(cam) == BRIDGE_SN9C105 ||
> -		    sn9c102_get_bridge(cam) == BRIDGE_SN9C120)
> -			err += sn9c102_write_reg(cam, 0xa6, 0x17);
> -	} else {
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x0a, 0x00, 0x02, 0, 0);
> -		err += sn9c102_write_reg(cam, 0x20, 0x19);
> -		if (sn9c102_get_bridge(cam) == BRIDGE_SN9C105 ||
> -		    sn9c102_get_bridge(cam) == BRIDGE_SN9C120)
> -			err += sn9c102_write_reg(cam, 0xa2, 0x17);
> -	}
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor mi0360 = {
> -	.name = "MI-0360",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C103 | BRIDGE_SN9C105 | BRIDGE_SN9C120,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x5d,
> -	.init = &mi0360_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_EXPOSURE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "exposure",
> -			.minimum = 0x00,
> -			.maximum = 0x0f,
> -			.step = 0x01,
> -			.default_value = 0x05,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x25,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_HFLIP,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "horizontal mirror",
> -			.minimum = 0,
> -			.maximum = 1,
> -			.step = 1,
> -			.default_value = 0,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_VFLIP,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "vertical mirror",
> -			.minimum = 0,
> -			.maximum = 1,
> -			.step = 1,
> -			.default_value = 0,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLUE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "blue balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x0f,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_RED_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "red balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x32,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GREEN_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "green balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x25,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &mi0360_get_ctrl,
> -	.set_ctrl = &mi0360_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &mi0360_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &mi0360_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_mi0360(struct sn9c102_device *cam)
> -{
> -
> -	u8 data[2];
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C103:
> -		if (sn9c102_write_const_regs(cam, {0x01, 0x01}, {0x00, 0x01},
> -					     {0x28, 0x17}))
> -			return -EIO;
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		if (sn9c102_write_const_regs(cam, {0x01, 0xf1}, {0x00, 0xf1},
> -					     {0x01, 0x01}, {0x00, 0x01},
> -					     {0x28, 0x17}))
> -			return -EIO;
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	if (sn9c102_i2c_try_raw_read(cam, &mi0360, mi0360.i2c_slave_id, 0x00,
> -				     2, data) < 0)
> -		return -EIO;
> -
> -	if (data[0] != 0x82 || data[1] != 0x43)
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &mi0360);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_mt9v111.c b/drivers/staging/media/sn9c102/sn9c102_mt9v111.c
> deleted file mode 100644
> index 95986eb..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_mt9v111.c
> +++ /dev/null
> @@ -1,260 +0,0 @@
> -/***************************************************************************
> - * Plug-in for MT9V111 image sensor connected to the SN9C1xx PC Camera     *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2007 by Luca Risolia <luca.risolia@studio.unibo.it>       *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int mt9v111_init(struct sn9c102_device *cam)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -
> -	err = sn9c102_write_const_regs(cam, {0x44, 0x01}, {0x40, 0x02},
> -				       {0x00, 0x03}, {0x1a, 0x04},
> -				       {0x1f, 0x05}, {0x20, 0x06},
> -				       {0x1f, 0x07}, {0x81, 0x08},
> -				       {0x5c, 0x09}, {0x00, 0x0a},
> -				       {0x00, 0x0b}, {0x00, 0x0c},
> -				       {0x00, 0x0d}, {0x00, 0x0e},
> -				       {0x00, 0x0f}, {0x03, 0x10},
> -				       {0x00, 0x11}, {0x00, 0x12},
> -				       {0x02, 0x13}, {0x14, 0x14},
> -				       {0x28, 0x15}, {0x1e, 0x16},
> -				       {0xe2, 0x17}, {0x06, 0x18},
> -				       {0x00, 0x19}, {0x00, 0x1a},
> -				       {0x00, 0x1b}, {0x08, 0x20},
> -				       {0x39, 0x21}, {0x51, 0x22},
> -				       {0x63, 0x23}, {0x73, 0x24},
> -				       {0x82, 0x25}, {0x8f, 0x26},
> -				       {0x9b, 0x27}, {0xa7, 0x28},
> -				       {0xb1, 0x29}, {0xbc, 0x2a},
> -				       {0xc6, 0x2b}, {0xcf, 0x2c},
> -				       {0xd8, 0x2d}, {0xe1, 0x2e},
> -				       {0xea, 0x2f}, {0xf2, 0x30},
> -				       {0x13, 0x84}, {0x00, 0x85},
> -				       {0x25, 0x86}, {0x00, 0x87},
> -				       {0x07, 0x88}, {0x00, 0x89},
> -				       {0xee, 0x8a}, {0x0f, 0x8b},
> -				       {0xe5, 0x8c}, {0x0f, 0x8d},
> -				       {0x2e, 0x8e}, {0x00, 0x8f},
> -				       {0x30, 0x90}, {0x00, 0x91},
> -				       {0xd4, 0x92}, {0x0f, 0x93},
> -				       {0xfc, 0x94}, {0x0f, 0x95},
> -				       {0x14, 0x96}, {0x00, 0x97},
> -				       {0x00, 0x98}, {0x60, 0x99},
> -				       {0x07, 0x9a}, {0x40, 0x9b},
> -				       {0x20, 0x9c}, {0x00, 0x9d},
> -				       {0x00, 0x9e}, {0x00, 0x9f},
> -				       {0x2d, 0xc0}, {0x2d, 0xc1},
> -				       {0x3a, 0xc2}, {0x05, 0xc3},
> -				       {0x04, 0xc4}, {0x3f, 0xc5},
> -				       {0x00, 0xc6}, {0x00, 0xc7},
> -				       {0x50, 0xc8}, {0x3c, 0xc9},
> -				       {0x28, 0xca}, {0xd8, 0xcb},
> -				       {0x14, 0xcc}, {0xec, 0xcd},
> -				       {0x32, 0xce}, {0xdd, 0xcf},
> -				       {0x2d, 0xd0}, {0xdd, 0xd1},
> -				       {0x6a, 0xd2}, {0x50, 0xd3},
> -				       {0x60, 0xd4}, {0x00, 0xd5},
> -				       {0x00, 0xd6});
> -
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x01,
> -					 0x00, 0x01, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x0d,
> -					 0x00, 0x01, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x0d,
> -					 0x00, 0x00, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x08,
> -					 0x04, 0x80, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x01,
> -					 0x00, 0x04, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x08,
> -					 0x00, 0x08, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x02,
> -					 0x00, 0x16, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x03,
> -					 0x01, 0xe7, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x04,
> -					 0x02, 0x87, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x06,
> -					 0x00, 0x40, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x05,
> -					 0x00, 0x09, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x07,
> -					 0x30, 0x02, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x0c,
> -					 0x00, 0x00, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x12,
> -					 0x00, 0xb0, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x13,
> -					 0x00, 0x7c, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x1e,
> -					 0x00, 0x00, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x20,
> -					 0x00, 0x00, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x20,
> -					 0x00, 0x00, 0, 0);
> -	err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id, 0x01,
> -					 0x00, 0x04, 0, 0);
> -
> -	return err;
> -}
> -
> -static int mt9v111_get_ctrl(struct sn9c102_device *cam,
> -			    struct v4l2_control *ctrl)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	u8 data[2];
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_VFLIP:
> -		if (sn9c102_i2c_try_raw_read(cam, s, s->i2c_slave_id, 0x20, 2,
> -					     data) < 0)
> -			return -EIO;
> -		ctrl->value = data[1] & 0x80 ? 1 : 0;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -static int mt9v111_set_ctrl(struct sn9c102_device *cam,
> -			    const struct v4l2_control *ctrl)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_VFLIP:
> -		err += sn9c102_i2c_try_raw_write(cam, s, 4, s->i2c_slave_id,
> -						 0x20,
> -						 ctrl->value ? 0x80 : 0x00,
> -						 ctrl->value ? 0x80 : 0x00, 0,
> -						 0);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -static int mt9v111_set_crop(struct sn9c102_device *cam,
> -			    const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 v_start = (u8) (rect->top - s->cropcap.bounds.top) + 2;
> -
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -static int mt9v111_set_pix_format(struct sn9c102_device *cam,
> -				  const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8) {
> -		err += sn9c102_write_reg(cam, 0xb4, 0x17);
> -	} else {
> -		err += sn9c102_write_reg(cam, 0xe2, 0x17);
> -	}
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor mt9v111 = {
> -	.name = "MT9V111",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C105 | BRIDGE_SN9C120,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x5c,
> -	.init = &mt9v111_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_VFLIP,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "vertical mirror",
> -			.minimum = 0,
> -			.maximum = 1,
> -			.step = 1,
> -			.default_value = 0,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &mt9v111_get_ctrl,
> -	.set_ctrl = &mt9v111_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &mt9v111_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &mt9v111_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_mt9v111(struct sn9c102_device *cam)
> -{
> -	u8 data[2];
> -	int err = 0;
> -
> -	err += sn9c102_write_const_regs(cam, {0x01, 0xf1}, {0x00, 0xf1},
> -					{0x29, 0x01}, {0x42, 0x17},
> -					{0x62, 0x17}, {0x08, 0x01});
> -	err += sn9c102_i2c_try_raw_write(cam, &mt9v111, 4,
> -					 mt9v111.i2c_slave_id, 0x01, 0x00,
> -					 0x04, 0, 0);
> -	if (err || sn9c102_i2c_try_raw_read(cam, &mt9v111,
> -					    mt9v111.i2c_slave_id, 0x36, 2,
> -					    data) < 0)
> -		return -EIO;
> -
> -	if (data[0] != 0x82 || data[1] != 0x3a)
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &mt9v111);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_ov7630.c b/drivers/staging/media/sn9c102/sn9c102_ov7630.c
> deleted file mode 100644
> index 9ec304d..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_ov7630.c
> +++ /dev/null
> @@ -1,634 +0,0 @@
> -/***************************************************************************
> - * Plug-in for OV7630 image sensor connected to the SN9C1xx PC Camera      *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2006-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int ov7630_init(struct sn9c102_device *cam)
> -{
> -	int err = 0;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -		err = sn9c102_write_const_regs(cam, {0x00, 0x14}, {0x60, 0x17},
> -					       {0x0f, 0x18}, {0x50, 0x19});
> -
> -		err += sn9c102_i2c_write(cam, 0x12, 0x8d);
> -		err += sn9c102_i2c_write(cam, 0x12, 0x0d);
> -		err += sn9c102_i2c_write(cam, 0x11, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x15, 0x35);
> -		err += sn9c102_i2c_write(cam, 0x16, 0x03);
> -		err += sn9c102_i2c_write(cam, 0x17, 0x1c);
> -		err += sn9c102_i2c_write(cam, 0x18, 0xbd);
> -		err += sn9c102_i2c_write(cam, 0x19, 0x06);
> -		err += sn9c102_i2c_write(cam, 0x1a, 0xf6);
> -		err += sn9c102_i2c_write(cam, 0x1b, 0x04);
> -		err += sn9c102_i2c_write(cam, 0x20, 0x44);
> -		err += sn9c102_i2c_write(cam, 0x23, 0xee);
> -		err += sn9c102_i2c_write(cam, 0x26, 0xa0);
> -		err += sn9c102_i2c_write(cam, 0x27, 0x9a);
> -		err += sn9c102_i2c_write(cam, 0x28, 0x20);
> -		err += sn9c102_i2c_write(cam, 0x29, 0x30);
> -		err += sn9c102_i2c_write(cam, 0x2f, 0x3d);
> -		err += sn9c102_i2c_write(cam, 0x30, 0x24);
> -		err += sn9c102_i2c_write(cam, 0x32, 0x86);
> -		err += sn9c102_i2c_write(cam, 0x60, 0xa9);
> -		err += sn9c102_i2c_write(cam, 0x61, 0x42);
> -		err += sn9c102_i2c_write(cam, 0x65, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x69, 0x38);
> -		err += sn9c102_i2c_write(cam, 0x6f, 0x88);
> -		err += sn9c102_i2c_write(cam, 0x70, 0x0b);
> -		err += sn9c102_i2c_write(cam, 0x71, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x74, 0x21);
> -		err += sn9c102_i2c_write(cam, 0x7d, 0xf7);
> -		break;
> -	case BRIDGE_SN9C103:
> -		err = sn9c102_write_const_regs(cam, {0x00, 0x02}, {0x00, 0x03},
> -					       {0x1a, 0x04}, {0x20, 0x05},
> -					       {0x20, 0x06}, {0x20, 0x07},
> -					       {0x03, 0x10}, {0x0a, 0x14},
> -					       {0x60, 0x17}, {0x0f, 0x18},
> -					       {0x50, 0x19}, {0x1d, 0x1a},
> -					       {0x10, 0x1b}, {0x02, 0x1c},
> -					       {0x03, 0x1d}, {0x0f, 0x1e},
> -					       {0x0c, 0x1f}, {0x00, 0x20},
> -					       {0x10, 0x21}, {0x20, 0x22},
> -					       {0x30, 0x23}, {0x40, 0x24},
> -					       {0x50, 0x25}, {0x60, 0x26},
> -					       {0x70, 0x27}, {0x80, 0x28},
> -					       {0x90, 0x29}, {0xa0, 0x2a},
> -					       {0xb0, 0x2b}, {0xc0, 0x2c},
> -					       {0xd0, 0x2d}, {0xe0, 0x2e},
> -					       {0xf0, 0x2f}, {0xff, 0x30});
> -
> -		err += sn9c102_i2c_write(cam, 0x12, 0x8d);
> -		err += sn9c102_i2c_write(cam, 0x12, 0x0d);
> -		err += sn9c102_i2c_write(cam, 0x15, 0x34);
> -		err += sn9c102_i2c_write(cam, 0x11, 0x01);
> -		err += sn9c102_i2c_write(cam, 0x1b, 0x04);
> -		err += sn9c102_i2c_write(cam, 0x20, 0x44);
> -		err += sn9c102_i2c_write(cam, 0x23, 0xee);
> -		err += sn9c102_i2c_write(cam, 0x26, 0xa0);
> -		err += sn9c102_i2c_write(cam, 0x27, 0x9a);
> -		err += sn9c102_i2c_write(cam, 0x28, 0x20);
> -		err += sn9c102_i2c_write(cam, 0x29, 0x30);
> -		err += sn9c102_i2c_write(cam, 0x2f, 0x3d);
> -		err += sn9c102_i2c_write(cam, 0x30, 0x24);
> -		err += sn9c102_i2c_write(cam, 0x32, 0x86);
> -		err += sn9c102_i2c_write(cam, 0x60, 0xa9);
> -		err += sn9c102_i2c_write(cam, 0x61, 0x42);
> -		err += sn9c102_i2c_write(cam, 0x65, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x69, 0x38);
> -		err += sn9c102_i2c_write(cam, 0x6f, 0x88);
> -		err += sn9c102_i2c_write(cam, 0x70, 0x0b);
> -		err += sn9c102_i2c_write(cam, 0x71, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x74, 0x21);
> -		err += sn9c102_i2c_write(cam, 0x7d, 0xf7);
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -	err = sn9c102_write_const_regs(cam, {0x40, 0x02}, {0x00, 0x03},
> -				       {0x1a, 0x04}, {0x03, 0x10},
> -				       {0x0a, 0x14}, {0xe2, 0x17},
> -				       {0x0b, 0x18}, {0x00, 0x19},
> -				       {0x1d, 0x1a}, {0x10, 0x1b},
> -				       {0x02, 0x1c}, {0x03, 0x1d},
> -				       {0x0f, 0x1e}, {0x0c, 0x1f},
> -				       {0x00, 0x20}, {0x24, 0x21},
> -				       {0x3b, 0x22}, {0x47, 0x23},
> -				       {0x60, 0x24}, {0x71, 0x25},
> -				       {0x80, 0x26}, {0x8f, 0x27},
> -				       {0x9d, 0x28}, {0xaa, 0x29},
> -				       {0xb8, 0x2a}, {0xc4, 0x2b},
> -				       {0xd1, 0x2c}, {0xdd, 0x2d},
> -				       {0xe8, 0x2e}, {0xf4, 0x2f},
> -				       {0xff, 0x30}, {0x00, 0x3f},
> -				       {0xc7, 0x40}, {0x01, 0x41},
> -				       {0x44, 0x42}, {0x00, 0x43},
> -				       {0x44, 0x44}, {0x00, 0x45},
> -				       {0x44, 0x46}, {0x00, 0x47},
> -				       {0xc7, 0x48}, {0x01, 0x49},
> -				       {0xc7, 0x4a}, {0x01, 0x4b},
> -				       {0xc7, 0x4c}, {0x01, 0x4d},
> -				       {0x44, 0x4e}, {0x00, 0x4f},
> -				       {0x44, 0x50}, {0x00, 0x51},
> -				       {0x44, 0x52}, {0x00, 0x53},
> -				       {0xc7, 0x54}, {0x01, 0x55},
> -				       {0xc7, 0x56}, {0x01, 0x57},
> -				       {0xc7, 0x58}, {0x01, 0x59},
> -				       {0x44, 0x5a}, {0x00, 0x5b},
> -				       {0x44, 0x5c}, {0x00, 0x5d},
> -				       {0x44, 0x5e}, {0x00, 0x5f},
> -				       {0xc7, 0x60}, {0x01, 0x61},
> -				       {0xc7, 0x62}, {0x01, 0x63},
> -				       {0xc7, 0x64}, {0x01, 0x65},
> -				       {0x44, 0x66}, {0x00, 0x67},
> -				       {0x44, 0x68}, {0x00, 0x69},
> -				       {0x44, 0x6a}, {0x00, 0x6b},
> -				       {0xc7, 0x6c}, {0x01, 0x6d},
> -				       {0xc7, 0x6e}, {0x01, 0x6f},
> -				       {0xc7, 0x70}, {0x01, 0x71},
> -				       {0x44, 0x72}, {0x00, 0x73},
> -				       {0x44, 0x74}, {0x00, 0x75},
> -				       {0x44, 0x76}, {0x00, 0x77},
> -				       {0xc7, 0x78}, {0x01, 0x79},
> -				       {0xc7, 0x7a}, {0x01, 0x7b},
> -				       {0xc7, 0x7c}, {0x01, 0x7d},
> -				       {0x44, 0x7e}, {0x00, 0x7f},
> -				       {0x17, 0x84}, {0x00, 0x85},
> -				       {0x2e, 0x86}, {0x00, 0x87},
> -				       {0x09, 0x88}, {0x00, 0x89},
> -				       {0xe8, 0x8a}, {0x0f, 0x8b},
> -				       {0xda, 0x8c}, {0x0f, 0x8d},
> -				       {0x40, 0x8e}, {0x00, 0x8f},
> -				       {0x37, 0x90}, {0x00, 0x91},
> -				       {0xcf, 0x92}, {0x0f, 0x93},
> -				       {0xfa, 0x94}, {0x0f, 0x95},
> -				       {0x00, 0x96}, {0x00, 0x97},
> -				       {0x00, 0x98}, {0x66, 0x99},
> -				       {0x00, 0x9a}, {0x40, 0x9b},
> -				       {0x20, 0x9c}, {0x00, 0x9d},
> -				       {0x00, 0x9e}, {0x00, 0x9f},
> -				       {0x2d, 0xc0}, {0x2d, 0xc1},
> -				       {0x3a, 0xc2}, {0x00, 0xc3},
> -				       {0x04, 0xc4}, {0x3f, 0xc5},
> -				       {0x00, 0xc6}, {0x00, 0xc7},
> -				       {0x50, 0xc8}, {0x3c, 0xc9},
> -				       {0x28, 0xca}, {0xd8, 0xcb},
> -				       {0x14, 0xcc}, {0xec, 0xcd},
> -				       {0x32, 0xce}, {0xdd, 0xcf},
> -				       {0x32, 0xd0}, {0xdd, 0xd1},
> -				       {0x6a, 0xd2}, {0x50, 0xd3},
> -				       {0x60, 0xd4}, {0x00, 0xd5},
> -				       {0x00, 0xd6});
> -
> -		err += sn9c102_i2c_write(cam, 0x12, 0x80);
> -		err += sn9c102_i2c_write(cam, 0x12, 0x48);
> -		err += sn9c102_i2c_write(cam, 0x01, 0x80);
> -		err += sn9c102_i2c_write(cam, 0x02, 0x80);
> -		err += sn9c102_i2c_write(cam, 0x03, 0x80);
> -		err += sn9c102_i2c_write(cam, 0x04, 0x10);
> -		err += sn9c102_i2c_write(cam, 0x05, 0x20);
> -		err += sn9c102_i2c_write(cam, 0x06, 0x80);
> -		err += sn9c102_i2c_write(cam, 0x11, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x0c, 0x20);
> -		err += sn9c102_i2c_write(cam, 0x0d, 0x20);
> -		err += sn9c102_i2c_write(cam, 0x15, 0x80);
> -		err += sn9c102_i2c_write(cam, 0x16, 0x03);
> -		err += sn9c102_i2c_write(cam, 0x17, 0x1b);
> -		err += sn9c102_i2c_write(cam, 0x18, 0xbd);
> -		err += sn9c102_i2c_write(cam, 0x19, 0x05);
> -		err += sn9c102_i2c_write(cam, 0x1a, 0xf6);
> -		err += sn9c102_i2c_write(cam, 0x1b, 0x04);
> -		err += sn9c102_i2c_write(cam, 0x21, 0x1b);
> -		err += sn9c102_i2c_write(cam, 0x22, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x23, 0xde);
> -		err += sn9c102_i2c_write(cam, 0x24, 0x10);
> -		err += sn9c102_i2c_write(cam, 0x25, 0x8a);
> -		err += sn9c102_i2c_write(cam, 0x26, 0xa0);
> -		err += sn9c102_i2c_write(cam, 0x27, 0xca);
> -		err += sn9c102_i2c_write(cam, 0x28, 0xa2);
> -		err += sn9c102_i2c_write(cam, 0x29, 0x74);
> -		err += sn9c102_i2c_write(cam, 0x2a, 0x88);
> -		err += sn9c102_i2c_write(cam, 0x2b, 0x34);
> -		err += sn9c102_i2c_write(cam, 0x2c, 0x88);
> -		err += sn9c102_i2c_write(cam, 0x2e, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x2f, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x30, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x32, 0xc2);
> -		err += sn9c102_i2c_write(cam, 0x33, 0x08);
> -		err += sn9c102_i2c_write(cam, 0x4c, 0x40);
> -		err += sn9c102_i2c_write(cam, 0x4d, 0xf3);
> -		err += sn9c102_i2c_write(cam, 0x60, 0x05);
> -		err += sn9c102_i2c_write(cam, 0x61, 0x40);
> -		err += sn9c102_i2c_write(cam, 0x62, 0x12);
> -		err += sn9c102_i2c_write(cam, 0x63, 0x57);
> -		err += sn9c102_i2c_write(cam, 0x64, 0x73);
> -		err += sn9c102_i2c_write(cam, 0x65, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x66, 0x55);
> -		err += sn9c102_i2c_write(cam, 0x67, 0x01);
> -		err += sn9c102_i2c_write(cam, 0x68, 0xac);
> -		err += sn9c102_i2c_write(cam, 0x69, 0x38);
> -		err += sn9c102_i2c_write(cam, 0x6f, 0x1f);
> -		err += sn9c102_i2c_write(cam, 0x70, 0x01);
> -		err += sn9c102_i2c_write(cam, 0x71, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x72, 0x10);
> -		err += sn9c102_i2c_write(cam, 0x73, 0x50);
> -		err += sn9c102_i2c_write(cam, 0x74, 0x20);
> -		err += sn9c102_i2c_write(cam, 0x76, 0x01);
> -		err += sn9c102_i2c_write(cam, 0x77, 0xf3);
> -		err += sn9c102_i2c_write(cam, 0x78, 0x90);
> -		err += sn9c102_i2c_write(cam, 0x79, 0x98);
> -		err += sn9c102_i2c_write(cam, 0x7a, 0x98);
> -		err += sn9c102_i2c_write(cam, 0x7b, 0x00);
> -		err += sn9c102_i2c_write(cam, 0x7c, 0x38);
> -		err += sn9c102_i2c_write(cam, 0x7d, 0xff);
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	return err;
> -}
> -
> -
> -static int ov7630_get_ctrl(struct sn9c102_device *cam,
> -			   struct v4l2_control *ctrl)
> -{
> -	enum sn9c102_bridge bridge = sn9c102_get_bridge(cam);
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x10);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		if (bridge == BRIDGE_SN9C105 || bridge == BRIDGE_SN9C120)
> -			ctrl->value = sn9c102_pread_reg(cam, 0x05);
> -		else
> -			ctrl->value = sn9c102_pread_reg(cam, 0x07);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ctrl->value = sn9c102_pread_reg(cam, 0x06);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		if (bridge == BRIDGE_SN9C105 || bridge == BRIDGE_SN9C120)
> -			ctrl->value = sn9c102_pread_reg(cam, 0x07);
> -		else
> -			ctrl->value = sn9c102_pread_reg(cam, 0x05);
> -		break;
> -		break;
> -	case V4L2_CID_GAIN:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x00);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x3f;
> -		break;
> -	case V4L2_CID_DO_WHITE_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x0c);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x3f;
> -		break;
> -	case V4L2_CID_WHITENESS:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x0d);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x3f;
> -		break;
> -	case V4L2_CID_AUTOGAIN:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x13);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x01;
> -		break;
> -	case V4L2_CID_VFLIP:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x75);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = (ctrl->value & 0x80) ? 1 : 0;
> -		break;
> -	case SN9C102_V4L2_CID_GAMMA:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x14);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = (ctrl->value & 0x02) ? 1 : 0;
> -		break;
> -	case SN9C102_V4L2_CID_BAND_FILTER:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x2d);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = (ctrl->value & 0x02) ? 1 : 0;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int ov7630_set_ctrl(struct sn9c102_device *cam,
> -			   const struct v4l2_control *ctrl)
> -{
> -	enum sn9c102_bridge bridge = sn9c102_get_bridge(cam);
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		err += sn9c102_i2c_write(cam, 0x10, ctrl->value);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		if (bridge == BRIDGE_SN9C105 || bridge == BRIDGE_SN9C120)
> -			err += sn9c102_write_reg(cam, ctrl->value, 0x05);
> -		else
> -			err += sn9c102_write_reg(cam, ctrl->value, 0x07);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		err += sn9c102_write_reg(cam, ctrl->value, 0x06);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		if (bridge == BRIDGE_SN9C105 || bridge == BRIDGE_SN9C120)
> -			err += sn9c102_write_reg(cam, ctrl->value, 0x07);
> -		else
> -			err += sn9c102_write_reg(cam, ctrl->value, 0x05);
> -		break;
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_write(cam, 0x00, ctrl->value);
> -		break;
> -	case V4L2_CID_DO_WHITE_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x0c, ctrl->value);
> -		break;
> -	case V4L2_CID_WHITENESS:
> -		err += sn9c102_i2c_write(cam, 0x0d, ctrl->value);
> -		break;
> -	case V4L2_CID_AUTOGAIN:
> -		err += sn9c102_i2c_write(cam, 0x13, ctrl->value |
> -						    (ctrl->value << 1));
> -		break;
> -	case V4L2_CID_VFLIP:
> -		err += sn9c102_i2c_write(cam, 0x75, 0x0e | (ctrl->value << 7));
> -		break;
> -	case SN9C102_V4L2_CID_GAMMA:
> -		err += sn9c102_i2c_write(cam, 0x14, ctrl->value << 2);
> -		break;
> -	case SN9C102_V4L2_CID_BAND_FILTER:
> -		err += sn9c102_i2c_write(cam, 0x2d, ctrl->value << 2);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int ov7630_set_crop(struct sn9c102_device *cam,
> -			   const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = 0, v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -	case BRIDGE_SN9C103:
> -		h_start = (u8)(rect->left - s->cropcap.bounds.left) + 1;
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		h_start = (u8)(rect->left - s->cropcap.bounds.left) + 4;
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -
> -static int ov7630_set_pix_format(struct sn9c102_device *cam,
> -				 const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -	case BRIDGE_SN9C103:
> -		if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8)
> -			err += sn9c102_write_reg(cam, 0x50, 0x19);
> -		else
> -			err += sn9c102_write_reg(cam, 0x20, 0x19);
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8) {
> -			err += sn9c102_write_reg(cam, 0xe5, 0x17);
> -			err += sn9c102_i2c_write(cam, 0x11, 0x04);
> -		} else {
> -			err += sn9c102_write_reg(cam, 0xe2, 0x17);
> -			err += sn9c102_i2c_write(cam, 0x11, 0x02);
> -		}
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor ov7630 = {
> -	.name = "OV7630",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C101 | BRIDGE_SN9C102 | BRIDGE_SN9C103 |
> -			    BRIDGE_SN9C105 | BRIDGE_SN9C120,
> -	.sysfs_ops = SN9C102_I2C_READ | SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x21,
> -	.init = &ov7630_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x14,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_EXPOSURE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "exposure",
> -			.minimum = 0x00,
> -			.maximum = 0xff,
> -			.step = 0x01,
> -			.default_value = 0x60,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_WHITENESS,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "white balance background: red",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x20,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_DO_WHITE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "white balance background: blue",
> -			.minimum = 0x00,
> -			.maximum = 0x3f,
> -			.step = 0x01,
> -			.default_value = 0x20,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_RED_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "red balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x20,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLUE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "blue balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x20,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_AUTOGAIN,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "auto adjust",
> -			.minimum = 0x00,
> -			.maximum = 0x01,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_VFLIP,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "vertical flip",
> -			.minimum = 0x00,
> -			.maximum = 0x01,
> -			.step = 0x01,
> -			.default_value = 0x01,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GREEN_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "green balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x20,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_BAND_FILTER,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "band filter",
> -			.minimum = 0x00,
> -			.maximum = 0x01,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GAMMA,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "rgb gamma",
> -			.minimum = 0x00,
> -			.maximum = 0x01,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &ov7630_get_ctrl,
> -	.set_ctrl = &ov7630_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &ov7630_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_SN9C10X,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &ov7630_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_ov7630(struct sn9c102_device *cam)
> -{
> -	int pid, ver, err = 0;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -		err = sn9c102_write_const_regs(cam, {0x01, 0x01}, {0x00, 0x01},
> -					       {0x28, 0x17});
> -		break;
> -	case BRIDGE_SN9C103: /* do _not_ change anything! */
> -		err = sn9c102_write_const_regs(cam, {0x09, 0x01}, {0x42, 0x01},
> -					       {0x28, 0x17}, {0x44, 0x02});
> -		pid = sn9c102_i2c_try_read(cam, &ov7630, 0x0a);
> -		if (err || pid < 0) /* try a different initialization */
> -			err += sn9c102_write_const_regs(cam, {0x01, 0x01},
> -							{0x00, 0x01});
> -		break;
> -	case BRIDGE_SN9C105:
> -	case BRIDGE_SN9C120:
> -		err = sn9c102_write_const_regs(cam, {0x01, 0xf1}, {0x00, 0xf1},
> -					       {0x29, 0x01}, {0x74, 0x02},
> -					       {0x0e, 0x01}, {0x44, 0x01});
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	pid = sn9c102_i2c_try_read(cam, &ov7630, 0x0a);
> -	ver = sn9c102_i2c_try_read(cam, &ov7630, 0x0b);
> -	if (err || pid < 0 || ver < 0)
> -		return -EIO;
> -	if (pid != 0x76 || ver != 0x31)
> -		return -ENODEV;
> -	sn9c102_attach_sensor(cam, &ov7630);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_ov7660.c b/drivers/staging/media/sn9c102/sn9c102_ov7660.c
> deleted file mode 100644
> index ac07805..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_ov7660.c
> +++ /dev/null
> @@ -1,546 +0,0 @@
> -/***************************************************************************
> - * Plug-in for OV7660 image sensor connected to the SN9C1xx PC Camera      *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2007 by Luca Risolia <luca.risolia@studio.unibo.it>       *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int ov7660_init(struct sn9c102_device *cam)
> -{
> -	int err = 0;
> -
> -	err = sn9c102_write_const_regs(cam, {0x40, 0x02}, {0x00, 0x03},
> -				       {0x1a, 0x04}, {0x03, 0x10},
> -				       {0x08, 0x14}, {0x20, 0x17},
> -				       {0x8b, 0x18}, {0x00, 0x19},
> -				       {0x1d, 0x1a}, {0x10, 0x1b},
> -				       {0x02, 0x1c}, {0x03, 0x1d},
> -				       {0x0f, 0x1e}, {0x0c, 0x1f},
> -				       {0x00, 0x20}, {0x29, 0x21},
> -				       {0x40, 0x22}, {0x54, 0x23},
> -				       {0x66, 0x24}, {0x76, 0x25},
> -				       {0x85, 0x26}, {0x94, 0x27},
> -				       {0xa1, 0x28}, {0xae, 0x29},
> -				       {0xbb, 0x2a}, {0xc7, 0x2b},
> -				       {0xd3, 0x2c}, {0xde, 0x2d},
> -				       {0xea, 0x2e}, {0xf4, 0x2f},
> -				       {0xff, 0x30}, {0x00, 0x3f},
> -				       {0xc7, 0x40}, {0x01, 0x41},
> -				       {0x44, 0x42}, {0x00, 0x43},
> -				       {0x44, 0x44}, {0x00, 0x45},
> -				       {0x44, 0x46}, {0x00, 0x47},
> -				       {0xc7, 0x48}, {0x01, 0x49},
> -				       {0xc7, 0x4a}, {0x01, 0x4b},
> -				       {0xc7, 0x4c}, {0x01, 0x4d},
> -				       {0x44, 0x4e}, {0x00, 0x4f},
> -				       {0x44, 0x50}, {0x00, 0x51},
> -				       {0x44, 0x52}, {0x00, 0x53},
> -				       {0xc7, 0x54}, {0x01, 0x55},
> -				       {0xc7, 0x56}, {0x01, 0x57},
> -				       {0xc7, 0x58}, {0x01, 0x59},
> -				       {0x44, 0x5a}, {0x00, 0x5b},
> -				       {0x44, 0x5c}, {0x00, 0x5d},
> -				       {0x44, 0x5e}, {0x00, 0x5f},
> -				       {0xc7, 0x60}, {0x01, 0x61},
> -				       {0xc7, 0x62}, {0x01, 0x63},
> -				       {0xc7, 0x64}, {0x01, 0x65},
> -				       {0x44, 0x66}, {0x00, 0x67},
> -				       {0x44, 0x68}, {0x00, 0x69},
> -				       {0x44, 0x6a}, {0x00, 0x6b},
> -				       {0xc7, 0x6c}, {0x01, 0x6d},
> -				       {0xc7, 0x6e}, {0x01, 0x6f},
> -				       {0xc7, 0x70}, {0x01, 0x71},
> -				       {0x44, 0x72}, {0x00, 0x73},
> -				       {0x44, 0x74}, {0x00, 0x75},
> -				       {0x44, 0x76}, {0x00, 0x77},
> -				       {0xc7, 0x78}, {0x01, 0x79},
> -				       {0xc7, 0x7a}, {0x01, 0x7b},
> -				       {0xc7, 0x7c}, {0x01, 0x7d},
> -				       {0x44, 0x7e}, {0x00, 0x7f},
> -				       {0x14, 0x84}, {0x00, 0x85},
> -				       {0x27, 0x86}, {0x00, 0x87},
> -				       {0x07, 0x88}, {0x00, 0x89},
> -				       {0xec, 0x8a}, {0x0f, 0x8b},
> -				       {0xd8, 0x8c}, {0x0f, 0x8d},
> -				       {0x3d, 0x8e}, {0x00, 0x8f},
> -				       {0x3d, 0x90}, {0x00, 0x91},
> -				       {0xcd, 0x92}, {0x0f, 0x93},
> -				       {0xf7, 0x94}, {0x0f, 0x95},
> -				       {0x0c, 0x96}, {0x00, 0x97},
> -				       {0x00, 0x98}, {0x66, 0x99},
> -				       {0x05, 0x9a}, {0x00, 0x9b},
> -				       {0x04, 0x9c}, {0x00, 0x9d},
> -				       {0x08, 0x9e}, {0x00, 0x9f},
> -				       {0x2d, 0xc0}, {0x2d, 0xc1},
> -				       {0x3a, 0xc2}, {0x05, 0xc3},
> -				       {0x04, 0xc4}, {0x3f, 0xc5},
> -				       {0x00, 0xc6}, {0x00, 0xc7},
> -				       {0x50, 0xc8}, {0x3C, 0xc9},
> -				       {0x28, 0xca}, {0xd8, 0xcb},
> -				       {0x14, 0xcc}, {0xec, 0xcd},
> -				       {0x32, 0xce}, {0xdd, 0xcf},
> -				       {0x32, 0xd0}, {0xdd, 0xd1},
> -				       {0x6a, 0xd2}, {0x50, 0xd3},
> -				       {0x00, 0xd4}, {0x00, 0xd5},
> -				       {0x00, 0xd6});
> -
> -	err += sn9c102_i2c_write(cam, 0x12, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x11, 0x09);
> -	err += sn9c102_i2c_write(cam, 0x00, 0x0A);
> -	err += sn9c102_i2c_write(cam, 0x01, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x02, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x03, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x04, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x05, 0x08);
> -	err += sn9c102_i2c_write(cam, 0x06, 0x0B);
> -	err += sn9c102_i2c_write(cam, 0x07, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x08, 0x1C);
> -	err += sn9c102_i2c_write(cam, 0x09, 0x01);
> -	err += sn9c102_i2c_write(cam, 0x0A, 0x76);
> -	err += sn9c102_i2c_write(cam, 0x0B, 0x60);
> -	err += sn9c102_i2c_write(cam, 0x0C, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x0D, 0x08);
> -	err += sn9c102_i2c_write(cam, 0x0E, 0x04);
> -	err += sn9c102_i2c_write(cam, 0x0F, 0x6F);
> -	err += sn9c102_i2c_write(cam, 0x10, 0x20);
> -	err += sn9c102_i2c_write(cam, 0x11, 0x03);
> -	err += sn9c102_i2c_write(cam, 0x12, 0x05);
> -	err += sn9c102_i2c_write(cam, 0x13, 0xC7);
> -	err += sn9c102_i2c_write(cam, 0x14, 0x2C);
> -	err += sn9c102_i2c_write(cam, 0x15, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x16, 0x02);
> -	err += sn9c102_i2c_write(cam, 0x17, 0x10);
> -	err += sn9c102_i2c_write(cam, 0x18, 0x60);
> -	err += sn9c102_i2c_write(cam, 0x19, 0x02);
> -	err += sn9c102_i2c_write(cam, 0x1A, 0x7B);
> -	err += sn9c102_i2c_write(cam, 0x1B, 0x02);
> -	err += sn9c102_i2c_write(cam, 0x1C, 0x7F);
> -	err += sn9c102_i2c_write(cam, 0x1D, 0xA2);
> -	err += sn9c102_i2c_write(cam, 0x1E, 0x01);
> -	err += sn9c102_i2c_write(cam, 0x1F, 0x0E);
> -	err += sn9c102_i2c_write(cam, 0x20, 0x05);
> -	err += sn9c102_i2c_write(cam, 0x21, 0x05);
> -	err += sn9c102_i2c_write(cam, 0x22, 0x05);
> -	err += sn9c102_i2c_write(cam, 0x23, 0x05);
> -	err += sn9c102_i2c_write(cam, 0x24, 0x68);
> -	err += sn9c102_i2c_write(cam, 0x25, 0x58);
> -	err += sn9c102_i2c_write(cam, 0x26, 0xD4);
> -	err += sn9c102_i2c_write(cam, 0x27, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x28, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x29, 0x30);
> -	err += sn9c102_i2c_write(cam, 0x2A, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x2B, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x2C, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x2D, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x2E, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x2F, 0x0E);
> -	err += sn9c102_i2c_write(cam, 0x30, 0x08);
> -	err += sn9c102_i2c_write(cam, 0x31, 0x30);
> -	err += sn9c102_i2c_write(cam, 0x32, 0xB4);
> -	err += sn9c102_i2c_write(cam, 0x33, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x34, 0x07);
> -	err += sn9c102_i2c_write(cam, 0x35, 0x84);
> -	err += sn9c102_i2c_write(cam, 0x36, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x37, 0x0C);
> -	err += sn9c102_i2c_write(cam, 0x38, 0x02);
> -	err += sn9c102_i2c_write(cam, 0x39, 0x43);
> -	err += sn9c102_i2c_write(cam, 0x3A, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x3B, 0x0A);
> -	err += sn9c102_i2c_write(cam, 0x3C, 0x6C);
> -	err += sn9c102_i2c_write(cam, 0x3D, 0x99);
> -	err += sn9c102_i2c_write(cam, 0x3E, 0x0E);
> -	err += sn9c102_i2c_write(cam, 0x3F, 0x41);
> -	err += sn9c102_i2c_write(cam, 0x40, 0xC1);
> -	err += sn9c102_i2c_write(cam, 0x41, 0x22);
> -	err += sn9c102_i2c_write(cam, 0x42, 0x08);
> -	err += sn9c102_i2c_write(cam, 0x43, 0xF0);
> -	err += sn9c102_i2c_write(cam, 0x44, 0x10);
> -	err += sn9c102_i2c_write(cam, 0x45, 0x78);
> -	err += sn9c102_i2c_write(cam, 0x46, 0xA8);
> -	err += sn9c102_i2c_write(cam, 0x47, 0x60);
> -	err += sn9c102_i2c_write(cam, 0x48, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x49, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x4A, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x4B, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x4C, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x4D, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x4E, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x4F, 0x46);
> -	err += sn9c102_i2c_write(cam, 0x50, 0x36);
> -	err += sn9c102_i2c_write(cam, 0x51, 0x0F);
> -	err += sn9c102_i2c_write(cam, 0x52, 0x17);
> -	err += sn9c102_i2c_write(cam, 0x53, 0x7F);
> -	err += sn9c102_i2c_write(cam, 0x54, 0x96);
> -	err += sn9c102_i2c_write(cam, 0x55, 0x40);
> -	err += sn9c102_i2c_write(cam, 0x56, 0x40);
> -	err += sn9c102_i2c_write(cam, 0x57, 0x40);
> -	err += sn9c102_i2c_write(cam, 0x58, 0x0F);
> -	err += sn9c102_i2c_write(cam, 0x59, 0xBA);
> -	err += sn9c102_i2c_write(cam, 0x5A, 0x9A);
> -	err += sn9c102_i2c_write(cam, 0x5B, 0x22);
> -	err += sn9c102_i2c_write(cam, 0x5C, 0xB9);
> -	err += sn9c102_i2c_write(cam, 0x5D, 0x9B);
> -	err += sn9c102_i2c_write(cam, 0x5E, 0x10);
> -	err += sn9c102_i2c_write(cam, 0x5F, 0xF0);
> -	err += sn9c102_i2c_write(cam, 0x60, 0x05);
> -	err += sn9c102_i2c_write(cam, 0x61, 0x60);
> -	err += sn9c102_i2c_write(cam, 0x62, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x63, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x64, 0x50);
> -	err += sn9c102_i2c_write(cam, 0x65, 0x30);
> -	err += sn9c102_i2c_write(cam, 0x66, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x67, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x68, 0x7A);
> -	err += sn9c102_i2c_write(cam, 0x69, 0x90);
> -	err += sn9c102_i2c_write(cam, 0x6A, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x6B, 0x0A);
> -	err += sn9c102_i2c_write(cam, 0x6C, 0x30);
> -	err += sn9c102_i2c_write(cam, 0x6D, 0x48);
> -	err += sn9c102_i2c_write(cam, 0x6E, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x6F, 0x74);
> -	err += sn9c102_i2c_write(cam, 0x70, 0x64);
> -	err += sn9c102_i2c_write(cam, 0x71, 0x60);
> -	err += sn9c102_i2c_write(cam, 0x72, 0x5C);
> -	err += sn9c102_i2c_write(cam, 0x73, 0x58);
> -	err += sn9c102_i2c_write(cam, 0x74, 0x54);
> -	err += sn9c102_i2c_write(cam, 0x75, 0x4C);
> -	err += sn9c102_i2c_write(cam, 0x76, 0x40);
> -	err += sn9c102_i2c_write(cam, 0x77, 0x38);
> -	err += sn9c102_i2c_write(cam, 0x78, 0x34);
> -	err += sn9c102_i2c_write(cam, 0x79, 0x30);
> -	err += sn9c102_i2c_write(cam, 0x7A, 0x2F);
> -	err += sn9c102_i2c_write(cam, 0x7B, 0x2B);
> -	err += sn9c102_i2c_write(cam, 0x7C, 0x03);
> -	err += sn9c102_i2c_write(cam, 0x7D, 0x07);
> -	err += sn9c102_i2c_write(cam, 0x7E, 0x17);
> -	err += sn9c102_i2c_write(cam, 0x7F, 0x34);
> -	err += sn9c102_i2c_write(cam, 0x80, 0x41);
> -	err += sn9c102_i2c_write(cam, 0x81, 0x4D);
> -	err += sn9c102_i2c_write(cam, 0x82, 0x58);
> -	err += sn9c102_i2c_write(cam, 0x83, 0x63);
> -	err += sn9c102_i2c_write(cam, 0x84, 0x6E);
> -	err += sn9c102_i2c_write(cam, 0x85, 0x77);
> -	err += sn9c102_i2c_write(cam, 0x86, 0x87);
> -	err += sn9c102_i2c_write(cam, 0x87, 0x95);
> -	err += sn9c102_i2c_write(cam, 0x88, 0xAF);
> -	err += sn9c102_i2c_write(cam, 0x89, 0xC7);
> -	err += sn9c102_i2c_write(cam, 0x8A, 0xDF);
> -	err += sn9c102_i2c_write(cam, 0x8B, 0x99);
> -	err += sn9c102_i2c_write(cam, 0x8C, 0x99);
> -	err += sn9c102_i2c_write(cam, 0x8D, 0xCF);
> -	err += sn9c102_i2c_write(cam, 0x8E, 0x20);
> -	err += sn9c102_i2c_write(cam, 0x8F, 0x26);
> -	err += sn9c102_i2c_write(cam, 0x90, 0x10);
> -	err += sn9c102_i2c_write(cam, 0x91, 0x0C);
> -	err += sn9c102_i2c_write(cam, 0x92, 0x25);
> -	err += sn9c102_i2c_write(cam, 0x93, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x94, 0x50);
> -	err += sn9c102_i2c_write(cam, 0x95, 0x50);
> -	err += sn9c102_i2c_write(cam, 0x96, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x97, 0x01);
> -	err += sn9c102_i2c_write(cam, 0x98, 0x10);
> -	err += sn9c102_i2c_write(cam, 0x99, 0x40);
> -	err += sn9c102_i2c_write(cam, 0x9A, 0x40);
> -	err += sn9c102_i2c_write(cam, 0x9B, 0x20);
> -	err += sn9c102_i2c_write(cam, 0x9C, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x9D, 0x99);
> -	err += sn9c102_i2c_write(cam, 0x9E, 0x7F);
> -	err += sn9c102_i2c_write(cam, 0x9F, 0x00);
> -	err += sn9c102_i2c_write(cam, 0xA0, 0x00);
> -	err += sn9c102_i2c_write(cam, 0xA1, 0x00);
> -
> -	return err;
> -}
> -
> -
> -static int ov7660_get_ctrl(struct sn9c102_device *cam,
> -			   struct v4l2_control *ctrl)
> -{
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x10);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		break;
> -	case V4L2_CID_DO_WHITE_BALANCE:
> -		ctrl->value = sn9c102_read_reg(cam, 0x02);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = (ctrl->value & 0x04) ? 1 : 0;
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		ctrl->value = sn9c102_read_reg(cam, 0x05);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x7f;
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ctrl->value = sn9c102_read_reg(cam, 0x06);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x7f;
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		ctrl->value = sn9c102_read_reg(cam, 0x07);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x7f;
> -		break;
> -	case SN9C102_V4L2_CID_BAND_FILTER:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x3b);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x08;
> -		break;
> -	case V4L2_CID_GAIN:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x00);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x1f;
> -		break;
> -	case V4L2_CID_AUTOGAIN:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x13);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x01;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int ov7660_set_ctrl(struct sn9c102_device *cam,
> -			   const struct v4l2_control *ctrl)
> -{
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		err += sn9c102_i2c_write(cam, 0x10, ctrl->value);
> -		break;
> -	case V4L2_CID_DO_WHITE_BALANCE:
> -		err += sn9c102_write_reg(cam, 0x43 | (ctrl->value << 2), 0x02);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		err += sn9c102_write_reg(cam, ctrl->value, 0x05);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		err += sn9c102_write_reg(cam, ctrl->value, 0x06);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		err += sn9c102_write_reg(cam, ctrl->value, 0x07);
> -		break;
> -	case SN9C102_V4L2_CID_BAND_FILTER:
> -		err += sn9c102_i2c_write(cam, ctrl->value << 3, 0x3b);
> -		break;
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_write(cam, 0x00, 0x60 + ctrl->value);
> -		break;
> -	case V4L2_CID_AUTOGAIN:
> -		err += sn9c102_i2c_write(cam, 0x13, 0xc0 |
> -						    (ctrl->value * 0x07));
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int ov7660_set_crop(struct sn9c102_device *cam,
> -			   const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 1,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -
> -static int ov7660_set_pix_format(struct sn9c102_device *cam,
> -				 const struct v4l2_pix_format *pix)
> -{
> -	int r0, err = 0;
> -
> -	r0 = sn9c102_pread_reg(cam, 0x01);
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
> -		err += sn9c102_write_reg(cam, r0 | 0x40, 0x01);
> -		err += sn9c102_write_reg(cam, 0xa2, 0x17);
> -		err += sn9c102_i2c_write(cam, 0x11, 0x00);
> -	} else {
> -		err += sn9c102_write_reg(cam, r0 | 0x40, 0x01);
> -		err += sn9c102_write_reg(cam, 0xa2, 0x17);
> -		err += sn9c102_i2c_write(cam, 0x11, 0x0d);
> -	}
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor ov7660 = {
> -	.name = "OV7660",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C105 | BRIDGE_SN9C120,
> -	.sysfs_ops = SN9C102_I2C_READ | SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x21,
> -	.init = &ov7660_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = 0x1f,
> -			.step = 0x01,
> -			.default_value = 0x09,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_EXPOSURE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "exposure",
> -			.minimum = 0x00,
> -			.maximum = 0xff,
> -			.step = 0x01,
> -			.default_value = 0x27,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_DO_WHITE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "night mode",
> -			.minimum = 0x00,
> -			.maximum = 0x01,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_RED_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "red balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x14,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLUE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "blue balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x14,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_AUTOGAIN,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "auto adjust",
> -			.minimum = 0x00,
> -			.maximum = 0x01,
> -			.step = 0x01,
> -			.default_value = 0x01,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GREEN_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "green balance",
> -			.minimum = 0x00,
> -			.maximum = 0x7f,
> -			.step = 0x01,
> -			.default_value = 0x14,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_BAND_FILTER,
> -			.type = V4L2_CTRL_TYPE_BOOLEAN,
> -			.name = "band filter",
> -			.minimum = 0x00,
> -			.maximum = 0x01,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &ov7660_get_ctrl,
> -	.set_ctrl = &ov7660_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &ov7660_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_JPEG,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &ov7660_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_ov7660(struct sn9c102_device *cam)
> -{
> -	int pid, ver, err;
> -
> -	err = sn9c102_write_const_regs(cam, {0x01, 0xf1}, {0x00, 0xf1},
> -				       {0x01, 0x01}, {0x00, 0x01},
> -				       {0x28, 0x17});
> -
> -	pid = sn9c102_i2c_try_read(cam, &ov7660, 0x0a);
> -	ver = sn9c102_i2c_try_read(cam, &ov7660, 0x0b);
> -	if (err || pid < 0 || ver < 0)
> -		return -EIO;
> -	if (pid != 0x76 || ver != 0x60)
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &ov7660);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_pas106b.c b/drivers/staging/media/sn9c102/sn9c102_pas106b.c
> deleted file mode 100644
> index 895931e..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_pas106b.c
> +++ /dev/null
> @@ -1,308 +0,0 @@
> -/***************************************************************************
> - * Plug-in for PAS106B image sensor connected to the SN9C1xx PC Camera     *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2004-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include <linux/delay.h>
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int pas106b_init(struct sn9c102_device *cam)
> -{
> -	int err = 0;
> -
> -	err = sn9c102_write_const_regs(cam, {0x00, 0x10}, {0x00, 0x11},
> -				       {0x00, 0x14}, {0x20, 0x17},
> -				       {0x20, 0x19}, {0x09, 0x18});
> -
> -	err += sn9c102_i2c_write(cam, 0x02, 0x0c);
> -	err += sn9c102_i2c_write(cam, 0x05, 0x5a);
> -	err += sn9c102_i2c_write(cam, 0x06, 0x88);
> -	err += sn9c102_i2c_write(cam, 0x07, 0x80);
> -	err += sn9c102_i2c_write(cam, 0x10, 0x06);
> -	err += sn9c102_i2c_write(cam, 0x11, 0x06);
> -	err += sn9c102_i2c_write(cam, 0x12, 0x00);
> -	err += sn9c102_i2c_write(cam, 0x14, 0x02);
> -	err += sn9c102_i2c_write(cam, 0x13, 0x01);
> -
> -	msleep(400);
> -
> -	return err;
> -}
> -
> -
> -static int pas106b_get_ctrl(struct sn9c102_device *cam,
> -			    struct v4l2_control *ctrl)
> -{
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		{
> -			int r1 = sn9c102_i2c_read(cam, 0x03),
> -			    r2 = sn9c102_i2c_read(cam, 0x04);
> -			if (r1 < 0 || r2 < 0)
> -				return -EIO;
> -			ctrl->value = (r1 << 4) | (r2 & 0x0f);
> -		}
> -		return 0;
> -	case V4L2_CID_RED_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x0c);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x1f;
> -		return 0;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x09);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x1f;
> -		return 0;
> -	case V4L2_CID_GAIN:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x0e);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x1f;
> -		return 0;
> -	case V4L2_CID_CONTRAST:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x0f);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x07;
> -		return 0;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x0a);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value = (ctrl->value & 0x1f) << 1;
> -		return 0;
> -	case SN9C102_V4L2_CID_DAC_MAGNITUDE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x08);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0xf8;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -
> -static int pas106b_set_ctrl(struct sn9c102_device *cam,
> -			    const struct v4l2_control *ctrl)
> -{
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		err += sn9c102_i2c_write(cam, 0x03, ctrl->value >> 4);
> -		err += sn9c102_i2c_write(cam, 0x04, ctrl->value & 0x0f);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x0c, ctrl->value);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x09, ctrl->value);
> -		break;
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_write(cam, 0x0e, ctrl->value);
> -		break;
> -	case V4L2_CID_CONTRAST:
> -		err += sn9c102_i2c_write(cam, 0x0f, ctrl->value);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x0a, ctrl->value >> 1);
> -		err += sn9c102_i2c_write(cam, 0x0b, ctrl->value >> 1);
> -		break;
> -	case SN9C102_V4L2_CID_DAC_MAGNITUDE:
> -		err += sn9c102_i2c_write(cam, 0x08, ctrl->value << 3);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -	err += sn9c102_i2c_write(cam, 0x13, 0x01);
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int pas106b_set_crop(struct sn9c102_device *cam,
> -			    const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 4,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 3;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -
> -static int pas106b_set_pix_format(struct sn9c102_device *cam,
> -				  const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X)
> -		err += sn9c102_write_reg(cam, 0x2c, 0x17);
> -	else
> -		err += sn9c102_write_reg(cam, 0x20, 0x17);
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor pas106b = {
> -	.name = "PAS106B",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C101 | BRIDGE_SN9C102,
> -	.sysfs_ops = SN9C102_I2C_READ | SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_400KHZ | SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x40,
> -	.init = &pas106b_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_EXPOSURE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "exposure",
> -			.minimum = 0x125,
> -			.maximum = 0xfff,
> -			.step = 0x001,
> -			.default_value = 0x140,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = 0x1f,
> -			.step = 0x01,
> -			.default_value = 0x0d,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_CONTRAST,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "contrast",
> -			.minimum = 0x00,
> -			.maximum = 0x07,
> -			.step = 0x01,
> -			.default_value = 0x00, /* 0x00~0x03 have same effect */
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_RED_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "red balance",
> -			.minimum = 0x00,
> -			.maximum = 0x1f,
> -			.step = 0x01,
> -			.default_value = 0x04,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLUE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "blue balance",
> -			.minimum = 0x00,
> -			.maximum = 0x1f,
> -			.step = 0x01,
> -			.default_value = 0x06,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GREEN_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "green balance",
> -			.minimum = 0x00,
> -			.maximum = 0x3e,
> -			.step = 0x02,
> -			.default_value = 0x02,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_DAC_MAGNITUDE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "DAC magnitude",
> -			.minimum = 0x00,
> -			.maximum = 0x1f,
> -			.step = 0x01,
> -			.default_value = 0x01,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &pas106b_get_ctrl,
> -	.set_ctrl = &pas106b_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 352,
> -			.height = 288,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 352,
> -			.height = 288,
> -		},
> -	},
> -	.set_crop = &pas106b_set_crop,
> -	.pix_format = {
> -		.width = 352,
> -		.height = 288,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8, /* we use this field as 'bits per pixel' */
> -	},
> -	.set_pix_format = &pas106b_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_pas106b(struct sn9c102_device *cam)
> -{
> -	int r0 = 0, r1 = 0;
> -	unsigned int pid = 0;
> -
> -	/*
> -	   Minimal initialization to enable the I2C communication
> -	   NOTE: do NOT change the values!
> -	*/
> -	if (sn9c102_write_const_regs(cam,
> -				     {0x01, 0x01}, /* sensor power down */
> -				     {0x00, 0x01}, /* sensor power on */
> -				    {0x28, 0x17})) /* sensor clock at 24 MHz */
> -		return -EIO;
> -
> -	r0 = sn9c102_i2c_try_read(cam, &pas106b, 0x00);
> -	r1 = sn9c102_i2c_try_read(cam, &pas106b, 0x01);
> -	if (r0 < 0 || r1 < 0)
> -		return -EIO;
> -
> -	pid = (r0 << 11) | ((r1 & 0xf0) >> 4);
> -	if (pid != 0x007)
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &pas106b);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_pas202bcb.c b/drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
> deleted file mode 100644
> index f9e31ae..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
> +++ /dev/null
> @@ -1,340 +0,0 @@
> -/***************************************************************************
> - * Plug-in for PAS202BCB image sensor connected to the SN9C1xx PC Camera   *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2004 by Carlos Eduardo Medaglia Dyonisio                  *
> - *                       <medaglia@undl.org.br>                            *
> - *                                                                         *
> - * Support for SN9C103, DAC Magnitude, exposure and green gain controls    *
> - * added by Luca Risolia <luca.risolia@studio.unibo.it>                    *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include <linux/delay.h>
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int pas202bcb_init(struct sn9c102_device *cam)
> -{
> -	int err = 0;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -		err = sn9c102_write_const_regs(cam, {0x00, 0x10}, {0x00, 0x11},
> -					       {0x00, 0x14}, {0x20, 0x17},
> -					       {0x30, 0x19}, {0x09, 0x18});
> -		break;
> -	case BRIDGE_SN9C103:
> -		err = sn9c102_write_const_regs(cam, {0x00, 0x02}, {0x00, 0x03},
> -					       {0x1a, 0x04}, {0x20, 0x05},
> -					       {0x20, 0x06}, {0x20, 0x07},
> -					       {0x00, 0x10}, {0x00, 0x11},
> -					       {0x00, 0x14}, {0x20, 0x17},
> -					       {0x30, 0x19}, {0x09, 0x18},
> -					       {0x02, 0x1c}, {0x03, 0x1d},
> -					       {0x0f, 0x1e}, {0x0c, 0x1f},
> -					       {0x00, 0x20}, {0x10, 0x21},
> -					       {0x20, 0x22}, {0x30, 0x23},
> -					       {0x40, 0x24}, {0x50, 0x25},
> -					       {0x60, 0x26}, {0x70, 0x27},
> -					       {0x80, 0x28}, {0x90, 0x29},
> -					       {0xa0, 0x2a}, {0xb0, 0x2b},
> -					       {0xc0, 0x2c}, {0xd0, 0x2d},
> -					       {0xe0, 0x2e}, {0xf0, 0x2f},
> -					       {0xff, 0x30});
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	err += sn9c102_i2c_write(cam, 0x02, 0x14);
> -	err += sn9c102_i2c_write(cam, 0x03, 0x40);
> -	err += sn9c102_i2c_write(cam, 0x0d, 0x2c);
> -	err += sn9c102_i2c_write(cam, 0x0e, 0x01);
> -	err += sn9c102_i2c_write(cam, 0x0f, 0xa9);
> -	err += sn9c102_i2c_write(cam, 0x10, 0x08);
> -	err += sn9c102_i2c_write(cam, 0x13, 0x63);
> -	err += sn9c102_i2c_write(cam, 0x15, 0x70);
> -	err += sn9c102_i2c_write(cam, 0x11, 0x01);
> -
> -	msleep(400);
> -
> -	return err;
> -}
> -
> -
> -static int pas202bcb_get_ctrl(struct sn9c102_device *cam,
> -			      struct v4l2_control *ctrl)
> -{
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		{
> -			int r1 = sn9c102_i2c_read(cam, 0x04),
> -			    r2 = sn9c102_i2c_read(cam, 0x05);
> -			if (r1 < 0 || r2 < 0)
> -				return -EIO;
> -			ctrl->value = (r1 << 6) | (r2 & 0x3f);
> -		}
> -		return 0;
> -	case V4L2_CID_RED_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x09);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x0f;
> -		return 0;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x07);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x0f;
> -		return 0;
> -	case V4L2_CID_GAIN:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x10);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x1f;
> -		return 0;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x08);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		ctrl->value &= 0x0f;
> -		return 0;
> -	case SN9C102_V4L2_CID_DAC_MAGNITUDE:
> -		ctrl->value = sn9c102_i2c_read(cam, 0x0c);
> -		if (ctrl->value < 0)
> -			return -EIO;
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -
> -static int pas202bcb_set_pix_format(struct sn9c102_device *cam,
> -				    const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X)
> -		err += sn9c102_write_reg(cam, 0x28, 0x17);
> -	else
> -		err += sn9c102_write_reg(cam, 0x20, 0x17);
> -
> -	return err;
> -}
> -
> -
> -static int pas202bcb_set_ctrl(struct sn9c102_device *cam,
> -			      const struct v4l2_control *ctrl)
> -{
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_EXPOSURE:
> -		err += sn9c102_i2c_write(cam, 0x04, ctrl->value >> 6);
> -		err += sn9c102_i2c_write(cam, 0x05, ctrl->value & 0x3f);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x09, ctrl->value);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x07, ctrl->value);
> -		break;
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_write(cam, 0x10, ctrl->value);
> -		break;
> -	case SN9C102_V4L2_CID_GREEN_BALANCE:
> -		err += sn9c102_i2c_write(cam, 0x08, ctrl->value);
> -		break;
> -	case SN9C102_V4L2_CID_DAC_MAGNITUDE:
> -		err += sn9c102_i2c_write(cam, 0x0c, ctrl->value);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -	err += sn9c102_i2c_write(cam, 0x11, 0x01);
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int pas202bcb_set_crop(struct sn9c102_device *cam,
> -			      const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = 0,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 3;
> -
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -		h_start = (u8)(rect->left - s->cropcap.bounds.left) + 4;
> -		break;
> -	case BRIDGE_SN9C103:
> -		h_start = (u8)(rect->left - s->cropcap.bounds.left) + 3;
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor pas202bcb = {
> -	.name = "PAS202BCB",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C101 | BRIDGE_SN9C102 | BRIDGE_SN9C103,
> -	.sysfs_ops = SN9C102_I2C_READ | SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_400KHZ | SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x40,
> -	.init = &pas202bcb_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_EXPOSURE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "exposure",
> -			.minimum = 0x01e5,
> -			.maximum = 0x3fff,
> -			.step = 0x0001,
> -			.default_value = 0x01e5,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = 0x1f,
> -			.step = 0x01,
> -			.default_value = 0x0b,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_RED_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "red balance",
> -			.minimum = 0x00,
> -			.maximum = 0x0f,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_BLUE_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "blue balance",
> -			.minimum = 0x00,
> -			.maximum = 0x0f,
> -			.step = 0x01,
> -			.default_value = 0x05,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_GREEN_BALANCE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "green balance",
> -			.minimum = 0x00,
> -			.maximum = 0x0f,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = SN9C102_V4L2_CID_DAC_MAGNITUDE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "DAC magnitude",
> -			.minimum = 0x00,
> -			.maximum = 0xff,
> -			.step = 0x01,
> -			.default_value = 0x04,
> -			.flags = 0,
> -		},
> -	},
> -	.get_ctrl = &pas202bcb_get_ctrl,
> -	.set_ctrl = &pas202bcb_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &pas202bcb_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &pas202bcb_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_pas202bcb(struct sn9c102_device *cam)
> -{
> -	int r0 = 0, r1 = 0, err = 0;
> -	unsigned int pid = 0;
> -
> -	/*
> -	 *  Minimal initialization to enable the I2C communication
> -	 *  NOTE: do NOT change the values!
> -	 */
> -	switch (sn9c102_get_bridge(cam)) {
> -	case BRIDGE_SN9C101:
> -	case BRIDGE_SN9C102:
> -		err = sn9c102_write_const_regs(cam,
> -					       {0x01, 0x01}, /* power down */
> -					       {0x40, 0x01}, /* power on */
> -					       {0x28, 0x17});/* clock 24 MHz */
> -		break;
> -	case BRIDGE_SN9C103: /* do _not_ change anything! */
> -		err = sn9c102_write_const_regs(cam, {0x09, 0x01}, {0x44, 0x01},
> -					       {0x44, 0x02}, {0x29, 0x17});
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	r0 = sn9c102_i2c_try_read(cam, &pas202bcb, 0x00);
> -	r1 = sn9c102_i2c_try_read(cam, &pas202bcb, 0x01);
> -
> -	if (err || r0 < 0 || r1 < 0)
> -		return -EIO;
> -
> -	pid = (r0 << 4) | ((r1 & 0xf0) >> 4);
> -	if (pid != 0x017)
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &pas202bcb);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_sensor.h b/drivers/staging/media/sn9c102/sn9c102_sensor.h
> deleted file mode 100644
> index 9f59c81..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_sensor.h
> +++ /dev/null
> @@ -1,307 +0,0 @@
> -/***************************************************************************
> - * API for image sensors connected to the SN9C1xx PC Camera Controllers    *
> - *                                                                         *
> - * Copyright (C) 2004-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#ifndef _SN9C102_SENSOR_H_
> -#define _SN9C102_SENSOR_H_
> -
> -#include <linux/usb.h>
> -#include <linux/videodev2.h>
> -#include <linux/device.h>
> -#include <linux/stddef.h>
> -#include <linux/errno.h>
> -#include <asm/types.h>
> -
> -struct sn9c102_device;
> -struct sn9c102_sensor;
> -
> -/*****************************************************************************/
> -
> -/*
> -   OVERVIEW.
> -   This is a small interface that allows you to add support for any CCD/CMOS
> -   image sensors connected to the SN9C1XX bridges. The entire API is documented
> -   below. In the most general case, to support a sensor there are three steps
> -   you have to follow:
> -   1) define the main "sn9c102_sensor" structure by setting the basic fields;
> -   2) write a probing function to be called by the core module when the USB
> -      camera is recognized, then add both the USB ids and the name of that
> -      function to the two corresponding tables in sn9c102_devtable.h;
> -   3) implement the methods that you want/need (and fill the rest of the main
> -      structure accordingly).
> -   "sn9c102_pas106b.c" is an example of all this stuff. Remember that you do
> -   NOT need to touch the source code of the core module for the things to work
> -   properly, unless you find bugs or flaws in it. Finally, do not forget to
> -   read the V4L2 API for completeness.
> -*/
> -
> -/*****************************************************************************/
> -
> -enum sn9c102_bridge {
> -	BRIDGE_SN9C101 = 0x01,
> -	BRIDGE_SN9C102 = 0x02,
> -	BRIDGE_SN9C103 = 0x04,
> -	BRIDGE_SN9C105 = 0x08,
> -	BRIDGE_SN9C120 = 0x10,
> -};
> -
> -/* Return the bridge name */
> -enum sn9c102_bridge sn9c102_get_bridge(struct sn9c102_device *cam);
> -
> -/* Return a pointer the sensor struct attached to the camera */
> -struct sn9c102_sensor *sn9c102_get_sensor(struct sn9c102_device *cam);
> -
> -/* Identify a device */
> -extern struct sn9c102_device*
> -sn9c102_match_id(struct sn9c102_device *cam, const struct usb_device_id *id);
> -
> -/* Attach a probed sensor to the camera. */
> -extern void
> -sn9c102_attach_sensor(struct sn9c102_device *cam,
> -		      const struct sn9c102_sensor *sensor);
> -
> -/*
> -   Read/write routines: they always return -1 on error, 0 or the read value
> -   otherwise. NOTE that a real read operation is not supported by the SN9C1XX
> -   chip for some of its registers. To work around this problem, a pseudo-read
> -   call is provided instead: it returns the last successfully written value
> -   on the register (0 if it has never been written), the usual -1 on error.
> -*/
> -
> -/* The "try" I2C I/O versions are used when probing the sensor */
> -extern int sn9c102_i2c_try_read(struct sn9c102_device*,
> -				const struct sn9c102_sensor*, u8 address);
> -
> -/*
> -   These must be used if and only if the sensor doesn't implement the standard
> -   I2C protocol. There are a number of good reasons why you must use the
> -   single-byte versions of these functions: do not abuse. The first function
> -   writes n bytes, from data0 to datan, to registers 0x09 - 0x09+n of SN9C1XX
> -   chip. The second one programs the registers 0x09 and 0x10 with data0 and
> -   data1, and places the n bytes read from the sensor register table in the
> -   buffer pointed by 'buffer'. Both the functions return -1 on error; the write
> -   version returns 0 on success, while the read version returns the first read
> -   byte.
> -*/
> -extern int sn9c102_i2c_try_raw_write(struct sn9c102_device *cam,
> -				     const struct sn9c102_sensor *sensor, u8 n,
> -				     u8 data0, u8 data1, u8 data2, u8 data3,
> -				     u8 data4, u8 data5);
> -extern int sn9c102_i2c_try_raw_read(struct sn9c102_device *cam,
> -				    const struct sn9c102_sensor *sensor,
> -				    u8 data0, u8 data1, u8 n, u8 buffer[]);
> -
> -/* To be used after the sensor struct has been attached to the camera struct */
> -extern int sn9c102_i2c_write(struct sn9c102_device*, u8 address, u8 value);
> -extern int sn9c102_i2c_read(struct sn9c102_device*, u8 address);
> -
> -/* I/O on registers in the bridge. Could be used by the sensor methods too */
> -extern int sn9c102_read_reg(struct sn9c102_device*, u16 index);
> -extern int sn9c102_pread_reg(struct sn9c102_device*, u16 index);
> -extern int sn9c102_write_reg(struct sn9c102_device*, u8 value, u16 index);
> -extern int sn9c102_write_regs(struct sn9c102_device*, const u8 valreg[][2],
> -			      int count);
> -/*
> -   Write multiple registers with constant values. For example:
> -   sn9c102_write_const_regs(cam, {0x00, 0x14}, {0x60, 0x17}, {0x0f, 0x18});
> -   Register addresses must be < 256.
> -*/
> -#define sn9c102_write_const_regs(sn9c102_device, data...)                     \
> -	({ static const u8 _valreg[][2] = {data};                             \
> -	sn9c102_write_regs(sn9c102_device, _valreg, ARRAY_SIZE(_valreg)); })
> -
> -/*****************************************************************************/
> -
> -enum sn9c102_i2c_sysfs_ops {
> -	SN9C102_I2C_READ = 0x01,
> -	SN9C102_I2C_WRITE = 0x02,
> -};
> -
> -enum sn9c102_i2c_frequency { /* sensors may support both the frequencies */
> -	SN9C102_I2C_100KHZ = 0x01,
> -	SN9C102_I2C_400KHZ = 0x02,
> -};
> -
> -enum sn9c102_i2c_interface {
> -	SN9C102_I2C_2WIRES,
> -	SN9C102_I2C_3WIRES,
> -};
> -
> -#define SN9C102_MAX_CTRLS (V4L2_CID_LASTP1-V4L2_CID_BASE+10)
> -
> -struct sn9c102_sensor {
> -	char name[32], /* sensor name */
> -	     maintainer[64]; /* name of the maintainer <email> */
> -
> -	enum sn9c102_bridge supported_bridge; /* supported SN9C1xx bridges */
> -
> -	/* Supported operations through the 'sysfs' interface */
> -	enum sn9c102_i2c_sysfs_ops sysfs_ops;
> -
> -	/*
> -	   These sensor capabilities must be provided if the SN9C1XX controller
> -	   needs to communicate through the sensor serial interface by using
> -	   at least one of the i2c functions available.
> -	*/
> -	enum sn9c102_i2c_frequency frequency;
> -	enum sn9c102_i2c_interface interface;
> -
> -	/*
> -	   This identifier must be provided if the image sensor implements
> -	   the standard I2C protocol.
> -	*/
> -	u8 i2c_slave_id; /* reg. 0x09 */
> -
> -	/*
> -	   NOTE: Where not noted,most of the functions below are not mandatory.
> -		 Set to null if you do not implement them. If implemented,
> -		 they must return 0 on success, the proper error otherwise.
> -	*/
> -
> -	int (*init)(struct sn9c102_device *cam);
> -	/*
> -	   This function will be called after the sensor has been attached.
> -	   It should be used to initialize the sensor only, but may also
> -	   configure part of the SN9C1XX chip if necessary. You don't need to
> -	   setup picture settings like brightness, contrast, etc.. here, if
> -	   the corresponding controls are implemented (see below), since
> -	   they are adjusted in the core driver by calling the set_ctrl()
> -	   method after init(), where the arguments are the default values
> -	   specified in the v4l2_queryctrl list of supported controls;
> -	   Same suggestions apply for other settings, _if_ the corresponding
> -	   methods are present; if not, the initialization must configure the
> -	   sensor according to the default configuration structures below.
> -	*/
> -
> -	struct v4l2_queryctrl qctrl[SN9C102_MAX_CTRLS];
> -	/*
> -	   Optional list of default controls, defined as indicated in the
> -	   V4L2 API. Menu type controls are not handled by this interface.
> -	*/
> -
> -	int (*get_ctrl)(struct sn9c102_device *cam, struct v4l2_control *ctrl);
> -	int (*set_ctrl)(struct sn9c102_device *cam,
> -			const struct v4l2_control *ctrl);
> -	/*
> -	   You must implement at least the set_ctrl method if you have defined
> -	   the list above. The returned value must follow the V4L2
> -	   specifications for the VIDIOC_G|C_CTRL ioctls. V4L2_CID_H|VCENTER
> -	   are not supported by this driver, so do not implement them. Also,
> -	   you don't have to check whether the passed values are out of bounds,
> -	   given that this is done by the core module.
> -	*/
> -
> -	struct v4l2_cropcap cropcap;
> -	/*
> -	   Think the image sensor as a grid of R,G,B monochromatic pixels
> -	   disposed according to a particular Bayer pattern, which describes
> -	   the complete array of pixels, from (0,0) to (xmax, ymax). We will
> -	   use this coordinate system from now on. It is assumed the sensor
> -	   chip can be programmed to capture/transmit a subsection of that
> -	   array of pixels: we will call this subsection "active window".
> -	   It is not always true that the largest achievable active window can
> -	   cover the whole array of pixels. The V4L2 API defines another
> -	   area called "source rectangle", which, in turn, is a subrectangle of
> -	   the active window. The SN9C1XX chip is always programmed to read the
> -	   source rectangle.
> -	   The bounds of both the active window and the source rectangle are
> -	   specified in the cropcap substructures 'bounds' and 'defrect'.
> -	   By default, the source rectangle should cover the largest possible
> -	   area. Again, it is not always true that the largest source rectangle
> -	   can cover the entire active window, although it is a rare case for
> -	   the hardware we have. The bounds of the source rectangle _must_ be
> -	   multiple of 16 and must use the same coordinate system as indicated
> -	   before; their centers shall align initially.
> -	   If necessary, the sensor chip must be initialized during init() to
> -	   set the bounds of the active sensor window; however, by default, it
> -	   usually covers the largest achievable area (maxwidth x maxheight)
> -	   of pixels, so no particular initialization is needed, if you have
> -	   defined the correct default bounds in the structures.
> -	   See the V4L2 API for further details.
> -	   NOTE: once you have defined the bounds of the active window
> -		 (struct cropcap.bounds) you must not change them.anymore.
> -	   Only 'bounds' and 'defrect' fields are mandatory, other fields
> -	   will be ignored.
> -	*/
> -
> -	int (*set_crop)(struct sn9c102_device *cam,
> -			const struct v4l2_rect *rect);
> -	/*
> -	   To be called on VIDIOC_C_SETCROP. The core module always calls a
> -	   default routine which configures the appropriate SN9C1XX regs (also
> -	   scaling), but you may need to override/adjust specific stuff.
> -	   'rect' contains width and height values that are multiple of 16: in
> -	   case you override the default function, you always have to program
> -	   the chip to match those values; on error return the corresponding
> -	   error code without rolling back.
> -	   NOTE: in case, you must program the SN9C1XX chip to get rid of
> -		 blank pixels or blank lines at the _start_ of each line or
> -		 frame after each HSYNC or VSYNC, so that the image starts with
> -		 real RGB data (see regs 0x12, 0x13) (having set H_SIZE and,
> -		 V_SIZE you don't have to care about blank pixels or blank
> -		 lines at the end of each line or frame).
> -	*/
> -
> -	struct v4l2_pix_format pix_format;
> -	/*
> -	   What you have to define here are: 1) initial 'width' and 'height' of
> -	   the target rectangle 2) the initial 'pixelformat', which can be
> -	   either V4L2_PIX_FMT_SN9C10X, V4L2_PIX_FMT_JPEG (for ompressed video)
> -	   or V4L2_PIX_FMT_SBGGR8 3) 'priv', which we'll be used to indicate
> -	   the number of bits per pixel for uncompressed video, 8 or 9 (despite
> -	   the current value of 'pixelformat').
> -	   NOTE 1: both 'width' and 'height' _must_ be either 1/1 or 1/2 or 1/4
> -		   of cropcap.defrect.width and cropcap.defrect.height. I
> -		   suggest 1/1.
> -	   NOTE 2: The initial compression quality is defined by the first bit
> -		   of reg 0x17 during the initialization of the image sensor.
> -	   NOTE 3: as said above, you have to program the SN9C1XX chip to get
> -		   rid of any blank pixels, so that the output of the sensor
> -		   matches the RGB bayer sequence (i.e. BGBGBG...GRGRGR).
> -	*/
> -
> -	int (*set_pix_format)(struct sn9c102_device *cam,
> -			      const struct v4l2_pix_format *pix);
> -	/*
> -	   To be called on VIDIOC_S_FMT, when switching from the SBGGR8 to
> -	   SN9C10X pixel format or viceversa. On error return the corresponding
> -	   error code without rolling back.
> -	*/
> -
> -	/*
> -	   Do NOT write to the data below, it's READ ONLY. It is used by the
> -	   core module to store successfully updated values of the above
> -	   settings, for rollbacks..etc..in case of errors during atomic I/O
> -	*/
> -	struct v4l2_queryctrl _qctrl[SN9C102_MAX_CTRLS];
> -	struct v4l2_rect _rect;
> -};
> -
> -/*****************************************************************************/
> -
> -/* Private ioctl's for control settings supported by some image sensors */
> -#define SN9C102_V4L2_CID_DAC_MAGNITUDE (V4L2_CID_PRIVATE_BASE + 0)
> -#define SN9C102_V4L2_CID_GREEN_BALANCE (V4L2_CID_PRIVATE_BASE + 1)
> -#define SN9C102_V4L2_CID_RESET_LEVEL (V4L2_CID_PRIVATE_BASE + 2)
> -#define SN9C102_V4L2_CID_PIXEL_BIAS_VOLTAGE (V4L2_CID_PRIVATE_BASE + 3)
> -#define SN9C102_V4L2_CID_GAMMA (V4L2_CID_PRIVATE_BASE + 4)
> -#define SN9C102_V4L2_CID_BAND_FILTER (V4L2_CID_PRIVATE_BASE + 5)
> -#define SN9C102_V4L2_CID_BRIGHT_LEVEL (V4L2_CID_PRIVATE_BASE + 6)
> -
> -#endif /* _SN9C102_SENSOR_H_ */
> diff --git a/drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c b/drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
> deleted file mode 100644
> index 6a00b62..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
> +++ /dev/null
> @@ -1,154 +0,0 @@
> -/***************************************************************************
> - * Plug-in for TAS5110C1B image sensor connected to the SN9C1xx PC Camera  *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2004-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int tas5110c1b_init(struct sn9c102_device *cam)
> -{
> -	int err = 0;
> -
> -	err = sn9c102_write_const_regs(cam, {0x01, 0x01}, {0x44, 0x01},
> -				       {0x00, 0x10}, {0x00, 0x11},
> -				       {0x0a, 0x14}, {0x60, 0x17},
> -				       {0x06, 0x18}, {0xfb, 0x19});
> -
> -	err += sn9c102_i2c_write(cam, 0xc0, 0x80);
> -
> -	return err;
> -}
> -
> -
> -static int tas5110c1b_set_ctrl(struct sn9c102_device *cam,
> -			       const struct v4l2_control *ctrl)
> -{
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_write(cam, 0x20, 0xf6 - ctrl->value);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int tas5110c1b_set_crop(struct sn9c102_device *cam,
> -			       const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 69,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 9;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	/* Don't change ! */
> -	err += sn9c102_write_reg(cam, 0x14, 0x1a);
> -	err += sn9c102_write_reg(cam, 0x0a, 0x1b);
> -	err += sn9c102_write_reg(cam, sn9c102_pread_reg(cam, 0x19), 0x19);
> -
> -	return err;
> -}
> -
> -
> -static int tas5110c1b_set_pix_format(struct sn9c102_device *cam,
> -				     const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X)
> -		err += sn9c102_write_reg(cam, 0x2b, 0x19);
> -	else
> -		err += sn9c102_write_reg(cam, 0xfb, 0x19);
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor tas5110c1b = {
> -	.name = "TAS5110C1B",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C101 | BRIDGE_SN9C102,
> -	.sysfs_ops = SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_3WIRES,
> -	.init = &tas5110c1b_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = 0xf6,
> -			.step = 0x01,
> -			.default_value = 0x40,
> -			.flags = 0,
> -		},
> -	},
> -	.set_ctrl = &tas5110c1b_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 352,
> -			.height = 288,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 352,
> -			.height = 288,
> -		},
> -	},
> -	.set_crop = &tas5110c1b_set_crop,
> -	.pix_format = {
> -		.width = 352,
> -		.height = 288,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &tas5110c1b_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_tas5110c1b(struct sn9c102_device *cam)
> -{
> -	const struct usb_device_id tas5110c1b_id_table[] = {
> -		{ USB_DEVICE(0x0c45, 0x6001), },
> -		{ USB_DEVICE(0x0c45, 0x6005), },
> -		{ USB_DEVICE(0x0c45, 0x60ab), },
> -		{ }
> -	};
> -
> -	/* Sensor detection is based on USB pid/vid */
> -	if (!sn9c102_match_id(cam, tas5110c1b_id_table))
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &tas5110c1b);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_tas5110d.c b/drivers/staging/media/sn9c102/sn9c102_tas5110d.c
> deleted file mode 100644
> index eefbf86..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_tas5110d.c
> +++ /dev/null
> @@ -1,119 +0,0 @@
> -/***************************************************************************
> - * Plug-in for TAS5110D image sensor connected to the SN9C1xx PC Camera    *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2007 by Luca Risolia <luca.risolia@studio.unibo.it>       *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int tas5110d_init(struct sn9c102_device *cam)
> -{
> -	int err;
> -
> -	err = sn9c102_write_const_regs(cam, {0x01, 0x01}, {0x04, 0x01},
> -				       {0x0a, 0x14}, {0x60, 0x17},
> -				       {0x06, 0x18}, {0xfb, 0x19});
> -
> -	err += sn9c102_i2c_write(cam, 0x9a, 0xca);
> -
> -	return err;
> -}
> -
> -
> -static int tas5110d_set_crop(struct sn9c102_device *cam,
> -			     const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	int err = 0;
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 69,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 9;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	err += sn9c102_write_reg(cam, 0x14, 0x1a);
> -	err += sn9c102_write_reg(cam, 0x0a, 0x1b);
> -
> -	return err;
> -}
> -
> -
> -static int tas5110d_set_pix_format(struct sn9c102_device *cam,
> -				     const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X)
> -		err += sn9c102_write_reg(cam, 0x3b, 0x19);
> -	else
> -		err += sn9c102_write_reg(cam, 0xfb, 0x19);
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor tas5110d = {
> -	.name = "TAS5110D",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C101 | BRIDGE_SN9C102,
> -	.sysfs_ops = SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_2WIRES,
> -	.i2c_slave_id = 0x61,
> -	.init = &tas5110d_init,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 352,
> -			.height = 288,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 352,
> -			.height = 288,
> -		},
> -	},
> -	.set_crop = &tas5110d_set_crop,
> -	.pix_format = {
> -		.width = 352,
> -		.height = 288,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &tas5110d_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_tas5110d(struct sn9c102_device *cam)
> -{
> -	const struct usb_device_id tas5110d_id_table[] = {
> -		{ USB_DEVICE(0x0c45, 0x6007), },
> -		{ }
> -	};
> -
> -	if (!sn9c102_match_id(cam, tas5110d_id_table))
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &tas5110d);
> -
> -	return 0;
> -}
> diff --git a/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c b/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
> deleted file mode 100644
> index 725de85..0000000
> --- a/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
> +++ /dev/null
> @@ -1,165 +0,0 @@
> -/***************************************************************************
> - * Plug-in for TAS5130D1B image sensor connected to the SN9C1xx PC Camera  *
> - * Controllers                                                             *
> - *                                                                         *
> - * Copyright (C) 2004-2007 by Luca Risolia <luca.risolia@studio.unibo.it>  *
> - *                                                                         *
> - * This program is free software; you can redistribute it and/or modify    *
> - * it under the terms of the GNU General Public License as published by    *
> - * the Free Software Foundation; either version 2 of the License, or       *
> - * (at your option) any later version.                                     *
> - *                                                                         *
> - * This program is distributed in the hope that it will be useful,         *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
> - * GNU General Public License for more details.                            *
> - *                                                                         *
> - * You should have received a copy of the GNU General Public License       *
> - * along with this program; if not, write to the Free Software             *
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
> - ***************************************************************************/
> -
> -#include "sn9c102_sensor.h"
> -#include "sn9c102_devtable.h"
> -
> -
> -static int tas5130d1b_init(struct sn9c102_device *cam)
> -{
> -	int err;
> -
> -	err = sn9c102_write_const_regs(cam, {0x01, 0x01}, {0x20, 0x17},
> -				       {0x04, 0x01}, {0x01, 0x10},
> -				       {0x00, 0x11}, {0x00, 0x14},
> -				       {0x60, 0x17}, {0x07, 0x18});
> -
> -	return err;
> -}
> -
> -
> -static int tas5130d1b_set_ctrl(struct sn9c102_device *cam,
> -			       const struct v4l2_control *ctrl)
> -{
> -	int err = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_GAIN:
> -		err += sn9c102_i2c_write(cam, 0x20, 0xf6 - ctrl->value);
> -		break;
> -	case V4L2_CID_EXPOSURE:
> -		err += sn9c102_i2c_write(cam, 0x40, 0x47 - ctrl->value);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return err ? -EIO : 0;
> -}
> -
> -
> -static int tas5130d1b_set_crop(struct sn9c102_device *cam,
> -			       const struct v4l2_rect *rect)
> -{
> -	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
> -	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 104,
> -	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 12;
> -	int err = 0;
> -
> -	err += sn9c102_write_reg(cam, h_start, 0x12);
> -	err += sn9c102_write_reg(cam, v_start, 0x13);
> -
> -	/* Do NOT change! */
> -	err += sn9c102_write_reg(cam, 0x1f, 0x1a);
> -	err += sn9c102_write_reg(cam, 0x1a, 0x1b);
> -	err += sn9c102_write_reg(cam, sn9c102_pread_reg(cam, 0x19), 0x19);
> -
> -	return err;
> -}
> -
> -
> -static int tas5130d1b_set_pix_format(struct sn9c102_device *cam,
> -				     const struct v4l2_pix_format *pix)
> -{
> -	int err = 0;
> -
> -	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X)
> -		err += sn9c102_write_reg(cam, 0x63, 0x19);
> -	else
> -		err += sn9c102_write_reg(cam, 0xf3, 0x19);
> -
> -	return err;
> -}
> -
> -
> -static const struct sn9c102_sensor tas5130d1b = {
> -	.name = "TAS5130D1B",
> -	.maintainer = "Luca Risolia <luca.risolia@studio.unibo.it>",
> -	.supported_bridge = BRIDGE_SN9C101 | BRIDGE_SN9C102,
> -	.sysfs_ops = SN9C102_I2C_WRITE,
> -	.frequency = SN9C102_I2C_100KHZ,
> -	.interface = SN9C102_I2C_3WIRES,
> -	.init = &tas5130d1b_init,
> -	.qctrl = {
> -		{
> -			.id = V4L2_CID_GAIN,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "global gain",
> -			.minimum = 0x00,
> -			.maximum = 0xf6,
> -			.step = 0x02,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -		{
> -			.id = V4L2_CID_EXPOSURE,
> -			.type = V4L2_CTRL_TYPE_INTEGER,
> -			.name = "exposure",
> -			.minimum = 0x00,
> -			.maximum = 0x47,
> -			.step = 0x01,
> -			.default_value = 0x00,
> -			.flags = 0,
> -		},
> -	},
> -	.set_ctrl = &tas5130d1b_set_ctrl,
> -	.cropcap = {
> -		.bounds = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -		.defrect = {
> -			.left = 0,
> -			.top = 0,
> -			.width = 640,
> -			.height = 480,
> -		},
> -	},
> -	.set_crop = &tas5130d1b_set_crop,
> -	.pix_format = {
> -		.width = 640,
> -		.height = 480,
> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
> -		.priv = 8,
> -	},
> -	.set_pix_format = &tas5130d1b_set_pix_format
> -};
> -
> -
> -int sn9c102_probe_tas5130d1b(struct sn9c102_device *cam)
> -{
> -	const struct usb_device_id tas5130d1b_id_table[] = {
> -		{ USB_DEVICE(0x0c45, 0x6024), },
> -		{ USB_DEVICE(0x0c45, 0x6025), },
> -		{ USB_DEVICE(0x0c45, 0x60aa), },
> -		{ }
> -	};
> -
> -	/* Sensor detection is based on USB pid/vid */
> -	if (!sn9c102_match_id(cam, tas5130d1b_id_table))
> -		return -ENODEV;
> -
> -	sn9c102_attach_sensor(cam, &tas5130d1b);
> -
> -	return 0;
> -}
> 
