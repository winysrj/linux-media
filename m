Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp215.webpack.hosteurope.de ([80.237.132.222]:33750 "EHLO
        wp215.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933154AbdK2PcV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 10:32:21 -0500
Subject: Re: [PATCH Resend] staging: media: cxd2099: style fix - replace
 hard-coded function names
From: Martin Homuth <martin@martinhomuth.de>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <d7fcc467-55df-15eb-51c8-effa8ece304f@martinhomuth.de>
Message-ID: <0c9de06d-4e7d-bc10-9980-3a55dde71b68@martinhomuth.de>
Date: Wed, 29 Nov 2017 16:32:18 +0100
MIME-Version: 1.0
In-Reply-To: <d7fcc467-55df-15eb-51c8-effa8ece304f@martinhomuth.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the remaining coding style warnings in the cxd2099
module. Instead of hard coding the function name the __func__ variable
should be used.

It fixes the following checkpatch.pl warning:

WARNING: Prefer using '"%s...", __func__' to using 'i2c_read_reg', this
function's name, in a string

Signed-off-by: Martin Homuth <martin.homuth@martinhomuth.de>
---
 drivers/staging/media/cxd2099/cxd2099.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c
b/drivers/staging/media/cxd2099/cxd2099.c
index 3e30f48..6641dd2 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -101,7 +101,7 @@ static int i2c_read_reg(struct i2c_adapter *adapter,
u8 adr,
 				   .buf = val, .len = 1} };

 	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		dev_err(&adapter->dev, "error in i2c_read_reg\n");
+		dev_err(&adapter->dev, "error in %s\n", __func__);
 		return -1;
 	}
 	return 0;
@@ -116,7 +116,7 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr,
 				   .buf = data, .len = n} };

 	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		dev_err(&adapter->dev, "error in i2c_read\n");
+		dev_err(&adapter->dev, "error in %s\n", __func__);
 		return -1;
 	}
 	return 0;
-- 
2.10.0
