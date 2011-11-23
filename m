Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33965 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1KWPOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 10:14:10 -0500
Received: by bke11 with SMTP id 11so1696573bke.19
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 07:14:09 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de
Subject: [PATCH v3 0/2] Add support form eMMa-PrP in i.MX2 chips as a mem2mem device.
Date: Wed, 23 Nov 2011 16:13:45 +0100
Message-Id: <1322061227-6631-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i.MX2x SoCs have a PrP which is capable of resizing and format
conversion of video frames. This driver provides support for
resizing and format conversion from YUYV to YUV420.

This operation is of the utmost importance since some of these
SoCs like i.MX27 include an H.264 video codec which only
accepts YUV420 as input.


[PATCH v3 1/2] MX2: Add platform definitions for eMMa-PrP device.
[PATCH v3 2/2] MEM2MEM: Add support for eMMa-PrP mem2mem operations.
