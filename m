Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:46502 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753214AbdHJWLc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 18:11:32 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH 2/5] [media] cx25840: describe standard for 0b1100 value in
 AFD_FMT_STAT bits
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Message-ID: <d7f35d67-3521-49d5-217e-c742a21e53a2@maciej.szmigiero.name>
Date: Thu, 10 Aug 2017 23:51:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A 0b1100 value in 4 LSBs of "General Status 1" register (AFD_FMT_STAT) has
known meaning for CX2584x-series chips - it means that a SECAM signal is
currently detected by the chip.

Use this opportunity to also fix wrong binary values that were present
as comments attached to some entries in an array where
chip register -> V4L2 standard mappings are stored.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 078b94ae55ac..2fa74c23d619 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -2166,9 +2166,9 @@ static int cx25840_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
 
 		/* 1001 */ V4L2_STD_UNKNOWN,
 		/* 1010 */ V4L2_STD_UNKNOWN,
-		/* 1001 */ V4L2_STD_UNKNOWN,
-		/* 1010 */ V4L2_STD_UNKNOWN,
 		/* 1011 */ V4L2_STD_UNKNOWN,
+		/* 1100 */ V4L2_STD_SECAM,
+		/* 1101 */ V4L2_STD_UNKNOWN,
 		/* 1110 */ V4L2_STD_UNKNOWN,
 		/* 1111 */ V4L2_STD_UNKNOWN
 	};
