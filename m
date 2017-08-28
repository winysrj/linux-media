Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36185 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdH1HmT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 03:42:19 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, awalls@md.metrocast.net,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] pci: make i2c_client const
Date: Mon, 28 Aug 2017 13:12:09 +0530
Message-Id: <1503906129-10960-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used in a copy operation.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-i2c.c | 2 +-
 drivers/media/pci/cx25821/cx25821-i2c.c | 2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c       | 2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c | 2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index 8528032..5bbbdec 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -270,7 +270,7 @@ static u32 cx23885_functionality(struct i2c_adapter *adap)
 	.algo              = &cx23885_i2c_algo_template,
 };
 
-static struct i2c_client cx23885_i2c_client_template = {
+static const struct i2c_client cx23885_i2c_client_template = {
 	.name	= "cx23885 internal",
 };
 
diff --git a/drivers/media/pci/cx25821/cx25821-i2c.c b/drivers/media/pci/cx25821/cx25821-i2c.c
index 263a1cf..012e93a 100644
--- a/drivers/media/pci/cx25821/cx25821-i2c.c
+++ b/drivers/media/pci/cx25821/cx25821-i2c.c
@@ -291,7 +291,7 @@ static u32 cx25821_functionality(struct i2c_adapter *adap)
 	.algo = &cx25821_i2c_algo_template,
 };
 
-static struct i2c_client cx25821_i2c_client_template = {
+static const struct i2c_client cx25821_i2c_client_template = {
 	.name = "cx25821 internal",
 };
 
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index 69b4fa6..09f95f1 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -700,7 +700,7 @@ static int ivtv_getsda_old(void *data)
 	.timeout	= IVTV_ALGO_BIT_TIMEOUT * HZ,         /* jiffies */
 };
 
-static struct i2c_client ivtv_i2c_client_template = {
+static const struct i2c_client ivtv_i2c_client_template = {
 	.name = "ivtv internal",
 };
 
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index 9d0e69e..af94aee 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -345,7 +345,7 @@ static u32 functionality(struct i2c_adapter *adap)
 	.algo          = &saa7134_algo,
 };
 
-static struct i2c_client saa7134_client_template = {
+static const struct i2c_client saa7134_client_template = {
 	.name	= "saa7134 internal",
 };
 
diff --git a/drivers/media/pci/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
index 430f678..e06b617 100644
--- a/drivers/media/pci/saa7164/saa7164-i2c.c
+++ b/drivers/media/pci/saa7164/saa7164-i2c.c
@@ -84,7 +84,7 @@ static u32 saa7164_functionality(struct i2c_adapter *adap)
 	.algo              = &saa7164_i2c_algo_template,
 };
 
-static struct i2c_client saa7164_i2c_client_template = {
+static const struct i2c_client saa7164_i2c_client_template = {
 	.name	= "saa7164 internal",
 };
 
-- 
1.9.1
