Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46831 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3ABNRd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 08:17:33 -0500
Received: by mail-pb0-f52.google.com with SMTP id ro2so7820839pbb.11
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 05:17:33 -0800 (PST)
From: Vikas C Sajjan <vikas.sajjan@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: inki.dae@samsung.com, laurent.pinchart@ideasonboard.com,
	tomi.valkeinen@ti.com, jesse.barker@linaro.org,
	aditya.ps@samsung.com
Subject: [PATCH 0/2] Making Exynos MIPI Complaint with Common Display Framework
Date: Wed,  2 Jan 2013 18:47:20 +0530
Message-Id: <1357132642-24588-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vikas Sajjan <vikas.sajjan@linaro.org>

This patchset contains 2 RFCs, 1st RFC has modiifications in exynos MIPI DSI
driver.

2nd RFC has additions done to video source struct as per exynos requirements.
I have NOT tested the patch yet, as i am yet recieve the MIPI DSI panel.
This based on Tomi's CDF RFC.

I am yet to modify s6e8ax0.c as per CDF and I have NOT tested these patches yet,
as i am yet recieve the MIPI DSI panel.

Vikas Sajjan (2):
  [RFC] video: exynos mipi dsi: Making Exynos MIPI Complaint with CDF
  [RFC] video: display: Adding frame related ops to MIPI DSI video
    source struct

 drivers/video/exynos/exynos_mipi_dsi.c        |   46 ++++++++++++++++++-------
 drivers/video/exynos/exynos_mipi_dsi_common.c |   22 ++++++++----
 drivers/video/exynos/exynos_mipi_dsi_common.h |   12 +++----
 include/video/display.h                       |    6 ++++
 include/video/exynos_mipi_dsim.h              |    5 ++-
 5 files changed, 62 insertions(+), 29 deletions(-)

-- 
1.7.9.5

