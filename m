Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49547 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933710AbeCEJft (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 04:35:49 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: [PATCH 2/7] media: sun6i: Reduce the error level
Date: Mon,  5 Mar 2018 10:35:29 +0100
Message-Id: <20180305093535.11801-3-maxime.ripard@bootlin.com>
In-Reply-To: <20180305093535.11801-1-maxime.ripard@bootlin.com>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
 <20180305093535.11801-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The is_format_support function can be called in the standard format
negociation path with a sensor, where it's expected to have not exactly the
same set of formats available.

Reduce the error logging level when we find a format not supported to not
have a lot of spurious messages.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index 2ec33fb04632..b0ac8a188f92 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -111,15 +111,14 @@ bool sun6i_csi_is_format_support(struct sun6i_csi *csi,
 			case MEDIA_BUS_FMT_YVYU8_1X16:
 				return true;
 			default:
-				dev_warn(sdev->dev,
-					 "Unsupported mbus code: 0x%x\n",
-					 mbus_code);
+				dev_dbg(sdev->dev, "Unsupported mbus code: 0x%x\n",
+					mbus_code);
 				break;
 			}
 			break;
 		default:
-			dev_warn(sdev->dev, "Unsupported pixformat: 0x%x\n",
-				 pixformat);
+			dev_dbg(sdev->dev, "Unsupported pixformat: 0x%x\n",
+				pixformat);
 			break;
 		}
 		return false;
@@ -175,13 +174,13 @@ bool sun6i_csi_is_format_support(struct sun6i_csi *csi,
 		case MEDIA_BUS_FMT_YVYU8_2X8:
 			return true;
 		default:
-			dev_warn(sdev->dev, "Unsupported mbus code: 0x%x\n",
-				 mbus_code);
+			dev_dbg(sdev->dev, "Unsupported mbus code: 0x%x\n",
+				mbus_code);
 			break;
 		}
 		break;
 	default:
-		dev_warn(sdev->dev, "Unsupported pixformat: 0x%x\n", pixformat);
+		dev_dbg(sdev->dev, "Unsupported pixformat: 0x%x\n", pixformat);
 		break;
 	}
 
-- 
2.14.3
