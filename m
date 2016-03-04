Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:58109 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203AbcCDJdY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 04:33:24 -0500
Message-ID: <56D9565A.4020201@lysator.liu.se>
Date: Fri, 04 Mar 2016 10:33:14 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 16/18] i2c: allow adapter drivers to override the adapter
 locking
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se> <1457044050-15230-17-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-17-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Here's a fixup for a problem found by the test robot. Sorry for the
inconvenience.

Cheers,
Peter

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 6be266c3d39b..5ecc6fc52ce0 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -961,6 +961,8 @@ static int i2c_check_addr_busy(struct i2c_adapter *adapter, int addr)
 /**
  * i2c_adapter_lock_bus - Get exclusive access to an I2C bus segment
  * @adapter: Target I2C bus segment
+ * @flags: I2C_LOCK_ADAPTER locks the root i2c adapter, I2C_LOCK_SEGMENT
+ *	locks only this branch in the adapter tree
  */
 static void i2c_adapter_lock_bus(struct i2c_adapter *adapter, int flags)
 {
@@ -970,6 +972,8 @@ static void i2c_adapter_lock_bus(struct i2c_adapter *adapter, int flags)
 /**
  * i2c_adapter_trylock_bus - Try to get exclusive access to an I2C bus segment
  * @adapter: Target I2C bus segment
+ * @flags: I2C_LOCK_ADAPTER trylocks the root i2c adapter, I2C_LOCK_SEGMENT
+ * 	trylocks only this branch in the adapter tree
  */
 static int i2c_adapter_trylock_bus(struct i2c_adapter *adapter, int flags)
 {
@@ -979,6 +983,8 @@ static int i2c_adapter_trylock_bus(struct i2c_adapter *adapter, int flags)
 /**
  * i2c_adapter_unlock_bus - Release exclusive access to an I2C bus segment
  * @adapter: Target I2C bus segment
+ * @flags: I2C_LOCK_ADAPTER unlocks the root i2c adapter, I2C_LOCK_SEGMENT
+ * 	unlocks only this branch in the adapter tree
  */
 static void i2c_adapter_unlock_bus(struct i2c_adapter *adapter, int flags)
 {
-- 
2.1.4

