Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:57667 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3CIAKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 19:10:35 -0500
Received: by mail-da0-f49.google.com with SMTP id t11so233670daj.22
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2013 16:10:34 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com,
	linaro-kernel@lists.linaro.org
Subject: [PATCH v13 0/2] Add display-timing node parsing to exynos drm fimd
Date: Sat,  9 Mar 2013 05:40:18 +0530
Message-Id: <1362787820-5305-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add display-timing node parsing to drm fimd and depends on
the display helper patchset at
http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html

changes since v12:
	- Added dependency of "OF" for exynos drm fimd as suggested
	by Inki Dae <inki.dae@samsung.com>

changes since v11:
	- Oops, there was a build error, fixed that.

changes since v10:
	- abandoned the pinctrl patch, as commented by Linus Walleij
	<linus.walleij@linaro.org>
	- added new patch to enable the OF_VIDEOMODE and FB_MODE_HELPERS for
	EXYNOS DRM FIMD.

changes since v9:
        - replaced IS_ERR_OR_NULL() with IS_ERR(), since IS_ERR_OR_NULL()
        will be depreciated, as discussed at
        http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/140543.html
        http://www.mail-archive.com/linux-omap@vger.kernel.org/msg78030.html

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
  drm/exynos: enable OF_VIDEOMODE and FB_MODE_HELPERS for exynos drm
    fimd

 drivers/gpu/drm/exynos/Kconfig           |    4 +++-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   24 ++++++++++++++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

-- 
1.7.9.5

