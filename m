Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:49051 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbcCDHK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 02:10:57 -0500
Message-ID: <56D934F7.4060909@lysator.liu.se>
Date: Fri, 04 Mar 2016 08:10:47 +0100
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
	Adriana Reus <adriana.reus@intel.com>,
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 18/18] i2c-mux: relax locking of the top i2c adapter
 during i2c controlled muxing
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se> <1457044050-15230-19-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-19-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Here's a fixup for a problem found by the test robot. Sorry for the
inconvenience.

Cheers,
Peter

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 40a4e0397826..b73c42eddca3 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -226,6 +226,7 @@ struct i2c_adapter *i2c_root_adapter(struct device *dev)
 
 	return i2c_root;
 }
+EXPORT_SYMBOL_GPL(i2c_root_adapter);
 
 int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters)
 {
-- 
2.1.4


