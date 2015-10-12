Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44733 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751401AbbJLPkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 11:40:10 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, k.kozlowski@samsung.com,
	laurent.pinchart@ideasonboard.com, hyun.kwon@xilinx.com,
	michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
	gregkh@linuxfoundation.org, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, lars@metafoo.de,
	elfring@users.sourceforge.net, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: [PATCH 1/1] media: Correctly determine whether an entity is a sub-device
Date: Mon, 12 Oct 2015 18:38:23 +0300
Message-Id: <1444664303-18454-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20151011215625.779630d9@recife.lan>
References: <20151011215625.779630d9@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the function of an entity is not one of the pre-defined ones, it is not
correctly recognised as a V4L2 sub-device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index a60872a..76e9a124 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -328,6 +328,7 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 	case MEDIA_ENT_F_LENS:
 	case MEDIA_ENT_F_ATV_DECODER:
 	case MEDIA_ENT_F_TUNER:
+	case MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN:
 		return true;
 
 	default:
-- 
2.1.4

