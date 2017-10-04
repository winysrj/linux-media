Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:4740 "EHLO
        mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751891AbdJDJGW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 05:06:22 -0400
Date: Wed, 4 Oct 2017 11:06:18 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Todor Tomov <todor.tomov@linaro.org>
cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hansverk@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] ov5645: I2C address change (fwd)
Message-ID: <alpine.DEB.2.20.1710041103510.3139@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

It seems that an unlock is missing on line 764.

julia

---------- Forwarded message ----------
Date: Wed, 4 Oct 2017 05:59:09 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] [media] ov5645: I2C address change

CC: kbuild-all@01.org
In-Reply-To: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org>
TO: Todor Tomov <todor.tomov@linaro.org>
CC: mchehab@kernel.org, sakari.ailus@linux.intel.com, hansverk@cisco.com, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>

Hi Todor,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.14-rc3 next-20170929]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Todor-Tomov/ov5645-I2C-address-change/20171003-234231
base:   git://linuxtv.org/media_tree.git master
:::::: branch date: 6 hours ago
:::::: commit date: 6 hours ago

>> drivers/media/i2c/ov5645.c:806:1-7: preceding lock on line 760

# https://github.com/0day-ci/linux/commit/c222075023642217170e2ef95f48efef079f9bcd
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout c222075023642217170e2ef95f48efef079f9bcd
vim +806 drivers/media/i2c/ov5645.c

9cae9722 Todor Tomov 2017-04-11  747
9cae9722 Todor Tomov 2017-04-11  748  static int ov5645_s_power(struct v4l2_subdev *sd, int on)
9cae9722 Todor Tomov 2017-04-11  749  {
9cae9722 Todor Tomov 2017-04-11  750  	struct ov5645 *ov5645 = to_ov5645(sd);
9cae9722 Todor Tomov 2017-04-11  751  	int ret = 0;
9cae9722 Todor Tomov 2017-04-11  752
9cae9722 Todor Tomov 2017-04-11  753  	mutex_lock(&ov5645->power_lock);
9cae9722 Todor Tomov 2017-04-11  754
9cae9722 Todor Tomov 2017-04-11  755  	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
9cae9722 Todor Tomov 2017-04-11  756  	 * update the power state.
9cae9722 Todor Tomov 2017-04-11  757  	 */
9cae9722 Todor Tomov 2017-04-11  758  	if (ov5645->power_count == !on) {
9cae9722 Todor Tomov 2017-04-11  759  		if (on) {
c2220750 Todor Tomov 2017-10-02 @760  			mutex_lock(&ov5645_lock);
c2220750 Todor Tomov 2017-10-02  761
9cae9722 Todor Tomov 2017-04-11  762  			ret = ov5645_set_power_on(ov5645);
9cae9722 Todor Tomov 2017-04-11  763  			if (ret < 0)
9cae9722 Todor Tomov 2017-04-11  764  				goto exit;
9cae9722 Todor Tomov 2017-04-11  765
c2220750 Todor Tomov 2017-10-02  766  			ret = ov5645_write_reg_to(ov5645, 0x3100,
c2220750 Todor Tomov 2017-10-02  767  						ov5645->i2c_client->addr, 0x78);
c2220750 Todor Tomov 2017-10-02  768  			if (ret < 0) {
c2220750 Todor Tomov 2017-10-02  769  				dev_err(ov5645->dev,
c2220750 Todor Tomov 2017-10-02  770  					"could not change i2c address\n");
c2220750 Todor Tomov 2017-10-02  771  				ov5645_set_power_off(ov5645);
c2220750 Todor Tomov 2017-10-02  772  				mutex_unlock(&ov5645_lock);
c2220750 Todor Tomov 2017-10-02  773  				goto exit;
c2220750 Todor Tomov 2017-10-02  774  			}
c2220750 Todor Tomov 2017-10-02  775
c2220750 Todor Tomov 2017-10-02  776  			mutex_unlock(&ov5645_lock);
c2220750 Todor Tomov 2017-10-02  777
9cae9722 Todor Tomov 2017-04-11  778  			ret = ov5645_set_register_array(ov5645,
9cae9722 Todor Tomov 2017-04-11  779  					ov5645_global_init_setting,
9cae9722 Todor Tomov 2017-04-11  780  					ARRAY_SIZE(ov5645_global_init_setting));
9cae9722 Todor Tomov 2017-04-11  781  			if (ret < 0) {
9cae9722 Todor Tomov 2017-04-11  782  				dev_err(ov5645->dev,
9cae9722 Todor Tomov 2017-04-11  783  					"could not set init registers\n");
9cae9722 Todor Tomov 2017-04-11  784  				ov5645_set_power_off(ov5645);
9cae9722 Todor Tomov 2017-04-11  785  				goto exit;
9cae9722 Todor Tomov 2017-04-11  786  			}
9cae9722 Todor Tomov 2017-04-11  787
9cae9722 Todor Tomov 2017-04-11  788  			ret = ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
9cae9722 Todor Tomov 2017-04-11  789  					       OV5645_SYSTEM_CTRL0_STOP);
9cae9722 Todor Tomov 2017-04-11  790  			if (ret < 0) {
9cae9722 Todor Tomov 2017-04-11  791  				ov5645_set_power_off(ov5645);
9cae9722 Todor Tomov 2017-04-11  792  				goto exit;
9cae9722 Todor Tomov 2017-04-11  793  			}
9cae9722 Todor Tomov 2017-04-11  794  		} else {
9cae9722 Todor Tomov 2017-04-11  795  			ov5645_set_power_off(ov5645);
9cae9722 Todor Tomov 2017-04-11  796  		}
9cae9722 Todor Tomov 2017-04-11  797  	}
9cae9722 Todor Tomov 2017-04-11  798
9cae9722 Todor Tomov 2017-04-11  799  	/* Update the power count. */
9cae9722 Todor Tomov 2017-04-11  800  	ov5645->power_count += on ? 1 : -1;
9cae9722 Todor Tomov 2017-04-11  801  	WARN_ON(ov5645->power_count < 0);
9cae9722 Todor Tomov 2017-04-11  802
9cae9722 Todor Tomov 2017-04-11  803  exit:
9cae9722 Todor Tomov 2017-04-11  804  	mutex_unlock(&ov5645->power_lock);
9cae9722 Todor Tomov 2017-04-11  805
9cae9722 Todor Tomov 2017-04-11 @806  	return ret;
9cae9722 Todor Tomov 2017-04-11  807  }
9cae9722 Todor Tomov 2017-04-11  808

:::::: The code at line 806 was first introduced by commit
:::::: 9cae97221aabfb3ca5daaa424a66c9d8eee1ff59 [media] media: Add a driver for the ov5645 camera sensor

:::::: TO: Todor Tomov <todor.tomov@linaro.org>
:::::: CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
