Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45232 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754457AbeDBWZC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 18:25:02 -0400
From: Nasser Afshin <afshin.nasser@gmail.com>
Cc: Nasser Afshin <Afshin.Nasser@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] media: i2c: tvp5150: Fix open brace placement codding style
Date: Tue,  3 Apr 2018 02:53:19 +0430
Message-Id: <20180402222322.30385-4-Afshin.Nasser@gmail.com>
In-Reply-To: <20180402222322.30385-1-Afshin.Nasser@gmail.com>
References: <d5e8dbe4-b68b-ac4e-0076-a3ee995f8327@embeddedor.com>
 <20180402222322.30385-1-Afshin.Nasser@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch resolves the following checkpatch.pl error:
    ERROR: that open brace { should be on the previous line

Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
---
 drivers/media/i2c/tvp5150.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index fd23138cc6a3..d561d87d219a 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -500,8 +500,8 @@ struct i2c_vbi_ram_value {
  * and so on. There are 16 possible locations from 0 to 15.
  */
 
-static struct i2c_vbi_ram_value vbi_ram_default[] =
-{
+static struct i2c_vbi_ram_value vbi_ram_default[] = {
+
 	/*
 	 * FIXME: Current api doesn't handle all VBI types, those not
 	 * yet supported are placed under #if 0
-- 
2.15.0
