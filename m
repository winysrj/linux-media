Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4391 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab3CZLR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 07:17:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix undefined reference to `au8522_attach'
Date: Tue, 26 Mar 2013 12:17:42 +0100
Cc: Michael Krufky <mkrufky@kernellabs.com>, mchehab@redhat.com,
	Fengguang Wu <fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261217.42913.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au8522_attach is dependent on CONFIG_DVB_AU8522_DTV, not CONFIG_DVB_AU8522.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index f2111e0..83fe9a6 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -61,7 +61,7 @@ struct au8522_config {
 	enum au8522_if_freq qam_if;
 };
 
-#if IS_ENABLED(CONFIG_DVB_AU8522)
+#if IS_ENABLED(CONFIG_DVB_AU8522_DTV)
 extern struct dvb_frontend *au8522_attach(const struct au8522_config *config,
 					  struct i2c_adapter *i2c);
 #else
