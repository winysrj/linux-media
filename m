Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:46058 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752696AbeDRQML (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 12:12:11 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 3/5] lgdt3306a v3.6 i2c mux backport
Date: Wed, 18 Apr 2018 11:12:05 -0500
Message-Id: <1524067927-12113-4-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
References: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another trivial patch

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 backports/v3.6_i2c_add_mux_adapter.patch | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/backports/v3.6_i2c_add_mux_adapter.patch b/backports/v3.6_i2c_add_mux_adapter.patch
index 8172316..d26b82b 100644
--- a/backports/v3.6_i2c_add_mux_adapter.patch
+++ b/backports/v3.6_i2c_add_mux_adapter.patch
@@ -62,3 +62,15 @@ index a29c345..725c13a 100644
  				&cx231xx_i2c_mux_select,
  				NULL);
  
+diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
+--- a/drivers/media/dvb-frontends/lgdt3306a.c	2018-01-23 22:13:14.095893561 +0000
++++ b/drivers/media/dvb-frontends/lgdt3306a.c	2018-01-23 22:13:52.796701755 +0000
+@@ -2301,7 +2301,7 @@ static int lgdt3306a_probe(struct i2c_cl
+ 
+ 	/* create mux i2c adapter for tuner */
+ 	state->i2c_adap = i2c_add_mux_adapter(client->adapter, &client->dev,
+-			client, 0, 0, 0, lgdt3306a_select, lgdt3306a_deselect);
++			client, 0, 0, lgdt3306a_select, lgdt3306a_deselect);
+ 	if (state->i2c_adap == NULL) {
+ 		ret = -ENODEV;
+ 		goto err_kfree;
-- 
2.7.4
