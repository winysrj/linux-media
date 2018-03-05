Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49563 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933714AbeCEJfu (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 5/7] media: sun6i: Support the YUYV format properly
Date: Mon,  5 Mar 2018 10:35:32 +0100
Message-Id: <20180305093535.11801-6-maxime.ripard@bootlin.com>
In-Reply-To: <20180305093535.11801-1-maxime.ripard@bootlin.com>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
 <20180305093535.11801-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, if we ever start a capture using the YUYV format, the switch
case in the get_csi_input_seq function will not catch it since it considers
it the default case.

However, that switch default also calls dev_warn to log an error, which is
this case will be either an unsupported format, or the YUYV format.

Obviously, the latter creates a spurious message. Make sure this isn't the
case.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index 9a25aad8b6b1..e0b39ea641aa 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -357,6 +357,10 @@ static enum csi_input_seq get_csi_input_seq(struct sun6i_csi_dev *sdev,
 			break;
 		}
 		break;
+
+	case V4L2_PIX_FMT_YUYV:
+		return CSI_INPUT_SEQ_YUYV;
+
 	default:
 		dev_warn(sdev->dev, "Unsupported pixformat: 0x%x, defaulting to YUYV\n",
 			 pixformat);
-- 
2.14.3
