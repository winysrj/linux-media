Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:48965 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751833AbdGHUlK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Jul 2017 16:41:10 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
From: "Jasmin J." <jasmin@anw.at>
Subject: media-build breaks for Kernel 3.13
Message-ID: <ff9884c5-b5b2-b7bd-9a60-e499e480b9eb@anw.at>
Date: Sat, 8 Jul 2017 22:41:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I tried to compile the last media master for Kernel 3.13 (Ubuntu 14.04) and get
errors during the patch step:
tar xfj linux-media.tar.bz2
 rm -f .patches_applied .linked_dir .git_log.md5
 make -C /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l stagingconfig
 make[1]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l'
 make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Applying patches for kernel 3.13.0-117-generic
 patch -s -f -N -p1 -i ../backports/api_version.patch
 patch -s -f -N -p1 -i ../backports/pr_fmt.patch
 1 out of 1 hunk FAILED
 Makefile:138: recipe for target 'apply_patches' failed
 make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Makefile:388: recipe for target 'stagingconfig' failed
 make[1]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l'
 Makefile:26: recipe for target 'stagingconfig' failed
 Disabling CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 Disabling CONFIG_DVB_DDBRIDGE_MSIENABLE
 Disabling CONFIG_VIDEOBUF2_MEMOPS
 Disabling CONFIG_FRAME_VECTOR
 Disabling CONFIG_DVB_AF9033
 Disabling CONFIG_VIDEO_ET8EK8
 Disabling CONFIG_VIDEO_DW9714
 Disabling CONFIG_SDR_MAX2175
 Disabling CONFIG_VIDEO_VIMC
 Setting CONFIG_DVB_MAX_ADAPTERS to 32
 make -C /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l
 make[1]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l'
 scripts/make_makefile.pl
 Updating/Creating .config
 make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 make[3]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 make[3]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Unapplying patches
 Unapplying patches
 patch -s -f -R -p1 -i ../backports/api_version.patch
 patch -s -f -R -p1 -i ../backports/api_version.patch
 make[3]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Applying patches for kernel 3.13.0-117-generic
 make[3]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Applying patches for kernel 3.13.0-117-generic
 Applying patches for kernel 3.13.0-117-generic
 make[3]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Applying patches for kernel 3.13.0-117-generic
 patch -s -f -N -p1 -i ../backports/api_version.patch
 patch -s -f -N -p1 -i ../backports/api_version.patch
 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/cec/cec-api.c.rej
 2 out of 2 hunks FAILED -- saving rejects to file drivers/media/media-device.c.rej
 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/usb/uvc/uvc_driver.c.rej
 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/v4l2-core/v4l2-ioctl.c.rej
 patch -s -f -N -p1 -i ../backports/pr_fmt.patch
 patch -s -f -N -p1 -i ../backports/pr_fmt.patch
 1 out of 1 hunk FAILED
 1 out of 1 hunk FAILED
 Makefile:138: recipe for target 'apply_patches' failed
 Makefile:138: recipe for target 'apply_patches' failed
 make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Preparing to compile for kernel version 3.13.0
 WARNING: This is the V4L/DVB backport tree, with experimental drivers
      backported to run on legacy kernels from the development tree at:
         http://git.linuxtv.org/media-tree.git.
      It is generally safe to use it for testing a new driver or
      feature, but its usage on production environments is risky.
      Don't use it in production. You've been warned.
 CEC_CORE: Requires at least kernel 3.19.0
 MEDIA_CEC_SUPPORT: Requires at least kernel 3.19.0
 V4L2_FLASH_LED_CLASS: Requires at least kernel 4.2.0
 RC_ST: Requires at least kernel 3.15.0
Created default (all yes) .config file
 ./scripts/make_myconfig.pl
 perl scripts/make_config_compat.pl /lib/modules/3.13.0-117-generic/build ./.myconfig ./config-compat.h
 make -C firmware prep
 creating symbolic links...
 make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/firmware'
 make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/firmware'
 make -C firmware
 make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/firmware'
   CC  ihex2fw
 Generating ttusb-budget/dspbootcode.bin
 Generating vicam/firmware.fw
 Generating cpia2/stv0672_vp4.bin
 Generating av7110/bootcode.bin
 make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/firmware'
 Kernel build directory is /lib/modules/3.13.0-117-generic/build
 make -C ../linux apply_patches
 make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 make[3]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Unapplying patches
 patch -s -f -R -p1 -i ../backports/api_version.patch
 patch -s -f -R -p1 -i ../backports/api_version.patch
 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/cec/cec-api.c.rej
 2 out of 2 hunks FAILED -- saving rejects to file drivers/media/media-device.c.rej
 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/usb/uvc/uvc_driver.c.rej
 1 out of 1 hunk FAILED -- saving rejects to file drivers/media/v4l2-core/v4l2-ioctl.c.rej
 make[3]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Applying patches for kernel 3.13.0-117-generic
 patch -s -f -N -p1 -i ../backports/api_version.patch
 patch -s -f -N -p1 -i ../backports/pr_fmt.patch
 1 out of 1 hunk FAILED
 Makefile:138: recipe for target 'apply_patches' failed
 make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
 Makefile:51: recipe for target 'default' failed
 make[1]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l'
 Makefile:26: recipe for target 'all' failed

May I ask when I can expect this get fixed?
I mean, is someone working on that already?

BR,
   Jasmin
