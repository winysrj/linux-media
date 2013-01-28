Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47615 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3A1Fpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 00:45:44 -0500
Received: by mail-pa0-f44.google.com with SMTP id hz11so1300824pad.31
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2013 21:45:44 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	s.trumtrar@pengutronix.de, inki.dae@samsung.com,
	l.krishna@samsung.com
Subject: [PATCH] Adds display-timing node parsing to exynos drm fimd as per
Date: Mon, 28 Jan 2013 11:15:35 +0530
Message-Id: <1359351936-20618-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds display-timing node parsing to drm fimd, this depends on
the display helper patchset at
http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33354.html

It also adds pinctrl support for drm fimd.

patch is based on branch "exynos-drm-next" at
http://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git

It is tested on Exynos4412 board by applying dependent patches available at
http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33354.html

Vikas Sajjan (1):
  video: drm: exynos: Adds display-timing node parsing using video
    helper function

 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   35 ++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

-- 
1.7.9.5

