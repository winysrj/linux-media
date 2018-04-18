Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:46056 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752077AbeDRQML (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 12:12:11 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/5] lgdt3306a v3.4 i2c mux backport
Date: Wed, 18 Apr 2018 11:12:04 -0500
Message-Id: <1524067927-12113-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
References: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trivial patch

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 backports/v3.4_i2c_add_mux_adapter.patch | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/backports/v3.4_i2c_add_mux_adapter.patch b/backports/v3.4_i2c_add_mux_adapter.patch
index 5f93275..fc1b697 100644
--- a/backports/v3.4_i2c_add_mux_adapter.patch
+++ b/backports/v3.4_i2c_add_mux_adapter.patch
@@ -66,3 +66,17 @@ index 725c13a..35e3ac1 100644
  				dev /* mux_priv */,
  				0,
  				mux_no /* chan_id */,
+diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
+--- a/drivers/media/dvb-frontends/lgdt3306a.c	2018-01-23 22:15:12.146359404 +0000
++++ b/drivers/media/dvb-frontends/lgdt3306a.c	2018-01-23 22:16:01.055381481 +0000
+@@ -2300,8 +2300,8 @@ static int lgdt3306a_probe(struct i2c_cl
+ 	state = fe->demodulator_priv;
+ 
+ 	/* create mux i2c adapter for tuner */
+-	state->i2c_adap = i2c_add_mux_adapter(client->adapter, &client->dev,
+-			client, 0, 0, lgdt3306a_select, lgdt3306a_deselect);
++	state->i2c_adap = i2c_add_mux_adapter(client->adapter, client,
++				0, 0, lgdt3306a_select, lgdt3306a_deselect);
+ 	if (state->i2c_adap == NULL) {
+ 		ret = -ENODEV;
+ 		goto err_kfree;
-- 
2.7.4
