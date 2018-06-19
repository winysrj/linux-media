Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40726 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030571AbeFSSvZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:51:25 -0400
Received: by mail-wr0-f196.google.com with SMTP id l41-v6so691437wre.7
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:51:24 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, jasmin@anw.at,
        rjkm@metzlerbros.de, mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/3] [media] dvb-frontends/cxd2099: fix boilerplate whitespace
Date: Tue, 19 Jun 2018 20:51:19 +0200
Message-Id: <20180619185119.24548-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185119.24548-1-d.scheller.oss@gmail.com>
References: <20180619185119.24548-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

There's a superfluous whitespace in the boilerplate license text in both
.c and .h files. Fix this.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2099.c | 2 +-
 drivers/media/dvb-frontends/cxd2099.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
index 5264e873850e..5d8884ed64ef 100644
--- a/drivers/media/dvb-frontends/cxd2099.c
+++ b/drivers/media/dvb-frontends/cxd2099.c
@@ -10,7 +10,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
  */
 
diff --git a/drivers/media/dvb-frontends/cxd2099.h b/drivers/media/dvb-frontends/cxd2099.h
index 0c101bdef01d..30787095843a 100644
--- a/drivers/media/dvb-frontends/cxd2099.h
+++ b/drivers/media/dvb-frontends/cxd2099.h
@@ -10,7 +10,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
  */
 
-- 
2.16.4
