Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64596 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2KWPW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 10:22:59 -0500
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDY00LGC5EOZC70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 15:23:12 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDY003BI5DXCUB0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 15:22:57 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 0/3] s5c73m3 camera sensor driver
Date: Fri, 23 Nov 2012 16:22:27 +0100
Message-id: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds V4L2 driver for S5C73M3 camera sensor.

This is I2C driver with SPI bus used for firmware upload.

Driver exposes two sub-devices:
- pure sensor with two source pads (ISP, JPEG),
- output-interface pad with two sink sensors (ISP, JPEG) and one
source pad.
ISP and JPEG pads are connected by immutable links.
Two pads allow support for custom camera format V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8
in which each frame contains two images in UYVY and JPEG format.
Size of each image can be configured independently using pads.

Regards
Andrzej


