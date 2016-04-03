Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:58029 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbcDCI4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 04:56:09 -0400
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v6 13/24] [media] cx231xx: convert to use an explicit i2c mux core
Date: Sun,  3 Apr 2016 10:52:43 +0200
Message-Id: <1459673574-11440-14-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select op to be in terms of the i2c mux core instead
of the child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/usb/cx231xx/cx231xx-core.c |  6 ++--
 drivers/media/usb/cx231xx/cx231xx-i2c.c  | 47 ++++++++++++++++----------------
 drivers/media/usb/cx231xx/cx231xx.h      |  4 ++-
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index f497888d94bf..f7aac2abd783 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1304,6 +1304,9 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	cx231xx_i2c_register(&dev->i2c_bus[1]);
 	cx231xx_i2c_register(&dev->i2c_bus[2]);
 
+	errCode = cx231xx_i2c_mux_create(dev);
+	if (errCode < 0)
+		return errCode;
 	cx231xx_i2c_mux_register(dev, 0);
 	cx231xx_i2c_mux_register(dev, 1);
 
@@ -1426,8 +1429,7 @@ EXPORT_SYMBOL_GPL(cx231xx_dev_init);
 void cx231xx_dev_uninit(struct cx231xx *dev)
 {
 	/* Un Initialize I2C bus */
-	cx231xx_i2c_mux_unregister(dev, 1);
-	cx231xx_i2c_mux_unregister(dev, 0);
+	cx231xx_i2c_mux_unregister(dev);
 	cx231xx_i2c_unregister(&dev->i2c_bus[2]);
 	cx231xx_i2c_unregister(&dev->i2c_bus[1]);
 	cx231xx_i2c_unregister(&dev->i2c_bus[0]);
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index a29c345b027d..eb22e05d4add 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -557,40 +557,41 @@ int cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
  * cx231xx_i2c_mux_select()
  * switch i2c master number 1 between port1 and port3
  */
-static int cx231xx_i2c_mux_select(struct i2c_adapter *adap,
-			void *mux_priv, u32 chan_id)
+static int cx231xx_i2c_mux_select(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct cx231xx *dev = mux_priv;
+	struct cx231xx *dev = i2c_mux_priv(muxc);
 
 	return cx231xx_enable_i2c_port_3(dev, chan_id);
 }
 
+int cx231xx_i2c_mux_create(struct cx231xx *dev)
+{
+	dev->muxc = i2c_mux_alloc(&dev->i2c_bus[1].i2c_adap, dev->dev, 0, 0,
+				  cx231xx_i2c_mux_select, NULL);
+	if (!dev->muxc)
+		return -ENOMEM;
+	dev->muxc->priv = dev;
+	return 0;
+}
+
 int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 {
-	struct i2c_adapter *i2c_parent = &dev->i2c_bus[1].i2c_adap;
-	/* what is the correct mux_dev? */
-	struct device *mux_dev = dev->dev;
-
-	dev->i2c_mux_adap[mux_no] = i2c_add_mux_adapter(i2c_parent,
-				mux_dev,
-				dev /* mux_priv */,
-				0,
-				mux_no /* chan_id */,
-				0 /* class */,
-				&cx231xx_i2c_mux_select,
-				NULL);
-
-	if (!dev->i2c_mux_adap[mux_no])
+	int rc;
+
+	rc = i2c_mux_add_adapter(dev->muxc,
+				 0,
+				 mux_no /* chan_id */,
+				 0 /* class */);
+	if (rc)
 		dev_warn(dev->dev,
 			 "i2c mux %d register FAILED\n", mux_no);
 
-	return 0;
+	return rc;
 }
 
-void cx231xx_i2c_mux_unregister(struct cx231xx *dev, int mux_no)
+void cx231xx_i2c_mux_unregister(struct cx231xx *dev)
 {
-	i2c_del_mux_adapter(dev->i2c_mux_adap[mux_no]);
-	dev->i2c_mux_adap[mux_no] = NULL;
+	i2c_mux_del_adapters(dev->muxc);
 }
 
 struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
@@ -603,9 +604,9 @@ struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
 	case I2C_2:
 		return &dev->i2c_bus[2].i2c_adap;
 	case I2C_1_MUX_1:
-		return dev->i2c_mux_adap[0];
+		return dev->muxc->adapter[0];
 	case I2C_1_MUX_3:
-		return dev->i2c_mux_adap[1];
+		return dev->muxc->adapter[1];
 	default:
 		return NULL;
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 69f6d20870f5..90c867683076 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -624,6 +624,7 @@ struct cx231xx {
 
 	/* I2C adapters: Master 1 & 2 (External) & Master 3 (Internal only) */
 	struct cx231xx_i2c i2c_bus[3];
+	struct i2c_mux_core *muxc;
 	struct i2c_adapter *i2c_mux_adap[2];
 
 	unsigned int xc_fw_load_done:1;
@@ -760,8 +761,9 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev);
 void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port);
 int cx231xx_i2c_register(struct cx231xx_i2c *bus);
 int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
+int cx231xx_i2c_mux_create(struct cx231xx *dev);
 int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no);
-void cx231xx_i2c_mux_unregister(struct cx231xx *dev, int mux_no);
+void cx231xx_i2c_mux_unregister(struct cx231xx *dev);
 struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port);
 
 /* Internal block control functions */
-- 
2.1.4

