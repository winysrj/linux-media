Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33682 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbdIATny (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:43:54 -0400
Received: by mail-wr0-f194.google.com with SMTP id k94so539395wrc.0
        for <linux-media@vger.kernel.org>; Fri, 01 Sep 2017 12:43:54 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH] [media] dvb-frontends/mxl5xx: declare LIST_HEAD(mxllist) static
Date: Fri,  1 Sep 2017 21:43:45 +0200
Message-Id: <20170901194345.18707-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes one sparse warning:
  mxl5xx.c:46:1: warning: symbol 'mxllist' was not declared. Should it be static?

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/mxl5xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 676c96c216c3..53064e11f5f1 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -43,7 +43,7 @@
 #define BYTE2(v) ((v >> 16) & 0xff)
 #define BYTE3(v) ((v >> 24) & 0xff)
 
-LIST_HEAD(mxllist);
+static LIST_HEAD(mxllist);
 
 struct mxl_base {
 	struct list_head     mxllist;
-- 
2.13.5
