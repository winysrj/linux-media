Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65FFC43444
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 23:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 719542084D
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 23:08:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="yVU8Dnp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfAHXIb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 18:08:31 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:48418 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729281AbfAHXIa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 18:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=References:In-Reply-To:Message-Id:Date:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YAvZ/pH6lMIksVLRvTR8eQqY0c+EoHMb/3U4kL6GjKs=; b=yVU8Dnp1mEt9WPCoepziK4bSP
        oLQnYWbYPNJgWTVMC8rlZGXXg0eo+t1uzLeOcuJ2FJrLK5cZvbzMBjJWCvAnQXuDpRSvrN5hO4ou2
        KKbzR/b0nppoJEfp1mlx73icrCKfiJR7HZ3cuVtls6hcxbiBeeIDmgMRMalq/CrajD/7Q=;
Received: from [78.134.43.6] (port=50994 helo=melee.fritz.box)
        by hostingweb31.netsons.net with esmtpa (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1gh02Y-00FWab-Eu; Tue, 08 Jan 2019 23:40:06 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
To:     linux-media@vger.kernel.org
Cc:     Luca Ceresoli <luca.ceresoli@aim-sportline.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Rosin <peda@axentia.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Luca Ceresoli <luca@lucaceresoli.net>
Subject: [RFC 1/4] i2c: core: let adapters be notified of client attach/detach
Date:   Tue,  8 Jan 2019 23:39:50 +0100
Message-Id: <20190108223953.9969-2-luca@lucaceresoli.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190108223953.9969-1-luca@lucaceresoli.net>
References: <20190108223953.9969-1-luca@lucaceresoli.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Luca Ceresoli <luca.ceresoli@aim-sportline.com>

An adapter might need to know when a new device is about to be
added. This will soon bee needed to implement an "I2C address
translator" (ATR for short), a device that propagates I2C transactions
with a different slave address (an "alias" address). An ATR driver
needs to know when a slave is being added to find a suitable alias and
program the device translation map.

Add an attach/detach callback pair to allow adapter drivers to be
notified of clients being added and removed.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/i2c/i2c-core-base.c | 16 ++++++++++++++++
 include/linux/i2c.h         |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 28460f6a60cc..4f8776e065ce 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -778,6 +778,11 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
 		}
 	}
 
+	if (adap->attach_ops &&
+	    adap->attach_ops->attach_client &&
+	    adap->attach_ops->attach_client(adap, info, client) != 0)
+		goto err_attach_client;
+
 	status = device_register(&client->dev);
 	if (status)
 		goto out_free_props;
@@ -788,6 +793,9 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
 	return client;
 
 out_free_props:
+	if (adap->attach_ops && adap->attach_ops->detach_client)
+		adap->attach_ops->detach_client(adap, client);
+err_attach_client:
 	if (info->properties)
 		device_remove_properties(&client->dev);
 out_err_put_of_node:
@@ -810,9 +818,17 @@ EXPORT_SYMBOL_GPL(i2c_new_device);
  */
 void i2c_unregister_device(struct i2c_client *client)
 {
+	struct i2c_adapter *adap;
+
 	if (!client)
 		return;
 
+	adap = client->adapter;
+
+	if (adap->attach_ops &&
+	    adap->attach_ops->detach_client)
+		adap->attach_ops->detach_client(adap, client);
+
 	if (client->dev.of_node) {
 		of_node_clear_flag(client->dev.of_node, OF_POPULATED);
 		of_node_put(client->dev.of_node);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 65b4eaed1d96..600d136b1056 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -551,6 +551,14 @@ struct i2c_lock_operations {
 	void (*unlock_bus)(struct i2c_adapter *, unsigned int flags);
 };
 
+struct i2c_attach_operations {
+	int  (*attach_client)(struct i2c_adapter *,
+			      const struct i2c_board_info *,
+			      struct i2c_client *);
+	void (*detach_client)(struct i2c_adapter *,
+			      struct i2c_client *);
+};
+
 /**
  * struct i2c_timings - I2C timing information
  * @bus_freq_hz: the bus frequency in Hz
@@ -674,6 +682,7 @@ struct i2c_adapter {
 
 	/* data fields that are valid for all devices	*/
 	const struct i2c_lock_operations *lock_ops;
+	const struct i2c_attach_operations *attach_ops;
 	struct rt_mutex bus_lock;
 	struct rt_mutex mux_lock;
 
-- 
2.17.1

