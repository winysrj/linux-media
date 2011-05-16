Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:50693 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1EPNAj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 09:00:39 -0400
Message-ID: <4DD11FEC.8050308@maxwell.research.nokia.com>
Date: Mon, 16 May 2011 16:00:28 +0300
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
Subject: [RFC 0/3] V4L2 API for flash devices and the adp1653 flash controller
 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

This is a patchset which implements RFC v4 of V4L2 API for flash devices
[1], with minor modifications, and adds the adp1653 flash controller driver.

What was changed was that the V4L2_CID_FLASH_STROBE_MODE control was
renamed to V4L2_CID_FLASH_STROBE_SOURCE. Also the related enum has been
renamed correspondingly.

Laurent: I didn't add the text from the RFC to the flash controls
documentation since I'm inclined to think it doesn't actually belong
there. Much of it is suggesting what could be done in future or defining
the scope of the interface. Both are mostly related to further
development activities. That said, there definitely is important
information in the RFC although much of it isn't directly related to the
flash controls. If we want to add (some of) that to the V4L2
documentation, where should it be put?

[1] http://www.spinics.net/lists/linux-media/msg32030.html

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
