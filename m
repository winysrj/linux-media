Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:50968 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab3BMKBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 05:01:20 -0500
Received: by mail-da0-f44.google.com with SMTP id z20so483157dae.31
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 02:01:20 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com, joshi@samsung.com,
	aditya.ps@samsung.com, tom.gall@linaro.org, patches@linaro.org,
	linux-samsung-soc@vger.kernel.org, ragesh.r@linaro.org,
	jesse.barker@linaro.org, robdclark@gmail.com,
	sumit.semwal@linaro.org
Subject: [RFC v2 0/3] Support Common Display Framework on Exynos5 SoC
Date: Wed, 13 Feb 2013 15:31:04 +0530
Message-Id: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changes since v1:
Since v1 was not tested when I posted it, now that I have the s6e8aa0 panel, I 
tested the same on Exynos5 SoC. Needed to make below mentioned changes to make 
it work.

In exynos mipi driver:
	1> added "enable_hs" as part of "dsi_video_source_ops", as this function
	needs to be called from the s6e8aa0 panel probe after LCD "power_on".

	2> moved the call exynos_mipi_dsi_set_hs_enable()
	out of the exynos_mipi_update_cfg() function as it needs to be called only
	after the LCD "power_on". hence in s6e8aa0 probe added call "enable_hs" 
	after "power_on". otherwise DSI COMMAND TIME OUT error occurs, after
	sending WRITE COMMAND.
	Prior to CDF changes, things used to work fine, as the panel 
	used to register with MIPI DSIM driver and in the MIPI DSI probe used to 
	call LCD "power_on" first and then "exynos_mipi_dsi_set_hs_enable".
	Since the CDF support is introduced, the both panel and mipi dsi probe
	happens independently and DSI COMMAND TIME OUT error used to occurs, after
	sending WRITE COMMAND. by making above mentioned changes it started working.

In s6e8ax0 driver:
	1> added call "enable_hs" in probe after "power_on", to over come above 
	mentioned error.
	2> addd init_lcd(), the missing sequence to initialise the lcd.

This patch series contains 3 patches with the following changes

is based on CDF-T proposed by Tomi Valkeinen <tomi.valkeinen@ti.com>
http://lwn.net/Articles/529489/

[PATCH 1/3] video: display: Adding frame related ops to MIPI DSI video source struct
		Adds the frame related ops to the MIPI DSI video source struct

[PATCH 2/3] video: exynos: mipi dsi: Making Exynos MIPI Compliant with CDF
		Makes the Exynos MIPI DSI driver compliant with CDF.
	
[PATCH 3/3] video: exynos: Making s6e8ax0 panel driver compliant with CDF

	Makes the Exynos s6e8ax0 panel driver compliant with CDF.
	Have made necessary changes in s6e8ax0 panel driver, made an effort to 
	remove dependency on backlight and lcd framework, but its NOT fully done.
	s6e8ax0_get_brightness() and s6e8ax0_set_brightness() functionalities
	have NOT been modified. as backlight support in CDF are _NOT_
	implemented yet.
	Thought of adding these "get and set" as part of 
	display_entity_control_ops(), but didn't modify as of now.
	Any thoughts on the same will be helpful.
	removed the lcd_ops "set_power and get_power" and added as part of 
	panel_set_state.

Testing: 
	Tested on Exynos5 SoC with s6e8aa0 panel connected, by applying some of
	the dependent patches
	Could see the linux logo and ran "modetest" application and saw the 
	test pattern on display panel.

Vikas Sajjan (3):
  video: display: Adding frame related ops to MIPI DSI video source
    struct
  video: exynos: mipi dsi: Making Exynos MIPI Compliant with CDF
  video: exynos: Making s6e8ax0 panel driver compliant with CDF

 drivers/video/exynos/exynos_mipi_dsi.c        |  197 ++----
 drivers/video/exynos/exynos_mipi_dsi_common.c |   22 +-
 drivers/video/exynos/exynos_mipi_dsi_common.h |   12 +-
 drivers/video/exynos/s6e8ax0.c                |  848 +++++++++++++------------
 include/video/display.h                       |    6 +
 include/video/exynos_mipi_dsim.h              |    5 +-
 6 files changed, 519 insertions(+), 571 deletions(-)

-- 
1.7.9.5

