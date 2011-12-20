Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:16937 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1LTU2E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 15:28:04 -0500
Message-ID: <4EF0EFC9.6080501@maxwell.research.nokia.com>
Date: Tue, 20 Dec 2011 22:27:53 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>
Subject: [RFC 0/17] V4L2 subdev and sensor control changes, SMIA++ driver
 and N9 camera board code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This patchset contains new versions of a couple of previous patchsets
I've sent to the list recently. There are mostly minor changes to many
existing patches based on the comments I've got so far, so I'm resending
them. The list is here:

- Integer menu controls [2],
- Selection IOCTL for subdevs [3],
- Sensor control changes [5],
- validate_pipeline() V4L2 subdev pad op,
- OMAP 3 ISP driver improvements [4],
- SMIA++ sensor driver and
- rm680/rm696 board code (a.k.a Nokia N9 and N950)

More detailed information can be found in the references. I'm still
sending the set as RFC since it contains many patches which I would like
to get more comments on, especially the changes related to V4L2.

This patchset depends on Aaro Koskinen's N9 patchset [1] to actually
function at least on the N9. That, to my understanding, is on its way to
mainline.


Comments and questions are very, very welcome.


References:

[1] http://www.spinics.net/lists/linux-omap/msg61295.html

[2] http://www.spinics.net/lists/linux-media/msg40796.html

[3] http://www.spinics.net/lists/linux-media/msg41503.html

[4] http://www.spinics.net/lists/linux-media/msg41542.html

[5] http://www.spinics.net/lists/linux-media/msg40861.html


Kind regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
