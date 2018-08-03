Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57196 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732083AbeHCQcm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 12:32:42 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] media: dvb-usb: fix spelling mistake: "completition" -> "completion"
Date: Fri,  3 Aug 2018 15:36:01 +0100
Message-Id: <20180803143601.4211-5-colin.king@canonical.com>
In-Reply-To: <20180803143601.4211-1-colin.king@canonical.com>
References: <20180803143601.4211-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in debug and error messages

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/dvb-usb/usb-urb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/usb-urb.c b/drivers/media/usb/dvb-usb/usb-urb.c
index 5e05963f4220..9771f0954c69 100644
--- a/drivers/media/usb/dvb-usb/usb-urb.c
+++ b/drivers/media/usb/dvb-usb/usb-urb.c
@@ -33,7 +33,7 @@ static void usb_urb_complete(struct urb *urb)
 		case -ESHUTDOWN:
 			return;
 		default:        /* error */
-			deb_ts("urb completition error %d.\n", urb->status);
+			deb_ts("urb completion error %d.\n", urb->status);
 			break;
 	}
 
@@ -57,7 +57,7 @@ static void usb_urb_complete(struct urb *urb)
 				stream->complete(stream, b, urb->actual_length);
 			break;
 		default:
-			err("unknown endpoint type in completition handler.");
+			err("unknown endpoint type in completion handler.");
 			return;
 	}
 	usb_submit_urb(urb,GFP_ATOMIC);
-- 
2.17.1
