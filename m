Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32678 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaIDUY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 16:24:27 -0400
Date: Thu, 4 Sep 2014 23:24:18 +0300
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org, Hans Verkuil <hans.verkuil@cisco.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:devel 360/499]
 drivers/media/platform/vivid/vivid-radio-rx.c:198
 vivid_radio_rx_s_hw_freq_seek() error: buffer overflow 'vivid_radio_bands' 3
 <= 3
Message-ID: <20140904202418.GR6549@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

First bad commit (maybe != root cause):

tree:   git://linuxtv.org/media_tree.git devel
head:   160416682519b8b63693a47a13460384a2656dad
commit: e75420dd25bc9d7b6f4e3b4c4f6c778b610c8cda [360/499] [media] vivid: enable the vivid driver

drivers/media/platform/vivid/vivid-radio-rx.c:198 vivid_radio_rx_s_hw_freq_seek() error: buffer overflow 'vivid_radio_bands' 3 <= 3
drivers/media/platform/vivid/vivid-radio-rx.c:199 vivid_radio_rx_s_hw_freq_seek() error: buffer overflow 'vivid_radio_bands' 3 <= 3
drivers/media/platform/vivid/vivid-rds-gen.c:81 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 43
drivers/media/platform/vivid/vivid-rds-gen.c:82 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 42
drivers/media/platform/vivid/vivid-rds-gen.c:88 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 84
drivers/media/platform/vivid/vivid-rds-gen.c:89 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 85
drivers/media/platform/vivid/vivid-rds-gen.c:91 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 86
drivers/media/platform/vivid/vivid-rds-gen.c:92 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 87

git remote add linuxtv-media git://linuxtv.org/media_tree.git
git remote update linuxtv-media
git checkout e75420dd25bc9d7b6f4e3b4c4f6c778b610c8cda
vim +/vivid_radio_bands +198 drivers/media/platform/vivid/vivid-radio-rx.c

55d58e98 Hans Verkuil 2014-08-25  192  		high = a->rangehigh;
55d58e98 Hans Verkuil 2014-08-25  193  	} else {
55d58e98 Hans Verkuil 2014-08-25  194  		for (band = 0; band < TOT_BANDS; band++)
55d58e98 Hans Verkuil 2014-08-25  195  			if (dev->radio_rx_freq >= vivid_radio_bands[band].rangelow &&
55d58e98 Hans Verkuil 2014-08-25  196  			    dev->radio_rx_freq <= vivid_radio_bands[band].rangehigh)
55d58e98 Hans Verkuil 2014-08-25  197  				break;
55d58e98 Hans Verkuil 2014-08-25  198  		low = vivid_radio_bands[band].rangelow;
55d58e98 Hans Verkuil 2014-08-25  199  		high = vivid_radio_bands[band].rangehigh;
55d58e98 Hans Verkuil 2014-08-25  200  	}
55d58e98 Hans Verkuil 2014-08-25  201  	spacing = band == BAND_AM ? 1600 : 16000;
55d58e98 Hans Verkuil 2014-08-25  202  	freq = clamp(dev->radio_rx_freq, low, high);

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
