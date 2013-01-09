Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:39655 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab3AIJoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 04:44:16 -0500
Received: by mail-da0-f53.google.com with SMTP id x6so661965dac.26
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2013 01:44:15 -0800 (PST)
From: Vikas C Sajjan <vikas.sajjan@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: inki.dae@samsung.com, laurent.pinchart@ideasonboard.com,
	tomi.valkeinen@ti.com, jesse.barker@linaro.org,
	aditya.ps@samsung.com, t.figa@samsung.com
Subject: [PATCH] Make s6e8ax0 panel driver compliant with CDF
Date: Wed,  9 Jan 2013 15:14:03 +0530
Message-Id: <1357724644-26194-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vikas Sajjan <vikas.sajjan@linaro.org>

Have made necessary chanages in s6e8ax0 panel driver, made an effort to remove
dependency on backlight and lcd framework, but its NOT fully done.

s6e8ax0_get_brightness() and s6e8ax0_set_brightness() functionalities have NOT
been modified. as backlight support in CDF are _NOT_ implemented yet.
Thought of adding these "get and set" as part of display_entity_control_ops(), 
but didn't modify as of now. Any thoughts on the same will be helpful.

removed the lcd_ops "set_power and get_power" and added as part of 
panel_set_state.

I _SHALL_ test these modificaions once i get the s6e8ax0 panel.

Vikas Sajjan (1):
  [RFC]: video: exynos: Making s6e8ax0 panel driver compliant with CDF

 drivers/video/exynos/s6e8ax0.c |  582 ++++++++++++++++++++++------------------
 1 file changed, 314 insertions(+), 268 deletions(-)

-- 
1.7.9.5

