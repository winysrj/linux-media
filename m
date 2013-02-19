Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18630 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3BSPgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 10:36:52 -0500
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 0/2] max77693-led driver
Date: Tue, 19 Feb 2013 16:36:15 +0100
Message-id: <1361288177-14452-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two patches add max77693-led driver with device tree support.
Driver is exposed to user space as a V4L2 flash subdevice.
This subdevice should be registered by V4L2 driver of the camera device.

Changes for v2 are described in patch 2/2, thanks for review to Sylwester.
Additionally I have inserted missing description of the patch 1/2.
I have also added e-mail recipients according to MAINTENANCE file.

Regards
Andrzej



