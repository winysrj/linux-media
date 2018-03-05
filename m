Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49561 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933713AbeCEJfu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 04:35:50 -0500
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
Subject: [PATCH 4/7] media: sun6i: Don't emit a warning when the configured format isn't found
Date: Mon,  5 Mar 2018 10:35:31 +0100
Message-Id: <20180305093535.11801-5-maxime.ripard@bootlin.com>
In-Reply-To: <20180305093535.11801-1-maxime.ripard@bootlin.com>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
 <20180305093535.11801-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the driver will call WARN when a format isn't available,
resulting in a kernel backtrace in our logs. This makes it look much more
serious than it should be.

Replace the call to the WARN macro to a dev_warn, which will still allow us
to log what happened without making it too dramatic.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index f10c3bc2a6c5..9a25aad8b6b1 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -299,7 +299,7 @@ static enum csi_output_fmt get_csi_output_format(struct sun6i_csi_dev *sdev,
 		return buf_interlaced ? CSI_FRAME_PLANAR_YUV422 :
 					CSI_FIELD_PLANAR_YUV422;
 	default:
-		WARN(1, "Unsupported pixformat: 0x%x\n", pixformat);
+		dev_warn(sdev->dev, "Unsupported pixformat: 0x%x\n", pixformat);
 		break;
 	}
 
@@ -330,7 +330,8 @@ static enum csi_input_seq get_csi_input_seq(struct sun6i_csi_dev *sdev,
 		case MEDIA_BUS_FMT_YVYU8_2X8:
 			return CSI_INPUT_SEQ_YVYU;
 		default:
-			WARN(1, "Unsupported mbus code: 0x%x\n", mbus_code);
+			dev_warn(sdev->dev, "Unsupported mbus code: 0x%x\n",
+				 mbus_code);
 			break;
 		}
 		break;
@@ -351,12 +352,14 @@ static enum csi_input_seq get_csi_input_seq(struct sun6i_csi_dev *sdev,
 		case MEDIA_BUS_FMT_YVYU8_2X8:
 			return CSI_INPUT_SEQ_YUYV;
 		default:
-			WARN(1, "Unsupported mbus code: 0x%x\n", mbus_code);
+			dev_warn(sdev->dev, "Unsupported mbus code: 0x%x\n",
+				 mbus_code);
 			break;
 		}
 		break;
 	default:
-		WARN(1, "Unsupported pixformat: 0x%x\n", pixformat);
+		dev_warn(sdev->dev, "Unsupported pixformat: 0x%x, defaulting to YUYV\n",
+			 pixformat);
 		break;
 	}
 
-- 
2.14.3
