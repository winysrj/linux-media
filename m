Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37832 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752947AbdHTM7P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 08:59:15 -0400
Received: by mail-wr0-f196.google.com with SMTP id z91so13504549wrc.4
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 05:59:15 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 1/2] [media] dvb-frontends/stv0910: declare global list_head stvlist static
Date: Sun, 20 Aug 2017 14:59:11 +0200
Message-Id: <20170820125912.9716-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170820125912.9716-1-d.scheller.oss@gmail.com>
References: <20170820125912.9716-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Cleans up smatch warning:
symbol 'stvlist' was not declared. Should it be static?

Patch originally submitted by Colin Ian King <colin.king@canonical.com>,
remainder after the merge of all other stv0910 fixes.

Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index d0a8ed36b899..d1ae9553f74c 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -34,7 +34,7 @@
 #define BER_SRC_S    0x20
 #define BER_SRC_S2   0x20
 
-LIST_HEAD(stvlist);
+static LIST_HEAD(stvlist);
 
 enum receive_mode { RCVMODE_NONE, RCVMODE_DVBS, RCVMODE_DVBS2, RCVMODE_AUTO };
 
-- 
2.13.0
