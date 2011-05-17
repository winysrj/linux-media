Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:41502 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab1EQPN0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 11:13:26 -0400
Message-ID: <4DD29088.1060703@maxwell.research.nokia.com>
Date: Tue, 17 May 2011 18:13:12 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: [RFC v2 0/3] V4L2 API for flash devices and the adp1653 flash controller
 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,


This patchset implements RFC v4 of V4L2 API for flash devices [1], with
minor modifications, and adds the adp1653 flash controller driver. There
have been changes since v1 [2] of this patchset:


- Faults on the flash LED are allowed to make the LED unusable before
the faults are read. This is implemented in the adp1653 driver.

- Intensities are using standard units; mA for flash / torch and uA for
the indicator.


Thanks to those who have given their feedback so far in the process!


[1] http://www.spinics.net/lists/linux-media/msg32030.html

[2] http://www.spinics.net/lists/linux-media/msg32396.html

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
