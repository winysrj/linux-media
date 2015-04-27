Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44326 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbbD0HaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 03:30:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/5] cx24123/mb86a20s/s921: fix compiler warnings
Date: Mon, 27 Apr 2015 09:29:53 +0200
Message-Id: <1430119795-16527-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
References: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In file included from drivers/media/common/b2c2/flexcop-fe-tuner.c:13:0:
drivers/media/dvb-frontends/cx24123.h:54:2: warning: 'cx24123_get_tuner_i2c_adapter' defined but not used [-Wunused-function]
  cx24123_get_tuner_i2c_adapter(struct dvb_frontend *fe)
  ^
In file included from drivers/media/usb/em28xx/em28xx-dvb.c:46:0:
drivers/media/dvb-frontends/s921.h:40:2: warning: 's921_get_tuner_i2c_adapter' defined but not used [-Wunused-function]
  s921_get_tuner_i2c_adapter(struct dvb_frontend *fe)
  ^
In file included from drivers/media/usb/em28xx/em28xx-dvb.c:55:0:
drivers/media/dvb-frontends/mb86a20s.h:49:2: warning: 'mb86a20s_get_tuner_i2c_adapter' defined but not used [-Wunused-function]
  mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *fe)
  ^
In file included from drivers/media/usb/cx231xx/cx231xx-dvb.c:35:0:
drivers/media/dvb-frontends/mb86a20s.h:49:2: warning: 'mb86a20s_get_tuner_i2c_adapter' defined but not used [-Wunused-function]
  mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *fe)
  ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/cx24123.h  | 2 +-
 drivers/media/dvb-frontends/mb86a20s.h | 2 +-
 drivers/media/dvb-frontends/s921.h     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24123.h b/drivers/media/dvb-frontends/cx24123.h
index 758aee5..975f3c9 100644
--- a/drivers/media/dvb-frontends/cx24123.h
+++ b/drivers/media/dvb-frontends/cx24123.h
@@ -50,7 +50,7 @@ static inline struct dvb_frontend *cx24123_attach(
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
-static struct i2c_adapter *
+static inline struct i2c_adapter *
 	cx24123_get_tuner_i2c_adapter(struct dvb_frontend *fe)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index f749c8a..a113282 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -45,7 +45,7 @@ static inline struct dvb_frontend *mb86a20s_attach(
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
-static struct i2c_adapter *
+static inline struct i2c_adapter *
 	mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *fe)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
diff --git a/drivers/media/dvb-frontends/s921.h b/drivers/media/dvb-frontends/s921.h
index 7d3999a..f5b722d 100644
--- a/drivers/media/dvb-frontends/s921.h
+++ b/drivers/media/dvb-frontends/s921.h
@@ -36,7 +36,7 @@ static inline struct dvb_frontend *s921_attach(
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
-static struct i2c_adapter *
+static inline struct i2c_adapter *
 	s921_get_tuner_i2c_adapter(struct dvb_frontend *fe)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-- 
2.1.4

