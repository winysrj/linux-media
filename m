Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:33534 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3BAL75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 06:59:57 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so1714052dak.25
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 03:59:56 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	s.trumtrar@pengutronix.de, inki.dae@samsung.com,
	l.krishna@samsung.com
Subject: [PATCH v3 0/1] Adds display-timing node parsing to exynos drm fimd
Date: Fri,  1 Feb 2013 17:29:48 +0530
Message-Id: <1359719989-29628-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds display-timing node parsing to drm fimd, this depends on
the display helper patchset at
http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html

It also adds pinctrl support for drm fimd.

changes since v2:
	- moved 'devm_pinctrl_get_select_default' function call under
		'if (pdev->dev.of_node)', this makes NON-DT code unchanged.
		(reported by: Rahul Sharma <r.sh.open@gmail.com>)

changes since v1:
	- addressed comments from Sean Paul <seanpaul@chromium.org>

patch is based on branch "exynos-drm-next" at
http://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git

Is tested on Exynos5250 and Exynos4412 by applying dependent patches available
at http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html

Vikas Sajjan (1):
  video: drm: exynos: Adds display-timing node parsing using video
    helper function

 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   39 +++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 4 deletions(-)

-- 
1.7.9.5

