Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36609 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3BGRim (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:38:42 -0500
Received: by mail-ea0-f176.google.com with SMTP id a13so1189433eaa.7
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 09:38:40 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 00/13] em28xx: ioctl fixes/clean-ups
Date: Thu,  7 Feb 2013 18:39:08 +0100
Message-Id: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series addresses some issues with the ioctl code of the em28xx driver:
Patches 1-5 and 11+12 fix and clean up the enabling/disabling of the ioctls 
depending on the device type and equipment.
Patches 6-10 remove some obsolete/useless code.
Patch 13 improves the VBI support detection and device node registration.

Changes since v1:
- added patch 11

Frank Schäfer (13):
  em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_QUERYSTD,
    VIDIOC_G/S_STD
  em28xx: disable tuner related ioctls for video and VBI devices
    without tuner
  em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_G_AUDIO and
    VIDIOC_S_AUDIO
  em28xx: use v4l2_disable_ioctl() to disable ioctl VIDIOC_S_PARM
  em28xx: disable ioctl VIDIOC_S_PARM for VBI devices
  em28xx: make ioctls VIDIOC_G/S_PARM working for VBI devices
  em28xx: remove ioctl VIDIOC_CROPCAP
  em28xx: get rid of duplicate function vidioc_s_fmt_vbi_cap()
  em28xx: VIDIOC_G_TUNER: remove unneeded setting of tuner type
  em28xx: remove obsolete device state checks from the ioctl functions
  em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available without
    CONFIG_VIDEO_ADV_DEBUG selected
  em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available for radio
    devices
  em28xx: do not claim VBI support if the device is a camera

 drivers/media/usb/em28xx/em28xx-core.c  |    5 +
 drivers/media/usb/em28xx/em28xx-video.c |  178 ++++++++-----------------------
 2 Dateien geändert, 52 Zeilen hinzugefügt(+), 131 Zeilen entfernt(-)

-- 
1.7.10.4

