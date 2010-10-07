Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29135 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0JGOoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 10:44:09 -0400
Date: Thu, 07 Oct 2010 16:43:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 0/4] Add support for camera capture in s5p-fimc driver
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1286462642-28211-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

Here is a third version of patches adding camera capture capability
to the s5p-fimc driver. I didn't receive any comments on v2 but I tracked
a few issues myself and made little additions. I hope to get these patches
merged in current form unless any objections appear.

The driver has been tested on Samsung Aquila and GONI boards (S5PC110) 
with SR030PC30 (VGA) and NOON010PC30 (CIF) image sensors.

Changes since v1:
- entirely removed plat-samsung/include/plat/fimc.h header so there is no
 platform code dependency

- improved s/try_fmt ioctl and introduced common ioctl handlers for mem2mem 
  and capture node where it's reasonable

- register definition changes merged with previous commit   
 [3/8] v4l: s5p-fimc: Register definition cleanup

Changes since v2:
	- improved s/g/crop(cap) handling in capture node
	- added passing of v4l control to the sensor subdevice

The patch series contains:

[PATCH 1/4] V4L/DVB: s5p-fimc: Register definition cleanup
[PATCH 2/4] V4L/DVB: s5p-fimc: M2M driver cleanup and minor improvements
[PATCH 3/4] V4L/DVB: s5p-fimc: Do not lock both capture and output buffer queue in s_fmt
[PATCH 4/4] V4L/DVB: s5p-fimc: Add camera capture support

It has been rebased onto linuxtv/staging-2.6.37 branch at
git://linuxtv.org/media_tree.git with 2 bugfix patches:

v4l: s5p-fimc: Fix 3-planar formats handling and pixel offset error on S5PV210 SoCs
v4l: s5p-fimc: Fix return value on probe() failure

also applied.

Cheers,
Sylwester

--
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center


