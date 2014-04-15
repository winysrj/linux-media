Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:40010 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaDOJ1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:27:34 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	t.figa@samsung.com, b.zolnierkie@samsung.com,
	jy0922.shim@samsung.com, rahul.sharma@samsung.com,
	pawel.moll@arm.com, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 0/4] drm: exynos: update/fixes to HDMI driver
Date: Tue, 15 Apr 2014 11:27:16 +0200
Message-id: <1397554040-4037-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,
This patchset adds 4 fixes/updates to EXYNOS DRM driver for
HDMI subsystem.

All comments are welcome.

Regards,
Tomasz Stanislawski

Changelog:

v2:
* fix check with gpio_is_valid()
* use U32_MAX instead of ULONG_MAX to be 64-bit-friendly
* use hdmi_driver_data as hdmi's compatile data

v1:
* initial version

Tomasz Stanislawski (4):
  drm: exynos: hdmi: simplify extracting hpd-gpio from DT
  drm: exynos: mixer: fix using usleep() in atomic context
  drm: exynos: add compatibles for HDMI and Mixer chips and exynos4210
    SoC
  drm: exynos: hdmi: add support for pixel clock limitation

 .../devicetree/bindings/video/exynos_hdmi.txt      |    4 +++
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   30 ++++++++++++++------
 drivers/gpu/drm/exynos/exynos_mixer.c              |    5 +++-
 include/media/s5p_hdmi.h                           |    1 +
 4 files changed, 31 insertions(+), 9 deletions(-)

-- 
1.7.9.5

