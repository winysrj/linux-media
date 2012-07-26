Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49924 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2GZLUs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:20:48 -0400
Received: by weyx8 with SMTP id x8so1257392wey.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 04:20:47 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
	g.liakhovetski@gmx.de, sakari.ailus@maxwell.research.nokia.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
	linux@arm.linux.org.uk, kernel@pengutronix.de
Subject: [PATCH 0/4] Fix clocks for i.MX27 in mx2_camera.c
Date: Thu, 26 Jul 2012 13:20:33 +0200
Message-Id: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following series follows the steps purposed by Guennadi
(http://www.spinics.net/lists/arm-kernel/msg185555.html) in
order to fix clock handlings for i.MX27 in mx2_camera.c

[PATCH 1/4] i.MX27: Fix emma-prp and csi clocks.
[PATCH 2/4] media: mx2_camera: Mark i.MX25 support as BROKEN.
[PATCH 3/4] Schedule removal of i.MX25 support in mx2_camera.c
[PATCH 4/4] media: mx2_camera: Fix clock handling for i.MX27.
