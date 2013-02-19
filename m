Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16849 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab3BSMAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 07:00:40 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MIG00G0BUNBNU70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Feb 2013 12:00:38 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MIG00I7PUOUPT60@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Feb 2013 12:00:38 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 0/2] max77693-led driver
Date: Tue, 19 Feb 2013 13:00:19 +0100
Message-id: <1361275221-6595-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two patches adds max77693-led driver with device tree support.
Driver is exposed to user space as a V4L2 flash subdevice.
This subdevice should be registered by V4L2 driver of the camera device.

Regards
Andrzej

