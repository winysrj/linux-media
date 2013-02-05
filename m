Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37895 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3BEFcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 00:32:53 -0500
Received: by mail-pa0-f43.google.com with SMTP id bh2so1574817pad.16
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2013 21:32:52 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com
Subject: [PATCH v4 0/1] Adds display-timing node parsing to exynos drm fimd
Date: Tue,  5 Feb 2013 11:02:46 +0530
Message-Id: <1360042367-16397-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds display-timing node parsing to drm fimd, this depends on
the display helper patchset at
http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html

It also adds pinctrl support for drm fimd.

changes since v3:
	- addressed comments from Sean Paul <seanpaul@chromium.org>, to modify
	the return values and print messages.

changes since v2:
	- moved 'devm_pinctrl_get_select_default' function call under
		'if (pdev->dev.of_node)', this makes NON-DT code unchanged.
		(reported by: Rahul Sharma <r.sh.open@gmail.com>)

changes since v1:
	- addressed comments from Sean Paul <seanpaul@chromium.org>

Vikas Sajjan (1):
  video: drm: exynos: Adds display-timing node parsing using video
    helper function

 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   41 +++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

-- 
1.7.9.5

