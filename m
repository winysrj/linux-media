Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:37584 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936377AbdKPXKC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 18:10:02 -0500
Received: by mail-qt0-f195.google.com with SMTP id d15so1800813qte.4
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 15:10:02 -0800 (PST)
MIME-Version: 1.0
From: Dan Gopstein <dgopstein@nyu.edu>
Date: Thu, 16 Nov 2017 18:09:20 -0500
Message-ID: <CAAqN1Z6YN2y3kvKu+SOsSh8EozY1+J_k3XHnH9F0F5z8bB402g@mail.gmail.com>
Subject: [PATCH] media: ABS macro parameter parenthesization
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Gopstein <dgopstein@nyu.edu>

Two definitions of the ABS (absolute value) macro fail to parenthesize their
parameter properly. This can lead to a bad expansion for low-precedence
expression arguments. Add parens to protect against troublesome arguments.

Signed-off-by: Dan Gopstein <dgopstein@nyu.edu>
---
See an example bad usage in
drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
on line 1204:

ABS(prev_swp_freq[j] - swp_freq)

For example: ABS(1-2) currently expands to ((1-2) < 0 ? (-1-2) : (1-2)) which
evaluates to -3. But the correct expansion would be ((1-2) < 0 ? -(1-2) : (1-2))
which evaluates to 1.

I found this issue as part of the "Atoms of Confusion" research at NYU's Secure
Systems Lab. As the work continues, hopefully we'll be able to find more issues
like this one.

diff --git a/drivers/media/dvb-frontends/dibx000_common.h
b/drivers/media/dvb-frontends/dibx000_common.h
index 8784af9..ae60f5d 100644
--- a/drivers/media/dvb-frontends/dibx000_common.h
+++ b/drivers/media/dvb-frontends/dibx000_common.h
@@ -223,7 +223,7 @@ struct dvb_frontend_parametersContext {

#define FE_CALLBACK_TIME_NEVER 0xffffffff

-#define ABS(x) ((x < 0) ? (-x) : (x))
+#define ABS(x) (((x) < 0) ? -(x) : (x))

#define DATA_BUS_ACCESS_MODE_8BIT                 0x01
#define DATA_BUS_ACCESS_MODE_16BIT                0x02
diff --git a/drivers/media/dvb-frontends/mb86a16.c
b/drivers/media/dvb-frontends/mb86a16.c
index dfe322e..2d921c7 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -31,7 +31,7 @@
static unsigned int verbose = 5;
module_param(verbose, int, 0644);

-#define ABS(x)         ((x) < 0 ? (-x) : (x))
+#define ABS(x)         ((x) < 0 ? -(x) : (x))

struct mb86a16_state {
        struct i2c_adapter              *i2c_adap;
