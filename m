Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52321 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0I2KXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 06:23:54 -0400
Date: Wed, 29 Sep 2010 12:23:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2] Add support for camera capture in s5p-fimc driver
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infraded.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1285755828-7815-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

The following is a second version of patches adding camera capture 
capability to the s5p-fimc driver, ready for review. The driver 
uses videobuf however it is meant as a first step to vb2 based 
implementation.

The host interface driver has been tested on Samsung Aquila and GONI
boards (S5PC110) with SR030PC30 (VGA) and NOON010PC30 (CIF) image sensors.
I am working on common driver for these image sensors so the patches
providing support for them might be available soon.


Changes since v1:

- entirely removed plat-samsung/include/plat/fimc.h header so there is no
 platform code dependency

- improved s/try_fmt ioctl and introduced more common ioctl handlers
 (enum/try/g_fmt, g_crop, cropcap) rather than having them separate 
 for mem2mem and capture node

- register definition changes merged with previous commit   
 [3/8] v4l: s5p-fimc: Register definition cleanup


The patch series contains:

[PATCH v2 1/4] V4L/DVB: s5p-fimc: Register definition cleanup
[PATCH v2 2/4] V4L/DVB: s5p-fimc: M2M driver cleanup and minor improvements
[PATCH v2 3/4] V4L/DVB: s5p-fimc: Do not lock both capture and output buffer queue in s_fmt
[PATCH v2 4/4] V4L/DVB: s5p-fimc: Add camera capture support

It has been prepared in assumption that the following patches,
posted by Marek Szyprowski, were applied:

v4l: s5p-fimc: Fix 3-planar formats handling and pixel
offset error on S5PV210 SoCs
v4l: s5p-fimc: Fix return value on probe() failure

For easier review the commits will be also available in few hours
in git repository at:

http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/v4l/s5p-fimc-capture-for-2.6.37

Regards,
Sylwester

--
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center
