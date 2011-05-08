Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:55407 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab1EHTRk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 15:17:40 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [PATCH v2 3/5] mxl5005: Fix warning caused by new entries in an enum
Date: Sun,  8 May 2011 20:17:18 +0100
Message-Id: <1304882240-23044-4-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4DC6BF28.8070006@redhat.com>
References: <4DC6BF28.8070006@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Additional bandwidth modes have been added in frontend.h
mxl5005s.c had no default case so the compiler was warning about
a non-exhausive switch statement.

Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
---
 drivers/media/common/tuners/mxl5005s.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index 0d6e094..d80e6f3 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -4020,6 +4020,10 @@ static int mxl5005s_set_params(struct dvb_frontend *fe,
 			case BANDWIDTH_7_MHZ:
 				req_bw  = MXL5005S_BANDWIDTH_7MHZ;
 				break;
+			default:
+				dprintk(1,"%s: Unsupported bandwidth mode %u, reverting to default\n",
+					__func__,params->u.ofdm.bandwidth);
+				/* Fall back to auto */
 			case BANDWIDTH_AUTO:
 			case BANDWIDTH_8_MHZ:
 				req_bw  = MXL5005S_BANDWIDTH_8MHZ;
-- 
1.7.1

