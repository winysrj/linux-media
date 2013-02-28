Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:48815 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3B1EMz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 23:12:55 -0500
Received: by mail-da0-f54.google.com with SMTP id p1so641449dad.41
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 20:12:55 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com, patches@linaro.org,
	linaro-dev@lists.linaro.org, joshi@samsung.com,
	jy0922.shim@samsung.com
Subject: [PATCH v9 0/2] Add display-timing node parsing to exynos drm fimd
Date: Thu, 28 Feb 2013 09:42:40 +0530
Message-Id: <1362024762-28406-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add display-timing node parsing to drm fimd and depends on
the display helper patchset at
http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html

It also adds pinctrl support for drm fimd.

changes since v8:
	- replaced IS_ERR() with IS_ERR_OR_NULL(),
	because devm_pinctrl_get_select_default can return NULL,
	If CONFIG_PINCTRL is disabled.
	- modified the error log, such that it shall NOT cross 80 column.
	- added Acked-by.
changes since v7:
	- addressed comments from Joonyoung Shim <jy0922.shim@samsung.com> 
	to remove a unnecessary variable.

changes since v6:
	addressed comments from Inki Dae <inki.dae@samsung.com> to
	separated out the pinctrl functionality and made a separate patch.

changes since v5:
	- addressed comments from Inki Dae <inki.dae@samsung.com>,
	to remove the allocation of 'fbmode' and replaced
	'-1'in "of_get_fb_videomode(dev->of_node, fbmode, -1)" with
	OF_USE_NATIVE_MODE.

changes since v4:
	- addressed comments from Paul Menzel 
	<paulepanter@users.sourceforge.net>, to modify the commit message

changes since v3:
	- addressed comments from Sean Paul <seanpaul@chromium.org>, to modify
	the return values and print messages.

changes since v2:
	- moved 'devm_pinctrl_get_select_default' function call under
		'if (pdev->dev.of_node)', this makes NON-DT code unchanged.
		(reported by: Rahul Sharma <r.sh.open@gmail.com>)

changes since v1:
	- addressed comments from Sean Paul <seanpaul@chromium.org>


Vikas Sajjan (2):
  video: drm: exynos: Add display-timing node parsing using video
    helper function
  video: drm: exynos: Add pinctrl support to fimd

 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   33 ++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

-- 
1.7.9.5

