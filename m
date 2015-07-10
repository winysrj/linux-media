Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61943 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbGJGee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:34:34 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>, linux-iio@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] Drop owner assignment from i2c_driver (and platform left-overs)
Date: Fri, 10 Jul 2015 15:34:25 +0900
Message-id: <1436510068-5284-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


The i2c drivers also do not have to set 'owner' field because
i2c_register_driver() will do it instead.

'owner' is removed from i2c drivers, which I was able to compile
with allyesconfig (arm, arm64, i386, x86_64, ppc64).
Only compile-tested.

The coccinelle script which generated the patch was sent here:
http://www.spinics.net/lists/kernel/msg2029903.html


Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  staging: iio: Drop owner assignment from i2c_driver
  staging: media: Drop owner assignment from i2c_driver
  staging: Drop owner assignment from i2c_driver

 drivers/staging/iio/addac/adt7316-i2c.c       | 1 -
 drivers/staging/iio/light/isl29018.c          | 1 -
 drivers/staging/iio/light/isl29028.c          | 1 -
 drivers/staging/media/lirc/lirc_zilog.c       | 1 -
 drivers/staging/media/mn88472/mn88472.c       | 1 -
 drivers/staging/media/mn88473/mn88473.c       | 1 -
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c | 1 -
 7 files changed, 7 deletions(-)

-- 
1.9.1

