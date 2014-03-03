Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaCCKHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:53 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 18/79] [media] drx-j: Some minor CodingStyle fixes at headers
Date: Mon,  3 Mar 2014 07:06:12 -0300
Message-Id: <1393841233-24840-19-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h   | 22 ++++++++--------------
 drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h |  9 ++-------
 2 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
index dd2fc797a991..80d7b2061bd0 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
@@ -1,4 +1,6 @@
 /*
+  I2C API, implementation depends on board specifics
+
   Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
   All rights reserved.
 
@@ -26,20 +28,12 @@
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
-*/
 
-/**
-* \file $Id: bsp_i2c.h,v 1.5 2009/07/07 14:20:30 justin Exp $
-*
-* \brief I2C API, implementation depends on board specifics
-*
-* This module encapsulates I2C access.In some applications several devices
-* share one I2C bus. If these devices have the same I2C address some kind
-* off "switch" must be implemented to ensure error free communication with
-* one device.  In case such a "switch" is used, the device ID can be used
-* to implement control over this "switch".
-*
-*
+  This module encapsulates I2C access.In some applications several devices
+  share one I2C bus. If these devices have the same I2C address some kind
+  off "switch" must be implemented to ensure error free communication with
+  one device.  In case such a "switch" is used, the device ID can be used
+  to implement control over this "switch".
 */
 
 #ifndef __BSPI2C_H__
@@ -123,7 +117,7 @@ Exported FUNCTIONS
 */
 	drx_status_t drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 					 u16 w_count,
-					 u8 *wData,
+					 u8 *w_data,
 					 struct i2c_device_addr *r_dev_addr,
 					 u16 r_count, u8 *r_data);
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
index 0016ba75bb7f..080ac02eaadb 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
@@ -1,4 +1,6 @@
 /*
+  Tuner dependable type definitions, macro's and functions
+
   Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
   All rights reserved.
 
@@ -28,13 +30,6 @@
   POSSIBILITY OF SUCH DAMAGE.
 */
 
-/**
-* \file $Id: bsp_tuner.h,v 1.5 2009/10/19 22:15:13 dingtao Exp $
-*
-* \brief Tuner dependable type definitions, macro's and functions
-*
-*/
-
 #ifndef __DRXBSP_TUNER_H__
 #define __DRXBSP_TUNER_H__
 /*------------------------------------------------------------------------------
-- 
1.8.5.3

