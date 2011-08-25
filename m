Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3523 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HYOIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/12] mt20xx.c: fix compiler warnings
Date: Thu, 25 Aug 2011 16:08:25 +0200
Message-Id: <739af58fe8fe964bc038a917ac5f33beefb472f3.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/common/tuners/mt20xx.c: In function 'mt2050_set_antenna':
v4l-dvb-git/drivers/media/common/tuners/mt20xx.c:433:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/common/tuners/mt20xx.c: In function 'mt2050_init':
v4l-dvb-git/drivers/media/common/tuners/mt20xx.c:577:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/tuners/mt20xx.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/media/common/tuners/mt20xx.c b/drivers/media/common/tuners/mt20xx.c
index d0e70e1..0e74e97 100644
--- a/drivers/media/common/tuners/mt20xx.c
+++ b/drivers/media/common/tuners/mt20xx.c
@@ -430,11 +430,10 @@ static void mt2050_set_antenna(struct dvb_frontend *fe, unsigned char antenna)
 {
 	struct microtune_priv *priv = fe->tuner_priv;
 	unsigned char buf[2];
-	int ret;
 
 	buf[0] = 6;
 	buf[1] = antenna ? 0x11 : 0x10;
-	ret=tuner_i2c_xfer_send(&priv->i2c_props,buf,2);
+	tuner_i2c_xfer_send(&priv->i2c_props, buf, 2);
 	tuner_dbg("mt2050: enabled antenna connector %d\n", antenna);
 }
 
@@ -574,21 +573,20 @@ static int mt2050_init(struct dvb_frontend *fe)
 {
 	struct microtune_priv *priv = fe->tuner_priv;
 	unsigned char buf[2];
-	int ret;
 
-	buf[0]=6;
-	buf[1]=0x10;
-	ret=tuner_i2c_xfer_send(&priv->i2c_props,buf,2); //  power
+	buf[0] = 6;
+	buf[1] = 0x10;
+	tuner_i2c_xfer_send(&priv->i2c_props, buf, 2); /* power */
 
-	buf[0]=0x0f;
-	buf[1]=0x0f;
-	ret=tuner_i2c_xfer_send(&priv->i2c_props,buf,2); // m1lo
+	buf[0] = 0x0f;
+	buf[1] = 0x0f;
+	tuner_i2c_xfer_send(&priv->i2c_props, buf, 2); /* m1lo */
 
-	buf[0]=0x0d;
-	ret=tuner_i2c_xfer_send(&priv->i2c_props,buf,1);
-	tuner_i2c_xfer_recv(&priv->i2c_props,buf,1);
+	buf[0] = 0x0d;
+	tuner_i2c_xfer_send(&priv->i2c_props, buf, 1);
+	tuner_i2c_xfer_recv(&priv->i2c_props, buf, 1);
 
-	tuner_dbg("mt2050: sro is %x\n",buf[0]);
+	tuner_dbg("mt2050: sro is %x\n", buf[0]);
 
 	memcpy(&fe->ops.tuner_ops, &mt2050_tuner_ops, sizeof(struct dvb_tuner_ops));
 
-- 
1.7.5.4

