Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031075AbbD1XGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:06:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 13/13] vivid-radio-rx: Don't go past buffer
Date: Tue, 28 Apr 2015 20:06:20 -0300
Message-Id: <c3004eee94a40cdfaf51b50dad464c25bc974e54.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
References: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/vivid/vivid-radio-rx.c:198 vivid_radio_rx_s_hw_freq_seek() error: buffer overflow 'vivid_radio_bands' 3 <= 3

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/vivid/vivid-radio-rx.c b/drivers/media/platform/vivid/vivid-radio-rx.c
index c7651a506668..f99092ca8f5c 100644
--- a/drivers/media/platform/vivid/vivid-radio-rx.c
+++ b/drivers/media/platform/vivid/vivid-radio-rx.c
@@ -195,6 +195,8 @@ int vivid_radio_rx_s_hw_freq_seek(struct file *file, void *fh, const struct v4l2
 			if (dev->radio_rx_freq >= vivid_radio_bands[band].rangelow &&
 			    dev->radio_rx_freq <= vivid_radio_bands[band].rangehigh)
 				break;
+		if (band == TOT_BANDS)
+			return -EINVAL;
 		low = vivid_radio_bands[band].rangelow;
 		high = vivid_radio_bands[band].rangehigh;
 	}
-- 
2.1.0

