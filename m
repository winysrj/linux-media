Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41672 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2CZNR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:17:57 -0400
Received: by wibhq7 with SMTP id hq7so4390491wib.1
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:17:56 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	u.kleine-koenig@pengutronix.de, mchehab@infradead.org,
	kernel@pengutronix.de, baruch@tkos.co.il
Subject: [PATCH v2 0/3] media: tvp5150: Fix mbus format to UYUV instead of YUYV.
Date: Mon, 26 Mar 2012 15:17:45 +0200
Message-Id: <1332767868-2531-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v2:
- Swap order of patches 3 and 4 to make the series bisectable.

[PATCH v2 1/3] media: tvp5150: Fix mbus format.
[PATCH v2 2/3] i.MX27: visstrim_m10: Remove use of MX2_CAMERA_SWAP16.
[PATCH v2 3/3] media: mx2_camera: Fix mbus format handling.
