Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8848 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbcCDF7l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 00:59:41 -0500
Date: Fri, 4 Mar 2016 13:58:50 +0800
From: kbuild test robot <lkp@intel.com>
To: Peter Rosin <peda@lysator.liu.se>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Peter Rosin <peda@axentia.se>,
	Wolfram Sang <wsa@the-dreams.de>,
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
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v4 16/18] i2c: allow adapter drivers to override the
 adapter locking
Message-ID: <201603041340.JOBeKIBG%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1457044050-15230-17-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Peter,

[auto build test WARNING on v4.5-rc6]
[cannot apply to wsa/i2c/for-next sailus-media/master next-20160303]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Peter-Rosin/i2c-mux-cleanup-and-locking-update/20160304-112229
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/linux/init.h:1: warning: no structured comments found
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   drivers/dma-buf/reservation.c:1: warning: no structured comments found
   include/linux/reservation.h:1: warning: no structured comments found
   include/linux/spi/spi.h:540: warning: No description found for parameter 'max_transfer_size'
>> drivers/i2c/i2c-core.c:966: warning: No description found for parameter 'flags'
   drivers/i2c/i2c-core.c:980: warning: No description found for parameter 'flags'
   drivers/i2c/i2c-core.c:994: warning: No description found for parameter 'flags'

vim +/flags +966 drivers/i2c/i2c-core.c

0826374b Michael Lawnick 2010-08-11  950  
97cc4d49 Jean Delvare    2010-10-24  951  	if (parent)
97cc4d49 Jean Delvare    2010-10-24  952  		result = i2c_check_mux_parents(parent, addr);
0826374b Michael Lawnick 2010-08-11  953  
0826374b Michael Lawnick 2010-08-11  954  	if (!result)
0826374b Michael Lawnick 2010-08-11  955  		result = device_for_each_child(&adapter->dev, &addr,
0826374b Michael Lawnick 2010-08-11  956  						i2c_check_mux_children);
0826374b Michael Lawnick 2010-08-11  957  
0826374b Michael Lawnick 2010-08-11  958  	return result;
3b5f794b Jean Delvare    2010-06-03  959  }
3b5f794b Jean Delvare    2010-06-03  960  
9c1600ed David Brownell  2007-05-01  961  /**
7adc3913 Peter Rosin     2016-03-03  962   * i2c_adapter_lock_bus - Get exclusive access to an I2C bus segment
fe61e07e Jean Delvare    2010-08-11  963   * @adapter: Target I2C bus segment
fe61e07e Jean Delvare    2010-08-11  964   */
7adc3913 Peter Rosin     2016-03-03  965  static void i2c_adapter_lock_bus(struct i2c_adapter *adapter, int flags)
fe61e07e Jean Delvare    2010-08-11 @966  {
97cc4d49 Jean Delvare    2010-10-24  967  	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
97cc4d49 Jean Delvare    2010-10-24  968  
97cc4d49 Jean Delvare    2010-10-24  969  	if (parent)
97cc4d49 Jean Delvare    2010-10-24  970  		i2c_lock_adapter(parent);
0826374b Michael Lawnick 2010-08-11  971  	else
fe61e07e Jean Delvare    2010-08-11  972  		rt_mutex_lock(&adapter->bus_lock);
fe61e07e Jean Delvare    2010-08-11  973  }
fe61e07e Jean Delvare    2010-08-11  974  

:::::: The code at line 966 was first introduced by commit
:::::: fe61e07e9ebc890c70d97a1f72ddaad4bee2d848 i2c: Move adapter locking helpers to i2c-core

:::::: TO: Jean Delvare <khali@linux-fr.org>
:::::: CC: Jean Delvare <khali@linux-fr.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--3V7upXqbjpZ4EhLz
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
WuGVKd5MHLIQ/Ad8/CQXUVgAAA==

--3V7upXqbjpZ4EhLz--
