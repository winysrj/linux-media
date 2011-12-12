Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54264 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1LLLoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 06:44:03 -0500
Received: by qcqz2 with SMTP id z2so3432630qcq.19
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 03:44:02 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	shawn.guo@linaro.org, richard.zhao@linaro.org,
	fabio.estevam@freescale.com, kernel@pengutronix.de,
	s.hauer@pengutronix.de, r.schwebel@pengutronix.de
Subject: [PATCH v4 0/2] Add support form eMMa-PrP in i.MX2 chips as a mem2mem device.
Date: Mon, 12 Dec 2011 12:43:43 +0100
Message-Id: <1323690225-15799-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v3:
 Patch order inverted as requested by Mauro.
 Now adjusting of the image dimensions is made using  v4l_bound_align_image().
 Some coding style fixes.

