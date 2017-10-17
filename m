Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:48186 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756394AbdJQG1h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 02:27:37 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: [PATCH][MEDIA]i.MX6 CSI: Fix MIPI camera operation in RAW/Bayer mode
Date: Tue, 17 Oct 2017 08:27:35 +0200
Message-ID: <m3fuail25k.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this fix, in 8-bit Y/Bayer mode, every other 8-byte group
of pixels is lost.
Not sure about possible side effects, though.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -340,7 +340,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	case V4L2_PIX_FMT_SGBRG8:
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SRGGB8:
-		burst_size = 8;
+		burst_size = 16;
 		passthrough = true;
 		passthrough_bits = 8;
 		break;

-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
