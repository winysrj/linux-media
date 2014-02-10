Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1417 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaBJIrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 03:47:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com
Subject: [REVIEWv2 PATCH 00/34] Add support for complex controls, use in solo/go7007
Date: Mon, 10 Feb 2014 09:46:25 +0100
Message-Id: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for complex controls (aka 'Properties') to
the control framework and uses them in the go7007 and solo6x10 drivers.
It is the first part of a larger patch series that adds support for configuration
stores and support for 'Multiple Selections'.

This patch series is based on this RFCv3:

http://lwn.net/Articles/582694/

and this earlier REVIEW patch series:

http://www.spinics.net/lists/linux-media/msg72188.html

Changes since this last REVIEW series are:

- add a patch to fix a pre-existing bug in the handling of the return code
  of copy_to/from_user.

- Tested motion detection for the go7007 and solo6x10 drivers (was on my TODO list)
  and as a result added a patch for the DMA handling when DMA-ing the motion detection
  matrix (was DMAed from stack) and made some minor changes in the solo and go7007
  patches (in both drivers the Motion Detection Mode control wasn't setup correctly
  and in go7007 there was no motion detection event sent when there was no more
  motion).

If there are no more objections, then I am going to make a pull request for this
in one week time.

Regards,

	Hans

