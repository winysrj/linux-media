Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48526 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab3BGLj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 06:39:58 -0500
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	alsa-devel@alsa-project.org, linux-fbdev@vger.kernel.org
Cc: tomi.valkeinen@ti.com, laurent.pinchart@ideasonboard.com,
	broonie@opensource.wolfsonmicro.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, r.sh.open@gmail.com, joshi@samsung.com
Subject: [RFC PATCH v2 0/5] exynos-hdmi to CDF compliant display driver
Date: Thu, 07 Feb 2013 06:59:32 -0500
Message-id: <1360238377-14806-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V2:
1) Adding hdmi sound card using cdf based hdmi audio codec.
2) DAPM and JACK control to hdmi codec.
3) Offload event handler by adding work queue.
4) Rework based on v1 comments.

Tested for:
1) Mode setting and switching using modetest.
2) Video with HPD and Power related scenarios.
3) Audio playback with Hotplug-Scenarios.
4) DAPM control for hdmi playback.

Pending:
1) Not moved exynos_hdmi to driver/video/display since it will make it
difficult to analyze the code changes.

V1:
This patch set is a proposal to change Exynos Drm Hdmi driver to a CDF
complaint panel driver. This migration serves 2 purposes. One is to eliminate
duplication due to v4l and drm hdmi drivers. Second is to add support for Hdmi
audio ALSA codec which is not possible with drm/v4l hdmi driver (specially for
exynos as hdmi audio and hdmi core registers are intermixed.).

This patch series is based on the Second RFC of CDF from Laurent Pinchart,
(http://lists.freedesktop.org/archives/dri-devel/2012-November/030888.html)
applied to 'for-next' branch at
git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git.

[PATCH 1/4] video: display: add event handling, set mode and hdmi ops to cdf
core

This patch adds:
1) Event Notification to CDF Core:
	Adds simple event notification mechanism supports multiple
	subscribers. This is used for hot-plug notification to the clients
	of hdmi display i.e. exynos-drm and alsa-codec. CDF Core maintains
	multiple subscriber list. When entity reports a event Core will
	route it to all of them. Un-subscription is not implemented which
	can be done if notification callback is Null.

2) set_mode to generic ops:
	It is meaningful for a panel like hdmi which supports multiple
	resolutions.

	HDMI needs conversion of Display Modes to Standard Display Timings.
	Though, it can be done within the driver but seems more meaningful
	if set_mode is called with Timing Details provided by CDF Core.

3) Provision for platform specific interfaces through void *private in display
entity:

	It has added void *private to display entity which can be used to
	expose interfaces which are very much specific to a particular platform.

	In exynos, hpd is connected to the soc via gpio bus. During initial
	hdmi poweron, hpd interrupt is not raised as there is no change in the
	gpio status. This is solved by providing a platform specific interface
	which is queried by the drm to get the hpd state. This interface may
	not be required by all platforms.

4) hdmi ops:
	get_edid: to query raw EDID data and length from the panel.
	check_mode: To check if a given mode is supported by exynos HDMI IP
			"AND" Connected HDMI Sink (tv/monitor).
	init_audio: Configure hdmi audio registers for Audio interface type
	(i2s/ spdif), SF, Audio Channels, BPS.
	set_audiostate: enable disable audio.

[PATCH 2/4] drm/edid: temporarily exposing generic edid-read interface from drm

It exposes generic interface from drm_edid.c to get the edid data and length
by any display entity. Once I get clear idea about edid handling in CDF, I need
to revert these temporary changes.

[PATCH 3/4] drm/exynos: moved drm hdmi driver to cdf framework

This patch implements exynos_hdmi_cdf.c which is a glue component between
exynos DRM and hdmi cdf panel. It is a platform driver register through
exynos_drm_drv.c. Exynos_hdmi.c is modified to register hdmi as display panel.
exynos_hdmi_cdf.c registers for exynos hdmi display entity and if successful,
proceeds for mode setting.

[PATCH 4/4] alsa/soc: add hdmi audio codec based on cdf

It registers hdmi-audio codec to the ALSA framework. This is the second client
to the hdmi panel. Once notified by the CDF Core it proceeds towards audio
setting and audio control. It also subscribes for hpd notification to implement
hpd related audio requirements.

Rahul Sharma (5):
  video: display: add event handling, set mode and hdmi ops to cdf core
  drm/edid: temporarily exposing generic edid-read interface from drm
  drm/exynos: moved drm hdmi driver to cdf framework
  alsa/soc: add hdmi audio codec based on cdf
  alsa/soc: add hdmi audio card using cdf based hdmi codec

 drivers/gpu/drm/drm_edid.c               |  88 ++++++
 drivers/gpu/drm/exynos/Kconfig           |   6 +
 drivers/gpu/drm/exynos/Makefile          |   1 +
 drivers/gpu/drm/exynos/exynos_drm_drv.c  |  24 ++
 drivers/gpu/drm/exynos/exynos_drm_drv.h  |   1 +
 drivers/gpu/drm/exynos/exynos_hdmi.c     | 445 ++++++++++++++++---------------
 drivers/gpu/drm/exynos/exynos_hdmi_cdf.c | 370 +++++++++++++++++++++++++
 drivers/video/display/display-core.c     |  85 ++++++
 include/video/display.h                  | 111 +++++++-
 include/video/exynos_hdmi.h              |  25 ++
 sound/soc/codecs/Kconfig                 |   3 +
 sound/soc/codecs/Makefile                |   2 +
 sound/soc/codecs/exynos_hdmi_audio.c     | 424 +++++++++++++++++++++++++++++
 sound/soc/samsung/Kconfig                |   8 +
 sound/soc/samsung/Makefile               |   2 +
 sound/soc/samsung/hdmi.c                 | 260 ++++++++++++++++++
 16 files changed, 1638 insertions(+), 217 deletions(-)
 create mode 100644 drivers/gpu/drm/exynos/exynos_hdmi_cdf.c
 create mode 100644 include/video/exynos_hdmi.h
 create mode 100644 sound/soc/codecs/exynos_hdmi_audio.c
 create mode 100644 sound/soc/samsung/hdmi.c

-- 
1.8.0

