Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:32910 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab2GFM6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 08:58:04 -0400
Received: by wgbds11 with SMTP id ds11so660442wgb.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 05:58:02 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	shawn.guo@linaro.org, fabio.estevam@freescale.com,
	richard.zhu@linaro.org, arnaud.patard@rtp-net.org,
	kernel@pengutronix.de, mchehab@infradead.org,
	p.zabel@pengutronix.de
Subject: [PATCH 0/3] Add support for 'Coda' video codec IP.
Date: Fri,  6 Jul 2012 14:57:48 +0200
Message-Id: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch provides support for the codadx6 that is inside
the i.MX27. Currently only H.264 and MPEG4 Part-2 encoding
operations are supported.

This is a refined version of the RFC sent two weeks ago [1].
The following tasks have been addressed since then:
 - Get rid of 'runtime' structure.
 - Device tree support (not tested).
 - Merge all the code in a single source file.
 - Use one node for both encoding and decoding.
 - Multi-instance support (not tested for more than one instance).
 - Prepare the code so that integration of further coda versions is easier.

This patch takes into account recommendations from Sascha and Philipp
from Pengutronix.

[PATCH 1/3] i.MX: coda: Add platform support for coda in i.MX27.
[PATCH 2/3] media: coda: Add driver for Coda video codec.
[PATCH 3/3] Visstrim M10: Add support for Coda.


[1] http://patchwork.linuxtv.org/patch/12977/
