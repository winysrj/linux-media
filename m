Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33993 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbdH1HVn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 03:21:43 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        ezequiel@vanguardiasur.com.ar, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] usb: make i2c_client const
Date: Mon, 28 Aug 2017 12:51:35 +0530
Message-Id: <1503904895-10871-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used in a copy operation.
Done using Coccinelle.

@match disable optional_qualifier@
identifier s;
@@
static struct i2c_client s = {...};

@ref@
position p;
identifier match.s;
@@
s@p

@good1@
position ref.p;
identifier match.s,f,c;
expression e;
@@
(
e = s@p
|
e = s@p.f
|
c(...,s@p.f,...)
|
c(...,s@p,...)
)

@bad depends on  !good1@
position ref.p;
identifier match.s;
@@
s@p

@depends on forall !bad disable optional_qualifier@
identifier match.s;
@@
static
+ const
struct i2c_client s;

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/au0828/au0828-i2c.c   | 2 +-
 drivers/media/usb/em28xx/em28xx-i2c.c   | 2 +-
 drivers/media/usb/stk1160/stk1160-i2c.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
index 42b352b..348b384 100644
--- a/drivers/media/usb/au0828/au0828-i2c.c
+++ b/drivers/media/usb/au0828/au0828-i2c.c
@@ -342,7 +342,7 @@ static u32 au0828_functionality(struct i2c_adapter *adap)
 	.algo              = &au0828_i2c_algo_template,
 };
 
-static struct i2c_client au0828_i2c_client_template = {
+static const struct i2c_client au0828_i2c_client_template = {
 	.name	= "au0828 internal",
 };
 
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 60b195c..fa3fe4c 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -882,7 +882,7 @@ static u32 functionality(struct i2c_adapter *i2c_adap)
 	.algo = &em28xx_algo,
 };
 
-static struct i2c_client em28xx_client_template = {
+static const struct i2c_client em28xx_client_template = {
 	.name = "em28xx internal",
 };
 
diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
index 3f2517b..7151e28 100644
--- a/drivers/media/usb/stk1160/stk1160-i2c.c
+++ b/drivers/media/usb/stk1160/stk1160-i2c.c
@@ -246,7 +246,7 @@ static u32 functionality(struct i2c_adapter *adap)
 	.algo = &algo,
 };
 
-static struct i2c_client client_template = {
+static const struct i2c_client client_template = {
 	.name = "stk1160 internal",
 };
 
-- 
1.9.1
