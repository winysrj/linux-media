Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21318 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1DKJHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 05:07:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 11 Apr 2011 11:07:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/4] s5p-fimc driver fixes for 2.6.39
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1302512865-20379-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

the following are a few bugfix patches for s5p-fimc driver. After recent rename
of the s5pv310 SoC series to Exynos4 it is necessary to change the variant name
in the driver, what the first patch does. The second patch corrects the S_FMT
ioctl handler to forbid the format change as soon as buffers were allocated.
The changset also correct the bytesperline and plane buffer size which were 
incorrect in case of the multi-planar formats. Finally it adds buffer timestamp
and the sequence support in the camera capture driver.

The change set contains:

[PATCH 1/4] s5p-fimc: Fix FIMC3 pixel limits on Exynos4
[PATCH 2/4] s5p-fimc: Do not allow changing format after REQBUFS
[PATCH 3/4] s5p-fimc: Fix bytesperline and plane payload setup
[PATCH 4/4] s5p-fimc: Add support for the buffer timestamps and sequence

--
Regards,

Sylwester Nawrocki
Samsung Poland R&D Center





