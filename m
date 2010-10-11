Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34262 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0JKR0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 13:26:39 -0400
Date: Mon, 11 Oct 2010 19:26:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 0/6] Add support for camera capture in s5p-fimc driver
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

this is a fifth version of patches adding camera capture capability
to the s5p-fimc driver. It incorporates minor fixes that I tracked
just after sending v4, my apologies for spaming the list..
Hopefully that is the last version to be merged.


Changes since v1:
- entirely removed plat-samsung/include/plat/fimc.h header so there is no
 platform code dependency
- improved s/try_fmt ioctl and introduced common ioctl handlers for mem2mem 
  and capture node where it's reasonable
- register definition changes merged with previous commit   
 [3/8] v4l: s5p-fimc: Register definition cleanup

Changes since v2:
- improved s/g/crop(cap) handling in capture node
- added passing of v4l controls to the sensor subdevice

Changes since v3:
- changed summary of patch [4/4] to adhere to patch submitting guidelines
- patch "V4L/DVB: s5p-fimc: M2M driver cleanup.." split to 2 separate
 commits - 2/5 and 3/5 in this series

Changes since v4:
- fixed passing control to the subdev, removed silly use of check_stream_type()
- add support for FIMC on S5PC210 (S5PV310) SoCs

The patch series contains:
[PATCH 1/6 v5] V4L/DVB: s5p-fimc: Register definition cleanup
[PATCH 2/6 v5] V4L/DVB: s5p-fimc: mem2mem driver refactoring and cleanup
[PATCH 3/6 v5] V4L/DVB: s5p-fimc: Fix 90/270 deg rotation errors
[PATCH 4/6 v5] V4L/DVB: s5p-fimc: Do not lock both buffer queues in s_fmt
[PATCH 5/6 v5] V4L/DVB: s5p-fimc: Add camera capture support
[PATCH 6/6 v5] V4L/DVB: s5p-fimc: Add suport for FIMC on S5PC210 SoCs


It has been rebased onto linuxtv/staging-2.6.37 branch at
git://linuxtv.org/media_tree.git with the below 2 bugfix patches already present 
in 2.6.36 also applied:

v4l: s5p-fimc: Fix 3-planar formats handling and pixel offset error on S5PV210 SoCs
v4l: s5p-fimc: Fix return value on probe() failure

Regards,
Sylwester


--
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center




