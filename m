Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44786 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758787AbdKQO4D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 09:56:03 -0500
Received: by mail-qt0-f195.google.com with SMTP id h42so6617819qtk.11
        for <linux-media@vger.kernel.org>; Fri, 17 Nov 2017 06:56:03 -0800 (PST)
From: dgopstein@nyu.edu
To: linux-media@vger.kernel.org
Cc: baruch@tkos.co.il, Dan Gopstein <dgopstein@nyu.edu>
Subject: [PATCH v2] media: ABS macro parameter parenthesization
Date: Fri, 17 Nov 2017 09:55:44 -0500
Message-Id: <1510930544-2177-1-git-send-email-dgopstein@nyu.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Gopstein <dgopstein@nyu.edu>

Two definitions of the ABS (absolute value) macro fail to parenthesize
their parameter properly. This can lead to a bad expansion for
low-precedence expression arguments. Add parens to protect against
troublesome arguments.

For example: ABS(1-2) currently expands to ((1-2) < 0 ? (-1-2) : (1-2))
which evaluates to -3. But the correct expansion would be
((1-2) < 0 ? -(1-2) : (1-2)) which evaluates to 1.

Signed-off-by: Dan Gopstein <dgopstein@nyu.edu>
---
v1->v2:
* unmangled the patch
* added example to commit text

 drivers/media/dvb-frontends/dibx000_common.h | 2 +-
 drivers/media/dvb-frontends/mb86a16.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dibx000_common.h b/drivers/media/dvb-frontends/dibx000_common.h
index 8784af9..ae60f5d 100644
--- a/drivers/media/dvb-frontends/dibx000_common.h
+++ b/drivers/media/dvb-frontends/dibx000_common.h
@@ -223,7 +223,7 @@ struct dvb_frontend_parametersContext {
 
 #define FE_CALLBACK_TIME_NEVER 0xffffffff
 
-#define ABS(x) ((x < 0) ? (-x) : (x))
+#define ABS(x) (((x) < 0) ? -(x) : (x))
 
 #define DATA_BUS_ACCESS_MODE_8BIT                 0x01
 #define DATA_BUS_ACCESS_MODE_16BIT                0x02
diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index dfe322e..2d921c7 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -31,7 +31,7 @@
 static unsigned int verbose = 5;
 module_param(verbose, int, 0644);
 
-#define ABS(x)		((x) < 0 ? (-x) : (x))
+#define ABS(x)		((x) < 0 ? -(x) : (x))
 
 struct mb86a16_state {
 	struct i2c_adapter		*i2c_adap;
-- 
2.7.4
