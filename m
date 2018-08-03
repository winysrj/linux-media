Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57194 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732188AbeHCQcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 12:32:41 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] media: cx231xx: fix spelling mistake: "completition" -> "completion"
Date: Fri,  3 Aug 2018 15:35:59 +0100
Message-Id: <20180803143601.4211-3-colin.king@canonical.com>
In-Reply-To: <20180803143601.4211-1-colin.king@canonical.com>
References: <20180803143601.4211-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_dbg debug messages

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c | 4 ++--
 drivers/media/usb/cx231xx/cx231xx-vbi.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 0025187c28e3..32ee7b3f21c9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -112,7 +112,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		dev_dbg(dev->dev, "urb completition error %d.\n",
+		dev_dbg(dev->dev, "urb completion error %d.\n",
 			urb->status);
 		break;
 	}
@@ -203,7 +203,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		dev_dbg(dev->dev, "urb completition error %d.\n",
+		dev_dbg(dev->dev, "urb completion error %d.\n",
 			urb->status);
 		break;
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 920417baf893..10b2eb7338ad 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -317,7 +317,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 		return;
 	default:		/* error */
 		dev_err(dev->dev,
-			"urb completition error %d.\n",	urb->status);
+			"urb completion error %d.\n", urb->status);
 		break;
 	}
 
-- 
2.17.1
