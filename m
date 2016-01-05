Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:45854 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbcAETQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 14:16:29 -0500
Message-ID: <568C1683.3080108@lysator.liu.se>
Date: Tue, 05 Jan 2016 20:16:19 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: kbuild test robot <lkp@intel.com>
CC: kbuild-all@01.org, Wolfram Sang <wsa@the-dreams.de>,
	Peter Rosin <peda@axentia.se>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Adriana Reus <adriana.reus@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>, linux-i2c@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/8] i2c-mux: move the slave side adapter management
 to i2c_mux_core
References: <201601060037.nR1VtA8Y%fengguang.wu@intel.com>
In-Reply-To: <201601060037.nR1VtA8Y%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This should fix it (I'm not sending a v3 right away).

Cheers,
Peter

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
index 1c982a56acd5..5de993deca7e 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
@@ -16,6 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/i2c-mux.h>
 #include <linux/dmi.h>
 #include <linux/acpi.h>
 #include "inv_mpu_iio.h"
@@ -182,7 +183,7 @@ int inv_mpu_acpi_create_mux_client(struct inv_mpu6050_state *st)
 			} else
 				return 0; /* no secondary addr, which is OK */
 		}
-		st->mux_client = i2c_new_device(st->mux_adapter, &info);
+		st->mux_client = i2c_new_device(st->muxc->adapter[0], &info);
 		if (!st->mux_client)
 			return -ENODEV;
 
-- 


On 2016-01-05 17:49, kbuild test robot wrote:
> Hi Peter,
> 
> [auto build test ERROR on wsa/i2c/for-next]
> [also build test ERROR on v4.4-rc8 next-20160105]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Peter-Rosin/i2c-mux-cleanup-and-locking-update/20160106-000205
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux i2c/for-next
> config: i386-randconfig-s1-201601 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c: In function 'inv_mpu_acpi_create_mux_client':
>>> drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c:185:37: error: 'struct inv_mpu6050_state' has no member named 'mux_adapter'
>       st->mux_client = i2c_new_device(st->mux_adapter, &info);
>                                         ^
> 
> vim +185 drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
> 
> a35c5d1a Srinivas Pandruvada 2015-01-30  179  					*name = '\0';
> a35c5d1a Srinivas Pandruvada 2015-01-30  180  				strlcat(info.type, "-client",
> a35c5d1a Srinivas Pandruvada 2015-01-30  181  					sizeof(info.type));
> a35c5d1a Srinivas Pandruvada 2015-01-30  182  			} else
> a35c5d1a Srinivas Pandruvada 2015-01-30  183  				return 0; /* no secondary addr, which is OK */
> a35c5d1a Srinivas Pandruvada 2015-01-30  184  		}
> a35c5d1a Srinivas Pandruvada 2015-01-30 @185  		st->mux_client = i2c_new_device(st->mux_adapter, &info);
> a35c5d1a Srinivas Pandruvada 2015-01-30  186  		if (!st->mux_client)
> a35c5d1a Srinivas Pandruvada 2015-01-30  187  			return -ENODEV;
> a35c5d1a Srinivas Pandruvada 2015-01-30  188  
> 
> :::::: The code at line 185 was first introduced by commit
> :::::: a35c5d1aa96aa6cc70e91786cbe9be4db23f8f4a iio: imu: inv_mpu6050: Create mux clients for ACPI
> 
> :::::: TO: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> :::::: CC: Jonathan Cameron <jic23@kernel.org>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
