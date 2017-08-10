Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:46486 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbdHJWL3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 18:11:29 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH 3/5] [media] cx25840: fix a possible divide by zero in set_fmt
 callback
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Message-ID: <b9ea3663-a4fd-83a7-8053-488450f5096b@maciej.szmigiero.name>
Date: Thu, 10 Aug 2017 23:52:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If set_fmt callback is called with format->width or format->height set to
zero and HACTIVE_CNT or VACTIVE_CNT bits (respectively) in chip are zero
we will divide by zero later in this callback when we try to calculate
HSC or VSC values.

Fix this by explicitly rejecting these values.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 2fa74c23d619..c19f39821f46 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1691,8 +1691,9 @@ static int cx25840_set_fmt(struct v4l2_subdev *sd,
 	 * height. Without that margin the cx23885 fails in this
 	 * check.
 	 */
-	if ((fmt->width * 16 < Hsrc) || (Hsrc < fmt->width) ||
-			(Vlines * 8 < Vsrc) || (Vsrc + 1 < Vlines)) {
+	if ((fmt->width == 0) || (Vlines == 0) ||
+	    (fmt->width * 16 < Hsrc) || (Hsrc < fmt->width) ||
+	    (Vlines * 8 < Vsrc) || (Vsrc + 1 < Vlines)) {
 		v4l_err(client, "%dx%d is not a valid size!\n",
 				fmt->width, fmt->height);
 		return -ERANGE;
