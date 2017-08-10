Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60300 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752941AbdHJPtv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 11:49:51 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        laurent.pinchart@ideasonboard.com, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org, Rui Miguel Silva <rmfrfs@gmail.com>
Subject: [PATCH v3 3/3] v4l2-flash-led-class: Document v4l2_flash_init() references
Date: Thu, 10 Aug 2017 18:49:47 +0300
Message-Id: <20170810154947.2283-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20170810154947.2283-1-sakari.ailus@linux.intel.com>
References: <20170810154947.2283-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_flash_init() keeps a reference to the ops struct but not to the
config struct (nor anything it contains). Document this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-flash-led-class.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
index c3f39992f3fa..6f4825b6a352 100644
--- a/include/media/v4l2-flash-led-class.h
+++ b/include/media/v4l2-flash-led-class.h
@@ -112,6 +112,9 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
  * @config:	initialization data for V4L2 Flash sub-device
  *
  * Create V4L2 Flash sub-device wrapping given LED subsystem device.
+ * The ops pointer is stored by the V4L2 flash framework. No
+ * references are held to config nor its contents once this function
+ * has returned.
  *
  * Returns: A valid pointer, or, when an error occurs, the return
  * value is encoded using ERR_PTR(). Use IS_ERR() to check and
@@ -130,6 +133,9 @@ struct v4l2_flash *v4l2_flash_init(
  * @config:	initialization data for V4L2 Flash sub-device
  *
  * Create V4L2 Flash sub-device wrapping given LED subsystem device.
+ * The ops pointer is stored by the V4L2 flash framework. No
+ * references are held to config nor its contents once this function
+ * has returned.
  *
  * Returns: A valid pointer, or, when an error occurs, the return
  * value is encoded using ERR_PTR(). Use IS_ERR() to check and
-- 
2.11.0
