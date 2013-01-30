Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61262 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3A3Ga5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 01:30:57 -0500
Received: by mail-pb0-f47.google.com with SMTP id rp8so774193pbb.20
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 22:30:56 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	s.trumtrar@pengutronix.de, inki.dae@samsung.com,
	l.krishna@samsung.com
Subject: [PATCH v2 0/1] Adds display-timing node parsing to exynos drm fimd
Date: Wed, 30 Jan 2013 12:00:48 +0530
Message-Id: <1359527449-5174-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds display-timing node parsing to drm fimd, this depends on
the display helper patchset at
http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html

It also adds pinctrl support for drm fimd.

patch is based on branch "exynos-drm-next" at
http://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git

Is tested on Exynos5250 and Exynos4412 by applying dependent patches available
at http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html

Vikas Sajjan (1):
  video: drm: exynos: Adds display-timing node parsing using video
    helper function

 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   38 +++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

-- 
1.7.9.5

